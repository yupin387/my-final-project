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
    private String ceremonyType;

    @Column(name = "optiontype", nullable = false, length = 100)
    private String optionType;

    @Column(name = "ceremonydetail", length = 255)
    private String ceremonyDetail;

    @Column(name = "baseprice", nullable = false)
    private double basePrice;


    @OneToMany(
        mappedBy = "ceremony",
        cascade = CascadeType.ALL,
        fetch = FetchType.EAGER
    )
    private List<CeremonyItem> ceremonyItems;

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
            String optionType,
            String ceremonyDetail,
            double basePrice) {
        this.ceremonyType = ceremonyType;
        this.optionType = optionType;
        this.ceremonyDetail = ceremonyDetail;
        this.basePrice = basePrice;
    }

 
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

    public String getOptionType() {
        return optionType;
    }

    public void setOptionType(String optionType) {
        this.optionType = optionType;
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