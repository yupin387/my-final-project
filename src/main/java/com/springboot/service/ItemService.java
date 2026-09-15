package com.springboot.service;

import com.springboot.model.*;
import com.springboot.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
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
    
    @Autowired
    private QuotationDetailRepository quotationDetailRepo;

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

   
    @Transactional
    public void saveItem(Item item, int typeId, List<Integer> ceremonyIds, List<Integer> quantities) {
        ItemType type = itemTypeRepo.findById(typeId).orElse(null);

        if (type != null && RESTRICTED_ITEM_TYPE_NAME.equals(type.getItemTypeName())) {
            throw new IllegalArgumentException(
                "ไม่สามารถสร้างหรือแก้ไขอุปกรณ์ประเภท \"แพ็กเกจ\" ผ่านฟอร์มนี้ได้ "
                + "แพ็กเกจถูกกำหนดไว้จากส่วนกลางเท่านั้น");
        }

        boolean isNewItem = item.getItemId() == 0;

        if (isNewItem) {
            // ---- กรณีเพิ่มอุปกรณ์ใหม่: ไม่มีของเดิมให้ diff เพิ่มได้ตรง ๆ ----
            item.setItemType(type);
            item.setIsActive(true);
            item.setCeremonyItems(new ArrayList<>());
            addCeremonyItems(item, item.getCeremonyItems(), ceremonyIds, quantities);
            itemRepo.save(item);
            return;
        }

   
        Item existingItem = itemRepo.findById(item.getItemId())
                .orElseThrow(() -> new IllegalArgumentException("ไม่พบอุปกรณ์ที่ต้องการแก้ไข"));

        Map<Integer, Integer> newQtyMap = new LinkedHashMap<>();
        if (ceremonyIds != null) {
            for (int idx = 0; idx < ceremonyIds.size(); idx++) {
                Integer cId = ceremonyIds.get(idx);
                if (cId == null) continue;

                int qty = 1;
                if (quantities != null && idx < quantities.size() && quantities.get(idx) != null) {
                    qty = quantities.get(idx);
                    if (qty < 1) qty = 1;
                }
                newQtyMap.put(cId, qty);
            }
        }

        if (existingItem.getCeremonyItems() == null) {
            existingItem.setCeremonyItems(new ArrayList<>());
        }
        List<CeremonyItem> existingCeremonyItems = existingItem.getCeremonyItems();

        Iterator<CeremonyItem> it = existingCeremonyItems.iterator();
        while (it.hasNext()) {
            CeremonyItem ci = it.next();
            if (ci.getCeremony() == null) {
                continue;
            }
            int cId = ci.getCeremony().getCeremonyId();

            if (newQtyMap.containsKey(cId)) {
                ci.setQuantity(newQtyMap.get(cId));
                newQtyMap.remove(cId);
            } else {
                it.remove(); 
            }
        }

        // 2) ที่เหลือใน newQtyMap คือ ceremonyId ใหม่ที่ยังไม่เคยผูกกับอุปกรณ์นี้มาก่อน -> เพิ่มเป็นแถวใหม่
        if (!newQtyMap.isEmpty()) {
            List<Ceremony> ceremonies = ceremonyRepo.findAllById(newQtyMap.keySet());
            for (Ceremony ceremony : ceremonies) {
                CeremonyItem ci = new CeremonyItem();
                ci.setItem(existingItem);
                ci.setCeremony(ceremony);
                ci.setQuantity(newQtyMap.get(ceremony.getCeremonyId()));
                existingCeremonyItems.add(ci);
            }
        }

        // 3) อัปเดตฟิลด์อื่น ๆ ของอุปกรณ์ตามค่าที่ส่งมาจากฟอร์ม
        existingItem.setItemName(item.getItemName());
        existingItem.setItemDetail(item.getItemDetail());
        existingItem.setUnit(item.getUnit());
        existingItem.setPricePerUnit(item.getPricePerUnit());
        existingItem.setItemType(type);
        // isActive ไม่แตะ เพราะฟอร์มแก้ไขนี้ไม่ได้เป็นตัวจัดการเปิด/ปิดใช้งาน (มี deleteItem แยกต่างหาก)

        itemRepo.save(existingItem);
    }

    // เพิ่ม CeremonyItem ใหม่ทั้งหมดเข้าไปใน targetList (ใช้เฉพาะตอนสร้างอุปกรณ์ใหม่ที่ยังไม่มีของเดิม)
    private void addCeremonyItems(Item item, List<CeremonyItem> targetList,
                                   List<Integer> ceremonyIds, List<Integer> quantities) {
        if (ceremonyIds == null || ceremonyIds.isEmpty()) return;

        List<Ceremony> ceremonies = ceremonyRepo.findAllById(ceremonyIds);

        for (int idx = 0; idx < ceremonyIds.size(); idx++) {
            Integer cId = ceremonyIds.get(idx);
            if (cId == null) continue;

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
            targetList.add(ci);
        }
    }

    // ลบอุปกรณ์แบบ soft delete: ไม่ได้ลบออกจากฐานข้อมูลจริง แค่ตั้ง isActive เป็น false
    @Transactional
    public void deleteItem(int id) {
        Item item = itemRepo.findById(id).orElse(null);
        if (item == null) {
            return;
        }

        boolean usedInAnyQuotation = quotationDetailRepo.existsByItem_ItemId(id);

        if (usedInAnyQuotation) {
            item.setIsActive(false);
            itemRepo.save(item);
        } else {
           
            itemRepo.delete(item);
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