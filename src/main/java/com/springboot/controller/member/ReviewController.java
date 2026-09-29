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
import com.springboot.model.Package;
import com.springboot.model.Review;
import com.springboot.service.BookingService;
import com.springboot.service.PackageService;
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


    @Autowired
    private PackageService packageService;

    // หน้าเขียนรีวิว: ต้องล็อกอิน + งานต้อง Completed + ยังไม่เคยรีวิว ไม่งั้น redirect ออก
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

    // บันทึกรีวิว: ผูกกับ booking, ตั้งวันที่, อัปโหลดรูปหลายไฟล์ (เก็บชื่อไฟล์คั่นด้วย comma) แล้ว redirect ไปหน้า /reviews
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

    // หน้าดูรีวิวตามแพ็กเกจ (ceremonyId): กรองตามดาว, แบ่งหน้าละ 9, คำนวณคะแนนเฉลี่ย + จำนวนแต่ละดาว
    @GetMapping("/reviews/{ceremonyId}")
    public String viewReviewsByCeremony(@PathVariable int ceremonyId,
                                         @RequestParam(value = "rating", required = false) Integer rating,
                                         @RequestParam(value = "page", defaultValue = "1") int page,
                                         Model model) {
        List<Review> allReviews = reviewService.getAllReviews();

        List<Review> reviewsForStats = allReviews.stream()
            .filter(r -> r.getBookingForm().getPackageEntity().getPackageId() == ceremonyId)
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

    // หน้าดูรีวิวทั้งหมด: กรองตามประเภทงาน (type) และดาว (rating) ได้, แบ่งหน้าละ 9, คำนวณคะแนนเฉลี่ย + จำนวนแต่ละดาว
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
                        && r.getBookingForm().getPackageEntity() != null
                        && typeTrimmed.equals(
                            r.getBookingForm().getPackageEntity().getPackageType() == null
                                ? ""
                                : r.getBookingForm().getPackageEntity().getPackageType().trim()))
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

        model.addAttribute("reviews", pagedReviews); 
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("avgRating", avg);
        model.addAttribute("starCounts", starCounts);
        model.addAttribute("selectedCeremonyType", type);
        model.addAttribute("selectedRating", rating);
        model.addAttribute("ceremonyTypes", buildCeremonyTypesForFooter());

        return "viewReview";
    }

    // จัดกลุ่มแพ็กเกจตาม packageType แล้วเลือกตัวแทนที่ราคาถูกที่สุดของแต่ละกลุ่ม ไว้ทำลิงก์ใน footer/dropdown "บริการ/แพ็กเกจ"
    private List<Map<String, Object>> buildCeremonyTypesForFooter() {
        List<Package> all = packageService.getAllPackages();
        Map<String, List<Package>> grouped = all.stream()
            .collect(Collectors.groupingBy(
                c -> c.getPackageType() == null ? "" : c.getPackageType().trim(),
                LinkedHashMap::new,
                Collectors.toList()
            ));
        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, List<Package>> entry : grouped.entrySet()) {
            List<Package> packages = entry.getValue();
            packages.sort(Comparator.comparingDouble(Package::getBasePrice));
            Package representative = packages.get(0);

            Map<String, Object> m = new LinkedHashMap<>();
            m.put("mainName", entry.getKey());
            m.put("representativeId", representative.getPackageId());
            result.add(m);
        }
        return result;
    }

  
}