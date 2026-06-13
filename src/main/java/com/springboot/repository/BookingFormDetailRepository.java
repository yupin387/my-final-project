package com.springboot.repository;

import com.springboot.model.BookingFormDetail;
import com.springboot.model.BookingFormDetailId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookingFormDetailRepository extends JpaRepository<BookingFormDetail, BookingFormDetailId> { 
   
}