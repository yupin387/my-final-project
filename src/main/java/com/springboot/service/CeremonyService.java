package com.springboot.service;

import com.springboot.model.Ceremony;
import com.springboot.repository.CeremonyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CeremonyService {

    @Autowired
    private CeremonyRepository ceremonyRepo;

    // ดึงพิธีทั้งหมด
    @Transactional(readOnly = true)
    public List<Ceremony> getAllCeremonies() {
        return ceremonyRepo.findAll();
    }

    // แก้ไข: เปลี่ยนจาก String id เป็น int id
    public Ceremony getCeremonyById(int id) {
        return ceremonyRepo.findById(id).orElse(null);
    }

    // บันทึกหรือแก้ไขข้อมูลพิธี
    @Transactional
    public void saveCeremony(Ceremony ceremony) {
        ceremonyRepo.save(ceremony);
    }

    // แก้ไข: เปลี่ยนจาก String id เป็น int id
    @Transactional
    public void deleteCeremony(int id) {
        ceremonyRepo.deleteById(id);
    }
    
    
    //==============เพิ่มเมธอท
 // ใน CeremonyService.java
    public Ceremony findById(Long id) {
        // แปลง Long เป็น int ถ้า ID ใน Repository ใช้ int
        return ceremonyRepo.findById(id.intValue()).orElse(null);
    }
    
 // เพิ่มใน CeremonyService.java
    public List<Ceremony> getCeremoniesByType(String ceremonyType) {
        return ceremonyRepo.findAll().stream()
                .filter(c -> ceremonyType.equals(c.getCeremonyType()))
                .filter(c -> !"กรอกความต้องการเบื้องต้น".equals(c.getCeremonyName())) // เอาเฉพาะ 3 แพ็กเกจหลัก ไม่รวมกำหนดเอง
                .sorted(java.util.Comparator.comparingDouble(Ceremony::getBasePrice))
                .collect(java.util.stream.Collectors.toList());
    }

    public Ceremony getCustomCeremonyByType(String ceremonyType) {
        return ceremonyRepo.findAll().stream()
                .filter(c -> ceremonyType.equals(c.getCeremonyType()))
                .filter(c -> "กรอกความต้องการเบื้องต้น".equals(c.getCeremonyName()))
                .findFirst()
                .orElse(null);
    }
}