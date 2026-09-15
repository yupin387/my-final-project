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


    public Ceremony getCeremonyById(int id) {
        return ceremonyRepo.findById(id).orElse(null);
    }

    // บันทึกหรือแก้ไขข้อมูลพิธี
    @Transactional
    public void saveCeremony(Ceremony ceremony) {
        ceremonyRepo.save(ceremony);
    }

   // ลบข้อมูลพิธี
    @Transactional
    public void deleteCeremony(int id) {
        ceremonyRepo.deleteById(id);
    }
    

    public Ceremony findById(Long id) {
        return ceremonyRepo.findById(id.intValue()).orElse(null);
    }
    
    public List<Ceremony> getCeremoniesByType(String ceremonyType) {
        return ceremonyRepo.findAll().stream()
                .filter(c -> ceremonyType.equals(c.getCeremonyType()))
                .filter(c -> !"กรอกความต้องการเบื้องต้น".equals(c.getOptionType())) 
                .sorted(java.util.Comparator.comparingDouble(Ceremony::getBasePrice))
                .collect(java.util.stream.Collectors.toList());
    }

    public Ceremony getCustomCeremonyByType(String ceremonyType) {
        return ceremonyRepo.findAll().stream()
                .filter(c -> ceremonyType.equals(c.getCeremonyType()))
                .filter(c -> "กรอกความต้องการเบื้องต้น".equals(c.getOptionType()))
                .findFirst()
                .orElse(null);
    }
}