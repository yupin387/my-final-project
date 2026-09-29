package com.springboot.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "package")
public class Package {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "packageid")
    private int packageId;

    @Column(name = "packagetype", nullable = false, length = 100)
    private String packageType;

    @Column(name = "optiontype", nullable = false, length = 100)
    private String optionType;

    @Column(name = "packagedetail", length = 255)
    private String packageDetail;

    @Column(name = "baseprice", nullable = false)
    private double basePrice;


    @OneToMany(
        mappedBy = "packageEntity",
        cascade = CascadeType.ALL,
        fetch = FetchType.EAGER
    )
    private List<PackageItem> packageItems;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "packagequestion",
        joinColumns = @JoinColumn(name = "packageid"),
        inverseJoinColumns = @JoinColumn(name = "questionsid")
    )
    private List<QuestionsDetail> questions;

    public Package() {
    }

    public Package(
            String packageType,
            String optionType,
            String packageDetail,
            double basePrice) {
        this.packageType = packageType;
        this.optionType = optionType;
        this.packageDetail = packageDetail;
        this.basePrice = basePrice;
    }


    public int getPackageId() {
        return packageId;
    }

    public void setPackageId(int packageId) {
        this.packageId = packageId;
    }

    public String getPackageType() {
        return packageType;
    }

    public void setPackageType(String packageType) {
        this.packageType = packageType;
    }

    public String getOptionType() {
        return optionType;
    }

    public void setOptionType(String optionType) {
        this.optionType = optionType;
    }

    public String getPackageDetail() {
        return packageDetail;
    }

    public void setPackageDetail(String packageDetail) {
        this.packageDetail = packageDetail;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public List<PackageItem> getPackageItems() {
        return packageItems;
    }

    public void setPackageItems(List<PackageItem> packageItems) {
        this.packageItems = packageItems;
    }

    public List<QuestionsDetail> getQuestions() {
        return questions;
    }

    public void setQuestions(List<QuestionsDetail> questions) {
        this.questions = questions;
    }
}