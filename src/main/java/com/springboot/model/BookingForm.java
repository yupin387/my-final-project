package com.springboot.model;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "bookingform")
public class BookingForm {
	@Id
	@Column(name = "bookingid", length = 50)
	private String bookingId;

	@Temporal(TemporalType.DATE)
	@Column(name = "bookingdate", nullable = false)
	private Date bookingDate;

	@Temporal(TemporalType.DATE)
	@Column(name = "eventdate", nullable = false)
	private Date eventDate;

	@Column(name = "eventtime", nullable = false)
	private String eventTime;

	@Column(name = "eventaddress", nullable = false)
	private String eventAddress;
	

	@Column(name = "addressimage")
	private String addressImage;

	@Column(name = "bookingstatus", nullable = false)
	private String bookingStatus;

	@ManyToOne
	@JoinColumn(name = "memberid", nullable = false)
	private Member member;

	@ManyToOne
	@JoinColumn(name = "ceremonyid", nullable = false)
	private Ceremony ceremony;

	@OneToOne(mappedBy = "bookingForm")
	private Quotation quotation;

	@OneToMany(mappedBy = "bookingForm", cascade = CascadeType.ALL, fetch = FetchType.EAGER, orphanRemoval = true)
	private List<BookingFormDetail> details;

	public BookingForm() {

	}

	public BookingForm(String bookingId, Date bookingDate, Date eventDate, String eventTime, String eventAddress,
			String bookingStatus, Member member, Ceremony ceremony, Quotation quotation,
			List<BookingFormDetail> details) {
		super();
		this.bookingId = bookingId;
		this.bookingDate = bookingDate;
		this.eventDate = eventDate;
		this.eventTime = eventTime;
		this.eventAddress = eventAddress;
		this.bookingStatus = bookingStatus;
		this.member = member;
		this.ceremony = ceremony;
		this.quotation = quotation;
		this.details = details;
	}

	public String getBookingId() {
		return bookingId;
	}

	public void setBookingId(String bookingId) {
		this.bookingId = bookingId;
	}

	public Date getBookingDate() {
		return bookingDate;
	}

	public void setBookingDate(Date bookingDate) {
		this.bookingDate = bookingDate;
	}

	public Date getEventDate() {
		return eventDate;
	}

	public void setEventDate(Date eventDate) {
		this.eventDate = eventDate;
	}

	public String getEventTime() {
		return eventTime;
	}

	public void setEventTime(String eventTime) {
		this.eventTime = eventTime;
	}

	public String getEventAddress() {
		return eventAddress;
	}

	public void setEventAddress(String eventAddress) {
		this.eventAddress = eventAddress;
	}
	
	

	public String getAddressImage() {
		return addressImage;
	}

	public void setAddressImage(String addressImage) {
		this.addressImage = addressImage;
	}

	public String getBookingStatus() {
		return bookingStatus;
	}

	public void setBookingStatus(String bookingStatus) {
		this.bookingStatus = bookingStatus;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public Ceremony getCeremony() {
		return ceremony;
	}

	public void setCeremony(Ceremony ceremony) {
		this.ceremony = ceremony;
	}

	public Quotation getQuotation() {
		return quotation;
	}

	public void setQuotation(Quotation quotation) {
		this.quotation = quotation;
	}

	public List<BookingFormDetail> getDetails() {
		return details;
	}

	public void setDetails(List<BookingFormDetail> details) {
		this.details = details;
	}
	
	//=================

}