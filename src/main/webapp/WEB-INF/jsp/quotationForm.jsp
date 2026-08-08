<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>จัดทำใบเสนอราคา - บุญมีนำพา จัดงานบุญ</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/quotationCreate.css?v=7">
</head>
<body>

	<%-- ===== NAVBAR ===== --%>
	<nav class="navbar">
		<a class="navbar-brand"
			href="${pageContext.request.contextPath}/organizer/bookings"> <img
			src="${pageContext.request.contextPath}/static/images/logoo.png"
			alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon"> <span
			class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
		</a>
		<div class="navbar-right">
			<nav class="navbar-menu">
				<a href="${pageContext.request.contextPath}/organizer/bookings"
					class="nav-item">รายการจอง</a> <a
					href="${pageContext.request.contextPath}/organizer/head-staff"
					class="nav-item">หัวหน้างาน</a> <a
					href="${pageContext.request.contextPath}/organizer/questions"
					class="nav-item">จัดการพิธี</a> <a
					href="${pageContext.request.contextPath}/organizer/quotation"
					class="nav-item active">ใบเสนอราคา</a>
			</nav>
			<div class="user-info" onclick="toggleDropdown()">
				<div class="user-avatar">A</div>
				<div class="user-detail">
					<span class="user-name">Admin Organizer</span> <span
						class="user-role">ผู้จัดการ</span>
				</div>
				<span class="arrow">▾</span>
				<div class="dropdown-menu" id="dropdownMenu">
					<a href="${pageContext.request.contextPath}/organizer/logout"
						class="dropdown-item">ออกจากระบบ</a>
				</div>
			</div>
		</div>
	</nav>



	<div class="page-wrapper">

		<%-- Page Title --%>
		<div class="page-title-row">
			<div class="section-ornament">
				<div class="ornament-line"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-diamond"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-line right"></div>
			</div>
			<h1>จัดทำใบเสนอราคา</h1>
			<div class="gold-line"></div>
			<p>ตรวจสอบจำนวนพระสงฆ์
				และเลือกวัสดุอุปกรณ์เสริมตามความเหมาะสมของงาน</p>
		</div>

		<%-- INFO CARD --%>
		<div class="info-card">
			<div class="info-grid">
				<div class="info-box">
					<span class="info-label">รหัสการจอง</span> <span
						class="info-value highlight">${b.bookingId}</span>
				</div>
				<div class="info-box">
					<span class="info-label">ประเภทพิธี</span> <span class="info-value">${b.ceremony.ceremonyType}</span>
				</div>
				<div class="info-box">
					<span class="info-label">รูปแบบการจอง</span> <span
						class="info-value">${b.ceremony.ceremonyName}</span>
				</div>
				<div class="info-box">
					<span class="info-label">ลูกค้า</span> <span class="info-value">${b.member.memberFirstName}
						${b.member.memberLastName}</span>
				</div>
				<div class="info-box">
					<span class="info-label">วันที่จัดงาน</span> <span
						class="info-value"><fmt:formatDate value="${b.eventDate}"
							pattern="dd/MM/yyyy" /></span>
				</div>
				<div class="info-box">
					<span class="info-label">เวลา</span> <span class="info-value">${b.eventTime}
						น.</span>
				</div>
			</div>
		</div>

		<%-- FORM --%>
		<form id="quotationForm"
			action="${pageContext.request.contextPath}/organizer/quotation/save"
			method="post" onsubmit="return validateForm()">

			<input type="hidden" name="bookingId" value="${b.bookingId}">

			<div class="main-layout">
				<div class="card">
					<div class="card-header">รายการสรุปค่าใช้จ่ายวัสดุและงานบริการ</div>
					<div class="card-body">

						<table id="mainQuotationTable">
							<colgroup>
								<col class="col-no">
								<col class="col-item">
								<col class="col-qty">
								<col class="col-unit">
								<col class="col-price">
								<col class="col-total">
								<col class="col-note">
								<col class="col-del">
							</colgroup>
							<thead>
								<tr>
									<th style="text-align: center;">ลำดับ</th>
									<th>รายการ</th>
									<th style="text-align: center;">จำนวน</th>
									<th style="text-align: center;">หน่วย</th>
									<th style="text-align: right;">ราคา/หน่วย</th>
									<th style="text-align: right;">รวมเงิน (฿)</th>
									<th>หมายเหตุ</th>
									<th style="text-align: center;">ลบ</th>
								</tr>
							</thead>

							<%-- เช็คก่อนว่าลูกค้าเลือกรูปแบบการนิมนต์แบบไหน และจำนวนพระเท่าไหร่ --%>
							<c:set var="monkInviteType" value="" />
							<c:set var="monkCount" value="" />
							<c:forEach var="d" items="${b.details}">
								<c:if
									test="${fn:contains(d.question.questionsText,'รูปแบบการนิมนต์')}">
									<c:set var="monkInviteType" value="${d.answer}" />
								</c:if>
								<c:if test="${fn:contains(d.question.questionsText,'จำนวนพระ')}">
									<c:set var="monkCount" value="${d.answer}" />
								</c:if>
							</c:forEach>

							<c:set var="monkSelfInviteDiscount" value="${1500}" />
							<c:set var="isMonkSelfInvite"
								value="${fn:contains(monkInviteType,'นิมนต์เอง')}" />

							<c:choose>
								<c:when test="${!isCustomRequest && isMonkSelfInvite}">
									<c:set var="packageDisplayPrice"
										value="${b.ceremony.basePrice - monkSelfInviteDiscount}" />
								</c:when>
								<c:otherwise>
									<c:set var="packageDisplayPrice" value="${b.ceremony.basePrice}" />
								</c:otherwise>
							</c:choose>

							<%-- ===================================================================
							     เช็คว่าอุปกรณ์แต่ละชิ้นในแพ็กเกจ (packageIncludedItems) "คูณตาม
							     จำนวนพระ" หรือไม่ เนื่องจากตอนนี้ยังไม่มี field ในฐานข้อมูลระบุเรื่องนี้
							     โดยตรง (itemceremony เป็น join table เปล่า ๆ ไม่มี quantity) จึงใช้
							     คีย์เวิร์ด "ต่อรูป" ในชื่อ/รายละเอียดอุปกรณ์เป็นตัวเช็คแทนไปก่อน
							     -> ถ้าอุปกรณ์ชิ้นไหนควรคูณตามจำนวนพระ ให้ตั้งชื่อ/รายละเอียดมีคำว่า
							        "ต่อรูป" อยู่ด้วย (เช่น "ผ้าไตร (ต่อรูป)") ไม่งั้นระบบจะใส่จำนวน = 1
							     -> ถ้าต้องการ field แยกจริง ๆ ในอนาคต ควรเพิ่ม column เช่น
							        scalesbymonk (boolean) ในตาราง itemceremony แล้วมาแก้จุดนี้แทน
							     =================================================================== --%>

							<%-- อุปกรณ์ที่รวมในแพ็กเกจ ตอนนี้แสดงต่อจากแถวราคาแพ็กเกจใน group-package
							     เลย (ไม่แยกหัวข้อหมวดอุปกรณ์อีกต่อไปเมื่อเลือกแพ็กเกจ) --%>
							<c:set var="hasPackageEquip"
								value="${!isCustomRequest && not empty packageIncludedItems}" />

							<tbody id="group-package">
								<tr class="group-row">
									<td colspan="8">
										<c:choose>
											<c:when test="${isCustomRequest}">
												รูปแบบการจอง: ${b.ceremony.ceremonyType} (กรอกความต้องการเบื้องต้น
												— ยังไม่ได้เลือกแพ็กเกจ กรุณาเลือกอุปกรณ์/บริการทั้งหมดด้านล่าง)
											</c:when>
											<c:otherwise>
												แพ็กเกจ: ${b.ceremony.ceremonyType} (${b.ceremony.ceremonyName})
											</c:otherwise>
										</c:choose>
									</td>
								</tr>

								<c:choose>
									<%-- ===== กรณีแพ็กเกจจริง: แสดงแถวราคาแพ็กเกจตายตัว (ล็อกจำนวน = 1 เสมอ) ===== --%>
									<c:when test="${!isCustomRequest}">
										<tr class="static-row no-qty-convert">
											<td class="row-number" style="text-align: center;">1</td>
											<td><span class="item-name">${b.ceremony.ceremonyName}</span>
												<c:if test="${not empty b.ceremony.ceremonyDetail}">
													<span class="item-desc">${b.ceremony.ceremonyDetail}</span>
												</c:if> <c:if test="${not empty monkCount}">
													<span class="item-desc"
														style="display: block; margin-top: 4px;">
														นิมนต์พระสงฆ์ ${monkCount} รูป <c:if
															test="${isMonkSelfInvite}">
															<span style="color: #c0392b; font-weight: 600;">
																(ลูกค้านิมนต์เอง)</span>
														</c:if>
													</span>
												</c:if> <c:if test="${isMonkSelfInvite}">
													<span class="item-desc"
														style="color: #c0392b; display: block; margin-top: 4px;">
														* ราคานี้หักส่วนลด
														<fmt:formatNumber value="${monkSelfInviteDiscount}"
															minFractionDigits="0" /> บาท
														เนื่องจากลูกค้านิมนต์พระสงฆ์เอง
													</span>
												</c:if>
												<%-- หมายเหตุ: อุปกรณ์ที่รวมในแพ็กเกจแสดงเป็นแถวจริงต่อจากแถวนี้
												     ด้านล่างเลย (ดู packageIncludedItems loop) ไม่ต้อง list
												     ชื่อซ้ำเป็น bullet text ตรงนี้ --%>
												<input type="hidden" name="bookingItemNames"
												value="${b.ceremony.ceremonyName}"></td>
											<td><input type="number" name="bookingQtys" value="1" min="1"
       class="qty-input" readonly style="text-align: center; background: #f4f4f4;"></td>
											<td style="text-align: center;">แพ็กเกจ</td>
											<td><input type="number" name="bookingPrices"
												value="${packageDisplayPrice}" step="0.01" min="0"
												class="price-input" style="text-align: right;"
												onchange="calculateGrandTotal()"></td>
											<td style="text-align: right;" class="amount-cell"><span
												class="subtotal">0.00</span></td>
											<td><input type="text" name="detailNotes"
												class="note-input" placeholder="หมายเหตุ"></td>
											<td style="text-align: center;">-</td>
										</tr>

										<%-- ✅ อุปกรณ์ที่รวมในแพ็กเกจ ย้ายมาอยู่ต่อจากแถวแพ็กเกจตรงนี้เลย
										     ไม่แยกเป็นหมวด "อุปกรณ์พิธีกรรม" อีกต่อไปเมื่อเลือกแพ็กเกจ --%>
										<c:if test="${hasPackageEquip}">
											<c:forEach var="pkgItem" items="${packageIncludedItems}">
												<c:set var="pkgItemQty" value="1" />
												<c:if
													test="${(not empty pkgItem.itemDetail && fn:contains(pkgItem.itemDetail,'ต่อรูป')) || fn:contains(pkgItem.itemName,'ต่อรูป')}">
													<c:set var="pkgItemQty" value="${monkCount}" />
												</c:if>
												<tr class="static-row no-qty-convert package-included-row">
													<td class="row-number no-index" style="text-align: center;"></td>
													<td><span class="item-name">${pkgItem.itemName}</span>
														<c:if test="${not empty pkgItem.itemDetail}">
															<span class="item-desc">${pkgItem.itemDetail}</span>
														</c:if></td>
													<td><input type="number" value="${pkgItemQty}"
														class="qty-input" readonly disabled
														style="text-align: center;"></td>
													<td style="text-align: center;">${pkgItem.unit}</td>
													<td style="text-align: center;"><span
														class="package-included-label">รวมในแพ็กเกจ</span></td>
													<td style="text-align: right;">-</td>
													<td><span class="item-desc">-</span></td>
													<td style="text-align: center;">-</td>
												</tr>
											</c:forEach>
										</c:if>
									</c:when>

									<%-- ===== กรณีกรอกความต้องการเบื้องต้น: ไม่มีของแถมฟรี ไม่มีแถวราคาตายตัว ===== --%>
									<c:otherwise>
										<tr class="static-row no-qty-convert">
											<td class="row-number no-index" style="text-align: center;"></td>
											<td colspan="7">
												<span class="item-name">${b.ceremony.ceremonyName}</span>
												<c:if test="${not empty b.ceremony.ceremonyDetail}">
													<span class="item-desc">${b.ceremony.ceremonyDetail}</span>
												</c:if>
												<c:if test="${not empty monkCount}">
													<span class="item-desc"
														style="display: block; margin-top: 4px;">
														นิมนต์พระสงฆ์ ${monkCount} รูป <c:if
															test="${isMonkSelfInvite}">
															<span style="color: #c0392b; font-weight: 600;">
																(ลูกค้านิมนต์เอง)</span>
														</c:if>
													</span>
												</c:if>
												<div class="item-desc" style="margin-top: 6px; color: #c0392b;">
													* งานนี้ไม่มีแพ็กเกจตายตัว กรุณากดปุ่ม
													"เลือกรายการวัสดุอุปกรณ์เสริม" ด้านล่างเพื่อเพิ่มรายการ
													อุปกรณ์ ภัตตาหาร สังฆทาน และบริการทั้งหมดที่ต้องใช้ในงานนี้
												</div>
											</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>

							<%-- หมวดอุปกรณ์พิธีกรรม (เสริม)
							     ตอนนี้ใช้เก็บเฉพาะอุปกรณ์ที่ผู้จัดงานเพิ่มเองผ่านป๊อปอัพเท่านั้น
							     (อุปกรณ์ที่รวมในแพ็กเกจย้ายไปแสดงใน group-package ด้านบนแล้ว)
							     หัวข้อของหมวดนี้จะถูกสร้างขึ้นเองโดย JS (ensureGroupHeader) เมื่อมี
							     การเพิ่มรายการเข้ามาเท่านั้น จึงปล่อย tbody นี้ว่างไว้ตอนโหลดหน้าแรก --%>
							<tbody id="group-equipment"></tbody>

							<%-- หมวดภัตตาหารปิ่นโต (ไม่แตะ — ดึงจาก bookingform ที่ลูกค้ากรอกไว้เหมือนเดิม) --%>
							<c:set var="hasFoodItems" value="false" />
							<c:forEach var="detail" items="${validDetails}">
								<c:if
									test="${fn:contains(detail.question.questionsText,'ภัตตาหาร') && fn:contains(detail.question.questionsText,'เลือก')}">
									<c:set var="selectedFoodName"
										value="${fn:trim(detail.answer)}" />
									<c:forEach var="item" items="${items}">
										<c:if test="${fn:trim(item.itemName) eq selectedFoodName}">
											<c:set var="hasFoodItems" value="true" />
										</c:if>
									</c:forEach>
								</c:if>
							</c:forEach>
							<tbody id="group-food">
								<c:if test="${hasFoodItems}">
									<tr class="group-row">
										<td colspan="8">หมวดภัตตาหารปิ่นโต</td>
									</tr>
								</c:if>
								<c:set var="foodQty" value="1" />
								<c:forEach var="d" items="${b.details}">
									<c:if
										test="${fn:contains(d.question.questionsText,'ภัตตาหาร') && fn:contains(d.question.questionsText,'จำนวน')}">
										<c:if test="${not empty d.answer && d.answer != '0'}">
											<c:set var="foodQty" value="${d.answer}" />
										</c:if>
									</c:if>
								</c:forEach>
								<c:forEach var="detail" items="${validDetails}">
									<c:if
										test="${fn:contains(detail.question.questionsText,'ภัตตาหาร') && fn:contains(detail.question.questionsText,'เลือก')}">
										<c:set var="selectedFoodName"
											value="${fn:trim(detail.answer)}" />
										<c:forEach var="item" items="${items}">
											<c:if test="${fn:trim(item.itemName) eq selectedFoodName}">
												<tr class="static-row">
													<td class="row-number" style="text-align: center;"></td>
													<td><span class="item-name">${item.itemName}</span> <c:if
															test="${not empty item.itemDetail}">
															<span class="item-desc">${item.itemDetail}</span>
														</c:if> <input type="hidden" name="bookingItemNames"
														value="${item.itemName}"></td>
													<td><input type="number" name="bookingQtys"
														value="${foodQty}" min="1" class="qty-input"
														style="text-align: center;"
														onchange="calculateGrandTotal()"></td>
													<td style="text-align: center;">${item.unit}</td>
													<td><input type="number" name="bookingPrices"
														value="${item.pricePerUnit}" step="0.01" min="0"
														class="price-input" style="text-align: right;"
														onchange="calculateGrandTotal()"></td>
													<td style="text-align: right;" class="amount-cell"><span
														class="subtotal">0.00</span></td>
													<td><input type="text" name="detailNotes"
														class="note-input" placeholder="หมายเหตุ"></td>
													<td style="text-align: center;">
														<button type="button" class="btn-remove"
															onclick="removeRow(this)">✕</button>
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
							</tbody>

							<%-- หมวดสังฆทาน (ไม่แตะ — ดึงจาก bookingform ที่ลูกค้ากรอกไว้เหมือนเดิม) --%>
							<c:set var="hasSangkathanItems" value="false" />
							<c:forEach var="detail" items="${validDetails}">
								<c:if
									test="${fn:contains(detail.question.questionsText,'สังฆทาน') && fn:contains(detail.question.questionsText,'เลือก')}">
									<c:set var="selectedSangNameCheck"
										value="${fn:trim(detail.answer)}" />
									<c:forEach var="item" items="${items}">
										<c:if test="${fn:trim(item.itemName) eq selectedSangNameCheck}">
											<c:set var="hasSangkathanItems" value="true" />
										</c:if>
									</c:forEach>
								</c:if>
							</c:forEach>
							<tbody id="group-sangkathan">
								<c:if test="${hasSangkathanItems}">
									<tr class="group-row">
										<td colspan="8">หมวดสังฆทาน</td>
									</tr>
								</c:if>
								<c:set var="sangQty" value="1" />
								<c:forEach var="d" items="${b.details}">
									<c:if
										test="${fn:contains(d.question.questionsText,'สังฆทาน') && fn:contains(d.question.questionsText,'จำนวน')}">
										<c:if test="${not empty d.answer && d.answer != '0'}">
											<c:set var="sangQty" value="${d.answer}" />
										</c:if>
									</c:if>
								</c:forEach>
								<c:forEach var="detail" items="${validDetails}">
									<c:if
										test="${fn:contains(detail.question.questionsText,'สังฆทาน') && fn:contains(detail.question.questionsText,'เลือก')}">
										<c:set var="selectedSangName"
											value="${fn:trim(detail.answer)}" />
										<c:forEach var="item" items="${items}">
											<c:if test="${fn:trim(item.itemName) eq selectedSangName}">
												<tr class="static-row">
													<td class="row-number" style="text-align: center;"></td>
													<td><span class="item-name">${item.itemName}</span> <c:if
															test="${not empty item.itemDetail}">
															<span class="item-desc">${item.itemDetail}</span>
														</c:if> <input type="hidden" name="bookingItemNames"
														value="${item.itemName}"></td>
													<td><input type="number" name="bookingQtys"
														value="${sangQty}" min="1" class="qty-input"
														style="text-align: center;"
														onchange="calculateGrandTotal()"></td>
													<td style="text-align: center;">${item.unit}</td>
													<td><input type="number" name="bookingPrices"
														value="${item.pricePerUnit}" step="0.01" min="0"
														class="price-input" style="text-align: right;"
														onchange="calculateGrandTotal()"></td>
													<td style="text-align: right;" class="amount-cell"><span
														class="subtotal">0.00</span></td>
													<td><input type="text" name="detailNotes"
														class="note-input" placeholder="หมายเหตุ"></td>
													<td style="text-align: center;">
														<button type="button" class="btn-remove"
															onclick="removeRow(this)">✕</button>
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
							</tbody>

							<%-- หมวดบริการและการดำเนินการ (รวมถึงบริการนิมนต์พระสงฆ์) --%>
							<tbody id="group-service">
								<c:if
									test="${isCustomRequest && not isMonkSelfInvite && not empty monkCount}">
									<tr class="group-row">
										<td colspan="8">หมวดบริการและการดำเนินการ</td>
									</tr>
									<c:forEach var="item" items="${items}">
										<c:if
											test="${fn:trim(item.itemName) eq 'บริการประสานงานนิมนต์พระ'}">
											<tr class="static-row">
												<td class="row-number" style="text-align: center;"></td>
												<td><span class="item-name">${item.itemName}</span> <c:if
														test="${not empty item.itemDetail}">
														<span class="item-desc">${item.itemDetail}</span>
													</c:if> <input type="hidden" name="bookingItemNames"
													value="${item.itemName}"></td>
												<td><input type="number" name="bookingQtys"
													value="${monkCount}" min="1" class="qty-input"
													style="text-align: center;"
													onchange="calculateGrandTotal()"></td>
												<td style="text-align: center;">${item.unit}</td>
												<td><input type="number" name="bookingPrices"
													value="${item.pricePerUnit}" step="0.01" min="0"
													class="price-input" style="text-align: right;"
													onchange="calculateGrandTotal()"></td>
												<td style="text-align: right;" class="amount-cell"><span
													class="subtotal">0.00</span></td>
												<td><input type="text" name="detailNotes"
													class="note-input" placeholder="หมายเหตุ"></td>
												<td style="text-align: center;">
													<button type="button" class="btn-remove"
														onclick="removeRow(this)">✕</button>
												</td>
											</tr>
										</c:if>
									</c:forEach>
								</c:if>
							</tbody>

						</table>

						<%-- ============================================================
						     FIX: กล่องแสดง "ความต้องการเพิ่มเติม" ที่ลูกค้ากรอกไว้ตอนจอง
						     (freetext เช่น "ต้องการเก้าอี้เพิ่ม 10 ตัว") ดึงมาจาก
						     QuotationController -> extractAdditionalNote() ผ่าน
						     model attribute "additionalNote"
						     หมายเหตุ: เป็นข้อมูลอ้างอิงให้ผู้จัดงานอ่านเฉยๆ ไม่ auto-fill
						     ราคา/จำนวนให้ เพราะเป็นข้อความอิสระ จับคู่กับชื่อ item ในระบบ
						     ไม่ได้ตรงๆ เหมือนสังฆทาน/ปิ่นโตที่เป็นการเลือกจากรายการที่มีอยู่แล้ว
						     ผู้จัดงานต้องอ่านแล้วไปกดปุ่ม "เลือกรายการวัสดุอุปกรณ์เสริม"
						     ด้านล่างเพื่อเพิ่มรายการ/ราคาที่ตรงกับความต้องการนี้เอง
						     ============================================================ --%>
						<c:if test="${not empty additionalNote}">
							<div class="additional-note-box"
								style="margin: 16px 0; padding: 14px 16px; background: #FFF7E6;
                                       border: 1px solid #E0C089; border-radius: 8px;">
								<div style="font-weight: 600; color: #8A5A00; margin-bottom: 6px;">
									📝 ความต้องการเพิ่มเติมที่ลูกค้ากรอกไว้ตอนจอง
								</div>
								<div style="white-space: pre-wrap; color: #5c4300; font-size: 14px;">${additionalNote}</div>
								<div style="font-size: 12px; color: #B0345A; margin-top: 8px;">
									* ข้อความนี้เป็นข้อมูลอ้างอิงเท่านั้น กรุณากดปุ่ม
									"เลือกรายการวัสดุอุปกรณ์เสริม" ด้านล่างเพื่อเพิ่มรายการและราคา
									ที่ตรงกับความต้องการนี้เข้าสู่ใบเสนอราคาด้วยตนเอง
								</div>
							</div>
						</c:if>

						<button type="button" class="btn-open-popup"
							onclick="openItemModal()">
							<span>＋</span> เลือกรายการวัสดุอุปกรณ์เสริม
						</button>

					</div>
				</div>
			</div>
		</form>
	</div>

	<%-- ===== FOOTER ===== --%>
	<footer class="site-footer">
		<div class="footer-content">
			<div class="footer-brand">
				<img
					src="${pageContext.request.contextPath}/static/images/logoo.png"
					alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
				<span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
			</div>
			<p class="footer-tagline">ระบบจัดการงานบุญสำหรับทีมงานและผู้ดูแลระบบ</p>
		</div>

	</footer>

	<%-- STICKY TOTAL BAR --%>
	<div class="total-bar">
		<div class="total-bar-inner">
			<div class="total-bar-meta">
				<span class="total-bar-label">ยอดรวมสุทธิทั้งสิ้น</span>
			</div>
			<div class="total-bar-amount">
				฿ <span id="grandTotal">0.00</span>
			</div>
			<button type="submit" form="quotationForm" class="btn-submit">
				บันทึกใบเสนอราคา</button>
		</div>
	</div>

	<%-- ITEM DATA STORE (เฉพาะรายการเสริมที่เลือกเพิ่มได้จริง ไม่รวมของที่ผูกกับทุกแพ็กเกจอยู่แล้ว) --%>
	<div id="itemDataStore" style="display: none;">
		<c:forEach var="item" items="${extraSelectableItems}">
			<div class="item-data" data-id="${item.itemId}"
				data-name="${item.itemName}" data-detail="${item.itemDetail}"
				data-unit="${item.unit}" data-price="${item.pricePerUnit}"
				data-type="${item.itemType.itemTypeName}"></div>
		</c:forEach>
	</div>

	<%-- ITEM SELECTION MODAL --%>
	<div id="itemSelectionModal" class="modal-overlay">
		<div class="modal-card">
			<div class="modal-header">
				<h3>เลือกอุปกรณ์และบริการเสริมสำหรับจัดงานบุญ</h3>
				<button type="button" class="close-btn" onclick="closeItemModal()">✕</button>
			</div>
			<div class="category-tabs">
				<button type="button" class="category-tab active"
					data-category="all" onclick="switchCategoryTab(this,'all')">ทั้งหมด</button>
				<button type="button" class="category-tab" data-category="อุปกรณ์"
					onclick="switchCategoryTab(this,'อุปกรณ์')">อุปกรณ์พิธีกรรม</button>
				<button type="button" class="category-tab" data-category="ภัตตาหาร"
					onclick="switchCategoryTab(this,'ภัตตาหาร')">ภัตตาหารปิ่นโต</button>
				<button type="button" class="category-tab" data-category="สังฆทาน"
					onclick="switchCategoryTab(this,'สังฆทาน')">สังฆทาน</button>
				<button type="button" class="category-tab" data-category="บริการ"
					onclick="switchCategoryTab(this,'บริการ')">บริการและดำเนินการ</button>
			</div>
			<div class="modal-body">
				<div class="picker-toolbar">
					<label class="select-all-label"> <input type="checkbox"
						id="selectAllVisible" onchange="toggleSelectAllVisible(this)">
						เลือกทั้งหมดทุกหมวด
					</label>
					<span class="selected-count-badge">เลือกแล้ว <span
						id="selectedCount">0</span> รายการ</span>
				</div>
				<div class="item-picker-grid" id="itemPickerGrid"></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn-cancel-modal"
					onclick="closeItemModal()">ยกเลิก</button>
				<button type="button" class="btn-submit-modal"
					onclick="addSelectedItemsToTable()">ตกลงเพิ่มรายการที่เลือก</button>
			</div>
		</div>
	</div>

	<script
		src="${pageContext.request.contextPath}/static/js/quotationCreate.js"></script>

</body>
</html>
