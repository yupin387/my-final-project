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
                       @RequestParam(value = "imageFile", required = false) List<MultipartFile> imageFiles) throws IOException {

        BookingForm b = bookingService.getBookingById(bookingId);
        review.setBookingForm(b);
        review.setReviewDate(new Date());

        // จัดการอัปโหลดหลายรูป (คั่นด้วย comma หรือเลือกรูปลักษณะที่รองรับในฐานข้อมูลของคุณ)
        if (imageFiles != null && !imageFiles.isEmpty()) {
            List<String> savedFileNames = new ArrayList<>();
            String uploadDir = "uploads/review/";
            java.io.File dir = new java.io.File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            for (MultipartFile file : imageFiles) {
                if (file != null && !file.isEmpty()) {
                    String fileName = file.getOriginalFilename();
                    java.nio.file.Path path = java.nio.file.Paths.get(uploadDir + fileName);
                    java.nio.file.Files.copy(file.getInputStream(), path, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    savedFileNames.add(fileName);
                }
            }
            
            // ถ้าฐานข้อมูลเก็บเป็น string เดียวรวมกัน ให้ใช้เครื่องหมายจุลภาคคั่น เช่น "img1.jpg,img2.jpg"
            if (!savedFileNames.isEmpty()) {
                review.setReviewImage(String.join(",", savedFileNames));
            }
        }

        reviewService.saveReview(review);
        return "redirect:/reviews";
    }

    // 3. หน้าดูรีวิวของประเภทงานนั้นๆ (แยกตาม ceremonyId เดี่ยว ๆ)
    @GetMapping("/reviews/{ceremonyId}")
    public String viewReviewsByCeremony(@PathVariable int ceremonyId,
                                         @RequestParam(value = "rating", required = false) Integer rating,
                                         @RequestParam(value = "page", defaultValue = "1") int page,
                                         Model model) {
        List<Review> allReviews = reviewService.getAllReviews();

        List<Review> reviewsForStats = allReviews.stream()
            .filter(r -> r.getBookingForm().getCeremony().getCeremonyId() == ceremonyId)
            .collect(Collectors.toList());

        List<Review> reviews = reviewsForStats;
        if (rating != null) {
            reviews = reviews.stream()
                .filter(r -> Math.round(r.getRating()) == rating)
                .collect(Collectors.toList());
        }

        // --- ระบบ Pagination (หน้าละ 9 รีวิว) ---
        int pageSize = 9;
        int totalReviews = reviews.size();
        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;
        if (page < 1) page = 1;

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalReviews);
        List<Review> pagedReviews = (start <= end) ? reviews.subList(start, end) : new ArrayList<>();
        // ----------------------------------------

        double avg = reviewsForStats.stream().mapToDouble(Review::getRating).average().orElse(0.0);
        Map<Long, Long> starCounts = reviewsForStats.stream()
                .collect(Collectors.groupingBy(r -> Math.round(r.getRating()), Collectors.counting()));

        model.addAttribute("reviews", pagedReviews); // ใช้ list ที่ตัดแล้วแสดงผล
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("avgRating", avg);
        model.addAttribute("starCounts", starCounts);
        model.addAttribute("selectedCeremonyId", ceremonyId);
        model.addAttribute("selectedRating", rating);
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
    // FIX: avgRating / starCounts เดิมคำนวณจาก list ที่กรองด้วย rating ไปแล้ว ทำให้พอกด
    // กรองดาวไหน แถบสัดส่วนของดาวอื่นกลายเป็น 0 และคะแนนเฉลี่ยก็เปลี่ยนไปเท่ากับดาวที่กรอง
    // อยู่ ซึ่งไม่ถูกต้อง — ตอนนี้แยกเป็น reviewsForStats (กรองแค่ type) ใช้คำนวณ avg/starCounts
    // ให้คงที่ตามประเภทงานที่เลือก ไม่ขึ้นกับ rating ที่กด ส่วน reviews (การ์ดที่แสดงจริง)
    // ค่อยกรองต่อด้วย rating จาก reviewsForStats อีกที
    @GetMapping("/reviews")
    public String viewAllReviews(
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "rating", required = false) Integer rating,
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {

        List<Review> allReviews = reviewService.getAllReviews();

        List<Review> reviewsForStats = allReviews;
        if (type != null && !type.trim().isEmpty()) {
            String typeTrimmed = type.trim();
            reviewsForStats = reviewsForStats.stream()
                .filter(r -> r.getBookingForm() != null
                        && r.getBookingForm().getCeremony() != null
                        && typeTrimmed.equals(
                            r.getBookingForm().getCeremony().getCeremonyType() == null
                                ? ""
                                : r.getBookingForm().getCeremony().getCeremonyType().trim()))
                .collect(Collectors.toList());
        }

        List<Review> reviews = reviewsForStats;
        if (rating != null) {
            reviews = reviews.stream()
                .filter(r -> Math.round(r.getRating()) == rating)
                .collect(Collectors.toList());
        }

        // --- ระบบ Pagination (หน้าละ 9 รีวิว) ---
        int pageSize = 9;
        int totalReviews = reviews.size();
        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;
        if (page < 1) page = 1;

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalReviews);
        List<Review> pagedReviews = (start <= end) ? reviews.subList(start, end) : new ArrayList<>();
        // ----------------------------------------

        double avg = reviewsForStats.stream()
                            .mapToDouble(Review::getRating)
                            .average()
                            .orElse(0.0);

        Map<Long, Long> starCounts = reviewsForStats.stream()
                .collect(Collectors.groupingBy(r -> Math.round(r.getRating()), Collectors.counting()));

        model.addAttribute("reviews", pagedReviews); // ใช้ list ที่ตัดแล้วแสดงผล
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("avgRating", avg);
        model.addAttribute("starCounts", starCounts);
        model.addAttribute("selectedCeremonyType", type);
        model.addAttribute("selectedRating", rating);
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