package com.springboot.controller.member;
 
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
import com.springboot.model.Review;
import com.springboot.service.BookingService;
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
    
    
 
    //  1. หน้าเขียนรีวิว
    @GetMapping("/review/write/{bookingId}")
    public String writeReview(@PathVariable String bookingId, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) return "redirect:/loginMember";
        
        BookingForm booking = bookingService.getBookingById(bookingId);
        // เช็คเงื่อนไข: ต้องเสร็จแล้ว และยังไม่เคยรีวิว
        if (!"Completed".equals(booking.getBookingStatus()) || reviewService.hasAlreadyReviewed(bookingId)) {
            return "redirect:/viewBooking/" + bookingId;
        }
 
        model.addAttribute("b", booking);
        return "review";
    }
 

    @PostMapping("/review/save")
    public String save(@ModelAttribute Review review, 
                       @RequestParam String bookingId,
                       @RequestParam("imageFile") MultipartFile file) throws IOException {
        
        BookingForm b = bookingService.getBookingById(bookingId);
        review.setBookingForm(b);
        review.setReviewDate(new Date()); 

        if (!file.isEmpty()) {
            String fileName = file.getOriginalFilename();
            
            // 1. กำหนดตำแหน่งที่จะเซฟไฟล์ (พาธที่ย้ายไปใหม่)
            String uploadDir = "uploads/review/";
            java.io.File dir = new java.io.File(uploadDir);
            if (!dir.exists()) dir.mkdirs(); // สร้างโฟลเดอร์ถ้ายังไม่มี
            
            // 2. บันทึกไฟล์ลง Disk
            java.nio.file.Path path = java.nio.file.Paths.get(uploadDir + fileName);
            java.nio.file.Files.copy(file.getInputStream(), path, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            
            review.setReviewImage(fileName); 
        }

        reviewService.saveReview(review); 
        return "redirect:/reviews";
    }
    
    //แก้ตรงนี้ ล่าสุด
    //  3. หน้าดูรีวิวของประเภทงานนั้นๆ (แยกตามงาน)
    // ใน ReviewController.java
 // แก้ไขเมธอดนี้ใน ReviewController
    @GetMapping("/reviews/{ceremonyId}")
    public String viewReviewsByCeremony(@PathVariable int ceremonyId, Model model) { // เปลี่ยนจาก @RequestParam เป็น @PathVariable
        List<Review> allReviews = reviewService.getAllReviews();
        
        // กรองตาม ID
        List<Review> reviews = allReviews.stream()
            .filter(r -> r.getBookingForm().getCeremony().getCeremonyId() == ceremonyId)
            .collect(Collectors.toList());
        
        // คำนวณค่าเฉลี่ย
        double avg = reviews.stream().mapToDouble(Review::getRating).average().orElse(0.0);
        Map<Long, Long> starCounts = reviews.stream()
                .collect(Collectors.groupingBy(r -> Math.round(r.getRating()), Collectors.counting()));
        
        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", avg);
        model.addAttribute("starCounts", starCounts);
        model.addAttribute("selectedCeremonyId", ceremonyId); // ส่งค่านี้ไปให้ JSP
        
        return "viewReview";
    }
    
    //  4. หน้าดูรีวิวทั้งหมด (รวมทุกงาน)
    @GetMapping("/reviews")
    public String viewAllReviews(Model model) {
        List<Review> reviews = reviewService.getAllReviews();
        
        double avg = reviews.stream()
                            .mapToDouble(Review::getRating)
                            .average()
                            .orElse(0.0);
        
        
        Map<Long, Long> starCounts = reviews.stream()
                .collect(Collectors.groupingBy(r -> Math.round(r.getRating()), Collectors.counting()));
        
        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", avg);
        model.addAttribute("starCounts", starCounts); 
        
        return "viewReview"; 
    }
}

 