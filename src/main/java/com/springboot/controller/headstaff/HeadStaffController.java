package com.springboot.controller.headstaff;

import com.springboot.model.*;
import com.springboot.repository.ItemRepository;
import com.springboot.service.BookingService;
import com.springboot.service.HeadStaffService;
import com.springboot.service.JobAssignmentService;
import com.springboot.service.QuotationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Controller
public class HeadStaffController {

    private static final String MONK_INVITE_SERVICE_ITEM_NAME = "บริการประสานงานนิมนต์พระ";

    // ลำดับสถานะงาน ใช้ตอนกดปุ่ม "ไปสถานะถัดไป"
    private static final List<String> STATUS_FLOW =
            Arrays.asList("Assigned", "Preparing", "In_Progress", "Completed");

    @Autowired
    private HeadStaffService headStaffService;

    @Autowired
    private JobAssignmentService staffAssignmentService;
    
    @Autowired
    private BookingService bookingService;

    @Autowired
    private QuotationService quotationService;

    @Autowired
    private ItemRepository itemRepo;

    // ตรวจสอบการเข้าสู่ระบบของหัวหน้างาน
    @PostMapping("/loginheadstaff")
    public ModelAndView login(@RequestParam String email,
                              @RequestParam String password, 
                              HttpSession session,
                              RedirectAttributes redirectAttrs) {

        HeadStaff staff = headStaffService.login(email, password);

        if (staff == null) {
            redirectAttrs.addFlashAttribute("error", "อีเมล รหัสผ่านไม่ถูกต้อง หรือบัญชีถูกระงับ");
            return new ModelAndView("redirect:/loginmanager");
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
        return new ModelAndView("redirect:/loginmanager");
    }

    // แสดงรายการงานที่ได้รับมอบหมายทั้งหมดของหัวหน้างานที่ล็อกอินอยู่ เรียงตามวันจัดงานที่ใกล้ถึงที่สุด
    @GetMapping("/staff/assignments")
    public String listAssignments(Model model, HttpSession session) {
        HeadStaff currentStaff = (HeadStaff) session.getAttribute("currentStaff");
        if (currentStaff == null) return "redirect:/loginmanager"; 

        List<JobAssignment> assignments = staffAssignmentService.getAssignmentsByStaff(currentStaff.getStaffId());

        assignments.sort(
            java.util.Comparator
                .comparing((JobAssignment a) -> "Completed".equals(a.getJobStatus()) ? 1 : 0)
                .thenComparing(
                    a -> a.getBookingForm().getEventDate(),
                    java.util.Comparator.nullsLast(java.util.Comparator.naturalOrder())
                )
        );

        // แยกเป็นกำลังดำเนินการ vs ประวัติ (Completed)
        List<JobAssignment> activeAssignments = new ArrayList<>();
        List<JobAssignment> completedAssignments = new ArrayList<>();
        for (JobAssignment a : assignments) {
            if ("Completed".equals(a.getJobStatus())) {
                completedAssignments.add(a);
            } else {
                activeAssignments.add(a);
            }
        }

        model.addAttribute("activeAssignments", activeAssignments);
        model.addAttribute("completedAssignments", completedAssignments);
        return "staffAssignmentList";
    }

    // แสดงรายละเอียดของงานมอบหมายชิ้นที่เลือก พร้อมรายการอุปกรณ์แบบเดียวกับใบเสนอราคา
    @GetMapping("/staff/assignments/detail/{id}")
    public String viewAssignmentDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginmanager";

        JobAssignment sa;
        if (id.startsWith("AN")) {
            sa = staffAssignmentService.getAssignmentById(id);
        } else {
            sa = staffAssignmentService.getAssignmentByBookingId(id);
        }

        if (sa == null) {
            return "redirect:/staff/assignments";
        }

        model.addAttribute("a", sa);

        BookingForm booking = sa.getBookingForm();
        Quotation quotation = (booking != null) ? booking.getQuotation() : null;

        if (quotation != null) {
            List<QuotationDetail> details = quotationService.getDetailsByQuotationId(quotation.getQuotationId());
            model.addAttribute("q", quotation);
            model.addAttribute("details", details);

            boolean isCustomRequest = booking.getCeremony() != null
                    && "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getOptionType());
            model.addAttribute("isCustomRequest", isCustomRequest);

            List<Item> ceremonyItems = getBaseCeremonyItemsWithMonkAdditions(booking, isCustomRequest);
            List<Item> packageIncludedItems = computePackageIncludedItems(ceremonyItems);
            model.addAttribute("packageIncludedItems", packageIncludedItems);

            // เช็คว่าลูกค้าเลือก "นิมนต์เอง" หรือไม่ (ใช้คำนวณส่วนลด/ราคาฟรีในตาราง)
            String monkInviteType = "";
            for (BookingFormDetail d : safeDetails(booking)) {
                if (d.getQuestion() != null
                        && d.getQuestion().getQuestionsText() != null
                        && d.getQuestion().getQuestionsText().contains("รูปแบบการนิมนต์")) {
                    monkInviteType = d.getAnswer();
                }
            }
            boolean isMonkSelfInvite = monkInviteType != null && monkInviteType.contains("นิมนต์เอง");
            model.addAttribute("isMonkSelfInvite", isMonkSelfInvite);
        } else {
            model.addAttribute("q", null);
            model.addAttribute("details", Collections.emptyList());
            model.addAttribute("packageIncludedItems", Collections.emptyList());
            model.addAttribute("isCustomRequest", false);
            model.addAttribute("isMonkSelfInvite", false);
        }

        return "staffAssignmentDetail";
    }
    
    // บันทึกรายงานความเสียหายจากการดำเนินงาน
    @PostMapping("/staff/assignments/report-damage/save")
    public String saveReport(@RequestParam String assignId,
                             @RequestParam String reportNote,
                             @RequestParam(value = "damageImages", required = false) MultipartFile[] files, 
                             RedirectAttributes ra) {
        try {
            staffAssignmentService.updateDamageReport(assignId, reportNote, files);
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
        if (currentStaff == null) return "redirect:/loginmanager";

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

    // บันทึกสถานะงานถัดไปทันที (กดปุ่มแล้วไปสถานะถัดไปเลย ไม่มี modal ให้เลือก)
    @PostMapping("/staff/assignments/update-status/save")
    public String saveJobStatus(@RequestParam String bookingId,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginmanager";

        JobAssignment sa = staffAssignmentService.getAssignmentByBookingId(bookingId);
        if (sa == null) {
            ra.addFlashAttribute("error", "ไม่พบข้อมูลงานที่มอบหมาย");
            return "redirect:/staff/assignments";
        }

        int currentIndex = STATUS_FLOW.indexOf(sa.getJobStatus());
        if (currentIndex < 0 || currentIndex >= STATUS_FLOW.size() - 1) {
            ra.addFlashAttribute("error", "สถานะงานนี้ไม่สามารถเปลี่ยนต่อไปได้แล้ว");
            return "redirect:/staff/assignments/detail/" + bookingId;
        }

        String nextStatus = STATUS_FLOW.get(currentIndex + 1);
        staffAssignmentService.updateJobStatus(bookingId, nextStatus);
        ra.addFlashAttribute("success", "อัปเดตสถานะงานเรียบร้อยแล้ว");
        return "redirect:/staff/assignments/detail/" + bookingId;
    }

    // ==========================================
    // Helper Methods (ก็อปปี้มาจาก QuotationController เพื่อคำนวณรายการ/หมวดหมู่แบบเดียวกัน)
    // TODO: ในอนาคตควรย้ายไปไว้ใน QuotationService แล้วเรียกใช้ร่วมกันทั้งสองฝั่ง
    // ==========================================

    private List<BookingFormDetail> safeDetails(BookingForm booking) {
        return (booking != null && booking.getDetails() != null) ? booking.getDetails() : new ArrayList<>();
    }

    private List<Item> getBaseCeremonyItemsWithMonkAdditions(BookingForm booking, boolean isCustomRequest) {
        List<Item> ceremonyItems = new ArrayList<>();
        if (booking.getCeremony() != null) {
            List<Item> itemsFromDb = quotationService.getItemsByCeremonyId(booking.getCeremony().getCeremonyId());
            if (itemsFromDb != null) {
                ceremonyItems.addAll(itemsFromDb);
            }
        }

        if (isCustomRequest) {
            int monkCount = 0;
            boolean isSelfInvite = false;

            for (BookingFormDetail d : safeDetails(booking)) {
                if (d.getQuestion() != null) {
                    if ("จำนวนพระสงฆ์".equals(d.getQuestion().getQuestionsText())) {
                        try {
                            monkCount = Integer.parseInt(d.getAnswer().replaceAll("[^0-9]", ""));
                        } catch (Exception e) {}
                    }
                    if ("รูปแบบการนิมนต์พระสงฆ์".equals(d.getQuestion().getQuestionsText())
                            && d.getAnswer() != null && d.getAnswer().contains("นิมนต์เอง")) {
                        isSelfInvite = true;
                    }
                }
            }

            if (monkCount > 0) {
                String[] monkItemNames = {"อาสนะพระสงฆ์", "ตาลปัตรพร้อมขาตั้ง", "กรวยดอกไม้ถวายพระสงฆ์"};
                for (String name : monkItemNames) {
                    itemRepo.findByItemName(name).ifPresent(item -> {
                        if (!ceremonyItems.contains(item)) ceremonyItems.add(item);
                    });
                }
                itemRepo.findByItemName(MONK_INVITE_SERVICE_ITEM_NAME).ifPresent(item -> {
                    if (!ceremonyItems.contains(item)) ceremonyItems.add(item);
                });
            }
        }
        return ceremonyItems;
    }

    private List<Item> computePackageIncludedItems(List<Item> allItems) {
        List<Item> packageIncludedItems = new ArrayList<>();
        if (allItems != null) {
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
}