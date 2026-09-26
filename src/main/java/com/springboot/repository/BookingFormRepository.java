package com.springboot.repository;

import com.springboot.model.BookingForm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;


@Repository
public interface BookingFormRepository extends JpaRepository<BookingForm, String> {
    
    // ดึงรายการจองตามสถานะเดียว เรียงตามวันที่จองล่าสุด
    @Query("SELECT b FROM BookingForm b WHERE b.bookingStatus = :status ORDER BY b.bookingDate DESC")
    List<BookingForm> findByStatus(@Param("status") String status);

    // ดึงรายการจองตามหลายสถานะพร้อมกัน เรียงตามวันจัดงาน
    @Query("SELECT b FROM BookingForm b WHERE b.bookingStatus IN :statuses ORDER BY b.eventDate ASC")
    List<BookingForm> findByStatusIn(@Param("statuses") List<String> statuses);

    // หา ID ที่มากที่สุดเพื่อใช้ในการรันเลขใหม่
    @Query("SELECT MAX(b.bookingId) FROM BookingForm b")
    String findMaxBookingId();
    
    // หาการจองล่าสุดของสมาชิก
    @Query("SELECT b FROM BookingForm b WHERE b.member.memberId = :memberId ORDER BY b.bookingId DESC")
    List<BookingForm> findLatestByMemberId(@Param("memberId") Integer memberId);
    
    // หาการจองทั้งหมดของสมาชิกคนนี้ เรียงจากล่าสุดไปเก่าสุด
    @Query("SELECT b FROM BookingForm b WHERE b.member.memberId = :memberId ORDER BY b.bookingDate DESC")
    List<BookingForm> findByMemberId(@Param("memberId") Integer memberId);

    // นับจำนวน booking ที่ "รับเข้าระบบแล้ว" (ไม่นับ Pending ที่ยังไม่ตัดสินใจ และไม่นับ Rejected)
    // ในวันจัดงานเดียวกัน ใช้เช็ค cap 2 คิว/วัน ตอนจะอนุมัติ
    @Query("SELECT COUNT(b) FROM BookingForm b " +
           "WHERE b.eventDate = :eventDate " +
           "AND b.bookingStatus NOT IN ('Pending', 'Rejected')")
    int countActiveBookingsByEventDate(@Param("eventDate") java.util.Date eventDate);
    
}