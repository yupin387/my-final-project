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
        if (booking == null) {
            return "redirect:/organizer/bookings";
        }

        List<BookingFormDetail> validDetails = buildValidDetails(booking);

        model.addAttribute("b", booking);
        model.addAttribute("validDetails", validDetails);
        model.addAttribute("additionalNote", extractAdditionalNote(booking));

        boolean isCustomRequest = booking.getCeremony() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName());
        model.addAttribute("isCustomRequest", isCustomRequest);

        // 1. ดึงรายการสินค้าทั้งหมดในระบบ
        List<Item> allSystemItems = itemRepo.findAll();
        model.addAttribute("items", allSystemItems);

        // 2. ดึงรายการสินค้าเฉพาะของพิธี (และเพิ่มอุปกรณ์พระสงฆ์อัตโนมัติหากเป็นเคสกรอกเอง)
        List<Item> ceremonyItems = getBaseCeremonyItemsWithMonkAdditions(booking, isCustomRequest);

        // 3. คำนวณรายการที่รวมในแพ็กเกจ
        List<Item> packageIncludedItems = computePackageIncludedItems(ceremonyItems);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        // 4. รายการที่สามารถเลือกเพิ่มใน Popup Modal
        String ceremonyType = booking.getCeremony() != null ? booking.getCeremony().getCeremonyType() : null;
        List<Item> extraSelectableItems = new ArrayList<>(allSystemItems);
        extraSelectableItems.removeAll(packageIncludedItems);
        extraSelectableItems = filterItemsByCeremonyType(extraSelectableItems, ceremonyType);

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
                                @RequestParam(required = false) String note,
                                @RequestParam(required = false) List<String> bookingItemNames,
                                @RequestParam(required = false) List<Integer> bookingQtys,
                                @RequestParam(required = false) List<Double> bookingPrices,
                                RedirectAttributes ra) {
        try {
            Quotation created = quotationService.createQuotation(bookingId, extraItemIds, extraQtys, extraPrices, note,
                    bookingItemNames, bookingQtys, bookingPrices);

            bookingService.updateJobStatus(bookingId, "Approved");

            ra.addFlashAttribute("success", "สร้างใบเสนอราคาสำเร็จ");
            return "redirect:/organizer/quotation/detail/" + created.getQuotationId();
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
        if (quotation == null) {
            return "redirect:/organizer/quotation";
        }

        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);

        BookingForm booking = quotation.getBookingForm();
        if (booking == null) {
            return "redirect:/organizer/quotation";
        }

        model.addAttribute("b", booking);
        model.addAttribute("additionalNote", extractAdditionalNote(booking));

        boolean isCustomRequest = booking.getCeremony() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName());

        // ดึงรายการไอเทมในพิธี พร้อมของพระสงฆ์ (เพื่อให้ในใบสรุปแสดงของที่ให้อัตโนมัติด้วย)
        List<Item> ceremonyItems = getBaseCeremonyItemsWithMonkAdditions(booking, isCustomRequest);
        List<Item> packageIncludedItems = computePackageIncludedItems(ceremonyItems);
        
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        return "quotationDetail";
    }

    @GetMapping("/edit/{id}")
    public String editQuotationForm(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) return "redirect:/loginorganizer";

        Quotation quotation = quotationService.getQuotationById(id);
        if (quotation == null) {
            return "redirect:/organizer/quotation";
        }

        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);

        BookingForm booking = quotation.getBookingForm();
        if (booking == null) {
            return "redirect:/organizer/quotation";
        }

        boolean isCustomRequest = booking.getCeremony() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName());
        model.addAttribute("isCustomRequest", isCustomRequest);

        // 1. ดึงรายการสินค้าทั้งหมดในระบบ
        List<Item> allSystemItems = itemRepo.findAll();
        model.addAttribute("items", allSystemItems);

        // 2. ดึงรายการสินค้าเฉพาะของพิธี พร้อมอุปกรณ์ที่ให้ตามจำนวนพระสงฆ์
        List<Item> ceremonyItems = getBaseCeremonyItemsWithMonkAdditions(booking, isCustomRequest);

        model.addAttribute("additionalNote", extractAdditionalNote(booking));

        // 3. คำนวณรายการในแพ็กเกจ
        List<Item> packageIncludedItems = computePackageIncludedItems(ceremonyItems);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        // 4. รายการสำหรับเลือกใน Modal
        String ceremonyType = booking.getCeremony() != null ? booking.getCeremony().getCeremonyType() : null;
        List<Item> extraSelectableItems = new ArrayList<>(allSystemItems);
        extraSelectableItems.removeAll(packageIncludedItems);
        extraSelectableItems = filterItemsByCeremonyType(extraSelectableItems, ceremonyType);

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
                                  @RequestParam(required = false) String note,
                                  @RequestParam(required = false) List<String> bookingItemNames,
                                  @RequestParam(required = false) List<Integer> bookingQtys,
                                  @RequestParam(required = false) List<Double> bookingPrices,
                                  RedirectAttributes ra) {
        try {
            quotationService.updateQuotation(quotationId, extraItemIds, extraQtys, extraPrices, note,
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

    // ==========================================
    // Helper Methods
    // ==========================================

    private List<BookingFormDetail> buildValidDetails(BookingForm booking) {
        List<BookingFormDetail> validDetails = new ArrayList<>();
        if (booking.getDetails() == null) return validDetails;
        
        for (BookingFormDetail d : booking.getDetails()) {
            String ans = d.getAnswer();
            if (d.getQuestion() != null && 
                (d.getQuestion().getQuestionsText().contains("ภัตตาหาร") ||
                 d.getQuestion().getQuestionsText().contains("สังฆทาน") ||
                 d.getQuestion().getQuestionsText().contains("อุปกรณ์") ||
                 d.getQuestion().getQuestionsText().contains("พระ"))
                && ans != null && !ans.equals("ไม่ต้องการ") && !ans.equals("ไม่") && !ans.matches("^[0-9]+$")) {
                validDetails.add(d);
            }
        }
        return validDetails;
    }

 // ดึงไอเทมของพิธี และบวกไอเทมพิเศษตามจำนวนพระสงฆ์ (สำหรับกรณี Custom Request)
    private List<Item> getBaseCeremonyItemsWithMonkAdditions(BookingForm booking, boolean isCustomRequest) {
        
        // แก้ไขให้ตัวแปรคงที่ (Effectively Final) โดยใช้ .addAll() แทนการเขียนทับค่า
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
            
            if (booking.getDetails() != null) {
                for (BookingFormDetail d : booking.getDetails()) {
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
            }

            if (monkCount > 0) {
                String[] monkItemNames = {"อาสนะพระสงฆ์", "ตาลปัตรพร้อมขาตั้ง", "กรวยดอกไม้ถวายพระสงฆ์"};
                for (String name : monkItemNames) {
                    itemRepo.findByItemName(name).ifPresent(item -> {
                        if (!ceremonyItems.contains(item)) ceremonyItems.add(item);
                    });
                }

                // หมายเหตุ: บริการประสานงานนิมนต์พระต้องใส่เข้าไปในใบเสนอราคาเสมอเมื่อมีจำนวนพระสงฆ์
                // แม้ลูกค้าจะเลือก "นิมนต์เอง" ก็ตาม เพราะจารย์ต้องการให้แสดงรายการนี้ไว้
                // แต่คิดราคาเป็น 0.00 บาท (ไปจัดการเรื่องราคา 0 บาทที่ฝั่งหน้า JSP แทน
                // โดยเช็คจากตัวแปร isMonkSelfInvite)
                itemRepo.findByItemName(MONK_INVITE_SERVICE_ITEM_NAME).ifPresent(item -> {
                    if (!ceremonyItems.contains(item)) ceremonyItems.add(item);
                });

                // ป้องกัน unused-variable warning และคงไว้เผื่อใช้ต่อยอด logic อื่นในอนาคต
                if (isSelfInvite) {
                    // ไม่ต้องทำอะไรเพิ่มตรงนี้ - ราคา/ป้ายกำกับ "ฟรี" จัดการที่ JSP
                }
            }
        }
        return ceremonyItems;
    }

    // คำนวณหา Item ที่จัดว่าเป็น "ของพื้นฐาน" เพื่อนำไปโชว์ให้ Organizer ดู (ตัดพวกปิ่นโต/สังฆทานออก)
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

    // กรอง item ให้เหลือเฉพาะที่เกี่ยวข้องกับ "ประเภทพิธี" (ceremonyType) ของ booking นี้
    private List<Item> filterItemsByCeremonyType(List<Item> allItems, String ceremonyType) {
        List<Item> filtered = new ArrayList<>();
        if (allItems == null) return filtered;

        for (Item it : allItems) {
            List<CeremonyItem> cis = it.getCeremonyItems();

            if (cis == null || cis.isEmpty()) {
                filtered.add(it);
                continue;
            }

            boolean matchesType = cis.stream()
                    .filter(ci -> ci.getCeremony() != null)
                    .anyMatch(ci -> ceremonyType == null
                            || ceremonyType.equals(ci.getCeremony().getCeremonyType()));

            if (matchesType) {
                filtered.add(it);
            }
        }
        return filtered;
    }

    private String extractAdditionalNote(BookingForm booking) {
        if (booking.getDetails() == null) return null;
        for (BookingFormDetail d : booking.getDetails()) {
            if (d.getQuestion() != null && d.getQuestion().getQuestionsText().contains("ความต้องการเพิ่มเติม")) {
                String ans = d.getAnswer();
                if (ans != null && !ans.trim().isEmpty()) {
                    return ans.trim();
                }
            }
        }
        return null;
    }
}