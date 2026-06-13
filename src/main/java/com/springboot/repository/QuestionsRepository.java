package com.springboot.repository;

import com.springboot.model.QuestionsDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface QuestionsRepository extends JpaRepository<QuestionsDetail, Integer> { // เปลี่ยนเป็น Integer
    
    @Query("SELECT q FROM QuestionsDetail q LEFT JOIN FETCH q.ceremony ORDER BY q.ceremony.ceremonyName ASC")
    List<QuestionsDetail> findAllWithCeremony();

    
    @Query("SELECT q FROM QuestionsDetail q WHERE q.ceremony.ceremonyId = :ceremonyId OR q.ceremony IS NULL")
    List<QuestionsDetail> findByCeremonyIdIncludingGlobal(@Param("ceremonyId") int ceremonyId);
}