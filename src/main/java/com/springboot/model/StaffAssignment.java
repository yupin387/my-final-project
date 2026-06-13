package com.springboot.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "staffassignment")
public class StaffAssignment {
	@Id
	@Column(name = "assignid", length = 50)
	private String assignId;

	@Temporal(TemporalType.DATE)
	@Column(name = "assigndate")
	private Date assignDate;

	@Column(name = "reportnote")
	private String reportNote;

	@Column(name = "reportimage")
	private String reportImage;

	@Column(name = "jobstatus", length = 50)
	private String jobStatus;


	@ManyToOne
	@JoinColumn(name = "bookingid",nullable = false)
	private BookingForm bookingForm;


	@ManyToOne
	@JoinColumn(name = "staffid",nullable = false)
	private HeadStaff headStaff; 

	public StaffAssignment() {
	}

    
	public StaffAssignment(String assignId, Date assignDate, String reportNote, String reportImage, String jobStatus,
			BookingForm bookingForm, HeadStaff headStaff) {
		super();
		this.assignId = assignId;
		this.assignDate = assignDate;
		this.reportNote = reportNote;
		this.reportImage = reportImage;
		this.jobStatus = jobStatus;
		this.bookingForm = bookingForm;
		this.headStaff = headStaff;
	}


	public String getAssignId() {
		return assignId;
	}

	public void setAssignId(String assignId) {
		this.assignId = assignId;
	}

	public Date getAssignDate() {
		return assignDate;
	}

	public void setAssignDate(Date assignDate) {
		this.assignDate = assignDate;
	}

	public String getReportNote() {
		return reportNote;
	}

	public void setReportNote(String reportNote) {
		this.reportNote = reportNote;
	}

	public String getReportImage() {
		return reportImage;
	}

	public void setReportImage(String reportImage) {
		this.reportImage = reportImage;
	}

	public String getJobStatus() {
		return jobStatus;
	}

	public void setJobStatus(String jobStatus) {
		this.jobStatus = jobStatus;
	}

	public BookingForm getBookingForm() {
		return bookingForm;
	}

	public void setBookingForm(BookingForm bookingForm) {
		this.bookingForm = bookingForm;
	}

	public HeadStaff getHeadStaff() {
		return headStaff;
	}

	public void setHeadStaff(HeadStaff headStaff) {
		this.headStaff = headStaff;
	}
}