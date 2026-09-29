package com.springboot.service;

import com.springboot.model.*;
import com.springboot.model.Package;
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
    private PackageRepository packageRepo;
    
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
    public void saveItem(Item item, int typeId, List<Integer> packageIds, List<Integer> quantities) {
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
            item.setPackageItems(new ArrayList<>());
            addPackageItems(item, item.getPackageItems(), packageIds, quantities);
            itemRepo.save(item);
            return;
        }

   
        Item existingItem = itemRepo.findById(item.getItemId())
                .orElseThrow(() -> new IllegalArgumentException("ไม่พบอุปกรณ์ที่ต้องการแก้ไข"));

        Map<Integer, Integer> newQtyMap = new LinkedHashMap<>();
        if (packageIds != null) {
            for (int idx = 0; idx < packageIds.size(); idx++) {
                Integer pId = packageIds.get(idx);
                if (pId == null) continue;

                int qty = 1;
                if (quantities != null && idx < quantities.size() && quantities.get(idx) != null) {
                    qty = quantities.get(idx);
                    if (qty < 1) qty = 1;
                }
                newQtyMap.put(pId, qty);
            }
        }

        if (existingItem.getPackageItems() == null) {
            existingItem.setPackageItems(new ArrayList<>());
        }
        List<PackageItem> existingPackageItems = existingItem.getPackageItems();

        Iterator<PackageItem> it = existingPackageItems.iterator();
        while (it.hasNext()) {
            PackageItem pi = it.next();
            if (pi.getPackageEntity() == null) {
                continue;
            }
            int pId = pi.getPackageEntity().getPackageId();

            if (newQtyMap.containsKey(pId)) {
                pi.setQuantity(newQtyMap.get(pId));
                newQtyMap.remove(pId);
            } else {
                it.remove(); 
            }
        }

        // 2) ที่เหลือใน newQtyMap คือ packageId ใหม่ที่ยังไม่เคยผูกกับอุปกรณ์นี้มาก่อน -> เพิ่มเป็นแถวใหม่
        if (!newQtyMap.isEmpty()) {
            List<Package> packages = packageRepo.findAllById(newQtyMap.keySet());
            for (Package pkg : packages) {
                PackageItem pi = new PackageItem();
                pi.setItem(existingItem);
                pi.setPackageEntity(pkg);
                pi.setQuantity(newQtyMap.get(pkg.getPackageId()));
                existingPackageItems.add(pi);
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

    // เพิ่ม PackageItem ใหม่ทั้งหมดเข้าไปใน targetList (ใช้เฉพาะตอนสร้างอุปกรณ์ใหม่ที่ยังไม่มีของเดิม)
    private void addPackageItems(Item item, List<PackageItem> targetList,
                                   List<Integer> packageIds, List<Integer> quantities) {
        if (packageIds == null || packageIds.isEmpty()) return;

        List<Package> packages = packageRepo.findAllById(packageIds);

        for (int idx = 0; idx < packageIds.size(); idx++) {
            Integer pId = packageIds.get(idx);
            if (pId == null) continue;

            Package pkg = packages.stream()
                    .filter(c -> c.getPackageId() == pId)
                    .findFirst()
                    .orElse(null);
            if (pkg == null) continue;

            int qty = 1;
            if (quantities != null && idx < quantities.size() && quantities.get(idx) != null) {
                qty = quantities.get(idx);
                if (qty < 1) qty = 1;
            }

            PackageItem pi = new PackageItem();
            pi.setItem(item);
            pi.setPackageEntity(pkg);
            pi.setQuantity(qty);
            targetList.add(pi);
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

    // ดึงอุปกรณ์ทั้งหมดที่ผูกอยู่กับแพ็กเกจ (package) ตาม packageId ที่ระบุ
    public List<Item> getItemsByPackageId(int packageId) {
        Package pkg = packageRepo.findById(packageId).orElse(null);
        if (pkg != null && pkg.getPackageItems() != null) {
            return pkg.getPackageItems().stream()
                .filter(pi -> pi.getItem() != null)
                .map(PackageItem::getItem)
                .collect(Collectors.toList());
        }
        return new ArrayList<>();
    }
}