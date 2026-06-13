package com.springboot.service;

import com.springboot.model.*;
import com.springboot.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class QuotationService {

	@Autowired
	private QuotationRepository quotationRepo;
	@Autowired
	private QuotationDetailRepository detailRepo;
	@Autowired
	private BookingFormRepository bookingRepo;
	@Autowired
	private ItemRepository itemRepo;
	@Autowired
	private HeadStaffRepository staffRepo;

	// เมธอดดึงข้อมูลพื้นฐาน (Read Operations)
	public List<Item> getAllItems() {
		return itemRepo.findAll();
	}

	public List<HeadStaff> getAllStaff() {
		return staffRepo.findAll();
	}

	public Quotation getQuotationById(String id) {
		return quotationRepo.findById(id).orElse(null);
	}

	public List<Quotation> getAllQuotations() {
		return quotationRepo.findAll();
	}

	public List<Quotation> getQuotationsByStatus(String status) {
		return quotationRepo.findByQuotationStatus(status);
	}

	public List<QuotationDetail> getDetailsByQuotationId(String id) {
		return detailRepo.findByQuotation_QuotationId(id);
	}


	

	public List<Item> getItemsByCeremonyId(int id) {
		return itemRepo.findByCeremonies_CeremonyId(id);
	}

	public Quotation getLatestQuotationByMemberId(Integer id) {
		return quotationRepo.findFirstByBookingFormMemberMemberIdOrderByQuotationIdDesc(id);
	}

	// ==========================================
	// 1. ฝั่ง Organizer (สร้าง/แก้ไขใบเสนอราคา)
	// ==========================================

	// สร้างใบเสนอราคาใหม่จากการจอง
	@Transactional
	public Quotation createQuotation(String bookingId, 
	                                 List<Integer> itemIds, List<Integer> qtys, List<Double> extraPrices, 
	                                 List<String> detailNotes,
	                                 List<String> bNames, List<Integer> bQtys, List<Double> bPrices) {
	    
	    BookingForm booking = bookingRepo.findById(bookingId).orElseThrow();
	    Quotation qt = new Quotation();
	    qt.setQuotationId("QT-" + booking.getBookingId());
	    qt.setBookingForm(booking);
	    qt.setQuotationDate(new Date());
	    qt.setQuotationStatus("Pending");
	    qt.setTotalAmount(0.0);
	    qt = quotationRepo.save(qt);

	    // ส่งรายการทั้ง 2 ชุดเข้าไปคำนวณและบันทึก
	    saveDetailsAndCalculateTotal(qt, itemIds, qtys, extraPrices, detailNotes, bNames, bQtys, bPrices);
	    
	    return quotationRepo.save(qt);
	}
	
	// แก้ไขใบเสนอราคาเดิม โดยลบรายการเก่าออกแล้วสร้างใหม่
	@Transactional
	public void updateQuotation(String quotationId, 
	                            List<Integer> itemIds, List<Integer> qtys, List<Double> extraPrices, List<String> detailNotes,
	                            List<String> bNames, List<Integer> bQtys, List<Double> bPrices) { // รับพารามิเตอร์เพิ่ม
	    
	    Quotation qt = quotationRepo.findById(quotationId).orElseThrow();

	    // ล้างรายการเดิมเพื่อคำนวณยอดใหม่
	    detailRepo.deleteByQuotation_QuotationId(quotationId);

	    // อัปเดตสถานะกลับเป็น Pending เพื่อให้ลูกค้ากลับมาตรวจสอบใหม่
	    qt.setQuotationStatus("Pending");
	    quotationRepo.save(qt);

	    // ส่งพารามิเตอร์ทั้งหมดรวมถึงชุดรายการจาก Booking (bNames, bQtys, bPrices) เข้าไป
	    saveDetailsAndCalculateTotal(qt, itemIds, qtys, extraPrices, detailNotes, bNames, bQtys, bPrices);
	}
	
	// ==========================================
		//(คำนวณเงินและบันทึกตารางย่อย)
	// ==========================================

	// เมทธอดนี้ต้องรับค่าเพิ่มคือ bNames (ชื่อ), bQtys (จำนวน), bPrices (ราคาที่กรอกเอง)
	// เมทธอดนี้ให้คุณนำไปวางแทนที่ตัวเดิมใน QuotationService.java
	private void saveDetailsAndCalculateTotal(Quotation qt, 
	                                          List<Integer> itemIds, List<Integer> qtys, List<Double> extraPrices, List<String> detailNotes,
	                                          List<String> bNames, List<Integer> bQtys, List<Double> bPrices) {
	    double total = 0.0;

	    // 1. บันทึกรายการจาก Popup (ที่มี itemId ในระบบอยู่แล้ว)
	    if (itemIds != null && qtys != null) {
	        for (int i = 0; i < itemIds.size(); i++) {
	            if (itemIds.get(i) == null) continue;
	            
	            Item item = itemRepo.findById(itemIds.get(i)).orElse(null);
	            if (item != null) {
	                double price = (extraPrices != null && i < extraPrices.size() && extraPrices.get(i) != null) 
	                               ? extraPrices.get(i) : item.getPricePerUnit();
	                int qty = (i < qtys.size()) ? qtys.get(i) : 0;
	                
	                QuotationDetail detail = new QuotationDetail();
	                detail.setQuotation(qt);
	                detail.setItem(item); // บันทึกความสัมพันธ์กับ Item จริงในฐานข้อมูล
	                detail.setQuantity(qty);
	                detail.setSubtotal(price * qty);
	                if (detailNotes != null && i < detailNotes.size()) detail.setNote(detailNotes.get(i));
	                
	                detailRepo.save(detail);
	                total += (price * qty);
	            }
	        }
	    }

	    // 2. บันทึกรายการที่ลูกค้าจองมาเอง (ไม่มี itemId ในฐานข้อมูล)
	    // เราจะใช้ Item จำลองเพื่อเก็บชื่อและราคาไปใส่ในตาราง QuotationDetail
	    if (bNames != null && bQtys != null) {
	        for (int i = 0; i < bNames.size(); i++) {
	            String name = bNames.get(i);
	            int qty = (i < bQtys.size()) ? bQtys.get(i) : 0;
	            double price = (bPrices != null && i < bPrices.size() && bPrices.get(i) != null)
	                           ? bPrices.get(i) : 0.0;

	            // ✅ ดึง Item จริงจาก DB แทนการสร้างจำลอง
	            Item item = itemRepo.findByItemName(name.trim()).orElse(null);
	            if (item == null) continue; // ข้ามถ้าไม่เจอ

	            QuotationDetail detail = new QuotationDetail();
	            detail.setQuotation(qt);
	            detail.setItem(item);
	            detail.setQuantity(qty);
	            detail.setSubtotal(price * qty);
	            detail.setNote("รายการพิเศษจากลูกค้า");

	            detailRepo.save(detail);
	            total += (price * qty);
	        }
	    }

	    // บันทึกยอดรวมทั้งหมดลง Quotation
	    qt.setTotalAmount(total);
	    quotationRepo.save(qt);
	}
	
	
		// เปลี่ยนสถานะใบเสนอราคาเป็น Confirmed (ตกลงจ้าง)
		@Transactional
		public void confirmQuotation(String id) {
			Quotation q = quotationRepo.findById(id).orElseThrow();
			q.setQuotationStatus("Confirmed");
			if (q.getBookingForm() != null)
				q.getBookingForm().setBookingStatus("Confirmed");
		}

		// หาพนักงานที่ว่างในวันที่กำหนด
		public List<HeadStaff> findAvailableStaff(Date eventDate) {
			return staffRepo.findAvailableStaff(eventDate);
		}

		// มอบหมายพนักงาน (Assign) ให้กับใบเสนอราคา
		@Transactional
		public void assignStaffToQuotation(String bookingId, Integer staffId) {
			Quotation quotation = quotationRepo.findByBookingForm_BookingId(bookingId);
			HeadStaff staff = staffRepo.findById(staffId).orElse(null);

			if (quotation != null && staff != null) {
				quotation.setStaff(staff);
				quotationRepo.save(quotation); // อย่าลืมเซฟข้อมูลพนักงานที่ถูก Assign
			}
		}

		
		
	// ==========================================
	// 2. ฝั่ง Member (ลูกค้าแจ้งแก้ไขรายการ)
	// ==========================================

		@Transactional
		public void submitMemberRevision(String quotationId, List<Integer> itemIds, List<String> memberNotes) {
			Quotation qt = quotationRepo.findById(quotationId).orElseThrow();
			qt.setQuotationStatus("Revised");
			quotationRepo.save(qt);

			if (itemIds == null || memberNotes == null) return;

			List<QuotationDetail> details = detailRepo.findByQuotation_QuotationId(quotationId);

			for (int i = 0; i < itemIds.size(); i++) {
				String note = (i < memberNotes.size()) ? memberNotes.get(i) : "";
				if (note == null || note.trim().isEmpty()) continue;

				int targetItemId = itemIds.get(i);

				for (QuotationDetail d : details) {
					if (d.getItem() != null && d.getItem().getItemId() == targetItemId) {
						d.setNote("[ลูกค้าขอแก้]: " + note.trim());
						detailRepo.save(d);
						break;
					}
				}
			}

			quotationRepo.save(qt);
		}
}