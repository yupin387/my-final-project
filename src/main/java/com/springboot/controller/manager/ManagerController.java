package com.springboot.controller.manager;

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
import java.util.Comparator;
import java.util.List;

@Controller
public class ManagerController {

    @Autowired
    private ManagerService managerService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private HeadStaffService headStaffService;
    
    @Autowired
    private QuotationService quotationService;

    @Autowired
    private JobAssignmentService staffAssignmentService;
    
    @Autowired
    private ItemService itemService;

    // ==========================================
    // 1. Login / Logout (รวม Manager + HeadStaff ในหน้าเดียว)
    // ==========================================

    // แสดงหน้าฟอร์มสำหรับเข้าสู่ระบบของฝ่ายจัดการ (ใช้ร่วมกันทั้ง Manager และ HeadStaff)
    @GetMapping("/loginmanager")
    public String showLoginForm() {
        return "loginManager";
    }

    // ตรวจสอบการเข้าสู่ระบบโดยเช็คว่าเป็น Manager หรือ HeadStaff ก่อนพาไปหน้าที่เหมาะสมของแต่ละ role
    @PostMapping("/login")
    public ModelAndView login(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession session,
                               RedirectAttributes ra) {

        // 1) ลองเช็คว่าเป็น Manager ก่อน
        Manager manager = managerService.login(email, password);
        if (manager != null) {
            session.setAttribute("currentManager", manager);
            ra.addFlashAttribute("success", "เข้าสู่ระบบสำเร็จ");
            return new ModelAndView("redirect:/manager/bookings");
        }

        // 2) ถ้าไม่ใช่ Manager ให้เช็คว่าเป็นหัวหน้างาน (HeadStaff) หรือไม่
        HeadStaff headStaff = headStaffService.login(email, password);
        if (headStaff != null) {
            session.setAttribute("currentStaff", headStaff);
            ra.addFlashAttribute("success", "เข้าสู่ระบบสำเร็จ");
            return new ModelAndView("redirect:/staff/assignments");
        }

        // 3) ไม่พบทั้ง Manager และ HeadStaff ที่ตรงกับข้อมูลนี้
        ra.addFlashAttribute("error", "อีเมลหรือรหัสผ่านไม่ถูกต้อง");
        return new ModelAndView("redirect:/loginmanager");
    }

    // ล้างข้อมูลในเซสชันและออกจากระบบของฝ่ายจัดการ (ใช้ร่วมกันทั้ง 2 role)
    @GetMapping("/manager/logout")
    public ModelAndView logout(HttpSession session) {
        session.invalidate();
        return new ModelAndView("redirect:/loginmanager");
    }

    // ==========================================
    // 2. จัดการรายชื่อหัวหน้างาน (Manager เป็นผู้ทำ)
    // ==========================================
    
    // แสดงรายชื่อหัวหน้างานที่ยังใช้งานอยู่ (Active) ทั้งหมด
    @GetMapping("/manager/head-staff")
    public String listHeadStaff(Model model, HttpSession session) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";
        
        List<HeadStaff> staffList = headStaffService.getAllActiveHeadStaff();
        
        model.addAttribute("staffList", staffList);
        return "headStaffList";
    }

    // แสดงหน้าฟอร์มสำหรับเพิ่มหัวหน้างานใหม่
    @GetMapping("/manager/head-staff/add")
    public String showAddStaffForm(HttpSession session) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";
        return "addHeadStaff";
    }

    // บันทึกข้อมูลหัวหน้างานใหม่ลงในระบบ
    @PostMapping("/manager/head-staff/add")
    public String addHeadStaff(@RequestParam String firstName, 
                                @RequestParam String lastName,
                                @RequestParam String email, 
                                @RequestParam String password, 
                                @RequestParam String phone, 
                                HttpSession session,
                                RedirectAttributes ra) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";
        try {
            headStaffService.addHeadStaff(firstName, lastName, email, password, phone);
            ra.addFlashAttribute("success", "เพิ่มหัวหน้างานเรียบร้อยแล้ว");
            return "redirect:/manager/head-staff";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถเพิ่มข้อมูลได้: " + e.getMessage());
            return "redirect:/manager/head-staff/add";
        }
    }

    // ลบหัวหน้างานออกจากระบบ (Service จะตัดสินใจเองว่าจะ Hard Delete หรือ Soft Delete)
    @PostMapping("/manager/head-staff/delete/{id}")
    public String deleteHeadStaff(@PathVariable int id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";
        try {
            headStaffService.deleteHeadStaff(id);
            ra.addFlashAttribute("success", "ลบข้อมูลพนักงานเรียบร้อยแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถลบได้: " + e.getMessage());
        }
        return "redirect:/manager/head-staff";
    }

    // ==========================================
    // 3. จัดการรายการจอง
    // ==========================================
    
    // แสดงรายการจองแบ่งตามสถานะ  พร้อมนับจำนวนของแต่ละสถานะ
    @GetMapping("/manager/bookings")
    public String listBookings(@RequestParam(name = "status", defaultValue = "Pending") String status,
                               Model model, HttpSession session) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";

        int countPending   = bookingService.findByStatus("Pending").size();
        int countConfirmed = bookingService.getBookingsByStatuses(
                                Arrays.asList("Confirmed", "Assigned", "Preparing", "In_Progress")).size();
        int countCompleted = bookingService.findByStatus("Completed").size();
        int countRejected  = bookingService.findByStatus("Rejected").size();
        int countAll       = countPending + countConfirmed + countCompleted + countRejected;

        model.addAttribute("countPending", countPending);
        model.addAttribute("countConfirmed", countConfirmed);
        model.addAttribute("countCompleted", countCompleted);
        model.addAttribute("countRejected", countRejected);
        model.addAttribute("countAll", countAll);

        if ("All".equals(status)) {
            List<BookingForm> bookings = bookingService.getBookingsByStatuses(
                Arrays.asList("Pending", "Confirmed", "Assigned", "Preparing", "In_Progress", "Completed", "Rejected"));
            bookings.sort(Comparator.comparing(BookingForm::getBookingId));
            model.addAttribute("bookings", bookings);
            model.addAttribute("currentStatus", status);
            return "bookingList_New";
        }

        if ("Pending".equals(status)) {
            List<BookingForm> bookings = bookingService.findByStatus("Pending");
            bookings.sort(Comparator.comparing(BookingForm::getBookingId));
            model.addAttribute("bookings", bookings);
            model.addAttribute("currentStatus", status);
            return "bookingList_New";
        }

        if ("Confirmed".equals(status) || "Completed".equals(status)) {
            List<BookingForm> bookings;
            if ("Confirmed".equals(status)) {
                bookings = bookingService.getBookingsByStatuses(
                    Arrays.asList("Confirmed", "Assigned", "Preparing", "In_Progress"));
            } else {
                bookings = bookingService.findByStatus("Completed");
            }
            bookings.sort(Comparator.comparing(BookingForm::getBookingId));
            model.addAttribute("bookings", bookings);
            model.addAttribute("currentStatus", status);
            return "bookingList_Confirmed";
        }

        List<BookingForm> bookings = bookingService.findByStatus(status);
        bookings.sort(Comparator.comparing(BookingForm::getBookingId));
        model.addAttribute("bookings", bookings);
        model.addAttribute("currentStatus", status);
        return "bookingList_New";
    }

    // แสดงรายละเอียดการจองรายการเดียว พร้อมคำนวณรายการอุปกรณ์ในแพ็กเกจ
    @GetMapping("/manager/bookings/detail/{id}")
    public String bookingDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";
        
        BookingForm booking = bookingService.getBookingById(id); 
        
        if (booking == null) return "redirect:/manager/bookings";

        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        List<CeremonyItem> packageItems = new java.util.ArrayList<>();
        if (booking.getCeremony() != null && booking.getCeremony().getCeremonyItems() != null) {
            packageItems.addAll(booking.getCeremony().getCeremonyItems());
        }

        if (booking.getCeremony() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getOptionType())) {

            int monkCount = extractMonkCount(booking);
            boolean isSelfInvite = isMonkSelfInvite(booking);

            if (monkCount > 0) {
                List<CeremonyItem> monkRelatedItems =
                        buildMonkRelatedItems(booking.getCeremony(), monkCount, isSelfInvite);
                packageItems.addAll(monkRelatedItems);
            }
        }

        model.addAttribute("packageItems", packageItems);

        model.addAttribute("b", booking);
        model.addAttribute("pintoItems", pintoItems);         
        model.addAttribute("sanghatharnItems", sanghatharnItems); 
        return "bookingDetail";
    }

    // ดึงจำนวนพระสงฆ์จากคำตอบของคำถาม "จำนวนพระสงฆ์" ในรายละเอียดการจอง (ตัดตัวอักษรที่ไม่ใช่ตัวเลขทิ้ง)
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

    // เช็คว่าลูกค้าเลือก "นิมนต์เอง" หรือไม่ จากคำตอบของคำถาม "รูปแบบการนิมนต์พระสงฆ์"
    // (ถ้านิมนต์เอง จะไม่คิดค่าบริการประสานงานนิมนต์พระ)
    private boolean isMonkSelfInvite(BookingForm booking) {
        if (booking.getDetails() == null) return false;

        return booking.getDetails().stream()
            .filter(d -> d.getQuestion() != null
                    && "รูปแบบการนิมนต์พระสงฆ์".equals(d.getQuestion().getQuestionsText()))
            .findFirst()
            .map(d -> d.getAnswer() != null && d.getAnswer().contains("นิมนต์เอง"))
            .orElse(false);
    }

    // สร้างรายการอุปกรณ์ที่เกี่ยวข้องกับจำนวนพระสงฆ์แบบ dynamic (ใช้เฉพาะกรณี "กรอกความต้องการเบื้องต้น"
    // ที่ไม่มี CeremonyItem ผูกไว้ล่วงหน้าตามจำนวนพระ) เช่น อาสนะ ตาลปัตร กรวยดอกไม้ ตามจำนวนพระที่ระบุ
    private List<CeremonyItem> buildMonkRelatedItems(Ceremony ceremony, int monkCount, boolean isSelfInvite) {
        List<CeremonyItem> result = new java.util.ArrayList<>();

        List<Item> serviceItems = itemService.getItemsByTypeName("บริการ");
        List<Item> ritualItems = itemService.getItemsByTypeName("อุปกรณ์พิธีกรรม");

        if (!isSelfInvite) {
            findItemByName(serviceItems, "บริการประสานงานนิมนต์พระ")
                .ifPresent(item -> result.add(new CeremonyItem(ceremony, item, monkCount)));
        }

        findItemByName(ritualItems, "อาสนะพระสงฆ์")
            .ifPresent(item -> result.add(new CeremonyItem(ceremony, item, monkCount)));

        findItemByName(ritualItems, "ตาลปัตรพร้อมขาตั้ง")
            .ifPresent(item -> result.add(new CeremonyItem(ceremony, item, monkCount)));

        findItemByName(ritualItems, "กรวยดอกไม้ถวายพระสงฆ์")
            .ifPresent(item -> result.add(new CeremonyItem(ceremony, item, monkCount)));

        return result;
    }

    // ค้นหา Item จากรายการโดยอ้างอิงชื่อ Item แบบตรงตัว
    private java.util.Optional<Item> findItemByName(List<Item> items, String name) {
        return items.stream().filter(i -> name.equals(i.getItemName())).findFirst();
    }

    // อนุมัติรับงานการจองรายการนี้ (เปลี่ยนสถานะเพื่อให้สามารถออกใบเสนอราคาต่อไปได้)
    @GetMapping("/manager/bookings/approve/{id}")
    public String approveBooking(@PathVariable String id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";
        try {
            bookingService.approveBooking(id); 
            ra.addFlashAttribute("success", "รับงานสำเร็จ! คุณสามารถกดจัดทำใบเสนอราคาได้แล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        return "redirect:/manager/bookings/detail/" + id;
    }

    // ปฏิเสธรายการจอง พร้อมบันทึกเหตุผลที่ปฏิเสธไว้ให้ลูกค้าเห็น
    @PostMapping("/manager/bookings/reject/{id}")
    public String rejectBooking(
            @PathVariable String id, 
            @RequestParam("rejectDetail") String rejectDetail,
            HttpSession session, 
            RedirectAttributes ra) {
            
        if (session.getAttribute("currentManager") == null) {
            return "redirect:/loginmanager";
        }
        
        try {
            bookingService.rejectBooking(id, rejectDetail);
            ra.addFlashAttribute("success", "ปฏิเสธรายการจองเรียบร้อยแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "ไม่สามารถปฏิเสธรายการได้: " + e.getMessage());
        }
        
        return "redirect:/manager/bookings?status=Rejected";
    }
    
    // ==========================================
    // 4. มอบหมายงาน (Assign Staff)
    // ==========================================

    // แสดงหน้าฟอร์มมอบหมายหัวหน้างานให้กับการจองรายการนี้ พร้อมรายชื่อพนักงานที่ว่างในวันงาน
    @GetMapping("/manager/assignments/assign/{bookingId}")
    public String showAssignForm(@PathVariable String bookingId, Model model, HttpSession session) {

        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";

        BookingForm booking = bookingService.getBookingById(bookingId);
        model.addAttribute("b", booking);

        model.addAttribute("staffList", quotationService.findAvailableStaff(booking.getEventDate()));

        boolean isChangeMode = booking.getQuotation() != null
                && booking.getQuotation().getStaff() != null;
        model.addAttribute("isChangeMode", isChangeMode);

        return "assignTask";
    }

     // บันทึกการมอบหมายหัวหน้างาน: ผูกพนักงานเข้ากับใบเสนอราคา อัปเดตสถานะการจอง
     @PostMapping("/manager/assignments/save")
     public String saveAssignment(@RequestParam String bookingId, 
                                   @RequestParam int staffId, 
                                   HttpSession session,
                                   RedirectAttributes ra) {
         if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";
         try {
             quotationService.assignStaffToQuotation(bookingId, staffId);
             bookingService.assignStaffToBooking(bookingId);
             staffAssignmentService.createNewAssignment(bookingId, staffId);
             
             ra.addFlashAttribute("success", "มอบหมายงานเรียบร้อยแล้ว");
             return "redirect:/manager/bookings?status=Confirmed";
         } catch (Exception e) {
             ra.addFlashAttribute("error", "บันทึกไม่สำเร็จ: " + e.getMessage());
             return "redirect:/manager/assignments/assign/" + bookingId;
         }
     }
 
    // ==========================================
    // 5. ดูรายละเอียดงานที่มอบหมาย (View Assign Job)
    // ==========================================
    // แสดงรายละเอียดงานที่ถูกมอบหมาย โดยรองรับการค้นหาทั้งจาก assignId (ขึ้นต้นด้วย "AN") และจาก bookingId
    @GetMapping("/manager/assignments/detail/{id}")
    public String viewAssignmentDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";

        JobAssignment sa;
        if (id.startsWith("AN")) {
            sa = staffAssignmentService.getAssignmentById(id);
        } else {
            sa = staffAssignmentService.getAssignmentByBookingId(id);
        }

        if (sa == null) {
            return "redirect:/manager/bookings?status=Confirmed";
        }

        model.addAttribute("a", sa);
        return "managerAssignmentDetail";
    }
}