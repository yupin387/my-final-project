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
    
    
    //==============
}