package com.springboot.controller.headstaff;

import com.springboot.model.BookingForm;
import com.springboot.model.HeadStaff;
import com.springboot.model.StaffAssignment;
import com.springboot.service.BookingService;
import com.springboot.service.HeadStaffService;
import com.springboot.service.StaffAssignmentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class HeadStaffController {

    @Autowired
    private HeadStaffService headStaffService;

    @Autowired
    private StaffAssignmentService staffAssignmentService;
    
    @Autowired
    private BookingService bookingService;

    // ตรวจสอบการเข้าสู่ระบบของหัวหน้างาน (เช็กทั้งรหัสผ่านและสถานะบัญชี)
    @PostMapping("/loginheadstaff")
    public ModelAndView login(@RequestParam String email,
                              @RequestParam String password, 
                              HttpSession session,
                              RedirectAttributes redirectAttrs) {

        HeadStaff staff = headStaffService.login(email, password);

        if (staff == null) {
            redirectAttrs.addFlashAttribute("error", "อีเมล รหัสผ่านไม่ถูกต้อง หรือบัญชีถูกระงับ");
            return new ModelAndView("redirect:/loginorganizer");
        }

        session.setAttribute("currentStaff", staff);
        redirectAttrs.addFlashAttribute("success", "เข้าสู่ระบบสำเร็จ");
        return new ModelAndView("redirect:/staff/assignments");
    }

    // ล้างข้อมูลเซสชันและออกจากระบบสำหรับหัวหน้างาน
    @GetMapping("/headstaff/logout")
    public ModelAndView logoutStaff(HttpSession session, RedirectAttributes redirectAttrs) {
        session.invalidate();
        redirectAttrs.addFlashAttribute("success", "ออกจากระบบเรียบร้อยแล้ว");
        return new ModelAndView("redirect:/loginorganizer");
    }

    // แสดงรายการงานที่ได้รับมอบหมายทั้งหมดของหัวหน้างานที่ล็อกอินอยู่
    @GetMapping("/staff/assignments")
    public String listAssignments(Model model, HttpSession session) {
        HeadStaff currentStaff = (HeadStaff) session.getAttribute("currentStaff");
        if (currentStaff == null) return "redirect:/loginorganizer"; // ✅ เพิ่มกลับ

        List<StaffAssignment> assignments = staffAssignmentService.getAssignmentsByStaff(currentStaff.getStaffId());
        model.addAttribute("assignments", assignments);
        return "staffAssignmentList";
    }
    // แสดงรายละเอียดของงานมอบหมายชิ้นที่เลือก
 // ใน HeadStaffController.java
    @GetMapping("/staff/assignments/detail/{id}")
    public String viewAssignmentDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginorganizer";

        StaffAssignment sa;
        // ตรวจสอบ: ถ้า id ขึ้นต้นด้วย "AN" ให้หาด้วย ID ถ้าไม่ใช่ให้หาด้วย BookingID
        if (id.startsWith("AN")) {
            sa = staffAssignmentService.getAssignmentById(id);
        } else {
            sa = staffAssignmentService.getAssignmentByBookingId(id);
        }
        
        model.addAttribute("a", sa);
        return "staffAssignmentDetail";
    }
    

    // บันทึกรายงานความเสียหายจากการดำเนินงาน (ส่งข้อความและรูปภาพ)
    @PostMapping("/staff/assignments/report-damage/save")
    public String saveReport(@RequestParam String assignId,
                             @RequestParam String reportNote,
                             @RequestParam(value = "imageFile", required = false) MultipartFile file, 
                             RedirectAttributes ra) {
        try {
            staffAssignmentService.updateDamageReport(assignId, reportNote, file);
            ra.addFlashAttribute("success", "ส่งรายงานความเสียหายเรียบร้อยแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถส่งรายงานได้: " + e.getMessage());
        }
        return "redirect:/staff/assignments/detail/" + assignId;
    }

    // แสดงหน้าจอสำหรับแก้ไขข้อมูลส่วนตัวของหัวหน้างาน
    @GetMapping("/staff/profile")
    public String showEditProfileForm(Model model, HttpSession session) {
        HeadStaff currentStaff = (HeadStaff) session.getAttribute("currentStaff");
        if (currentStaff == null) return "redirect:/loginorganizer";

        HeadStaff staff = headStaffService.getHeadStaffById(currentStaff.getStaffId());
        model.addAttribute("staff", staff);
        return "editStaffProfile";
    }

    // อัปเดตข้อมูลโปรไฟล์พนักงานและรีเซ็ตข้อมูลในเซสชันใหม่
    @PostMapping("/staff/profile/update")
    public String updateStaffProfile(@ModelAttribute HeadStaff updatedStaff, HttpSession session, RedirectAttributes ra) {
        try {
            headStaffService.updateProfile(updatedStaff);
            session.setAttribute("currentStaff", updatedStaff);
            
           
            ra.addFlashAttribute("success", "อัปเดตข้อมูลส่วนตัวเรียบร้อยแล้ว");
            return "redirect:/staff/profile"; 
            
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถอัปเดตข้อมูลได้: " + e.getMessage());
            return "redirect:/staff/profile";
        }
    }
    
    
 // เพิ่มเข้ามาใน HeadStaffController
    @GetMapping("/staff/assignments/update-status/{bookingId}")
    public String showUpdateStatusForm(@PathVariable String bookingId, Model model, HttpSession session) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginorganizer";
        
        BookingForm booking = bookingService.getBookingById(bookingId);
        model.addAttribute("b", booking);
        return "updateJobStatus";
    }

    @PostMapping("/staff/assignments/update-status/save")
    public String saveJobStatus(@RequestParam String bookingId,
                                 @RequestParam String jobStatus,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginorganizer";
        
        staffAssignmentService.updateJobStatus(bookingId, jobStatus);
        ra.addFlashAttribute("success", "อัปเดตสถานะงานสำเร็จ");
        return "redirect:/staff/assignments/detail/" + bookingId;
    }
}