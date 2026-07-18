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

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/organizer/questions")
public class QuestionsController {

    @Autowired
    private QuestionsService questionsService;

    @Autowired
    private CeremonyService ceremonyService;

    // ลำดับประเภทงานตายตัว ใช้ตอนจัดกลุ่ม dropdown ให้เรียงเหมือนกันทุกครั้ง
    private static final List<String> CEREMONY_TYPE_ORDER =
        List.of("ทำบุญบ้าน", "ขึ้นบ้านใหม่", "ทำบุญบริษัทหรือออฟฟิศ");

    // ลำดับระดับแพ็กเกจตายตัว ใช้จัดเรียง option ภายในแต่ละ optgroup
    private static final List<String> PACKAGE_ORDER =
        List.of("มาตรฐาน", "อิ่มบุญ", "พรีเมียม", "กำหนดเอง");

    // แก้ไข: dropdown "สำหรับประเภทพิธี" เดิมวน ceremonies ทั้ง 12 แถวแบบแบน ๆ
    // โชว์แค่ ceremonyName (ชื่อแพ็กเกจ) ทำให้มี option หน้าตาซ้ำกัน 4 แบบ x 3 รอบ
    // แยกไม่ออกว่าเป็นของประเภทงานไหน จึง group ตาม ceremonyType ไว้ล่วงหน้า
    // ให้ JSP ใช้ <optgroup> แบ่งเป็น 3 กลุ่มตามประเภทงานแทน
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

        // ดึงประเภทงานบุญที่มีอยู่จริงแบบไม่ซ้ำ (ปกติจะมี 3 ค่า)
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

        // แก้ไข: ส่ง ceremony ที่ group ตามประเภทงานแล้ว แทน list แบนที่แยกประเภทไม่ออก
        model.addAttribute("groupedCeremonies", groupCeremoniesByType(ceremonyService.getAllCeremonies()));
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
        // แก้ไข: ส่ง ceremony ที่ group ตามประเภทงานแล้ว แทน list แบนที่แยกประเภทไม่ออก
        model.addAttribute("groupedCeremonies", groupCeremoniesByType(ceremonyService.getAllCeremonies()));
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