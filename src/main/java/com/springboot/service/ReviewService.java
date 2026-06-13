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
    
    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }
 
    @Transactional
    public void saveReview(Review review) { reviewRepository.save(review); }
 
    public boolean hasAlreadyReviewed(String bookingId) {
        return reviewRepository.findByBookingForm_BookingId(bookingId) != null;
    }

    public List<Review> getTop2RecentReviews() {
        return reviewRepository.findTop2ByOrderByReviewIdDesc();
    }
}