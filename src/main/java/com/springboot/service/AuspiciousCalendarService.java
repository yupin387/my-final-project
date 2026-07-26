package com.springboot.service;

import java.io.InputStream;
import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import net.fortuna.ical4j.data.CalendarBuilder;
import net.fortuna.ical4j.model.Component;
import net.fortuna.ical4j.model.DateTime;
import net.fortuna.ical4j.model.Period;
import net.fortuna.ical4j.model.PeriodList;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.component.VEvent;

@Service
public class AuspiciousCalendarService {

    private static final Logger log = LoggerFactory.getLogger(AuspiciousCalendarService.class);

    private static final String ICS_URL = "https://calendar.google.com/calendar/ical/h61ifkc3ivsejr5kgtn2s6t4lc%40group.calendar.google.com/public/basic.ics";

    // ช่วงปีที่ต้องการขยาย recurring event (RRULE) ออกมาเป็นวันจริง
    // ปรับตัวเลขตรงนี้ให้ครอบคลุมช่วงที่ปฏิทินหน้าเว็บให้เลื่อนดูได้
    private static final int RANGE_START_YEAR = 2025;
    private static final int RANGE_END_YEAR = 2027;

    private static final List<String> MAIN_GOOD_LABELS = List.of(
            "วันราชาโชค", "วันมหาสิทธิโชค", "วันชัยโชค",
            "วันอัมฤตโชค", "วันอำมฤตโชค",
            "วันอธิบดี", "วันธงชัย", "วันสิทธิโชค"
    );

    private static String normalizeLabel(String raw) {
        if (raw == null)
            return "";
        String cleaned = raw.replaceAll("[\\p{Cntrl}]", "").replace("\u00A0", " ")
                .replace("\u200B", "")
                .replace("\uFEFF", "")
                .trim().replaceAll("\\s+", " ");
        return cleaned;
    }

    private static String normalizeAndStripSuffix(String raw) {
        String cleaned = normalizeLabel(raw);
        cleaned = cleaned.replaceAll("\\s*\\([^)]*\\)\\s*$", "").trim();
        return cleaned;
    }

    public Map<String, List<Map<String, String>>> fetchDayQuality() throws Exception {
        Map<String, List<Map<String, String>>> result = new LinkedHashMap<>();
        CalendarBuilder builder = new CalendarBuilder();

        // ช่วงเวลาที่จะใช้ "ขยาย" recurring event (RRULE) ให้ออกมาเป็นวันจริงแต่ละวัน
        DateTime rangeStart = new DateTime(
                java.sql.Timestamp.valueOf(LocalDate.of(RANGE_START_YEAR, 1, 1).atStartOfDay()));
        DateTime rangeEnd = new DateTime(
                java.sql.Timestamp.valueOf(LocalDate.of(RANGE_END_YEAR, 12, 31).atStartOfDay()));
        Period range = new Period(rangeStart, rangeEnd);

        try (InputStream in = new URL(ICS_URL).openStream()) {
            net.fortuna.ical4j.model.Calendar calendar = builder.build(in);

            for (Object c : calendar.getComponents(Component.VEVENT)) {
                try {
                    VEvent event = (VEvent) c;
                    Property summaryProp = event.getProperty(Property.SUMMARY);
                    if (summaryProp == null || summaryProp.getValue() == null
                            || summaryProp.getValue().isBlank()) {
                        continue;
                    }

                    String summary = summaryProp.getValue();
                    String cleanSummary = summary.replaceAll("[\\p{Cntrl}\\u00A0\\u200B\\uFEFF]", " ");
                    String[] labels = cleanSummary.split("[,\\/]");

                    // *** จุดสำคัญของการแก้ไข ***
                    // แทนที่จะอ่านแค่ DTSTART ตัวเดียวของ event
                    // ให้ขยาย recurring event (ถ้ามี RRULE) ออกมาเป็นทุกวันจริง
                    // ภายในช่วง range ที่กำหนดไว้ด้านบน
                    PeriodList periods = event.calculateRecurrenceSet(range);

                    for (Object po : periods) {
                        Period p = (Period) po;
                        String rawDate = p.getStart().toString();
                        // รองรับทั้งกรณี date-only (yyyyMMdd) และ date-time (yyyyMMdd'T'HHmmss...)
                        String datePart = rawDate.length() >= 8 ? rawDate.substring(0, 8) : rawDate;
                        LocalDate date = LocalDate.parse(datePart, DateTimeFormatter.BASIC_ISO_DATE);
                        String dateKey = date.toString();

                        log.debug("[ICS] {} => {}", dateKey, summary);

                        List<Map<String, String>> tags = result.computeIfAbsent(dateKey, k -> new ArrayList<>());

                        for (String rawLabel : labels) {
                            String label = normalizeAndStripSuffix(rawLabel);
                            if (label.isEmpty()) {
                                continue;
                            }
                            log.debug("พบฤกษ์วันที่ {}: {}", dateKey, label);

                            Map<String, String> tag = new LinkedHashMap<>();
                            tag.put("type", "good");
                            tag.put("label", label);
                            tags.add(tag);
                        }
                    }
                } catch (Exception eventEx) {
                    log.warn("ข้าม event เนื่องจากเกิดข้อผิดพลาด: {}", eventEx.getMessage());
                }
            }
        }
        return result;
    }
}