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
<title>จัดทำใบเสนอราคา - ระบบรับจัดงานบุญ</title>
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/quotationCreate.css">
</head>
<body>

	<%-- ===== NAVBAR ===== --%>
	<div class="navbar">
		<span class="navbar-title">ระบบรับจัดงานบุญ</span>
		<div class="navbar-right">
			<nav class="navbar-menu">
				<a href="${pageContext.request.contextPath}/organizer/bookings"
					class="nav-item">รายการจอง</a>
				<a href="${pageContext.request.contextPath}/organizer/head-staff"
					class="nav-item">หัวหน้างาน</a>
				<a href="${pageContext.request.contextPath}/organizer/questions"
					class="nav-item">จัดการพิธี</a>
				<a href="${pageContext.request.contextPath}/organizer/quotation"
					class="nav-item active">ใบเสนอราคา</a>
			</nav>
			<div class="user-info" onclick="toggleDropdown()">
				<div class="user-avatar">A</div>
				<div class="user-detail">
					<span class="user-name">Admin Organizer</span>
					<span class="user-role">ผู้จัดการ</span>
				</div>
				<span class="arrow">▾</span>
				<div class="dropdown-menu" id="dropdownMenu">
					<a href="${pageContext.request.contextPath}/organizer/logout"
						class="dropdown-item">ออกจากระบบ</a>
				</div>
			</div>
		</div>
	</div>

	<div class="page-wrapper">
		<div class="page-title-row">
			<h1>จัดทำใบเสนอราคา</h1>
			<p>ตรวจสอบจำนวนพระสงฆ์ และเลือกวัสดุอุปกรณ์เสริมตามความเหมาะสมของงาน</p>
		</div>

		<%-- ===== INFO CARD ===== --%>
		<div class="info-card">
			<div class="info-grid">
				<div class="info-box">
					<span class="info-label">รหัสการจอง</span>
					<span class="info-value highlight">${b.bookingId}</span>
				</div>
				<div class="info-box">
					<span class="info-label">ประเภทพิธี</span>
					<span class="info-value">${b.ceremony.ceremonyName}</span>
				</div>
				<div class="info-box">
					<span class="info-label">ลูกค้า</span>
					<span class="info-value">${b.member.memberFirstName} ${b.member.memberLastName}</span>
				</div>
				<div class="info-box">
					<span class="info-label">วันที่จัดงาน</span>
					<span class="info-value">
						<fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy" />
					</span>
				</div>
				<div class="info-box">
					<span class="info-label">เวลา</span>
					<span class="info-value">${b.eventTime} น.</span>
				</div>
			</div>
		</div>

		<%-- ===== FORM ===== --%>
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
									<th style="text-align:center;">ลำดับ</th>
									<th>รายการ</th>
									<th style="text-align:center;">จำนวน</th>
									<th style="text-align:center;">หน่วย</th>
									<th style="text-align:right;">ราคา/หน่วย</th>
									<th style="text-align:right;">รวมเงิน (฿)</th>
									<th>หมายเหตุรายการ</th>
									<th style="text-align:center;">ลบ</th>
								</tr>
							</thead>

							<%-- ===== หมวดอุปกรณ์พิธีกรรม ===== --%>
							<tbody id="group-equipment">
								<tr class="group-row">
									<td colspan="8">หมวดอุปกรณ์พิธีกรรม</td>
								</tr>
							</tbody>

							<%-- ===== หมวดภัตตาหารปิ่นโต ===== --%>
							<tbody id="group-food">
								<tr class="group-row">
									<td colspan="8">หมวดภัตตาหารปิ่นโต</td>
								</tr>

								<c:set var="foodQty" value="1" />
								<c:forEach var="d" items="${b.details}">
									<c:if test="${fn:contains(d.question.questionsText, 'ภัตตาหาร') && fn:contains(d.question.questionsText, 'จำนวน')}">
										<c:if test="${not empty d.answer && d.answer != '0'}">
											<c:set var="foodQty" value="${d.answer}" />
										</c:if>
									</c:if>
								</c:forEach>

								<c:forEach var="detail" items="${validDetails}">
									<c:if test="${fn:contains(detail.question.questionsText, 'ภัตตาหาร') && fn:contains(detail.question.questionsText, 'เลือก')}">
										<c:set var="selectedFoodName" value="${fn:trim(detail.answer)}" />
										<c:forEach var="item" items="${items}">
											<c:if test="${fn:trim(item.itemName) eq selectedFoodName}">
												<tr class="static-row">
													<td class="row-number" style="text-align:center;"></td>
													<td>
														<span class="item-name">${item.itemName}</span>
														<input type="hidden" name="bookingItemNames" value="${item.itemName}">
													</td>
													<%-- qty: JS จะแปลงเป็น qty-wrapper อัตโนมัติตอน window.onload --%>
													<td>
														<input type="number" name="bookingQtys"
															value="${foodQty}" min="1" class="qty-input"
															style="text-align:center;"
															onchange="calculateGrandTotal()">
													</td>
													<td style="text-align:center;">${item.unit}</td>
													<td>
														<input type="number" name="bookingPrices"
															value="${item.pricePerUnit}" step="0.01" min="0"
															class="price-input" style="text-align:right;"
															onchange="calculateGrandTotal()">
													</td>
													<td style="text-align:right;" class="amount-cell">
														<span class="subtotal">0.00</span>
													</td>
													<td><input type="text" name="detailNotes" class="note-input" placeholder="หมายเหตุ"></td>
													<td style="text-align:center;">
														<button type="button" class="btn-remove" onclick="removeRow(this)">✕</button>
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
							</tbody>

							<%-- ===== หมวดสังฆทาน ===== --%>
							<tbody id="group-sangkathan">
								<tr class="group-row">
									<td colspan="8">หมวดสังฆทาน</td>
								</tr>

								<c:set var="sangQty" value="1" />
								<c:forEach var="d" items="${b.details}">
									<c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน') && fn:contains(d.question.questionsText, 'จำนวน')}">
										<c:if test="${not empty d.answer && d.answer != '0'}">
											<c:set var="sangQty" value="${d.answer}" />
										</c:if>
									</c:if>
								</c:forEach>

								<c:forEach var="detail" items="${validDetails}">
									<c:if test="${fn:contains(detail.question.questionsText, 'สังฆทาน') && fn:contains(detail.question.questionsText, 'เลือก')}">
										<c:set var="selectedSangName" value="${fn:trim(detail.answer)}" />
										<c:forEach var="item" items="${items}">
											<c:if test="${fn:trim(item.itemName) eq selectedSangName}">
												<tr class="static-row">
													<td class="row-number" style="text-align:center;"></td>
													<td>
														<span class="item-name">${item.itemName}</span>
														<input type="hidden" name="bookingItemNames" value="${item.itemName}">
													</td>
													<td>
														<input type="number" name="bookingQtys"
															value="${sangQty}" min="1" class="qty-input"
															style="text-align:center;"
															onchange="calculateGrandTotal()">
													</td>
													<td style="text-align:center;">${item.unit}</td>
													<td>
														<input type="number" name="bookingPrices"
															value="${item.pricePerUnit}" step="0.01" min="0"
															class="price-input" style="text-align:right;"
															onchange="calculateGrandTotal()">
													</td>
													<td style="text-align:right;" class="amount-cell">
														<span class="subtotal">0.00</span>
													</td>
													<td><input type="text" name="detailNotes" class="note-input" placeholder="หมายเหตุ"></td>
													<td style="text-align:center;">
														<button type="button" class="btn-remove" onclick="removeRow(this)">✕</button>
													</td>
												</tr>
											</c:if>
										</c:forEach>
									</c:if>
								</c:forEach>
							</tbody>

							<%-- ===== หมวดบริการและการดำเนินการ (พระสงฆ์) ===== --%>
							<tbody id="group-service">
								<tr class="group-row">
									<td colspan="8">หมวดบริการและการดำเนินการ</td>
								</tr>
								<c:forEach var="detail" items="${b.details}">
									<c:if test="${fn:contains(detail.question.questionsText, 'จำนวนพระ')}">
										<tr class="static-row" data-item-id="1">
											<td class="row-number" style="text-align:center;"></td>
											<td>
												<span class="item-name">นิมนต์พระสงฆ์</span>
												<input type="hidden" name="extraItemIds" value="1">
											</td>
											<td>
												<input type="number" name="extraQtys"
													value="${not empty detail.answer ? detail.answer : 1}"
													min="1" class="qty-input" style="text-align:center;"
													onchange="calculateGrandTotal()">
											</td>
											<td style="text-align:center;">รูป</td>
											<td>
												<input type="number" name="extraPrices"
													value="200.00" step="0.01" min="0"
													class="price-input" style="text-align:right;"
													onchange="calculateGrandTotal()">
											</td>
											<td style="text-align:right;" class="amount-cell">
												<span class="subtotal">0.00</span>
											</td>
											<td>
												<input type="text" name="detailNotes"
													value="นิมนต์พระสงฆ์ ${detail.answer} รูป"
													class="note-input">
											</td>
											<td style="text-align:center;">-</td>
										</tr>
									</c:if>
								</c:forEach>
							</tbody>

						</table>

						<button type="button" class="btn-open-popup" onclick="openItemModal()">
							<span>＋</span> เลือกรายการวัสดุอุปกรณ์เสริม
						</button>

					</div><%-- end card-body --%>
				</div><%-- end card --%>
			</div><%-- end main-layout --%>
		</form>
	</div><%-- end page-wrapper --%>

	<%-- ===== STICKY TOTAL BAR ===== --%>
	<div class="total-bar">
		<div class="total-bar-inner">
			<div class="total-bar-meta">
				<span class="total-bar-label">ยอดรวมสุทธิทั้งสิ้น</span>
			</div>
			<div class="total-bar-amount">
				฿ <span id="grandTotal">0.00</span>
			</div>
			<button type="submit" form="quotationForm" class="btn-submit">บันทึกใบเสนอราคา</button>
		</div>
	</div>

	<%-- ===== ITEM SELECTION MODAL ===== --%>
	<div id="itemSelectionModal" class="modal-overlay">
		<div class="modal-card">
			<div class="modal-header">
				<h3>เลือกอุปกรณ์และบริการเสริมสำหรับจัดงานบุญ</h3>
				<button type="button" class="close-btn" onclick="closeItemModal()">✕</button>
			</div>
			<div class="modal-body">
				<table class="popup-table">
					<thead>
						<tr>
							<th width="50" style="text-align:center;">เลือก</th>
							<th>ชื่อรายการสินค้า/งานบริการ</th>
							<th width="140">หมวดหมู่</th>
							<th width="90" style="text-align:center;">หน่วย</th>
							<th width="130" style="text-align:right;">ราคา/หน่วย (฿)</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="item" items="${items}">
							<tr>
								<td style="text-align:center;">
									<input type="checkbox" class="popup-item-checkbox"
										value="${item.itemId}"
										data-name="${item.itemName}"
										data-detail="${item.itemDetail}"
										data-unit="${item.unit}"
										data-price="${item.pricePerUnit}"
										data-type="${item.itemType.itemTypeName}">
								</td>
								<td>
									<strong style="color:#222;">${item.itemName}</strong>
									<c:if test="${not empty item.itemDetail}">
										<br><small style="color:#888;">${item.itemDetail}</small>
									</c:if>
								</td>
								<td><span class="badge-type">${item.itemType.itemTypeName}</span></td>
								<td style="text-align:center;">${item.unit}</td>
								<td style="text-align:right; font-weight:600; color:#333;">
									<fmt:formatNumber value="${item.pricePerUnit}" pattern="#,###.00" />
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn-cancel-modal" onclick="closeItemModal()">ยกเลิก</button>
				<button type="button" class="btn-submit-modal" onclick="addSelectedItemsToTable()">ตกลงเพิ่มรายการที่เลือก</button>
			</div>
		</div>
	</div>

	<script src="${pageContext.request.contextPath}/static/js/quotationCreate.js"></script>
</body>
</html>
