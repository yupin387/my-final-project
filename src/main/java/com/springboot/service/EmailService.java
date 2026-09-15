package com.springboot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${app.base-url}")
    private String baseUrl;


    @Value("${spring.mail.username}")
    private String fromEmail;


    private static final String FROM_DISPLAY_NAME = "บุญมีนำพา จัดงานบุญ";

  
    public void sendHeadStaffWelcomeEmail(String toEmail, String firstName, String lastName,
                                           String rawPassword) {
        String loginUrl = baseUrl + "/loginmanager";

        String body = "เรียน คุณ" + firstName + " " + lastName + ",\n\n"
                + "แอดมินได้สร้างบัญชีหัวหน้างานให้คุณเรียบร้อยแล้ว\n\n"
                + "ข้อมูลสำหรับเข้าสู่ระบบ:\n"
                + "  Username (อีเมล): " + toEmail + "\n"
                + "  Password: " + rawPassword + "\n\n"
                + "คุณสามารถเข้าสู่ระบบได้ที่:\n"
                + loginUrl + "\n\n"
                + "ทีมงานระบบบุญมีนำพา จัดงานบุญ";

        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
           
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, false, "UTF-8");

            
            helper.setFrom(fromEmail, FROM_DISPLAY_NAME);
            helper.setTo(toEmail);
            helper.setSubject("✅ บัญชีหัวหน้างานของคุณถูกสร้างแล้ว - บุญมีนำพา จัดงานบุญ");
            helper.setText(body, false);

            mailSender.send(mimeMessage);
        } catch (Exception e) {
            System.err.println("[EmailService] ส่งอีเมลแจ้งหัวหน้างานไม่สำเร็จ: " + e.getMessage());
        }
    }
}