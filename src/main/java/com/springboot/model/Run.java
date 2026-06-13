package com.springboot.model;

import org.springframework.boot.SpringApplication;
import org.springframework.context.ApplicationContext;
import com.springboot.SpringBootApplicationMain;
import com.springboot.repository.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Run {
    public static void main(String[] args) {
        ApplicationContext context = SpringApplication.run(SpringBootApplicationMain.class, args);

        CeremonyRepository ceremonyRepo = context.getBean(CeremonyRepository.class);
        OrganizerRepository organizerRepo = context.getBean(OrganizerRepository.class);
        HeadStaffRepository headStaffRepo = context.getBean(HeadStaffRepository.class);
        ItemTypeRepository itemTypeRepo = context.getBean(ItemTypeRepository.class);
        ItemRepository itemRepo = context.getBean(ItemRepository.class);
        MemberRepository memberRepo = context.getBean(MemberRepository.class);
        QuestionsRepository qRepo = context.getBean(QuestionsRepository.class);

        try {
            // 1. Ceremony
            Ceremony c1 = new Ceremony("ขึ้นบ้านใหม่", "พิธีมงคลทำบุญขึ้นบ้านใหม่", 10000.0);
            Ceremony c2 = new Ceremony("สืบชะตา", "พิธีต่อชะตาเพื่อความเป็นสิริมงคล", 10000.0);
            ceremonyRepo.saveAllAndFlush(Arrays.asList(c1, c2));

            // 2. Organizer & Staff
            organizerRepo.saveAndFlush(new Organizer("admin@gmail.com", "12345678"));
            headStaffRepo.saveAllAndFlush(Arrays.asList(
            	    new HeadStaff("สมชาย", "ใจดี", "somchai@gmail.com", "12344444", "0811111111"),
            	    new HeadStaff("สมหญิง", "ใจดี", "somying@gmail.com", "12345555", "0812222222"),
            	    // เพิ่ม 4 คนใหม่ที่นี่ครับ
            	    new HeadStaff("วิชัย", "รักงาน", "wichai@gmail.com", "12346666", "0813333333"),
            	    new HeadStaff("มานี", "รักดี", "manee@gmail.com", "12347777", "0814444444"),
            	    new HeadStaff("ชูใจ", "สดใส", "chujai@gmail.com", "12348888", "0815555555"),
            	    new HeadStaff("ปิติ", "ตั้งใจ", "piti@gmail.com", "12349999", "0816666666")
            	));

         // 3. ItemType
            ItemType t1 = new ItemType("อุปกรณ์พิธีกรรม");
            ItemType t2 = new ItemType("ภัตตาหารปิ่นโต");
            ItemType t3 = new ItemType("บริการ");
            ItemType t4 = new ItemType("สังฆทาน");
            itemTypeRepo.saveAllAndFlush(List.of(t1, t2, t3, t4));

            // 4. Item
            List<Item> items = new ArrayList<>();
            
            // --- บริการ (t3) ---
            items.add(new Item("บริการประสานงานนิมนต์พระ", "ติดต่อและรถรับ-ส่ง", "ครั้ง", 200.0, t3, List.of(c1, c2)));
            items.add(new Item("บริการจัดโต๊ะหมู่บูชา", "จัดโต๊ะหมู่และอาสนะ", "ครั้ง", 1500.0, t3, List.of(c1, c2)));
            items.add(new Item("บริการเจ้าหน้าที่รันคิว", "ดูแลลำดับพิธีการ", "คน", 500.0, t3, List.of(c1, c2)));
            items.add(new Item("บริการเครื่องเสียง", "ชุดไมค์ลอยพร้อมลำโพง", "ชุด", 1200.0, t3, List.of(c1, c2)));

            // --- อุปกรณ์พิธีกรรม (t1) ---
            // ใช้ได้ทั้งคู่
            items.add(new Item("อาสนะพระสงฆ์", "เบาะรองนั่งกำมะหยี่", "ตัว", 250.0, t1, List.of(c1, c2)));
            items.add(new Item("ชุดเครื่องทองเหลือง", "กระถางธูป เชิงเทียน แจกัน", "ชุด", 500.0, t1, List.of(c1, c2)));
            items.add(new Item("กระโถนพระสงฆ์", "กระโถนสีทอง", "ใบ", 150.0, t1, List.of(c1, c2)));
            items.add(new Item("ที่กรวดน้ำ", "ชุดทองเหลืองพร้อมจานรอง", "ชุด", 200.0, t1, List.of(c1, c2)));
            
            // เฉพาะ ขึ้นบ้านใหม่ (c1)
            items.add(new Item("โต๊ะหมู่บูชาไม้สัก", "โต๊ะหมู่ 7", "ชุด", 3500.0, t1, List.of(c1)));
            items.add(new Item("แป้งเจิม", "แป้งเจิมมงคล", "ตลับ", 80.0, t1, List.of(c1)));
            items.add(new Item("แผ่นทองคำเปลว", "สำหรับเจิมประตูบ้าน", "ชุด", 150.0, t1, List.of(c1)));
            items.add(new Item("สายสิญจน์", "ด้ายสายสิญจน์มงคล", "ม้วน", 100.0, t1, List.of(c1)));
            
            // เฉพาะ สืบชะตา (c2)
            items.add(new Item("ชุดบายศรีปากชาม", "บายศรีประณีต", "ชุด", 900.0, t1, List.of(c2)));
            items.add(new Item("ชุดตุงชัยล้านนา", "ตุงสีสันสวยงาม", "ชุด", 600.0, t1, List.of(c2)));
            items.add(new Item("แผ่นทอง-เงิน-นาก", "สำหรับเขียนชื่อในพิธี", "ชุด", 150.0, t1, List.of(c2)));
            items.add(new Item("เทียนสะเดาะเคราะห์", "เทียนประจำวันเกิด", "เล่ม", 120.0, t1, List.of(c2)));
            items.add(new Item("หมากพลูและบุหรี่", "เครื่องบูชาแบบล้านนา", "ชุด", 200.0, t1, List.of(c2)));

            // --- สังฆทาน (t4) ---
            items.add(new Item("ชุดสังฆทานมงคลเล็ก", "ของใช้ประหยัด", "ชุด", 300.0, t4, List.of(c1, c2)));
            items.add(new Item("ชุดสังฆทานพรีเมียม", "ของใช้เกรดพรีเมียม", "ชุด", 800.0, t4, List.of(c1, c2)));
            items.add(new Item("ชุดสังฆทานจัดเต็ม", "ของใช้ครบชุด", "ชุด", 1500.0, t4, List.of(c1, c2)));
            
            // --- ภัตตาหาร (t2) ---
            items.add(new Item("ปิ่นโตชุดมาตรฐาน", "กับข้าว 3 อย่าง", "เถา", 350.0, t2, List.of(c1, c2)));
            items.add(new Item("ปิ่นโตชุดพรีเมียม", "กับข้าวระดับภัตตาคาร", "เถา", 600.0, t2, List.of(c1, c2)));
            items.add(new Item("ชุดผลไม้ตามฤดูกาล", "ผลไม้คัดเกรด", "ตะกร้า", 450.0, t2, List.of(c1, c2)));
            
            itemRepo.saveAllAndFlush(items);

            // 5. QuestionsDetail (แก้ไข: ไม่ใช้ null, เพิ่มคำถามสังฆทาน)
            List<QuestionsDetail> questions = new ArrayList<>();
            List<Ceremony> ceremonies = Arrays.asList(c1, c2);

            for (Ceremony c : ceremonies) {
                questions.add(new QuestionsDetail("รูปแบบการนิมนต์พระสงฆ์", c));
                questions.add(new QuestionsDetail("จำนวนพระสงฆ์", c));
                questions.add(new QuestionsDetail("รายละเอียดการนิมนต์พระสงฆ์", c));
                questions.add(new QuestionsDetail("ต้องการชุดภัตตาหารปิ่นโตหรือไม่", c));
                questions.add(new QuestionsDetail("เลือกชุดภัตตาหารปิ่นโต", c));
                questions.add(new QuestionsDetail("จำนวนชุดภัตตาหารปิ่นโต", c));
                
                // คำถามสังฆทานใหม่
                questions.add(new QuestionsDetail("ต้องการสังฆทานหรือไม่", c));
                questions.add(new QuestionsDetail("เลือกชุดสังฆทานที่ต้องการ", c));
                questions.add(new QuestionsDetail("จำนวนชุดสังฆทาน", c));
                
                questions.add(new QuestionsDetail("จำนวนแขก", c));
            }

            // คำถามเฉพาะพิธี
            questions.add(new QuestionsDetail("ต้องการชุดอุปกรณ์พิธีขึ้นบ้านใหม่หรือไม่", c1));
            questions.add(new QuestionsDetail("ต้องการผูกข้อมือรับพรหรือไม่", c2));

            qRepo.saveAllAndFlush(questions);

            // 6. Member
            memberRepo.saveAndFlush(new Member("บุญมี", "ลุงหมู่", "boonmee@mail.com", "12345678", "0812345678"));

            System.out.println("\n>> --- [SYSTEM READY] DATA SEEDED SUCCESSFULLY ---");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}