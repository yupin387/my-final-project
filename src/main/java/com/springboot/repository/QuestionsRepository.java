package com.springboot.repository;

import com.springboot.model.QuestionsDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface QuestionsRepository extends JpaRepository<QuestionsDetail, Integer> {

    // ดึงคำถามทั้งหมด 
    // เรียงตาม questionsId (ลำดับการสร้าง) เพื่อให้คำถามที่เพิ่มใหม่ไปต่อท้ายเสมอ
    @Query("SELECT DISTINCT q FROM QuestionsDetail q LEFT JOIN FETCH q.packages ORDER BY q.questionsId ASC")
    List<QuestionsDetail> findAllWithPackage();

    // คำถามที่ผูกกับ package นี้โดยตรง + คำถาม "กลาง" ที่ไม่ผูกกับ package ไหนเลย (packages ว่าง)
    @Query("SELECT DISTINCT q FROM QuestionsDetail q LEFT JOIN q.packages c " +
           "WHERE c.packageId = :packageId OR q.packages IS EMPTY")
    List<QuestionsDetail> findByPackageIdIncludingGlobal(@Param("packageId") int packageId);
    
   

}