package com.springboot.model;
import java.util.Date;
import jakarta.persistence.*;

@Entity
@Table(name = "quotation")
public class Quotation {

	@Id
	@Column(name = "quotationid", length = 50)
	private String quotationId;

	@Temporal(TemporalType.DATE)
	@Column(name = "quotationdate")
	private Date quotationDate;

	@Column(name = "totalamount")
	private Double totalAmount;

	@Column(name = "quotationstatus", length = 50)
	private String quotationStatus;

	@Column(name = "note", length = 500)
	private String note;

	@OneToOne
	@JoinColumn(name = "bookingid", nullable = false, unique = true)
	private BookingForm bookingForm;

	@ManyToOne
	@JoinColumn(name = "staffid")
	private HeadStaff staff;

	public Quotation() {
	}

	// Getter & Setter
	public String getQuotationId() {
		return quotationId;
	}

	public void setQuotationId(String quotationId) {
		this.quotationId = quotationId;
	}

	public Date getQuotationDate() {
		return quotationDate;
	}

	public void setQuotationDate(Date quotationDate) {
		this.quotationDate = quotationDate;
	}

	public Double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getQuotationStatus() {
		return quotationStatus;
	}

	public void setQuotationStatus(String quotationStatus) {
		this.quotationStatus = quotationStatus;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public BookingForm getBookingForm() {
		return bookingForm;
	}

	public void setBookingForm(BookingForm bookingForm) {
		this.bookingForm = bookingForm;
	}

	public HeadStaff getStaff() {
		return staff;
	}

	public void setStaff(HeadStaff staff) {
		this.staff = staff;
	}
}