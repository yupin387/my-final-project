package com.springboot.controller.manager;

import com.springboot.model.*;
import com.springboot.repository.ItemRepository;
import com.springboot.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manager/quotation")
public class QuotationController {

    private static final String MONK_INVITE_SERVICE_ITEM_NAME = "บริการประสานงานนิมนต์พระ";

    @Autowired
    private QuotationService quotationService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private ItemRepository itemRepo;
    

    // แสดงรายการใบเสนอราคาทั้งหมด รองรับการกรองตามสถานะ (status)
    @GetMapping
    public String listAllQuotations(
            @RequestParam(name = "status", defaultValue = "Pending") String status,
            Model model,
            HttpSession session) {

        if (session.getAttribute("currentManager") == null) {
            return "redirect:/loginmanager";
        }

        List<Quotation> all = quotationService.getAllQuotations();

 
        Map<String, Long> statusCounts = new HashMap<>();
        statusCounts.put("All", (long) all.size());
        for (String s : new String[]{"Pending", "Revised", "Confirmed"}) {
            statusCounts.put(s, all.stream()
                    .filter(q -> s.equalsIgnoreCase(q.getQuotationStatus()))
                    .count());
        }

        List<Quotation> quotations;
        if ("All".equalsIgnoreCase(status)) {
            quotations = new ArrayList<>(all);
        } else {
            quotations = new ArrayList<>();
            for (Quotation q : all) {
                if (status.equalsIgnoreCase(q.getQuotationStatus())) {
                    quotations.add(q);
                }
            }
        }

        // เรียงวันจัดงานที่ใกล้ที่สุดขึ้นก่อน
        quotations.sort(byNearestEventDate());

        model.addAttribute("quotations", quotations);
        model.addAttribute("currentStatus", status);
        model.addAttribute("statusCounts", statusCounts);

        return "quotationList";
    }

    // แสดงหน้าฟอร์มสร้างใบเสนอราคาใหม่จากรายการจอง โดยเตรียมข้อมูลรายการอุปกรณ์ในแพ็กเกจ
    @GetMapping("/create/{bookingId}")
    public String createQuotationForm(@PathVariable String bookingId, Model model, HttpSession session) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";

        BookingForm booking = bookingService.getBookingById(bookingId);
        if (booking == null) {
            return "redirect:/manager/bookings";
        }

        List<BookingFormDetail> validDetails = buildValidDetails(booking);

        model.addAttribute("b", booking);
        model.addAttribute("validDetails", validDetails);
        model.addAttribute("additionalNote", extractAdditionalNote(booking));

        boolean isCustomRequest = booking.getPackageEntity() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getPackageEntity().getOptionType());
        model.addAttribute("isCustomRequest", isCustomRequest);

        // 1. ดึงรายการสินค้าทั้งหมดในระบบ
        List<Item> allSystemItems = itemRepo.findAll();
        model.addAttribute("items", allSystemItems);

        // 2. ดึงรายการสินค้าเฉพาะของแพ็กเกจ (และเพิ่มอุปกรณ์พระสงฆ์อัตโนมัติหากเป็นเคสกรอกเอง)
        List<Item> packageItems = getBasePackageItemsWithMonkAdditions(booking, isCustomRequest);

        // 3. คำนวณรายการที่รวมในแพ็กเกจ
        List<Item> packageIncludedItems = computePackageIncludedItems(packageItems);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        // 4. รายการที่สามารถเลือกเพิ่มใน Popup Modal
        String packageType = booking.getPackageEntity() != null ? booking.getPackageEntity().getPackageType() : null;
        List<Item> extraSelectableItems = new ArrayList<>(allSystemItems);
        extraSelectableItems.removeAll(packageIncludedItems);
        extraSelectableItems = filterItemsByPackageType(extraSelectableItems, packageType);

        if (isCustomRequest) {
            extraSelectableItems.removeIf(i -> MONK_INVITE_SERVICE_ITEM_NAME.equals(i.getItemName()));
        }

        model.addAttribute("extraSelectableItems", extraSelectableItems);

        // 5. ราคาชุดสังฆทานที่คำนวณตามกฎแพ็กเกจ (ส่วนต่างจากชุดที่รวมในแพ็กเกจ / เกินโควตาคิดเต็ม)
        model.addAttribute("sanghatanLines", quotationService.calculateSanghatanLines(booking));

        return "quotationForm";
    }

    // บันทึกใบเสนอราคาใหม่ และอัปเดตสถานะการจองเป็น "Approved" หลังสร้างสำเร็จ
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
            return "redirect:/manager/quotation/detail/" + created.getQuotationId();
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return "redirect:/manager/quotation/create/" + bookingId;
        }
    }

    // แสดงรายละเอียดใบเสนอราคาที่มีอยู่แล้ว พร้อมรายการอุปกรณ์ในแพ็กเกจ (รวมของที่ให้ตามจำนวนพระสงฆ์)
    // เพื่อให้ใบสรุปแสดงครบทุกรายการที่เกี่ยวข้อง
    @GetMapping("/detail/{id}")
    public String quotationDetail(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";

        Quotation quotation = quotationService.getQuotationById(id);
        if (quotation == null) {
            return "redirect:/manager/quotation";
        }

        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);

        BookingForm booking = quotation.getBookingForm();
        if (booking == null) {
            return "redirect:/manager/quotation";
        }

        model.addAttribute("b", booking);
        model.addAttribute("additionalNote", extractAdditionalNote(booking));

        boolean isCustomRequest = booking.getPackageEntity() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getPackageEntity().getOptionType());


        List<Item> packageItems = getBasePackageItemsWithMonkAdditions(booking, isCustomRequest);
        List<Item> packageIncludedItems = computePackageIncludedItems(packageItems);
        
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        return "quotationDetail";
    }

    // แสดงหน้าฟอร์มแก้ไขใบเสนอราคาเดิม โดยเตรียมข้อมูลรายการเช่นเดียวกับตอนสร้างใหม่
    @GetMapping("/edit/{id}")
    public String editQuotationForm(@PathVariable String id, Model model, HttpSession session) {
        if (session.getAttribute("currentManager") == null) return "redirect:/loginmanager";

        Quotation quotation = quotationService.getQuotationById(id);
        if (quotation == null) {
            return "redirect:/manager/quotation";
        }

        List<QuotationDetail> details = quotationService.getDetailsByQuotationId(id);

        model.addAttribute("q", quotation);
        model.addAttribute("details", details);

        BookingForm booking = quotation.getBookingForm();
        if (booking == null) {
            return "redirect:/manager/quotation";
        }

        boolean isCustomRequest = booking.getPackageEntity() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getPackageEntity().getOptionType());
        model.addAttribute("isCustomRequest", isCustomRequest);

        // 1. ดึงรายการสินค้าทั้งหมดในระบบ
        List<Item> allSystemItems = itemRepo.findAll();
        model.addAttribute("items", allSystemItems);

        // 2. ดึงรายการสินค้าเฉพาะของแพ็กเกจ พร้อมอุปกรณ์ที่ให้ตามจำนวนพระสงฆ์
        List<Item> packageItems = getBasePackageItemsWithMonkAdditions(booking, isCustomRequest);

        model.addAttribute("additionalNote", extractAdditionalNote(booking));

        // 3. คำนวณรายการในแพ็กเกจ
        List<Item> packageIncludedItems = computePackageIncludedItems(packageItems);
        model.addAttribute("packageIncludedItems", packageIncludedItems);

        // 4. รายการสำหรับเลือกใน Modal
        String packageType = booking.getPackageEntity() != null ? booking.getPackageEntity().getPackageType() : null;
        List<Item> extraSelectableItems = new ArrayList<>(allSystemItems);
        extraSelectableItems.removeAll(packageIncludedItems);
        extraSelectableItems = filterItemsByPackageType(extraSelectableItems, packageType);

        if (isCustomRequest) {
            extraSelectableItems.removeIf(i -> MONK_INVITE_SERVICE_ITEM_NAME.equals(i.getItemName()));
        }

        model.addAttribute("extraSelectableItems", extraSelectableItems);

        return "editQuotation";
    }

    // บันทึกการแก้ไขใบเสนอราคา (ลบรายการเก่าออกแล้วบันทึกรายการใหม่ตามข้อมูลที่ส่งเข้ามา)
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
            return "redirect:/manager/quotation/detail/" + quotationId;
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "แก้ไขไม่สำเร็จ: " + e.getMessage());
            return "redirect:/manager/quotation/edit/" + quotationId;
        }
    }

    // API ภายใน: ดึงรายการอุปกรณ์ที่ผูกอยู่กับ Package ตาม id ที่ระบุ 
    @GetMapping("/api/get-items-by-package/{packageId}")
    @ResponseBody
    public List<Item> getItemsByPackage(@PathVariable int packageId) {
        return quotationService.getItemsByPackageId(packageId);
    }

    // ==========================================
    // Helper Methods
    // ==========================================

    // เรียงลำดับวันจัดงาน: งานที่ยังไม่ถึง (ใกล้สุดอยู่บน) → งานที่ผ่านไปแล้ว (ล่าสุดก่อน) → ไม่มีวันที่อยู่ท้ายสุด
    private Comparator<Quotation> byNearestEventDate() {
        LocalDate today = LocalDate.now();
        return (a, b) -> {
            LocalDate da = getEventLocalDate(a);
            LocalDate db = getEventLocalDate(b);

            if (da == null && db == null) return 0;
            if (da == null) return 1;
            if (db == null) return -1;

            boolean pastA = da.isBefore(today);
            boolean pastB = db.isBefore(today);
            if (pastA != pastB) return pastA ? 1 : -1;      

            return pastA ? db.compareTo(da)                  
                         : da.compareTo(db);                
        };
    }

    // แปลงวันจัดงานของใบเสนอราคาเป็น LocalDate (คืน null ถ้าไม่มีข้อมูล)
    private LocalDate getEventLocalDate(Quotation q) {
        if (q.getBookingForm() == null || q.getBookingForm().getEventDate() == null) return null;
        return Instant.ofEpochMilli(q.getBookingForm().getEventDate().getTime())
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
    }

    // กรองรายละเอียดการจองให้เหลือเฉพาะคำถาม-คำตอบที่เกี่ยวข้องกับ
    // ภัตตาหาร/สังฆทาน/อุปกรณ์/พระ และมีคำตอบที่ไม่ใช่ "ไม่ต้องการ"/"ไม่"/ตัวเลขล้วน
    // เพื่อนำไปแสดงในหน้าสร้างใบเสนอราคา
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

    // ดึงไอเทมของแพ็กเกจ และบวกไอเทมพิเศษตามจำนวนพระสงฆ์ (สำหรับกรณี Custom Request)
    private List<Item> getBasePackageItemsWithMonkAdditions(BookingForm booking, boolean isCustomRequest) {
        
        List<Item> packageItems = new ArrayList<>();
        if (booking.getPackageEntity() != null) {
            List<Item> itemsFromDb = quotationService.getItemsByPackageId(booking.getPackageEntity().getPackageId());
            if (itemsFromDb != null) {
                packageItems.addAll(itemsFromDb);
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
                        if (!packageItems.contains(item)) packageItems.add(item);
                    });
                }

                itemRepo.findByItemName(MONK_INVITE_SERVICE_ITEM_NAME).ifPresent(item -> {
                    if (!packageItems.contains(item)) packageItems.add(item);
                });

                if (isSelfInvite) {
                   
                }
            }
        }
        return packageItems;
    }

    // คำนวณหา Item ที่จัดว่าเป็น "ของพื้นฐาน" เพื่อนำไปโชว์ให้ Manager ดู (ตัดพวกปิ่นโต/สังฆทานออก)
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

    // กรอง item ให้เหลือเฉพาะที่เกี่ยวข้องกับ "ประเภทงานบุญ" (packageType) ของ booking นี้
    private List<Item> filterItemsByPackageType(List<Item> allItems, String packageType) {
        List<Item> filtered = new ArrayList<>();
        if (allItems == null) return filtered;

        for (Item it : allItems) {
            List<PackageItem> pis = it.getPackageItems();

            if (pis == null || pis.isEmpty()) {
                filtered.add(it);
                continue;
            }

            boolean matchesType = pis.stream()
                    .filter(pi -> pi.getPackageEntity() != null)
                    .anyMatch(pi -> packageType == null
                            || packageType.equals(pi.getPackageEntity().getPackageType()));

            if (matchesType) {
                filtered.add(it);
            }
        }
        return filtered;
    }

    // ดึงคำตอบของคำถาม "ความต้องการเพิ่มเติม" จากรายละเอียดการจอง (ถ้ามีและไม่ว่างเปล่า)
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