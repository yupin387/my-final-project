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
    // ชื่อประเภทอุปกรณ์ที่ห้ามสร้าง/แก้ไขผ่านฟอร์มอุปกรณ์ทั่วไป (ต้องจัดการแยกจากส่วนกลางเท่านั้น)
    private static final String RESTRICTED_ITEM_TYPE_NAME = "แพ็กเกจ";

    @Autowired
    private ItemRepository itemRepo;
    
    @Autowired
    private ItemTypeRepository itemTypeRepo;
    
    @Autowired
    private CeremonyRepository ceremonyRepo;

    // ดึงอุปกรณ์ที่ยัง active อยู่เท่านั้น (isActive = true)
    public List<Item> getAllActiveItems() {
        return itemRepo.findAllActive();
    }

    // ดึงอุปกรณ์ทั้งหมดในระบบ (รวมที่ถูกปิดใช้งานแล้วด้วย)
    public List<Item> getAllItems() {
        return itemRepo.findAll();
    }

    // ดึงประเภทอุปกรณ์ (ItemType) ทั้งหมด
    public List<ItemType> getAllItemTypes() {
        return itemTypeRepo.findAll();
    }

    // ดึงอุปกรณ์ทั้งหมดที่อยู่ในประเภท (typeId) ที่ระบุ
    public List<Item> getItemsByType(int typeId) {
        return itemRepo.findByItemType_ItemTypeId(typeId);
    }

    // ดึงอุปกรณ์ตาม id คืนค่า null ถ้าไม่พบ
    public Item getItemById(int id) {
        return itemRepo.findById(id).orElse(null);
    }


    // บันทึก/แก้ไขอุปกรณ์ พร้อมผูกกับพิธี (ceremony) ที่เลือกและจำนวนของแต่ละพิธี
    @Transactional
    public void saveItem(Item item, int typeId, List<Integer> ceremonyIds, List<Integer> quantities) {
        ItemType type = itemTypeRepo.findById(typeId).orElse(null);

        if (type != null && RESTRICTED_ITEM_TYPE_NAME.equals(type.getItemTypeName())) {
            throw new IllegalArgumentException(
                "ไม่สามารถสร้างหรือแก้ไขอุปกรณ์ประเภท \"แพ็กเกจ\" ผ่านฟอร์มนี้ได้ "
                + "แพ็กเกจถูกกำหนดไว้จากส่วนกลางเท่านั้น");
        }

        item.setItemType(type);
        if (item.getItemId() == 0) { 
            item.setIsActive(true);
        }

        if (item.getCeremonyItems() == null) {
            item.setCeremonyItems(new ArrayList<>());
        } else {
            item.getCeremonyItems().clear();
        }

        if (ceremonyIds != null && !ceremonyIds.isEmpty()) {
            List<Ceremony> ceremonies = ceremonyRepo.findAllById(ceremonyIds);

            for (int idx = 0; idx < ceremonyIds.size(); idx++) {
                int cId = ceremonyIds.get(idx);
                Ceremony ceremony = ceremonies.stream()
                    .filter(c -> c.getCeremonyId() == cId)
                    .findFirst()
                    .orElse(null);
                if (ceremony == null) continue;

            
                int qty = 1;
                if (quantities != null && idx < quantities.size() && quantities.get(idx) != null) {
                    qty = quantities.get(idx);
                    if (qty < 1) qty = 1;
                }

                CeremonyItem ci = new CeremonyItem();
                ci.setItem(item);
                ci.setCeremony(ceremony);
                ci.setQuantity(qty);
                item.getCeremonyItems().add(ci);
            }
        }
        
        itemRepo.save(item); 
    }
    
    // ลบอุปกรณ์แบบ soft delete: ไม่ได้ลบออกจากฐานข้อมูลจริง แค่ตั้ง isActive เป็น false
    @Transactional
    public void deleteItem(int id) {
        Item item = itemRepo.findById(id).orElse(null);
        if (item != null) {
            item.setIsActive(false);
            itemRepo.save(item); 
        }
    }

    // ดึงอุปกรณ์ทั้งหมดที่อยู่ในประเภทตามชื่อที่ระบุ (เช่น "สังฆทาน", "ภัตตาหารปิ่นโต")
    public List<Item> getItemsByTypeName(String typeName) {
        return itemRepo.findByItemType_ItemTypeName(typeName);
    }
    
    // ดึงอุปกรณ์ทั้งหมดที่ผูกอยู่กับพิธี (ceremony) ตาม ceremonyId ที่ระบุ
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