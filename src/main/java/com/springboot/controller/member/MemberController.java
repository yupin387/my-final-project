package com.springboot.controller.member;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.model.BookingForm;
import com.springboot.model.Ceremony;
import com.springboot.model.Item;
import com.springboot.model.Member;
import com.springboot.model.Quotation;
import com.springboot.model.QuotationDetail;
import com.springboot.service.CeremonyService;
import com.springboot.service.MemberService;
import com.springboot.service.QuotationService;

import jakarta.servlet.http.HttpSession;


@Controller
public class MemberController {
    
    @Autowired
    private MemberService memberService;
    
    @Autowired
    private QuotationService quotationService;
    
    @Autowired
    private CeremonyService ceremonyService;

    // แผนที่ (Map) สำหรับจับคู่ "ประเภทพิธี" กับ "รูปภาพประกอบ" ที่จะใช้แสดงในหน้าเว็บ
    private static final Map<String, String> TYPE_IMAGE_MAP = new LinkedHashMap<>();
    static {
        TYPE_IMAGE_MAP.put("ทำบุญบ้าน", "ceremony1.webp");
        TYPE_IMAGE_MAP.put("ขึ้นบ้านใหม่", "img11.jpg");
        TYPE_IMAGE_MAP.put("ทำบุญบริษัทหรือออฟฟิศ", "img12.jpg");
    }

    private static final String DEFAULT_TYPE_IMAGE = "ceremony1.webp";

    // แสดงหน้าล็อกอินสำหรับสมาชิก
    @GetMapping("/loginMember")
    public String loginPage() {
        return "loginMember";
    }

    // ประมวลผลการล็อกอิน: เช็คอีเมล/รหัสผ่าน ถ้าถูกต้องเก็บข้อมูลผู้ใช้ลง session แล้วพาไปหน้า home
    @PostMapping("/loginMember")
    public String processLogin(@RequestParam("memberemail") String email, 
                               @RequestParam("memberpassword") String password, 
                               HttpSession session, 
                               Model model) {

        Member member = memberService.login(email, password);

        if (member != null) {
            session.setAttribute("user", member);
            return "redirect:/home?loginSuccess=true";
        } else {
            model.addAttribute("errorMsg", "อีเมลหรือรหัสผ่านไม่ถูกต้อง");
            return "loginMember";
        }
    }
    
    // ออกจากระบบ: ล้าง session ทั้งหมดแล้วพากลับหน้า home
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/home";
    }
    
    // แสดงหน้าแก้ไขโปรไฟล์: โหลดข้อมูลสมาชิกล่าสุดจากฐานข้อมูล (กันกรณีข้อมูลใน session เก่า)
    @GetMapping("/editProfile")
    public String editProfilePage(HttpSession session, Model model) {
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return "redirect:/loginMember";
        }
        
        Member latestData = memberService.getMemberById(user.getMemberId());
        if (latestData == null) {
            latestData = user;
        }
        model.addAttribute("member", latestData);
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());
        
        return "editProfile";
    }

    // บันทึกการแก้ไขโปรไฟล์ พร้อมอัปเดตข้อมูลใน session ให้ตรงกับข้อมูลล่าสุด
    @PostMapping("/updateProfile")
    public String updateProfile(@ModelAttribute Member member,
                                @RequestParam(value = "newPassword", required = false) String newPassword,
                                HttpSession session,
                                RedirectAttributes ra) {
        try {
            memberService.updateProfile(member, newPassword);
            session.setAttribute("user", member);
            ra.addFlashAttribute("success", "บันทึกข้อมูลที่เปลี่ยนแปลงแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        return "redirect:/editProfile";
    }

    // ดูใบเสนอราคาล่าสุดของสมาชิกที่ล็อกอินอยู่ (ไม่ต้องระบุ quotationId)
    // ถ้าไม่มีใบเสนอราคาเลย ให้ redirect ไปหน้ารายการจองแทน
    @GetMapping("/member/quotation/list")
    public String showLatestQuotation(HttpSession session, Model model) {
        Member user = (Member) session.getAttribute("user");
        if (user == null) return "redirect:/loginMember";

        Quotation latestQ = quotationService.getLatestQuotationByMemberId(user.getMemberId());

        if (latestQ == null) {
            return "redirect:/myBookings";
        }

        populateQuotationDetailModel(latestQ, model);
        return "memberQuotationDetail";
    }

    // ดูใบเสนอราคาตาม quotationId ที่ระบุ พร้อมเช็คสิทธิ์ว่าเป็นเจ้าของใบเสนอราคาจริงหรือไม่
    @GetMapping("/member/quotation/detail/{quotationId}")
    public String showQuotationDetail(@PathVariable String quotationId, HttpSession session, Model model) {
        Member user = (Member) session.getAttribute("user");
        if (user == null) return "redirect:/loginMember";

        Quotation q = quotationService.getQuotationById(quotationId);
        if (q == null) {
            return "redirect:/myBookings?error=quotationNotFound";
        }

        boolean isOwner = q.getBookingForm() != null
                && q.getBookingForm().getMember() != null
                && q.getBookingForm().getMember().getMemberId() == user.getMemberId();
        if (!isOwner) {
            return "redirect:/myBookings?error=noAccess";
        }

        populateQuotationDetailModel(q, model);
        return "memberQuotationDetail";
    }

    // เมธอดกลางสำหรับเตรียมข้อมูลทั้งหมดที่หน้า memberQuotationDetail ต้องใช้
    // (ตัวใบเสนอราคา, รายละเอียดรายการ, ข้อมูลการจอง, รายการที่รวมอยู่ในแพ็กเกจ)
    private void populateQuotationDetailModel(Quotation q, Model model) {
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());

        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(q.getQuotationId());

        model.addAttribute("q", q);
        model.addAttribute("details", details);

        BookingForm booking = q.getBookingForm();
        if (booking != null) {
            model.addAttribute("b", booking);

            if (booking.getCeremony() != null) {
                int ceremonyId = booking.getCeremony().getCeremonyId();
                List<Item> allItems = quotationService.getItemsByCeremonyId(ceremonyId);
                boolean isCustomRequest = "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getOptionType());

                List<Item> packageIncludedItems = computePackageIncludedItems(allItems, isCustomRequest);
                model.addAttribute("packageIncludedItems", packageIncludedItems);
            }
        }
    }
    
    // สมาชิกกดยืนยันการจองตามใบเสนอราคา: เปลี่ยนสถานะเป็น Confirmed แล้วพากลับหน้า home
    @PostMapping("/member/quotation/confirm")
    public String confirmQuotation(@RequestParam String quotationId, RedirectAttributes ra) {
        try {
            quotationService.confirmQuotation(quotationId);
            ra.addFlashAttribute("success", "ยืนยันใบเสนอราคาเรียบร้อยแล้ว ระบบกำลังเตรียมการมอบหมายงาน");
            return "redirect:/home";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return "redirect:/member/quotation/detail/" + quotationId;
        }
    }
    
    // สมาชิกส่งข้อความแจ้งขอแก้ไขรายการในใบเสนอราคา ให้ผู้จัดการตรวจสอบ
    @PostMapping("/member/quotation/revise-all")
    public String memberReviseAllItems(@RequestParam String quotationId,
                                       @RequestParam(required = false) String memberNote,
                                       RedirectAttributes ra) {
        try {
            quotationService.submitMemberRevision(quotationId, memberNote);
            ra.addFlashAttribute("success", "ส่งรายการแจ้งขอแก้ไขให้ผู้จัดการเรียบร้อยแล้ว");
            return "redirect:/member/quotation/detail/" + quotationId;
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return "redirect:/member/quotation/detail/" + quotationId;
        }
    }

    // คัดกรองว่ารายการ (Item) ใดบ้างที่ "รวมอยู่ในแพ็กเกจ" แล้วโดยอัตโนมัติ
    private List<Item> computePackageIncludedItems(List<Item> allItems, boolean isCustomRequest) {
        List<Item> packageIncludedItems = new ArrayList<>();
        if (!isCustomRequest && allItems != null) {
            for (Item it : allItems) {
                if (it.getItemType() != null) {
                    String typeName = it.getItemType().getItemTypeName();
                    boolean isPackage = "แพ็กเกจ".equals(typeName);
                    boolean isFoodOrSangkathan = "ภัตตาหารปิ่นโต".equals(typeName) || "สังฆทาน".equals(typeName);
                    boolean isOptionalExtra = "อุปกรณ์เสริม (เลือกเพิ่มเอง)".equals(typeName);
                    
                    if (!isPackage && !isFoodOrSangkathan && !isOptionalExtra) {
                        packageIncludedItems.add(it);
                    }
                }
            }
        }
        return packageIncludedItems;
    }

    // จัดกลุ่มพิธีทั้งหมดตาม "ประเภทพิธี" (ceremonyType) แล้วเลือกแพ็กเกจราคาถูกสุดในแต่ละกลุ่มมาเป็นตัวแทน
    private List<Map<String, Object>> buildCeremonyTypes() {
        List<Ceremony> ceremonies = ceremonyService.getAllCeremonies();

        Map<String, List<Ceremony>> grouped = ceremonies.stream()
            .collect(Collectors.groupingBy(
                c -> c.getCeremonyType() == null ? "" : c.getCeremonyType().trim(),
                LinkedHashMap::new,
                Collectors.toList()
            ));

        List<Map<String, Object>> ceremonyTypes = new ArrayList<>();
        for (Map.Entry<String, List<Ceremony>> entry : grouped.entrySet()) {
            List<Ceremony> packages = entry.getValue();
            packages.sort(Comparator.comparingDouble(Ceremony::getBasePrice));
            Ceremony representative = packages.get(0);

            String mainName = entry.getKey();
            String image = TYPE_IMAGE_MAP.getOrDefault(mainName, DEFAULT_TYPE_IMAGE);

            Map<String, Object> typeMap = new LinkedHashMap<>();
            typeMap.put("mainName", mainName);
            typeMap.put("representativeId", representative.getCeremonyId());
            typeMap.put("image", image);
            typeMap.put("priceFrom", packages.get(0).getBasePrice());
            typeMap.put("packageCount", packages.size());
            ceremonyTypes.add(typeMap);
        }
        return ceremonyTypes;
    }
    
    // สมัครสมาชิกใหม่: เช็คอีเมลซ้ำก่อน ถ้าไม่ซ้ำถึงจะสร้างสมาชิกใหม่และบันทึกลงฐานข้อมูล
    @PostMapping("/saveMember")
    public String saveMember(@RequestParam("memberFirstName") String firstName,
                             @RequestParam("memberLastName") String lastName,
                             @RequestParam("phoneNumber") String phone,
                             @RequestParam("memberEmail") String email,
                             @RequestParam("memberPassword") String password,
                             Model model) {
        
        // 1. เช็คว่ามีอีเมลนี้ในระบบหรือยัง โดยเรียกผ่าน memberService
        boolean isEmailExists = memberService.isEmailTaken(email); 
        
        if (isEmailExists) {
            model.addAttribute("errorMsg", "อีเมลนี้ถูกใช้งานในระบบแล้ว กรุณาใช้อีเมลอื่น");
            return "register"; 
        }
        
        // 2. ถ้าไม่ซ้ำ สร้าง Object สมาชิกใหม่แล้วทำการบันทึกผ่าน Service
        Member member = new Member();
        member.setMemberFirstName(firstName);
        member.setMemberLastName(lastName);
        member.setPhoneNumber(phone);
        member.setMemberEmail(email);
        member.setMemberPassword(password);
        
        memberService.saveMember(member); 
        
        return "redirect:/loginMember";
    }
}