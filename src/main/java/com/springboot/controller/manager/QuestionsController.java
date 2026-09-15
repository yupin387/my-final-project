package com.springboot.controller.manager;

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

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/manager/questions") // ✅ แก้ไข: เปลี่ยนจาก organizer เป็น manager
public class QuestionsController {

    @Autowired
    private QuestionsService questionsService;

    @Autowired
    private CeremonyService ceremonyService;

    private static final List<String> CEREMONY_TYPE_ORDER =
        List.of("ทำบุญบ้าน", "ขึ้นบ้านใหม่", "ทำบุญบริษัทหรือออฟฟิศ");

    @GetMapping
    public String listQuestions(@RequestParam(required = false, defaultValue = "all") String ceremonyType,
                                Model model, HttpSession session) {
        // ✅ แก้ไข: เปลี่ยนเช็ค currentOrganizer เป็น currentManager และ redirect ไป loginmanager
        if (session.getAttribute("currentManager") == null) {
            return "redirect:/loginmanager";
        }

        List<Ceremony> ceremonies = ceremonyService.getAllCeremonies();

        List<String> ceremonyTypes = ceremonies.stream()
                .map(Ceremony::getCeremonyType)
                .filter(t -> t != null && !t.isBlank())
                .distinct()
                .collect(Collectors.toList());

        List<QuestionsDetail> allQuestions = questionsService.getAllQuestions();
        List<QuestionsDetail> questions;

        if ("all".equals(ceremonyType)) {
            questions = allQuestions;
        } else {
            questions = allQuestions.stream()
                    .filter(q -> q.getCeremonies() != null
                            && q.getCeremonies().stream()
                                    .anyMatch(c -> ceremonyType.equals(c.getCeremonyType())))
                    .collect(Collectors.toList());
        }

        model.addAttribute("selectedCeremonyType", ceremonyType);
        model.addAttribute("ceremonyTypes", ceremonyTypes);
        model.addAttribute("ceremonies", ceremonies);
        model.addAttribute("questions", questions);

        return "questionsList";
    }

    @GetMapping("/add")
    public String showAddForm(Model model, HttpSession session) {
        // ✅ แก้ไข: เปลี่ยนเช็ค currentOrganizer เป็น currentManager
        if (session.getAttribute("currentManager") == null) {
            return "redirect:/loginmanager";
        }

        model.addAttribute("ceremonyTypes", CEREMONY_TYPE_ORDER);
        return "addQuestion";
    }

    @PostMapping("/add")
    public String processAdd(@RequestParam String questionText,
                             @RequestParam(required = false) List<String> ceremonyTypes,
                             RedirectAttributes redirectAttrs) {
        try {
            questionsService.addQuestion(questionText,
                    ceremonyTypes != null ? ceremonyTypes : new ArrayList<>());
            redirectAttrs.addFlashAttribute("success", "เพิ่มคำถามเรียบร้อยแล้ว");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        // ✅ แก้ไข: เปลี่ยน redirect ไป manager/questions
        return "redirect:/manager/questions";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable int id,
                               Model model,
                               HttpSession session,
                               RedirectAttributes redirectAttrs) {
        // ✅ แก้ไข: เปลี่ยนเช็ค currentOrganizer เป็น currentManager
        if (session.getAttribute("currentManager") == null) {
            return "redirect:/loginmanager";
        }

        QuestionsDetail question = questionsService.getQuestionById(id);
        if (question == null) {
            redirectAttrs.addFlashAttribute("error", "ไม่พบข้อมูลคำถาม");
            return "redirect:/manager/questions";
        }

        List<String> selectedCeremonyTypes = new ArrayList<>();
        if (question.getCeremonies() != null) {
            selectedCeremonyTypes = question.getCeremonies().stream()
                    .map(Ceremony::getCeremonyType)
                    .filter(t -> t != null && !t.isBlank())
                    .distinct()
                    .collect(Collectors.toList());
        }

        model.addAttribute("question", question);
        model.addAttribute("selectedCeremonyTypes", selectedCeremonyTypes);
        model.addAttribute("ceremonyTypes", CEREMONY_TYPE_ORDER);
        return "editQuestion";
    }

    @PostMapping("/update")
    public String updateQuestion(@RequestParam int questionsId,
                                 @RequestParam String questionsText,
                                 @RequestParam(required = false) List<String> ceremonyTypes,
                                 RedirectAttributes redirectAttrs) {
        try {
            questionsService.updateQuestion(questionsId, questionsText,
                    ceremonyTypes != null ? ceremonyTypes : new ArrayList<>());
            redirectAttrs.addFlashAttribute("success", "แก้ไขข้อมูลเรียบร้อยแล้ว");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        // ✅ แก้ไข: เปลี่ยน redirect ไป manager/questions
        return "redirect:/manager/questions";
    }

    @PostMapping("/delete/{id}")
    public String deleteQuestion(@PathVariable int id,
                                 HttpSession session,
                                 RedirectAttributes redirectAttrs) {
        // ✅ แก้ไข: เปลี่ยนเช็ค currentOrganizer เป็น currentManager
        if (session.getAttribute("currentManager") == null) {
            return "redirect:/loginmanager";
        }

        questionsService.deleteQuestion(id);
        redirectAttrs.addFlashAttribute("success", "ลบคำถามเรียบร้อยแล้ว");
        // ✅ แก้ไข: เปลี่ยน redirect ไป manager/questions
        return "redirect:/manager/questions";
    }
}