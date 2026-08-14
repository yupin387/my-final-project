package com.springboot.service;

import com.springboot.model.QuestionsDetail;
import com.springboot.model.Ceremony;
import com.springboot.repository.QuestionsRepository;
import com.springboot.repository.CeremonyRepository;
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
    private CeremonyRepository ceremonyRepo;

    public List<QuestionsDetail> getAllQuestions() {
        return questionsRepo.findAllWithCeremony();
    }

    public List<QuestionsDetail> getQuestionsByCeremony(int ceremonyId) {
        return questionsRepo.findByCeremonyIdIncludingGlobal(ceremonyId);
    }

    // แก้ไข: many-to-many แล้ว หนึ่ง ceremonyType ผูกได้กับ "ทุกแพ็กเกจ" ของประเภทนั้น
    // (ไม่ต้องเลือกแพ็กเกจตัวแทนตัวเดียวเหมือนตอน ManyToOne อีกแล้ว)
    // ถ้า ceremonyType เป็น null/ALL/ว่าง -> คืน list ว่าง = คำถาม "กลาง" ไม่ผูกกับ ceremony ไหน
    private List<Ceremony> resolveCeremoniesByType(String ceremonyType) {
        if (ceremonyType == null || ceremonyType.equals("ALL") || ceremonyType.isEmpty()) {
            return new ArrayList<>();
        }
        List<Ceremony> options = ceremonyRepo.findByCeremonyType(ceremonyType);
        if (options.isEmpty()) {
            throw new IllegalArgumentException("ไม่พบประเภทพิธีที่ระบุ: " + ceremonyType);
        }
        return options;
    }

    // แก้ไข: เพิ่มคำถามใหม่ แล้วผูกจากฝั่ง Ceremony (owning side) เพราะ QuestionsDetail
    // เป็นแค่ mappedBy เฉยๆ ถ้าไปเซตฝั่ง question อย่างเดียวจะไม่ถูกบันทึกลง join table
    @Transactional
    public void addQuestion(String questionText, String ceremonyType) {
        QuestionsDetail question = new QuestionsDetail(questionText);
        questionsRepo.saveAndFlush(question); // save ก่อนเพื่อให้มี id

        List<Ceremony> ceremonies = resolveCeremoniesByType(ceremonyType);
        for (Ceremony c : ceremonies) {
            if (c.getQuestions() == null) {
                c.setQuestions(new ArrayList<>());
            }
            c.getQuestions().add(question);
        }
        ceremonyRepo.saveAll(ceremonies);
    }

    // แก้ไข: ก่อนลบ ต้องเอาคำถามออกจากทุก ceremony ที่ผูกอยู่ก่อน (ฝั่งเจ้าของ join table)
    // ไม่งั้นจะชน foreign key constraint ตอนลบแถวใน Questionsdetail
    @Transactional
    public void deleteQuestion(int id) {
        QuestionsDetail question = questionsRepo.findById(id).orElse(null);
        if (question == null) {
            return;
        }

        if (question.getCeremonies() != null) {
            for (Ceremony c : new ArrayList<>(question.getCeremonies())) {
                if (c.getQuestions() != null) {
                    c.getQuestions().remove(question);
                }
            }
            ceremonyRepo.saveAll(question.getCeremonies());
        }

        questionsRepo.deleteById(id);
    }

    public QuestionsDetail getQuestionById(int id) {
        return questionsRepo.findById(id).orElse(null);
    }

    // แก้ไข: ล้างความสัมพันธ์เดิมทั้งหมด แล้วผูกใหม่ตาม ceremonyType ที่เลือก
    @Transactional
    public void updateQuestion(int id, String text, String ceremonyType) {
        QuestionsDetail existing = questionsRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ไม่พบคำถาม ID: " + id));

        existing.setQuestionsText(text);

        // ล้างความสัมพันธ์เดิม (ฝั่งเจ้าของคือ Ceremony)
        if (existing.getCeremonies() != null) {
            for (Ceremony c : new ArrayList<>(existing.getCeremonies())) {
                if (c.getQuestions() != null) {
                    c.getQuestions().remove(existing);
                }
            }
        }

        // ผูกความสัมพันธ์ใหม่
        List<Ceremony> newCeremonies = resolveCeremoniesByType(ceremonyType);
        for (Ceremony c : newCeremonies) {
            if (c.getQuestions() == null) {
                c.setQuestions(new ArrayList<>());
            }
            c.getQuestions().add(existing);
        }

        ceremonyRepo.saveAll(newCeremonies);
        questionsRepo.save(existing);
    }
}