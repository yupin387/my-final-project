package com.springboot.repository;

import com.springboot.model.JobAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

@Repository
public interface JobAssignmentRepository extends JpaRepository<JobAssignment, String> {

    // ค้นหางานทั้งหมดของพนักงานคนนั้น
    List<JobAssignment> findByHeadStaff_StaffId(int staffId);

    // ค้นหางานโดยอ้างอิงจากรหัสการจอง
    JobAssignment findByBookingForm_BookingId(String bookingId);

    // ใช้ตอนลบหัวหน้างาน เพื่อตัดสินใจว่าจะ Hard Delete หรือ Soft Delete
    boolean existsByHeadStaff_StaffId(int staffId);

    // หารหัส assignId ที่มีค่ามากที่สุดในตาราง ใช้สำหรับ generate รหัสถัดไปแบบ running number
    @Query("SELECT MAX(sa.assignId) FROM JobAssignment sa")
    String findMaxAssignId();

    // ลบข้อมูลการมอบหมายงานทั้งหมดที่ผูกกับ bookingId ที่ระบุ (ใช้ตอนลบ/ยกเลิกการจองนั้น)
    @Modifying
    @Transactional
    @Query("DELETE FROM JobAssignment sa WHERE sa.bookingForm.bookingId = :bookingId")
    void deleteByBookingId(@Param("bookingId") String bookingId);
    
 // นับจำนวนงานที่หัวหน้างานคนนี้ยังรับผิดชอบอยู่ (ยังไม่ Completed) เพื่อดูภาระงานตอนมอบหมาย
    @Query("SELECT COUNT(sa) FROM JobAssignment sa " +
           "WHERE sa.headStaff.staffId = :staffId " +
           "AND sa.bookingForm.bookingStatus <> 'Completed'")
    int countActiveAssignmentsByStaffId(@Param("staffId") int staffId);
    
 // นับจำนวนงาน "ที่ยังไม่จบ" ของหัวหน้างานคนนี้ ในวันจัดงานเดียวกัน
 // (Completed และ Rejected ไม่นับ เพราะไม่ใช่ conflict จริง)
 @Query("SELECT COUNT(sa) FROM JobAssignment sa " +
        "WHERE sa.headStaff.staffId = :staffId " +
        "AND sa.bookingForm.eventDate = :eventDate " +
        "AND sa.bookingForm.bookingStatus IN ('Assigned', 'Preparing', 'In_Progress')")
 int countAssignmentsByStaffAndDate(@Param("staffId") int staffId, @Param("eventDate") java.util.Date eventDate);
}

    