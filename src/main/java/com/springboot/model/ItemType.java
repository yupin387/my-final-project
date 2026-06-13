package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(name = "itemtype")
public class ItemType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    @Column(name = "itemtypeid")
    private int itemTypeId; 

    @Column(name = "itemtypename", nullable = false)
    private String itemTypeName;

    public ItemType() {
    }

    
    public ItemType(String itemTypeName) {
        this.itemTypeName = itemTypeName;
    }

    
    public int getItemTypeId() {
        return itemTypeId;
    }

    public void setItemTypeId(int itemTypeId) {
        this.itemTypeId = itemTypeId;
    }

    public String getItemTypeName() {
        return itemTypeName;
    }

    public void setItemTypeName(String itemTypeName) {
        this.itemTypeName = itemTypeName;
    }
}