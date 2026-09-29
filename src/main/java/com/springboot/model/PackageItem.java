package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(
    name = "packageitem",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"packageid", "itemid"})
    }
)
public class PackageItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "packageitemid")
    private int packageItemId;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "packageid", nullable = false)
    private Package packageEntity;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "itemid", nullable = false)
    private Item item;


    @Column(name = "quantity", nullable = false)
    private int quantity;



    public PackageItem() {
    }


    public PackageItem(Package packageEntity, Item item, int quantity) {
        this.packageEntity = packageEntity;
        this.item = item;
        this.quantity = quantity;
    }



    public int getPackageItemId() {
        return packageItemId;
    }

    public void setPackageItemId(int packageItemId) {
        this.packageItemId = packageItemId;
    }

    public Package getPackageEntity() {
        return packageEntity;
    }

    public void setPackageEntity(Package packageEntity) {
        this.packageEntity = packageEntity;
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