package com.springboot.repository;

import com.springboot.model.QuotationDetail;
import com.springboot.model.QuotationDetailId;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface QuotationDetailRepository extends JpaRepository<QuotationDetail, QuotationDetailId> {
   
    // ดึงรายการไอเทมในใบเสนอราคา
    List<QuotationDetail> findByQuotation_QuotationId(String quotationId);
    
    @Modifying
    @Transactional
    // ลบรายการไอเทมเดิมออก (ใช้บ่อยตอน Update ใบเสนอราคา)
    void deleteByQuotation_QuotationId(String quotationId);
}