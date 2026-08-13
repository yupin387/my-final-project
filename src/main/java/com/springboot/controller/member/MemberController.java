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

    // ===== ใช้ mapping รูปภาพแบบเดียวกับ UserController เพื่อความสอดคล้องกัน =====
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
 
  //แก้เมธอทนี้ สำหรับแจ้งเตือน
    @PostMapping("/loginMember")
    public String processLogin(@RequestParam("memberemail") String email, 
                               @RequestParam("memberpassword") String password, 
                               HttpSession session, 
                               Model model) {

        // เปลี่ยนจาก checkLogin เป็น login ให้ตรงกับใน MemberService
        Member member = memberService.login(email, password);

        if (member != null) {
            // ถ้าล็อกอินผ่าน เซ็ต Session
            session.setAttribute("user", member);

            // 🚩 ใส่บรรทัดนี้ เพื่อให้ล็อกอินเสร็จแล้วเด้งไปหน้า home พร้อมป๊อปอัปแจ้งเตือน!
            return "redirect:/home?loginSuccess=true"; 

        } else {
            // ถ้าล็อกอินไม่ผ่าน ให้กลับไปหน้า login พร้อมข้อความแจ้งเตือน
            model.addAttribute("errorMsg", "อีเมลหรือรหัสผ่านไม่ถูกต้อง");
            return "loginMember";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // 1. ล้างข้อมูลใน Session ทิ้งทั้งหมด (ชื่อ, ID, สถานะ จะหายไปทันที)
        session.invalidate();
        
        // 2. ส่งผู้ใช้กลับไปที่หน้า /home
        return "redirect:/home";
    }
    
    @GetMapping("/editProfile")
    public String editProfilePage(HttpSession session, Model model) {
        Member user = (Member) session.getAttribute("user");
        
        if (user == null) {
            return "redirect:/loginMember";
        }
        
        // ข้อมูลล่าสุดจาก DB
        Member latestData = memberService.getMemberById(user.getMemberId());
        
        if (latestData == null) {
            latestData = user;
        }
        model.addAttribute("member", latestData);
        
        // 🚩 เพิ่มบรรทัดนี้เข้าไปตรงนี้ครับ!
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());
        
        return "editProfile";
    }
 
    @PostMapping("/updateProfile")
    public String updateProfile(@ModelAttribute Member member,
                                @RequestParam(value = "newPassword", required = false) String newPassword,
                                HttpSession session) {
        
        memberService.updateProfile(member, newPassword);
        
        // อัปเดตข้อมูลใน Session
        session.setAttribute("user", member);
        
        return "redirect:/home";
    }
    

    @GetMapping("/member/quotation/list") // ลิงก์เดิมจาก Navbar แต่จะเปลี่ยนการทำงานข้างใน
    public String showLatestQuotation(HttpSession session, Model model) {
        Member user = (Member) session.getAttribute("user");
        if (user == null) return "redirect:/loginMember";

        // 🚩 เพิ่มบรรทัดนี้ — ตัวที่หายไป ทำให้ dropdown "บริการ/แพ็กเกจ" ใน navbar ว่างเปล่า
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());

        // 1. หาใบเสนอราคาสุดท้ายของสมาชิกคนนี้
        Quotation latestQ = quotationService.getLatestQuotationByMemberId(user.getMemberId());

        if (latestQ == null) {
            // ถ้าสมาชิกยังไม่มีใบเสนอราคาเลย ให้ส่งไปหน้า "การจองของฉัน" แทน
            return "redirect:/memberQuotationDetail";
        }

        // 2. ถ้าเจอ ให้ดึงรายละเอียดและส่งไปหน้า Detail ที่คุณทำไว้
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(latestQ.getQuotationId());
        
        model.addAttribute("q", latestQ);
        model.addAttribute("details", details);
        
        // 🚩 เพิ่ม Logic คำนวณ packageIncludedItems ให้ตรงกับฝั่ง Organizer
        BookingForm booking = latestQ.getBookingForm();
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
        
        return "memberQuotationDetail"; 
    }
    
    // ใน MemberController.java หรือ Controller ฝั่งสมาชิกของคุณ
    @PostMapping("/member/quotation/confirm")
    public String confirmQuotation(@RequestParam String quotationId, RedirectAttributes ra) {
        try {
            // ✅ เรียกผ่าน Service ตามที่คุณต้องการ
            quotationService.confirmQuotation(quotationId);
            
            ra.addFlashAttribute("success", "ยืนยันใบเสนอราคาเรียบร้อยแล้ว ระบบกำลังเตรียมการมอบหมายงาน");
            return "redirect:/home"; // หรือหน้าที่คุณต้องการให้ไปหลังยืนยัน
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return "redirect:/member/quotation/detail/" + quotationId;
        }
    }
    
    
    @PostMapping("/member/quotation/revise-all")
    public String memberReviseAllItems(@RequestParam String quotationId,
                                       @RequestParam(required = false) List<Integer> itemIds,
                                       @RequestParam(required = false) List<String> memberNotes,
                                       RedirectAttributes ra) {
        try {
            // 1. เรียกใช้ Service เพื่อเซฟโน้ตแจ้งแก้รายรายการ และอัปเดตสถานะเป็น "Revised"
            quotationService.submitMemberRevision(quotationId, itemIds, memberNotes);
            
            ra.addFlashAttribute("success", "ส่งรายการแจ้งขอแก้ไขให้ออแกไนเซอร์เรียบร้อยแล้ว");
            return "redirect:/member/quotation/list"; 
            
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return "redirect:/member/quotation/list";
        }
    }
    
    // ===== Helper คำนวณรายการในแพ็กเกจ (แบบเดียวกับฝั่ง Organizer) =====
    private List<Item> computePackageIncludedItems(List<Item> allItems, boolean isCustomRequest) {
        List<Item> packageIncludedItems = new ArrayList<>();
        if (!isCustomRequest && allItems != null) {
            for (Item it : allItems) {
                if (it.getItemType() != null) {
                    String typeName = it.getItemType().getItemTypeName();
                    boolean isFoodOrSangkathan = "ภัตตาหารปิ่นโต".equals(typeName) || "สังฆทาน".equals(typeName);
                    boolean isBundledInAllPackages = it.getCeremonies() != null && it.getCeremonies().size() >= 9;
                    if (!isFoodOrSangkathan && isBundledInAllPackages) {
                        packageIncludedItems.add(it);
                    }
                }
            }
        }
        return packageIncludedItems;
    }

    // ===== Helper สร้างรายการ ceremonyTypes สำหรับ dropdown "บริการ/แพ็กเกจ" ใน navbar
    //       (โลจิกเดียวกับ UserController#buildCeremonyTypes เพื่อให้ navbar ทุกหน้าตรงกัน) =====
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
    
    //==================
}