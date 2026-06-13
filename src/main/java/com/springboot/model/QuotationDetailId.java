package com.springboot.model;

import java.io.Serializable;
import java.util.Objects;

public class QuotationDetailId implements Serializable {
    private String quotation; 
    private int item;         

    public QuotationDetailId() {}

    
    public QuotationDetailId(String quotation, int item) {
        this.quotation = quotation;
        this.item = item;
    }

  
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        QuotationDetailId that = (QuotationDetailId) o;
        return item == that.item && 
               Objects.equals(quotation, that.quotation);
    }

    @Override
    public int hashCode() {
        return Objects.hash(quotation, item);
    }
}