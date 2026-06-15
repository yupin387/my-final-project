package com.springboot.service;
 
import com.springboot.model.*;
import com.springboot.repository.BookingFormRepository;
import com.springboot.repository.QuestionsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;
 
@Service
public class BookingService {
 
    @Autowired
    private BookingFormRepository bookingRepo;
    
    @Autowired
    private QuestionsRepository questionsRepo;

    // =================================================================================
    // ส่วนที่ 1: สำหรับ Member & Organizer (การจองเริ่มต้น จนถึง การพิจารณาอนุมัติ)
    // =================================================================================
 
    /**
     * สำหรับ Member: บันทึกการจองใหม่ เจน ID อัตโนมัติ และคัดกรองคำถาม
     */
    @Transactional
    public BookingForm saveBooking(BookingForm booking) {
        booking.setBookingId(generateBookingId());
        booking.setBookingDate(new Date());
        booking.setBookingStatus("Pending");

        if (booking.getDetails() != null) {
            
            Map<Integer, BookingFormDetail> uniqueMap = new LinkedHashMap<>();
            for (BookingFormDetail d : booking.getDetails()) {
                if (d.getQuestion() != null) {
                    uniqueMap.put(d.getQuestion().getQuestionsId(), d);
                }
            }
            
            List<BookingFormDetail> filteredDetails = new ArrayList<>(uniqueMap.values());
            for (BookingFormDetail detail : filteredDetails) {
                QuestionsDetail realQ = questionsRepo.findById(detail.getQuestion().getQuestionsId()).orElse(null);
                if (realQ != null) {
                    detail.setQuestion(realQ);
                    detail.setBookingForm(booking);
                }
            }
            booking.setDetails(filteredDetails);
        }
        return bookingRepo.save(booking);
    }

    /**
     * สำหรับ Member: ดูสถานะการจองล่าสุดของตนเอง
     */
    public BookingForm getLatestBookingByMember(int memberId) {
        List<BookingForm> results = bookingRepo.findLatestByMemberId(memberId);
        return (results != null && !results.isEmpty()) ? results.get(0) : null;
    }

    /**
     * สำหรับ Organizer: อนุมัติการจอง (เปลี่ยนสถานะเป็น Approved)
     */
    @Transactional
    public void approveBooking(String id) {
        updateStatus(id, "Approved");
    }

    /**
     * สำหรับ Organizer: ปฏิเสธการจอง (เปลี่ยนสถานะเป็น Rejected)
     */
    @Transactional
    public void rejectBooking(String id) {
        updateStatus(id, "Rejected");
    }

    /**
     * (Internal) สร้างรหัสการจองอัตโนมัติ BK + ตัวเลข 3 หลัก
     */
    private String generateBookingId() {
        String maxId = bookingRepo.findMaxBookingId();
        int nextNum = 1;
        if (maxId != null && maxId.startsWith("BK")) {
            nextNum = Integer.parseInt(maxId.substring(2)) + 1;
        }
        return String.format("BK%03d", nextNum);
    }


    // =================================================================================
    // ส่วนที่ 2: สำหรับ Organizer (ช่วงปลาย) & Head Staff (รายการยืนยัน และงานหน้างาน)
    
    // =================================================================================

    // สำหรับ Organizer: ดึงรายการตามกลุ่มสถานะ (เช่น ดึงเฉพาะที่ Approved เพื่อเตรียมออกใบเสนอราคา)
    public List<BookingForm> getBookingsByStatuses(List<String> statuses) {
        return bookingRepo.findByStatusIn(statuses);
    }

    // สำหรับค้นหาตามสถานะเดี่ยว
    public List<BookingForm> findByStatus(String status) {
        return bookingRepo.findByStatus(status);
    }

    // สำหรับดูรายละเอียดการจองรายบุคคล
    public BookingForm getBookingById(String id) {
        return bookingRepo.findById(id).orElse(null);
    }

    // สำหรับเปลี่ยนสถานะเป็น Assigned เมื่อมอบหมายพนักงานในหน้าใบเสนอราคาเสร็จสิ้น
    @Transactional
    public void assignStaffToBooking(String id) {
        updateStatus(id, "Assigned");
    }
 
    // สำหรับอัปเดตสถานะงาน (เช่น In Progress, Completed)
    @Transactional
    public void updateJobStatus(String id, String newStatus) {
        updateStatus(id, newStatus);
    }

    // (Common) เมทธอดกลางสำหรับอัปเดตสถานะ (ใช้ระบบ Dirty Checking)
    private void updateStatus(String id, String status) {
        BookingForm booking = bookingRepo.findById(id).orElse(null);
        if (booking != null) {
            booking.setBookingStatus(status);
            
        }
    }
    
    // สำหรับดึงรายการจองทั้งหมดจากฐานข้อมูล
    public List<BookingForm> getAllBookings() {
        return bookingRepo.findAll(); 
    }
    
    
    
    //=================================================================================================
    //=================================================================================================
}