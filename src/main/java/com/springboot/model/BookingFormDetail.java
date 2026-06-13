package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Bookingformdetail")
@IdClass(BookingFormDetailId.class)
public class BookingFormDetail {


	@Id
	@ManyToOne(fetch = FetchType.EAGER) // เพิ่มการดึงแบบ EAGER เพื่อให้คำถามโชว์แน่นอน
	@JoinColumn(name = "bookingid", referencedColumnName = "bookingid")
	private BookingForm bookingForm;

	@Id
	@ManyToOne(fetch = FetchType.EAGER) 
	@JoinColumn(name = "questionsid", referencedColumnName = "questionsid")
	private QuestionsDetail question;

	@Column(name = "answer")
	private String answer;

	public BookingFormDetail() {
	}
	

	public BookingFormDetail(BookingForm bookingForm, QuestionsDetail question, String answer) {
		super();
		this.bookingForm = bookingForm;
		this.question = question;
		this.answer = answer;
	}



	public BookingForm getBookingForm() {
		return bookingForm;
	}

	public void setBookingForm(BookingForm bookingForm) {
		this.bookingForm = bookingForm;
	}

	public QuestionsDetail getQuestion() {
		return question;
	}

	public void setQuestion(QuestionsDetail question) {
		this.question = question;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}
}