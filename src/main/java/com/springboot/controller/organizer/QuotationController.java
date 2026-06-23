package com.springboot.controller.organizer;

import com.springboot.model.*;
import com.springboot.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/organizer/quotation")
public class QuotationController {

    @Autowired
    private QuotationService quotationService;

    @Autowired
    private BookingService bookingService;

    // แสดงรายการใบเสนอราคา โดยรองรับการกรองข้อมูลตามสถานะ
    @GetMapping
    public String listAllQuotations(
            @RequestParam(name = "status", defaultValue = "All") String status,
            Model model,
            HttpSession session) {

        if (session.getAttribute("currentOrganizer") == null) {
            return "redirect:/loginorganizer";
        }

        List<Quotation> quotations;
        if ("All".equalsIgnoreCase(status)) {
            quotations = quotationService.getAllQuotations();
        } else {
            quotations = quotationService.getQuotationsByStatus(status);
        }

        model.addAttribute("quotations", quotations);
        model.addAttribute("currentStatus", status);

        return "quotationList";
    }

    // แสดงหน้าฟอร์มสำหรับสร้างใบเสนอราคาใหม่
    @GetMapping("/create/{bookingId}")
    public String createQuotationForm(@PathVariable String bookingId, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        BookingForm booking = bookingService.getBookingById(bookingId);

        List<BookingFormDetail> validDetails = new ArrayList<>();
        for (BookingFormDetail d : booking.getDetails()) {
            String ans = d.getAnswer();
            if ((d.getQuestion().getQuestionsText().contains("ภัตตาหาร") ||
                 d.getQuestion().getQuestionsText().contains("สังฆทาน") ||
                 d.getQuestion().getQuestionsText().contains("พระ"))
                && ans != null && !ans.equals("ไม่ต้องการ") && !ans.equals("ไม่") && !ans.matches("^[0-9]+$")) {
                validDetails.add(d);
            }
        }

        model.addAttribute("b", booking);
        model.addAttribute("validDetails", validDetails);

        int ceremonyId = booking.getCeremony().getCeremonyId();
        model.addAttribute("items", quotationService.getItemsByCeremonyId(ceremonyId));

        return "quotationForm";
    }

    // บันทึกใบเสนอราคาใหม่
    @PostMapping("/save")
    public String saveQuotation(@RequestParam String bookingId,
                                @RequestParam(required = false) List<Integer> extraItemIds,
                                @RequestParam(required = false) List<Integer> extraQtys,
                                @RequestParam(required = false) List<Double> extraPrices,
                                @RequestParam(required = false) List<String> detailNotes,
                                @RequestParam(required = false) List<String> bookingItemNames,
                                @RequestParam(required = false) List<Integer> bookingQtys,
                                @RequestParam(required = false) List<Double> bookingPrices,
                                RedirectAttributes ra) {
        try {
            quotationService.createQuotation(bookingId, extraItemIds, extraQtys, extraPrices, detailNotes,
                                             bookingItemNames, bookingQtys, bookingPrices);
            ra.addFlashAttribute("success", "สร้างใบเสนอราคาสำเร็จ");
            return "redirect:/organizer/quotation";
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return "redirect:/organizer/quotation/create/" + bookingId;
        }
    }

    // แสดงรายละเอียดใบเสนอราคา
    @GetMapping("/detail/{id}")
    public String quotationDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        Quotation quotation = quotationService.getQuotationById(id);
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);
        return "quotationDetail";
    }
    
 // แสดงหน้าฟอร์มสำหรับแก้ไขใบเสนอราคา โดยดึงข้อมูลใบเสนอราคา, รายละเอียดรายการ และรายการสินค้าตามประเภทพิธีมาแสดง
    @GetMapping("/edit/{id}")
    public String editQuotationForm(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        // ดึงข้อมูลใบเสนอราคาและรายละเอียดรายการทั้งหมดที่เกี่ยวข้องกับ ID นี้
        Quotation quotation = quotationService.getQuotationById(id);
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);

        // ดึงรายการสินค้าทั้งหมดที่สามารถเลือกได้ โดยกรองตามประเภทพิธี (Ceremony ID) ของการจองนั้นๆ
        int ceremonyId = quotation.getBookingForm().getCeremony().getCeremonyId();
        model.addAttribute("items", quotationService.getItemsByCeremonyId(ceremonyId));

        return "editQuotation";
    }
    
    // อัปเดตใบเสนอราคา
    @PostMapping("/update")
    public String updateQuotation(@RequestParam String quotationId,
                                  @RequestParam(required = false) List<Integer> extraItemIds,
                                  @RequestParam(required = false) List<Integer> extraQtys,
                                  @RequestParam(required = false) List<Double> extraPrices,
                                  @RequestParam(required = false) List<String> detailNotes,
                                  @RequestParam(required = false) List<String> bookingItemNames,
                                  @RequestParam(required = false) List<Integer> bookingQtys,
                                  @RequestParam(required = false) List<Double> bookingPrices,
                                  RedirectAttributes ra) {
        try {
            quotationService.updateQuotation(quotationId, extraItemIds, extraQtys, extraPrices, detailNotes,
                                             bookingItemNames, bookingQtys, bookingPrices);
            ra.addFlashAttribute("success", "แก้ไขใบเสนอราคาเรียบร้อยแล้ว");
            return "redirect:/organizer/quotation/detail/" + quotationId;
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "แก้ไขไม่สำเร็จ: " + e.getMessage());
            return "redirect:/organizer/quotation/edit/" + quotationId;
        }
    }
}