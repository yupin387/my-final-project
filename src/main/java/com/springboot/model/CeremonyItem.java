package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(
    name = "ceremonyitem",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"ceremonyid", "itemid"})
    }
)
public class CeremonyItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ceremonyitemid")
    private int ceremonyItemId;

    // =========================
    // Ceremony
    // =========================
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ceremonyid", nullable = false)
    private Ceremony ceremony;

    // =========================
    // Item
    // =========================
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "itemid", nullable = false)
    private Item item;

    // =========================
    // จำนวน
    // =========================
    @Column(name = "quantity", nullable = false)
    private int quantity;

    // =========================
    // Constructor
    // =========================
    public CeremonyItem() {
    }

    // ไม่ต้องรับ ceremonyItemId เพราะเป็น GeneratedValue
    public CeremonyItem(Ceremony ceremony, Item item, int quantity) {
        this.ceremony = ceremony;
        this.item = item;
        this.quantity = quantity;
    }

    // =========================
    // Getter / Setter
    // =========================

    public int getCeremonyItemId() {
        return ceremonyItemId;
    }

    public void setCeremonyItemId(int ceremonyItemId) {
        this.ceremonyItemId = ceremonyItemId;
    }

    public Ceremony getCeremony() {
        return ceremony;
    }

    public void setCeremony(Ceremony ceremony) {
        this.ceremony = ceremony;
    }

    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}