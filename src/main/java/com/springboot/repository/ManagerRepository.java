package com.springboot.repository;

import com.springboot.model.Manager;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface ManagerRepository extends JpaRepository<Manager, Integer> {
    
    //  ค้นหาผู้จัดการด้วยอีเมลและรหัสผ่านเพื่อตรวจสอบการล็อกอิน
    Optional<Manager> findByManagerEmailAndManagerPassword(String managerEmail, String managerPassword);

    // ค้นหาผู้จัดการด้วยอีเมล (ใช้สำหรับการตรวจสอบอีเมลซ้ำ หรือดึงข้อมูลผู้จัดการ)
    Optional<Manager> findByManagerEmail(String managerEmail);
}