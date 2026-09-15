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

    // ดึงคำถามทั้งหมด พร้อมข้อมูลพิธีที่ผูกอยู่ (fetch ceremony มาด้วย)
    public List<QuestionsDetail> getAllQuestions() {
        return questionsRepo.findAllWithCeremony();
    }

    // ดึงคำถามที่ใช้กับพิธีตาม ceremonyId ที่ระบุ รวมถึงคำถามที่เป็น "คำถามกลาง" (global) ด้วย
    public List<QuestionsDetail> getQuestionsByCeremony(int ceremonyId) {
        return questionsRepo.findByCeremonyIdIncludingGlobal(ceremonyId);
    }

    // แปลงรายชื่อ "ประเภทพิธี" (string) ให้เป็น list ของ Ceremony จริงในฐานข้อมูล
    // ข้าม type ที่เป็น null, "ALL" หรือค่าว่าง — ถ้าระบุ type มาแต่หาไม่เจอเลยจะโยน exception
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

    // เพิ่มคำถามใหม่ แล้วผูกกับพิธีตามประเภทที่เลือก (ผูกได้หลายประเภทพร้อมกัน)
    // save คำถามก่อนเพื่อให้มี id ก่อนนำไปผูกความสัมพันธ์กับ Ceremony
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

    // ลบคำถามตาม id: ตัดความสัมพันธ์กับทุกพิธีที่ผูกอยู่ก่อน แล้วค่อยลบตัวคำถามออก
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

    // ดึงคำถามตาม id คืนค่า null ถ้าไม่พบ
    public QuestionsDetail getQuestionById(int id) {
        return questionsRepo.findById(id).orElse(null);
    }

    // แก้ไขคำถามที่มีอยู่: อัปเดตข้อความคำถาม แล้วล้างความสัมพันธ์กับพิธีเดิมทั้งหมด
    // ก่อนผูกใหม่ตามรายการประเภทพิธีที่เลือกมาล่าสุด
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