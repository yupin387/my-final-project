package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(name = "headstaff")
public class HeadStaff {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "staffid")
	private int staffId;

	@Column(name = "stafffirstname", nullable = false, length = 50)
	private String staffFirstName;

	@Column(name = "stafflastname", nullable = false, length = 50)
	private String staffLastName;

	@Column(name = "staffemail", nullable = false, length = 100)
	private String staffEmail;

	@Column(name = "staffpassword", nullable = false, length = 50)
	private String staffPassword;

	@Column(name = "staffphone", nullable = false, length = 10)
	private String staffPhone;

	@Column(name = "is_active", nullable = false)
	private boolean isActive = true; // ค่าเริ่มต้นเป็น true (ยังทำงานอยู่)

	public HeadStaff() {

	}

	public HeadStaff(String staffFirstName, String staffLastName, String staffEmail, String staffPassword,
			String staffPhone) {
		super();
		this.staffFirstName = staffFirstName;
		this.staffLastName = staffLastName;
		this.staffEmail = staffEmail;
		this.staffPassword = staffPassword;
		this.staffPhone = staffPhone;

	}

	public int getStaffId() {
		return staffId;
	}

	public void setStaffId(int staffId) {
		this.staffId = staffId;
	}

	public String getStaffFirstName() {
		return staffFirstName;
	}

	public void setStaffFirstName(String staffFirstName) {
		this.staffFirstName = staffFirstName;
	}

	public String getStaffLastName() {
		return staffLastName;
	}

	public void setStaffLastName(String staffLastName) {
		this.staffLastName = staffLastName;
	}

	public String getStaffEmail() {
		return staffEmail;
	}

	public void setStaffEmail(String staffEmail) {
		this.staffEmail = staffEmail;
	}

	public String getStaffPassword() {
		return staffPassword;
	}

	public void setStaffPassword(String staffPassword) {
		this.staffPassword = staffPassword;
	}

	public String getStaffPhone() {
		return staffPhone;
	}

	public void setStaffPhone(String staffPhone) {
		this.staffPhone = staffPhone;
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean active) {
		isActive = active;
	}

}