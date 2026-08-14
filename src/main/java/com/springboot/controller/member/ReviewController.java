package com.springboot.controller.member;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.model.BookingForm;
import com.springboot.model.Ceremony;
import com.springboot.model.Review;
import com.springboot.service.BookingService;
import com.springboot.service.CeremonyService;
import com.springboot.service.ReviewService;

import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;

@Controller
public class ReviewController {
    @Autowired
    private ReviewService reviewService;

    @Autowired
    private BookingService bookingService;

    // เพิ่มเข้ามาเพื่อดึง ceremonyTypes ให้ dropdown "บริการ/แพ็กเกจ" ใน navbar
    // และเพื่อ map ระหว่าง ceremonyType (string) กับ representativeId ตอนสร้างเมนู
    @Autowired
    private CeremonyService ceremonyService;

    // 1. หน้าเขียนรีวิว
    @GetMapping("/review/write/{bookingId}")
    public String writeReview(@PathVariable String bookingId, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) return "redirect:/loginMember";

        BookingForm booking = bookingService.getBookingById(bookingId);
        if (booking == null) return "redirect:/home";

        if (!"Completed".equals(booking.getBookingStatus()) || reviewService.hasAlreadyReviewed(bookingId)) {
            return "redirect:/viewBooking/" + bookingId;
        }

        model.addAttribute("b", booking);
        return "review";
    }

    @PostMapping("/review/save")
    public String save(@ModelAttribute Review review,
                       @RequestParam String bookingId,
                       @RequestParam(value = "imageFile", required = false) MultipartFile file) throws IOException {

        BookingForm b = bookingService.getBookingById(bookingId);
        review.setBookingForm(b);
        review.setReviewDate(new Date());

        if (file != null && !file.isEmpty()) {
            String fileName = file.getOriginalFilename();

            String uploadDir = "uploads/review/";
            java.io.File dir = new java.io.File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            java.nio.file.Path path = java.nio.file.Paths.get(uploadDir + fileName);
            java.nio.file.Files.copy(file.getInputStream(), path, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

            review.setReviewImage(fileName);
        }

        reviewService.saveReview(review);
        return "redirect:/reviews";
    }

    // 3. หน้าดูรีวิวของประเภทงานนั้นๆ (แยกตาม ceremonyId เดี่ยว ๆ)
    @GetMapping("/reviews/{ceremonyId}")
    public String viewReviewsByCeremony(@PathVariable int ceremonyId,
                                         @RequestParam(value = "rating", required = false) Integer rating,
                                         Model model) {
        List<Review> allReviews = reviewService.getAllReviews();

        List<Review> reviews = allReviews.stream()
            .filter(r -> r.getBookingForm().getCeremony().getCeremonyId() == ceremonyId)
            .collect(Collectors.toList());

        // FIX: เพิ่มกรองตามจำนวนดาว เหมือนกับใน viewAllReviews() เพื่อให้ rating-bars
        // ที่กดได้ในหน้านี้ทำงานสอดคล้องกัน (คำนวณจาก Math.round เหมือน starCounts ด้านล่าง)
        if (rating != null) {
            reviews = reviews.stream()
                .filter(r -> Math.round(r.getRating()) == rating)
                .collect(Collectors.toList());
        }

        double avg = reviews.stream().mapToDouble(Review::getRating).average().orElse(0.0);
        Map<Long, Long> starCounts = reviews.stream()
                .collect(Collectors.groupingBy(r -> Math.round(r.getRating()), Collectors.counting()));

        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", avg);
        model.addAttribute("starCounts", starCounts);
        model.addAttribute("selectedCeremonyId", ceremonyId);
        model.addAttribute("selectedRating", rating); // FIX: ส่งกลับไปให้ JSP ไฮไลต์แถบดาวที่เลือกอยู่

        // FIX: เดิมหน้านี้ไม่ได้ set ceremonyTypes ทำให้เมนู dropdown "บริการ/แพ็กเกจ"
        // ใน navbar ของ viewReview.jsp ว่างเปล่า
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());

        return "viewReview";
    }

    // 4. หน้าดูรีวิวทั้งหมด (รวมทุกงาน) + รองรับกรองตามประเภทงานผ่าน query param "type"
    // และกรองตามจำนวนดาวผ่าน query param "rating"
    // FIX: เดิมเมธอดนี้ไม่รับพารามิเตอร์ "type" เลย ทำให้ปุ่มกรอง (btn-filter) ใน
    // viewReview.jsp ที่ลิงก์ไป /reviews?type=ทำบุญบ้าน ฯลฯ ไม่มีผลอะไร (แสดงรีวิวทั้งหมดเสมอ
    // และ ${selectedCeremonyType} ก็ไม่เคยมีค่า ปุ่ม active-link เลยไม่ทำงานด้วย)
    // FIX: เพิ่มพารามิเตอร์ "rating" เพื่อให้กดที่แถบสัดส่วนดาวใน summary-card แล้วกรอง
    // เฉพาะรีวิวที่ได้คะแนนตามดาวนั้น ๆ ได้ (ใช้ร่วมกับ type พร้อมกันได้)
    @GetMapping("/reviews")
    public String viewAllReviews(
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "rating", required = false) Integer rating,
            Model model) {

        List<Review> allReviews = reviewService.getAllReviews();

        List<Review> reviews = allReviews;
        if (type != null && !type.trim().isEmpty()) {
            String typeTrimmed = type.trim();
            reviews = reviews.stream()
                .filter(r -> r.getBookingForm() != null
                        && r.getBookingForm().getCeremony() != null
                        && typeTrimmed.equals(
                            r.getBookingForm().getCeremony().getCeremonyType() == null
                                ? ""
                                : r.getBookingForm().getCeremony().getCeremonyType().trim()))
                .collect(Collectors.toList());
        }

        // FIX: กรองตามดาว — ปัดเศษด้วย Math.round เหมือนตอนสร้าง starCounts ด้านล่าง
        // เพื่อให้ rating=4 ครอบคลุมรีวิวที่ให้คะแนน 3.5-4.4 ตามเกณฑ์เดียวกับที่แสดงในแถบสัดส่วน
        if (rating != null) {
            reviews = reviews.stream()
                .filter(r -> Math.round(r.getRating()) == rating)
                .collect(Collectors.toList());
        }

        double avg = reviews.stream()
                            .mapToDouble(Review::getRating)
                            .average()
                            .orElse(0.0);

        Map<Long, Long> starCounts = reviews.stream()
                .collect(Collectors.groupingBy(r -> Math.round(r.getRating()), Collectors.counting()));

        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", avg);
        model.addAttribute("starCounts", starCounts);
        model.addAttribute("selectedCeremonyType", type);
        model.addAttribute("selectedRating", rating); // FIX: ส่งกลับไปให้ JSP ไฮไลต์ปุ่ม/แถบดาวที่เลือกอยู่

        // FIX: เพิ่ม ceremonyTypes ให้ dropdown "บริการ/แพ็กเกจ" ใน navbar ของ viewReview.jsp
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());

        return "viewReview";
    }

    /*
     * ใช้ logic เดียวกับ buildCeremonyTypesForFooter() ใน BookingFormController /
     * buildCeremonyTypes() ใน UserController: จัดกลุ่มพิธีตาม ceremonyType แล้วเลือก
     * ตัวแทน (representative) ที่ราคาถูกที่สุดของแต่ละกลุ่ม เพื่อใช้เป็นลิงก์ไปหน้า
     * /ceremony/detail/{id} ใน dropdown "บริการ/แพ็กเกจ"
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

    //======================
}