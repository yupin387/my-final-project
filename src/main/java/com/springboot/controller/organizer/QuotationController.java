package com.springboot.controller.organizer;

import com.springboot.model.*;
import com.springboot.repository.ItemRepository;
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

    private static final String MONK_INVITE_SERVICE_ITEM_NAME = "บริการประสานงานนิมนต์พระ";

    @Autowired
    private QuotationService quotationService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private ItemRepository itemRepo;

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

    @GetMapping("/create/{bookingId}")
    public String createQuotationForm(@PathVariable String bookingId, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        BookingForm booking = bookingService.getBookingById(bookingId);
        List<BookingFormDetail> validDetails = buildValidDetails(booking);

        model.addAttribute("b", booking);
        model.addAttribute("validDetails", validDetails);
        model.addAttribute("additionalNote", extractAdditionalNote(booking));

        boolean isCustomRequest = "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName());
        model.addAttribute("isCustomRequest", isCustomRequest);

        // 1. ดึงรายการสินค้าทั้งหมดในระบบ (เพื่อให้ JSP สามารถ Match ชื่อสังฆทานและปิ่นโตเจอ)
        List<Item> allSystemItems = itemRepo.findAll();
        model.addAttribute("items", allSystemItems);

        // 2. ดึงรายการสินค้าเฉพาะของพิธี เพื่อใช้คำนวณของที่รวมในแพ็กเกจ
        List<Item> ceremonyItems;
        if (isCustomRequest) {
            ceremonyItems = allSystemItems;
        } else {
            int ceremonyId = booking.getCeremony().getCeremonyId();
            ceremonyItems = quotationService.getItemsByCeremonyId(ceremonyId);
        }

        // 3. คำนวณรายการที่รวมในแพ็กเกจ
        List<Item> packageIncludedItems = computePackageIncludedItems(ceremonyItems, isCustomRequest);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        // 4. รายการที่สามารถเลือกเพิ่มใน Popup Modal (ดึงจากสินค้าทั้งหมด แล้วตัดรายการที่มีในแพ็กเกจออก)
        List<Item> extraSelectableItems = new ArrayList<>(allSystemItems);
        extraSelectableItems.removeAll(packageIncludedItems);

        if (isCustomRequest) {
            extraSelectableItems.removeIf(i -> MONK_INVITE_SERVICE_ITEM_NAME.equals(i.getItemName()));
        }

        model.addAttribute("extraSelectableItems", extraSelectableItems);

        return "quotationForm";
    }

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

    @GetMapping("/detail/{id}")
    public String quotationDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        Quotation quotation = quotationService.getQuotationById(id);
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);

        model.addAttribute("b", quotation.getBookingForm());
        model.addAttribute("additionalNote", extractAdditionalNote(quotation.getBookingForm()));

        boolean isCustomRequest = "กรอกความต้องการเบื้องต้น".equals(quotation.getBookingForm().getCeremony().getCeremonyName());

        List<Item> allItems;
        if (isCustomRequest) {
            allItems = itemRepo.findAll();
        } else {
            int ceremonyId = quotation.getBookingForm().getCeremony().getCeremonyId();
            allItems = quotationService.getItemsByCeremonyId(ceremonyId);
        }

        List<Item> packageIncludedItems = computePackageIncludedItems(allItems, isCustomRequest);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        return "quotationDetail";
    }

    @GetMapping("/edit/{id}")
    public String editQuotationForm(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        Quotation quotation = quotationService.getQuotationById(id);
        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);

        BookingForm booking = quotation.getBookingForm();

        boolean isCustomRequest = "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName());
        model.addAttribute("isCustomRequest", isCustomRequest);

        // 1. ดึงรายการสินค้าทั้งหมดในระบบ
        List<Item> allSystemItems = itemRepo.findAll();
        model.addAttribute("items", allSystemItems);

        // 2. ดึงรายการสินค้าเฉพาะของพิธี
        List<Item> ceremonyItems;
        if (isCustomRequest) {
            ceremonyItems = allSystemItems;
        } else {
            int ceremonyId = booking.getCeremony().getCeremonyId();
            ceremonyItems = quotationService.getItemsByCeremonyId(ceremonyId);
        }

        model.addAttribute("additionalNote", extractAdditionalNote(booking));

        // 3. คำนวณรายการในแพ็กเกจ
        List<Item> packageIncludedItems = computePackageIncludedItems(ceremonyItems, isCustomRequest);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        // 4. รายการสำหรับเลือกใน Modal
        List<Item> extraSelectableItems = new ArrayList<>(allSystemItems);
        extraSelectableItems.removeAll(packageIncludedItems);

        if (isCustomRequest) {
            extraSelectableItems.removeIf(i -> MONK_INVITE_SERVICE_ITEM_NAME.equals(i.getItemName()));
        }

        model.addAttribute("extraSelectableItems", extraSelectableItems);

        return "editQuotation";
    }
    
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

    private List<BookingFormDetail> buildValidDetails(BookingForm booking) {
        List<BookingFormDetail> validDetails = new ArrayList<>();
        for (BookingFormDetail d : booking.getDetails()) {
            String ans = d.getAnswer();
            if ((d.getQuestion().getQuestionsText().contains("ภัตตาหาร") ||
                 d.getQuestion().getQuestionsText().contains("สังฆทาน") ||
                 d.getQuestion().getQuestionsText().contains("อุปกรณ์") ||
                 d.getQuestion().getQuestionsText().contains("พระ"))
                && ans != null && !ans.equals("ไม่ต้องการ") && !ans.equals("ไม่") && !ans.matches("^[0-9]+$")) {
                validDetails.add(d);
            }
        }
        return validDetails;
    }

    // ฟังก์ชันถูกแก้ไขเพื่อให้ดึงของที่อยู่ในแพ็กเกจได้ครบถ้วน
    private List<Item> computePackageIncludedItems(List<Item> allItems, boolean isCustomRequest) {
        List<Item> packageIncludedItems = new ArrayList<>();
        if (!isCustomRequest && allItems != null) {
            for (Item it : allItems) {
                if (it.getItemType() != null) {
                    String typeName = it.getItemType().getItemTypeName();
                    boolean isPackage = "แพ็กเกจ".equals(typeName);
                    boolean isFoodOrSangkathan = "ภัตตาหารปิ่นโต".equals(typeName) || "สังฆทาน".equals(typeName);
                    boolean isOptionalExtra = "อุปกรณ์เสริม (เลือกเพิ่มเอง)".equals(typeName);
                    
                    // ตัดเงื่อนไข size() >= 9 ออก และเช็คแค่ว่าไม่ใช่อาหาร สังฆทาน หรืออุปกรณ์เสริม ก็ให้ดึงมาโชว์ในแพ็กเกจเลย
                    if (!isPackage && !isFoodOrSangkathan && !isOptionalExtra) {
                        packageIncludedItems.add(it);
                    }
                }
            }
        }
        return packageIncludedItems;
    }

    private String extractAdditionalNote(BookingForm booking) {
        for (BookingFormDetail d : booking.getDetails()) {
            if (d.getQuestion().getQuestionsText().contains("ความต้องการเพิ่มเติม")) {
                String ans = d.getAnswer();
                if (ans != null && !ans.trim().isEmpty()) {
                    return ans.trim();
                }
            }
        }
        return null;
    }
}