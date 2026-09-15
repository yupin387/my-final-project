package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(name = "manager")
public class Manager {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "managerid")
    private int managerId;

    @Column(name = "manageremail", nullable = false, length = 100)
    private String managerEmail;

    @Column(name = "managerpassword", nullable = false, length = 50)
    private String managerPassword;

    public Manager() {
    }

    public Manager(String managerEmail, String managerPassword) {
        this.managerEmail = managerEmail;
        this.managerPassword = managerPassword;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public String getManagerEmail() {
        return managerEmail;
    }

    public void setManagerEmail(String managerEmail) {
        this.managerEmail = managerEmail;
    }

    public String getManagerPassword() {
        return managerPassword;
    }

    public void setManagerPassword(String managerPassword) {
        this.managerPassword = managerPassword;
    }
}