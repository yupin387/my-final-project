package com.springboot.controller.member;
 
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.model.Member;
import com.springboot.model.Quotation;
import com.springboot.model.QuotationDetail;
import com.springboot.service.MemberService;
import com.springboot.service.QuotationService;

import jakarta.servlet.http.HttpSession;
 
@Controller
public class MemberController {
    
    @Autowired
    private MemberService memberService;
    
    @Autowired
    private QuotationService quotationService; 
 
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
        
        // ดึงข้อมูลล่าสุดจาก DB
        Member latestData = memberService.getMemberById(user.getMemberId());
        
        // จุดสำคัญ: ถ้าหาข้อมูลไม่เจอ ให้เอาตัวจาก Session มาโชว์แก้ขัดไปก่อนป้องกันหน้าพัง 
        if (latestData == null) {
            latestData = user;
        }
        
        model.addAttribute("member", latestData);
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

        // 1. หาใบเสนอราคาสุดท้ายของสมาชิกคนนี้
        Quotation latestQ = quotationService.getLatestQuotationByMemberId(user.getMemberId());

        if (latestQ == null) {
            // ถ้าสมาชิกยังไม่มีใบเสนอราคาเลย ให้ส่งไปหน้า "การจองของฉัน" แทน
            return "redirect:/memberQuotationDetail";
        }

        // 2. ถ้าเจอ ให้ดึงรายละเอียดและส่งไปหน้า Detail ที่คุณทำไว้เลย
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(latestQ.getQuotationId());
        
        model.addAttribute("q", latestQ);
        model.addAttribute("details", details);
        
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
}