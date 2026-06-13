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
    }

    // ดึงรายชื่อหัวหน้างานทั้งหมดที่มีอยู่ในระบบ (รวมทั้งที่ Active และ Inactive)
    public List<HeadStaff> getAllHeadStaff() {
        return headStaffRepository.findAll();
    }

    // ค้นหาข้อมูลหัวหน้างานรายบุคคลโดยอ้างอิงจากรหัส ID
    public HeadStaff getHeadStaffById(int id) { 
        return headStaffRepository.findById(id).orElse(null);
    }

    // ทำการลบข้อมูลแบบ Soft Delete โดยเปลี่ยนสถานะการใช้งานเป็น false เพื่อรักษาประวัติข้อมูล
    @Transactional
    public void deleteHeadStaff(int id) {
        HeadStaff staff = headStaffRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("ไม่พบข้อมูลพนักงานที่ต้องการลบ"));

        staff.setActive(false); 
        headStaffRepository.save(staff);
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