package com.springboot.service;

import com.springboot.model.*;
import com.springboot.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ItemService {

    @Autowired
    private ItemRepository itemRepo;

    @Autowired
    private ItemTypeRepository itemTypeRepo;

    @Autowired
    private CeremonyRepository ceremonyRepo;

    // ดึงรายชื่ออุปกรณ์และบริการเฉพาะรายการที่ยังมีสถานะเปิดใช้งานอยู่ (Active)
    public List<Item> getAllActiveItems() {
        return itemRepo.findAllActive();
    }

    // ดึงรายชื่ออุปกรณ์ทั้งหมดในฐานข้อมูลรวมถึงรายการที่ปิดใช้งานไปแล้ว
    public List<Item> getAllItems() {
        return itemRepo.findAll();
    }

    // ดึงรายการประเภทของอุปกรณ์ทั้งหมด (เช่น อุปกรณ์, ภัตตาหาร, บริการ)
    public List<ItemType> getAllItemTypes() {
        return itemTypeRepo.findAll();
    }

    // ค้นหาและดึงรายชื่ออุปกรณ์ตามรหัสประเภทที่ระบุ
    public List<Item> getItemsByType(int typeId) {
        return itemRepo.findByItemType_ItemTypeId(typeId);
    }

    // ค้นหาข้อมูลรายละเอียดของอุปกรณ์รายชิ้นตามรหัส ID
    public Item getItemById(int id) {
        return itemRepo.findById(id).orElse(null);
    }

    // บันทึกข้อมูลการเพิ่มหรือแก้ไขอุปกรณ์ พร้อมจัดการความสัมพันธ์กับประเภทและพิธีกรรม
    @Transactional
    public void saveItem(Item item, int typeId, List<Integer> ceremonyIds) {
        ItemType type = itemTypeRepo.findById(typeId).orElse(null);
        item.setItemType(type);

        if (item.getItemId() == 0) { 
            item.setIsActive(true);
        }

        if (ceremonyIds != null && !ceremonyIds.isEmpty()) {
            List<Ceremony> ceremonies = ceremonyRepo.findAllById(ceremonyIds);
            item.setCeremonies(ceremonies);
        } else {
            item.getCeremonies().clear();
        }

        itemRepo.save(item); 
    }
    
    // ทำการลบอุปกรณ์แบบ Soft Delete โดยเปลี่ยนสถานะการใช้งานเป็น false แทนการลบจริง
    @Transactional
    public void deleteItem(int id) {
        Item item = itemRepo.findById(id).orElse(null);
        if (item != null) {
            item.setIsActive(false);
            itemRepo.save(item); 
        }
    }

    // ค้นหาและดึงรายชื่ออุปกรณ์โดยอ้างอิงจากชื่อประเภทของอุปกรณ์
    public List<Item> getItemsByTypeName(String typeName) {
        return itemRepo.findByItemType_ItemTypeName(typeName);
    }
}