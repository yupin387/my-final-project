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

    // =========================================================
    // ประเภท Item
    // =========================================================

    @ManyToOne
    @JoinColumn(name = "itemtypeid", nullable = false)
    private ItemType itemType;

    // =========================================================
    // รายการ Ceremony ที่ Item นี้ถูกใช้
    // ผ่านตารางกลาง CeremonyItem
    // =========================================================

    @OneToMany(mappedBy = "item")
    private List<CeremonyItem> ceremonyItems;

    // =========================================================
    // Constructor
    // =========================================================

    public Item() {
    }

    /*
     * Constructor สำหรับสร้าง Item ใหม่
     *
     * ไม่ต้องส่ง ceremonyItems เข้ามา
     * เพราะความสัมพันธ์กับ Ceremony
     * จะถูกสร้างผ่าน CeremonyItem
     */
    public Item(
            String itemName,
            String itemDetail,
            String unit,
            double pricePerUnit,
            ItemType itemType) {

        this.itemName = itemName;
        this.itemDetail = itemDetail;
        this.unit = unit;
        this.pricePerUnit = pricePerUnit;
        this.itemType = itemType;
    }

    // =========================================================
    // Getter / Setter
    // =========================================================

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
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

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public ItemType getItemType() {
        return itemType;
    }

    public void setItemType(ItemType itemType) {
        this.itemType = itemType;
    }

    public List<CeremonyItem> getCeremonyItems() {
        return ceremonyItems;
    }

    public void setCeremonyItems(List<CeremonyItem> ceremonyItems) {
        this.ceremonyItems = ceremonyItems;
    }
}