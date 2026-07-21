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

    // ชื่อ item บริการนิมนต์พระ ต้องตรงกับที่ seed ไว้ใน Run.java เป๊ะๆ
    // ใช้เป็นค่าคงที่กลาง กันพิมพ์ผิดไม่ตรงกันระหว่างจุดที่อ้างอิง
    private static final String MONK_INVITE_SERVICE_ITEM_NAME = "บริการประสานงานนิมนต์พระ";

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

        List<BookingFormDetail> validDetails = buildValidDetails(booking);

        model.addAttribute("b", booking);
        model.addAttribute("validDetails", validDetails);

        int ceremonyId = booking.getCeremony().getCeremonyId();
        List<Item> allItems = quotationService.getItemsByCeremonyId(ceremonyId);
        model.addAttribute("items", allItems);

        // เช็คว่าเป็นรูปแบบ "กรอกความต้องการเบื้องต้น" หรือไม่
        boolean isCustomRequest = "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName());
        model.addAttribute("isCustomRequest", isCustomRequest);

        List<Item> packageIncludedItems = computePackageIncludedItems(allItems, isCustomRequest);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        // กรอกความต้องการเบื้องต้น: ทุก item ต้องเลือกเองทั้งหมด ไม่มีอะไรถูกตัดออกไปเป็น "ของแถม"
        List<Item> extraSelectableItems = new ArrayList<>(allItems);
        extraSelectableItems.removeAll(packageIncludedItems);

        // FIX: กรณี "กรอกความต้องการเบื้องต้น" หน้า quotationForm.jsp จะดึง
        // "บริการประสานงานนิมนต์พระ" มาใส่ในตารางอัตโนมัติให้แล้ว (จำนวน = จำนวนพระที่กรอกไว้
        // ตอนจอง และเฉพาะเมื่อเลือก "ให้ทางร้านนิมนต์" เท่านั้น) จึงต้องตัด item ตัวนี้ออกจาก
        // popup เลือกรายการเสริม ไม่งั้นผู้จัดงานจะกดเพิ่มซ้ำเข้าไปได้อีกรอบ กลายเป็น 2 แถว
        if (isCustomRequest) {
            extraSelectableItems.removeIf(i -> MONK_INVITE_SERVICE_ITEM_NAME.equals(i.getItemName()));
        }

        model.addAttribute("extraSelectableItems", extraSelectableItems);

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

        // FIX: quotationDetail.jsp ใช้ ${b.ceremony.ceremonyName} ("รูปแบบการจอง")
        // แต่ไม่เคยมีการ addAttribute("b", ...) มาก่อน เลยว่างเปล่าเสมอ
        model.addAttribute("b", quotation.getBookingForm());

        // เหมือนหน้า create/edit: คำนวณรายการที่ผูกกับ "ทุกแพ็กเกจ" เพื่อแสดงเป็น bullet list ในกล่องแพ็กเกจ
        int ceremonyId = quotation.getBookingForm().getCeremony().getCeremonyId();
        List<Item> allItems = quotationService.getItemsByCeremonyId(ceremonyId);
        boolean isCustomRequest = "กรอกความต้องการเบื้องต้น".equals(quotation.getBookingForm().getCeremony().getCeremonyName());
        List<Item> packageIncludedItems = computePackageIncludedItems(allItems, isCustomRequest);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        return "quotationDetail";
    }

    // แสดงหน้าฟอร์มสำหรับแก้ไขใบเสนอราคา โดยดึงข้อมูลใบเสนอราคา, รายละเอียดรายการ และรายการสินค้าตามประเภทพิธีมาแสดง
    @GetMapping("/edit/{id}")
    public String editQuotationForm(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        Quotation quotation = quotationService.getQuotationById(id);
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);

        // หมายเหตุ: editQuotation.jsp ใช้ ${q.bookingForm...} และดึงรายการจาก ${details} (ข้อมูลที่บันทึกไว้จริง)
        // ไม่ได้ใช้ "b"/"validDetails" เหมือนหน้า create เลยไม่ต้อง addAttribute สองตัวนี้ที่นี่
        BookingForm booking = quotation.getBookingForm();
        int ceremonyId = booking.getCeremony().getCeremonyId();
        List<Item> allItems = quotationService.getItemsByCeremonyId(ceremonyId);

        // เหมือนกับ createQuotationForm: "items" ต้องเป็นรายการเต็ม เผื่อ JSP ส่วนอื่นต้องอ้างอิง
        model.addAttribute("items", allItems);

        // เช็คว่าเป็นรูปแบบ "กรอกความต้องการเบื้องต้น" หรือไม่ (ใช้ตัดสินว่าจะโชว์แถวราคาแพ็กเกจ/bullet list หรือไม่)
        boolean isCustomRequest = "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName());
        model.addAttribute("isCustomRequest", isCustomRequest);

        // packageIncludedItems: อุปกรณ์/บริการพื้นฐานที่ผูกกับทุกแพ็กเกจ (แสดงเป็น bullet list เท่านั้น)
        // มีความหมายเฉพาะแพ็กเกจจริงเท่านั้น กรอกความต้องการเบื้องต้นไม่มีของแถมฟรี
        List<Item> packageIncludedItems = computePackageIncludedItems(allItems, isCustomRequest);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        // extraSelectableItems: ใช้ใน popup เท่านั้น (ตัดของที่ผูกกับทุกแพ็กเกจออก กันเลือกซ้ำ)
        // กรอกความต้องการเบื้องต้น: packageIncludedItems ว่าง เลยเท่ากับว่าทุก item เลือกได้ใน popup หมด
        List<Item> extraSelectableItems = new ArrayList<>(allItems);
        extraSelectableItems.removeAll(packageIncludedItems);

        // FIX: เหมือนหน้า create — กรณี custom request ตัด "บริการประสานงานนิมนต์พระ" ออกจาก popup
        // เพื่อไม่ให้เลือกซ้ำกับแถวที่ระบบ auto-add ให้ (ถ้า editQuotation.jsp ทำ auto-add แบบเดียวกัน)
        if (isCustomRequest) {
            extraSelectableItems.removeIf(i -> MONK_INVITE_SERVICE_ITEM_NAME.equals(i.getItemName()));
        }

        model.addAttribute("extraSelectableItems", extraSelectableItems);

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

    @GetMapping("/api/get-items-by-ceremony/{ceremonyId}")
    @ResponseBody
    public List<Item> getItemsByCeremony(@PathVariable int ceremonyId) {
        return quotationService.getItemsByCeremonyId(ceremonyId);
    }

    // ===== Helper ที่ดึงมาจาก createQuotationForm() เดิม เพื่อใช้ซ้ำใน edit/detail ได้ =====

    private List<BookingFormDetail> buildValidDetails(BookingForm booking) {
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
        return validDetails;
    }

    private List<Item> computePackageIncludedItems(List<Item> allItems, boolean isCustomRequest) {
        List<Item> packageIncludedItems = new ArrayList<>();
        if (!isCustomRequest) {
            for (Item it : allItems) {
                String typeName = it.getItemType().getItemTypeName();
                boolean isFoodOrSangkathan = typeName.equals("ภัตตาหารปิ่นโต") || typeName.equals("สังฆทาน");
                boolean isBundledInAllPackages = it.getCeremonies() != null && it.getCeremonies().size() >= 9;
                if (!isFoodOrSangkathan && isBundledInAllPackages) {
                    packageIncludedItems.add(it);
                }
            }
        }
        return packageIncludedItems;
    }
}