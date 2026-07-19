package com.springboot.service;
import java.io.InputStream;
import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import org.springframework.stereotype.Service;
import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.component.VEvent;
@Service
public class AuspiciousCalendarService {
    private static final String ICS_URL =
        "https://calendar.google.com/calendar/ical/h61ifkc3ivsejr5kgtn2s6t4lc%40group.calendar.google.com/public/basic.ics";

    // รายชื่อฤกษ์ที่ "คาดว่า" จะเจอในปฏิทินนี้ — ใช้แค่สำหรับ log เตือนเวลาเจอ label แปลกๆ
    // ที่ไม่อยู่ในลิสต์นี้เท่านั้น ไม่ได้ใช้กรองข้อมูลออกแล้ว (ดูเหตุผลด้านล่างที่ fetchDayQuality)
    private static final List<String> MAIN_GOOD_LABELS = List.of(
    	    "วันราชาโชค", "วันมหาสิทธิโชค", "วันชัยโชค",
    	    "วันอัมฤตโชค", "วันอำมฤตโชค", // ใส่ทั้งสระอำและสระอา
    	    "วันอธิบดี", "วันธงชัย", "วันสิทธิโชค"
    	);

    /**
     * ทำความสะอาด label ก่อนเทียบ/เก็บ:
     * - ตัดช่องว่างหัวท้าย (trim)
     * - แทนที่ non-breaking space (\u00A0) และ zero-width space (\u200B) ที่มักติดมาจากการ
     *   copy-paste ข้อความในปฏิทิน Google Calendar ด้วยช่องว่างปกติ/ตัดทิ้ง
     * - ยุบช่องว่างซ้ำๆ ให้เหลือช่องเดียว
     *
     * เคยเจอปัญหาว่า label เดียวกันเป๊ะ (เช่น "วันอธิบดี") ขึ้นบางวันไม่ขึ้นบางวัน ทั้งที่สะกด
     * เหมือนกันทุกตัวอักษรตอนอ่านด้วยตา สาเหตุที่เป็นไปได้มากที่สุดคือมีอักขระที่มองไม่เห็น
     * (เช่น NBSP/zero-width space) แทรกอยู่ในบาง event เท่านั้น ฟังก์ชันนี้ช่วยลดปัญหานั้น
     */
    private static String normalizeLabel(String raw) {
        if (raw == null) return "";
        String cleaned = raw
                .replaceAll("[\\p{Cntrl}]", "")
                .replace("\u00A0", " ")    // non-breaking space -> ช่องว่างปกติ
                .replace("\u200B", "")     // zero-width space -> ตัดทิ้ง
                .replace("\uFEFF", "")     // BOM -> ตัดทิ้ง
                .trim()
                .replaceAll("\\s+", " ");
        return cleaned;
    }

    /**
     * นอกจาก trim/ลบอักขระที่มองไม่เห็นแล้ว ยังตัด suffix ประเภท " (+)" หรือ
     * เครื่องหมายวงเล็บต่อท้ายชื่อฤกษ์ออกด้วย
     *
     * ปัญหาที่เจอจริง: ปฏิทิน Google Calendar สาธารณะตัวนี้ (boonumpar) บาง event กรอก
     * summary เป็น "วันธงชัย (+)" ซึ่งมีความหมายเดียวกับ "วันธงชัย" เป๊ะ แต่สะกดไม่ตรงกับ
     * MAIN_GOOD_LABELS ที่ใช้เทียบในบล็อกสรุปรายเดือน (buildMonthlyGoodDays ฝั่ง
     * UserController) ทำให้ label แบบมีหางวงเล็บถูกกรองทิ้งอย่างไม่ตั้งใจ ทั้งที่ควรนับ
     * เป็นวันฤกษ์ดีประเภทเดียวกัน
     */
    private static String normalizeAndStripSuffix(String raw) {
        String cleaned = normalizeLabel(raw);
        // ตัดวงเล็บท้ายสตริงออก เช่น "วันธงชัย (+)" -> "วันธงชัย"
        cleaned = cleaned.replaceAll("\\s*\\([^)]*\\)\\s*$", "").trim();
        return cleaned;
    }

    public Map<String, List<Map<String, String>>> fetchDayQuality() throws Exception {
        Map<String, List<Map<String, String>>> result = new LinkedHashMap<>();
        CalendarBuilder builder = new CalendarBuilder();
        
        try (InputStream in = new URL(ICS_URL).openStream()) {
            net.fortuna.ical4j.model.Calendar calendar = builder.build(in);
            
            for (Object c : calendar.getComponents(Component.VEVENT)) {
                try {
                    VEvent event = (VEvent) c;
                    Property dtStartProp = event.getProperty(Property.DTSTART);
                    Property summaryProp = event.getProperty(Property.SUMMARY);
                    
                    if (dtStartProp == null || summaryProp == null) continue;
                    
                    String datePart = dtStartProp.getValue().substring(0, 8);
                    LocalDate date = LocalDate.parse(datePart, DateTimeFormatter.BASIC_ISO_DATE);
                    String dateKey = date.toString();
                    
                    String summary = summaryProp.getValue();
                    if (summary == null) continue;

                    // --- ส่วนที่ปรับปรุง: ล้างข้อมูลและแยกคำ ---
                    // ล้างอักขระพิเศษทุกชนิดก่อน split
                    String cleanSummary = summary.replaceAll("[\\p{Cntrl}\\u00A0\\u200B\\uFEFF]", " ");

                    // เดิม split ด้วย "," อย่างเดียว แต่พบว่าปฏิทินจริงบางวันคั่นชื่อฤกษ์
                    // หลายอันด้วย "/" แทน เช่น "วันธงชัย / วันมหาสิทธิโชค" ถ้า split แค่ "," 
                    // สตริงทั้งก้อนจะถูกอ่านเป็น label เดียว ไม่ตรงกับ MAIN_GOOD_LABELS
                    // ตัวไหนเลย ทำให้ทั้งสองฤกษ์หลุดหายไปพร้อมกันจากบล็อกสรุปรายเดือน
                    // จึงเพิ่ม "/" เป็นตัวคั่นด้วย
                    String[] labels = cleanSummary.split("[,/]");
                    
                    List<Map<String, String>> tags = result.computeIfAbsent(dateKey, k -> new ArrayList<>());
                    
                    for (String rawLabel : labels) {
                        // ใช้ normalizeAndStripSuffix แทน trim ธรรมดา เพื่อตัดหางวงเล็บ
                        // เช่น "(+)" ที่ติดมากับบาง event ออกไปด้วย ไม่ใช่แค่ยุบช่องว่าง
                        String label = normalizeAndStripSuffix(rawLabel);
                        if (label.isEmpty()) continue;

                        // เปลี่ยนจากเดิมที่เป็นการกรองออก ให้เป็นการ "รับเข้าทั้งหมด"
                        // แล้วใช้ System.out เพื่อดูว่ามีคำไหนที่หลุดมาบ้างใน Console
                        System.out.println("[Log] พบฤกษ์วันที่ " + dateKey + ": " + label);

                        Map<String, String> tag = new LinkedHashMap<>();
                        tag.put("type", "good");
                        tag.put("label", label);
                        tags.add(tag);
                    }
                } catch (Exception eventEx) {
                    System.err.println("[Error] ข้าม event: " + eventEx.getMessage());
                }
            }
        }
        return result;
    }
}