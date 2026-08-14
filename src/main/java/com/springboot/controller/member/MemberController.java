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

    private static final Map<String, String> TYPE_IMAGE_MAP = new LinkedHashMap<>();
    static {
        TYPE_IMAGE_MAP.put("ทำบุญบ้าน", "ceremony1.webp");
        TYPE_IMAGE_MAP.put("ขึ้นบ้านใหม่", "img11.jpg");
        TYPE_IMAGE_MAP.put("ทำบุญบริษัทหรือออฟฟิศ", "img12.jpg");
    }
    private static final String DEFAULT_TYPE_IMAGE = "ceremony1.webp";
 
    @GetMapping("/loginMember")
    public String loginPage() {
        return "loginMember";
    }
 
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
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/home";
    }
    
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
 
    @PostMapping("/updateProfile")
    public String updateProfile(@ModelAttribute Member member,
                                @RequestParam(value = "newPassword", required = false) String newPassword,
                                HttpSession session) {
        memberService.updateProfile(member, newPassword);
        session.setAttribute("user", member);
        return "redirect:/home";
    }

    // เดิม: ดึงใบเสนอราคา "ล่าสุด" ของสมาชิกเสมอ ไม่ว่าจะกดจาก booking ไหน
    // ยังคงไว้เผื่อมีที่อื่นเรียกใช้อยู่ (เช่นเมนู/แดชบอร์ดที่อยากโชว์ใบล่าสุด)
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

    // FIX: ใหม่ — endpoint สำหรับดูใบเสนอราคาของ "booking รายการที่เลือกจริงๆ" ตาม quotationId
    // แก้ปัญหาที่ปุ่ม "ใบเสนอราคา" ใน myBookingList.jsp เดิมลิงก์ไปหน้า /viewBooking/{id}#quotationSection
    // ซึ่งเป็นหน้ารายละเอียดการจอง ไม่ใช่หน้าใบเสนอราคา ทำให้กดแล้วไม่เจอใบเสนอราคาจริง
    @GetMapping("/member/quotation/detail/{quotationId}")
    public String showQuotationDetail(@PathVariable String quotationId, HttpSession session, Model model) {
        Member user = (Member) session.getAttribute("user");
        if (user == null) return "redirect:/loginMember";

        Quotation q = quotationService.getQuotationById(quotationId);
        if (q == null) {
            return "redirect:/myBookings?error=quotationNotFound";
        }

        // FIX: กันไม่ให้สมาชิกคนอื่นเดา quotationId แล้วดูใบเสนอราคาของคนอื่นได้
        boolean isOwner = q.getBookingForm() != null
                && q.getBookingForm().getMember() != null
                && q.getBookingForm().getMember().getMemberId() == user.getMemberId();
        if (!isOwner) {
            return "redirect:/myBookings?error=noAccess";
        }

        populateQuotationDetailModel(q, model);
        return "memberQuotationDetail";
    }

    // FIX: ดึง logic ที่ซ้ำกันระหว่าง showLatestQuotation และ showQuotationDetail
    // มารวมไว้ที่เดียว เพื่อไม่ให้ต้องแก้ 2 จุดทุกครั้งที่ปรับ model attribute
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
                boolean isCustomRequest = "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName());

                List<Item> packageIncludedItems = computePackageIncludedItems(allItems, isCustomRequest);
                model.addAttribute("packageIncludedItems", packageIncludedItems);
            }
        }
    }
    
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
    
    @PostMapping("/member/quotation/revise-all")
    public String memberReviseAllItems(@RequestParam String quotationId,
                                       @RequestParam(required = false) String memberNote,
                                       RedirectAttributes ra) {
        try {
            quotationService.submitMemberRevision(quotationId, memberNote);
            ra.addFlashAttribute("success", "ส่งรายการแจ้งขอแก้ไขให้ออแกไนเซอร์เรียบร้อยแล้ว");
            return "redirect:/member/quotation/detail/" + quotationId;
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return "redirect:/member/quotation/detail/" + quotationId;
        }
    }
    // อัปเดตฟังก์ชันนี้เพื่อให้ดึงไอเท็มในแพ็กเกจได้ครบถ้วน เหมือนฝั่ง Organizer
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
}