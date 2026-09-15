package com.springboot.service;

import com.springboot.model.HeadStaff;
import com.springboot.repository.HeadStaffRepository;
import org.springframework.transaction.annotation.Transactional; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class HeadStaffService {

    @Autowired
    private HeadStaffRepository headStaffRepository;

    @Autowired
    private EmailService emailService;  
    
    @Autowired
    private QuotationService quotationService;   

    @Autowired
    private JobAssignmentService jobAssignmentService;   


    // ตรวจสอบการเข้าสู่ระบบโดยเช็กอีเมล รหัสผ่าน และต้องมีสถานะบัญชีที่ยังใช้งานอยู่ (Active)
    public HeadStaff login(String email, String password) {
        return headStaffRepository.findByStaffEmailAndStaffPasswordAndIsActiveTrue(email, password)
                                   .orElse(null);
    }

    // ตรวจสอบอีเมลซ้ำและบันทึกข้อมูลหัวหน้างานใหม่ลงในฐานข้อมูล
    public void addHeadStaff(String firstName, String lastName, String email, String password, String phone) {
        if (headStaffRepository.existsByStaffEmail(email)) {
            throw new IllegalArgumentException("อีเมลนี้ถูกใช้งานแล้ว");
        }

        HeadStaff staff = new HeadStaff();
        staff.setStaffFirstName(firstName);
        staff.setStaffLastName(lastName);
        staff.setStaffEmail(email);
        staff.setStaffPassword(password);
        staff.setStaffPhone(phone);

        headStaffRepository.save(staff);

        // ส่งอีเมลแจ้งข้อมูลเข้าสู่ระบบ (ถ้าส่งไม่สำเร็จ จะไม่ทำให้การเพิ่มหัวหน้างานล้มเหลว
        // เพราะ EmailService ดักข้อผิดพลาดไว้ให้แล้ว)
        emailService.sendHeadStaffWelcomeEmail(email, firstName, lastName, password);
    }

    // ดึงรายชื่อหัวหน้างานทั้งหมดที่มีอยู่ในระบบ (รวมทั้งที่ Active และ Inactive)
    public List<HeadStaff> getAllHeadStaff() {
        return headStaffRepository.findAll();
    }

    // ค้นหาข้อมูลหัวหน้างานรายบุคคลโดยอ้างอิงจากรหัส ID
    public HeadStaff getHeadStaffById(int id) { 
        return headStaffRepository.findById(id).orElse(null);
    }

   
    // ตรวจสอบก่อนลบ: ถ้าไม่เคยมีใบเสนอราคา และไม่เคยถูกมอบหมายงานผูกอยู่เลย ลบออกจริง (Hard Delete)
    // แต่ถ้ามีประวัติอย่างใดอย่างหนึ่งอยู่ Soft Delete เพื่อรักษาความสัมพันธ์ของข้อมูลเก่า
    @Transactional
    public void deleteHeadStaff(int id) {
        HeadStaff staff = headStaffRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("ไม่พบข้อมูลพนักงานที่ต้องการลบ"));

        boolean hasQuotation  = quotationService.hasQuotationForStaff(id);
        boolean hasAssignment = jobAssignmentService.hasAssignmentForStaff(id);

        if (hasQuotation || hasAssignment) {
            staff.setActive(false);
            headStaffRepository.save(staff);
        } else {
           
            headStaffRepository.delete(staff);
        }
    }

    // ดึงรายชื่อเฉพาะหัวหน้างานที่ยังมีสถานะเปิดใช้งาน (Active) สำหรับนำไปมอบหมายงาน
    public List<HeadStaff> getAllActiveHeadStaff() {
        return headStaffRepository.findByIsActiveTrue();
    }

    // อัปเดตข้อมูลส่วนตัวของหัวหน้างาน เช่น ชื่อ นามสกุล เบอร์โทรศัพท์ และรหัสผ่านใหม่
    @Transactional
    public void updateProfile(HeadStaff updatedStaff) {
        HeadStaff existingStaff = headStaffRepository.findById(updatedStaff.getStaffId())
                .orElseThrow(() -> new RuntimeException("ไม่พบข้อมูลพนักงาน"));

        existingStaff.setStaffFirstName(updatedStaff.getStaffFirstName());
        existingStaff.setStaffLastName(updatedStaff.getStaffLastName());
        existingStaff.setStaffPhone(updatedStaff.getStaffPhone());

        if (updatedStaff.getStaffPassword() != null && !updatedStaff.getStaffPassword().isEmpty()) {
            existingStaff.setStaffPassword(updatedStaff.getStaffPassword());
        }

        headStaffRepository.save(existingStaff);
    }
}