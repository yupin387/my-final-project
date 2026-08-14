package com.springboot.repository;

import com.springboot.model.QuestionsDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface QuestionsRepository extends JpaRepository<QuestionsDetail, Integer> {

    // ดึงคำถามทั้งหมด พร้อม fetch ceremonies มาด้วย (กัน N+1 / lazy loading พัง)
    @Query("SELECT DISTINCT q FROM QuestionsDetail q LEFT JOIN FETCH q.ceremonies")
    List<QuestionsDetail> findAllWithCeremony();

    // คำถามที่ผูกกับ ceremony นี้โดยตรง + คำถาม "กลาง" ที่ไม่ผูกกับ ceremony ไหนเลย (ceremonies ว่าง)
    @Query("SELECT DISTINCT q FROM QuestionsDetail q LEFT JOIN q.ceremonies c " +
           "WHERE c.ceremonyId = :ceremonyId OR q.ceremonies IS EMPTY")
    List<QuestionsDetail> findByCeremonyIdIncludingGlobal(@Param("ceremonyId") int ceremonyId);
}