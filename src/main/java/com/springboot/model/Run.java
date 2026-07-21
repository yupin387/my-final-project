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
			// จำนวนพระต่อระดับแพ็กเกจ: มาตรฐาน = 5 รูป, อิ่มบุญ = 7 รูป, พรีเมียม = 9 รูป
			// (ฝังจำนวนพระไว้ในข้อความ ceremonyDetail แทนการเพิ่มคอลัมน์ใหม่)
			// Ceremony(ceremonyType, ceremonyName, ceremonyDetail, basePrice)
			// ceremonyType = ทำบุญบ้าน/ขึ้นบ้านใหม่/ทำบุญออฟฟิศ, ceremonyName = ชื่อแพ็กเกจ
			Ceremony c1 = new Ceremony("ทำบุญบ้าน", "แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 5 รูป)", 10000.0);

			Ceremony c2 = new Ceremony("ทำบุญบ้าน", "แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 7 รูป)", 15000.0);

			Ceremony c3 = new Ceremony("ทำบุญบ้าน", "แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 9 รูป)", 18000.0);

			Ceremony c4 = new Ceremony("ขึ้นบ้านใหม่", "แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 5 รูป)", 10000.0);

			Ceremony c5 = new Ceremony("ขึ้นบ้านใหม่", "แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 7 รูป)", 15000.0);

			Ceremony c6 = new Ceremony("ขึ้นบ้านใหม่", "แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 9 รูป)", 18000.0);

			Ceremony c7 = new Ceremony("ทำบุญบริษัทหรือออฟฟิศ", "แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 5 รูป)", 10000.0);

			Ceremony c8 = new Ceremony("ทำบุญบริษัทหรือออฟฟิศ", "แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 7 รูป)", 15000.0);

			Ceremony c9 = new Ceremony("ทำบุญบริษัทหรือออฟฟิศ", "แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 9 รูป)", 18000.0);


			Ceremony c10 = new Ceremony(
				    "ทำบุญบ้าน",
				    "กรอกความต้องการเบื้องต้น",
				    "ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา",
				    8000.0
				);

				Ceremony c11 = new Ceremony(
				    "ขึ้นบ้านใหม่",
				    "กรอกความต้องการเบื้องต้น",
				    "ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา",
				    8000.0
				);

				Ceremony c12 = new Ceremony(
						"ทำบุญบริษัทหรือออฟฟิศ",
				    "กรอกความต้องการเบื้องต้น",
				    "ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา",
				    8000.0
				);

			ceremonyRepo.saveAllAndFlush(Arrays.asList(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12));

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
			// 3. ItemType
			ItemType t1 = new ItemType("อุปกรณ์พิธีกรรม");
			ItemType t2 = new ItemType("ภัตตาหารปิ่นโต");
			ItemType t3 = new ItemType("บริการ");
			ItemType t4 = new ItemType("สังฆทาน");
			ItemType t5 = new ItemType("แพ็กเกจ");  // เพิ่มใหม่
			itemTypeRepo.saveAllAndFlush(List.of(t1, t2, t3, t4, t5));

			// 4. Item
			// ระบบมีงานบุญ 3 ประเภท x 4 ตัวเลือก (มาตรฐาน/อิ่มบุญ/พรีเมียม/กำหนดเอง) = 12 ceremony (c1-c12)
			//   ทำบุญบ้าน      : c1 มาตรฐาน, c2 อิ่มบุญ, c3 พรีเมียม, c10 กำหนดเอง
			//   ขึ้นบ้านใหม่    : c4 มาตรฐาน, c5 อิ่มบุญ, c6 พรีเมียม, c11 กำหนดเอง
			//   ทำบุญออฟฟิศ    : c7 มาตรฐาน, c8 อิ่มบุญ, c9 พรีเมียม, c12 กำหนดเอง
			List<Ceremony> allCeremonies = Arrays.asList(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12);
			List<Item> items = new ArrayList<>();

			// ========================================================
			// A. ของที่ใช้ร่วมกันทุกงาน ทุกระดับแพ็กเกจ (c1-c9)
			//    เป็นของ/บริการพื้นฐานที่พิธีสงฆ์ทุกแบบต้องมี ไม่ว่าจะจัดที่บ้าน ที่บ้านใหม่ หรือที่ออฟฟิศ
			// ========================================================
			// ========================================================
			// F. Item ตัวแทนแพ็กเกจ — ใช้ผูกกับ QuotationDetail ตอนสร้าง/แก้ไขใบเสนอราคา
//			    (QuotationService.saveDetailsAndCalculateTotal ค้นหาด้วย itemName == ceremonyName)
//			    ราคาซ้ำกันทุกประเภทงาน (ทำบุญบ้าน/ขึ้นบ้านใหม่/ทำบุญออฟฟิศ) จึงสร้างแค่ 4 รายการพอ
			// ========================================================
			items.add(new Item("แพ็กเกจมาตรฐาน", "แพ็กเกจมาตรฐาน (นิมนต์พระสงฆ์ 5 รูป)", "แพ็กเกจ", 10000.0, t5,
			        Arrays.asList(c1, c4, c7)));
			items.add(new Item("แพ็กเกจอิ่มบุญ", "แพ็กเกจอิ่มบุญ (นิมนต์พระสงฆ์ 7 รูป)", "แพ็กเกจ", 15000.0, t5,
			        Arrays.asList(c2, c5, c8)));
			items.add(new Item("แพ็กเกจพรีเมียม", "แพ็กเกจพรีเมียม (นิมนต์พระสงฆ์ 9 รูป)", "แพ็กเกจ", 18000.0, t5,
			        Arrays.asList(c3, c6, c9)));
//			items.add(new Item("กรอกความต้องการเบื้องต้น", "แพ็กเกจกำหนดเอง ลูกค้ากรอกรายละเอียดเอง", "แพ็กเกจ", 8000.0, t5,
//			        Arrays.asList(c10, c11, c12)));
//			
			
			// --- บริการ (t3) ---
			items.add(new Item("บริการประสานงานนิมนต์พระ", "ติดต่อประสานงานและนิมนต์พระสงฆ์", "รูป", 500.0, t3,
					allCeremonies));

			items.add(new Item("บริการจัดสถานที่ประกอบพิธี", "จัดเตรียมโต๊ะหมู่บูชา อาสนะพระ และพื้นที่ประกอบพิธี",
					"ครั้ง", 2500.0, t3, allCeremonies));

			items.add(new Item("บริการเจ้าหน้าที่ดูแลพิธี", "ดูแลลำดับขั้นตอนและอำนวยความสะดวกภายในงาน", "คน", 800.0,
					t3, allCeremonies));
			
			items.add(new Item("มัคนายก", "ดูแลลำดับขั้นตอน", "คน", 800.0,
					t3, allCeremonies));

			// --- อุปกรณ์พิธีกรรมพื้นฐาน (t1) ---
			items.add(new Item("บายศรีสู่ขวัญ", "บายศรีปากชาม สำหรับพิธีสักการะ", "ชุด", 1500.0, t1, allCeremonies));
			items.add(new Item("อาสนะพระสงฆ์", "เบาะรองนั่งกำมะหยี่สำหรับพระสงฆ์", "ตัว", 250.0, t1, allCeremonies));
			items.add(new Item("ชุดเครื่องทองเหลือง", "กระถางธูป เชิงเทียน แจกัน", "ชุด", 500.0, t1, allCeremonies));
			items.add(new Item("กระโถนพระสงฆ์", "กระโถนสีทองสำหรับพระสงฆ์", "ใบ", 150.0, t1, allCeremonies));
			items.add(new Item("ที่กรวดน้ำ", "ชุดทองเหลืองพร้อมจานรอง", "ชุด", 200.0, t1, allCeremonies));
			items.add(new Item("ชุดน้ำมนต์", "ขันน้ำมนต์ทองเหลือง 1 ใบ + แปรงประพรมน้ำมนต์ 1 อัน", "ชุด", 300.0, t1,
					allCeremonies)); 
			items.add(new Item("ชุดบูชาพระประธาน", "ธูปเทียนบูชา พานดอกไม้ แจกันดอกไม้", "ชุด", 550.0, t1,
					allCeremonies));
			items.add(new Item("เชิงเทียนทองเหลือง", "เชิงเทียนสำหรับบูชาพระ", "คู่", 250.0, t1, allCeremonies));
			items.add(new Item("สายสิญจน์", "ด้ายสายสิญจน์มงคล", "ม้วน", 100.0, t1, allCeremonies));
			items.add(new Item("โต๊ะวางเครื่องสักการะ", "โต๊ะสำหรับวางเครื่องบูชา", "ตัว", 400.0, t1, allCeremonies));

			// --- สังฆทาน (t4) — ทุกงานเลือกได้เหมือนกัน ---
			items.add(new Item("ชุดสังฆทานมาตรฐาน", "ประกอบด้วย สบู่ ยาสีฟัน แปรงสีฟัน ผงซักฟอก และกระดาษทิชชู่", "ชุด",
					299.0, t4, allCeremonies));

			items.add(
					new Item("ชุดสังฆทานพรีเมียม", "ประกอบด้วย เครื่องอุปโภคบริโภค ผ้าเช็ดตัว ร่ม และยาสามัญประจำบ้าน",
							"ชุด", 399.0, t4, allCeremonies));

			items.add(new Item("ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน",
					"ประกอบด้วย ผ้าไตรจีวร ย่ามพระ และเครื่องอุปโภคบริโภคที่จำเป็น", "ชุด", 499.0, t4,
					allCeremonies));

			// --- ภัตตาหารปิ่นโต (t2) — ทุกงานเลือกได้เหมือนกัน ---
			items.add(new Item("ปิ่นโตชุดประหยัด", "ข้าวสวย แกงจืดเต้าหู้หมูสับ ผัดผักรวม และผลไม้ตามฤดูกาล", "เถา",
					299.0, t2, allCeremonies));

			items.add(new Item("ปิ่นโตชุดมาตรฐาน", "ข้าวสวย แกงเขียวหวานไก่ ผัดผักรวม ไข่พะโล้ และผลไม้ตามฤดูกาล",
					"เถา", 399.0, t2, allCeremonies));

			items.add(new Item("ปิ่นโตชุดพรีเมียม",
					"ข้าวสวย ต้มยำกุ้ง ปลานึ่งมะนาว ผัดผักรวม ขนมหวานไทย และผลไม้ตามฤดูกาล", "เถา", 499.0, t2,
					allCeremonies));

			items.add(new Item("ปิ่นโตชุดพิเศษ",
					"ข้าวสวย ปลาทอดราดซอส ต้มยำกุ้ง ผัดผักรวม ขนมหวานไทย ผลไม้รวม และเครื่องดื่ม", "เถา", 599.0, t2,
					allCeremonies));

			// ========================================================
			// B. ของเฉพาะ "งานทำบุญบ้าน" (c1, c2, c3) — เน้นของสักการะสำหรับทำบุญประจำปี/ตามโอกาส
			// ========================================================
			items.add(new Item("พานพุ่มดอกไม้สดถวายพระ", "พุ่มดอกไม้สดสำหรับถวายพระในพิธีทำบุญบ้าน", "พุ่ม", 350.0,
					t1, Arrays.asList(c1, c2, c3, c10)));
			items.add(new Item("ชุดผ้าป่าเล็ก", "ต้นผ้าป่าสำหรับทำบุญประจำปี ตกแต่งด้วยธนบัตรจำลอง", "ต้น", 450.0,
					t1, Arrays.asList(c1, c2, c3, c10)));

			// ========================================================
			// C. ของเฉพาะ "งานขึ้นบ้านใหม่" (c4, c5, c6) — เน้นของที่ใช้ตอน "เปิดบ้าน" ครั้งแรก
			// ========================================================
			items.add(new Item("โต๊ะหมู่บูชาไม้สัก", "โต๊ะหมู่ 7 สำหรับประดิษฐานพระ", "ชุด", 3500.0, t1,
					Arrays.asList(c4, c5, c6, c11)));
			items.add(new Item("พระพุทธรูปประดิษฐาน", "พระพุทธรูปสำหรับขึ้นหิ้งพระ", "องค์", 2500.0, t1,
					Arrays.asList(c4, c5, c6, c11)));
			items.add(new Item("ชุดเจิมประตูหน้าต่าง", "แป้งเจิมมงคล + แผ่นทองคำเปลว สำหรับเจิมประตูหน้าต่าง", "ชุด",
					300.0, t1, Arrays.asList(c4, c5, c6, c11)));
			items.add(new Item("พวงมาลัยดอกมะลิ", "ใช้ถวายพระและบูชาพระประธาน", "พวง", 120.0, t1,
					Arrays.asList(c4, c5, c6, c11)));
			items.add(new Item("ผ้าขาวปูโต๊ะหมู่บูชา", "ผ้าสำหรับคลุมโต๊ะหมู่บูชา", "ผืน", 300.0, t1,
					Arrays.asList(c4, c5, c6, c11)));

			// ========================================================
			// D. ของเฉพาะ "งานทำบุญออฟฟิศ/บริษัท" (c7, c8, c9) — เน้นของเสริมมงคลด้านธุรกิจ
			// ========================================================
			items.add(new Item("ป้ายฤกษ์เปิดกิจการ", "ป้ายอวยพรฤกษ์มงคลสำหรับติดหน้าออฟฟิศ", "ป้าย", 600.0, t1,
					Arrays.asList(c7, c8, c9, c12)));
			items.add(new Item("พุ่มเงินพุ่มทอง", "พุ่มดอกไม้สัญลักษณ์เงินทอง เสริมโชคลาภกิจการ", "คู่", 900.0, t1,
					Arrays.asList(c7, c8, c9, c12)));
			items.add(new Item("โต๊ะหมู่บูชาสำนักงาน (กะทัดรัด)", "โต๊ะหมู่บูชาขนาดกะทัดรัดเหมาะกับพื้นที่ออฟฟิศ",
					"ชุด", 2800.0, t1, Arrays.asList(c7, c8, c9, c12)));
			items.add(new Item("ริบบิ้น-กรวยดอกไม้เปิดกิจการ", "สำหรับพิธีตัดริบบิ้น/เปิดกรวยดอกไม้เปิดกิจการ", "ชุด",
					500.0, t1, Arrays.asList(c7, c8, c9, c12)));

			// ========================================================
			// E. ของเฉพาะ "ระดับพรีเมียม" ของทั้ง 3 งาน (c3, c6, c9)
			//    แสดงความต่างระหว่างระดับแพ็กเกจ: พรีเมียมได้ของ/บริการเพิ่มจากมาตรฐานและอิ่มบุญ
			// ========================================================
			items.add(new Item("บริการถ่ายภาพบันทึกพิธี", "ช่างภาพมืออาชีพบันทึกภาพตลอดพิธี พร้อมไฟล์ภาพดิจิทัล",
					"ครั้ง", 3500.0, t3, Arrays.asList(c3, c6, c9, c10, c11, c12)));
			items.add(new Item("ชุดดอกไม้สดตกแต่งพิธีระดับพรีเมียม", "จัดดอกไม้สดตกแต่งบริเวณพิธีแบบพรีเมียม",
					"ชุด", 4500.0, t1, Arrays.asList(c3, c6, c9, c10, c11, c12)));

			itemRepo.saveAllAndFlush(items);

			// 5. QuestionsDetail
			// แก้ไข: เดิมวน allCeremonies (12 แถว = 3 งาน x 4 แพ็กเกจ) ทำให้คำถามชุดเดียวกัน
			// ถูกสร้างซ้ำ 12 รอบ (120 แถวในตาราง questionsdetail) เพราะคำถามควรผูกกับ
			// "ประเภทงาน" (ทำบุญบ้าน/ขึ้นบ้านใหม่/ทำบุญออฟฟิศ) ไม่ใช่ผูกกับทุกแพ็กเกจย่อย
			//
			// ตอนนี้สร้างคำถามแค่ 3 ชุด (1 ชุดต่อ 1 ประเภทงาน) โดยผูกไว้กับ Ceremony
			// "มาตรฐาน" ของแต่ละประเภทเป็นตัวแทน (c1, c4, c7) ส่วนฝั่ง service/repository
			// ต้อง query คำถามโดย join ผ่าน ceremony.ceremonyType แทนการ match
			// ceremonyId ตรงๆ ไม่งั้นแพ็กเกจอื่น (อิ่มบุญ/พรีเมียม/กำหนดเอง) จะไม่เจอคำถามเลย
			//
			// ตัวอย่าง repository method ที่ต้องเพิ่มใน QuestionsRepository:
			//   List<QuestionsDetail> findByCeremony_CeremonyType(String ceremonyType);
			// แล้วใน QuestionsService.getQuestionsByCeremony(int ceremonyId) ให้ resolve
			// ceremonyType จาก ceremonyId ก่อน แล้วค่อยเรียก method ข้างบนแทน เช่น:
			//   Ceremony ceremony = ceremonyRepo.findById(ceremonyId).orElseThrow();
			//   return questionsRepo.findByCeremony_CeremonyType(ceremony.getCeremonyType());
			List<Ceremony> ceremonyTypeRepresentatives = Arrays.asList(c1, c4, c7); // มาตรฐานของแต่ละประเภทงาน

			List<QuestionsDetail> questions = new ArrayList<>();

			for (Ceremony c : ceremonyTypeRepresentatives) {
				questions.add(new QuestionsDetail("รูปแบบการนิมนต์พระสงฆ์", c));
				questions.add(new QuestionsDetail("จำนวนพระสงฆ์", c));
				questions.add(new QuestionsDetail("รายละเอียดการนิมนต์พระสงฆ์", c));
				questions.add(new QuestionsDetail("ต้องการชุดภัตตาหารปิ่นโตหรือไม่", c));
				questions.add(new QuestionsDetail("เลือกชุดภัตตาหารปิ่นโต", c));
				questions.add(new QuestionsDetail("จำนวนชุดภัตตาหารปิ่นโต", c));

				// คำถามสังฆทาน
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

	// ===================
}