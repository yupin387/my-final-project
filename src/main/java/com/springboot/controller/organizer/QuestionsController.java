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
import java.util.stream.Collectors;

@Controller
@RequestMapping("/organizer/questions")
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
        if (session.getAttribute("currentOrganizer") == null) {
            return "redirect:/loginorganizer";
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
            // แก้ไข: เช็คจาก list ของ ceremonies แทนที่จะเช็คตัวเดียว
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
        if (session.getAttribute("currentOrganizer") == null) {
            return "redirect:/loginorganizer";
        }

        model.addAttribute("ceremonyTypes", CEREMONY_TYPE_ORDER);
        return "addQuestion";
    }

    @PostMapping("/add")
    public String processAdd(@RequestParam String questionText,
                             @RequestParam String ceremonyType,
                             RedirectAttributes redirectAttrs) {
        try {
            questionsService.addQuestion(questionText, ceremonyType);
            redirectAttrs.addFlashAttribute("success", "เพิ่มคำถามเรียบร้อยแล้ว");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        return "redirect:/organizer/questions";
    }

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

        // แก้ไข: เดิมอ่านจาก question.getCeremony().getCeremonyType() ตัวเดียว
        // ตอนนี้เป็น list -> ใช้ตัวแรกเป็นตัวแทนแสดงใน dropdown ของฟอร์มแก้ไข
        String currentCeremonyType = (question.getCeremonies() != null && !question.getCeremonies().isEmpty())
                ? question.getCeremonies().get(0).getCeremonyType()
                : "ALL";

        model.addAttribute("question", question);
        model.addAttribute("currentCeremonyType", currentCeremonyType);
        model.addAttribute("ceremonyTypes", CEREMONY_TYPE_ORDER);
        return "editQuestion";
    }

    @PostMapping("/update")
    public String updateQuestion(@RequestParam int questionsId,
                                 @RequestParam String questionsText,
                                 @RequestParam String ceremonyType,
                                 RedirectAttributes redirectAttrs) {
        try {
            questionsService.updateQuestion(questionsId, questionsText, ceremonyType);
            redirectAttrs.addFlashAttribute("success", "แก้ไขข้อมูลเรียบร้อยแล้ว");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
        }
        return "redirect:/organizer/questions";
    }

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