package com.springboot.repository;

import com.springboot.model.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ItemRepository extends JpaRepository<Item, Integer> { 

    // ค้นหารายการสินค้า (Item) โดยระบุ ID ของประเภทสินค้า
    List<Item> findByItemType_ItemTypeId(int typeId);

    // ดึงข้อมูลรายการสินค้าทั้งหมดที่ยังเปิดใช้งานอยู่
    @Query("SELECT i FROM Item i WHERE i.isActive = true")
    List<Item> findAllActive();

    // ค้นหารายการสินค้าตามชื่อประเภทสินค้า
    List<Item> findByItemType_ItemTypeName(String typeName);
    
    // ค้นหารายการสินค้าที่ผูกอยู่กับพิธีกรรม 
    List<Item> findByCeremonies_CeremonyId(int ceremonyId);
    
    // ค้นหารายการสินค้าโดยระบุชื่อรายการ
    Optional<Item> findByItemName(String itemName);
    
}