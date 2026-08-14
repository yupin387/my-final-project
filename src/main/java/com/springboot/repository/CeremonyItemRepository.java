package com.springboot.repository;

import com.springboot.model.Ceremony;
import com.springboot.model.CeremonyItem;
import com.springboot.model.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CeremonyItemRepository extends JpaRepository<CeremonyItem, Integer> {

    // 1. ค้นหารายการ Item ทั้งหมดที่อยู่ในพิธีที่กำหนด
    List<CeremonyItem> findByCeremony(Ceremony ceremony);

    // 2. ค้นหารายการพิธีทั้งหมดที่มีการใช้ Item นั้นๆ
    List<CeremonyItem> findByItem(Item item);
    
    // หมายเหตุ: เนื่องจาก extends JpaRepository แล้ว
    // คุณสามารถใช้งาน .save(), .findById(), .delete(), .findAll() ได้ทันทีโดยไม่ต้องเขียนโค้ดเพิ่มครับ
}