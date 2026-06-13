package com.springboot.service;

import com.springboot.model.Organizer;
import com.springboot.repository.OrganizerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrganizerService {

    @Autowired
    private OrganizerRepository organizerRepo;

    // ตรวจสอบการเข้าสู่ระบบของผู้จัดการโดยเช็กอีเมลและรหัสผ่านที่ตรงกัน
    public Organizer login(String email, String password) {
        return organizerRepo.findByOrganizerEmailAndOrganizerPassword(email, password)
                .orElse(null);
    }

    // ค้นหาและดึงข้อมูลรายละเอียดของผู้จัดการโดยอ้างอิงจากที่อยู่อีเมล
    public Organizer getOrganizerByEmail(String email) {
        return organizerRepo.findByOrganizerEmail(email).orElse(null);
    }
}