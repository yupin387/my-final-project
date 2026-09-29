package com.springboot.repository;

import com.springboot.model.Package;
import com.springboot.model.PackageItem;
import com.springboot.model.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PackageItemRepository extends JpaRepository<PackageItem, Integer> {

    // ค้นหารายการ Item ทั้งหมดที่อยู่ในพิธีที่กำหนด
    List<PackageItem> findByPackageEntity(Package packageEntity);

    // ค้นหารายการพิธีทั้งหมดที่มีการใช้ Item นั้นๆ
    List<PackageItem> findByItem(Item item);
    
   
}