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

    // ✅ แก้ไขตรงนี้: เปลี่ยนเป็น JobAssignment
    @Query("SELECT MAX(sa.assignId) FROM JobAssignment sa")
    String findMaxAssignId();

    // ✅ แก้ไขตรงนี้: เปลี่ยนเป็น JobAssignment
    @Modifying
    @Transactional
    @Query("DELETE FROM JobAssignment sa WHERE sa.bookingForm.bookingId = :bookingId")
    void deleteByBookingId(@Param("bookingId") String bookingId);
}