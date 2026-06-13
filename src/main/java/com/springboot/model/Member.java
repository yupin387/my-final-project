package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Member")
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "memberid")
    private int memberId;

    @Column(name = "memberfirstname", nullable = false, length = 100)
    private String memberFirstName;

    @Column(name = "memberlastname", nullable = false, length = 100)
    private String memberLastName;

    @Column(name = "memberemail", nullable = false, length = 100)
    private String memberEmail;

    @Column(name = "memberpassword", nullable = false, length = 50)
    private String memberPassword;

    @Column(name = "phonenumber", nullable = false, length = 10)
    private String phoneNumber;

    public Member() {
    }

    public Member(String memberFirstName, String memberLastName, String memberEmail, String memberPassword,
            String phoneNumber) {
        this.memberFirstName = memberFirstName;
        this.memberLastName = memberLastName;
        this.memberEmail = memberEmail;
        this.memberPassword = memberPassword;
        this.phoneNumber = phoneNumber;
    }

    public int getMemberId() {
        return memberId;
    }

    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

    // ✅ แก้ไขการสะกด Getter/Setter ให้ถูกต้อง (ir ไม่ใช่ ri)
    public String getMemberFirstName() {
        return memberFirstName;
    }

    public void setMemberFirstName(String memberFirstName) {
        this.memberFirstName = memberFirstName;
    }

    public String getMemberLastName() {
        return memberLastName;
    }

    public void setMemberLastName(String memberLastName) {
        this.memberLastName = memberLastName;
    }

    public String getMemberEmail() {
        return memberEmail;
    }

    public void setMemberEmail(String memberEmail) {
        this.memberEmail = memberEmail;
    }

    public String getMemberPassword() {
        return memberPassword;
    }

    public void setMemberPassword(String memberPassword) {
        this.memberPassword = memberPassword;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}