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
    
    @Autowired
    private ItemService itemService;   // ⬅️ เพิ่มบรรทัดนี้

    // ==========================================
    // 1. Login / Logout (รวม Organizer + HeadStaff ในหน้าเดียว)
    // ==========================================

    // แสดงหน้าฟอร์มสำหรับเข้าสู่ระบบของฝ่ายจัดการ (ใช้ร่วมกันทั้ง Organizer และ HeadStaff)
    @GetMapping("/loginorganizer")
    public String showLoginForm() {
        return "loginOrganizer";
    }

    // ==========================================================
    // FIX: รวม endpoint การ login เป็นจุดเดียวคือ "/login"
    // (เดิมฟอร์มใน loginOrganizer.jsp post ไปที่ "/login" แต่ controller
    //  map ไว้ที่ "/loginorganizer" ทำให้ path ไม่ตรงกัน — แก้ให้ตรงกันแล้ว)
    //
    // FIX: ตรวจสอบข้อมูลแบบ "ล็อกอินหน้าเดียว ดีเทคเองว่าเป็นใคร" ตามที่อาจารย์สั่ง
    // ไม่ต้องแยกหน้าล็อกอินของ Organizer กับ HeadStaff อีกต่อไป:
    //   1) เช็คก่อนว่าเป็น Organizer หรือไม่
    //   2) ถ้าไม่ใช่ ให้เช็คว่าเป็น HeadStaff หรือไม่ (อีเมลเป็น unique
    //      อยู่แล้วในแต่ละตาราง จึงไม่มีทางชนกันระหว่าง 2 role)
    //   3) ถ้าไม่พบทั้งคู่ ค่อยแจ้ง error ว่าอีเมล/รหัสผ่านไม่ถูกต้อง
    // ==========================================================
    @PostMapping("/login")
    public ModelAndView login(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession session,
                               RedirectAttributes ra) {

        // 1) ลองเช็คว่าเป็น Organizer ก่อน
        Organizer organizer = organizerService.login(email, password);
        if (organizer != null) {
            session.setAttribute("currentOrganizer", organizer);
            return new ModelAndView("redirect:/organizer/bookings");
        }

        // 2) ถ้าไม่ใช่ Organizer ให้เช็คว่าเป็นหัวหน้างาน (HeadStaff) หรือไม่
        HeadStaff headStaff = headStaffService.login(email, password);
        if (headStaff != null) {
            // FIX: ต้องใช้ key "currentStaff" ให้ตรงกับที่ HeadStaffController เช็ค
            // (session.getAttribute("currentStaff")) ไม่ใช่ "currentHeadStaff"
            session.setAttribute("currentStaff", headStaff);
            // FIX: หน้า dashboard จริงของหัวหน้างานคือ /staff/assignments
            // (ตรงกับ @GetMapping("/staff/assignments") ใน HeadStaffController)
            return new ModelAndView("redirect:/staff/assignments");
        }

        // 3) ไม่พบทั้ง Organizer และ HeadStaff ที่ตรงกับข้อมูลนี้
        ra.addFlashAttribute("error", "อีเมลหรือรหัสผ่านไม่ถูกต้อง");
        return new ModelAndView("redirect:/loginorganizer");
    }

    // ล้างข้อมูลในเซสชันและออกจากระบบของฝ่ายจัดการ (ใช้ร่วมกันทั้ง 2 role)
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
        //  แท็บ "งานใหม่" (Pending): รวม Approved เข้าไปด้วย
        //  เพราะ "รับงานแล้ว" (Approved) ยังถือเป็นงานที่ organizer
        //  ต้องดำเนินการต่อ (ทำใบเสนอราคา) — ยังไม่ใช่ขั้น "ยืนยันแล้ว"
        //  ซึ่งเป็นสถานะที่ "ลูกค้า" เป็นคนกดยืนยันเอง
        // ==========================================================
        if ("Pending".equals(status)) {
            List<BookingForm> bookings = bookingService.getBookingsByStatuses(
                Arrays.asList("Pending", "Approved"));
            model.addAttribute("bookings", bookings);
            model.addAttribute("currentStatus", status);
            return "bookingList_New";
        }

        // ==========================================================
        //  ดูแลงานที่ยืนยันแล้ว (ลูกค้ายืนยันเอง) และงานที่เสร็จสิ้น
        // ==========================================================
        if ("Confirmed".equals(status) || "Completed".equals(status)) {
            List<BookingForm> bookings;
            if ("Confirmed".equals(status)) {
                bookings = bookingService.getBookingsByStatuses(
                    Arrays.asList("Confirmed", "Assigned", "Preparing", "In_Progress"));
            } else {
                bookings = bookingService.findByStatus("Completed");
            }
            model.addAttribute("bookings", bookings);
            model.addAttribute("currentStatus", status);
            return "bookingList_Confirmed";
        }

        // ==========================================================
        // งานยกเลิก (Rejected)
        // ==========================================================
        List<BookingForm> bookings = bookingService.findByStatus(status);
        model.addAttribute("bookings", bookings);
        model.addAttribute("currentStatus", status);
        return "bookingList_New";
    }

    // แสดงรายละเอียดทั้งหมดของรายการจองที่ระบุตาม ID
 // แสดงรายละเอียดทั้งหมดของรายการจองที่ระบุตาม ID
    @GetMapping("/organizer/bookings/detail/{id}")
    public String bookingDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        
        BookingForm booking = bookingService.getBookingById(id); 
        
        if (booking == null) return "redirect:/organizer/bookings";

        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        // 🌟 ดึงรายการอุปกรณ์จากแพ็กเกจ แล้วส่งไปให้ JSP ในชื่อ "packageItems" 🌟
        List<CeremonyItem> packageItems = new java.util.ArrayList<>();
        if (booking.getCeremony() != null && booking.getCeremony().getCeremonyItems() != null) {
            packageItems.addAll(booking.getCeremony().getCeremonyItems());
        }

        // ===================================================================
        // ถ้าเป็นแพ็กเกจ "กรอกความต้องการเบื้องต้น" ให้เพิ่มอุปกรณ์ที่ผูกกับ
        // จำนวนพระสงฆ์แบบ dynamic ตามคำตอบที่ลูกค้ากรอกจริง (ไม่ใช่ค่าคงที่)
        // ===================================================================
        if (booking.getCeremony() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName())) {

            int monkCount = extractMonkCount(booking);

            if (monkCount > 0) {
                List<CeremonyItem> monkRelatedItems = buildMonkRelatedItems(booking.getCeremony(), monkCount);
                packageItems.addAll(monkRelatedItems);
            }
        }

        model.addAttribute("packageItems", packageItems);

        model.addAttribute("b", booking);
        model.addAttribute("pintoItems", pintoItems);         
        model.addAttribute("sanghatharnItems", sanghatharnItems); 
        return "bookingDetail";
    }

    /**
     * อ่านคำตอบของคำถาม "จำนวนพระสงฆ์" จาก booking.details แล้วแปลงเป็นตัวเลข
     * คืนค่า 0 ถ้าไม่มีคำตอบ หรือแปลงตัวเลขไม่ได้
     */
    private int extractMonkCount(BookingForm booking) {
        if (booking.getDetails() == null) return 0;

        return booking.getDetails().stream()
            .filter(d -> d.getQuestion() != null
                    && "จำนวนพระสงฆ์".equals(d.getQuestion().getQuestionsText()))
            .findFirst()
            .map(d -> {
                try {
                    String raw = d.getAnswer() == null ? "" : d.getAnswer().replaceAll("[^0-9]", "");
                    return raw.isEmpty() ? 0 : Integer.parseInt(raw);
                } catch (NumberFormatException e) {
                    return 0;
                }
            })
            .orElse(0);
    }

    /**
     * สร้างรายการอุปกรณ์ที่ quantity ขึ้นกับจำนวนพระสงฆ์จริง
     * (ไม่ได้ save ลง DB แค่สร้างไว้แสดงผลชั่วคราวเท่านั้น)
     */
    private List<CeremonyItem> buildMonkRelatedItems(Ceremony ceremony, int monkCount) {
        List<CeremonyItem> result = new java.util.ArrayList<>();

        List<Item> serviceItems = itemService.getItemsByTypeName("บริการ");
        List<Item> ritualItems = itemService.getItemsByTypeName("อุปกรณ์พิธีกรรม");

        findItemByName(serviceItems, "บริการประสานงานนิมนต์พระ")
            .ifPresent(item -> result.add(new CeremonyItem(ceremony, item, monkCount)));

        findItemByName(ritualItems, "อาสนะพระสงฆ์")
            .ifPresent(item -> result.add(new CeremonyItem(ceremony, item, monkCount)));

        findItemByName(ritualItems, "ตาลปัตรพร้อมขาตั้ง")
            .ifPresent(item -> result.add(new CeremonyItem(ceremony, item, monkCount)));

        findItemByName(ritualItems, "กรวยดอกไม้ถวายพระสงฆ์")
            .ifPresent(item -> result.add(new CeremonyItem(ceremony, item, monkCount)));

        return result;
    }

    private java.util.Optional<Item> findItemByName(List<Item> items, String name) {
        return items.stream().filter(i -> name.equals(i.getItemName())).findFirst();
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
    @PostMapping("/organizer/bookings/reject/{id}")
    public String rejectBooking(
            @PathVariable String id, 
            @RequestParam("rejectDetail") String rejectDetail, // รับค่าเหตุผลจากฟอร์ม JSP
            HttpSession session, 
            RedirectAttributes ra) {
            
        if (session.getAttribute("currentOrganizer") == null) {
            return "redirect:/loginorganizer";
        }
        
        try {
            // ส่ง rejectDetail เข้าไปใน Service ด้วย
            bookingService.rejectBooking(id, rejectDetail);
            
            // แนะนำ: เปลี่ยนคีย์จาก "error" เป็น "success" หรือ "message" หากเป็นการทำงานที่สำเร็จ
            ra.addFlashAttribute("success", "ปฏิเสธรายการจองเรียบร้อยแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถปฏิเสธรายการได้: " + e.getMessage());
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