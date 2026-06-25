package com.springboot.repository;

import com.springboot.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Integer> { 
    
    //  ค้นหารีวิวผ่าน Booking ID (ซึ่งเป็น String)
    Review findByBookingForm_BookingId(String bookingId);
    
 //  ดึงรีวิว 2 อันล่าสุด โดยเรียงตาม reviewId จากมากไปน้อย
    List<Review> findTop2ByOrderByReviewIdDesc();
}
