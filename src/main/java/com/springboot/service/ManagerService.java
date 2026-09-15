package com.springboot.service;

import com.springboot.model.Manager;
import com.springboot.repository.ManagerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ManagerService {

    @Autowired
    private ManagerRepository managerRepo; // ✅ เปลี่ยนชื่อตัวแปรให้ตรงความหมาย

    // ตรวจสอบการเข้าสู่ระบบของผู้จัดการโดยเช็กอีเมลและรหัสผ่านที่ตรงกัน
    public Manager login(String email, String password) {
        // ✅ เปลี่ยนเมธอดเป็น ManagerEmail และ ManagerPassword
        return managerRepo.findByManagerEmailAndManagerPassword(email, password)
                .orElse(null);
    }

    // ค้นหาและดึงข้อมูลรายละเอียดของผู้จัดการโดยอ้างอิงจากที่อยู่อีเมล
    public Manager getManagerByEmail(String email) { // ✅ เปลี่ยนชื่อเมธอด
        // ✅ เปลี่ยนเมธอดเป็น ManagerEmail
        return managerRepo.findByManagerEmail(email).orElse(null);
    }
}