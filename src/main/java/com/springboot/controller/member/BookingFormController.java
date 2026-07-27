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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.model.BookingForm;
import com.springboot.model.Ceremony;
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

    // ใช้แสดงปฏิทินย่อในฟอร์มจอง (เลือกวันได้พร้อมเช็คว่าง/เต็มคิว)
    @Autowired
    private AuspiciousCalendarService auspiciousCalendarService;

    // จำนวนทีมงาน/คิวที่รับได้ต่อวัน ให้ตรงกับ TEAM_COUNT ใน UserController
    private static final int TEAM_COUNT = 2;

    // แคชวันฤกษ์ดีของหน้าฟอร์มจอง แยกตัวแปรออกจาก UserController เพื่อไม่ต้องแก้ไฟล์นั้นเลย
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
            System.err.println("[BookingFormController] ดึงข้อมูลวันฤกษ์ดีไม่สำเร็จ (ปฏิทินในฟอร์มจะไม่มีแท็ก ★/▲): "
                + e.getMessage());
            dayQualityCache = new LinkedHashMap<>();
        }
    }

    // เติมข้อมูลปฏิทิน (วันว่าง/เต็มคิว/ฤกษ์ดี) ให้ model ก่อน return view — ใช้ร่วมกันทั้ง 3 ฟอร์ม
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

    /*
     * FIX: เดิมเมธอดนี้ return เฉพาะ "mainName" อย่างเดียว ทำให้ลิงก์ในเมนู dropdown
     * "บริการ/แพ็กเกจ" ของหน้า bookingForm.jsp / viewBooking.jsp ที่อ้างอิง
     * ${t.representativeId} ไม่มีค่า (ลิงก์จะกลายเป็น /ceremony/detail/ เฉยๆ)
     * จึงต้องหา "ตัวแทน" ของแต่ละประเภทงานบุญ (representative ceremony) และใส่
     * representativeId เข้าไปด้วย ให้ตรงกับ logic เดียวกันกับ buildCeremonyTypes()
     * ใน UserController (เรียงตามราคาแล้วเลือกตัวที่ถูกที่สุดเป็นตัวแทน)
     */
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


    /*===========แก้===========*/
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

        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        model.addAttribute("booking", booking);
        model.addAttribute("hasReview", alreadyReviewed);
        model.addAttribute("pintoItems", pintoItems);
        model.addAttribute("sanghatharnItems", sanghatharnItems);
        // FIX: เดิมหน้านี้ไม่ได้ set ceremonyTypes ทำให้เมนู dropdown "บริการ/แพ็กเกจ"
        // ใน navbar ของ viewBooking.jsp ว่างเปล่า (${ceremonyTypes} ไม่มีค่า)
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());
        return "viewBooking";
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
            bookingService.rejectBooking(id);
            ra.addFlashAttribute("success", "ยกเลิกรายการจองสำเร็จแล้ว");
        } catch(Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาดในการยกเลิก: " + e.getMessage());
        }
        
        return "redirect:/home";
    }
}