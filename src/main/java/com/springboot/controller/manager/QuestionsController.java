package com.springboot.controller.manager;

import com.springboot.model.QuestionsDetail;

import com.springboot.model.Package;
import com.springboot.service.PackageService;
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
import java.util.Comparator;

@Controller
@RequestMapping("/manager/questions")
public class QuestionsController {

	@Autowired
	private QuestionsService questionsService;

	@Autowired
	private PackageService packageService;

	// ลำดับการแสดงผลของประเภทงานบุญ (ใช้ในฟอร์มเพิ่ม/แก้ไขคำถาม)
	// แก้ไขชื่อตัวแปรให้สอดคล้องกับ Package
	private static final List<String> PACKAGE_TYPE_ORDER = List.of("ทำบุญบ้าน", "ขึ้นบ้านใหม่",
			"ทำบุญบริษัทหรือออฟฟิศ");

	// แสดงรายการคำถามทั้งหมด รองรับการกรองตามประเภทงานบุญ (packageType)
	@GetMapping
	public String listQuestions(@RequestParam(required = false, defaultValue = "all") String packageType, Model model,
			HttpSession session) {

		if (session.getAttribute("currentManager") == null) {
			return "redirect:/loginmanager";
		}

		List<Package> packages = packageService.getAllPackages();

		List<String> packageTypes = packages.stream().map(Package::getPackageType)
				.filter(t -> t != null && !t.isBlank()).distinct().sorted(Comparator.comparingInt(t -> {
					int i = PACKAGE_TYPE_ORDER.indexOf(t);
					return i < 0 ? Integer.MAX_VALUE : i;
				})).collect(Collectors.toList());

		List<QuestionsDetail> allQuestions = questionsService.getAllQuestions();
		List<QuestionsDetail> questions;

		if ("all".equals(packageType)) {
			questions = allQuestions;
		} else {
			questions = allQuestions.stream()
					.filter(q -> q.getPackages() != null
							&& q.getPackages().stream().anyMatch(c -> packageType.equals(c.getPackageType())))
					.collect(Collectors.toList());
		}

		model.addAttribute("selectedPackageType", packageType);
		model.addAttribute("packageTypes", packageTypes);
		model.addAttribute("packages", packages);
		model.addAttribute("questions", questions);

		return "questionsList";
	}

	// แสดงหน้าฟอร์มสำหรับเพิ่มคำถามใหม่
	@GetMapping("/add")
	public String showAddForm(Model model, HttpSession session) {

		if (session.getAttribute("currentManager") == null) {
			return "redirect:/loginmanager";
		}

		model.addAttribute("packageTypes", PACKAGE_TYPE_ORDER);
		return "addQuestion";
	}

	// บันทึกคำถามใหม่ลงในระบบ พร้อมผูกกับประเภทงานบุญที่เลือก
	@PostMapping("/add")
	public String processAdd(@RequestParam String questionText,
			@RequestParam(required = false) List<String> packageTypes, RedirectAttributes redirectAttrs) {
		try {
			questionsService.addQuestion(questionText, packageTypes != null ? packageTypes : new ArrayList<>());
			redirectAttrs.addFlashAttribute("success", "เพิ่มคำถามเรียบร้อยแล้ว");
		} catch (Exception e) {
			redirectAttrs.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
		}

		return "redirect:/manager/questions";
	}

	// แสดงหน้าฟอร์มแก้ไขคำถามที่มีอยู่แล้ว
	// พร้อมดึงประเภทงานบุญที่คำถามนี้ถูกผูกไว้มาเติมล่วงหน้า
	@GetMapping("/edit/{id}")
	public String showEditForm(@PathVariable int id, Model model, HttpSession session,
			RedirectAttributes redirectAttrs) {

		if (session.getAttribute("currentManager") == null) {
			return "redirect:/loginmanager";
		}

		QuestionsDetail question = questionsService.getQuestionById(id);
		if (question == null) {
			redirectAttrs.addFlashAttribute("error", "ไม่พบข้อมูลคำถาม");
			return "redirect:/manager/questions";
		}

		List<String> selectedPackageTypes = new ArrayList<>();
		if (question.getPackages() != null) {
			selectedPackageTypes = question.getPackages().stream().map(Package::getPackageType)
					.filter(t -> t != null && !t.isBlank()).distinct().collect(Collectors.toList());
		}

		model.addAttribute("question", question);

		model.addAttribute("selectedPackageTypes", selectedPackageTypes);
		model.addAttribute("packageTypes", PACKAGE_TYPE_ORDER);
		return "editQuestion";
	}

	// บันทึกการแก้ไขคำถาม ทั้งข้อความคำถามและประเภทงานบุญที่ผูกอยู่
	@PostMapping("/update")
	public String updateQuestion(@RequestParam int questionsId, @RequestParam String questionsText,
			@RequestParam(required = false) List<String> packageTypes, RedirectAttributes redirectAttrs) {
		try {
			questionsService.updateQuestion(questionsId, questionsText,
					packageTypes != null ? packageTypes : new ArrayList<>());
			redirectAttrs.addFlashAttribute("success", "แก้ไขข้อมูลเรียบร้อยแล้ว");
		} catch (Exception e) {
			redirectAttrs.addFlashAttribute("error", "เกิดข้อผิดพลาด: " + e.getMessage());
		}

		return "redirect:/manager/questions";
	}

	// ลบคำถามออกจากระบบตามรหัส id ที่ระบุ
	@PostMapping("/delete/{id}")
	public String deleteQuestion(@PathVariable int id, HttpSession session, RedirectAttributes redirectAttrs) {

		if (session.getAttribute("currentManager") == null) {
			return "redirect:/loginmanager";
		}

		questionsService.deleteQuestion(id);
		redirectAttrs.addFlashAttribute("success", "ลบคำถามเรียบร้อยแล้ว");

		return "redirect:/manager/questions";
	}
}