package com.springboot.controller.headstaff;

import com.springboot.model.Ceremony;
import com.springboot.model.CeremonyItem;
import com.springboot.model.Item;
import com.springboot.service.ItemService;
import com.springboot.service.CeremonyService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/staff/items")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @Autowired
    private CeremonyService ceremonyService;

    // ลำดับประเภทงานตายตัว ใช้ตอนแสดงผลคอลัมน์ "ใช้กับพิธี" ให้เรียงเหมือนกันทุกแถว
    private static final List<String> CEREMONY_TYPE_ORDER =
        List.of("ทำบุญบ้าน", "ขึ้นบ้านใหม่", "ทำบุญบริษัทหรือออฟฟิศ");

    // ลำดับระดับแพ็กเกจตายตัว ใช้จัดเรียง checkbox ภายในแต่ละกลุ่มประเภทงาน
    private static final List<String> PACKAGE_ORDER =
    	    List.of("แพ็กเกจมาตรฐาน", "แพ็กเกจอิ่มบุญ", "แพ็กเกจพรีเมียม", "กรอกความต้องการเบื้องต้น");
    // จัดกลุ่ม Ceremony ตามประเภทงาน (ceremonyType)
    private Map<String, List<Ceremony>> groupCeremoniesByType(List<Ceremony> allCeremonies) {
        Map<String, List<Ceremony>> grouped = new LinkedHashMap<>();
        for (String type : CEREMONY_TYPE_ORDER) {
            List<Ceremony> forType = allCeremonies.stream()
                .filter(c -> type.equals(c.getCeremonyType()))
                .sorted((a, b) -> {
                    int ra = PACKAGE_ORDER.indexOf(a.getCeremonyName());
                    int rb = PACKAGE_ORDER.indexOf(b.getCeremonyName());
                    if (ra < 0) ra = PACKAGE_ORDER.size();
                    if (rb < 0) rb = PACKAGE_ORDER.size();
                    return Integer.compare(ra, rb);
                })
                .collect(Collectors.toList());
            if (!forType.isEmpty()) {
                grouped.put(type, forType);
            }
        }
        return grouped;
    }

    // แสดงรายการอุปกรณ์ทั้งหมดโดยกรองเฉพาะรายการที่ยังเปิดใช้งานอยู่ (Active)
    @GetMapping
    public String listItem(@RequestParam(required = false) String typeId, 
                           Model model, 
                           HttpSession session) {
        if (session.getAttribute("currentStaff") == null) {
            return "redirect:/loginorganizer"; 
        }

        List<Item> items;
        
        if (typeId == null || typeId.equals("all") || typeId.isEmpty()) {
            items = itemService.getAllActiveItems(); 
        } else {
            items = itemService.getItemsByType(Integer.parseInt(typeId)); 
        }

        model.addAttribute("items", items);
        model.addAttribute("itemTypes", itemService.getAllItemTypes());
        model.addAttribute("selectedType", typeId != null ? typeId : "all");

        // แก้ไขจุดบกพร่อง: อ่านข้อมูล Ceremony ผ่านตารางกลาง CeremonyItem
        Map<Integer, List<String>> itemCeremonyTypes = new LinkedHashMap<>();
        for (Item item : items) {
            List<CeremonyItem> ceremonyItems = item.getCeremonyItems();
            
            Set<String> distinctTypes;
            if (ceremonyItems == null) {
                distinctTypes = new LinkedHashSet<>();
            } else {
                distinctTypes = ceremonyItems.stream()
                    .filter(ci -> ci.getCeremony() != null)
                    .map(ci -> ci.getCeremony().getCeremonyType())
                    .collect(Collectors.toCollection(LinkedHashSet::new));
            }

            List<String> orderedTypes = CEREMONY_TYPE_ORDER.stream()
                .filter(distinctTypes::contains)
                .collect(Collectors.toList());

            itemCeremonyTypes.put(item.getItemId(), orderedTypes);
        }
        model.addAttribute("itemCeremonyTypes", itemCeremonyTypes);
        
        return "itemList";
    }

    // แสดงหน้าฟอร์มสำหรับเพิ่มข้อมูลอุปกรณ์ใหม่เข้าสู่ระบบ
    @GetMapping("/add")
    public String showAddForm(Model model, HttpSession session) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginorganizer";
        
        model.addAttribute("item", new Item());
        model.addAttribute("itemTypes", itemService.getAllItemTypes());
        model.addAttribute("groupedCeremonies", groupCeremoniesByType(ceremonyService.getAllCeremonies()));
        
        return "addItem"; 
    }

    // แสดงหน้าฟอร์มแก้ไขข้อมูลอุปกรณ์ตามรหัส (ID) ที่ระบุ
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable int id, Model model, HttpSession session) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginorganizer";
        
        Item item = itemService.getItemById(id);
        
        // ดึงรายการ ceremonyId ทั้งหมดที่ Item นี้ถูกใช้อยู่ส่งไปให้ JSP แสดงผล Checkbox ล่วงหน้า
        List<Integer> selectedCeremonyIds = new ArrayList<>();
        if (item.getCeremonyItems() != null) {
            selectedCeremonyIds = item.getCeremonyItems().stream()
                .filter(ci -> ci.getCeremony() != null)
                .map(ci -> ci.getCeremony().getCeremonyId())
                .collect(Collectors.toList());
        }

        model.addAttribute("item", item);
        model.addAttribute("itemTypes", itemService.getAllItemTypes());
        model.addAttribute("groupedCeremonies", groupCeremoniesByType(ceremonyService.getAllCeremonies()));
        model.addAttribute("selectedCeremonyIds", selectedCeremonyIds);
        
        return "editItem"; 
    }

    // บันทึกข้อมูลการเพิ่มหรือแก้ไขอุปกรณ์
    @PostMapping("/save")
    public String saveItem(@ModelAttribute Item item,
                           @RequestParam int typeId,
                           @RequestParam(required = false) List<Integer> ceremonyIds,
                           RedirectAttributes ra) {
        try {
            boolean isEdit = item.getItemId() != 0;
            itemService.saveItem(item, typeId, ceremonyIds);
            ra.addFlashAttribute("success", isEdit ? "แก้ไขข้อมูลอุปกรณ์เรียบร้อยแล้ว" : "เพิ่มข้อมูลอุปกรณ์เรียบร้อยแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        return "redirect:/staff/items";
    }
   
    // ทำการลบอุปกรณ์แบบ Soft Delete 
    @PostMapping("/delete/{id}")
    public String deleteItem(@PathVariable int id, RedirectAttributes ra) {
        try {
            itemService.deleteItem(id);
            ra.addFlashAttribute("success", "ลบอุปกรณ์เรียบร้อยแล้ว");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาดในการลบอุปกรณ์");
        }
        return "redirect:/staff/items";
    }
}