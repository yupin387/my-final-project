package com.springboot.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "ceremony")
public class Ceremony {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY) 
	@Column(name = "ceremonyid")
	private int ceremonyId; 

	@Column(name = "ceremonyname", nullable = false, length = 100)
	private String ceremonyName;

	@Column(name = "ceremonydetail", length = 255)
	private String ceremonyDetail;

	@Column(name = "baseprice", nullable = false)
	private double basePrice;

	@ManyToMany(mappedBy = "ceremonies")
	private List<Item> items;


	public Ceremony() {
	}


	public Ceremony(String ceremonyName, String ceremonyDetail, double basePrice) {
		this.ceremonyName = ceremonyName;
		this.ceremonyDetail = ceremonyDetail;
		this.basePrice = basePrice;
	}

	
	public int getCeremonyId() {
		return ceremonyId;
	}

	public void setCeremonyId(int ceremonyId) {
		this.ceremonyId = ceremonyId;
	}

	
	public String getCeremonyName() {
		return ceremonyName;
	}

	public void setCeremonyName(String ceremonyName) {
		this.ceremonyName = ceremonyName;
	}

	public String getCeremonyDetail() {
		return ceremonyDetail;
	}

	public void setCeremonyDetail(String ceremonyDetail) {
		this.ceremonyDetail = ceremonyDetail;
	}

	public double getBasePrice() {
		return basePrice;
	}

	public void setBasePrice(double basePrice) {
		this.basePrice = basePrice;
	}

	public List<Item> getItems() {
		return items;
	}

	public void setItems(List<Item> items) {
		this.items = items;
	}
}