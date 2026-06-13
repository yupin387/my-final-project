package com.springboot.repository;

import com.springboot.model.Organizer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface OrganizerRepository extends JpaRepository<Organizer, Integer> {
    
    // ค้นหาผู้จัดการด้วยอีเมลและรหัสผ่านเพื่อตรวจสอบการล็อกอิน
    Optional<Organizer> findByOrganizerEmailAndOrganizerPassword(String organizerEmail, String organizerPassword);

    // ค้นหาผู้จัดการด้วยอีเมล (ใช้สำหรับการตรวจสอบอีเมลซ้ำ หรือดึงข้อมูลผู้จัดการ)
    Optional<Organizer> findByOrganizerEmail(String organizerEmail);
}