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

    // แก้ไข: รับ "หลายประเภทงาน" พร้อมกัน (ไม่ใช่แค่ตัวเดียวเหมือนเดิม)
    // แต่ละ ceremonyType ผูกได้กับ "ทุกแพ็กเกจ" ของประเภทนั้น (many-to-many)
    // ถ้า list ว่าง/null/มีแต่ ALL -> คืน list ว่าง = คำถาม "กลาง" ไม่ผูกกับ ceremony ไหนเลย
    private List<Ceremony> resolveCeremoniesByTypes(List<String> ceremonyTypes) {
        List<Ceremony> result = new ArrayList<>();
        if (ceremonyTypes == null || ceremonyTypes.isEmpty()) {
            return result;
        }
        for (String type : ceremonyTypes) {
            if (type == null || type.equals("ALL") || type.isEmpty()) {
                continue;
            }
            List<Ceremony> options = ceremonyRepo.findByCeremonyType(type);
            if (options.isEmpty()) {
                throw new IllegalArgumentException("ไม่พบประเภทพิธีที่ระบุ: " + type);
            }
            result.addAll(options);
        }
        return result;
    }

    // แก้ไข: เพิ่มคำถามใหม่ ผูกได้กับหลายประเภทงานพร้อมกันในครั้งเดียว
    // ยังคง save ฝั่ง Ceremony (owning side) เหมือนเดิม เพราะ QuestionsDetail
    // เป็นแค่ mappedBy เฉยๆ ถ้าไปเซตฝั่ง question อย่างเดียวจะไม่ถูกบันทึกลง join table
    @Transactional
    public void addQuestion(String questionText, List<String> ceremonyTypes) {
        QuestionsDetail question = new QuestionsDetail(questionText);
        questionsRepo.saveAndFlush(question); // save ก่อนเพื่อให้มี id

        List<Ceremony> ceremonies = resolveCeremoniesByTypes(ceremonyTypes);
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

    // แก้ไข: ล้างความสัมพันธ์เดิมทั้งหมด แล้วผูกใหม่ตามหลายประเภทงานที่เลือก
    @Transactional
    public void updateQuestion(int id, String text, List<String> ceremonyTypes) {
        QuestionsDetail existing = questionsRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ไม่พบคำถาม ID: " + id));

        existing.setQuestionsText(text);

        // ล้างความสัมพันธ์เดิมทั้งหมดก่อน (ฝั่งเจ้าของคือ Ceremony) ไม่ว่าจะผูกกับกี่ประเภทงานอยู่ก็ตาม
        if (existing.getCeremonies() != null) {
            for (Ceremony c : new ArrayList<>(existing.getCeremonies())) {
                if (c.getQuestions() != null) {
                    c.getQuestions().remove(existing);
                }
            }
        }

        // ผูกความสัมพันธ์ใหม่ตามหลายประเภทงานที่เลือกมา
        List<Ceremony> newCeremonies = resolveCeremoniesByTypes(ceremonyTypes);
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