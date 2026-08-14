package com.springboot.repository;

import com.springboot.model.Ceremony;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CeremonyRepository extends JpaRepository<Ceremony, Integer> {

    // ค้นหาพิธีตามชื่อ
    List<Ceremony> findByCeremonyNameContaining(String name);

    // แก้ไข: เปลี่ยน c.items เป็น c.ceremonyItems และ Join ไปยัง item 
    @Query("SELECT DISTINCT c FROM Ceremony c LEFT JOIN FETCH c.ceremonyItems ci LEFT JOIN FETCH ci.item")
    List<Ceremony> findAllWithItems();

    // เพิ่ม: ดึงแพ็กเกจทั้งหมดของ "ประเภทงาน" หนึ่ง ๆ (ทำบุญบ้าน/ขึ้นบ้านใหม่/ทำบุญออฟฟิศ)
    // ใช้ตอนฟอร์มเพิ่ม/แก้คำถามส่งมาแค่ ceremonyType แล้วต้องเลือกแพ็กเกจแรกให้อัตโนมัติ
    List<Ceremony> findByCeremonyType(String ceremonyType);
}