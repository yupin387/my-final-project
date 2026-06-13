package com.springboot.model;

import java.io.Serializable;
import java.util.Objects;

public class BookingFormDetailId implements Serializable {

    private String bookingForm;   
    private int question;        

    public BookingFormDetailId() {}

    public BookingFormDetailId(String bookingForm, int question) {
        this.bookingForm = bookingForm;
        this.question = question;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof BookingFormDetailId)) return false;
        BookingFormDetailId that = (BookingFormDetailId) o;
        return question == that.question &&
               Objects.equals(bookingForm, that.bookingForm);
    }

    @Override
    public int hashCode() {
        return Objects.hash(bookingForm, question);
    }
}