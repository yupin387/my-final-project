package com.springboot.controller.organizer;

import com.springboot.model.*;
import com.springboot.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;
import java.util.List;

@Controller
public class OrganizerController {

    @Autowired
    private OrganizerService organizerService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private HeadStaffService headStaffService;
    
    @Autowired
    private QuotationService quotationService;

    @Autowired
    private StaffAssignmentService staffAssignmentService;

    // ==========================================
    // 1. Login / Logout Organizer
    // ==========================================
    
    // แสดงหน้าฟอร์มสำหรับเข้าสู่ระบบของฝ่ายจัดการ (Organizer)
    @GetMapping("/loginorganizer")
    public String showLoginForm() {
        return "loginOrganizer";
    }

    // ตรวจสอบข้อมูลประจำตัวและจัดการเซสชันเมื่อเข้าสู่ระบบสำเร็จ
    @PostMapping("/loginorganizer")
    public ModelAndView loginOrganizer(@RequestParam String email,
                                       @RequestParam String password,
                                       HttpSession session, 
                                       RedirectAttributes ra) {
        Organizer organizer = organizerService.login(email, password);
        if (organizer == null) {
            ra.addFlashAttribute("error", "อีเมลหรือรหัสผ่านไม่ถูกต้อง");
            return new ModelAndView("redirect:/loginorganizer");
        }
        session.setAttribute("currentOrganizer", organizer);
        return new ModelAndView("redirect:/organizer/bookings");
    }

    // ล้างข้อมูลในเซสชันและออกจากระบบของฝ่ายจัดการ
    @GetMapping("/organizer/logout")
    public ModelAndView logout(HttpSession session) {
        session.invalidate();
        return new ModelAndView("redirect:/loginorganizer");
    }

    // ==========================================
    // 2. จัดการรายชื่อหัวหน้างาน (Organizer เป็นผู้ทำ)
    // ==========================================
    
    // ดึงรายชื่อพนักงานทั้งหมดที่ยังมีสถานะเปิดใช้งาน (Active) มาแสดงผล
    @GetMapping("/organizer/head-staff")
    public String listHeadStaff(Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        
        List<HeadStaff> staffList = headStaffService.getAllActiveHeadStaff();
        
        model.addAttribute("staffList", staffList);
        return "headStaffList";
    }

    // แสดงหน้าจอแบบฟอร์มสำหรับกรอกข้อมูลเพื่อเพิ่มพนักงานใหม่
    @GetMapping("/organizer/head-staff/add")
    public String showAddStaffForm(HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        return "addHeadStaff";
    }

    // รับข้อมูลจากฟอร์มและบันทึกรายชื่อพนักงานใหม่ลงในฐานข้อมูล
    @PostMapping("/organizer/head-staff/add")
    public String addHeadStaff(@RequestParam String firstName, 
                                @RequestParam String lastName,
                                @RequestParam String email, 
                                @RequestParam String password, 
                                @RequestParam String phone, 
                                HttpSession session,
                                RedirectAttributes ra) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        try {
            headStaffService.addHeadStaff(firstName, lastName, email, password, phone);
            ra.addFlashAttribute("success", "เพิ่มหัวหน้างานเรียบร้อยแล้ว");
            return "redirect:/organizer/head-staff";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถเพิ่มข้อมูลได้: " + e.getMessage());
            return "redirect:/organizer/head-staff/add";
        }
    }

    // ทำการลบพนักงานแบบนุ่มนวล (Soft Delete) โดยการเปลี่ยนสถานะเป็นไม่ใช้งาน
    @PostMapping("/organizer/head-staff/delete/{id}")
    public String deleteHeadStaff(@PathVariable int id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        try {
            headStaffService.deleteHeadStaff(id);
            ra.addFlashAttribute("success", "ลบข้อมูลพนักงานเรียบร้อยแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถลบได้: " + e.getMessage());
        }
        return "redirect:/organizer/head-staff";
    }

    // ==========================================
    // 3. จัดการรายการจอง
    // ==========================================
    
    // แสดงรายการจองทั้งหมดโดยกรองตามสถานะที่เลือก (เช่น งานใหม่ หรือ งานที่ยืนยันแล้ว)
    @GetMapping("/organizer/bookings")
    public String listBookings(@RequestParam(name = "status", defaultValue = "Pending") String status,
                               Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        // ==========================================================
        //  ดูแลงานที่ยืนยันแล้ว และงานที่เสร็จสิ้น
        // ==========================================================
        if ("Confirmed".equals(status) || "Completed".equals(status)) {
            List<BookingForm> bookings;
            if ("Confirmed".equals(status)) {
                bookings = bookingService.getBookingsByStatuses(Arrays.asList("Confirmed", "Assigned", "Preparing", "In_Progress"));
            } else {
                bookings = bookingService.findByStatus("Completed");
            }
            model.addAttribute("bookings", bookings);
            model.addAttribute("currentStatus", status);
            return "bookingList_Confirmed";
        }

        // ==========================================================
        // ดูแลงานใหม่ และงานยกเลิก
        // ==========================================================
        List<BookingForm> bookings = bookingService.findByStatus(status);
        model.addAttribute("bookings", bookings);
        model.addAttribute("currentStatus", status);
        return "bookingList_New";
    }

    // แสดงรายละเอียดทั้งหมดของรายการจองที่ระบุตาม ID
    @GetMapping("/organizer/bookings/detail/{id}")
    public String bookingDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        
        BookingForm booking = bookingService.getBookingById(id); 
        
        if (booking == null) return "redirect:/organizer/bookings";
        model.addAttribute("b", booking);
        return "bookingDetail";
    }

    // อนุมัติรายการจองเพื่อให้สามารถดำเนินการในขั้นตอนจัดทำใบเสนอราคาต่อไปได้
    @GetMapping("/organizer/bookings/approve/{id}")
    public String approveBooking(@PathVariable String id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        try {
            bookingService.approveBooking(id); 
            ra.addFlashAttribute("success", "รับงานสำเร็จ! คุณสามารถกดจัดทำใบเสนอราคาได้แล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        return "redirect:/organizer/bookings/detail/" + id;
    }

    // ปฏิเสธรายการจองและเปลี่ยนสถานะเป็นถูกปฏิเสธ (Rejected)
    @GetMapping("/organizer/bookings/reject/{id}")
    public String rejectBooking(@PathVariable String id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        try {
            bookingService.rejectBooking(id);
            ra.addFlashAttribute("error", "ปฏิเสธรายการจองแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถปฏิเสธรายการได้");
        }
        return "redirect:/organizer/bookings?status=Rejected";
    }
    
 // ==========================================
 // 4. มอบหมายงาน (Assign Staff)
 // ==========================================

 // แสดงหน้าฟอร์มสำหรับมอบหมายงานให้พนักงาน โดยดึงข้อมูลการจองและรายชื่อพนักงานที่ว่างในวันนั้นๆ มาแสดง
    @GetMapping("/organizer/assignments/assign/{bookingId}")
     public String showAssignForm(@PathVariable String bookingId, Model model, HttpSession session) {
         if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
         
         BookingForm booking = bookingService.getBookingById(bookingId);
         model.addAttribute("b", booking);
         // ค้นหาพนักงานที่ว่างในวันที่จัดงานจาก quotationService
         model.addAttribute("staffList", quotationService.findAvailableStaff(booking.getEventDate()));
         return "assignTask";
     }

     // บันทึกข้อมูลการมอบหมายงาน โดยเชื่อมโยงพนักงานเข้ากับงานที่เลือก และอัปเดตสถานะการจองในระบบ
     @PostMapping("/organizer/assignments/save")
     public String saveAssignment(@RequestParam String bookingId, 
                                   @RequestParam int staffId, 
                                   HttpSession session,
                                   RedirectAttributes ra) {
         if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
         try {
             // บันทึกการมอบหมายพนักงานเข้ากับใบเสนอราคา, การจอง และสร้างบันทึกการมอบหมายงานใหม่
             quotationService.assignStaffToQuotation(bookingId, staffId);
             bookingService.assignStaffToBooking(bookingId);
             staffAssignmentService.createNewAssignment(bookingId, staffId);
             
             ra.addFlashAttribute("success", "มอบหมายงานเรียบร้อยแล้ว");
             return "redirect:/organizer/bookings?status=Confirmed";
         } catch (Exception e) {
             // หากเกิดข้อผิดพลาด ให้ส่งข้อความแจ้งเตือนและกลับไปหน้าเดิม
             ra.addFlashAttribute("error", "บันทึกไม่สำเร็จ: " + e.getMessage());
             return "redirect:/organizer/assignments/assign/" + bookingId;
         }
     }
 
}