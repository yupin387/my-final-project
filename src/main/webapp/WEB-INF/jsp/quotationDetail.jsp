<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>รายละเอียดใบเสนอราคา ${q.quotationId} - บุญมีนำพา
	จัดงานบุญ</title>
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/quotationDetail.css?v=4">
</head>
<body>

	<%-- ===== NAVBAR ===== --%>
	<nav class="navbar">
		<a class="navbar-brand-wrap"
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
		<c:if test="${not empty success}">
			<div class="flash-banner flash-banner-success">${success}</div>
		</c:if>
		<c:if test="${not empty error}">
			<div class="flash-banner flash-banner-error">${error}</div>
		</c:if>

		<div class="page-title-row">
			<div>
				<h1>ใบเสนอราคา #${q.quotationId}</h1>
			</div>
			<span class="status-badge status-${q.quotationStatus}"> <c:choose>
					<c:when test="${q.quotationStatus == 'Pending'}">รอการยืนยัน</c:when>
					<c:when test="${q.quotationStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
					<c:when test="${q.quotationStatus == 'Revised'}">ต้องการแก้ไข</c:when>
					<c:otherwise>${q.quotationStatus}</c:otherwise>
				</c:choose>
			</span>
		</div>

		<%-- INFO CARD --%>
		<div class="info-card">
			<div class="info-card-header">ข้อมูลการจองและพิธี</div>
			<div class="info-grid">
				<div class="info-box">
					<span class="info-label">รหัสการจอง</span> <span
						class="info-value highlight">${q.bookingForm.bookingId}</span>
				</div>
				<div class="info-box">
					<span class="info-label">ประเภทพิธี</span> <span class="info-value">${q.bookingForm.ceremony.ceremonyType}</span>
				</div>
				<%-- เพิ่มใหม่: แสดงชื่อแพ็กเกจคู่กับประเภทพิธี ให้สอดคล้องกับหน้าสร้าง/แก้ไขใบเสนอราคา --%>
				<div class="info-box">
    <span class="info-label">รูปแบบการจอง</span> <span
        class="info-value">${b.ceremony.ceremonyName}</span>
</div>
				<div class="info-box">
					<span class="info-label">ลูกค้า</span> <span class="info-value">${q.bookingForm.member.memberFirstName}
						${q.bookingForm.member.memberLastName}</span>
				</div>
				<div class="info-box">
					<span class="info-label">วันจัดงาน</span> <span class="info-value"><fmt:formatDate
							value="${q.bookingForm.eventDate}" pattern="dd/MM/yyyy" /></span>
				</div>
				<div class="info-box">
					<span class="info-label">เวลา</span> <span class="info-value">${q.bookingForm.eventTime}
						น.</span>
				</div>
				<div class="info-box">
					<span class="info-label">หัวหน้างานรับผิดชอบ</span> <span
						class="info-value"> <c:choose>
							<c:when test="${not empty q.staff}">
                            ${q.staff.staffFirstName} ${q.staff.staffLastName}<br>
								<small style="color: #666;">โทร: ${q.staff.staffPhone}</small>
							</c:when>
							<c:otherwise>รอการมอบหมาย</c:otherwise>
						</c:choose>
					</span>
				</div>
			</div>
		</div>

		<%-- TABLE CARD --%>
		<div class="table-card">
			<div class="table-card-header">รายละเอียดรายการประมาณการค่าใช้จ่าย</div>
			<table>
				<thead>
					<tr>
						<th width="60" style="text-align: center;">ลำดับ</th>
						<th>รายการ</th>
						<th width="110" style="text-align: center;">จำนวน</th>
						<th width="130" style="text-align: right;">ราคา/หน่วย</th>
						<th width="130" style="text-align: right;">รวม (บาท)</th>
						<th width="220">หมายเหตุ</th>
					</tr>
				</thead>
				<tbody>
					<c:set var="count" value="1" />

					<%-- ตัวแปรชื่อแพ็กเกจ ใช้แยกแถวแพ็กเกจออกจากหมวดอื่น ๆ ไม่ให้ปนกัน/ซ้ำกัน
                     รายการแพ็กเกจถูกบันทึกโดยใช้ itemName == ceremonyName (ดู QuotationService) --%>
					<c:set var="packageName"
						value="${q.bookingForm.ceremony.ceremonyName}" />

					<%-- เช็คก่อนว่าแต่ละหมวดมีรายการจริงหรือไม่ ถ้าไม่มีจะไม่แสดง header เลย --%>
					<c:set var="hasEquipmentRow" value="false" />
					<c:set var="hasFoodRow" value="false" />
					<c:set var="hasSangkathanRow" value="false" />
					<c:set var="hasServiceRow" value="false" />
					<c:forEach var="d" items="${details}">
						<c:if test="${d.item != null && d.item.itemName != packageName}">
							<c:if test="${d.item.itemType.itemTypeName.contains('อุปกรณ์')}">
								<c:set var="hasEquipmentRow" value="true" />
							</c:if>
							<c:if test="${d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
								<c:set var="hasFoodRow" value="true" />
							</c:if>
							<c:if test="${d.item.itemType.itemTypeName.contains('สังฆทาน')}">
								<c:set var="hasSangkathanRow" value="true" />
							</c:if>
							<c:if test="${d.item.itemType.itemTypeName.contains('บริการ')}">
								<c:set var="hasServiceRow" value="true" />
							</c:if>
						</c:if>
					</c:forEach>

					<%-- หมวดแพ็กเกจหลัก --%>
					<c:forEach var="d" items="${details}">
						<c:if test="${d.item != null && d.item.itemName == packageName}">
							<tr class="group-row">
								<td colspan="6">แพ็กเกจ:
									${q.bookingForm.ceremony.ceremonyType} (${packageName})</td>
							</tr>
							<tr>
								<td style="text-align: center; color: #888;">${count}</td>
								<c:set var="count" value="${count + 1}" />
								<td><strong>${d.item.itemName}</strong> <c:if
										test="${not empty d.item.itemDetail}">
										<br>
										<small style="color: #888;">${d.item.itemDetail}</small>
									</c:if> <c:if test="${not empty packageIncludedItems}">
										<div style="margin-top: 6px; font-size: 0.85em; color: #888;">
											<c:forEach var="pkgItem" items="${packageIncludedItems}">
                - ${pkgItem.itemName}<br />
											</c:forEach>
										</div>
									</c:if></td>
								<td style="text-align: center;">${d.quantity}
									${d.item.unit}</td>
								<td style="text-align: right;"><fmt:formatNumber
										value="${d.subtotal / d.quantity}" pattern="#,###.00" /></td>
								<td style="text-align: right;"><fmt:formatNumber
										value="${d.subtotal}" pattern="#,###.00" /></td>
								<td class="note-text">${not empty d.note ? d.note : '-'}</td>
							</tr>
						</c:if>
					</c:forEach>

					<%-- หมวดอุปกรณ์พิธีกรรม (แสดงเฉพาะเมื่อมีรายการจริง) --%>
					<c:if test="${hasEquipmentRow}">
						<tr class="group-row">
							<td colspan="6">หมวดอุปกรณ์พิธีกรรม</td>
						</tr>
						<c:forEach var="d" items="${details}">
							<c:if
								test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์')}">
								<tr>
									<td style="text-align: center; color: #888;">${count}</td>
									<c:set var="count" value="${count + 1}" />
									<td><strong>${d.item.itemName}</strong> <c:if
											test="${not empty d.item.itemDetail}">
											<br>
											<small style="color: #888;">${d.item.itemDetail}</small>
										</c:if></td>
									<td style="text-align: center;">${d.quantity}
										${d.item.unit}</td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${d.item.pricePerUnit}" pattern="#,###.00" /></td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${d.subtotal}" pattern="#,###.00" /></td>
									<td class="note-text">${not empty d.note ? d.note : '-'}</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>

					<%-- หมวดภัตตาหารปิ่นโต (แสดงเฉพาะเมื่อมีรายการจริง) --%>
					<c:if test="${hasFoodRow}">
						<tr class="group-row">
							<td colspan="6">หมวดภัตตาหารปิ่นโต</td>
						</tr>
						<c:forEach var="d" items="${details}">
							<c:if
								test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
								<tr>
									<td style="text-align: center; color: #888;">${count}</td>
									<c:set var="count" value="${count + 1}" />
									<td><strong>${d.item.itemName}</strong> <c:if
											test="${not empty d.item.itemDetail}">
											<br>
											<small style="color: #888;">${d.item.itemDetail}</small>
										</c:if></td>
									<td style="text-align: center;">${d.quantity}
										${d.item.unit}</td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${d.item.pricePerUnit}" pattern="#,###.00" /></td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${d.subtotal}" pattern="#,###.00" /></td>
									<td class="note-text">${not empty d.note ? d.note : '-'}</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>

					<%-- หมวดสังฆทาน (แสดงเฉพาะเมื่อมีรายการจริง) --%>
					<c:if test="${hasSangkathanRow}">
						<tr class="group-row">
							<td colspan="6">หมวดสังฆทาน</td>
						</tr>
						<c:forEach var="d" items="${details}">
							<c:if
								test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
								<tr>
									<td style="text-align: center; color: #888;">${count}</td>
									<c:set var="count" value="${count + 1}" />
									<td><strong>${d.item.itemName}</strong> <c:if
											test="${not empty d.item.itemDetail}">
											<br>
											<small style="color: #888;">${d.item.itemDetail}</small>
										</c:if></td>
									<td style="text-align: center;">${d.quantity}
										${d.item.unit}</td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${d.item.pricePerUnit}" pattern="#,###.00" /></td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${d.subtotal}" pattern="#,###.00" /></td>
									<td class="note-text">${not empty d.note ? d.note : '-'}</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>

					<%-- หมวดบริการและการดำเนินการ (แสดงเฉพาะเมื่อมีรายการจริง) --%>
					<c:if test="${hasServiceRow}">
						<tr class="group-row">
							<td colspan="6">หมวดบริการและการดำเนินการ</td>
						</tr>
						<c:forEach var="d" items="${details}">
							<c:if
								test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('บริการ')}">
								<tr>
									<td style="text-align: center; color: #888;">${count}</td>
									<c:set var="count" value="${count + 1}" />
									<td><strong style="color: #222;">${d.item.itemName}</strong>
										<c:if test="${not empty d.item.itemDetail}">
											<br>
											<small style="color: #888;">${d.item.itemDetail}</small>
										</c:if></td>
									<td style="text-align: center;">${d.quantity}
										${d.item.unit}</td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${d.subtotal / d.quantity}" pattern="#,###.00" /></td>
									<td style="text-align: right;"><fmt:formatNumber
											value="${d.subtotal}" pattern="#,###.00" /></td>
									<td class="note-text">${not empty d.note ? d.note : '-'}</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>

				</tbody>
			</table>
		</div>

		<%-- TOTAL --%>
		<div class="total-card">
			<div class="total-label">ยอดเงินสุทธิทั้งสิ้น</div>
			<div class="total-amount">
				฿
				<fmt:formatNumber value="${q.totalAmount}" pattern="#,###.00" />
			</div>
		</div>

		<%-- BUTTONS --%>
		<div class="btn-row">
			<a href="${pageContext.request.contextPath}/organizer/quotation"
				class="btn btn-back">← กลับหน้ารายการ</a>
			<c:if test="${q.quotationStatus != 'Confirmed'}">
				<a
					href="${pageContext.request.contextPath}/organizer/quotation/edit/${q.quotationId}"
					class="btn btn-edit">แก้ไขใบเสนอราคา</a>
			</c:if>
		</div>
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

</body>
</html>
