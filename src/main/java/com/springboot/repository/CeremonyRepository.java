package com.springboot.repository;

import com.springboot.model.Ceremony;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface CeremonyRepository extends JpaRepository<Ceremony, Integer> {

    // ค้นหาพิธีที่ "รูปแบบตัวเลือก" (optionType) มีคำที่ระบุอยู่ (ค้นแบบ contains)
    List<Ceremony> findByOptionTypeContaining(String name);

    // ดึงพิธีทั้งหมดพร้อม fetch รายการอุปกรณ์ (ceremonyItems) และตัวสินค้า (item) มาด้วยในคราวเดียว
    @Query("SELECT DISTINCT c FROM Ceremony c LEFT JOIN FETCH c.ceremonyItems ci LEFT JOIN FETCH ci.item")
    List<Ceremony> findAllWithItems();

    // ค้นหาพิธีทั้งหมดที่ตรงกับ "ประเภทพิธี" (ceremonyType) ที่ระบุ
    List<Ceremony> findByCeremonyType(String ceremonyType);
}