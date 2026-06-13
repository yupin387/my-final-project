package com.springboot.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Review")
public class Review {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "reviewid")
	private int reviewId;

	@Temporal(TemporalType.DATE)
	@Column(name = "reviewdate", nullable = false)
	private Date reviewDate;

	@Column(name = "reviewimage", length = 255)
	private String reviewImage;

	@Column(name = "rating", nullable = false)
	private Double rating;

	@Column(name = "comment")
	private String comment;

	@OneToOne
	@JoinColumn(name = "bookingid", nullable = false, unique = true)
	private BookingForm bookingForm;

	public Review() {
	}

	public Review(Date reviewDate, String reviewImage, Double rating, String comment, BookingForm bookingForm) {
		this.reviewDate = reviewDate;
		this.reviewImage = reviewImage;
		this.rating = rating;
		this.comment = comment;
		this.bookingForm = bookingForm;
	}

	public int getReviewId() {
		return reviewId;
	}

	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}

	public Date getReviewDate() {
		return reviewDate;
	}

	public void setReviewDate(Date reviewDate) {
		this.reviewDate = reviewDate;
	}

	public String getReviewImage() {
		return reviewImage;
	}

	public void setReviewImage(String reviewImage) {
		this.reviewImage = reviewImage;
	}

	public Double getRating() {
		return rating;
	}

	public void setRating(Double rating) {
		this.rating = rating;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public BookingForm getBookingForm() {
		return bookingForm;
	}

	public void setBookingForm(BookingForm bookingForm) {
		this.bookingForm = bookingForm;
	}
}