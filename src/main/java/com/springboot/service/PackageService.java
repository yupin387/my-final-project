package com.springboot.service;

import com.springboot.model.Package;
import com.springboot.repository.PackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PackageService {

    @Autowired
    private PackageRepository packageRepo;

    // ดึงข้อมูลแพ็กเกจทั้งหมดในระบบ (โหมดอ่านอย่างเดียว)
    @Transactional(readOnly = true)
    public List<Package> getAllPackages() {
        return packageRepo.findAll();
    }

    // ค้นหาแพ็กเกจตามรหัส (id) 
    // คืนค่า null หากไม่พบข้อมูล
    public Package getPackageById(int id) {
        return packageRepo.findById(id).orElse(null);
    }

    // บันทึกแพ็กเกจใหม่ หรือแก้ไขข้อมูลแพ็กเกจที่มีอยู่แล้ว
    @Transactional
    public void savePackage(Package pkg) {
        packageRepo.save(pkg);
    }

    // ลบแพ็กเกจตามรหัส (id) ที่ระบุ
    @Transactional
    public void deletePackage(int id) {
        packageRepo.deleteById(id);
    }

    // ค้นหาแพ็กเกจตามรหัส (id) 
    public Package findById(Long id) {
        return packageRepo.findById(id.intValue()).orElse(null);
    }

    // ดึงรายการแพ็กเกจตามประเภทแพ็กเกจ (packageType)
    // โดยไม่รวมแพ็กเกจแบบ "กรอกความต้องการเบื้องต้น" และเรียงลำดับจากราคาพื้นฐานน้อยไปมาก
    public List<Package> getPackagesByType(String packageType) {
        return packageRepo.findAll().stream()
                .filter(c -> packageType.equals(c.getPackageType()))
                .filter(c -> !"กรอกความต้องการเบื้องต้น".equals(c.getOptionType()))
                .sorted(java.util.Comparator.comparingDouble(Package::getBasePrice))
                .collect(java.util.stream.Collectors.toList());
    }

    // ดึงแพ็กเกจแบบกำหนดเอง ("กรอกความต้องการเบื้องต้น") ตามประเภทแพ็กเกจ
    public Package getCustomPackageByType(String packageType) {
        return packageRepo.findAll().stream()
                .filter(c -> packageType.equals(c.getPackageType()))
                .filter(c -> "กรอกความต้องการเบื้องต้น".equals(c.getOptionType()))
                .findFirst()
                .orElse(null);
    }
}