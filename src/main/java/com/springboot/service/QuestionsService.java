package com.springboot.service;

import com.springboot.model.QuestionsDetail;
import com.springboot.model.Package;
import com.springboot.repository.QuestionsRepository;
import com.springboot.repository.PackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;


@Service
public class QuestionsService {

    @Autowired
    private QuestionsRepository questionsRepo;
    @Autowired
    private PackageRepository packageRepo;

    // ดึงคำถามทั้งหมดพร้อมข้อมูลแพ็กเกจที่ผูกอยู่
    public List<QuestionsDetail> getAllQuestions() {
        return questionsRepo.findAllWithPackage();
    }

    // ดึงคำถามของแพ็กเกจที่ระบุ รวมคำถามกลาง (global)
    public List<QuestionsDetail> getQuestionsByPackage(int packageId) {
        return questionsRepo.findByPackageIdIncludingGlobal(packageId);
    }

    // แปลงรายชื่อประเภทพิธีเป็น Package จริงในฐานข้อมูล (ไม่พบจะโยน exception)
    private List<Package> resolvePackagesByTypes(List<String> packageTypes) {
        List<Package> result = new ArrayList<>();
        if (packageTypes == null || packageTypes.isEmpty()) {
            return result;
        }
        for (String type : packageTypes) {
            if (type == null || type.equals("ALL") || type.isEmpty()) {
                continue;
            }
            List<Package> options = packageRepo.findByPackageType(type);
            if (options.isEmpty()) {
                throw new IllegalArgumentException("ไม่พบประเภทพิธีที่ระบุ: " + type);
            }
            result.addAll(options);
        }
        return result;
    }

    // เพิ่มคำถามใหม่และผูกกับแพ็กเกจตามประเภทที่เลือก
    @Transactional
    public void addQuestion(String questionText, List<String> packageTypes) {
        QuestionsDetail question = new QuestionsDetail(questionText);
        questionsRepo.saveAndFlush(question); // save ก่อนเพื่อให้มี id

        List<Package> packages = resolvePackagesByTypes(packageTypes);
        for (Package p : packages) {
            if (p.getQuestions() == null) {
                p.setQuestions(new ArrayList<>());
            }
            p.getQuestions().add(question);
        }
        packageRepo.saveAll(packages);
    }

    // ลบคำถามตาม id โดยตัดความสัมพันธ์กับแพ็กเกจก่อน
    @Transactional
    public void deleteQuestion(int id) {
        QuestionsDetail question = questionsRepo.findById(id).orElse(null);
        if (question == null) {
            return;
        }

        if (question.getPackages() != null) {
            for (Package p : new ArrayList<>(question.getPackages())) {
                if (p.getQuestions() != null) {
                    p.getQuestions().removeIf(q -> q.getQuestionsId() == question.getQuestionsId());
                }
            }
            packageRepo.saveAll(question.getPackages());
        }

        questionsRepo.deleteById(id);
    }

    // ดึงคำถามตาม id (ไม่พบคืน null)
    public QuestionsDetail getQuestionById(int id) {
        return questionsRepo.findById(id).orElse(null);
    }

    // แก้ไขข้อความคำถามและผูกแพ็กเกจใหม่ตามประเภทที่เลือก
    @Transactional
    public void updateQuestion(int id, String text, List<String> packageTypes) {
        QuestionsDetail existing = questionsRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ไม่พบคำถาม ID: " + id));

        existing.setQuestionsText(text);

        // ล้างความสัมพันธ์เดิมทั้งหมดก่อน (ฝั่งเจ้าของคือ Package)
        List<Package> oldPackages = existing.getPackages() != null
                ? new ArrayList<>(existing.getPackages()) : new ArrayList<>();
        for (Package p : oldPackages) {
            if (p.getQuestions() != null) {
                p.getQuestions().removeIf(q -> q.getQuestionsId() == existing.getQuestionsId());
            }
        }

        // ผูกความสัมพันธ์ใหม่ตามหลายประเภทงานที่เลือกมา
        List<Package> newPackages = resolvePackagesByTypes(packageTypes);
        for (Package p : newPackages) {
            if (p.getQuestions() == null) {
                p.setQuestions(new ArrayList<>());
            }
            boolean alreadyLinked = p.getQuestions().stream()
                    .anyMatch(q -> q.getQuestionsId() == existing.getQuestionsId());
            if (!alreadyLinked) {
                p.getQuestions().add(existing);
            }
        }

        // รวม package เก่า + ใหม่ (ไม่ซ้ำ) แล้ว save ทั้งหมด
        List<Package> toSave = new ArrayList<>(oldPackages);
        for (Package p : newPackages) {
            boolean alreadyInList = toSave.stream()
                    .anyMatch(x -> x.getPackageId() == p.getPackageId());
            if (!alreadyInList) {
                toSave.add(p);
            }
        }
        packageRepo.saveAll(toSave);
        questionsRepo.save(existing);
    }
}