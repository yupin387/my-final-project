package com.springboot.service;

import com.springboot.model.*;
import com.springboot.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ItemService {
    // ชื่อ ItemType ที่ห้ามสร้าง/แก้ไขผ่านฟอร์มอุปกรณ์ทั่วไป (addItem/editItem)
    // เพราะ item ประเภทแพ็กเกจมีกฎพิเศษ (itemName ต้องตรงกับ ceremony.ceremonyName เป๊ะๆ,
    // ผูกกับ ceremony ตายตัวตามระดับราคา, ราคาจริงที่ระบบใช้อยู่ที่ ceremony.basePrice
    // ไม่ใช่ item.pricePerUnit) แพ็กเกจทั้งหมดถูกกำหนดไว้แล้วจาก seed data (Run.java) เท่านั้น
    private static final String RESTRICTED_ITEM_TYPE_NAME = "แพ็กเกจ";

    @Autowired
    private ItemRepository itemRepo;
    
    @Autowired
    private ItemTypeRepository itemTypeRepo;
    
    @Autowired
    private CeremonyRepository ceremonyRepo;

    // ดึงรายชื่ออุปกรณ์และบริการเฉพาะรายการที่ยังมีสถานะเปิดใช้งานอยู่
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

    // บันทึกข้อมูลการเพิ่มหรือแก้ไขอุปกรณ์ พร้อมจัดการความสัมพันธ์ผ่าน CeremonyItem
    @Transactional
    public void saveItem(Item item, int typeId, List<Integer> ceremonyIds) {
        ItemType type = itemTypeRepo.findById(typeId).orElse(null);

        // FIX: กันไว้ที่ service ชั้นเดียวกับที่บันทึกจริง เผื่อมีคนยิง request ตรงมาที่
        // /staff/items/save โดยข้าม UI ด้วย typeId ของ "แพ็กเกจ" ห้ามสร้าง/แก้ไข item ประเภทนี้ผ่านฟอร์มนี้
        if (type != null && RESTRICTED_ITEM_TYPE_NAME.equals(type.getItemTypeName())) {
            throw new IllegalArgumentException(
                "ไม่สามารถสร้างหรือแก้ไขอุปกรณ์ประเภท \"แพ็กเกจ\" ผ่านฟอร์มนี้ได้ "
                + "แพ็กเกจถูกกำหนดไว้จากส่วนกลางเท่านั้น");
        }

        item.setItemType(type);
        if (item.getItemId() == 0) { 
            item.setIsActive(true);
        }

        // จัดการความสัมพันธ์ผ่าน CeremonyItem แทนการเรียก .setCeremonies() โดยตรง
        if (item.getCeremonyItems() == null) {
            item.setCeremonyItems(new ArrayList<>());
        } else {
            item.getCeremonyItems().clear();
        }

        if (ceremonyIds != null && !ceremonyIds.isEmpty()) {
            List<Ceremony> ceremonies = ceremonyRepo.findAllById(ceremonyIds);
            for (Ceremony ceremony : ceremonies) {
                CeremonyItem ci = new CeremonyItem();
                ci.setItem(item);
                ci.setCeremony(ceremony);
                item.getCeremonyItems().add(ci);
            }
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
    
    // ค้นหาและดึงรายการอุปกรณ์ที่ผูกอยู่กับรหัสพิธีกรรม/แพ็กเกจ (Ceremony ID) ผ่าน CeremonyItem
    public List<Item> getItemsByCeremonyId(int ceremonyId) {
        Ceremony ceremony = ceremonyRepo.findById(ceremonyId).orElse(null);
        if (ceremony != null && ceremony.getCeremonyItems() != null) {
            return ceremony.getCeremonyItems().stream()
                .filter(ci -> ci.getItem() != null)
                .map(CeremonyItem::getItem)
                .collect(Collectors.toList());
        }
        return new ArrayList<>();
    }
}