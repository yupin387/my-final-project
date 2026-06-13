package com.springboot.service;

import com.springboot.model.QuestionsDetail;
import com.springboot.model.Ceremony;
import com.springboot.repository.QuestionsRepository;
import com.springboot.repository.CeremonyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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

    // เปลี่ยนเป็น int
    public List<QuestionsDetail> getQuestionsByCeremony(int ceremonyId) {
        return questionsRepo.findByCeremonyIdIncludingGlobal(ceremonyId);
    }
    
    @Transactional
    public void addQuestion(String questionText, String ceremonyIdStr) {
        QuestionsDetail question = new QuestionsDetail();
        
        question.setQuestionsText(questionText);

        // ตรวจสอบค่าที่ส่งมาจากหน้าเว็บ (ถ้าเป็น "ALL" ให้เป็น null)
        if (ceremonyIdStr != null && !ceremonyIdStr.equals("ALL") && !ceremonyIdStr.isEmpty()) {
            int ceremonyId = Integer.parseInt(ceremonyIdStr); 
            Ceremony ceremony = ceremonyRepo.findById(ceremonyId)
                    .orElseThrow(() -> new IllegalArgumentException("ไม่พบประเภทพิธีที่ระบุ"));
            question.setCeremony(ceremony);
        } else {
            question.setCeremony(null);
        }

        questionsRepo.save(question);
    }
    
  
    public void deleteQuestion(int id) {
        questionsRepo.deleteById(id);
    }
    
  
    public QuestionsDetail getQuestionById(int id) {
        return questionsRepo.findById(id).orElse(null);
    }

    @Transactional
    public void updateQuestion(int id, String text, String ceremonyIdStr) {
        QuestionsDetail existing = questionsRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ไม่พบคำถาม ID: " + id));
        
        existing.setQuestionsText(text);

        if (ceremonyIdStr != null && !ceremonyIdStr.equals("ALL") && !ceremonyIdStr.isEmpty()) {
            int ceremonyId = Integer.parseInt(ceremonyIdStr);
            Ceremony ceremony = ceremonyRepo.findById(ceremonyId).orElse(null);
            existing.setCeremony(ceremony);
        } else {
            existing.setCeremony(null);
        }

        questionsRepo.save(existing);
    }
    
    
}