package com.springboot.model;

import java.time.LocalDateTime;

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

		PackageRepository packageRepo = context.getBean(PackageRepository.class);

		ManagerRepository managerRepo = context.getBean(ManagerRepository.class);

		HeadStaffRepository headStaffRepo = context.getBean(HeadStaffRepository.class);

		ItemTypeRepository itemTypeRepo = context.getBean(ItemTypeRepository.class);

		ItemRepository itemRepo = context.getBean(ItemRepository.class);

		MemberRepository memberRepo = context.getBean(MemberRepository.class);

		QuestionsRepository qRepo = context.getBean(QuestionsRepository.class);

		PackageItemRepository packageItemRepo = context.getBean(PackageItemRepository.class);

		try {

			// =========================================================
			// 1. PACKAGE
			// =========================================================

			// ---------------------------------------------------------
			// ทำบุญบ้าน
			// ---------------------------------------------------------

			Package c1 = new Package("ทำบุญบ้าน", "แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 5 รูป)", 10000.0);

			Package c2 = new Package("ทำบุญบ้าน", "แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 7 รูป)", 15000.0);

			Package c3 = new Package("ทำบุญบ้าน", "แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับทำบุญบ้าน (นิมนต์พระสงฆ์ 9 รูป)", 18000.0);

			// ---------------------------------------------------------
			// ขึ้นบ้านใหม่
			// ---------------------------------------------------------

			Package c4 = new Package("ขึ้นบ้านใหม่", "แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 5 รูป)", 10000.0);

			Package c5 = new Package("ขึ้นบ้านใหม่", "แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 7 รูป)", 15000.0);

			Package c6 = new Package("ขึ้นบ้านใหม่", "แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับขึ้นบ้านใหม่ (นิมนต์พระสงฆ์ 9 รูป)", 18000.0);

			// ---------------------------------------------------------
			// ทำบุญบริษัท / ออฟฟิศ
			// ---------------------------------------------------------

			Package c7 = new Package("ทำบุญบริษัทหรือออฟฟิศ", "แพ็กเกจมาตรฐาน",
					"แพ็กเกจมาตรฐาน สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 5 รูป)", 10000.0);

			Package c8 = new Package("ทำบุญบริษัทหรือออฟฟิศ", "แพ็กเกจอิ่มบุญ",
					"แพ็กเกจอิ่มบุญ สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 7 รูป)", 15000.0);

			Package c9 = new Package("ทำบุญบริษัทหรือออฟฟิศ", "แพ็กเกจพรีเมียม",
					"แพ็กเกจพรีเมียม สำหรับทำบุญออฟฟิศ (นิมนต์พระสงฆ์ 9 รูป)", 18000.0);

			// =========================================================
			// 1.1 กรอกความต้องการเบื้องต้น
			// =========================================================

			Package c10 = new Package("ทำบุญบ้าน", "กรอกความต้องการเบื้องต้น",
					"ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา (เริ่มต้น)", 0.0);

			Package c11 = new Package("ขึ้นบ้านใหม่", "กรอกความต้องการเบื้องต้น",
					"ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา (เริ่มต้น)", 0.0);

			Package c12 = new Package("ทำบุญบริษัทหรือออฟฟิศ", "กรอกความต้องการเบื้องต้น",
					"ลูกค้ากรอกรายละเอียดงานเบื้องต้น และให้ผู้จัดงานจัดบริการพร้อมประเมินราคา (เริ่มต้น)", 0.0);

			packageRepo.saveAllAndFlush(Arrays.asList(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12));

			// =========================================================
			// 2. MANAGER
			// =========================================================

			managerRepo.saveAndFlush(new Manager("admin17@gmail.com", "12345678"));

			// =========================================================
			// 2.1 HEAD STAFF
			// =========================================================

			headStaffRepo.saveAllAndFlush(Arrays.asList(

					new HeadStaff("สมชาย", "ใจดี", "somchai87@gmail.com", "12344444", "0811111111",
							LocalDateTime.of(2025, 1, 10, 9, 0)),

					new HeadStaff("สมหญิง", "ใจดี", "somying75@gmail.com", "12345555", "0812222222",
							LocalDateTime.of(2025, 2, 15, 9, 30)),

					new HeadStaff("วิชัย", "รักงาน", "wichai7@gmail.com", "12346666", "0813333333",
							LocalDateTime.of(2025, 3, 20, 10, 0)),

					new HeadStaff("มานี", "รักดี", "manee41@gmail.com", "12347777", "0814444444",
							LocalDateTime.of(2025, 4, 5, 8, 45)),

					new HeadStaff("ชูใจ", "สดใส", "chujai78@gmail.com", "12348888", "0815555555",
							LocalDateTime.of(2025, 5, 12, 13, 15)),

					new HeadStaff("ปิติ", "ตั้งใจ", "piti824@gmail.com", "12349999", "0816666666",
							LocalDateTime.of(2025, 6, 18, 14, 0)),

					new HeadStaff("อำนาจ", "ขยันดี", "amnat895@gmail.com", "12351111", "0817777777",
							LocalDateTime.of(2025, 7, 22, 9, 20)),

					new HeadStaff("จินตนา", "ศรัทธา", "jintana32@gmail.com", "12352222", "0818888888",
							LocalDateTime.of(2025, 8, 30, 11, 10))));

			// =========================================================
			// 3. ITEM TYPE
			// =========================================================

			ItemType t1 = new ItemType("อุปกรณ์พิธีกรรม");

			ItemType t2 = new ItemType("ภัตตาหารปิ่นโต");

			ItemType t3 = new ItemType("บริการ");

			ItemType t4 = new ItemType("สังฆทาน");

			ItemType t5 = new ItemType("อุปกรณ์เสริม (เลือกเพิ่มเอง)");

			itemTypeRepo.saveAllAndFlush(List.of(t1, t2, t3, t4, t5));

			// =========================================================
			// 4. PACKAGE ทั้งหมด
			// =========================================================

			List<Package> allPackages = Arrays.asList(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12);

			// =========================================================
			// 5. ITEM
			// =========================================================

			List<Item> items = new ArrayList<>();

			// =========================================================
			// 5.1 บริการ
			// =========================================================

			Item monkService = new Item("บริการประสานงานนิมนต์พระ",
					"ติดต่อประสานงาน นิมนต์ และรับ-ส่งพระสงฆ์ด้วยรถตู้ VIP (ต่อรูป)", "รูป", 500.0, t3);

			Item placeService = new Item("บริการจัดสถานที่ประกอบพิธี",
					"จัดเตรียมโต๊ะหมู่บูชา อาสนะพระ และพื้นที่ประกอบพิธี", "ครั้ง", 2500.0, t3);

			Item staffService = new Item("บริการเจ้าหน้าที่ดูแลพิธี", "ดูแลลำดับขั้นตอนและอำนวยความสะดวกภายในงาน", "คน",
					800.0, t3);

			Item mcService = new Item("มัคนายก", "ดูแลลำดับขั้นตอน", "คน", 800.0, t3);

			Item soundService = new Item("เครื่องเสียง (โปรโมชั่นฟรี)",
					"ชุดเครื่องเสียงคุณภาพดี เสียงชัด ครบชุด — แถมฟรีตามโปรโมชั่น", "ชุด", 0.0, t3);

			Item chairService = new Item("เก้าอี้ (โปรโมชั่นฟรี)",
					"เก้าอี้สะอาด สวยงาม พร้อมใช้งาน 10 ตัว — แถมฟรีตามโปรโมชั่น", "ชุด", 0.0, t3);

			Item tableService = new Item("โต๊ะพร้อมผ้าคลุม (โปรโมชั่นฟรี)",
					"โต๊ะจัดเต็ม เข้าชุด ดูเรียบร้อย พร้อมผ้าคลุม 2 ตัว — แถมฟรีตามโปรโมชั่น", "ชุด", 0.0, t3);

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

			Item baiSri = new Item("บายศรีสู่ขวัญ", "บายศรีปากชาม สำหรับพิธีสักการะ", "ชุด", 1500.0, t1);

			Item monkSeat = new Item("อาสนะพระสงฆ์", "เบาะรองนั่งกำมะหยี่สำหรับพระสงฆ์ (ต่อรูป)", "ตัว", 250.0, t1);

			Item brassSet = new Item("ชุดเครื่องทองเหลือง", "กระถางธูป และแจกัน", "ชุด", 500.0, t1);

			Item waterSet = new Item("ที่กรวดน้ำ", "ชุดทองเหลืองพร้อมจานรอง", "ชุด", 200.0, t1);

			Item holyWater = new Item("ชุดน้ำมนต์", "ขันน้ำมนต์ทองเหลือง 1 ใบ + แปรงประพรมน้ำมนต์ 1 อัน", "ชุด", 300.0,
					t1);

			Item buddhaSet = new Item("ชุดบูชาพระประธาน",
					"ของสักการะถวายหน้าพระประธานโดยเฉพาะ (พานดอกไม้ ธูปเทียนบูชา)", "ชุด", 550.0, t1);

			Item candle = new Item("เชิงเทียนทองเหลือง", "เชิงเทียนสำหรับบูชาพระ", "คู่", 250.0, t1);

			Item holyString = new Item("สายสิญจน์", "ด้ายสายสิญจน์มงคล", "ม้วน", 100.0, t1);

			Item worshipTable = new Item("โต๊ะวางเครื่องสักการะ", "โต๊ะสำหรับวางเครื่องบูชา", "ตัว", 400.0, t1);

			Item talapat = new Item("ตาลปัตรพร้อมขาตั้ง", "ตาลปัตรสำหรับพระสงฆ์ พร้อมขาตั้ง (ต่อรูป)", "ชุด", 350.0,
					t1);

			Item flowerWreath = new Item("พวงมาลัยดอกไม้สดถวายพระพุทธ", "พวงมาลัยดอกไม้สดสำหรับถวายพระพุทธรูป", "พวง",
					150.0, t1);

			Item flowerCone = new Item("กรวยดอกไม้ถวายพระสงฆ์", "กรวยดอกไม้สดสำหรับถวายพระสงฆ์ (ต่อรูป)", "กรวย", 200.0,
					t1);

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

			Item sanghaStandard = new Item("ชุดสังฆทานมาตรฐาน",
					"ประกอบด้วย สบู่ ยาสีฟัน แปรงสีฟัน ผงซักฟอก และกระดาษทิชชู่", "ชุด", 299.0, t4);

			Item sanghaPremium = new Item("ชุดสังฆทานพรีเมียม",
					"ประกอบด้วย เครื่องอุปโภคบริโภค ผ้าเช็ดตัว ร่ม และยาสามัญประจำบ้าน", "ชุด", 399.0, t4);

			Item sanghaRobe = new Item("ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน",
					"ประกอบด้วย ผ้าไตรจีวร ย่ามพระ และเครื่องอุปโภคบริโภคที่จำเป็น", "ชุด", 499.0, t4);

			items.add(sanghaStandard);
			items.add(sanghaPremium);
			items.add(sanghaRobe);

			Item pintoEconomy = new Item("ปิ่นโตชุดประหยัด", "ข้าวสวย แกงจืดเต้าหู้หมูสับ ผัดผักรวม และผลไม้ตามฤดูกาล",
					"เถา", 299.0, t2);

			Item pintoStandard = new Item("ปิ่นโตชุดมาตรฐาน",
					"ข้าวสวย แกงเขียวหวานไก่ ผัดผักรวม ไข่พะโล้ และผลไม้ตามฤดูกาล", "เถา", 399.0, t2);

			Item pintoPremium = new Item("ปิ่นโตชุดพรีเมียม",
					"ข้าวสวย ต้มยำกุ้ง ปลานึ่งมะนาว ผัดผักรวม ขนมหวานไทย และผลไม้ตามฤดูกาล", "เถา", 499.0, t2);

			Item pintoSpecial = new Item("ปิ่นโตชุดพิเศษ",
					"ข้าวสวย ปลาทอดราดซอส ต้มยำกุ้ง ผัดผักรวม ขนมหวานไทย ผลไม้รวม และเครื่องดื่ม", "เถา", 599.0, t2);

			items.add(pintoEconomy);
			items.add(pintoStandard);
			items.add(pintoPremium);
			items.add(pintoSpecial);

			// =========================================================
			// 5.5 ของเฉพาะงานทำบุญบ้าน
			// =========================================================

			Item houseFlower = new Item("พานพุ่มดอกไม้สดถวายพระ", "พุ่มดอกไม้สดสำหรับถวายพระในพิธีทำบุญบ้าน", "พุ่ม",
					350.0, t1);

			items.add(houseFlower);

			// =========================================================
			// 5.6 ของเฉพาะงานขึ้นบ้านใหม่
			// =========================================================

			Item teakTable = new Item("โต๊ะหมู่บูชาไม้สัก", "โต๊ะหมู่ 7 สำหรับประดิษฐานพระ", "ชุด", 3500.0, t1);

			Item buddha = new Item("พระพุทธรูปประดิษฐาน", "พระพุทธรูปสำหรับขึ้นหิ้งพระ", "องค์", 2500.0, t1);

			Item doorSet = new Item("ชุดเจิมประตูหน้าต่าง", "แป้งเจิมมงคล + แผ่นทองคำเปลว สำหรับเจิมประตูหน้าต่าง",
					"ชุด", 300.0, t1);

			items.add(teakTable);
			items.add(buddha);
			items.add(doorSet);

			// =========================================================
			// 5.7 ของเฉพาะงานออฟฟิศ
			// =========================================================

			Item openingSign = new Item("ป้ายฤกษ์เปิดกิจการ", "ป้ายอวยพรฤกษ์มงคลสำหรับติดหน้าออฟฟิศ", "ป้าย", 600.0,
					t1);

			Item moneyFlower = new Item("พุ่มเงินพุ่มทอง", "พุ่มดอกไม้สัญลักษณ์เงินทอง เสริมโชคลาภกิจการ", "คู่", 900.0,
					t1);

			Item officeTable = new Item("โต๊ะหมู่บูชาสำนักงาน (กะทัดรัด)",
					"โต๊ะหมู่บูชาขนาดกะทัดรัดเหมาะกับพื้นที่ออฟฟิศ", "ชุด", 2800.0, t1);

			Item ribbonSet = new Item("ริบบิ้น-กรวยดอกไม้เปิดกิจการ", "สำหรับพิธีตัดริบบิ้น/เปิดกรวยดอกไม้เปิดกิจการ",
					"ชุด", 500.0, t1);

			items.add(openingSign);
			items.add(moneyFlower);
			items.add(officeTable);
			items.add(ribbonSet);

			// =========================================================
			// 5.8 ของระดับ Premium
			// =========================================================

			Item photographer = new Item("บริการถ่ายภาพบันทึกพิธี",
					"ช่างภาพมืออาชีพบันทึกภาพตลอดพิธี พร้อมไฟล์ภาพดิจิทัล", "ครั้ง", 3500.0, t3);

			Item premiumFlower = new Item("ชุดดอกไม้สดตกแต่งพิธีระดับพรีเมียม",
					"จัดดอกไม้สดตกแต่งบริเวณพิธีแบบพรีเมียม", "ชุด", 4500.0, t1);

			items.add(photographer);
			items.add(premiumFlower);

			// =========================================================
			// 5.9 อุปกรณ์เสริม
			// =========================================================

			Item tent = new Item("เต็นท์ขนาดมาตรฐาน", "เต็นท์ผ้าใบขนาดมาตรฐาน สำหรับกันแดดกันฝนบริเวณจัดงาน", "หลัง",
					2000.0, t5);

			Item extraTable = new Item("โต๊ะ", "โต๊ะพร้อมผ้าคลุม สำหรับกรณีต้องการเพิ่มเติม", "ตัว", 150.0, t5);

			Item extraChair = new Item("เก้าอี้", "เก้าอี้สำหรับแขกร่วมงาน กรณีต้องการเพิ่มเติม", "ตัว", 30.0, t5);

			Item fan = new Item("พัดลมไอเย็น", "พัดลมไอเย็นสำหรับบริเวณจัดงานกลางแจ้ง", "ตัว", 500.0, t5);

			Item microphone = new Item("ไมโครโฟนไร้สาย", "ไมค์ลอยไร้สายสำหรับพิธีกรหรือผู้กล่าวสุนทรพจน์เพิ่มเติม",
					"ตัว", 300.0, t5);

			Item carpet = new Item("พรมทางเดิน", "พรมปูทางเดินบริเวณจัดงาน", "เส้น", 600.0, t5);

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
			// 6. PACKAGE ITEM
			// =========================================================

			// =========================================================
			// 6.1 ทำบุญบ้าน : แพ็กเกจมาตรฐาน 5 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c1, monkService, 5));

			packageItemRepo.save(new PackageItem(c1, placeService, 1));

			packageItemRepo.save(new PackageItem(c1, staffService, 1));

			packageItemRepo.save(new PackageItem(c1, mcService, 1));

			packageItemRepo.save(new PackageItem(c1, soundService, 1));

			packageItemRepo.save(new PackageItem(c1, chairService, 1));

			packageItemRepo.save(new PackageItem(c1, tableService, 1));

			packageItemRepo.save(new PackageItem(c1, monkSeat, 5));

			packageItemRepo.save(new PackageItem(c1, talapat, 5));

			packageItemRepo.save(new PackageItem(c1, flowerCone, 5));

			packageItemRepo.save(new PackageItem(c1, baiSri, 1));

			packageItemRepo.save(new PackageItem(c1, brassSet, 1));

			packageItemRepo.save(new PackageItem(c1, waterSet, 1));

			packageItemRepo.save(new PackageItem(c1, holyWater, 1));

			packageItemRepo.save(new PackageItem(c1, buddhaSet, 1));

			packageItemRepo.save(new PackageItem(c1, candle, 1));

			packageItemRepo.save(new PackageItem(c1, holyString, 1));

			packageItemRepo.save(new PackageItem(c1, worshipTable, 1));

			// ✅ เพิ่ม: พานพุ่มดอกไม้สดถวายพระ (ของเฉพาะงานทำบุญบ้าน)
			packageItemRepo.save(new PackageItem(c1, houseFlower, 1));

			// =========================================================
			// 6.2 ทำบุญบ้าน : แพ็กเกจอิ่มบุญ 7 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c2, monkService, 7));

			packageItemRepo.save(new PackageItem(c2, placeService, 1));

			packageItemRepo.save(new PackageItem(c2, staffService, 1));

			packageItemRepo.save(new PackageItem(c2, mcService, 1));

			packageItemRepo.save(new PackageItem(c2, soundService, 1));

			packageItemRepo.save(new PackageItem(c2, chairService, 1));

			packageItemRepo.save(new PackageItem(c2, tableService, 1));

			packageItemRepo.save(new PackageItem(c2, monkSeat, 7));

			packageItemRepo.save(new PackageItem(c2, talapat, 7));

			packageItemRepo.save(new PackageItem(c2, flowerCone, 7));

			packageItemRepo.save(new PackageItem(c2, baiSri, 1));

			packageItemRepo.save(new PackageItem(c2, brassSet, 1));

			packageItemRepo.save(new PackageItem(c2, waterSet, 1));

			packageItemRepo.save(new PackageItem(c2, holyWater, 1));

			packageItemRepo.save(new PackageItem(c2, buddhaSet, 1));

			packageItemRepo.save(new PackageItem(c2, candle, 1));

			packageItemRepo.save(new PackageItem(c2, holyString, 1));

			packageItemRepo.save(new PackageItem(c2, worshipTable, 1));

			// ✅ เพิ่ม: พานพุ่มดอกไม้สดถวายพระ (ของเฉพาะงานทำบุญบ้าน)
			packageItemRepo.save(new PackageItem(c2, houseFlower, 1));

			// =========================================================
			// 6.3 ทำบุญบ้าน : แพ็กเกจพรีเมียม 9 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c3, monkService, 9));

			packageItemRepo.save(new PackageItem(c3, placeService, 1));

			packageItemRepo.save(new PackageItem(c3, staffService, 1));

			packageItemRepo.save(new PackageItem(c3, mcService, 1));

			packageItemRepo.save(new PackageItem(c3, soundService, 1));

			packageItemRepo.save(new PackageItem(c3, chairService, 1));

			packageItemRepo.save(new PackageItem(c3, tableService, 1));

			packageItemRepo.save(new PackageItem(c3, monkSeat, 9));

			packageItemRepo.save(new PackageItem(c3, talapat, 9));

			packageItemRepo.save(new PackageItem(c3, flowerCone, 9));

			packageItemRepo.save(new PackageItem(c3, baiSri, 1));

			packageItemRepo.save(new PackageItem(c3, brassSet, 1));

			packageItemRepo.save(new PackageItem(c3, waterSet, 1));

			packageItemRepo.save(new PackageItem(c3, holyWater, 1));

			packageItemRepo.save(new PackageItem(c3, buddhaSet, 1));

			packageItemRepo.save(new PackageItem(c3, candle, 1));

			packageItemRepo.save(new PackageItem(c3, holyString, 1));

			packageItemRepo.save(new PackageItem(c3, worshipTable, 1));

			// ✅ เพิ่ม: พานพุ่มดอกไม้สดถวายพระ (ของเฉพาะงานทำบุญบ้าน)
			packageItemRepo.save(new PackageItem(c3, houseFlower, 1));

			// ✅ เพิ่ม: ของแถมระดับพรีเมียม (ให้เท่ากับพรีเมียมออฟฟิศ c9)
			packageItemRepo.save(new PackageItem(c3, photographer, 1));

			packageItemRepo.save(new PackageItem(c3, premiumFlower, 1));

			// =========================================================
			// 6.4 ขึ้นบ้านใหม่ : แพ็กเกจมาตรฐาน 5 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c4, monkService, 5));

			packageItemRepo.save(new PackageItem(c4, placeService, 1));

			packageItemRepo.save(new PackageItem(c4, staffService, 1));

			packageItemRepo.save(new PackageItem(c4, mcService, 1));

			packageItemRepo.save(new PackageItem(c4, soundService, 1));

			packageItemRepo.save(new PackageItem(c4, chairService, 1));

			packageItemRepo.save(new PackageItem(c4, tableService, 1));

			packageItemRepo.save(new PackageItem(c4, monkSeat, 5));

			packageItemRepo.save(new PackageItem(c4, talapat, 5));

			packageItemRepo.save(new PackageItem(c4, flowerCone, 5));

			packageItemRepo.save(new PackageItem(c4, teakTable, 1));

			packageItemRepo.save(new PackageItem(c4, buddha, 1));

			packageItemRepo.save(new PackageItem(c4, doorSet, 1));

			// =========================================================
			// 6.5 ขึ้นบ้านใหม่ : แพ็กเกจอิ่มบุญ 7 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c5, monkService, 7));

			packageItemRepo.save(new PackageItem(c5, placeService, 1));

			packageItemRepo.save(new PackageItem(c5, staffService, 1));

			packageItemRepo.save(new PackageItem(c5, mcService, 1));

			packageItemRepo.save(new PackageItem(c5, soundService, 1));

			packageItemRepo.save(new PackageItem(c5, chairService, 1));

			packageItemRepo.save(new PackageItem(c5, tableService, 1));

			packageItemRepo.save(new PackageItem(c5, monkSeat, 7));

			packageItemRepo.save(new PackageItem(c5, talapat, 7));

			packageItemRepo.save(new PackageItem(c5, flowerCone, 7));

			packageItemRepo.save(new PackageItem(c5, teakTable, 1));

			packageItemRepo.save(new PackageItem(c5, buddha, 1));

			packageItemRepo.save(new PackageItem(c5, doorSet, 1));

			// =========================================================
			// 6.6 ขึ้นบ้านใหม่ : แพ็กเกจพรีเมียม 9 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c6, monkService, 9));

			packageItemRepo.save(new PackageItem(c6, placeService, 1));

			packageItemRepo.save(new PackageItem(c6, staffService, 1));

			packageItemRepo.save(new PackageItem(c6, mcService, 1));

			packageItemRepo.save(new PackageItem(c6, soundService, 1));

			packageItemRepo.save(new PackageItem(c6, chairService, 1));

			packageItemRepo.save(new PackageItem(c6, tableService, 1));

			packageItemRepo.save(new PackageItem(c6, monkSeat, 9));

			packageItemRepo.save(new PackageItem(c6, talapat, 9));

			packageItemRepo.save(new PackageItem(c6, flowerCone, 9));

			packageItemRepo.save(new PackageItem(c6, teakTable, 1));

			packageItemRepo.save(new PackageItem(c6, buddha, 1));

			packageItemRepo.save(new PackageItem(c6, doorSet, 1));

			// ✅ เพิ่ม: ของแถมระดับพรีเมียม (ให้เท่ากับพรีเมียมออฟฟิศ c9)
			packageItemRepo.save(new PackageItem(c6, photographer, 1));

			packageItemRepo.save(new PackageItem(c6, premiumFlower, 1));

			// =========================================================
			// 6.7 ทำบุญออฟฟิศ : แพ็กเกจมาตรฐาน 5 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c7, monkService, 5));

			packageItemRepo.save(new PackageItem(c7, placeService, 1));

			packageItemRepo.save(new PackageItem(c7, staffService, 1));

			packageItemRepo.save(new PackageItem(c7, mcService, 1));

			packageItemRepo.save(new PackageItem(c7, soundService, 1));

			packageItemRepo.save(new PackageItem(c7, chairService, 1));

			packageItemRepo.save(new PackageItem(c7, tableService, 1));

			packageItemRepo.save(new PackageItem(c7, monkSeat, 5));

			packageItemRepo.save(new PackageItem(c7, talapat, 5));

			packageItemRepo.save(new PackageItem(c7, flowerCone, 5));

			packageItemRepo.save(new PackageItem(c7, openingSign, 1));

			packageItemRepo.save(new PackageItem(c7, moneyFlower, 1));

			packageItemRepo.save(new PackageItem(c7, officeTable, 1));

			packageItemRepo.save(new PackageItem(c7, ribbonSet, 1));

			// =========================================================
			// 6.8 ทำบุญออฟฟิศ : แพ็กเกจอิ่มบุญ 7 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c8, monkService, 7));

			packageItemRepo.save(new PackageItem(c8, placeService, 1));

			packageItemRepo.save(new PackageItem(c8, staffService, 1));

			packageItemRepo.save(new PackageItem(c8, mcService, 1));

			packageItemRepo.save(new PackageItem(c8, soundService, 1));

			packageItemRepo.save(new PackageItem(c8, chairService, 1));

			packageItemRepo.save(new PackageItem(c8, tableService, 1));

			packageItemRepo.save(new PackageItem(c8, monkSeat, 7));

			packageItemRepo.save(new PackageItem(c8, talapat, 7));

			packageItemRepo.save(new PackageItem(c8, flowerCone, 7));

			packageItemRepo.save(new PackageItem(c8, openingSign, 1));

			packageItemRepo.save(new PackageItem(c8, moneyFlower, 1));

			packageItemRepo.save(new PackageItem(c8, officeTable, 1));

			packageItemRepo.save(new PackageItem(c8, ribbonSet, 1));

			// =========================================================
			// 6.9 ทำบุญออฟฟิศ : แพ็กเกจพรีเมียม 9 พระ
			// =========================================================

			packageItemRepo.save(new PackageItem(c9, monkService, 9));

			packageItemRepo.save(new PackageItem(c9, placeService, 1));

			packageItemRepo.save(new PackageItem(c9, staffService, 1));

			packageItemRepo.save(new PackageItem(c9, mcService, 1));

			packageItemRepo.save(new PackageItem(c9, soundService, 1));

			packageItemRepo.save(new PackageItem(c9, chairService, 1));

			packageItemRepo.save(new PackageItem(c9, tableService, 1));

			packageItemRepo.save(new PackageItem(c9, monkSeat, 9));

			packageItemRepo.save(new PackageItem(c9, talapat, 9));

			packageItemRepo.save(new PackageItem(c9, flowerCone, 9));

			packageItemRepo.save(new PackageItem(c9, openingSign, 1));

			packageItemRepo.save(new PackageItem(c9, moneyFlower, 1));

			packageItemRepo.save(new PackageItem(c9, officeTable, 1));

			packageItemRepo.save(new PackageItem(c9, ribbonSet, 1));

			packageItemRepo.save(new PackageItem(c9, photographer, 1));

			packageItemRepo.save(new PackageItem(c9, premiumFlower, 1));

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

			for (Package c : Arrays.asList(c10, c11, c12)) {

				packageItemRepo.save(new PackageItem(c, placeService, 1));

				packageItemRepo.save(new PackageItem(c, staffService, 1));

				packageItemRepo.save(new PackageItem(c, mcService, 1));

				packageItemRepo.save(new PackageItem(c, soundService, 1));

				packageItemRepo.save(new PackageItem(c, chairService, 1));

				packageItemRepo.save(new PackageItem(c, tableService, 1));
			}

			// ---------------------------------------------------------
			// c10 : ทำบุญบ้าน
			// ---------------------------------------------------------

			packageItemRepo.save(new PackageItem(c10, baiSri, 1));

			packageItemRepo.save(new PackageItem(c10, brassSet, 1));

			packageItemRepo.save(new PackageItem(c10, waterSet, 1));

			packageItemRepo.save(new PackageItem(c10, holyWater, 1));

			packageItemRepo.save(new PackageItem(c10, buddhaSet, 1));

			packageItemRepo.save(new PackageItem(c10, candle, 1));

			packageItemRepo.save(new PackageItem(c10, holyString, 1));

			packageItemRepo.save(new PackageItem(c10, worshipTable, 1));

			packageItemRepo.save(new PackageItem(c10, houseFlower, 1));

			// ---------------------------------------------------------
			// c11 : ขึ้นบ้านใหม่
			// ---------------------------------------------------------

			packageItemRepo.save(new PackageItem(c11, teakTable, 1));

			packageItemRepo.save(new PackageItem(c11, buddha, 1));

			packageItemRepo.save(new PackageItem(c11, doorSet, 1));

			packageItemRepo.save(new PackageItem(c11, holyWater, 1));

			packageItemRepo.save(new PackageItem(c11, holyString, 1));

			packageItemRepo.save(new PackageItem(c11, candle, 1));

			// ---------------------------------------------------------
			// c12 : ทำบุญบริษัท / ออฟฟิศ
			// ---------------------------------------------------------

			packageItemRepo.save(new PackageItem(c12, openingSign, 1));

			packageItemRepo.save(new PackageItem(c12, moneyFlower, 1));

			packageItemRepo.save(new PackageItem(c12, officeTable, 1));

			packageItemRepo.save(new PackageItem(c12, ribbonSet, 1));

			// =========================================================
			// 6.11 สังฆทานมาตรฐาน 299
			// =========================================================

			// แพ็กเกจมาตรฐาน (5 พระ) -> สังฆทาน 5 ชุด
			List<Package> standardPackages = Arrays.asList(c1, c4, c7);
			for (Package c : standardPackages) {
				packageItemRepo.save(new PackageItem(c, sanghaStandard, 5));
			}

			// แพ็กเกจอิ่มบุญ (7 พระ) -> สังฆทาน 7 ชุด
			List<Package> fullMeritPackages = Arrays.asList(c2, c5, c8);
			for (Package c : fullMeritPackages) {
				packageItemRepo.save(new PackageItem(c, sanghaStandard, 7));
			}

			// แพ็กเกจพรีเมียม (9 พระ) -> สังฆทาน 9 ชุด
			List<Package> premiumPackages = Arrays.asList(c3, c6, c9);
			for (Package c : premiumPackages) {
				packageItemRepo.save(new PackageItem(c, sanghaStandard, 9));
			}

			// =========================================================
			// 7. QUESTIONS DETAIL
			// =========================================================
			//
			// Many-to-Many กับ Package
			// =========================================================

			QuestionsDetail q1 = new QuestionsDetail("รูปแบบการนิมนต์พระสงฆ์");

			QuestionsDetail q2 = new QuestionsDetail("จำนวนพระสงฆ์");

			QuestionsDetail q3 = new QuestionsDetail("รายละเอียดการนิมนต์พระสงฆ์");

			QuestionsDetail q4 = new QuestionsDetail("ต้องการชุดภัตตาหารปิ่นโตหรือไม่");

			QuestionsDetail q5 = new QuestionsDetail("เลือกชุดภัตตาหารปิ่นโต");

			QuestionsDetail q6 = new QuestionsDetail("จำนวนชุดภัตตาหารปิ่นโต");

			QuestionsDetail q7 = new QuestionsDetail("ต้องการสังฆทานหรือไม่");

			QuestionsDetail q8 = new QuestionsDetail("เลือกชุดสังฆทานที่ต้องการ");

			QuestionsDetail q9 = new QuestionsDetail("จำนวนชุดสังฆทาน");

			QuestionsDetail q11 = new QuestionsDetail("มีความต้องการเพิ่มเติมหรือไม่");

			List<QuestionsDetail> allQuestions = Arrays.asList(q1, q2, q3, q4, q5, q6, q7, q8, q9, q11);

			qRepo.saveAllAndFlush(allQuestions);

			// ---------------------------------------------------------
			// ผูกคำถามกับ Package ทุกตัว
			// ---------------------------------------------------------

			for (Package c : allPackages) {

				c.setQuestions(allQuestions);
			}

			packageRepo.saveAllAndFlush(allPackages);

			// =========================================================
			// 8. MEMBER
			// =========================================================

			memberRepo.saveAllAndFlush(Arrays.asList(

					new Member("บุญมี", "ลุงหลู่", "boonmee61@gmail.com", "12345678", "0812345678"),

					new Member("สุนีย์", "คำดี", "sunee85@gmail.com", "12345679", "0812345679"),

					new Member("ประเสริฐ", "สุขใจ", "prasert87@gmail.com", "12345680", "0812345680"),

					new Member("อารีย์", "บุญส่ง", "aree23@gmail.com", "12345681", "0812345681"),

					new Member("ธนพล", "ศรีสุข", "thanapon8@gmail.com", "12345682", "0812345682")));

			// =========================================================
			// SYSTEM READY
			// =========================================================

			System.out.println("\n>> --- [SYSTEM READY] DATA SEEDED SUCCESSFULLY ---");

		} catch (Exception e) {

			e.printStackTrace();

		}
	}
}