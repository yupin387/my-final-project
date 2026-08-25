package com.springboot.controller.member;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.model.BookingForm;
import com.springboot.model.Ceremony;
import com.springboot.model.CeremonyItem;
import com.springboot.model.Item;
import com.springboot.model.Member;
import com.springboot.model.QuestionsDetail;
import com.springboot.service.AuspiciousCalendarService;
import com.springboot.service.BookingService;
import com.springboot.service.CeremonyService;
import com.springboot.service.ItemService;
import com.springboot.service.QuestionsService;
import com.springboot.service.ReviewService;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpSession;

@Controller
public class BookingFormController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private QuestionsService questionsService;
    
    @Autowired
    private ItemService itemService;
    
    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private CeremonyService ceremonyService;

    @Autowired
    private AuspiciousCalendarService auspiciousCalendarService;

    private static final int TEAM_COUNT = 2;

    private Map<String, List<Map<String, String>>> dayQualityCache = new LinkedHashMap<>();

    @PostConstruct
    private void loadDayQuality() {
        try {
            Map<String, List<Map<String, String>>> raw = auspiciousCalendarService.fetchDayQuality();
            Map<String, List<Map<String, String>>> normalized = new LinkedHashMap<>();
            for (Map.Entry<String, List<Map<String, String>>> e : raw.entrySet()) {
                LocalDate date = LocalDate.parse(e.getKey());
                if (date.getYear() >= 2400) {
                    date = date.minusYears(543);
                }
                normalized.put(date.toString(), e.getValue());
            }
            dayQualityCache = normalized;
        } catch (Exception e) {
            System.err.println("[BookingFormController] ดึงข้อมูลวันฤกษ์ดีไม่สำเร็จ: " + e.getMessage());
            dayQualityCache = new LinkedHashMap<>();
        }
    }

    private void addCalendarAttributes(Model model) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        List<String> confirmedDates = bookingService.getAllBookings().stream()
            .filter(b -> b.getBookingStatus() != null && (
                "Approved".equals(b.getBookingStatus()) ||
                "Confirmed".equals(b.getBookingStatus()) ||
                "Completed".equals(b.getBookingStatus())))
            .map(b -> sdf.format(b.getEventDate()))
            .collect(Collectors.toList());

        model.addAttribute("bookedDates", confirmedDates.stream().distinct().collect(Collectors.toList()));
        model.addAttribute("bookingsPerDate", confirmedDates.stream()
            .collect(Collectors.groupingBy(d -> d, LinkedHashMap::new, Collectors.counting())));
        model.addAttribute("teamCount", TEAM_COUNT);
        model.addAttribute("dayQuality", dayQualityCache);
    }
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }
    
    @GetMapping("/booking")
    public String showBookingForm(Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember?error=pleaseLogin";

        String mainType = "ทำบุญบ้าน";
        List<QuestionsDetail> questions = questionsService.getQuestionsByCeremony(1);
        List<Ceremony> ceremonies = ceremonyService.getCeremoniesByType(mainType);
        Ceremony customCeremony = ceremonyService.getCustomCeremonyByType(mainType);

        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        model.addAttribute("booking", new BookingForm());
        model.addAttribute("questions", questions);
        model.addAttribute("ceremonies", ceremonies);
        model.addAttribute("defaultCeremonyId", customCeremony != null ? customCeremony.getCeremonyId() : null);
        model.addAttribute("pintoItems", pintoItems);
        model.addAttribute("sanghatharnItems", sanghatharnItems);
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());
        addCalendarAttributes(model);

        return "fillBookingForm";
    }

    @GetMapping("/booking2")
    public String showBookingForm2(Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember?error=pleaseLogin";

        String mainType = "ขึ้นบ้านใหม่";
        List<QuestionsDetail> questions = questionsService.getQuestionsByCeremony(4);
        List<Ceremony> ceremonies = ceremonyService.getCeremoniesByType(mainType);
        Ceremony customCeremony = ceremonyService.getCustomCeremonyByType(mainType);

        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        model.addAttribute("booking", new BookingForm());
        model.addAttribute("questions", questions);
        model.addAttribute("ceremonies", ceremonies);
        model.addAttribute("defaultCeremonyId", customCeremony != null ? customCeremony.getCeremonyId() : null);
        model.addAttribute("pintoItems", pintoItems);
        model.addAttribute("sanghatharnItems", sanghatharnItems);
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());
        addCalendarAttributes(model);

        return "fillBookingForm2";
    }

    @GetMapping("/booking3")
    public String showBookingForm3(Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember?error=pleaseLogin";

        String mainType = "ทำบุญบริษัทหรือออฟฟิศ";
        List<QuestionsDetail> questions = questionsService.getQuestionsByCeremony(7);
        List<Ceremony> ceremonies = ceremonyService.getCeremoniesByType(mainType);
        Ceremony customCeremony = ceremonyService.getCustomCeremonyByType(mainType);

        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        model.addAttribute("booking", new BookingForm());
        model.addAttribute("questions", questions);
        model.addAttribute("ceremonies", ceremonies);
        model.addAttribute("defaultCeremonyId", customCeremony != null ? customCeremony.getCeremonyId() : null);
        model.addAttribute("pintoItems", pintoItems);
        model.addAttribute("sanghatharnItems", sanghatharnItems);
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());
        addCalendarAttributes(model);

        return "fillBookingForm3";
    }

    private List<Map<String, Object>> buildCeremonyTypesForFooter() {
        List<Ceremony> all = ceremonyService.getAllCeremonies();
        Map<String, List<Ceremony>> grouped = all.stream()
            .collect(Collectors.groupingBy(
                c -> c.getCeremonyType() == null ? "" : c.getCeremonyType().trim(),
                LinkedHashMap::new,
                Collectors.toList()
            ));
        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, List<Ceremony>> entry : grouped.entrySet()) {
            List<Ceremony> packages = entry.getValue();
            packages.sort(Comparator.comparingDouble(Ceremony::getBasePrice));
            Ceremony representative = packages.get(0);

            Map<String, Object> m = new LinkedHashMap<>();
            m.put("mainName", entry.getKey());
            m.put("representativeId", representative.getCeremonyId());
            result.add(m);
        }
        return result;
    }

    @PostMapping("/saveBooking")
    public String saveBooking(@ModelAttribute BookingForm booking,
    		                  @RequestParam Map<String, String> allParams,
                              HttpSession session) throws IOException {
        
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember";

        if (booking.getCeremony() == null || booking.getCeremony().getCeremonyId() == 0) {
            return "redirect:/booking?error=noCeremony";
        }

        int ceremonyId = booking.getCeremony().getCeremonyId();
        Ceremony ceremony = ceremonyService.getCeremonyById(ceremonyId);
        
        booking.setCeremony(ceremony);
        booking.setMember(loginUser);

        List<String> imageBase64List = new ArrayList<>();
        for (int i = 0; ; i++) {
            String val = allParams.get("imageBase64[" + i + "]");
            if (val == null) break;
            imageBase64List.add(val);
        }

        if (!imageBase64List.isEmpty()) {
            try {
                String uploadDir = System.getProperty("user.dir") + "/uploads/address/";
                new java.io.File(uploadDir).mkdirs();
                List<String> fileNames = new ArrayList<>();
                for (String base64 : imageBase64List) {
                    if (base64 != null && base64.contains(",")) {
                        String data = base64.split(",")[1];
                        byte[] bytes = java.util.Base64.getDecoder().decode(data);
                        String fileName = System.currentTimeMillis() + "_"
                                + java.util.UUID.randomUUID().toString().substring(0, 8) + ".jpg";
                        java.nio.file.Files.write(java.nio.file.Paths.get(uploadDir + fileName), bytes);
                        fileNames.add(fileName);
                    }
                }
                booking.setAddressImage(String.join(",", fileNames));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        BookingForm saved = bookingService.saveBooking(booking);
        return "redirect:/viewBooking/" + saved.getBookingId();
    }

    @GetMapping("/viewBooking/{id}")
    public String viewBooking(@PathVariable String id, Model model, HttpSession session) {
        BookingForm booking = bookingService.getBookingById(id);
        if (booking == null) return "redirect:/home";

        boolean alreadyReviewed = reviewService.hasAlreadyReviewed(id);

        List<CeremonyItem> packageItems = new ArrayList<>();
        if (booking.getCeremony() != null && booking.getCeremony().getCeremonyItems() != null) {
            packageItems = booking.getCeremony().getCeremonyItems().stream()
                .filter(ci -> ci.getItem() != null)
                .collect(Collectors.toList());
        }

        // ===================================================================
        // ถ้าเป็นแพ็กเกจ "กรอกความต้องการเบื้องต้น" ให้เพิ่มอุปกรณ์ที่ผูกกับ
        // จำนวนพระสงฆ์แบบ dynamic ตามคำตอบที่ลูกค้ากรอกจริง (ไม่ใช่ค่าคงที่)
        //
        // FIX: ต้องเช็คด้วยว่าลูกค้าเลือก "นิมนต์เอง" หรือไม่ ถ้าเลือกนิมนต์เอง
        // ต้อง "ไม่" เพิ่มค่า "บริการประสานงานนิมนต์พระ" (500 บาท/รูป) เข้าไป
        // เพราะร้านไม่ได้เป็นคนนิมนต์พระให้ — ให้ตรงกับ logic เดียวกันกับฝั่ง
        // Organizer (OrganizerController) และหน้า quotationCreate.jsp
        // (isMonkSelfInvite) ไม่งั้นราคาที่ลูกค้าเห็นในหน้า viewBooking ของตัวเอง
        // จะสูงเกินจริงสำหรับเคสนิมนต์เอง
        // ===================================================================
        if (booking.getCeremony() != null
                && "กรอกความต้องการเบื้องต้น".equals(booking.getCeremony().getCeremonyName())) {

            int monkCount = extractMonkCount(booking);
            boolean isSelfInvite = isMonkSelfInvite(booking);

            if (monkCount > 0) {
                List<CeremonyItem> monkRelatedItems =
                        buildMonkRelatedItems(booking.getCeremony(), monkCount, isSelfInvite);
                packageItems.addAll(monkRelatedItems);
            }
        }

        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        model.addAttribute("booking", booking);
        model.addAttribute("packageItems", packageItems);
        model.addAttribute("hasReview", alreadyReviewed);
        model.addAttribute("pintoItems", pintoItems);
        model.addAttribute("sanghatharnItems", sanghatharnItems);
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());

        return "viewBooking";
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
     * อ่านคำตอบของคำถาม "รูปแบบการนิมนต์พระสงฆ์" แล้วเช็คว่าลูกค้าเลือก
     * "นิมนต์เอง" หรือไม่ (ตรงกับ logic fn:contains(monkInviteType,'นิมนต์เอง')
     * ที่ใช้ในหน้า quotationCreate.jsp / quotationDetail.jsp และ
     * OrganizerController ฝั่ง organizer)
     */
    private boolean isMonkSelfInvite(BookingForm booking) {
        if (booking.getDetails() == null) return false;

        return booking.getDetails().stream()
            .filter(d -> d.getQuestion() != null
                    && "รูปแบบการนิมนต์พระสงฆ์".equals(d.getQuestion().getQuestionsText()))
            .findFirst()
            .map(d -> d.getAnswer() != null && d.getAnswer().contains("นิมนต์เอง"))
            .orElse(false);
    }

    /**
     * สร้างรายการอุปกรณ์ที่ quantity ขึ้นกับจำนวนพระสงฆ์จริง
     * (ไม่ได้ save ลง DB แค่สร้างไว้แสดงผลชั่วคราวเท่านั้น)
     *
     * FIX: เพิ่มพารามิเตอร์ isSelfInvite — ถ้าลูกค้านิมนต์พระเอง จะไม่เพิ่ม
     * "บริการประสานงานนิมนต์พระ" (ค่าบริการที่ร้านคิดเฉพาะตอนช่วยนิมนต์ให้)
     * ส่วนอุปกรณ์พิธีอื่น (อาสนะ, ตาลปัตร, กรวยดอกไม้) ยังต้องเตรียมให้ตามจำนวน
     * พระอยู่ดี ไม่ว่าใครจะเป็นคนนิมนต์
     */
    private List<CeremonyItem> buildMonkRelatedItems(Ceremony ceremony, int monkCount, boolean isSelfInvite) {
        List<CeremonyItem> result = new ArrayList<>();

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

    
    private java.util.Optional<Item> findItemByName(List<Item> items, String name) {
        return items.stream().filter(i -> name.equals(i.getItemName())).findFirst();
    }
    
    @GetMapping("/latestBooking")
    public String viewLatestBooking(HttpSession session) {
        Member user = (Member) session.getAttribute("user");
        if (user == null) return "redirect:/loginMember";

        BookingForm latest = bookingService.getLatestBookingByMember(user.getMemberId());

        if (latest != null && latest.getBookingId() != null) {
            return "redirect:/viewBooking/" + latest.getBookingId();
        } else {
            return "redirect:/booking";
        }
    }
    
    @GetMapping("/booking/cancel/{id}")
    public String cancelBooking(@PathVariable String id, HttpSession session, RedirectAttributes ra) {
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember";
        
        try {
            bookingService.rejectBooking(id, "ผู้จองยกเลิกรายการจองด้วยตนเอง");
            ra.addFlashAttribute("success", "ยกเลิกรายการจองสำเร็จแล้ว");
        } catch(Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาดในการยกเลิก: " + e.getMessage());
        }
        
        return "redirect:/home";
    }
    
    @GetMapping("/myBookings")
    public String myBookings(Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember?error=pleaseLogin";

        List<BookingForm> bookings = bookingService.getBookingsByMember(loginUser.getMemberId());
        
        // เรียงตาม bookingId จากน้อยไปมาก
        bookings.sort(Comparator.comparing(BookingForm::getBookingId));

        model.addAttribute("bookings", bookings);
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());

        return "myBookingList";
    }
}