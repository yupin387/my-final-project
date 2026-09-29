<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ใบสรุปรายละเอียดการจอง ${booking.bookingId} - บุญมีนำพา</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Charmonman:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/viewBooking.css?v=28">

</head>
<body>

	<%-- Navbar --%>
	<nav class="navbar-custom">
		<a class="navbar-brand-wrap"
			href="${pageContext.request.contextPath}/home">
			<div class="lotus-icon">
				<img
					src="${pageContext.request.contextPath}/static/images/logoo.png"
					alt="บุญมีนำพา รับจัดงานบุญ" onerror="this.style.display='none'">
			</div> <span class="nav-brand-text">บุญมีนำพา รับจัดงานบุญ</span>
		</a>
		<div class="navbar-center">
			<a href="${pageContext.request.contextPath}/home"
				class="nav-link-item">หน้าหลัก</a>

			<div class="dropdown-wrap nav-dropdown-wrap">
				<a href="javascript:void(0);" class="nav-link-item">บริการ/แพ็กเกจ
					▾</a>
				<div class="dropdown-menu-custom nav-dropdown-panel">
					<c:if test="${not empty ceremonyTypes}">
						<c:forEach var="t" items="${ceremonyTypes}">
							<a
								href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}"
								class="dropdown-link">${t.mainName}</a>
						</c:forEach>
					</c:if>
				</div>
			</div>

			<div class="dropdown-wrap nav-dropdown-wrap">
				<a href="${pageContext.request.contextPath}/calendar"
					class="nav-link-item">ปฏิทิน ▾</a>
				<div class="dropdown-menu-custom nav-dropdown-panel">
					<a
						href="${pageContext.request.contextPath}/calendar#calendarSection"
						class="dropdown-link">ปฏิทิน (ฤกษ์ดี)</a> <a
						href="${pageContext.request.contextPath}/calendar#lannaCalendarSection"
						class="dropdown-link">ปฏิทิน (ล้านนา)</a>
				</div>
			</div>

			<a href="${pageContext.request.contextPath}/myBookings"
				class="nav-link-item active">รายการจอง</a> <a
				href="${pageContext.request.contextPath}/reviews"
				class="nav-link-item">รีวิว</a>
		</div>

		<div class="dropdown-wrap">
			<div class="user-profile-pill" onclick="toggleDropdown(event)">
				<div class="avatar-circle-nav">
					<c:choose>
						<c:when
							test="${not empty sessionScope.user && not empty sessionScope.user.memberFirstName}">
                        ${fn:substring(sessionScope.user.memberFirstName, 0, 1)}
                    </c:when>
						<c:otherwise>U</c:otherwise>
					</c:choose>
				</div>
				<div class="user-info-text">
					<span class="user-name-nav"> <c:out
							value="${sessionScope.user.memberFirstName}" default="สมาชิก" />
						<c:out value="${sessionScope.user.memberLastName}" default="" />
					</span> <span class="user-role-nav">สมาชิก</span>
				</div>
			</div>
			<div class="dropdown-menu-custom" id="dropdownMenu">
				<a href="${pageContext.request.contextPath}/editProfile"
					class="dropdown-link">โปรไฟล์ของฉัน</a> <a
					href="${pageContext.request.contextPath}/logout"
					class="dropdown-link danger">ออกจากระบบ</a>
			</div>
		</div>
	</nav>

	<div class="page-wrapper">

		<%-- แจ้งเตือนกรณีรอการติดต่อ --%>
		<c:if test="${booking.bookingStatus == 'Pending'}">
			<div class="booking-notice" id="pendingNotice">
				<div class="notice-icon">
					<i class="bi bi-telephone-inbound-fill"></i>
				</div>
				<div class="notice-content">
					<strong>รอการติดต่อจากทีมงาน</strong>
					<p>หลังจากท่านส่งยืนยันการจองแล้ว
						กรุณารอการติดต่อจากทีมงานเพื่อประสานงานรายละเอียดเพิ่มเติม
						พร้อมจัดทำใบเสนอราคาเพื่อยืนยันการจองอีกครั้ง</p>
				</div>
			</div>
		</c:if>

		<%-- แจ้งเตือนกรณีถูกปฏิเสธ พร้อมเหตุผลที่ทีมงานระบุไว้ --%>
		<c:if test="${booking.bookingStatus == 'Rejected'}">
			<div class="booking-notice notice-rejected">
				<div class="notice-icon">
					<i class="bi bi-x-circle-fill"></i>
				</div>
				<div class="notice-content">
					<strong>รายการจองนี้ถูกปฏิเสธ</strong>
					<p>ทีมงานได้พิจารณาและไม่สามารถรับงานนี้ได้
						กรุณาดูเหตุผลด้านล่าง
						หากมีข้อสงสัยสามารถติดต่อทีมงานเพื่อสอบถามเพิ่มเติมได้</p>
					<div class="notice-reject-reason">
						<strong>เหตุผลที่ปฏิเสธ:</strong>
						<c:out value="${booking.rejectDetail}" default="ไม่ได้ระบุเหตุผล" />
					</div>
				</div>
			</div>
		</c:if>

		<%-- กระดาษเอกสารใบสรุปการจอง --%>
		<div class="booking-sheet-document">

			<%-- Header เอกสาร --%>
			<div class="sheet-header">
				<div class="company-brand">
					<div class="brand-logo">
						<img
							src="${pageContext.request.contextPath}/static/images/logoo.png"
							alt="บุญมีนำพา" onerror="this.style.display='none'">
					</div>
					<div>
						<h1 class="company-name">บุญมีนำพา รับจัดงานบุญ</h1>
						<p class="company-sub">บริการรับจัดงานบุญ พิธีทำบุญบ้าน
							และงานพิธีสงฆ์ทุกรูปแบบ</p>
					</div>
				</div>

				<div class="document-title-box">
					<h2 class="doc-title">ใบสรุปรายละเอียดการจอง</h2>
					<div class="doc-no">
						รหัสรายการจอง: <strong>${booking.bookingId}</strong>
					</div>
					<div class="mt-2">
						<span
							class="status-pill status-${fn:toLowerCase(booking.bookingStatus)}"
							id="bookingStatusPill"> <c:choose>
								<c:when test="${booking.bookingStatus == 'Pending'}">รอดำเนินการ</c:when>
								<c:when test="${booking.bookingStatus == 'Approved'}">อนุมัติแล้ว</c:when>
								<c:when test="${booking.bookingStatus == 'Quoted'}">ออกใบเสนอราคาแล้ว</c:when>
								<c:when test="${booking.bookingStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
								<c:when test="${booking.bookingStatus == 'Completed'}">เสร็จสิ้น</c:when>
								<c:when test="${booking.bookingStatus == 'Rejected'}">ปฏิเสธแล้ว</c:when>
								<c:when test="${booking.bookingStatus == 'Cancelled'}">ยกเลิกแล้ว</c:when>
								<c:otherwise>${booking.bookingStatus}</c:otherwise>
							</c:choose>
						</span>
					</div>
				</div>
			</div>

			<hr class="sheet-divider-bold">

			<%-- 1. ข้อมูลผู้ใช้บริการ & กำหนดการ --%>
			<div class="section">
				<div class="row g-4">
					<div class="col-md-6">
						<div class="sheet-box">
							<div class="section-title">
								<i class="bi bi-person-fill"></i> ข้อมูลผู้ใช้บริการ
							</div>
							<div class="info-row">
								<span class="info-label">ชื่อ-นามสกุล</span> <span
									class="info-value">คุณ ${booking.member.memberFirstName}
									${booking.member.memberLastName}</span>
							</div>
							<div class="info-row">
								<span class="info-label">เบอร์โทรศัพท์</span> <span
									class="info-value">${booking.member.phoneNumber}</span>
							</div>
							<c:if test="${not empty booking.member.memberEmail}">
								<div class="info-row">
									<span class="info-label">อีเมล</span> <span class="info-value">${booking.member.memberEmail}</span>
								</div>
							</c:if>
						</div>
					</div>

					<div class="col-md-6">
						<div class="sheet-box">
							<div class="section-title">
								<i class="bi bi-calendar-event-fill"></i> กำหนดการและสถานที่
							</div>
							<div class="info-row">
								<span class="info-label">วันที่จัดงาน</span> <span
									class="info-value"><fmt:formatDate
										value="${booking.eventDate}" pattern="dd/MM/yyyy" /></span>
							</div>
							<div class="info-row">
								<span class="info-label">เวลาเริ่มพิธี</span> <span
									class="info-value">${booking.eventTime} น.</span>
							</div>
							<div class="info-row">
								<span class="info-label">สถานที่จัดงาน</span> <span
									class="info-value">${booking.eventAddress}</span>
							</div>
						</div>
					</div>
				</div>
			</div>

			<%-- 2. แผนที่และรูปภาพสถานที่ --%>
			<c:if test="${not empty booking.eventAddress}">
				<div class="section pt-0">
					<div class="row g-4">
						<div class="col-md-6">
							<div class="section-title">
								<i class="bi bi-geo-alt-fill"></i> แผนที่ปักหมุดสถานที่
							</div>
							<c:set var="mapQuery"
								value="${not empty booking.eventLat && not empty booking.eventLng ? booking.eventLat += ',' += booking.eventLng : fn:escapeXml(booking.eventAddress)}" />
							<div class="map-container">
								<iframe class="map-iframe" loading="lazy" allowfullscreen
									src="https://maps.google.com/maps?q=${mapQuery}&t=&z=16&ie=UTF8&iwloc=&output=embed">
								</iframe>
							</div>
							<a
								href="https://www.google.com/maps/search/?api=1&query=${mapQuery}"
								target="_blank" class="btn-map-link"> <i
								class="bi bi-box-arrow-up-right"></i> เปิดนำทางใน Google Maps
							</a>
						</div>

						<div class="col-md-6">
							<div class="section-title">
								<i class="bi bi-images"></i> รูปภาพสถานที่ประกอบ
							</div>
							<c:choose>
								<c:when test="${not empty booking.addressImage}">
									<div class="image-gallery">
										<c:forEach items="${fn:split(booking.addressImage, ',')}"
											var="imgFile">
											<c:set var="trimmed" value="${fn:trim(imgFile)}" />
											<c:if test="${not empty trimmed}">
												<img
													src="${pageContext.request.contextPath}/uploads/address/${trimmed}"
													class="location-img" alt="สถานที่จัดงาน"
													onerror="this.style.display='none'">
											</c:if>
										</c:forEach>
									</div>
								</c:when>
								<c:otherwise>
									<div class="no-img-box">
										<i class="bi bi-image"></i> ไม่มีรูปภาพสถานที่
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</c:if>

			<hr class="divider">

			<%-- ===== ตัวแปรควบคุมการแสดงผล คำนวณล่วงหน้าก่อนเข้าส่วนที่ 3 ===== --%>
			<%-- ✅ แก้ไข: ceremony -> packageEntity --%>
			<c:set var="basePriceVal" value="${booking.packageEntity.basePrice}" />
			<c:set var="isCustomRequest"
				value="${empty basePriceVal || basePriceVal == 0 || fn:indexOf(booking.packageEntity.optionType, 'กรอกความต้องการ') ne -1}" />

			<%-- อ่านชุดสังฆทานที่ลูกค้าเลือก และจำนวนชุดที่สั่ง --%>
			<c:set var="sanghaChoice" value="" />
			<c:set var="sanghaQtyRaw" value="0" />
			<c:forEach items="${booking.details}" var="dd">
				<c:if
					test="${dd.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ'}">
					<c:set var="sanghaChoice" value="${fn:trim(dd.answer)}" />
				</c:if>
				<c:if
					test="${dd.question.questionsText eq 'จำนวนชุดสังฆทาน' && not empty fn:trim(dd.answer)}">
					<c:set var="sanghaQtyRaw" value="${fn:trim(dd.answer)}" />
				</c:if>
			</c:forEach>

			<%-- หาชุดสังฆทานที่ "รวมอยู่ในแพ็กเกจ" จาก PackageItem (โหมดกรอกเองจะไม่มี) --%>
			<c:set var="includedName" value="" />
			<c:set var="includedPrice" value="0" />
			<c:set var="includedQty" value="0" />
			<c:if test="${not isCustomRequest}">
				<c:forEach items="${packageItems}" var="pk">
					<c:if test="${pk.item.itemType.itemTypeName eq 'สังฆทาน'}">
						<c:set var="includedName" value="${pk.item.itemName}" />
						<c:set var="includedPrice" value="${pk.item.pricePerUnit}" />
						<c:set var="includedQty" value="${pk.quantity}" />
					</c:if>
				</c:forEach>
			</c:if>

			<%-- สังฆทานอยู่ในแพ็กเกจทั้งหมด (ไม่ต้องคิดเงินเพิ่ม) = เลือกชุดเดียวกับที่รวมในแพ็กเกจ และจำนวนไม่เกินโควตา
			     ถ้าไม่เข้าเงื่อนไข (เลือกชุดอื่น หรือสั่งเกินโควตา) จะแสดงในส่วน "รายการเพิ่มเติม" เพื่อคิดส่วนต่าง/ราคาเต็ม --%>
			<c:set var="sanghaFullyIncluded"
				value="${not isCustomRequest && not empty includedName && sanghaChoice eq includedName && sanghaQtyRaw <= includedQty}" />
			<c:set var="showSanghaSeparately"
				value="${isCustomRequest || (not empty sanghaChoice && not sanghaFullyIncluded)}" />
			<c:set var="hideSangha" value="${!showSanghaSeparately}" />

			<%-- 3. รายละเอียดแพ็กเกจ / ความต้องการ --%>
			<div class="section">
				<div class="section-title">
					<i class="bi bi-box-seam-fill"></i>
					<c:choose>
						<c:when test="${isCustomRequest}">รายละเอียดงานบุญ (แจ้งความต้องการเบื้องต้น)</c:when>
						<c:otherwise>รายละเอียดแพ็กเกจงานบุญ</c:otherwise>
					</c:choose>
				</div>

				<div class="sheet-box mb-3">
					<div class="row g-3">
						<div class="col-md-6">
							<div class="info-row mb-0">
								<%-- ✅ แก้ไข: Package ไม่มี field ceremonyType ใช้ packageType แทน --%>
								<span class="info-label">ประเภทงานบุญ</span> <span
									class="info-value">${booking.packageEntity.packageType}</span>
							</div>
						</div>
						<div class="col-md-6">
							<div class="info-row mb-0">
								<span class="info-label"> <c:choose>
										<c:when test="${isCustomRequest}">รูปแบบบริการ</c:when>
										<c:otherwise>ชื่อแพ็กเกจ</c:otherwise>
									</c:choose>
								</span>
								<%-- ✅ แก้ไข: ceremony -> packageEntity --%>
								<span class="info-value">${booking.packageEntity.optionType}</span>
							</div>
						</div>
						<%-- ✅ แก้ไข: ceremony -> packageEntity --%>
						<c:if
							test="${not isCustomRequest && not empty booking.packageEntity.basePrice}">
							<div class="col-12 mt-2 pt-2 border-top">
								<div class="info-row mb-0">
									<span class="info-label">ราคาเริ่มต้นแพ็กเกจ</span> <span
										class="info-value price-text"> ฿<fmt:formatNumber
											value="${booking.packageEntity.basePrice}" pattern="#,###" />
									</span>
								</div>
							</div>
						</c:if>
					</div>
				</div>

				<div class="package-inclusions-box">
					<div class="package-inclusions-title">
						<i class="bi bi-check-circle-fill" style="color: #28a745;"></i>
						<c:choose>
							<c:when test="${isCustomRequest}">รายการบริการพื้นฐานที่จัดให้ :</c:when>
							<c:otherwise>รายการในแพ็กเกจ :</c:otherwise>
						</c:choose>
					</div>

					<c:choose>
						<c:when test="${not empty packageItems}">
							<div class="package-items-grid" id="packageItemsGrid">
								<%-- แสดงชุดสังฆทานที่รวมในแพ็กเกจไว้เสมอ (ไม่ซ่อนแล้ว) เพราะราคาส่วนต่างของชุดที่อัปเกรดอ้างอิงจากชุดนี้ --%>
								<c:forEach var="pi" items="${packageItems}">
									<c:if
										test="${pi.item.itemType.itemTypeId != 5 && pi.item.itemType.itemTypeId != 6}">
										<div class="package-item-chip"
											data-price="${pi.item.pricePerUnit}"
											data-qty="${pi.quantity}"
											data-name="${fn:trim(pi.item.itemName)}">
											<i class="bi bi-check2"></i> <span class="flex-grow-1">${pi.item.itemName}</span>
											<strong class="text-secondary ms-1">${pi.quantity}
												${pi.item.unit}</strong>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</c:when>
						<c:otherwise>
							<div class="text-muted fst-italic py-1">-
								ไม่มีรายการอุปกรณ์ในระบบ -</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<%-- 4. ตัวเลือกและความต้องการเพิ่มเติม --%>
			<c:if test="${not empty booking.details}">

				<c:set var="sanghaHeaderPrinted" value="false" />

				<hr class="divider">
				<div class="section" id="bookingDetailsSection">

					<c:if test="${not isCustomRequest}">
						<div class="section-title">
							<i class="bi bi-plus-circle"></i>
							รายการเพิ่มเติมนอกเหนือจากแพ็กเกจ
						</div>
					</c:if>
					<c:forEach items="${booking.details}" var="d">

						<c:set var="isSanghaQuestion"
							value="${d.question.questionsText eq 'ต้องการสังฆทานหรือไม่' or d.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ' or d.question.questionsText eq 'จำนวนชุดสังฆทาน'}" />

						<c:if test="${not (isSanghaQuestion and hideSangha)}">

							<c:if
								test="${d.question.questionsText eq 'รูปแบบการนิมนต์พระสงฆ์'}">
								<div class="section-title mt-3">
									<i class="bi bi-journal-text"></i> การนิมนต์พระสงฆ์
								</div>
							</c:if>

							<c:if
								test="${d.question.questionsText eq 'ต้องการชุดภัตตาหารปิ่นโตหรือไม่'}">
								<div class="section-title mt-4">
									<i class="bi bi-box-seam"></i> ชุดภัตตาหารปิ่นโต
								</div>
							</c:if>

							<c:if
								test="${isSanghaQuestion and showSanghaSeparately and not sanghaHeaderPrinted}">
								<div class="section-title mt-4">
									<i class="bi bi-gift"></i> ชุดสังฆทาน
								</div>
								<c:set var="sanghaHeaderPrinted" value="true" />
							</c:if>

							<c:if
								test="${d.question.questionsText eq 'มีความต้องการเพิ่มเติมหรือไม่'}">
								<div class="section-title mt-4">
									<i class="bi bi-plus-circle"></i> รายการเพิ่มเติม
								</div>
							</c:if>

							<div class="info-row"
								data-qtext="${fn:trim(d.question.questionsText)}"
								data-answer="${fn:trim(d.answer)}">
								<span class="info-label" style="width: 300px;"><c:out
										value="${d.question.questionsText}" default="รายการ" /></span> <span
									class="info-value"> <c:choose>
										<c:when
											test="${not empty d.answer and fn:trim(d.answer) ne ''}">
											<c:out value="${d.answer}" />
											<%-- ปิ่นโต: แสดงราคาต่อชุดตามเดิม
											     สังฆทาน: ไม่ใส่ราคาตรงนี้ ให้ JavaScript (viewBooking.js) เติมหมายเหตุตามกฎแพ็กเกจ (ส่วนต่าง/ราคาเต็ม) --%>
											<c:if
												test="${d.question.questionsText eq 'เลือกชุดภัตตาหารปิ่นโต'}">
												<c:choose>
													<c:when test="${d.answer eq 'ปิ่นโตชุดประหยัด'}">(299 บาท)</c:when>
													<c:when test="${d.answer eq 'ปิ่นโตชุดมาตรฐาน'}">(399 บาท)</c:when>
													<c:when test="${d.answer eq 'ปิ่นโตชุดพรีเมียม'}">(499 บาท)</c:when>
													<c:when test="${d.answer eq 'ปิ่นโตชุดพิเศษ'}">(599 บาท)</c:when>
												</c:choose>
											</c:if>
										</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose>
								</span>
							</div>
						</c:if>

					</c:forEach>
				</div>
			</c:if>

			<%-- สรุปค่าใช้จ่ายโดยประมาณ --%>
			<div class="cost-summary-wrapper">
				<div class="cost-summary-box" id="costSummaryBox">
					<div class="cost-summary-title">
						<i class="bi bi-calculator-fill"></i> สรุปค่าใช้จ่ายโดยประมาณ
					</div>
					<div class="cost-row">
						<span class="cost-label" id="costPackageLabel">ราคาแพ็กเกจ:</span>
						<span class="cost-value" id="costPackageValue">-</span>
					</div>
					<div class="cost-row" id="costAdditionalRow" style="display: none;">
						<span class="cost-label">รายการเพิ่มเติม:</span> <span
							class="cost-value" id="costAdditionalValue">-</span>
					</div>
					<div class="cost-row cost-discount" id="costDiscountRow"
						style="display: none;">
						<span class="cost-label">ส่วนลดนิมนต์เอง:</span> <span
							class="cost-value" id="costDiscountValue">-</span>
					</div>
					<div class="cost-row cost-total">
						<span class="cost-label">ยอดรวมสุทธิ:</span> <span
							class="cost-value" id="costTotalValue">-</span>
					</div>
					<div class="cost-summary-note">* หมายเหตุ:
						ราคาดังกล่าวเป็นเพียงราคาโดยประมาณเบื้องต้น
						และยังไม่รวมค่าใช้จ่ายเพิ่มเติมตามความต้องการของลูกค้า
						โดยทีมงานจะตรวจสอบรายละเอียดและยืนยันราคาอีกครั้ง</div>
				</div>
			</div>

			<%-- Action Bar --%>
			<div class="action-bar">
				<div>
					<%-- ปุ่มเขียนรีวิวถูกย้ายไปอยู่ที่หน้ารายการจอง (myBookingList) แล้ว
					     หน้านี้จึงเหลือเฉพาะปุ่มยกเลิกรายการจองกรณีที่ยังรอดำเนินการ --%>
					<c:if test="${booking.bookingStatus == 'Pending'}">
						<button type="button" class="btn btn-cancel"
							onclick="showCancelModal('${booking.bookingId}')">
							<i class="bi bi-x-circle me-1"></i> ยกเลิกรายการจอง
						</button>
					</c:if>
				</div>
				<a href="${pageContext.request.contextPath}/myBookings"
					class="btn-back">← กลับหน้ารายการจอง</a>
			</div>
		</div>
	</div>

	<%-- Footer --%>
	<footer class="site-footer">
		<div class="footer-top">
			<svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
				style="display: block; width: 100%; height: 8px;">
            <rect width="1200" height="8" fill="url(#footerGrad)" />
            <defs>
                <linearGradient id="footerGrad" x1="0%" y1="0%"
					x2="100%" y2="0%">
                    <stop offset="0%" stop-color="rgba(217,164,65,0.15)" />
                    <stop offset="50%" stop-color="rgba(217,164,65,0.9)" />
                    <stop offset="100%"
					stop-color="rgba(217,164,65,0.15)" />
                </linearGradient>
            </defs>
        </svg>
		</div>
		<div class="container footer-content footer-content-slim">
			<div class="footer-col footer-brand-col">
				<div class="footer-brand">
					<div class="lotus-icon">
						<img
							src="${pageContext.request.contextPath}/static/images/logoo.png"
							alt="บุญมี รับจัดงานบุญ">
					</div>
					<span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
				</div>
				<p class="footer-tagline">รับจัดงานบุญ ดูแลพิธีสงฆ์ให้คุณ
					ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
				<div class="footer-social">
					<a href="#" class="footer-social-link">📘 Facebook</a> <a href="#"
						class="footer-social-link">▶️ YouTube</a> <a href="#"
						class="footer-social-link">💬 LINE OA</a>
				</div>
			</div>

			<div class="footer-col footer-contact-col">
				<h4 class="footer-heading">ติดต่อเรา</h4>
				<p>📞 โทร. 08X-XXX-XXXX</p>
				<p>💬 LINE OA: @boonmee</p>
				<p>✉️ boonmee@gmail.com</p>
				<p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
			</div>
		</div>
	</footer>

	<%-- Modal ยกเลิกการจอง (โครงสร้างตามแบบรูปที่ 1 + ปุ่มยืนยันสีแดง) --%>
	<div class="modal fade" id="cancelModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content modal-custom-card">
				<div class="modal-body text-center p-4">


					<h4 class="modal-title-custom mb-2">ยืนยันการยกเลิกการจอง</h4>

					<p class="text-muted small mb-3">
						การดำเนินการนี้จะเปลี่ยนสถานะเป็น "ยกเลิกแล้ว"</p>


					<div class="booking-code-badge mb-3">
						รหัสการจอง: <span id="cancelBookingId">${booking.bookingId}</span>
					</div>

					<p class="text-muted small mb-4">
						หากยกเลิกแล้วจะไม่สามารถย้อนกลับได้</p>


					<div class="d-flex justify-content-center gap-3">
						<button type="button" class="btn btn-modal-cancel"
							data-bs-dismiss="modal">ยกเลิก</button>
						<a id="confirmCancelUrl" href="#" class="btn btn-modal-danger">
							ยืนยันยกเลิก </a>
					</div>

				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<%-- ส่วนนี้ต้องอยู่ใน JSP เพราะใช้ค่าจากเซิร์ฟเวอร์ (EL/JSTL)
	     ส่งต่อให้ viewBooking.js ผ่าน contextPath และ VIEW_BOOKING_CONFIG
	     ตรรกะคำนวณทั้งหมดอยู่ใน viewBooking.js --%>
	<script>
		const contextPath = "${pageContext.request.contextPath}";

		window.VIEW_BOOKING_CONFIG = {
			// ราคาจริงจากฐานข้อมูล (เขียนทับราคาตั้งต้นใน viewBooking.js)
			priceOverrides : {},
			// ชุดสังฆทานที่รวมอยู่ในแพ็กเกจ (qty = 0 หมายถึงไม่มี เช่นโหมดกรอกเอง)
			includedSangha : {
				price : ${includedPrice},
				qty : ${includedQty}
			},
			isCustomRequest : ${isCustomRequest},
			<%-- ✅ แก้ไข: ceremony -> packageEntity (ทั้ง basePrice และ optionType) --%>
			basePrice : "${booking.packageEntity.basePrice}",
			optionType : "${fn:trim(booking.packageEntity.optionType)}"
		};
		<c:forEach items="${pintoItems}" var="pItem">
		VIEW_BOOKING_CONFIG.priceOverrides["${pItem.itemName}"] = ${pItem.pricePerUnit};
		</c:forEach>
		<c:forEach items="${sanghatharnItems}" var="sItem">
		VIEW_BOOKING_CONFIG.priceOverrides["${sItem.itemName}"] = ${sItem.pricePerUnit};
		</c:forEach>
	</script>
	<script
		src="${pageContext.request.contextPath}/static/js/viewBooking.js?v=29"></script>
</body>
</html>
