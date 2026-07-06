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
			Ceremony c1 = new Ceremony("ขึ้นบ้านใหม่", "พิธีสงฆ์เพื่อความเป็นสิริมงคลแก่บ้านใหม่และผู้อยู่อาศัย ครบถ้วนตามประเพณีล้านนา", 5000.0);        
            Ceremony c2 = new Ceremony("สืบชะตา", "พิธีต่ออายุ แก้เคล็ด เสริมสิริมงคล และสร้างกำลังใจให้ชีวิตราบรื่นยั่งยืน", 5000.0);  
			ceremonyRepo.saveAllAndFlush(Arrays.asList(c1, c2));

			// 2. Organizer & Staff
			organizerRepo.saveAndFlush(new Organizer("admin@gmail.com", "12345678"));
			headStaffRepo.saveAllAndFlush(
					Arrays.asList(new HeadStaff("สมชาย", "ใจดี", "somchai@gmail.com", "12344444", "0811111111"),
							new HeadStaff("สมหญิง", "ใจดี", "somying@gmail.com", "12345555", "0812222222"),
							new HeadStaff("วิชัย", "รักงาน", "wichai@gmail.com", "12346666", "0813333333"),
							new HeadStaff("มานี", "รักดี", "manee@gmail.com", "12347777", "0814444444"),
							new HeadStaff("ชูใจ", "สดใส", "chujai@gmail.com", "12348888", "0815555555"),
							new HeadStaff("ปิติ", "ตั้งใจ", "piti@gmail.com", "12349999", "0816666666"),

							// เพิ่มใหม่
							new HeadStaff("อำนาจ", "ขยันดี", "amnat@gmail.com", "12351111", "0817777777"),
							new HeadStaff("จินตนา", "ศรัทธา", "jintana@gmail.com", "12352222", "0818888888")));

			// 3. ItemType
			ItemType t1 = new ItemType("อุปกรณ์พิธีกรรม");
			ItemType t2 = new ItemType("ภัตตาหารปิ่นโต");
			ItemType t3 = new ItemType("บริการ");
			ItemType t4 = new ItemType("สังฆทาน");
			itemTypeRepo.saveAllAndFlush(List.of(t1, t2, t3, t4));

			// 4. Item
			List<Item> items = new ArrayList<>();

			// --- บริการ (t3) ---
			items.add(new Item("บริการประสานงานนิมนต์พระ", "ติดต่อประสานงานและนิมนต์พระสงฆ์", "รูป", 500.0, t3,
					List.of(c1, c2)));

			items.add(new Item("บริการจัดสถานที่ประกอบพิธี", "จัดเตรียมโต๊ะหมู่บูชา อาสนะพระ และพื้นที่ประกอบพิธี",
					"ครั้ง", 2500.0, t3, List.of(c1, c2)));

			items.add(new Item("บริการเจ้าหน้าที่ดูแลพิธี", "ดูแลลำดับขั้นตอนและอำนวยความสะดวกภายในงาน", "คน", 800.0,
					t3, List.of(c1, c2)));

			

			// --- อุปกรณ์พิธีกรรม (t1) ---

			// ใช้ได้ทั้งพิธีขึ้นบ้านใหม่ และ สืบชะตา
			
			// บายศรี (ย้ายมาจากฝั่งสืบชะตาเดิม → ใช้ได้ทั้ง 2 พิธี แบ่ง 3 ขนาดตามจำนวนแขก)
			items.add(new Item("บายศรีสู่ขวัญ", "บายศรีปากชาม สำหรับพิธีสักการะ", "ชุด", 1500.0, t1, List.of(c1, c2)));	
			items.add(new Item("อาสนะพระสงฆ์", "เบาะรองนั่งกำมะหยี่สำหรับพระสงฆ์", "ตัว", 250.0, t1, List.of(c1, c2)));
			items.add(new Item("ชุดเครื่องทองเหลือง", "กระถางธูป เชิงเทียน แจกัน", "ชุด", 500.0, t1, List.of(c1, c2)));
			items.add(new Item("กระโถนพระสงฆ์", "กระโถนสีทองสำหรับพระสงฆ์", "ใบ", 150.0, t1, List.of(c1, c2)));
			items.add(new Item("ที่กรวดน้ำ", "ชุดทองเหลืองพร้อมจานรอง", "ชุด", 200.0, t1, List.of(c1, c2)));
			items.add(new Item("ชุดน้ำมนต์", "ขันน้ำมนต์ทองเหลือง 1 ใบ + แปรงประพรมน้ำมนต์ 1 อัน", "ชุด", 300.0, t1, List.of(c1, c2)));
			items.add(new Item("ชุดบูชาพระประธาน", "ธูปเทียนบูชา พานดอกไม้ แจกันดอกไม้", "ชุด", 550.0, t1, List.of(c1, c2)));
			
			items.add(new Item("เชิงเทียนทองเหลือง", "เชิงเทียนสำหรับบูชาพระ", "คู่", 250.0, t1, List.of(c1, c2)));
			items.add(new Item("สายสิญจน์", "ด้ายสายสิญจน์มงคล", "ม้วน", 100.0, t1, List.of(c1, c2)));
			items.add(new Item("โต๊ะวางเครื่องสักการะ", "โต๊ะสำหรับวางเครื่องบูชา", "ตัว", 400.0, t1, List.of(c1, c2)));

		
			//items.add(new Item("บายศรีสู่ขวัญ (เล็ก)", "บายศรีปากชาม สำหรับแขกจำนวนน้อย (ต่ำกว่า 30 คน)", "ชุด", 900.0, t1, List.of(c1, c2)));
			//items.add(new Item("บายศรีสู่ขวัญ (กลาง)", "บายศรีปากชาม สำหรับแขกจำนวนปานกลาง (30-80 คน)", "ชุด", 1500.0, t1, List.of(c1, c2)));
			//items.add(new Item("บายศรีสู่ขวัญ (ใหญ่)", "บายศรีปากชาม สำหรับแขกจำนวนมาก (มากกว่า 80 คน)", "ชุด", 2200.0, t1, List.of(c1, c2)));


			// เฉพาะพิธีขึ้นบ้านใหม่
			items.add(new Item("โต๊ะหมู่บูชาไม้สัก", "โต๊ะหมู่ 7 สำหรับประดิษฐานพระ", "ชุด", 3500.0, t1, List.of(c1)));
			items.add(new Item("พระพุทธรูปประดิษฐาน", "พระพุทธรูปสำหรับขึ้นหิ้งพระ", "องค์", 2500.0, t1, List.of(c1)));
			items.add(new Item("ชุดเจิมประตูหน้าต่าง", "แป้งเจิมมงคล + แผ่นทองคำเปลว สำหรับเจิมประตูหน้าต่าง", "ชุด", 300.0, t1, List.of(c1)));
			items.add(new Item("พวงมาลัยดอกมะลิ", "ใช้ถวายพระและบูชาพระประธาน", "พวง", 120.0, t1, List.of(c1)));
			items.add(new Item("ผ้าขาวปูโต๊ะหมู่บูชา", "ผ้าสำหรับคลุมโต๊ะหมู่บูชา", "ผืน", 300.0, t1, List.of(c1)));

			// เฉพาะพิธีสืบชะตา
			items.add(new Item("ชุดตุงชัยล้านนา", "ตุงสีสันสวยงามตามประเพณีล้านนา", "ชุด", 600.0, t1, List.of(c2)));
			items.add(new Item("แผ่นทอง-เงิน-นาก", "สำหรับเขียนชื่อในพิธี", "ชุด", 150.0, t1, List.of(c2)));
			items.add(new Item("เทียนสะเดาะเคราะห์", "เทียนประจำวันเกิด", "เล่ม", 120.0, t1, List.of(c2)));
			items.add(new Item("หมากพลูและบุหรี่", "เครื่องบูชาแบบล้านนา", "ชุด", 200.0, t1, List.of(c2)));
			items.add(new Item("ไม้ค้ำศรี", "ไม้ค้ำชะตาตามประเพณีล้านนา", "ต้น", 400.0, t1, List.of(c2)));
			items.add(new Item("สะตวง", "ภาชนะประกอบพิธีสืบชะตา", "ชุด", 250.0, t1, List.of(c2)));
			items.add(new Item("ตุงใยแมงมุม", "เครื่องสักการะแบบล้านนา", "ชุด", 350.0, t1, List.of(c2)));
			items.add(new Item("เทียนนพเคราะห์", "เทียนบูชาดาวนพเคราะห์", "ชุด", 200.0, t1, List.of(c2)));
			items.add(new Item("ชุดเครื่องสืบชะตาล้านนา", "ดอกไม้ ธูป เทียน ข้าวตอก เครื่องบูชา", "ชุด", 600.0, t1, List.of(c2)));

			// --- สังฆทาน (t4) ---
			items.add(new Item("ชุดสังฆทานมาตรฐาน", "ประกอบด้วย สบู่ ยาสีฟัน แปรงสีฟัน ผงซักฟอก และกระดาษทิชชู่", "ชุด",
					299.0, t4, List.of(c1, c2)));


			items.add(
					new Item("ชุดสังฆทานพรีเมียม", "ประกอบด้วย เครื่องอุปโภคบริโภค ผ้าเช็ดตัว ร่ม และยาสามัญประจำบ้าน",
							"ชุด", 399.0, t4, List.of(c1, c2)));

			items.add(new Item("ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน",
					"ประกอบด้วย ผ้าไตรจีวร ย่ามพระ และเครื่องอุปโภคบริโภคที่จำเป็น", "ชุด", 499.0, t4,
					List.of(c1, c2)));



			// --- ภัตตาหารปิ่นโต (t2) ---
			items.add(new Item("ปิ่นโตชุดประหยัด", "ข้าวสวย แกงจืดเต้าหู้หมูสับ ผัดผักรวม และผลไม้ตามฤดูกาล", "เถา",
					299.0, t2, List.of(c1, c2)));

			items.add(new Item("ปิ่นโตชุดมาตรฐาน", "ข้าวสวย แกงเขียวหวานไก่ ผัดผักรวม ไข่พะโล้ และผลไม้ตามฤดูกาล",
					"เถา", 399.0, t2, List.of(c1, c2)));


			items.add(new Item("ปิ่นโตชุดพรีเมียม",
					"ข้าวสวย ต้มยำกุ้ง ปลานึ่งมะนาว ผัดผักรวม ขนมหวานไทย และผลไม้ตามฤดูกาล", "เถา", 499.0, t2,
					List.of(c1, c2)));

			items.add(new Item("ปิ่นโตชุดพิเศษ",
					"ข้าวสวย ปลาทอดราดซอส ต้มยำกุ้ง ผัดผักรวม ขนมหวานไทย ผลไม้รวม และเครื่องดื่ม", "เถา", 599.0, t2,
					List.of(c1, c2)));
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

			qRepo.saveAllAndFlush(questions);

			// 6. Member
			memberRepo.saveAllAndFlush(
					Arrays.asList(new Member("บุญมี", "ลุงหลู่", "boonmee@gmail.com", "12345678", "0812345678"),
							new Member("สุนีย์", "คำดี", "sunee@gmail.com", "12345679", "0812345679"),
							new Member("ประเสริฐ", "สุขใจ", "prasert@gmail.com", "12345680", "0812345680"),
							new Member("อารีย์", "บุญส่ง", "aree@gmail.com", "12345681", "0812345681"),
							new Member("ธนพล", "ศรีสุข", "thanapon@gmail.com", "12345682", "0812345682")));

			System.out.println("\n>> --- [SYSTEM READY] DATA SEEDED SUCCESSFULLY ---");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	//===================
}