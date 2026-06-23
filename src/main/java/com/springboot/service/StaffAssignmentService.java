package com.springboot.service;

import com.springboot.model.StaffAssignment;
import com.springboot.model.BookingForm;
import com.springboot.model.HeadStaff;
import com.springboot.repository.StaffAssignmentRepository;
import com.springboot.repository.BookingFormRepository;
import com.springboot.repository.HeadStaffRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Service
public class StaffAssignmentService {

    @Autowired
    private StaffAssignmentRepository staffAssignmentRepo;

    @Autowired
    private BookingFormRepository bookingRepo;

    @Autowired
    private HeadStaffRepository staffRepo;

    // ดึงรายการงานที่ได้รับมอบหมายทั้งหมดโดยกรองตามรหัสพนักงาน
    public List<StaffAssignment> getAssignmentsByStaff(int staffId) {
        return staffAssignmentRepo.findByHeadStaff_StaffId(staffId);
    }
    
 // ค้นหาข้อมูลการมอบหมายงานโดยระบุจาก Booking ID ของการจองนั้นๆ
    public StaffAssignment getAssignmentByBookingId(String bookingId) {
        return staffAssignmentRepo.findByBookingForm_BookingId(bookingId);
    }

    // สร้างการมอบหมายงานใหม่ โดยจะลบข้อมูลการมอบหมายเดิมของรายการจองนั้นก่อน
    @Transactional
    public void createNewAssignment(String bookingId, int staffId) {
        BookingForm booking = bookingRepo.findById(bookingId)
                .orElseThrow(() -> new RuntimeException("ไม่พบรหัสการจอง: " + bookingId));
        HeadStaff staff = staffRepo.findById(staffId)
                .orElseThrow(() -> new RuntimeException("ไม่พบรหัสพนักงาน ID: " + staffId));

        staffAssignmentRepo.deleteByBookingId(bookingId);

        String assignId = generateAssignId();

        StaffAssignment sa = new StaffAssignment();
        sa.setAssignId(assignId);
        sa.setBookingForm(booking);
        sa.setHeadStaff(staff);
        sa.setAssignDate(new java.util.Date());
        sa.setJobStatus("Assigned");

        staffAssignmentRepo.save(sa);
    }

    // สร้างรหัสการมอบหมายงานใหม่แบบรันตัวเลขโดยอัตโนมัติ (เช่น AN001, AN002)
    private String generateAssignId() {
        String maxId = staffAssignmentRepo.findMaxAssignId();
        int nextNum = 1;

        if (maxId != null && maxId.startsWith("AN")) {
            nextNum = Integer.parseInt(maxId.substring(2)) + 1;
        }
        return String.format("AN%03d", nextNum);
    }

    // ดึงข้อมูลรายละเอียดการมอบหมายงานชิ้นที่ต้องการตามรหัส ID
    public StaffAssignment getAssignmentById(String id) {
        return staffAssignmentRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("ไม่พบข้อมูลรหัส: " + id));
    }

    // อัปเดตสถานะความคืบหน้าของงานพร้อมกันทั้งในตารางการจองและตารางมอบหมายงาน
    @Transactional
    public void updateJobStatus(String bookingId, String newStatus) {
        BookingForm booking = bookingRepo.findById(bookingId).orElseThrow();
        booking.setBookingStatus(newStatus);
        bookingRepo.save(booking);

        StaffAssignment assignment = staffAssignmentRepo.findByBookingForm_BookingId(bookingId);
        if (assignment != null) {
            assignment.setJobStatus(newStatus);
            staffAssignmentRepo.save(assignment); 
        }
    }

    // บันทึกรายงานความเสียหายหลังจบงาน พร้อมจัดการอัปโหลดรูปภาพหลักฐาน
    @Transactional
    public void updateDamageReport(String assignId, String reportNote, MultipartFile[] files) throws IOException {
        StaffAssignment sa = staffAssignmentRepo.findById(assignId).orElseThrow();
        sa.setReportNote(reportNote);

        if (files != null && files.length > 0) {
            String rootPath = System.getProperty("user.dir");
            File uploadDir = new File(rootPath + File.separator + "uploads" + File.separator + "report");
            if (!uploadDir.exists()) uploadDir.mkdirs();

            StringBuilder reportImages = new StringBuilder();

            for (MultipartFile file : files) {
                if (file != null && !file.isEmpty()) {
                    String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                    File saveFile = new File(uploadDir.getAbsolutePath() + File.separator + fileName);
                    file.transferTo(saveFile);

                    if (reportImages.length() > 0) reportImages.append(",");
                    reportImages.append("report/").append(fileName);
                }
            }

            sa.setReportImage(reportImages.toString());
        }
    }
}