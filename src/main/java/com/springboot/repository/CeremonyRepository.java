package com.springboot.repository;

import com.springboot.model.Ceremony;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
// เปลี่ยน String เป็น Integer
public interface CeremonyRepository extends JpaRepository<Ceremony, Integer> {

    // ค้นหาพิธีตามชื่อ
    List<Ceremony> findByCeremonyNameContaining(String name);

    // ดึงข้อมูลพิธีพร้อมโหลด items
    @Query("SELECT DISTINCT c FROM Ceremony c LEFT JOIN FETCH c.items")
    List<Ceremony> findAllWithItems();
}