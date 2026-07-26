package com.springboot.service;
import com.springboot.model.QuestionsDetail;
import com.springboot.model.Ceremony;
import com.springboot.repository.QuestionsRepository;
import com.springboot.repository.CeremonyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Comparator;
import java.util.List;

@Service
public class QuestionsService {
    @Autowired
    private QuestionsRepository questionsRepo;
    @Autowired
    private CeremonyRepository ceremonyRepo;

    // ลำดับระดับแพ็กเกจตายตัว ใช้เลือก "แพ็กเกจแรก" ของประเภทงานที่เลือกให้อัตโนมัติ
    // เพราะฟอร์มเพิ่ม/แก้คำถามตอนนี้ให้ผู้ใช้เลือกแค่ ceremonyType ไม่ได้เจาะจงแพ็กเกจ
    // แต่ QuestionsDetail.ceremony ยังผูกกับ Ceremony แถวใดแถวหนึ่งอยู่ (ManyToOne เดิม)
    private static final List<String> PACKAGE_ORDER =
        List.of("มาตรฐาน", "อิ่มบุญ", "พรีเมียม", "กำหนดเอง");

    public List<QuestionsDetail> getAllQuestions() {
        return questionsRepo.findAllWithCeremony();
    }

    // เปลี่ยนเป็น int
    public List<QuestionsDetail> getQuestionsByCeremony(int ceremonyId) {
        return questionsRepo.findByCeremonyIdIncludingGlobal(ceremonyId);
    }

    // แก้ไข: หาแพ็กเกจแรก (ตามลำดับ PACKAGE_ORDER) ของ ceremonyType ที่ระบุ
    // ถ้าไม่ระบุ/เป็น "ALL" ให้ถือเป็นคำถามทั่วไป (ceremony = null) เหมือนพฤติกรรมเดิม
    private Ceremony resolveDefaultCeremony(String ceremonyType) {
        if (ceremonyType == null || ceremonyType.equals("ALL") || ceremonyType.isEmpty()) {
            return null;
        }
        List<Ceremony> options = ceremonyRepo.findByCeremonyType(ceremonyType);
        if (options.isEmpty()) {
            throw new IllegalArgumentException("ไม่พบประเภทพิธีที่ระบุ: " + ceremonyType);
        }
        return options.stream()
                .min(Comparator.comparingInt(c -> {
                    int idx = PACKAGE_ORDER.indexOf(c.getCeremonyName());
                    return idx < 0 ? PACKAGE_ORDER.size() : idx;
                }))
                .orElse(options.get(0));
    }

    // แก้ไข: รับ ceremonyType (String) แทน ceremonyId เพราะฟอร์มเหลือแค่เลือกประเภทงาน
    @Transactional
    public void addQuestion(String questionText, String ceremonyType) {
        QuestionsDetail question = new QuestionsDetail();
        question.setQuestionsText(questionText);
        question.setCeremony(resolveDefaultCeremony(ceremonyType));
        questionsRepo.save(question);
    }

    public void deleteQuestion(int id) {
        questionsRepo.deleteById(id);
    }

    public QuestionsDetail getQuestionById(int id) {
        return questionsRepo.findById(id).orElse(null);
    }

    // แก้ไข: รับ ceremonyType (String) แทน ceremonyId เช่นเดียวกับ addQuestion
    @Transactional
    public void updateQuestion(int id, String text, String ceremonyType) {
        QuestionsDetail existing = questionsRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ไม่พบคำถาม ID: " + id));

        existing.setQuestionsText(text);
        existing.setCeremony(resolveDefaultCeremony(ceremonyType));
        questionsRepo.save(existing);
    }
}