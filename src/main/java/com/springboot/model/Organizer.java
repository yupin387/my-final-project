package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Organizer")
public class Organizer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    @Column(name = "organizerid")
    private int organizerId; 

    @Column(name = "organizeremail", nullable = false, length = 100)
    private String organizerEmail;

    
    @Column(name = "organizerpassword", nullable = false, length = 50)
    private String organizerPassword;

    public Organizer() {
    }

    
    public Organizer(String organizerEmail, String organizerPassword) {
        this.organizerEmail = organizerEmail;
        this.organizerPassword = organizerPassword;
    }

    
    public int getOrganizerId() {
        return organizerId;
    }

    public void setOrganizerId(int organizerId) {
        this.organizerId = organizerId;
    }

    public String getOrganizerEmail() {
        return organizerEmail;
    }

    public void setOrganizerEmail(String organizerEmail) {
        this.organizerEmail = organizerEmail;
    }

    public String getOrganizerPassword() {
        return organizerPassword;
    }

    public void setOrganizerPassword(String organizerPassword) {
        this.organizerPassword = organizerPassword;
    }
}