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

    @Column(name = "ceremonytype", nullable = false, length = 100)
    // ค่าที่เป็นไปได้:
    // ทำบุญบ้าน
    // ขึ้นบ้านใหม่
    // ทำบุญบริษัทหรือออฟฟิศ
    private String ceremonyType;

    @Column(name = "ceremonyname", nullable = false, length = 100)
    // ชื่อแพ็กเกจ เช่น
    // มาตรฐาน, อิ่มบุญ, พรีเมียม, ประเมินตามความต้องการ
    private String ceremonyName;

    @Column(name = "ceremonydetail", length = 255)
    private String ceremonyDetail;

    @Column(name = "baseprice", nullable = false)
    private double basePrice;

    /*
     * รายการสินค้า/บริการที่อยู่ในแพ็กเกจ
     * โดยมี CeremonyItem เป็นตารางกลาง
     * เพื่อเก็บจำนวน (quantity) ของแต่ละรายการ
     */
    @OneToMany(
        mappedBy = "ceremony",
        cascade = CascadeType.ALL,
        fetch = FetchType.EAGER
    )
    private List<CeremonyItem> ceremonyItems;

    /*
     * คำถามที่ใช้ถามลูกค้าสำหรับพิธีนี้
     * Many-to-Many กับ QuestionsDetail (ฝั่งนี้เป็น owning side)
     * ใช้ตารางกลาง ceremony_question เก็บแค่คู่ FK (ceremonyid, questionsid)
     * ไม่มี attribute เพิ่มเติม จึงไม่ต้องมี Entity กลาง
     */
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "ceremony_question",
        joinColumns = @JoinColumn(name = "ceremonyid"),
        inverseJoinColumns = @JoinColumn(name = "questionsid")
    )
    private List<QuestionsDetail> questions;

    public Ceremony() {
    }

    public Ceremony(
            String ceremonyType,
            String ceremonyName,
            String ceremonyDetail,
            double basePrice) {
        this.ceremonyType = ceremonyType;
        this.ceremonyName = ceremonyName;
        this.ceremonyDetail = ceremonyDetail;
        this.basePrice = basePrice;
    }

    // =========================================================
    // Getter / Setter
    // =========================================================

    public int getCeremonyId() {
        return ceremonyId;
    }

    public void setCeremonyId(int ceremonyId) {
        this.ceremonyId = ceremonyId;
    }

    public String getCeremonyType() {
        return ceremonyType;
    }

    public void setCeremonyType(String ceremonyType) {
        this.ceremonyType = ceremonyType;
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

    public List<CeremonyItem> getCeremonyItems() {
        return ceremonyItems;
    }

    public void setCeremonyItems(List<CeremonyItem> ceremonyItems) {
        this.ceremonyItems = ceremonyItems;
    }

    public List<QuestionsDetail> getQuestions() {
        return questions;
    }

    public void setQuestions(List<QuestionsDetail> questions) {
        this.questions = questions;
    }
}