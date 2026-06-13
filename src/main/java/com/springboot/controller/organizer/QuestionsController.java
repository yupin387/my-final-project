package com.springboot.controller.organizer;

import com.springboot.model.QuestionsDetail;
import com.springboot.model.Ceremony;
import com.springboot.service.CeremonyService;
import com.springboot.service.QuestionsService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/organizer/questions")
public class QuestionsController {

    @Autowired
    private QuestionsService questionsService;

    @Autowired
    private CeremonyService ceremonyService;

    // ===== แสดงรายการคำถาม =====  แก้ตรงนี้ด้วย ล่าสุด
    @GetMapping
    public String listQuestions(@RequestParam(required = false) String ceremonyId, 
                                Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) {
            return "redirect:/loginorganizer";
        }

        List<Ceremony> ceremonies = ceremonyService.getAllCeremonies();
        List<QuestionsDetail> questions;

        if (ceremonyId != null) {
        	questions = questionsService.getQuestionsByCeremony(Integer.parseInt(ceremonyId));
            model.addAttribute("selectedCeremony", ceremonyId);
        } else {
            // กรณีนี้คือไม่ได้เลือกพิธี (ถ้าจะแสดงทั้งหมด)
            questions = questionsService.getAllQuestions();
            model.addAttribute("selectedCeremony", "all");
        }

        model.addAttribute("ceremonies", ceremonies);
        model.addAttribute("questions", questions);
        
        return "questionsList";
    }
    
    // ===== หน้าฟอร์มเพิ่มคำถาม =====
    @GetMapping("/add")
    public String showAddForm(Model model, HttpSession session) {
        if (session.getAttribute("currentOrganizer") == null) {
            return "redirect:/loginorganizer";
        }
        
        model.addAttribute("ceremonies", ceremonyService.getAllCeremonies()); 
        return "addQuestion"; 
    }
    
    //แก้ตรงยนี้ ล่าสุด
    // ===== บันทึกการเพิ่มคำถาม =====
    @PostMapping("/add")
    public String processAdd(@RequestParam String questionText,
                             @RequestParam int ceremonyId, // เปลี่ยนจาก String เป็น int ให้ตรงกับประเภทข้อมูล
                             RedirectAttributes redirectAttrs) {
        try {
            // ส่งเป็น String ตามเดิมถ้า Service ของคุณรับเป็น String
            questionsService.addQuestion(questionText, String.valueOf(ceremonyId));
            redirectAttrs.addFlashAttribute("success", "เพิ่มคำถามเรียบร้อยแล้ว");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        return "redirect:/organizer/questions";
    }
    
    // ===== หน้าฟอร์มแก้ไขคำถาม =====
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable int id, 
                               Model model, 
                               HttpSession session, 
                               RedirectAttributes redirectAttrs) {
        if (session.getAttribute("currentOrganizer") == null) {
            return "redirect:/loginorganizer";
        }

        QuestionsDetail question = questionsService.getQuestionById(id);
        if (question == null) {
            redirectAttrs.addFlashAttribute("error", "ไม่พบข้อมูลคำถาม");
            return "redirect:/organizer/questions";
        }

        model.addAttribute("question", question);
        model.addAttribute("ceremonies", ceremonyService.getAllCeremonies());
        return "editQuestion"; 
    }

    // ===== บันทึกการแก้ไข =====
    @PostMapping("/update")
    public String updateQuestion(@RequestParam int questionsId, 
                                 @RequestParam String questionsText,
                                 @RequestParam String ceremonyId,
                                 RedirectAttributes redirectAttrs) {
        try {
            questionsService.updateQuestion(questionsId, questionsText, ceremonyId);
            redirectAttrs.addFlashAttribute("success", "แก้ไขข้อมูลเรียบร้อยแล้ว");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        return "redirect:/organizer/questions";
    }
    
    // ===== ลบคำถาม =====
    @PostMapping("/delete/{id}")
    public String deleteQuestion(@PathVariable int id, 
                                 HttpSession session,
                                 RedirectAttributes redirectAttrs) {
        if (session.getAttribute("currentOrganizer") == null) {
            return "redirect:/loginorganizer";
        }

        questionsService.deleteQuestion(id);
        redirectAttrs.addFlashAttribute("success", "ลบคำถามเรียบร้อยแล้ว");
        return "redirect:/organizer/questions";
    }
}