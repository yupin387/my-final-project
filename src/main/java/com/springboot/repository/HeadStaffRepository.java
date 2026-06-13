package com.springboot.repository;

import com.springboot.model.HeadStaff;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface HeadStaffRepository extends JpaRepository<HeadStaff, Integer> { 
    
    // เช็คว่ามีอีเมลนี้ในระบบหรือยัง (ใช้ตอนลงทะเบียนพนักงานใหม่)
    boolean existsByStaffEmail(String staffEmail);
    
    //ต้องเช็คทั้ง Email, Password และสถานะ isActive ต้องเป็น true เท่านั้น
    Optional<HeadStaff> findByStaffEmailAndStaffPasswordAndIsActiveTrue(String staffEmail, String staffPassword);
    
    // ค้นหาพนักงานที่ไม่ติดงานในวันที่ระบุ (ใช้ตอนมอบหมายงาน)
    @Query("SELECT s FROM HeadStaff s WHERE s.isActive = true AND s.staffId NOT IN " +
           "(SELECT q.staff.staffId FROM Quotation q " +
           " WHERE q.bookingForm.eventDate = :eventDate " +
           " AND q.staff IS NOT NULL)")
    List<HeadStaff> findAvailableStaff(@Param("eventDate") Date eventDate);
    
    // ดึงพนักงานเฉพาะคนที่มีสถานะเป็นใช้งานอยู่ (ใช้แสดงในหน้าจัดการพนักงานของ Organizer)
    List<HeadStaff> findByIsActiveTrue();
}