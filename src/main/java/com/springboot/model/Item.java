package com.springboot.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "item")
public class Item {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "itemid")
	private int itemId;

	@Column(name = "itemname", nullable = false, length = 100)
	private String itemName;

	@Column(name = "itemdetail")
	private String itemDetail;

	@Column(name = "unit", nullable = false, length = 20)
	private String unit;

	@Column(name = "priceperunit", nullable = false)
	private double pricePerUnit;

	@Column(name = "isactive")
	private Boolean isActive = true;

	@ManyToOne
	@JoinColumn(name = "itemtypeid", nullable = false)
	private ItemType itemType;

	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "itemceremony", joinColumns = @JoinColumn(name = "itemid"),

			inverseJoinColumns = @JoinColumn(name = "ceremonyid"))
	private List<Ceremony> ceremonies;

	public Item() {
	}

	public Item(String itemName, String itemDetail, String unit, double pricePerUnit, ItemType itemType,
			List<Ceremony> ceremonies) {
		this.itemName = itemName;
		this.itemDetail = itemDetail;
		this.unit = unit;
		this.pricePerUnit = pricePerUnit;
		this.itemType = itemType;
		this.ceremonies = ceremonies;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public String getItemName() {
		return itemName;
	}

	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getItemDetail() {
		return itemDetail;
	}

	public void setItemDetail(String itemDetail) {
		this.itemDetail = itemDetail;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public double getPricePerUnit() {
		return pricePerUnit;
	}

	public void setPricePerUnit(double pricePerUnit) {
		this.pricePerUnit = pricePerUnit;
	}

	public ItemType getItemType() {
		return itemType;
	}

	public void setItemType(ItemType itemType) {
		this.itemType = itemType;
	}

	public List<Ceremony> getCeremonies() {
		return ceremonies;
	}

	public void setCeremonies(List<Ceremony> ceremonies) {
		this.ceremonies = ceremonies;
	}
}