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
    private static final String RESTRICTED_ITEM_TYPE_NAME = "แพ็กเกจ";

    @Autowired
    private ItemRepository itemRepo;
    
    @Autowired
    private ItemTypeRepository itemTypeRepo;
    
    @Autowired
    private CeremonyRepository ceremonyRepo;

    public List<Item> getAllActiveItems() {
        return itemRepo.findAllActive();
    }

    public List<Item> getAllItems() {
        return itemRepo.findAll();
    }

    public List<ItemType> getAllItemTypes() {
        return itemTypeRepo.findAll();
    }

    public List<Item> getItemsByType(int typeId) {
        return itemRepo.findByItemType_ItemTypeId(typeId);
    }

    public Item getItemById(int id) {
        return itemRepo.findById(id).orElse(null);
    }

    // บันทึกข้อมูลการเพิ่มหรือแก้ไขอุปกรณ์ พร้อมจัดการความสัมพันธ์ผ่าน CeremonyItem
    // FIX: เพิ่มพารามิเตอร์ quantities — parallel array คู่กับ ceremonyIds
    // (index ตรงกันเพราะฝั่ง JSP disable input ตอนไม่ติ๊ก checkbox ทำให้ browser
    // ไม่ส่งค่าตัวที่ไม่ได้เลือกมาด้วย ลำดับที่เหลือจึงตรงกันเสมอ)
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

                // quantity คอลัมน์ nullable=false ต้องมีค่าเสมอ — กันกรณี list สั้นกว่า
                // หรือค่าที่ส่งมาผิดปกติ (<1) ด้วยการ fallback เป็น 1
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
    
    @Transactional
    public void deleteItem(int id) {
        Item item = itemRepo.findById(id).orElse(null);
        if (item != null) {
            item.setIsActive(false);
            itemRepo.save(item); 
        }
    }

    public List<Item> getItemsByTypeName(String typeName) {
        return itemRepo.findByItemType_ItemTypeName(typeName);
    }
    
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