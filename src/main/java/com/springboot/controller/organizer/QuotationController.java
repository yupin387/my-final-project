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
    

    // แสดงหน้าฟอร์มสำหรับสร้างใบเสนอราคาใหม่ โดยดึงข้อมูลจาก Booking และรายการพิธี
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
        
        // ✅ เพิ่มสองบรรทัดนี้
        int ceremonyId = booking.getCeremony().getCeremonyId();
        model.addAttribute("items", quotationService.getItemsByCeremonyId(ceremonyId));
        
        return "quotationForm";
    }
    
    
    //บันทึกข้อมูลใบเสนอราคาที่สร้างใหม่ พร้อมรับข้อมูลสินค้าเพิ่มเติมและราคาที่กำหนดเอง
    @PostMapping("/save")
    public String saveQuotation(@RequestParam String bookingId,
                                // ชุดที่ 1: รายการจาก Popup
                                @RequestParam(required = false) List<Integer> extraItemIds, 
                                @RequestParam(required = false) List<Integer> extraQtys, 
                                @RequestParam(required = false) List<Double> extraPrices, 
                                @RequestParam(required = false) List<String> detailNotes,
                                // ชุดที่ 2: รายการจาก Booking (รายการลูกค้าเลือก)
                                @RequestParam(required = false) List<String> bookingItemNames, 
                                @RequestParam(required = false) List<Integer> bookingQtys, 
                                @RequestParam(required = false) List<Double> bookingPrices,
                                RedirectAttributes ra) { 
        try {
            // ส่งครบ 8 ตัวตามลำดับนี้ครับ:
            // (bookingId, itemIds, qtys, extraPrices, detailNotes, bNames, bQtys, bPrices)
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
    // แสดงรายละเอียดของใบเสนอราคาตาม ID ที่ระบุ
    @GetMapping("/detail/{id}")
    public String quotationDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        
        Quotation quotation = quotationService.getQuotationById(id);
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);
        
        model.addAttribute("q", quotation);
        model.addAttribute("details", details);
        return "quotationDetail"; 
    }

    //แสดงหน้าฟอร์มแก้ไขใบเสนอราคาเดิม เพื่อปรับปรุงข้อมูลและรายการสินค้า
    @GetMapping("/edit/{id}")
    public String editQuotationForm(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";
        
        Quotation quotation = quotationService.getQuotationById(id);
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);
        
        model.addAttribute("q", quotation);
        model.addAttribute("details", details); 
        model.addAttribute("itemList", quotationService.getAllItems()); 
        return "editQuotation"; 
    }

    //อัปเดตข้อมูลใบเสนอราคาที่แก้ไขแล้ว รวมถึงการปรับเปลี่ยนราคาค่าเดินทางหรือสินค้า
    @PostMapping("/update")
    public String updateQuotation(@RequestParam String quotationId,
                                  // ชุดที่ 1: รายการจาก Popup
                                  @RequestParam(required = false) List<Integer> extraItemIds, 
                                  @RequestParam(required = false) List<Integer> extraQtys,
                                  @RequestParam(required = false) List<Double> extraPrices, 
                                  @RequestParam(required = false) List<String> detailNotes,
                                  // ชุดที่ 2: รายการจาก Booking
                                  @RequestParam(required = false) List<String> bookingItemNames, 
                                  @RequestParam(required = false) List<Integer> bookingQtys, 
                                  @RequestParam(required = false) List<Double> bookingPrices,
                                  RedirectAttributes ra) {
        try {
            // ส่งครบ 8 ตัวตามที่แก้ไขใน Service แล้ว
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