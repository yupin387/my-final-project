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

    // ลำดับประเภทงานตายตัว ใช้ populate dropdown "ประเภทงาน" ในฟอร์มเพิ่ม/แก้คำถาม
    private static final List<String> CEREMONY_TYPE_ORDER =
        List.of("ทำบุญบ้าน", "ขึ้นบ้านใหม่", "ทำบุญบริษัทหรือออฟฟิศ");

    // ===== หน้ารายการคำถาม — กรองตาม "ประเภทงานบุญ" (ceremonyType) ไม่ใช่รายแพ็กเกจ (ceremonyId)
    //       เพราะประเภทงานมีแค่ 3 ค่าตายตัว (ทำบุญบ้าน / ขึ้นบ้านใหม่ / ทำบุญออฟฟิศ)
    //       ในขณะที่แพ็กเกจ (ceremonyId) มีได้หลายรายการต่อประเภทงาน จึงไม่ควรใช้กรอง tab =====
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
            questions = allQuestions.stream()
                    .filter(q -> q.getCeremony() != null
                            && ceremonyType.equals(q.getCeremony().getCeremonyType()))
                    .collect(Collectors.toList());
        }

        model.addAttribute("selectedCeremonyType", ceremonyType);
        model.addAttribute("ceremonyTypes", ceremonyTypes);
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

        // แก้ไข: ฟอร์มเหลือแค่เลือก "ประเภทงาน" (3 ตัวเลือก) ไม่ต้องส่ง groupedCeremonies
        // ที่แยกแพ็กเกจแล้ว เพราะ service จะเลือกแพ็กเกจแรกของประเภทนั้นให้อัตโนมัติ
        model.addAttribute("ceremonyTypes", CEREMONY_TYPE_ORDER);
        return "addQuestion";
    }

    // ===== บันทึกการเพิ่มคำถาม =====
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
        model.addAttribute("ceremonyTypes", CEREMONY_TYPE_ORDER);
        return "editQuestion";
    }

    // ===== บันทึกการแก้ไข =====
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