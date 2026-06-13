package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Quotationdetail")
@IdClass(QuotationDetailId.class) 
public class QuotationDetail {

    @Id
    @ManyToOne
    @JoinColumn(name = "quotationid", referencedColumnName = "quotationid")
    private Quotation quotation;

    @Id
    @ManyToOne
    @JoinColumn(name = "itemid", referencedColumnName = "itemid")
    private Item item;

    @Column(name = "quantity")
    private Integer quantity;

    @Column(name = "subtotal") 
    private Double subtotal;
    
    @Column(name = "note")
    private String note;

    

    public QuotationDetail() {}

	public QuotationDetail(Quotation quotation, Item item, Integer quantity, Double subtotal) {
		super();
		this.quotation = quotation;
		this.item = item;
		this.quantity = quantity;
		this.subtotal = subtotal;
		
	}

	public Quotation getQuotation() {
		return quotation;
	}

	public void setQuotation(Quotation quotation) {
		this.quotation = quotation;
	}

	public Item getItem() {
		return item;
	}

	public void setItem(Item item) {
		this.item = item;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public Double getSubtotal() {
		return subtotal;
	}

	public void setSubtotal(Double subtotal) {
		this.subtotal = subtotal;
	}
	
	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	

    
}