package com.springboot.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.springboot.model.Review;
import com.springboot.repository.ReviewRepository;
import java.util.List;

@Service
public class ReviewService {
	
    @Autowired
    private ReviewRepository reviewRepository;
    
    // ดึงรีวิวทั้งหมดในระบบ
    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }
 
    // บันทึกรีวิวใหม่
    @Transactional
    public void saveReview(Review review) { reviewRepository.save(review); }
 
    // เช็คว่าการจองนี้เคยรีวิวแล้วหรือยัง
    public boolean hasAlreadyReviewed(String bookingId) {
        return reviewRepository.findByBookingForm_BookingId(bookingId) != null;
    }
    
    //---------------------------------------------
}