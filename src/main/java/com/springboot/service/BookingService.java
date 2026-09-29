package com.springboot.service;

import com.springboot.model.*;
import com.springboot.repository.BookingFormRepository;
import com.springboot.repository.QuestionsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class BookingService {

    @Autowired
    private BookingFormRepository bookingRepo;

    @Autowired
    private QuestionsRepository questionsRepo;

    // จำนวนคิวสูงสุดที่รับได้ต่อวันจัดงาน
    private static final int MAX_BOOKINGS_PER_DAY = 2;

    // =================================================================================
    // ส่วนที่ 1: สำหรับ Member & Manager (การจองเริ่มต้น จนถึง การพิจารณาอนุมัติ)
    // =================================================================================

    // Member: บันทึกการจองใหม่ สร้าง ID อัตโนมัติ ตั้งสถานะ Pending และคัดคำตอบซ้ำของคำถามเดียวกันออก
    @Transactional
    public BookingForm saveBooking(BookingForm booking) {
        booking.setBookingId(generateBookingId());
        booking.setBookingDate(new Date());
        booking.setBookingStatus("Pending");

        if (booking.getDetails() != null) {

            // เก็บคำตอบล่าสุดของแต่ละคำถาม (questionsId ซ้ำจะถูกทับ)
            Map<Integer, BookingFormDetail> uniqueMap = new LinkedHashMap<>();
            for (BookingFormDetail d : booking.getDetails()) {
                if (d.getQuestion() != null) {
                    uniqueMap.put(d.getQuestion().getQuestionsId(), d);
                }
            }

            // ผูกคำตอบเข้ากับ Question จริงจาก DB และผูกกลับมาที่ booking
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

    // Member: ดึงการจองล่าสุดของตนเอง (คืน null ถ้าไม่มี)
    public BookingForm getLatestBookingByMember(int memberId) {
        List<BookingForm> results = bookingRepo.findLatestByMemberId(memberId);
        return (results != null && !results.isEmpty()) ? results.get(0) : null;
    }

    // Manager: อนุมัติการจอง (เช็คคิวเต็มต่อวันก่อน แล้วเปลี่ยนสถานะเป็น Approved)
    @Transactional
    public void approveBooking(String id) throws Exception {
        BookingForm booking = bookingRepo.findById(id)
                .orElseThrow(() -> new Exception("ไม่พบข้อมูลการจองรหัส: " + id));

        int existingCount = bookingRepo.countActiveBookingsByEventDate(booking.getEventDate());
        if (existingCount >= MAX_BOOKINGS_PER_DAY) {
            throw new Exception("วันที่จัดงานนี้มีการจองครบ " + MAX_BOOKINGS_PER_DAY + " คิวแล้ว ไม่สามารถอนุมัติเพิ่มได้");
        }

        updateStatus(id, "Approved");
    }

    // Manager/Member: ปฏิเสธหรือยกเลิกการจอง (เปลี่ยนสถานะเป็น Rejected พร้อมเหตุผล)
    @Transactional
    public void rejectBooking(String id, String rejectDetail) throws Exception {
        BookingForm booking = bookingRepo.findById(id)
                .orElseThrow(() -> new Exception("ไม่พบข้อมูลการจองรหัส: " + id));

        booking.setBookingStatus("Rejected");
        booking.setRejectDetail(rejectDetail);

        bookingRepo.save(booking);
    }

    // (Internal) สร้างรหัสการจองอัตโนมัติ BK + ตัวเลข 3 หลัก เช่น BK001
    private String generateBookingId() {
        String maxId = bookingRepo.findMaxBookingId();
        int nextNum = 1;
        if (maxId != null && maxId.startsWith("BK")) {
            nextNum = Integer.parseInt(maxId.substring(2)) + 1;
        }
        return String.format("BK%03d", nextNum);
    }

    // =================================================================================
    // ส่วนที่ 2: สำหรับ Manager (ช่วงปลาย) & Head Staff (รายการยืนยัน และงานหน้างาน)
    // =================================================================================

    // ดึงรายการตามหลายสถานะพร้อมกัน (เช่น Confirmed, Assigned, Preparing, In_Progress)
    public List<BookingForm> getBookingsByStatuses(List<String> statuses) {
        return bookingRepo.findByStatusIn(statuses);
    }

    // ดึงรายการตามสถานะเดียว
    public List<BookingForm> findByStatus(String status) {
        return bookingRepo.findByStatus(status);
    }

    // ดึงรายละเอียดการจองรายตัว (คืน null ถ้าไม่พบ)
    public BookingForm getBookingById(String id) {
        return bookingRepo.findById(id).orElse(null);
    }

    // เปลี่ยนสถานะเป็น Assigned เมื่อมอบหมายหัวหน้างานเสร็จสิ้น
    @Transactional
    public void assignStaffToBooking(String id) {
        updateStatus(id, "Assigned");
    }

    // อัปเดตสถานะการจองตามที่ระบุ (ใช้ตอนสร้างใบเสนอราคาเสร็จ เพื่อตั้งเป็น Approved)
    @Transactional
    public void updateJobStatus(String id, String newStatus) {
        updateStatus(id, newStatus);
    }

    // ดึงรายการจองทั้งหมดจากฐานข้อมูล
    public List<BookingForm> getAllBookings() {
        return bookingRepo.findAll();
    }

    // Member: ดึงรายการจองทั้งหมดของตนเอง (ใช้ในหน้า list)
    public List<BookingForm> getBookingsByMember(int memberId) {
        return bookingRepo.findByMemberId(memberId);
    }

    // เมธอดกลางสำหรับอัปเดตสถานะ (อาศัย Dirty Checking ของ JPA ภายใน @Transactional)
    private void updateStatus(String id, String status) {
        BookingForm booking = bookingRepo.findById(id).orElse(null);
        if (booking != null) {
            booking.setBookingStatus(status);
        }
    }
}