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
	private static final String ICS_URL = "https://calendar.google.com/calendar/ical/h61ifkc3ivsejr5kgtn2s6t4lc%40group.calendar.google.com/public/basic.ics";

	private static final List<String> MAIN_GOOD_LABELS = List.of("วันราชาโชค", "วันมหาสิทธิโชค", "วันชัยโชค",
			"วันอัมฤตโชค", "วันอำมฤตโชค",
			"วันอธิบดี", "วันธงชัย", "วันสิทธิโชค");

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

		try (InputStream in = new URL(ICS_URL).openStream()) {

			net.fortuna.ical4j.model.Calendar calendar = builder.build(in);

			for (Object c : calendar.getComponents(Component.VEVENT)) {

				try {

					VEvent event = (VEvent) c;

					Property dtStartProp = event.getProperty(Property.DTSTART);

					Property summaryProp = event.getProperty(Property.SUMMARY);

					if (dtStartProp == null || summaryProp == null) {

						continue;
					}

					String datePart = dtStartProp.getValue().substring(0, 8);

					LocalDate date = LocalDate.parse(datePart, DateTimeFormatter.BASIC_ISO_DATE);

					String dateKey = date.toString();

					String summary = summaryProp.getValue();

					if (summary == null || summary.isBlank()) {

						continue;
					}

					System.out.println("[ICS] " + dateKey + " => " + summary);

					String cleanSummary = summary.replaceAll("[\\p{Cntrl}\\u00A0\\u200B\\uFEFF]", " ");

					String[] labels = cleanSummary.split("[,\\/]");

					List<Map<String, String>> tags = result.computeIfAbsent(dateKey, k -> new ArrayList<>());

					for (String rawLabel : labels) {

						String label = normalizeAndStripSuffix(rawLabel);

						if (label.isEmpty()) {

							continue;
						}

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