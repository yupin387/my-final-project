package com.springboot.repository;

import com.springboot.model.Package;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface PackageRepository extends JpaRepository<Package, Integer> {

    // ค้นหาพิธีที่ "รูปแบบตัวเลือก" (optionType) มีคำที่ระบุอยู่ (ค้นแบบ contains)
    List<Package> findByOptionTypeContaining(String name);

    // ดึงพิธีทั้งหมดพร้อม fetch รายการอุปกรณ์ (packageItems) และตัวสินค้า (item) มาด้วยในคราวเดียว
    @Query("SELECT DISTINCT c FROM Package c LEFT JOIN FETCH c.packageItems ci LEFT JOIN FETCH ci.item")
    List<Package> findAllWithItems();

    // ค้นหาพิธีทั้งหมดที่ตรงกับ "ประเภทพิธี" (packageType) ที่ระบุ
    List<Package> findByPackageType(String packageType);
}