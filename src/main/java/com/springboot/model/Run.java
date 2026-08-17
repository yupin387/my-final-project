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

		// =========================================================
		// Repository
		// =========================================================

		CeremonyRepository ceremonyRepo =
				context.getBean(CeremonyRepository.class);

		OrganizerRepository organizerRepo =
				context.getBean(OrganizerRepository.class);

		HeadStaffRepository headStaffRepo =
				context.getBean(HeadStaffRepository.class);

		ItemTypeRepository itemTypeRepo =
				context.getBean(ItemTypeRepository.class);

		ItemRepository itemRepo =
				context.getBean(ItemRepository.class);

		MemberRepository memberRepo =
				context.getBean(MemberRepository.class);

		QuestionsRepository qRepo =
				context.getBean(QuestionsRepository.class);

		CeremonyItemRepository ceremonyItemRepo =
				context.getBean(CeremonyItemRepository.class);


		try {

			// =========================================================
			// 1. CEREMONY
			// =========================================================
			//
			// หมายเหตุ:
			// แพ็กเกจ "ไม่ใช่ ItemType"
			//
			// แพ็กเกจถูกเก็บใน Ceremony เช่น
			// c1 = ทำบุญบ้าน + แพ็กเกจมาตรฐาน
			// c2 = ทำบุญบ้าน + แพ็กเกจอิ่มบุญ
			//
			// CeremonyItem จะเป็นตัวบอกว่า
			// แพ็กเกจนั้นมี Item อะไรบ้าง
			// =========================================================


			// ---------------------------------------------------------
			// ทำบุญบ้าน
			// ---------------------------------------------------------

			Ceremony c1 = new Ceremony(
					"ทำบุญบ้าน",
					"แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 5 รูป)",
					10000.0
			);

			Ceremony c2 = new Ceremony(
					"ทำบุญบ้าน",
					"แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 7 รูป)",
					15000.0
			);

			Ceremony c3 = new Ceremony(
					"ทำบุญบ้าน",
					"แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 9 รูป)",
					18000.0
			);


			// ---------------------------------------------------------
			// ขึ้นบ้านใหม่
			// ---------------------------------------------------------

			Ceremony c4 = new Ceremony(
					"ขึ้นบ้านใหม่",
					"แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 5 รูป)",
					10000.0
			);

			Ceremony c5 = new Ceremony(
					"ขึ้นบ้านใหม่",
					"แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 7 รูป)",
					15000.0
			);

			Ceremony c6 = new Ceremony(
					"ขึ้นบ้านใหม่",
					"แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 9 รูป)",
					18000.0
			);


			// ---------------------------------------------------------
			// ทำบุญบริษัท / ออฟฟิศ
			// ---------------------------------------------------------

			Ceremony c7 = new Ceremony(
					"ทำบุญบริษัทหรือออฟฟิศ",
					"แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 5 รูป)",
					10000.0
			);

			Ceremony c8 = new Ceremony(
					"ทำบุญบริษัทหรือออฟฟิศ",
					"แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 7 รูป)",
					15000.0
			);

			Ceremony c9 = new Ceremony(
					"ทำบุญบริษัทหรือออฟฟิศ",
					"แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 9 รูป)",
					18000.0
			);


			// =========================================================
			// 1.1 กรอกความต้องการเบื้องต้น
			// =========================================================

			Ceremony c10 = new Ceremony(
					"ทำบุญบ้าน",
					"กรอกความต้องการเบื้องต้น",
					"ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา (เริ่มต้น)",
					0.0
			);

			Ceremony c11 = new Ceremony(
					"ขึ้นบ้านใหม่",
					"กรอกความต้องการเบื้องต้น",
					"ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา (เริ่มต้น)",
					0.0
			);

			Ceremony c12 = new Ceremony(
					"ทำบุญบริษัทหรือออฟฟิศ",
					"กรอกความต้องการเบื้องต้น",
					"ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา (เริ่มต้น)",
					0.0
			);


			ceremonyRepo.saveAllAndFlush(Arrays.asList(
					c1, c2, c3,
					c4, c5, c6,
					c7, c8, c9,
					c10, c11, c12
			));


			// =========================================================
			// 2. ORGANIZER
			// =========================================================

			organizerRepo.saveAndFlush(
					new Organizer(
							"admin@gmail.com",
							"12345678"
					)
			);


			// =========================================================
			// 2.1 HEAD STAFF
			// =========================================================

			headStaffRepo.saveAllAndFlush(Arrays.asList(

					new HeadStaff(
							"สมชาย",
							"ใจดี",
							"somchai@gmail.com",
							"12344444",
							"0811111111"
					),

					new HeadStaff(
							"สมหญิง",
							"ใจดี",
							"somying@gmail.com",
							"12345555",
							"0812222222"
					),

					new HeadStaff(
							"วิชัย",
							"รักงาน",
							"wichai@gmail.com",
							"12346666",
							"0813333333"
					),

					new HeadStaff(
							"มานี",
							"รักดี",
							"manee@gmail.com",
							"12347777",
							"0814444444"
					),

					new HeadStaff(
							"ชูใจ",
							"สดใส",
							"chujai@gmail.com",
							"12348888",
							"0815555555"
					),

					new HeadStaff(
							"ปิติ",
							"ตั้งใจ",
							"piti@gmail.com",
							"12349999",
							"0816666666"
					),

					new HeadStaff(
							"อำนาจ",
							"ขยันดี",
							"amnat@gmail.com",
							"12351111",
							"0817777777"
					),

					new HeadStaff(
							"จินตนา",
							"ศรัทธา",
							"jintana@gmail.com",
							"12352222",
							"0818888888"
					))
			);


			// =========================================================
			// 3. ITEM TYPE
			// =========================================================
			//
			// สำคัญ:
			// ไม่มี "แพ็กเกจ" แล้ว
			//
			// เพราะแพ็กเกจอยู่ใน Ceremony
			//
			// ItemType มีหน้าที่บอกว่า Item คืออะไร
			// =========================================================

			ItemType t1 = new ItemType(
					"อุปกรณ์พิธีกรรม"
			);

			ItemType t2 = new ItemType(
					"ภัตตาหารปิ่นโต"
			);

			ItemType t3 = new ItemType(
					"บริการ"
			);

			ItemType t4 = new ItemType(
					"สังฆทาน"
			);

			ItemType t5 = new ItemType(
					"อุปกรณ์เสริม (เลือกเพิ่มเอง)"
			);


			itemTypeRepo.saveAllAndFlush(
					List.of(
							t1,
							t2,
							t3,
							t4,
							t5
					)
			);


			// =========================================================
			// 4. CEREMONY ทั้งหมด
			// =========================================================

			List<Ceremony> allCeremonies = Arrays.asList(
					c1, c2, c3,
					c4, c5, c6,
					c7, c8, c9,
					c10, c11, c12
			);


			// =========================================================
			// 5. ITEM
			// =========================================================

			List<Item> items = new ArrayList<>();


			// =========================================================
			// 5.1 บริการ
			// =========================================================

			Item monkService = new Item(
					"บริการประสานงานนิมนต์พระ",
					"ติดต่อประสานงาน นิมนต์ และรับ-ส่งพระสงฆ์ด้วยรถตู้ VIP (ต่อรูป)",
					"รูป",
					500.0,
					t3
			);

			Item placeService = new Item(
					"บริการจัดสถานที่ประกอบพิธี",
					"จัดเตรียมโต๊ะหมู่บูชา อาสนะพระ และพื้นที่ประกอบพิธี",
					"ครั้ง",
					2500.0,
					t3
			);

			Item staffService = new Item(
					"บริการเจ้าหน้าที่ดูแลพิธี",
					"ดูแลลำดับขั้นตอนและอำนวยความสะดวกภายในงาน",
					"คน",
					800.0,
					t3
			);

			Item mcService = new Item(
					"มัคนายก",
					"ดูแลลำดับขั้นตอน",
					"คน",
					800.0,
					t3
			);

			Item soundService = new Item(
					"เครื่องเสียง (โปรโมชั่นฟรี)",
					"ชุดเครื่องเสียงคุณภาพดี เสียงชัด ครบชุด — แถมฟรีตามโปรโมชั่น",
					"ชุด",
					0.0,
					t3
			);

			Item chairService = new Item(
					"เก้าอี้ (โปรโมชั่นฟรี)",
					"เก้าอี้สะอาด สวยงาม พร้อมใช้งาน 10 ตัว — แถมฟรีตามโปรโมชั่น",
					"ชุด",
					0.0,
					t3
			);

			Item tableService = new Item(
					"โต๊ะพร้อมผ้าคลุม (โปรโมชั่นฟรี)",
					"โต๊ะจัดเต็ม เข้าชุด ดูเรียบร้อย พร้อมผ้าคลุม 2 ตัว — แถมฟรีตามโปรโมชั่น",
					"ชุด",
					0.0,
					t3
			);


			items.add(monkService);
			items.add(placeService);
			items.add(staffService);
			items.add(mcService);
			items.add(soundService);
			items.add(chairService);
			items.add(tableService);


			// =========================================================
			// 5.2 อุปกรณ์พิธีกรรม
			// =========================================================

			Item baiSri = new Item(
					"บายศรีสู่ขวัญ",
					"บายศรีปากชาม สำหรับพิธีสักการะ",
					"ชุด",
					1500.0,
					t1
			);

			Item monkSeat = new Item(
					"อาสนะพระสงฆ์",
					"เบาะรองนั่งกำมะหยี่สำหรับพระสงฆ์ (ต่อรูป)",
					"ตัว",
					250.0,
					t1
			);

			Item brassSet = new Item(
					"ชุดเครื่องทองเหลือง",
					"กระถางธูป และแจกัน",
					"ชุด",
					500.0,
					t1
			);

			Item waterSet = new Item(
					"ที่กรวดน้ำ",
					"ชุดทองเหลืองพร้อมจานรอง",
					"ชุด",
					200.0,
					t1
			);

			Item holyWater = new Item(
					"ชุดน้ำมนต์",
					"ขันน้ำมนต์ทองเหลือง 1 ใบ + แปรงประพรมน้ำมนต์ 1 อัน",
					"ชุด",
					300.0,
					t1
			);

			Item buddhaSet = new Item(
					"ชุดบูชาพระประธาน",
					"ของสักการะถวายหน้าพระประธานโดยเฉพาะ (พานดอกไม้ ธูปเทียนบูชา)",
					"ชุด",
					550.0,
					t1
			);

			Item candle = new Item(
					"เชิงเทียนทองเหลือง",
					"เชิงเทียนสำหรับบูชาพระ",
					"คู่",
					250.0,
					t1
			);

			Item holyString = new Item(
					"สายสิญจน์",
					"ด้ายสายสิญจน์มงคล",
					"ม้วน",
					100.0,
					t1
			);

			Item worshipTable = new Item(
					"โต๊ะวางเครื่องสักการะ",
					"โต๊ะสำหรับวางเครื่องบูชา",
					"ตัว",
					400.0,
					t1
			);

			Item talapat = new Item(
					"ตาลปัตรพร้อมขาตั้ง",
					"ตาลปัตรสำหรับพระสงฆ์ พร้อมขาตั้ง (ต่อรูป)",
					"ชุด",
					350.0,
					t1
			);

			Item flowerWreath = new Item(
					"พวงมาลัยดอกไม้สดถวายพระพุทธ",
					"พวงมาลัยดอกไม้สดสำหรับถวายพระพุทธรูป",
					"พวง",
					150.0,
					t1
			);

			Item flowerCone = new Item(
					"กรวยดอกไม้ถวายพระสงฆ์",
					"กรวยดอกไม้สดสำหรับถวายพระสงฆ์ (ต่อรูป)",
					"กรวย",
					200.0,
					t1
			);


			items.add(baiSri);
			items.add(monkSeat);
			items.add(brassSet);
			items.add(waterSet);
			items.add(holyWater);
			items.add(buddhaSet);
			items.add(candle);
			items.add(holyString);
			items.add(worshipTable);
			items.add(talapat);
			items.add(flowerWreath);
			items.add(flowerCone);


			// =========================================================
			// 5.3 สังฆทาน
			// =========================================================

			Item sanghaStandard = new Item(
					"ชุดสังฆทานมาตรฐาน",
					"ประกอบด้วย สบู่ ยาสีฟัน แปรงสีฟัน ผงซักฟอก และกระดาษทิชชู่",
					"ชุด",
					299.0,
					t4
			);

			Item sanghaPremium = new Item(
					"ชุดสังฆทานพรีเมียม",
					"ประกอบด้วย เครื่องอุปโภคบริโภค ผ้าเช็ดตัว ร่ม และยาสามัญประจำบ้าน",
					"ชุด",
					399.0,
					t4
			);

			Item sanghaRobe = new Item(
					"ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน",
					"ประกอบด้วย ผ้าไตรจีวร ย่ามพระ และเครื่องอุปโภคบริโภคที่จำเป็น",
					"ชุด",
					499.0,
					t4
			);


			items.add(sanghaStandard);
			items.add(sanghaPremium);
			items.add(sanghaRobe);


			// =========================================================
			// 5.4 ภัตตาหารปิ่นโต
			// =========================================================
			//
			// ปิ่นโตเป็น "ภัตตาหารปิ่นโต"
			// ไม่ใช่ "แพ็กเกจ"
			//
			// ถ้าต้องการให้ปิ่นโตตัวนี้อยู่ในแพ็กเกจ
			// ให้เพิ่ม CeremonyItem ภายหลัง
			//
			// เช่น
			// ceremonyItemRepo.save(
			//     new CeremonyItem(c1, pintoEconomy, 5)
			// );
			//
			// แบบนี้จะหมายถึง
			// แพ็กเกจมาตรฐานมีปิ่นโต 5 เถา
			// =========================================================

			Item pintoEconomy = new Item(
					"ปิ่นโตชุดประหยัด",
					"ข้าวสวย แกงจืดเต้าหู้หมูสับ ผัดผักรวม และผลไม้ตามฤดูกาล",
					"เถา",
					199.0,
					t2
			);

			Item pintoStandard = new Item(
					"ปิ่นโตชุดมาตรฐาน",
					"ข้าวสวย แกงเขียวหวานไก่ ผัดผักรวม ไข่พะโล้ และผลไม้ตามฤดูกาล",
					"เถา",
					399.0,
					t2
			);

			Item pintoPremium = new Item(
					"ปิ่นโตชุดพรีเมียม",
					"ข้าวสวย ต้มยำกุ้ง ปลานึ่งมะนาว ผัดผักรวม ขนมหวานไทย และผลไม้ตามฤดูกาล",
					"เถา",
					499.0,
					t2
			);

			Item pintoSpecial = new Item(
					"ปิ่นโตชุดพิเศษ",
					"ข้าวสวย ปลาทอดราดซอส ต้มยำกุ้ง ผัดผักรวม ขนมหวานไทย ผลไม้รวม และเครื่องดื่ม",
					"เถา",
					599.0,
					t2
			);


			items.add(pintoEconomy);
			items.add(pintoStandard);
			items.add(pintoPremium);
			items.add(pintoSpecial);


			// =========================================================
			// 5.5 ของเฉพาะงานทำบุญบ้าน
			// =========================================================

			Item houseFlower = new Item(
					"พานพุ่มดอกไม้สดถวายพระ",
					"พุ่มดอกไม้สดสำหรับถวายพระในพิธีทำบุญบ้าน",
					"พุ่ม",
					350.0,
					t1
			);

			items.add(houseFlower);


			// =========================================================
			// 5.6 ของเฉพาะงานขึ้นบ้านใหม่
			// =========================================================

			Item teakTable = new Item(
					"โต๊ะหมู่บูชาไม้สัก",
					"โต๊ะหมู่ 7 สำหรับประดิษฐานพระ",
					"ชุด",
					3500.0,
					t1
			);

			Item buddha = new Item(
					"พระพุทธรูปประดิษฐาน",
					"พระพุทธรูปสำหรับขึ้นหิ้งพระ",
					"องค์",
					2500.0,
					t1
			);

			Item doorSet = new Item(
					"ชุดเจิมประตูหน้าต่าง",
					"แป้งเจิมมงคล + แผ่นทองคำเปลว สำหรับเจิมประตูหน้าต่าง",
					"ชุด",
					300.0,
					t1
			);


			items.add(teakTable);
			items.add(buddha);
			items.add(doorSet);


			// =========================================================
			// 5.7 ของเฉพาะงานออฟฟิศ
			// =========================================================

			Item openingSign = new Item(
					"ป้ายฤกษ์เปิดกิจการ",
					"ป้ายอวยพรฤกษ์มงคลสำหรับติดหน้าออฟฟิศ",
					"ป้าย",
					600.0,
					t1
			);

			Item moneyFlower = new Item(
					"พุ่มเงินพุ่มทอง",
					"พุ่มดอกไม้สัญลักษณ์เงินทอง เสริมโชคลาภกิจการ",
					"คู่",
					900.0,
					t1
			);

			Item officeTable = new Item(
					"โต๊ะหมู่บูชาสำนักงาน (กะทัดรัด)",
					"โต๊ะหมู่บูชาขนาดกะทัดรัดเหมาะกับพื้นที่ออฟฟิศ",
					"ชุด",
					2800.0,
					t1
			);

			Item ribbonSet = new Item(
					"ริบบิ้น-กรวยดอกไม้เปิดกิจการ",
					"สำหรับพิธีตัดริบบิ้น/เปิดกรวยดอกไม้เปิดกิจการ",
					"ชุด",
					500.0,
					t1
			);


			items.add(openingSign);
			items.add(moneyFlower);
			items.add(officeTable);
			items.add(ribbonSet);


			// =========================================================
			// 5.8 ของระดับ Premium
			// =========================================================

			Item photographer = new Item(
					"บริการถ่ายภาพบันทึกพิธี",
					"ช่างภาพมืออาชีพบันทึกภาพตลอดพิธี พร้อมไฟล์ภาพดิจิทัล",
					"ครั้ง",
					3500.0,
					t3
			);

			Item premiumFlower = new Item(
					"ชุดดอกไม้สดตกแต่งพิธีระดับพรีเมียม",
					"จัดดอกไม้สดตกแต่งบริเวณพิธีแบบพรีเมียม",
					"ชุด",
					4500.0,
					t1
			);


			items.add(photographer);
			items.add(premiumFlower);


			// =========================================================
			// 5.9 อุปกรณ์เสริม
			// =========================================================
			//
			// ของกลุ่มนี้ "เลือกเพิ่มเอง"
			// จึงยังไม่ต้องผูกกับ Ceremony
			// =========================================================

			Item tent = new Item(
					"เต็นท์ขนาดมาตรฐาน",
					"เต็นท์ผ้าใบขนาดมาตรฐาน สำหรับกันแดดกันฝนบริเวณจัดงาน",
					"หลัง",
					2000.0,
					t5
			);

			Item extraTable = new Item(
					"โต๊ะ",
					"โต๊ะพร้อมผ้าคลุม สำหรับกรณีต้องการเพิ่มเติม",
					"ตัว",
					150.0,
					t5
			);

			Item extraChair = new Item(
					"เก้าอี้",
					"เก้าอี้สำหรับแขกร่วมงาน กรณีต้องการเพิ่มเติม",
					"ตัว",
					30.0,
					t5
			);

			Item fan = new Item(
					"พัดลมไอเย็น",
					"พัดลมไอเย็นสำหรับบริเวณจัดงานกลางแจ้ง",
					"ตัว",
					500.0,
					t5
			);

			Item microphone = new Item(
					"ไมโครโฟนไร้สาย",
					"ไมค์ลอยไร้สายสำหรับพิธีกรหรือผู้กล่าวสุนทรพจน์เพิ่มเติม",
					"ตัว",
					300.0,
					t5
			);

			Item carpet = new Item(
					"พรมทางเดิน",
					"พรมปูทางเดินบริเวณจัดงาน",
					"เส้น",
					600.0,
					t5
			);


			items.add(tent);
			items.add(extraTable);
			items.add(extraChair);
			items.add(fan);
			items.add(microphone);
			items.add(carpet);


			// =========================================================
			// SAVE ITEM
			// =========================================================

			itemRepo.saveAllAndFlush(items);


			// =========================================================
			// 6. CEREMONY ITEM
			// =========================================================
			//
			// CeremonyItem = ตัวเชื่อม Ceremony กับ Item
			//
			// ใช้บอกว่า:
			//
			// แพ็กเกจนี้มี Item อะไร
			// และมีจำนวนเท่าไร
			//
			// ตัวอย่าง:
			//
			// c1 + อาสนะ = 5
			// c1 + ตาลปัตร = 5
			// c1 + กรวย = 5
			//
			// =========================================================


			// =========================================================
			// 6.1 ทำบุญบ้าน : แพ็กเกจมาตรฐาน 5 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c1, monkService, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, monkSeat, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, talapat, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, flowerCone, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, baiSri, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, brassSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, waterSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, holyWater, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, buddhaSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, candle, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, holyString, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c1, worshipTable, 1)
			);


			// =========================================================
			// 6.2 ทำบุญบ้าน : แพ็กเกจอิ่มบุญ 7 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c2, monkService, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, monkSeat, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, talapat, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, flowerCone, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, baiSri, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, brassSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, waterSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, holyWater, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, buddhaSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, candle, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, holyString, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c2, worshipTable, 1)
			);


			// =========================================================
			// 6.3 ทำบุญบ้าน : แพ็กเกจพรีเมียม 9 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c3, monkService, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, monkSeat, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, talapat, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, flowerCone, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, baiSri, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, brassSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, waterSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, holyWater, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, buddhaSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, candle, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, holyString, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c3, worshipTable, 1)
			);


			// =========================================================
			// 6.4 ขึ้นบ้านใหม่ : แพ็กเกจมาตรฐาน 5 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c4, monkService, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, monkSeat, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, talapat, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, flowerCone, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, teakTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, buddha, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c4, doorSet, 1)
			);


			// =========================================================
			// 6.5 ขึ้นบ้านใหม่ : แพ็กเกจอิ่มบุญ 7 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c5, monkService, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, monkSeat, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, talapat, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, flowerCone, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, teakTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, buddha, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c5, doorSet, 1)
			);


			// =========================================================
			// 6.6 ขึ้นบ้านใหม่ : แพ็กเกจพรีเมียม 9 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c6, monkService, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, monkSeat, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, talapat, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, flowerCone, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, teakTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, buddha, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c6, doorSet, 1)
			);


			// =========================================================
			// 6.7 ทำบุญออฟฟิศ : แพ็กเกจมาตรฐาน 5 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c7, monkService, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, monkSeat, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, talapat, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, flowerCone, 5)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, openingSign, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, moneyFlower, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, officeTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c7, ribbonSet, 1)
			);


			// =========================================================
			// 6.8 ทำบุญออฟฟิศ : แพ็กเกจอิ่มบุญ 7 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c8, monkService, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, monkSeat, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, talapat, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, flowerCone, 7)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, openingSign, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, moneyFlower, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, officeTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c8, ribbonSet, 1)
			);


			// =========================================================
			// 6.9 ทำบุญออฟฟิศ : แพ็กเกจพรีเมียม 9 พระ
			// =========================================================

			ceremonyItemRepo.save(
					new CeremonyItem(c9, monkService, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, placeService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, staffService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, mcService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, soundService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, chairService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, tableService, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, monkSeat, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, talapat, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, flowerCone, 9)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, openingSign, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, moneyFlower, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, officeTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, ribbonSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, photographer, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c9, premiumFlower, 1)
			);


			// =========================================================
			// 6.10 กรอกความต้องการเบื้องต้น
			// =========================================================
			//
			// c10 / c11 / c12
			//
			// ไม่กำหนดจำนวนพระสงฆ์ล่วงหน้า
			// เพราะลูกค้าจะกรอกจำนวนพระเอง
			// =========================================================


			// ---------------------------------------------------------
			// บริการพื้นฐานร่วมทุกงาน
			// ---------------------------------------------------------

			for (Ceremony c : Arrays.asList(
					c10,
					c11,
					c12
			)) {

				ceremonyItemRepo.save(
						new CeremonyItem(c, placeService, 1)
				);

				ceremonyItemRepo.save(
						new CeremonyItem(c, staffService, 1)
				);

				ceremonyItemRepo.save(
						new CeremonyItem(c, mcService, 1)
				);

				ceremonyItemRepo.save(
						new CeremonyItem(c, soundService, 1)
				);

				ceremonyItemRepo.save(
						new CeremonyItem(c, chairService, 1)
				);

				ceremonyItemRepo.save(
						new CeremonyItem(c, tableService, 1)
				);
			}


			// ---------------------------------------------------------
			// c10 : ทำบุญบ้าน
			// ---------------------------------------------------------

			ceremonyItemRepo.save(
					new CeremonyItem(c10, baiSri, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c10, brassSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c10, waterSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c10, holyWater, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c10, buddhaSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c10, candle, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c10, holyString, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c10, worshipTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c10, houseFlower, 1)
			);


			// ---------------------------------------------------------
			// c11 : ขึ้นบ้านใหม่
			// ---------------------------------------------------------

			ceremonyItemRepo.save(
					new CeremonyItem(c11, teakTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c11, buddha, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c11, doorSet, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c11, holyWater, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c11, holyString, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c11, candle, 1)
			);


			// ---------------------------------------------------------
			// c12 : ทำบุญบริษัท / ออฟฟิศ
			// ---------------------------------------------------------

			ceremonyItemRepo.save(
					new CeremonyItem(c12, openingSign, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c12, moneyFlower, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c12, officeTable, 1)
			);

			ceremonyItemRepo.save(
					new CeremonyItem(c12, ribbonSet, 1)
			);


			// =========================================================
			// 6.11 สังฆทานมาตรฐาน 299
			// =========================================================
			//
			// สำคัญมาก
			//
			// สังฆทานมาตรฐาน 299
			// "รวมอยู่ในทุกแพ็กเกจ"
			//
			// ดังนั้นผูกเฉพาะ c1-c9
			//
			// ไม่ผูก c10-c12
			//
			// เพราะ c10-c12 เป็นกรอกความต้องการเบื้องต้น
			// =========================================================

			List<Ceremony> packageCeremonies = Arrays.asList(
					c1, c2, c3,
					c4, c5, c6,
					c7, c8, c9
			);

			for (Ceremony c : packageCeremonies) {

				ceremonyItemRepo.save(
						new CeremonyItem(
								c,
								sanghaStandard,
								1
						)
				);
			}


			// =========================================================
			// 6.12 ตัวอย่าง "ปิ่นโตอยู่ในแพ็กเกจ"
			// =========================================================
			//
			// ตอนนี้ยังไม่ใส่ปิ่นโตลงทุกแพ็กเกจอัตโนมัติ
			//
			// เพราะ Item "ปิ่นโตชุดประหยัด" เป็น Item กลาง
			// ที่สามารถเลือกไปใส่แพ็กเกจใดก็ได้
			//
			// ถ้าภายหลังอาจารย์กำหนดว่า
			//
			// แพ็กเกจมาตรฐานต้องมีปิ่นโต 5 เถา
			//
			// ก็เพิ่มเพียง:
			//
			// ceremonyItemRepo.save(
			//     new CeremonyItem(c1, pintoEconomy, 5)
			// );
			//
			// เท่านั้น
			//
			// ไม่ต้องสร้าง Item ใหม่
			// และไม่ต้องเปลี่ยนประเภทจาก "ภัตตาหารปิ่นโต"
			// เป็น "แพ็กเกจ"
			// =========================================================


			// =========================================================
			// 7. QUESTIONS DETAIL
			// =========================================================
			//
			// Many-to-Many กับ Ceremony
			// =========================================================

			QuestionsDetail q1 =
					new QuestionsDetail(
							"รูปแบบการนิมนต์พระสงฆ์"
					);

			QuestionsDetail q2 =
					new QuestionsDetail(
							"จำนวนพระสงฆ์"
					);

			QuestionsDetail q3 =
					new QuestionsDetail(
							"รายละเอียดการนิมนต์พระสงฆ์"
					);

			QuestionsDetail q4 =
					new QuestionsDetail(
							"ต้องการชุดภัตตาหารปิ่นโตหรือไม่"
					);

			QuestionsDetail q5 =
					new QuestionsDetail(
							"เลือกชุดภัตตาหารปิ่นโต"
					);

			QuestionsDetail q6 =
					new QuestionsDetail(
							"จำนวนชุดภัตตาหารปิ่นโต"
					);

			QuestionsDetail q7 =
					new QuestionsDetail(
							"ต้องการสังฆทานหรือไม่"
					);

			QuestionsDetail q8 =
					new QuestionsDetail(
							"เลือกชุดสังฆทานที่ต้องการ"
					);

			QuestionsDetail q9 =
					new QuestionsDetail(
							"จำนวนชุดสังฆทาน"
					);

			QuestionsDetail q11 =
					new QuestionsDetail(
							"มีความต้องการเพิ่มเติมหรือไม่"
					);


			List<QuestionsDetail> allQuestions =
					Arrays.asList(
							q1,
							q2,
							q3,
							q4,
							q5,
							q6,
							q7,
							q8,
							q9,
							q11
					);


			qRepo.saveAllAndFlush(
					allQuestions
			);


			// ---------------------------------------------------------
			// ผูกคำถามกับ Ceremony ทุกตัว
			// ---------------------------------------------------------

			for (Ceremony c : allCeremonies) {

				c.setQuestions(
						allQuestions
				);
			}


			ceremonyRepo.saveAllAndFlush(
					allCeremonies
			);


			// =========================================================
			// 8. MEMBER
			// =========================================================

			memberRepo.saveAllAndFlush(
					Arrays.asList(

							new Member(
									"บุญมี",
									"ลุงหลู่",
									"boonmee@gmail.com",
									"12345678",
									"0812345678"
							),

							new Member(
									"สุนีย์",
									"คำดี",
									"sunee@gmail.com",
									"12345679",
									"0812345679"
							),

							new Member(
									"ประเสริฐ",
									"สุขใจ",
									"prasert@gmail.com",
									"12345680",
									"0812345680"
							),

							new Member(
									"อารีย์",
									"บุญส่ง",
									"aree@gmail.com",
									"12345681",
									"0812345681"
							),

							new Member(
									"ธนพล",
									"ศรีสุข",
									"thanapon@gmail.com",
									"12345682",
									"0812345682"
							)
					)
			);


			// =========================================================
			// SYSTEM READY
			// =========================================================

			System.out.println(
					"\n>> --- [SYSTEM READY] DATA SEEDED SUCCESSFULLY ---"
			);


		} catch (Exception e) {

			e.printStackTrace();

		}
	}
}