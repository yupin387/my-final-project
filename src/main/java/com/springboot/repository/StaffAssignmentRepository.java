package com.springboot.repository;

import com.springboot.model.StaffAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

@Repository
public interface StaffAssignmentRepository extends JpaRepository<StaffAssignment, String> {
    
    // ค้นหางานทั้งหมดของพนักงานคนนั้น
    List<StaffAssignment> findByHeadStaff_StaffId(int staffId);

    // ค้นหางานโดยอ้างอิงจากรหัสการจอง
    StaffAssignment findByBookingForm_BookingId(String bookingId);

    // เก็บไว้เฉพาะถ้ายังต้องรันเลข ID เองแบบ AN001
    @Query("SELECT MAX(sa.assignId) FROM StaffAssignment sa")
    String findMaxAssignId();

    // เก็บไว้เฉพาะถ้าต้องใช้ล้างข้อมูลเก่าก่อน Assign คนใหม่ 
    @Modifying
    @Transactional
    @Query("DELETE FROM StaffAssignment sa WHERE sa.bookingForm.bookingId = :bookingId")
    void deleteByBookingId(@Param("bookingId") String bookingId);
}