package com.springboot.controller.user;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

import jakarta.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.springboot.model.Ceremony;
import com.springboot.model.Item;
import com.springboot.model.Member;
import com.springboot.service.AuspiciousCalendarService;
import com.springboot.service.BookingService;
import com.springboot.service.CeremonyService;
import com.springboot.service.MemberService;
import com.springboot.service.ReviewService;

@Controller
public class UserController {

    @Autowired
    private MemberService memberService;
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private BookingService bookingService;

    @Autowired
    private CeremonyService ceremonyService;

    // ดึงวันฤกษ์ดีสดจาก Google Calendar สาธารณะของ boonumpar เท่านั้น (ไม่มี fallback ไฟล์ JSON แล้ว)
    @Autowired
    private AuspiciousCalendarService auspiciousCalendarService;

    // จำนวนทีมงาน/คิวที่รับได้ต่อวัน — ตอนนี้ตั้งตายตัวไว้ที่ 2
    // TODO: ถ้าวันหน้าอยากปรับจำนวนทีมงานได้จริงจากฐานข้อมูล (เช่น ตาราง staff availability)
    // ให้เปลี่ยนค่าคงที่นี้เป็นการ query จาก service แทน
    private static final int TEAM_COUNT = 2;

    // ครบทั้ง 7 ประเภทฤกษ์ดี (ตรงกับบล็อก "ความหมายฤกษ์ดี" ในหน้า calendar.jsp) ใช้กรองสำหรับ
    // บล็อกสรุปรายเดือน "สรุปฤกษ์ดีทำบุญ ปี 2569" — เดิมมีแค่ 4 ประเภท ทำให้อีก 3 ประเภทที่เหลือ
    // (วันมหาสิทธิโชค, วันชัยโชค, วันสิทธิโชค) ไม่เคยขึ้นในสรุปรายเดือนเลยทั้งที่มีข้อมูลอยู่
    //
    // หมายเหตุเรื่องคำสะกด "วันอัมฤตโชค": ใส่ไว้ทั้ง 2 แบบสะกด ("วันอัมฤตโชค" และ
    // "วันอำมฤตโชค") กันไว้ก่อน เผื่อปฏิทิน Google Calendar จริงใช้คำสะกดแบบใดแบบหนึ่ง
    // (ใส่ 2 แบบไม่มีผลเสีย เพราะจะมีแค่แบบที่ตรงกับข้อมูลจริงเท่านั้นที่ match ขึ้นมา)
    private static final List<String> MAIN_GOOD_LABELS = List.of(
    	    "วันราชาโชค", "วันมหาสิทธิโชค", "วันชัยโชค",
    	    "วันอัมฤตโชค", "วันอำมฤตโชค", 
    	    "วันอธิบดี", "วันธงชัย", "วันสิทธิโชค",
    	    "วันอัมฤตโชค", "วันอำมฤตโชค" // ใส่เผื่อไว้กรณีปฏิทินใช้สระที่ต่างกัน
    	);

    private static final String[] MONTH_NAMES_TH = {
        "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
        "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
    };

    // ปีที่ต้องการแสดงในบล็อก "สรุปฤกษ์ดีทำบุญ ปี 2569"
    // ปฏิทิน Google Calendar สาธารณะที่ดึงมามีข้อมูลหลายปีปนกัน (2026, 2027, ...)
    // ถ้าไม่กรองปีตรงนี้ เดือนเดียวกันจากคนละปีจะถูกจับคู่กับ label "2569" เดียวกันหมด
    // ทำให้ดูเหมือนเดือนซ้ำกัน (เช่น "มกราคม 2569" โผล่หลายใบ) ทั้งที่จริงคือคนละปี ค.ศ.
    private static final int TARGET_YEAR_CE = 2026; // ตรงกับ พ.ศ. 2569
    private static final int TARGET_YEAR_BE = TARGET_YEAR_CE + 543; // 2569

    /**
     * เทียบว่าปีของวันที่นี้ "ตรงกับปีที่ต้องการโชว์" หรือไม่ — เช็คทั้งแบบ ค.ศ. และ พ.ศ.
     * (ปฏิทิน boonumpar มี event บางส่วนกรอกปีเป็น พ.ศ. ตรงๆ ดูฟังก์ชัน normalizeYearKeys())
     * โดยปกติ dayQualityCache จะถูก normalize เป็น ค.ศ. ล้วนไปแล้วตั้งแต่ตอนโหลด
     * แต่เก็บเงื่อนไขนี้ไว้เผื่อกรณีข้อมูลหลุดรอดมาไม่ตรง format
     */
    private static boolean isTargetYear(LocalDate date) {
        int y = date.getYear();
        return y == TARGET_YEAR_CE || y == TARGET_YEAR_BE;
    }

    // ภาพประจำแต่ละประเภทงานบุญ ใช้ทั้งใน home และ calendar
    private static final Map<String, String> TYPE_IMAGE_MAP = new LinkedHashMap<>();
    static {
        TYPE_IMAGE_MAP.put("ทำบุญบ้าน", "ceremony1.webp");
        TYPE_IMAGE_MAP.put("ขึ้นบ้านใหม่", "img11.jpg");
        TYPE_IMAGE_MAP.put("ทำบุญบริษัทหรือออฟฟิศ", "img12.jpg");
    }
    private static final String DEFAULT_TYPE_IMAGE = "ceremony1.webp";

    // แคชข้อมูลวันฤกษ์ดีไว้ในหน่วยความจำ โหลดจาก Google Calendar สดแค่ครั้งเดียวตอนแอปสตาร์ท
    // key เป็น yyyy-MM-dd แบบ ค.ศ. เสมอ (มาจาก ICS DTSTART โดยตรง)
    private Map<String, List<Map<String, String>>> dayQualityCache = new LinkedHashMap<>();

    /**
     * โหลดวันฤกษ์ดีจาก Google Calendar สาธารณะของ boonumpar เท่านั้น
     * (ตัดไฟล์ fallback auspicious-days-2569.json ออกแล้ว — ไฟล์นั้นมีข้อมูลเก่า/ไม่ครบ
     * และมีการดักวันไม่ดีเองปนอยู่ ทำให้ข้อมูลไม่ตรงกับปฏิทินจริงบน Google Calendar)
     *
     * ถ้าดึงสดไม่สำเร็จ (เช่น เน็ตล่ม, calendar ID เปลี่ยน, ถูกบล็อกโดย network ของเซิร์ฟเวอร์)
     * จะปล่อย dayQualityCache เป็น map ว่าง — ปฏิทินยังใช้งานได้ปกติ แค่ไม่มีแท็ก ★/▲ ชั่วคราว
     * เท่านั้น ให้เช็ค log ข้อความ error ด้านล่างเพื่อสืบสาเหตุ
     */
    @PostConstruct
    private void loadDayQualityFromJson() {
        try {
            dayQualityCache = normalizeYearKeys(auspiciousCalendarService.fetchDayQuality());
            System.out.println("[UserController] โหลดวันฤกษ์ดีจาก Google Calendar สำเร็จ ("
                + dayQualityCache.size() + " วัน) ตัวอย่าง key: "
                + dayQualityCache.keySet().stream().limit(5).collect(Collectors.joining(", ")));
        } catch (Exception e) {
            System.err.println("[UserController] ดึงข้อมูลวันฤกษ์ดีจาก Google Calendar ไม่สำเร็จ "
                + "(ปฏิทินจะไม่มีแท็ก ★/▲ จนกว่าจะดึงสำเร็จ): " + e.getMessage());
            dayQualityCache = new LinkedHashMap<>();
        }
    }

    /**
     * ทำให้ key วันที่เป็น "ค.ศ." เสมอ
     *
     * ปัญหาที่เจอจริง: ปฏิทิน Google Calendar สาธารณะตัวนี้ (boonumpar) กรอกวันที่บาง event
     * ด้วยเลขปี "พ.ศ." ตรงๆ ลงในฟิลด์ DTSTART (เช่น "25690701" -> parse ได้ปี 2569) แทนที่จะ
     * เป็นปี ค.ศ. จริง (2026) ทั้งที่ตัว Google Calendar UI จะช่วยแปลงแสดงผลให้ดูเป็น ค.ศ. เอง
     * แต่ค่า DTSTART ดิบที่เราดึงผ่าน ICS ยังเป็นเลขปีตามที่ผู้กรอกพิมพ์ไว้ (พ.ศ.)
     *
     * ฝั่งปฏิทินหน้า /calendar (home.js) สร้าง key จาก JavaScript `new Date()` ซึ่งได้ปีแบบ
     * ค.ศ. เสมอ (เช่น "2026-07-01") ถ้า dayQualityCache ยังมี key เป็น พ.ศ. ("2569-07-01")
     * จะ match กันไม่ได้เลยสักวัน ★ ฤกษ์ดี / ▲ ควรเลี่ยง เลยไม่ขึ้นในปฏิทินทั้งหมด
     *
     * เกณฑ์ที่ใช้: ปี >= 2400 ถือว่าเป็นเลข พ.ศ. (ปีจริงในระบบ ค.ศ. ปัจจุบัน/อนาคตอันใกล้
     * ไม่มีทางเกิน 2400) จึงลบ 543 เพื่อแปลงกลับเป็น ค.ศ. ก่อนเก็บลง cache
     * ปีเก่าๆ ที่ยังเป็น ค.ศ. อยู่แล้ว (เช่น event เก่าที่กรอกถูกต้องตั้งแต่แรก) จะไม่ถูกแตะต้อง
     */
    private Map<String, List<Map<String, String>>> normalizeYearKeys(
            Map<String, List<Map<String, String>>> raw) {
        Map<String, List<Map<String, String>>> normalized = new LinkedHashMap<>();
        for (Map.Entry<String, List<Map<String, String>>> entry : raw.entrySet()) {
            try {
                LocalDate date = LocalDate.parse(entry.getKey());
                if (date.getYear() >= 2400) {
                    date = date.minusYears(543);
                }
                normalized.put(date.toString(), entry.getValue());
            } catch (Exception ex) {
                System.err.println("[UserController] ข้าม key วันที่รูปแบบผิด: " + entry.getKey());
            }
        }
        return normalized;
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("member", new Member());
        return "register";
    }

    @PostMapping("/saveMember")
    public String saveMember(@ModelAttribute Member member) {
        memberService.saveMember(member);
        return "redirect:/loginMember?successRegister";
    }

    @GetMapping("/home")
    public String home(Model model) {
        // หน้า home ใช้แค่รายชื่อประเภทงานบุญ (สำหรับเมนู/footer/แพ็กเกจ)
        // ส่วนข้อมูลปฏิทิน (วันจอง, วันฤกษ์ดี ฯลฯ) ย้ายไปอยู่ที่ /calendar แล้ว
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());
        return "home";
    }

    @GetMapping("/calendar")
    public String calendarPage(Model model) {
        // เมนู/popup เลือกประเภทงานบุญในหน้าปฏิทิน ก็ยังต้องใช้ ceremonyTypes เหมือนกัน
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());

        // ===== วันที่มีการจองแล้ว + จำนวนคิวที่ถูกจองไปแล้วต่อวัน =====
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        List<String> confirmedBookingDates = bookingService.getAllBookings().stream()
            .filter(b -> b.getBookingStatus() != null && (
                "Approved".equals(b.getBookingStatus()) ||
                "Confirmed".equals(b.getBookingStatus()) ||
                "Completed".equals(b.getBookingStatus())))
            .map(b -> sdf.format(b.getEventDate()))
            .collect(Collectors.toList());

        List<String> bookedDates = confirmedBookingDates.stream().distinct().collect(Collectors.toList());
        model.addAttribute("bookedDates", bookedDates);

        Map<String, Long> bookingsPerDate = confirmedBookingDates.stream()
            .collect(Collectors.groupingBy(d -> d, LinkedHashMap::new, Collectors.counting()));
        model.addAttribute("bookingsPerDate", bookingsPerDate);

        model.addAttribute("teamCount", TEAM_COUNT);

        // ===== วันดี / วันควรเลี่ยง — โหลดจาก Google Calendar สดเท่านั้น =====
        model.addAttribute("dayQuality", dayQualityCache);

        // ===== สรุปฤกษ์ดีทำบุญรายเดือน (ครบทั้ง 7 ประเภท) =====
        model.addAttribute("monthlyGoodDays", buildMonthlyGoodDays());

        return "calendar";
    }

    /**
     * จัดกลุ่มแพ็กเกจงานบุญทั้งหมดให้เหลือ 3 "ประเภทงานบุญหลัก"
     * ใช้ร่วมกันทั้งหน้า home และหน้า calendar (เมนู/footer/popup เลือกประเภทงานบุญ)
     */
    private List<Map<String, Object>> buildCeremonyTypes() {
        List<Ceremony> ceremonies = ceremonyService.getAllCeremonies();

        Map<String, List<Ceremony>> grouped = ceremonies.stream()
            .collect(Collectors.groupingBy(
                c -> c.getCeremonyType() == null ? "" : c.getCeremonyType().trim(),
                LinkedHashMap::new,
                Collectors.toList()
            ));

        List<Map<String, Object>> ceremonyTypes = new ArrayList<>();
        for (Map.Entry<String, List<Ceremony>> entry : grouped.entrySet()) {
            List<Ceremony> packages = entry.getValue();
            packages.sort(Comparator.comparingDouble(Ceremony::getBasePrice));
            Ceremony representative = packages.get(0);

            String mainName = entry.getKey();
            String image = TYPE_IMAGE_MAP.getOrDefault(mainName, DEFAULT_TYPE_IMAGE);

            Map<String, Object> typeMap = new LinkedHashMap<>();
            typeMap.put("mainName", mainName);
            typeMap.put("representativeId", representative.getCeremonyId());
            typeMap.put("image", image);
            typeMap.put("priceFrom", packages.get(0).getBasePrice());
            typeMap.put("packageCount", packages.size());
            ceremonyTypes.add(typeMap);
        }
        return ceremonyTypes;
    }

    /**
     * สรุปวันฤกษ์ดี (ครบทั้ง 7 ประเภท: วันราชาโชค / วันมหาสิทธิโชค / วันชัยโชค /
     * วันอัมฤตโชค / วันอธิบดี / วันธงชัย / วันสิทธิโชค)
     * จาก dayQualityCache แล้วจัดกลุ่มตามเดือน เรียงวันที่จากน้อยไปมาก
     * เพื่อส่งให้ JSP แสดงในบล็อก "สรุปฤกษ์ดีทำบุญ ปี 2569" (หน้า calendar)
     *
     * หมายเหตุ: ฟีด Google Calendar สาธารณะมีข้อมูลหลายปีปนกัน (2026, 2027, ...)
     * แต่ JSP โชว์ label ปีตายตัวว่า "2569" เดือนเดียวกันจากคนละปีเลยไปโผล่ซ้ำกัน
     * แก้โดยกรองเอาเฉพาะปีเป้าหมาย (TARGET_YEAR_CE) ตั้งแต่ตอน build เลย
     */
    private List<Map<String, Object>> buildMonthlyGoodDays() {
        // ใช้ TreeMap เพื่อให้วันที่เรียงจากน้อยไปมากอัตโนมัติ (คีย์เป็น "yyyy-MM-dd" เรียง string ได้ตรงลำดับวันที่พอดี)
        Map<String, List<Map<String, String>>> sorted = new TreeMap<>(dayQualityCache);

        // เดือน (yyyy-MM) -> รายการวันดีในเดือนนั้น
        Map<String, List<Map<String, String>>> byMonth = new LinkedHashMap<>();

        for (Map.Entry<String, List<Map<String, String>>> entry : sorted.entrySet()) {
            String dateStr = entry.getKey(); // yyyy-MM-dd

            LocalDate date = LocalDate.parse(dateStr);
            // กรองเอาเฉพาะปีที่ต้องการโชว์ (ตัด noise ปีอื่นที่ติดมาจาก feed ทิ้ง)
            // รองรับทั้งปีแบบ ค.ศ. (2026) และกรณีข้อมูลเก็บเลข พ.ศ. ตรงๆ (2569) เผื่อไว้
            if (!isTargetYear(date)) continue;

            List<String> goodLabelsThisDate = entry.getValue().stream()
                .filter(tag -> "good".equals(tag.get("type")) && MAIN_GOOD_LABELS.contains(tag.get("label")))
                .map(tag -> tag.get("label"))
                .collect(Collectors.toList());

            if (goodLabelsThisDate.isEmpty()) continue;

            String monthKey = dateStr.substring(0, 7); // yyyy-MM

            Map<String, String> row = new LinkedHashMap<>();
            row.put("dateLabel", date.getDayOfMonth() + " " + MONTH_NAMES_TH[date.getMonthValue() - 1]);
            row.put("typeLabel", String.join(", ", goodLabelsThisDate));

            byMonth.computeIfAbsent(monthKey, k -> new ArrayList<>()).add(row);
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, List<Map<String, String>>> entry : byMonth.entrySet()) {
            String monthKey = entry.getKey(); // yyyy-MM
            int monthValue = Integer.parseInt(monthKey.substring(5, 7));

            Map<String, Object> monthMap = new LinkedHashMap<>();
            monthMap.put("monthName", MONTH_NAMES_TH[monthValue - 1]);
            monthMap.put("days", entry.getValue());
            result.add(monthMap);
        }
        return result;
    }

    @GetMapping("/ceremony/detail/{id}")
    public String showCeremonyDetail(
            @PathVariable int id,
            @RequestParam(value = "dates", required = false) String dates,
            Model model) {

        Ceremony ceremony = ceremonyService.getCeremonyById(id);
        if (ceremony == null) return "redirect:/home";

        String mainType = ceremony.getCeremonyType() == null ? "" : ceremony.getCeremonyType().trim();

        List<Ceremony> siblingPackages = ceremonyService.getAllCeremonies().stream()
            .filter(c -> mainType.equals(c.getCeremonyType() == null ? "" : c.getCeremonyType().trim()))
            .sorted(Comparator.comparingDouble(Ceremony::getBasePrice))
            .collect(Collectors.toList());

        model.addAttribute("mainType", mainType);
        model.addAttribute("packages", siblingPackages);

        List<Item> equipmentList    = new ArrayList<>();
        List<Item> serviceList      = new ArrayList<>();
        List<Item> pintoItems       = new ArrayList<>();
        List<Item> sangkhathanItems = new ArrayList<>();

        for (Item item : ceremony.getItems()) {
            String typeName = item.getItemType().getItemTypeName();

            if (typeName.contains("อุปกรณ์")) {
                equipmentList.add(item);
            } else if (typeName.contains("ปิ่นโต")) {
                pintoItems.add(item);
            } else if (typeName.contains("บริการ")) {
                serviceList.add(item);
            } else if (typeName.contains("สังฆทาน")) {
                sangkhathanItems.add(item);
            }
        }

        model.addAttribute("ceremony",         ceremony);
        model.addAttribute("equipments",       equipmentList);
        model.addAttribute("services",         serviceList);
        model.addAttribute("pintoItems",       pintoItems);
        model.addAttribute("sangkhathanItems", sangkhathanItems);
        model.addAttribute("selectedDates", dates);

        if ("ทำบุญบ้าน".equals(mainType)) {
            return "ceremonyDetailHome";
        } else if ("ขึ้นบ้านใหม่".equals(mainType)) {
            return "ceremonyDetailNewHome";
        } else if ("ทำบุญบริษัทหรือออฟฟิศ".equals(mainType)) {
            return "ceremonyDetailOffice";
        }
        return "ceremonyDetailHome";
    }
}