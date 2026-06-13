package com.springboot.controller.headstaff;

import com.springboot.model.Item;
import com.springboot.service.ItemService;
import com.springboot.service.CeremonyService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

@Controller
@RequestMapping("/staff/items")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @Autowired
    private CeremonyService ceremonyService;

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
        
        return "itemList";
    }

    // แสดงหน้าฟอร์มสำหรับเพิ่มข้อมูลอุปกรณ์ใหม่เข้าสู่ระบบ
    @GetMapping("/add")
    public String showAddForm(Model model, HttpSession session) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginorganizer";
        
        model.addAttribute("item", new Item());
        model.addAttribute("itemTypes", itemService.getAllItemTypes());
        model.addAttribute("ceremonies", ceremonyService.getAllCeremonies());
        
        return "addItem"; 
    }

    // แสดงหน้าฟอร์มแก้ไขข้อมูลอุปกรณ์ตามรหัส (ID) ที่ระบุ
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable int id, Model model, HttpSession session) {
        if (session.getAttribute("currentStaff") == null) return "redirect:/loginorganizer";
        
        Item item = itemService.getItemById(id);
        model.addAttribute("item", item);
        model.addAttribute("itemTypes", itemService.getAllItemTypes());
        model.addAttribute("ceremonies", ceremonyService.getAllCeremonies());
        
        return "editItem"; 
    }

    // บันทึกข้อมูลการเพิ่มหรือแก้ไขอุปกรณ์ พร้อมเชื่อมโยงประเภทและพิธีที่เกี่ยวข้อง
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
   
    // ทำการลบอุปกรณ์แบบ Soft Delete โดยการเปลี่ยนสถานะการใช้งานแทนการลบทิ้งจริง
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