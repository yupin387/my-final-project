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


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ceremonyid", nullable = false)
    private Ceremony ceremony;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "itemid", nullable = false)
    private Item item;


    @Column(name = "quantity", nullable = false)
    private int quantity;



    public CeremonyItem() {
    }


    public CeremonyItem(Ceremony ceremony, Item item, int quantity) {
        this.ceremony = ceremony;
        this.item = item;
        this.quantity = quantity;
    }



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