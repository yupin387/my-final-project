package com.springboot.repository;

import com.springboot.model.Quotation;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface QuotationRepository extends JpaRepository<Quotation, String> {
    
    // ค้นหาใบเสนอราคาด้วยรหัสการจอง
    Quotation findByBookingForm_BookingId(String bookingId);
    
    // ค้นหาใบเสนอราคาตามสถานะ (เช่น รอดำเนินการ, อนุมัติแล้ว)
    List<Quotation> findByQuotationStatus(String status);
    
        
    // ค้นหาใบเสนอราคาที่ดูแลโดยพนักงานท่านนั้น
    List<Quotation> findByStaff_StaffId(int staffId);
    
    
    //=====================================
    
    //   ค้นหาใบเสนอราคาล่าสุดของสมาชิกท่านนั้น (ใช้ MemberId ในการหา)
    Quotation findFirstByBookingFormMemberMemberIdOrderByQuotationIdDesc(Integer memberId);
}