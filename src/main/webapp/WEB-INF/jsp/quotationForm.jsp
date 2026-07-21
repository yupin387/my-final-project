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
<title>จัดทำใบเสนอราคา - บุญมี รับจัดงานบุญ</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/quotationCreate.css?v=5">
</head>
<body>

	<%-- ===== NAVBAR ===== --%>
	<nav class="navbar">
		<a class="navbar-brand"
			href="${pageContext.request.contextPath}/organizer/bookings"> <img
			src="${pageContext.request.contextPath}/static/images/logoo.png"
			alt="บุญมี รับจัดงานบุญ" class="lotus-icon"> <span
			class="navbar-title">บุญมี รับจัดงานบุญ</span>
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
				<%-- แสดงชื่อรูปแบบการจองที่ลูกค้าเลือกไว้ตอนจอง ดึงมาจาก b.ceremony ตรง ๆ
                 ไม่ต้องมี dropdown ให้เลือกซ้ำ เพราะพิธี+รูปแบบถูกกำหนดตั้งแต่ตอนจองแล้ว --%>
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

							<%-- ===================================================================
                             หมวดแพ็กเกจหลัก / รูปแบบการจอง
                             - กรณีแพ็กเกจจริง (มาตรฐาน/อิ่มบุญ/พรีเมียม): แสดงเป็นก้อนเดียว
                               ราคาตาม basePrice พร้อมรายการที่รวมอยู่แล้ว (ดู Run.java ส่วน A)
                               บริการนิมนต์พระรวมอยู่ใน basePrice ของแพ็กเกจอยู่แล้ว จึงไม่ต้อง
                               ดึง "บริการประสานงานนิมนต์พระ" มาคิดแยกอีก
                             - กรณี "กรอกความต้องการเบื้องต้น": ไม่มีของแถมฟรี ไม่มีราคาตายตัว
                               ผู้จัดงานต้องเลือกอุปกรณ์/บริการทั้งหมดเองผ่านป๊อปอัพด้านล่าง
                               ยกเว้น "บริการประสานงานนิมนต์พระ" ที่ระบบดึงจำนวนพระมาให้อัตโนมัติ
                               (ดูหมวดบริการด้านล่าง) เมื่อลูกค้าเลือก "ให้ทางร้านนิมนต์"
                             =================================================================== --%>
							<%-- เช็คก่อนว่าลูกค้าเลือกรูปแบบการนิมนต์แบบไหน และจำนวนพระเท่าไหร่
                             ข้อมูลนี้เป็นแค่ "รายละเอียด" แสดงในกล่องด้านบน ไม่ใช่รายการคิดเงินแยก
                             เพราะบริการนิมนต์พระรวมอยู่ใน basePrice ของแพ็กเกจอยู่แล้ว (กรณีแพ็กเกจจริง) --%>
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
									<%-- ===== กรณีแพ็กเกจจริง: แสดงแถวราคาแพ็กเกจตายตัว ===== --%>
									<c:when test="${!isCustomRequest}">
										<tr class="static-row">
											<td class="row-number" style="text-align: center;">1</td>
											<td><span class="item-name">${b.ceremony.ceremonyName}</span>
												<c:if test="${not empty b.ceremony.ceremonyDetail}">
													<span class="item-desc">${b.ceremony.ceremonyDetail}</span>
												</c:if> <c:if test="${not empty monkCount}">
													<span class="item-desc"
														style="display: block; margin-top: 4px;">
														นิมนต์พระสงฆ์ ${monkCount} รูป <c:if
															test="${fn:contains(monkInviteType,'นิมนต์เอง')}">
															<span style="color: #c0392b; font-weight: 600;">
																(ลูกค้านิมนต์เอง)</span>
														</c:if>
													</span>
												</c:if> <c:if test="${not empty packageIncludedItems}">
													<div class="item-desc" style="margin-top: 6px;">
														<c:forEach var="pkgItem" items="${packageIncludedItems}">
                                                        - ${pkgItem.itemName}<br />
														</c:forEach>
													</div>
												</c:if>
												<%-- ชื่อนี้ต้องตรงกับ Item ที่มีอยู่จริงในฐานข้อมูล (itemName = ceremonyName)
                                             ไม่งั้น service จะหาไม่เจอแล้วข้ามแถวนี้ไปเงียบ ๆ --%>
												<input type="hidden" name="bookingItemNames"
												value="${b.ceremony.ceremonyName}"></td>
											<td><input type="number" name="bookingQtys" value="1"
												min="1" class="qty-input" readonly
												style="text-align: center; background: #f4f4f4;"></td>
											<td style="text-align: center;">แพ็กเกจ</td>
											<td><input type="number" name="bookingPrices"
												value="${b.ceremony.basePrice}" step="0.01" min="0"
												class="price-input" style="text-align: right;"
												onchange="calculateGrandTotal()"></td>
											<td style="text-align: right;" class="amount-cell"><span
												class="subtotal">0.00</span></td>
											<td><input type="text" name="detailNotes"
												class="note-input" placeholder="หมายเหตุ"></td>
											<td style="text-align: center;">-</td>
										</tr>
									</c:when>

									<%-- ===== กรณีกรอกความต้องการเบื้องต้น: ไม่มีของแถมฟรี ไม่มีแถวราคาตายตัว
                                         แสดงแค่คำอธิบาย ผู้จัดงานต้องเลือกทุกอย่างเองผ่านป๊อปอัพ ===== --%>
									<c:otherwise>
										<tr class="static-row">
											<td class="row-number" style="text-align: center;"></td>
											<td colspan="7">
												<span class="item-name">${b.ceremony.ceremonyName}</span>
												<c:if test="${not empty b.ceremony.ceremonyDetail}">
													<span class="item-desc">${b.ceremony.ceremonyDetail}</span>
												</c:if>
												<c:if test="${not empty monkCount}">
													<span class="item-desc"
														style="display: block; margin-top: 4px;">
														นิมนต์พระสงฆ์ ${monkCount} รูป <c:if
															test="${fn:contains(monkInviteType,'นิมนต์เอง')}">
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

							<%-- หมวดอุปกรณ์พิธีกรรม
                             (เพิ่มใหม่: เดิมไม่มี tbody id="group-equipment" ทำให้ JS หา container ไม่เจอ
                              เวลาเลือกรายการหมวด "อุปกรณ์" จาก popup แล้วกดตกลง จะ error เงียบ ๆ และไม่เพิ่มแถวเข้าตาราง) --%>
							<tbody id="group-equipment">
								<tr class="group-row">
									<td colspan="8">หมวดอุปกรณ์พิธีกรรม</td>
								</tr>
							</tbody>

							<%-- หมวดภัตตาหารปิ่นโต --%>
							<tbody id="group-food">
								<tr class="group-row">
									<td colspan="8">หมวดภัตตาหารปิ่นโต</td>
								</tr>
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

							<%-- หมวดสังฆทาน --%>
							<tbody id="group-sangkathan">
								<tr class="group-row">
									<td colspan="8">หมวดสังฆทาน</td>
								</tr>
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

							<%-- หมวดบริการและการดำเนินการ (รวมถึงบริการนิมนต์พระสงฆ์)
                             FIX: ดึง "บริการประสานงานนิมนต์พระ" มาใส่ในตารางให้อัตโนมัติ
                             เฉพาะกรณี "กรอกความต้องการเบื้องต้น" (isCustomRequest) เท่านั้น
                             เพราะกรณีแพ็กเกจจริง บริการนี้รวมอยู่ใน basePrice ของแพ็กเกจอยู่แล้ว
                             ไม่ต้องคิดแยกซ้ำ (ดู tbody id="group-package" ด้านบน)
                             เงื่อนไข:
                               1) isCustomRequest ต้องเป็น true (กรอกเองเท่านั้น)
                               2) monkInviteType ต้องไม่ใช่ "นิมนต์เอง" (ลูกค้าให้ร้านนิมนต์ให้)
                               3) monkCount ต้องมีค่า (มีจำนวนพระที่กรอกไว้จริง)
                             จำนวน (bookingQtys) = จำนวนพระที่ลูกค้ากรอกไว้ตอนจอง (monkCount)
                             เหมือน pattern ของหมวดปิ่นโต/สังฆทานด้านบนที่ดึง qty จาก b.details --%>
							<tbody id="group-service">
								<tr class="group-row">
									<td colspan="8">หมวดบริการและการดำเนินการ</td>
								</tr>
								<c:if
									test="${isCustomRequest && not fn:contains(monkInviteType,'นิมนต์เอง') && not empty monkCount}">
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
					alt="บุญมี รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
				<span class="footer-brand-text">บุญมี รับจัดงานบุญ</span>
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
