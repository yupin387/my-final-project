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
import com.springboot.model.CeremonyItem;
import com.springboot.model.Item;
import com.springboot.model.Member;
import com.springboot.service.AuspiciousCalendarService;
import com.springboot.service.BookingService;
import com.springboot.service.CeremonyService;
import com.springboot.service.MemberService;
import com.springboot.service.ReviewService;

// ===== Controller หลักฝั่งผู้ใช้ทั่วไป (User/Guest) =====
// จัดการ: หน้าแรก, สมัครสมาชิก, ปฏิทิน (ทั่วไป/ล้านนา + วันฤกษ์ดี), รายละเอียดพิธี/แพ็กเกจ
@Controller
public class UserController {


    @Autowired
    private BookingService bookingService;

    @Autowired
    private CeremonyService ceremonyService;

    @Autowired
    private AuspiciousCalendarService auspiciousCalendarService;

    // จำนวนทีมงานที่มีอยู่ ใช้คำนวณว่าวันไหนคิวเต็มแล้วในหน้าปฏิทิน
    private static final int TEAM_COUNT = 2;

    // รายชื่อ "วันฤกษ์ดีหลัก" ที่ใช้กรองในหน้าปฏิทินล้านนา (ตัดคำว่า "วัน" ออกก่อนเทียบ)
    private static final List<String> MAIN_GOOD_LABELS = List.of(
        "วันราชาโชค", "วันมหาสิทธิโชค", "วันชัยโชค",
        "วันอัมฤตโชค", "วันอำมฤตโชค", 
        "วันอธิบดี", "วันธงชัย", "วันสิทธิโชค",
        "วันอัมฤตโชค", "วันอำมฤตโชค"
    );

    // ชื่อเดือน/ชื่อวันในสัปดาห์ภาษาไทย ใช้แสดงผลในตารางสรุปวันฤกษ์ดีรายเดือน
    private static final String[] MONTH_NAMES_TH = {
        "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
        "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
    };

    private static final String[] WEEKDAY_NAMES_TH = {
        "จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์", "เสาร์", "อาทิตย์"
    };

    // ปีเป้าหมายที่ใช้แสดงผลในตารางวันฤกษ์ดีรายเดือน (รองรับทั้ง พ.ศ. และ ค.ศ.)
    private static final int TARGET_YEAR_CE = 2026;
    private static final int TARGET_YEAR_BE = TARGET_YEAR_CE + 543;

    // เช็คว่าวันที่ที่ให้มาอยู่ในปีเป้าหมายหรือไม่ (เทียบได้ทั้งเลขปี ค.ศ. และ พ.ศ.)
    private static boolean isTargetYear(LocalDate date) {
        int y = date.getYear();
        return y == TARGET_YEAR_CE || y == TARGET_YEAR_BE;
    }

    // แผนที่จับคู่ "ประเภทพิธี" กับ "รูปภาพประกอบ" ที่จะใช้แสดงในหน้าเว็บ
    private static final Map<String, String> TYPE_IMAGE_MAP = new LinkedHashMap<>();
    static {
        TYPE_IMAGE_MAP.put("ทำบุญบ้าน", "ceremony1.webp");
        TYPE_IMAGE_MAP.put("ขึ้นบ้านใหม่", "img11.jpg");
        TYPE_IMAGE_MAP.put("ทำบุญบริษัทหรือออฟฟิศ", "img12.jpg");
    }
    // รูปภาพเริ่มต้น ถ้าประเภทพิธีไม่มีอยู่ใน TYPE_IMAGE_MAP ด้านบน
    private static final String DEFAULT_TYPE_IMAGE = "ceremony1.webp";

    // แคชข้อมูล "คุณภาพของวัน" (ฤกษ์ดี/ไม่ดี) ที่โหลดมาจาก Google Calendar
    // เก็บไว้ในหน่วยความจำเพื่อไม่ต้องยิงไปดึงใหม่ทุกครั้งที่มีคนเข้าดูปฏิทิน
    private Map<String, List<Map<String, String>>> dayQualityCache = new LinkedHashMap<>();

    // ทำงานทันทีหลัง Controller ถูกสร้าง (ตอนแอปเริ่มทำงาน): ดึงข้อมูลวันฤกษ์ดีจาก
    // Google Calendar มาเก็บไว้ใน cache ถ้าดึงไม่สำเร็จจะปล่อยเป็น map ว่าง (ปฏิทินจะไม่มีแท็ก ★/▲)
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

    // แปลง key วันที่ที่อาจเป็น พ.ศ. (ปี >= 2400) ให้กลายเป็น ค.ศ. ทั้งหมด
    // เพื่อให้ key ในแคชเป็นมาตรฐานเดียวกัน (ค.ศ.) ก่อนนำไปใช้เทียบต่อ
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

    // แสดงหน้าปฏิทินล้านนา
    @GetMapping("/lanna-calendar")
    public String lannaCalendarPage(Model model) {
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());
        return "lannaCalendar";
    }

    // แสดงหน้าสมัครสมาชิก พร้อมเตรียม object Member ว่างไว้ผูกกับฟอร์ม
    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("member", new Member());
        return "register";
    }

    // แสดงหน้าแรกของเว็บไซต์
    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());
        return "home";
    }

    // แสดงหน้าปฏิทิน (ฤกษ์ดี): เตรียมวันที่จองแล้ว (นับเฉพาะสถานะ Approved/Confirmed/Completed),
    // จำนวนการจองต่อวัน, จำนวนทีมงาน, ข้อมูลวันฤกษ์ดี และตารางสรุปวันฤกษ์ดีรายเดือน
    @GetMapping("/calendar")
    public String calendarPage(Model model) {
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());

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

        model.addAttribute("dayQuality", dayQualityCache);

        model.addAttribute("monthlyGoodDaysByWeekday", buildMonthlyGoodDaysByWeekday());

        return "calendar";
    }

    // จัดกลุ่มพิธีทั้งหมดตาม "ประเภทพิธี" (ceremonyType) แล้วเลือกแพ็กเกจราคาถูกสุดในแต่ละกลุ่มมาเป็นตัวแทน
    // ใช้สำหรับแสดงเมนู "บริการ/แพ็กเกจ" ใน navbar และหน้าอื่นๆ
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

    // ตัดคำนำหน้า "วัน" ออกจากชื่อฤกษ์ (เช่น "วันชัยโชค" -> "ชัยโชค") เพื่อใช้เทียบ label แบบไม่สนใจคำนำหน้า
    private static String stripDayPrefix(String s) {
        if (s == null) return "";
        return s.startsWith("วัน") ? s.substring(3) : s;
    }

    // สร้างตารางสรุป "วันฤกษ์ดีหลัก" แยกตามเดือนและวันในสัปดาห์ สำหรับปีเป้าหมาย (TARGET_YEAR)
    // เพื่อใช้แสดงในหน้าปฏิทินล้านนาว่าแต่ละเดือน วันจันทร์/อังคาร/... ตรงกับวันที่อะไรบ้างที่เป็นฤกษ์ดี
    private List<Map<String, Object>> buildMonthlyGoodDaysByWeekday() {
        Map<String, List<Map<String, String>>> sorted = new TreeMap<>(dayQualityCache);

        Map<String, Map<Integer, List<Integer>>> byMonthWeekday = new LinkedHashMap<>();

        for (Map.Entry<String, List<Map<String, String>>> entry : sorted.entrySet()) {
            String dateStr = entry.getKey();

            LocalDate date = LocalDate.parse(dateStr);
            if (!isTargetYear(date)) continue;
            boolean hasGoodTag = entry.getValue().stream().anyMatch(tag -> {
                if (!"good".equals(tag.get("type"))) return false;

                String label = tag.get("label");
                if (label == null) return false;

                String labelCore = stripDayPrefix(label);
                return MAIN_GOOD_LABELS.stream()
                        .anyMatch(keyword -> labelCore.contains(stripDayPrefix(keyword)));
            });

            if (!hasGoodTag) continue;

            String monthKey = dateStr.substring(0, 7);
            int weekdayIndex = date.getDayOfWeek().getValue() - 1;

            byMonthWeekday
                .computeIfAbsent(monthKey, k -> new LinkedHashMap<>())
                .computeIfAbsent(weekdayIndex, k -> new ArrayList<>())
                .add(date.getDayOfMonth());
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, Map<Integer, List<Integer>>> monthEntry : byMonthWeekday.entrySet()) {
            String monthKey = monthEntry.getKey();
            int monthValue = Integer.parseInt(monthKey.substring(5, 7));
            Map<Integer, List<Integer>> weekdayMap = monthEntry.getValue();

            List<Map<String, String>> weekdayRows = new ArrayList<>();
            for (int i = 0; i < 7; i++) {
                List<Integer> days = weekdayMap.getOrDefault(i, List.of());
                String daysText = days.isEmpty()
                    ? "–"
                    : days.stream().map(String::valueOf).collect(Collectors.joining(", "));

                Map<String, String> row = new LinkedHashMap<>();
                row.put("weekday", WEEKDAY_NAMES_TH[i]);
                row.put("daysText", daysText);
                weekdayRows.add(row);
            }

            Map<String, Object> monthMap = new LinkedHashMap<>();
            monthMap.put("monthName", MONTH_NAMES_TH[monthValue - 1]);
            monthMap.put("weekdayRows", weekdayRows);
            result.add(monthMap);
        }
        return result;
    }

    // แสดงหน้ารายละเอียดพิธี/แพ็กเกจตาม ceremonyId ที่เลือก
    // แยกรายการอุปกรณ์/บริการ/ปิ่นโต/สังฆทานตามประเภท แล้วเลือก view ที่จะ render
    // ตาม "ประเภทพิธีหลัก" (ทำบุญบ้าน / ขึ้นบ้านใหม่ / ทำบุญบริษัทหรือออฟฟิศ)
    @GetMapping("/ceremony/detail/{id}")
    public String showCeremonyDetail(
            @PathVariable int id,
            @RequestParam(value = "dates", required = false) String dates,
            Model model) {

        Ceremony ceremony = ceremonyService.getCeremonyById(id);
        if (ceremony == null) return "redirect:/home";
        
        model.addAttribute("ceremonyTypes", buildCeremonyTypes());

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

        if (ceremony.getCeremonyItems() != null) {
            for (CeremonyItem ci : ceremony.getCeremonyItems()) {
                Item item = ci.getItem();
                if (item != null && item.getItemType() != null) {
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