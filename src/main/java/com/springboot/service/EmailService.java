package com.springboot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${app.base-url}")
    private String baseUrl;

    /**
     * ส่งอีเมลแจ้ง Username/Password ให้หัวหน้างานที่ถูกเพิ่มใหม่
     * FIX: ใช้ SimpleMailMessage (plain text) ก่อนเพื่อความง่าย/เสถียร
     * ถ้าต้องการ HTML สวยๆ ทีหลังค่อยเปลี่ยนเป็น MimeMessage + Thymeleaf template
     */
    public void sendHeadStaffWelcomeEmail(String toEmail, String firstName, String lastName,
                                           String rawPassword) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("✅ บัญชีหัวหน้างานของคุณถูกสร้างแล้ว - บุญมีนำพา จัดงานบุญ");

        String loginUrl = baseUrl + "/loginorganizer";

        String body = "เรียน คุณ" + firstName + " " + lastName + ",\n\n"
                + "แอดมินได้สร้างบัญชีหัวหน้างานให้คุณเรียบร้อยแล้ว\n\n"
                + "ข้อมูลสำหรับเข้าสู่ระบบ:\n"
                + "  Username (อีเมล): " + toEmail + "\n"
                + "  Password: " + rawPassword + "\n\n"
                + "คุณสามารถเข้าสู่ระบบได้ที่:\n"
                + loginUrl + "\n\n"
                + "ทีมงานระบบบุญมีนำพา จัดงานบุญ";

        message.setText(body);

        // FIX: ห่อ try-catch กันเคส SMTP ล่ม/ตั้งค่าไม่ถูกต้อง ไม่ให้ทำให้
        // การ "เพิ่มหัวหน้างาน" ทั้ง flow ล้มไปด้วย (บันทึกข้อมูลลง DB สำเร็จแล้ว
        // แค่ส่งอีเมลไม่ได้ ไม่ควร throw จนธุรกรรมทั้งหมดพัง)
        try {
            mailSender.send(message);
        } catch (Exception e) {
            System.err.println("[EmailService] ส่งอีเมลแจ้งหัวหน้างานไม่สำเร็จ: " + e.getMessage());
        }
    }
}