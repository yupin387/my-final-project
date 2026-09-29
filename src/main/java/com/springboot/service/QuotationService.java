package com.springboot.service;

import com.springboot.model.*;
import com.springboot.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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



	// ดึงอุปกรณ์ทั้งหมดในระบบ
	public List<Item> getAllItems() {
		return itemRepo.findAll();
	}

	// ดึงหัวหน้างานทั้งหมด
	public List<HeadStaff> getAllStaff() {
		return staffRepo.findAll();
	}

	// ดึงใบเสนอราคาตาม id (ไม่พบคืน null)
	public Quotation getQuotationById(String id) {
		return quotationRepo.findById(id).orElse(null);
	}

	// ดึงใบเสนอราคาทั้งหมดในระบบ
	public List<Quotation> getAllQuotations() {
		return quotationRepo.findAll();
	}

	// ดึงใบเสนอราคาตามสถานะที่ระบุ
	public List<Quotation> getQuotationsByStatus(String status) {
		return quotationRepo.findByQuotationStatus(status);
	}

	// ดึงรายการย่อยทั้งหมดของใบเสนอราคาตาม id
	public List<QuotationDetail> getDetailsByQuotationId(String id) {
		return detailRepo.findByQuotation_QuotationId(id);
	}

	// ดึงอุปกรณ์ทั้งหมดที่ผูกกับแพ็กเกจตาม id
	public List<Item> getItemsByPackageId(int id) {
		return itemRepo.findByPackageItems_PackageEntity_PackageId(id);
	}

	// ดึงใบเสนอราคาล่าสุดของสมาชิกตาม memberId
	public Quotation getLatestQuotationByMemberId(Integer id) {
		return quotationRepo.findFirstByBookingFormMemberMemberIdOrderByQuotationIdDesc(id);
	}

	// ==========================================
	// 1. ฝั่ง Manager (สร้าง/แก้ไขใบเสนอราคา)
	// ==========================================

	// สร้างใบเสนอราคาใหม่จากการจอง
	@Transactional
	public Quotation createQuotation(String bookingId,
	                                 List<Integer> itemIds, List<Integer> qtys, List<Double> extraPrices,
	                                 String note,
	                                 List<String> bNames, List<Integer> bQtys, List<Double> bPrices) {

	    BookingForm booking = bookingRepo.findById(bookingId).orElseThrow();
	    Quotation qt = new Quotation();
	    qt.setQuotationId("QT-" + booking.getBookingId());
	    qt.setBookingForm(booking);
	    qt.setQuotationDate(new Date());
	    qt.setQuotationStatus("Pending");
	    qt.setTotalAmount(0.0);
	    qt.setNote(note);
	    qt = quotationRepo.save(qt);

	    // ส่งรายการทั้ง 2 ชุดเข้าไปคำนวณและบันทึก (ไม่มี note ต่อรายการแล้ว)
	    saveDetailsAndCalculateTotal(qt, itemIds, qtys, extraPrices, bNames, bQtys, bPrices);

	    return quotationRepo.save(qt);
	}

	// แก้ไขใบเสนอราคาเดิมโดยลบรายการเก่าแล้วสร้างใหม่
	@Transactional
	public void updateQuotation(String quotationId,
	                            List<Integer> itemIds, List<Integer> qtys, List<Double> extraPrices,
	                            String note,
	                            List<String> bNames, List<Integer> bQtys, List<Double> bPrices) {

	    Quotation qt = quotationRepo.findById(quotationId).orElseThrow();

	    // ล้างรายการเดิมเพื่อคำนวณยอดใหม่
	    detailRepo.deleteByQuotation_QuotationId(quotationId);

	    // อัปเดตสถานะกลับเป็น Pending เพื่อให้ลูกค้ากลับมาตรวจสอบใหม่ และอัปเดต note รวม
	    qt.setQuotationStatus("Pending");
	    qt.setNote(note);
	    quotationRepo.save(qt);

	    saveDetailsAndCalculateTotal(qt, itemIds, qtys, extraPrices, bNames, bQtys, bPrices);
	}

	// คำนวณยอดรวมและบันทึกรายการย่อยของใบเสนอราคา
	private void saveDetailsAndCalculateTotal(Quotation qt,
	                                          List<Integer> itemIds, List<Integer> qtys, List<Double> extraPrices,
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
	                detail.setItem(item);
	                detail.setQuantity(qty);
	                detail.setSubtotal(price * qty);

	                detailRepo.save(detail);
	                total += (price * qty);
	            }
	        }
	    }

	    // 2. บันทึกรายการที่ลูกค้าจองมาเอง (ไม่มี itemId ในฐานข้อมูล)
	    if (bNames != null && bQtys != null) {
	        for (int i = 0; i < bNames.size(); i++) {
	            String name = bNames.get(i);
	            int qty = (i < bQtys.size()) ? bQtys.get(i) : 0;
	            double price = (bPrices != null && i < bPrices.size() && bPrices.get(i) != null)
	                           ? bPrices.get(i) : 0.0;

	            Item item = itemRepo.findByItemName(name.trim()).orElse(null);
	            if (item == null) continue;

	            QuotationDetail detail = new QuotationDetail();
	            detail.setQuotation(qt);
	            detail.setItem(item);
	            detail.setQuantity(qty);
	            detail.setSubtotal(price * qty);

	            detailRepo.save(detail);
	            total += (price * qty);
	        }
	    }

	    qt.setTotalAmount(total);
	    quotationRepo.save(qt);
	}

	// เปลี่ยนสถานะใบเสนอราคาเป็น Confirmed และอัปเดตสถานะการจองให้ตรงกัน
	@Transactional
	public void confirmQuotation(String id) {
		Quotation q = quotationRepo.findById(id).orElseThrow();
		q.setQuotationStatus("Confirmed");
		if (q.getBookingForm() != null)
			q.getBookingForm().setBookingStatus("Confirmed");
	}

	// หาหัวหน้างานที่ว่างในวันที่กำหนด
	public List<HeadStaff> findAvailableStaff(Date eventDate) {
		return staffRepo.findAvailableStaff(eventDate);
	}

	// มอบหมายหัวหน้างานให้ใบเสนอราคาโดยอ้างอิง bookingId
	@Transactional
	public void assignStaffToQuotation(String bookingId, Integer staffId) {
		Quotation quotation = quotationRepo.findByBookingForm_BookingId(bookingId);
		HeadStaff staff = staffRepo.findById(staffId).orElse(null);

		if (quotation != null && staff != null) {
			quotation.setStaff(staff);
			quotationRepo.save(quotation);
		}
	}

	// ==========================================
	// 2. ฝั่ง Member (ลูกค้าแจ้งแก้ไขรายการ)
	// ==========================================

	// เปลี่ยนสถานะเป็น Revised และเก็บข้อความที่ลูกค้าขอแก้ไว้ใน note
	@Transactional
	public void submitMemberRevision(String quotationId, String memberNote) {
		Quotation qt = quotationRepo.findById(quotationId).orElseThrow();
		qt.setQuotationStatus("Revised");

		if (memberNote != null && !memberNote.trim().isEmpty()) {
			qt.setNote("[ลูกค้าขอแก้]: " + memberNote.trim());
		}

		quotationRepo.save(qt);
	}
	
	// เช็คว่าหัวหน้างานคนนี้เคยถูกผูกกับใบเสนอราคาหรือไม่
	public boolean hasQuotationForStaff(int staffId) {
	    List<Quotation> list = quotationRepo.findByStaff_StaffId(staffId);
	    return list != null && !list.isEmpty();
	}

	// ==========================================
	// 3. คำนวณราคาชุดสังฆทาน (ใช้ตั้งค่าเริ่มต้นในหน้าสร้างใบเสนอราคา)
	// ==========================================
	

	// 1 บรรทัดราคาที่จะแสดง/ส่งเข้าฟอร์มใบเสนอราคา
	public static class PriceLine {
		private final Item item;
		private final int qty;
		private final double unitPrice;
		private final String label;

		public PriceLine(Item item, int qty, double unitPrice, String label) {
			this.item = item;
			this.qty = qty;
			this.unitPrice = unitPrice;
			this.label = label;
		}

		public Item getItem() { return item; }
		public int getQty() { return qty; }
		public double getUnitPrice() { return unitPrice; }
		public String getLabel() { return label; }
	}

	// คำนวณบรรทัดราคาสังฆทานของ booking (ไม่ได้เลือกสังฆทานคืนลิสต์ว่าง)
	public List<PriceLine> calculateSanghatanLines(BookingForm booking) {
		List<PriceLine> lines = new ArrayList<>();

		String chosenName = answerOf(booking, "เลือกชุดสังฆทาน");
		int orderedQty = intAnswerOf(booking, "จำนวนชุดสังฆทาน");
		if (chosenName == null || orderedQty <= 0) return lines;

		Item chosen = itemRepo.findByItemName(chosenName.trim()).orElse(null);
		if (chosen == null) return lines;

		double chosenPrice = chosen.getPricePerUnit();

		// หาชุดสังฆทานที่รวมในแพ็กเกจ (โหมดกรอกเองจะไม่มี)
		PackageItem included = null;
		if (booking.getPackageEntity() != null && booking.getPackageEntity().getPackageItems() != null) {
			for (PackageItem pi : booking.getPackageEntity().getPackageItems()) {
				if (pi.getItem() != null && pi.getItem().getItemType() != null
						&& "สังฆทาน".equals(pi.getItem().getItemType().getItemTypeName())) {
					included = pi;
					break;
				}
			}
		}

		// โหมดกรอกเอง: คิดราคาเต็มทุกชุด
		if (included == null) {
			lines.add(new PriceLine(chosen, orderedQty, chosenPrice, "ชุดสังฆทาน"));
			return lines;
		}

		int covered = Math.min(orderedQty, included.getQuantity());
		int extra = orderedQty - covered;
		double diff = Math.max(0, chosenPrice - included.getItem().getPricePerUnit());

		// ส่วนที่อยู่ในโควตาแพ็กเกจ: คิดเฉพาะส่วนต่าง
		if (covered > 0) {
			lines.add(new PriceLine(chosen, covered, diff,
					diff == 0 ? "รวมในแพ็กเกจ" : "ส่วนต่างอัปเกรดจากชุดมาตรฐาน"));
		}
		// ส่วนที่เกินโควตา: คิดราคาเต็ม
		if (extra > 0) {
			lines.add(new PriceLine(chosen, extra, chosenPrice, "เกินจำนวนในแพ็กเกจ"));
		}
		return lines;
	}

	// อ่านคำตอบของคำถามที่มี keyword ที่ระบุ (ไม่พบคืน null)
	private String answerOf(BookingForm b, String keyword) {
		if (b.getDetails() == null) return null;
		for (BookingFormDetail d : b.getDetails()) {
			if (d.getQuestion() != null && d.getQuestion().getQuestionsText() != null
					&& d.getQuestion().getQuestionsText().contains(keyword)) {
				return d.getAnswer();
			}
		}
		return null;
	}

	// อ่านคำตอบเป็นตัวเลข (ไม่พบหรือแปลงไม่ได้คืน 0)
	private int intAnswerOf(BookingForm b, String keyword) {
		try {
			String raw = answerOf(b, keyword);
			return raw == null ? 0 : Integer.parseInt(raw.replaceAll("[^0-9]", ""));
		} catch (NumberFormatException e) {
			return 0;
		}
	}
}