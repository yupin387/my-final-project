<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${ceremony.ceremonyName}-บุญมีรับจัดงานบุญ</title>
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/ceremonyDetail.css">
<style>
/* ===== จุดที่ต่างจากอีก 2 หน้า (บ้าน/ขึ้นบ้านใหม่) จริงๆ: การ์ดแพ็กเกจของหน้าบริษัทรูปใหญ่กว่าและ padding มากกว่า ===== */
.cd-package-img-container {
	height: 340px;
}

.cd-package-option {
	padding: 24px;
}

@media ( max-width : 900px) {
	.cd-package-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.cd-package-img-container {
		height: 260px;
	}
}

@media ( max-width : 560px) {
	.cd-package-grid {
		grid-template-columns: 1fr;
	}
	.cd-package-img-container {
		height: 280px;
	}
}
</style>
</head>
<body>

	<%-- ========== NAVBAR (ตรงกับหน้า home ทุกจุด: dropdown บริการ/แพ็กเกจ, ปฏิทิน, สถานะล็อกอิน) ========== --%>
	<nav class="navbar-custom">
		<a class="navbar-brand-wrap"
			href="${pageContext.request.contextPath}/home"
			style="text-decoration: none;"> <img
			src="${pageContext.request.contextPath}/static/images/logoo.png"
			alt="บุญมี รับจัดงานบุญ" class="lotus-icon"> <span
			class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
		</a>
		<div class="navbar-center">
			<a href="${pageContext.request.contextPath}/home"
				class="nav-link-item">หน้าหลัก</a>

			<div class="nav-dropdown-wrap">
				<a href="javascript:void(0);"
					class="nav-link-item nav-dropdown-toggle active">
					บริการ/แพ็กเกจ <span class="nav-caret">▾</span>
				</a>
				<div class="nav-dropdown-panel">
					<c:forEach var="t" items="${ceremonyTypes}">
						<a
							href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}"
							class="nav-dropdown-link">${t.mainName}</a>
					</c:forEach>
					<hr class="nav-dropdown-divider">
				</div>
			</div>

			<div class="nav-dropdown-wrap">
				<a href="${pageContext.request.contextPath}/calendar"
					class="nav-link-item nav-dropdown-toggle"> ปฏิทิน <span
					class="nav-caret">▾</span>
				</a>
				<div class="nav-dropdown-panel">
					<a
						href="${pageContext.request.contextPath}/calendar#calendarSection"
						class="nav-dropdown-link">ปฏิทิน (ฤกษ์ดี)</a> <a
						href="${pageContext.request.contextPath}/calendar#lannaCalendarSection"
						class="nav-dropdown-link">ปฏิทิน (ล้านนา)</a>
				</div>
			</div>

			<c:if test="${not empty sessionScope.user}">
				<a href="${pageContext.request.contextPath}/myBookings" class="nav-link-item">รายการจอง</a>
				
			</c:if>
			<a href="${pageContext.request.contextPath}/reviews"
				class="nav-link-item">รีวิว</a>
			<c:if test="${empty sessionScope.user}">
				<a href="${pageContext.request.contextPath}/loginMember"
					class="nav-link-item">เข้าสู่ระบบ</a>
			</c:if>
		</div>
		<c:choose>
			<c:when test="${not empty sessionScope.user}">
				<div class="dropdown-wrap">
					<div class="user-profile-pill">
						<div class="avatar-circle-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
						<div class="user-info-text">
							<span class="user-name-nav">${sessionScope.user.memberFirstName}
								${sessionScope.user.memberLastName}</span> <span class="user-role-nav">สมาชิก</span>
						</div>
					</div>
					<div class="dropdown-menu-custom" id="dropdownMenu">
						<a href="${pageContext.request.contextPath}/editProfile"
							class="dropdown-link">โปรไฟล์ของฉัน</a> <a
							href="${pageContext.request.contextPath}/logout"
							class="dropdown-link danger">ออกจากระบบ</a>
					</div>
				</div>
			</c:when>
			<c:otherwise>
				<a href="${pageContext.request.contextPath}/register"
					class="btn-register-nav">สมัครสมาชิก</a>
			</c:otherwise>
		</c:choose>
	</nav>

	<%-- ========== HEADER: เหลือแค่ชื่องาน + วันที่เลือก ========== --%>
	<div class="cd-hero"
		style="background-image:url('${pageContext.request.contextPath}/static/images/Hero-banner/cover7.png');">
		<div class="cd-hero-overlay"></div>
		<div class="cd-hero-content">
			<h1 class="cd-hero-title">รายละเอียดงาน${mainType}</h1>
			<div class="cd-hero-divider"></div>
			<c:if test="${not empty selectedDates}">
				<div class="cd-hero-note">
					📅 วันที่คุณเลือกไว้: <strong>${selectedDates}</strong>
				</div>
			</c:if>
		</div>
	</div>

	<%-- ========== HERO แนะนำงานทำบุญบริษัท: ข้อความซ้าย + รูปขวา + การ์ดลอย "รู้จักงานทำบุญออฟฟิศ"
	     (โครงสร้างเดียวกับหน้าทำบุญบ้าน .cd-intro-hero เพื่อให้ธีม/เลย์เอาต์ตรงกัน) ========== --%>
	<section class="cd-intro-hero">
		<div class="cd-intro-hero-petal cd-intro-hero-petal--tr"></div>
		<div class="cd-intro-hero-petal cd-intro-hero-petal--bl"></div>

		<div class="cd-intro-hero-inner">
			<div class="cd-intro-hero-text">
				<div class="cd-intro-hero-icon">
					<svg width="40" height="40" viewBox="0 0 48 34">
						<path d="M24 4 C24 4 20 12 24 20 C28 12 24 4 24 4 Z" fill="#E0577F"/>
						<path d="M24 8 C24 8 16 13 15 22 C21 20 24 14 24 8 Z" fill="#F49CB9"/>
						<path d="M24 8 C24 8 32 13 33 22 C27 20 24 14 24 8 Z" fill="#F49CB9"/>
						<path d="M14 22 C14 22 22 24 24 30 C16 30 14 26 14 22 Z" fill="#E0577F"/>
						<path d="M34 22 C34 22 26 24 24 30 C32 30 34 26 34 22 Z" fill="#E0577F"/>
					</svg>
				</div>

				<h2 class="cd-intro-hero-title">พิธีทำบุญบริษัท เพื่อความเป็นสิริมงคลและความเจริญก้าวหน้าขององค์กร</h2>

				<p class="cd-intro-hero-desc">
					การทำบุญบริษัทหรือออฟฟิศ เป็นโอกาสในการเสริมสิริมงคลให้กับสถานที่ทำงาน
					และผู้ที่ปฏิบัติงานภายในองค์กร หลายบริษัทนิยมจัดพิธีทำบุญเพื่อสร้างขวัญและกำลังใจ
					รวมถึงเป็นการเริ่มต้นช่วงเวลาใหม่ ๆ ด้วยความเป็นสิริมงคล
					อีกทั้งยังช่วยสร้างความสามัคคีและความสัมพันธ์อันดีระหว่างผู้บริหารและพนักงาน
				</p>

				<div class="cd-intro-hero-ornament">
					<svg width="60" height="20" viewBox="0 0 60 20">
						<line x1="0" y1="10" x2="20" y2="10" stroke="#D9A441" stroke-width="1"/>
						<line x1="40" y1="10" x2="60" y2="10" stroke="#D9A441" stroke-width="1"/>
						<path d="M30 4 C27 8 27 12 30 16 C33 12 33 8 30 4 Z" fill="#E0577F"/>
						<path d="M24 10 C26 8 28 8 30 10 C28 12 26 12 24 10 Z" fill="#D9A441"/>
						<path d="M36 10 C34 8 32 8 30 10 C32 12 34 12 36 10 Z" fill="#D9A441"/>
					</svg>
				</div>
			</div>

			<div class="cd-intro-hero-photo-wrap">
				<img src="${pageContext.request.contextPath}/static/images/b3.jpg"
					 alt="ทีมงานให้คำปรึกษาการจัดงานทำบุญบริษัท" class="cd-intro-hero-photo">

				<div class="cd-intro-float-card">
					<div class="cd-intro-float-card-icon">🏢</div>
					<div class="cd-intro-float-card-body">
						<div class="cd-intro-float-card-title">รู้จักงานทำบุญออฟฟิศ</div>
						<p class="cd-intro-float-card-desc">
							งานทำบุญออฟฟิศหรือบริษัท คือการนิมนต์พระสงฆ์มาประกอบพิธีสงฆ์ในสถานที่ทำงาน
							เพื่อความเป็นสิริมงคลในการดำเนินธุรกิจ นิยมจัดเมื่อเปิดบริษัทใหม่
							ย้ายสำนักงาน หรือทำบุญประจำปีของกิจการ เชื่อว่าจะช่วยเสริมดวงการงาน
							สร้างขวัญกำลังใจให้พนักงาน และเป็นการแสดงความเคารพต่อสถานที่ทำงาน
							ก่อนเริ่มดำเนินกิจการหรือช่วงเวลาสำคัญของบริษัท
						</p>
					</div>
				</div>
			</div>
		</div>
	</section>

	<%-- ========== KANOK DIVIDER ========== --%>
<svg viewBox="0 0 1200 48" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="display:block;width:100%;height:48px;background:#FFF5F8;">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#F0A9C1" stroke-width="1" opacity="0.6"/>
    <g fill="#E0577F" opacity="0.5">
        <ellipse cx="600" cy="24" rx="18" ry="6" transform="rotate(-30 600 24)"/>
        <ellipse cx="600" cy="24" rx="18" ry="6" transform="rotate(30 600 24)"/>
        <ellipse cx="600" cy="24" rx="18" ry="6"/>
        <circle  cx="600" cy="24" r="4"   fill="#D9A441"/>
        <ellipse cx="480" cy="24" rx="14" ry="5" transform="rotate(-30 480 24)"/>
        <ellipse cx="480" cy="24" rx="14" ry="5" transform="rotate(30 480 24)"/>
        <circle  cx="480" cy="24" r="3"   fill="#D9A441"/>
        <ellipse cx="720" cy="24" rx="14" ry="5" transform="rotate(-30 720 24)"/>
        <ellipse cx="720" cy="24" rx="14" ry="5" transform="rotate(30 720 24)"/>
        <circle  cx="720" cy="24" r="3"   fill="#D9A441"/>
        <ellipse cx="360" cy="24" rx="10" ry="4" transform="rotate(-30 360 24)"/>
        <ellipse cx="360" cy="24" rx="10" ry="4" transform="rotate(30 360 24)"/>
        <circle  cx="360" cy="24" r="2.5" fill="#D9A441"/>
        <ellipse cx="840" cy="24" rx="10" ry="4" transform="rotate(-30 840 24)"/>
        <ellipse cx="840" cy="24" rx="10" ry="4" transform="rotate(30 840 24)"/>
        <circle  cx="840" cy="24" r="2.5" fill="#D9A441"/>
        <ellipse cx="240" cy="24" rx="7"  ry="3" transform="rotate(-30 240 24)"/>
        <ellipse cx="240" cy="24" rx="7"  ry="3" transform="rotate(30 240 24)"/>
        <ellipse cx="960" cy="24" rx="7"  ry="3" transform="rotate(-30 960 24)"/>
        <ellipse cx="960" cy="24" rx="7"  ry="3" transform="rotate(30 960 24)"/>
    </g>
    <line x1="0" y1="6"  x2="1200" y2="6"  stroke="#F0A9C1" stroke-width="0.5" opacity="0.35"/>
    <line x1="0" y1="42" x2="1200" y2="42" stroke="#F0A9C1" stroke-width="0.5" opacity="0.35"/>
</svg>

	<%-- ========== MAIN CONTENT ========== --%>
	<div class="cd-container">

		<%-- ========== โซน 2: เปรียบเทียบแพ็กเกจ ========== --%>
		<div class="cd-card cd-package-card">
			<div class="cd-card-title">📦 เปรียบเทียบแพ็กเกจ${mainType}</div>
			<p
				style="font-size: 13px; color: var(--text-muted); margin-bottom: 16px; line-height: 1.6;">
				แต่ละแพ็กเกจมีจำนวนพระสงฆ์เท่ากัน แต่รายละเอียดรายการอื่นๆ
				ที่ได้รับแตกต่างกัน กดปุ่ม <strong>"ดูรายละเอียดแพ็กเกจนี้"</strong>
				เพื่ออ่านก่อนตัดสินใจ แล้วกด <strong>"เลือกจองแพ็กเกจนี้"</strong>
				เพื่อไปกรอกแบบฟอร์มของแพ็กเกจที่ต้องการได้เลย
			</p>
			<div class="cd-package-grid">
				<c:set var="imageIndex" value="1" />
				<c:forEach items="${packages}" var="p">
					<c:if test="${p.ceremonyName != 'กรอกความต้องการเบื้องต้น'}">
						<div class="cd-package-option">
							<div class="cd-package-img-container">
								<img
									src="${pageContext.request.contextPath}/static/images/p${imageIndex}.png"
									alt="${p.ceremonyName}">
							</div>

							<div class="cd-package-option-name">${p.ceremonyName}</div>
							<div class="cd-package-option-price">
								<fmt:formatNumber value="${p.basePrice}" type="number"
									groupingUsed="true" maxFractionDigits="0" />
								บาท
							</div>

							<%-- ========== รายละเอียดแพ็กเกจ (ซ่อน/แสดงได้) ========== --%>
							<div id="detail-${p.ceremonyId}" class="cd-detail-collapsed"
								style="width: 100%;">
								<ul class="cd-condition-list"
									style="font-size: 0.85rem; text-align: left; padding-left: 18px; margin: 0;">
									<c:choose>
										<c:when test="${p.ceremonyName == 'แพ็กเกจมาตรฐาน'}">
											<li>ติดต่อวัด นิมนต์คณะพระภิกษุสงฆ์ 5 รูป</li>
											<li>ชุดโต๊ะหมู่บูชา และพระประธาน</li>
											<li>ชุดอาสนะพระภิกษุสงฆ์ จำนวน 5 ชุด</li>
											<li>เครื่องใช้ และอุปกรณ์ประกอบพิธีสงฆ์</li>
											<li>พิธีกรดำเนินพิธีการสงฆ์</li>
											<li>ชุดสังฆทาน ชุดมาตรฐาน ราคา 299 บาท/ชุด (จำนวน 5 ชุด)</li>
											<li>ดอกไม้ ธูปเทียน สายสิญจน์ แป้งเจิม</li>
											<li>เจ้าหน้าที่จัดเตรียมงาน, พิธีกร ค่าขนส่งอุปกรณ์</li>
										</c:when>
										<c:when test="${p.ceremonyName == 'แพ็กเกจอิ่มบุญ'}">
											<li>ติดต่อวัด นิมนต์คณะพระภิกษุสงฆ์ 7 รูป</li>
											<li>ชุดโต๊ะหมู่บูชา และพระประธาน</li>
											<li>ชุดอาสนะพระภิกษุสงฆ์ จำนวน 7 ชุด</li>
											<li>เครื่องใช้ และอุปกรณ์ประกอบพิธีสงฆ์</li>
											<li>พิธีกรดำเนินพิธีการสงฆ์</li>
											<li>ชุดสังฆทาน ชุดมาตรฐาน ราคา 299 บาท/ชุด (จำนวน 7 ชุด)</li>
											<li>ชุดไทยธรรม ถุงทองอุปโภค และบริโภค
												พร้อมพวงมาลัยถวายคณะพระภิกษุสงฆ์ จำนวน 7 รูป</li>
											<li>ดอกไม้ ธูปเทียน พานพุ่ม สายสิญจน์ แป้งเจิม</li>
											<li>เจ้าหน้าที่จัดเตรียมงาน, พิธีกร ค่าขนส่งอุปกรณ์</li>
										</c:when>
										<c:when test="${p.ceremonyName == 'แพ็กเกจพรีเมียม'}">
											<li>ติดต่อวัด นิมนต์คณะพระภิกษุสงฆ์ 9 รูป</li>
											<li>ชุดโต๊ะหมู่บูชา และพระประธาน</li>
											<li>ชุดอาสนะพระภิกษุสงฆ์ จำนวน 9 ชุด</li>
											<li>เครื่องใช้ และอุปกรณ์ประกอบพิธีสงฆ์</li>
											<li>พิธีกรดำเนินพิธีการสงฆ์</li>
											<li>ชุดสังฆทาน ชุดมาตรฐาน ราคา 299 บาท/ชุด (จำนวน 9 ชุด)</li>
											<li>ชุดไทยธรรม ถุงทองอุปโภค และบริโภค
												พร้อมพวงมาลัยถวายคณะพระภิกษุสงฆ์ จำนวน 9 รูป</li>
											<li>ดอกไม้ ธูปเทียน พานพุ่ม สายสิญจน์ แป้งเดิม
												และแผ่นทอง</li>
											<li>เจ้าหน้าที่จัดเตรียมงาน, พิธีกร ค่าขนส่งอุปกรณ์</li>
										</c:when>
										<c:otherwise>
											<li>รายละเอียดจะจัดเตรียมตามความต้องการของท่าน</li>
										</c:otherwise>
									</c:choose>
								</ul>
							</div>
							<button type="button" class="cd-btn-view-detail"
								onclick="toggleDetail('${p.ceremonyId}', this)">
								ดูรายละเอียดแพ็กเกจนี้ ▾</button>

							<%-- ปุ่มจอง --%>
							<a
								href="${pageContext.request.contextPath}/booking3?ceremonyId=${p.ceremonyId}"
								class="cd-btn-select-package">เลือกจองแพ็กเกจนี้</a>

							<c:set var="imageIndex" value="${imageIndex + 1}" />
						</div>
					</c:if>
				</c:forEach>
			</div>
		</div>

		<%-- ========== โซน 3: สิ่งที่จะได้รับ ========== --%>
		<div class="cd-card">
			<div class="cd-card-title">✨ สิ่งที่รวมในทุกแพ็กเกจ</div>

			<ul class="cd-condition-list">
				<li>✅ ให้คำปรึกษาและวางแผนการจัดงานบุญโดยทีมงานผู้มีประสบการณ์</li>

				<li>✅ ดำเนินพิธีตามหลักพระพุทธศาสนาและประเพณีไทย</li>

				<li>✅ นิมนต์และรับ-ส่งพระสงฆ์ <strong>(จำนวนพระแตกต่างกันตามแพ็กเกจ)</strong></li>

				<li>✅ จัดเตรียมอุปกรณ์ประกอบพิธีครบชุด
					พร้อมจัดสถานที่สำหรับประกอบพิธี</li>

				<li>✅ ทีมงานดูแลและอำนวยความสะดวกตลอดพิธี</li>

				<li>✅ มัคนายกดำเนินพิธี</li>

				<li>
					✅ เลือกสินค้าและบริการเพิ่มเติมได้ เช่น ชุดสังฆทาน ชุดปิ่นโต
					<div class="cd-important-note">
						<strong>หมายเหตุ:</strong> ชุดสังฆทานที่รวมอยู่ในแพ็กเกจเป็นชุดมาตรฐานราคา 299 บาท/ชุด
						ตามจำนวนพระสงฆ์ของแพ็กเกจที่เลือก หากลูกค้าต้องการเปลี่ยนเป็นชุดสังฆทานราคาอื่นที่นอกเหนือจากชุดมาตรฐานนี้
						ทางร้านจะคิดค่าใช้จ่ายส่วนต่างเพิ่มเติมจากราคาแพ็กเกจที่ระบุไว้
					</div>
				</li>
			</ul>
		</div>

		<div class="promotion-banner-wrap">
			<img
				src="${pageContext.request.contextPath}/static/images/promotion.png"
				alt="โปรโมชั่น จัดงานบุญให้ง่าย ครบ จบในที่เดียว รับฟรี เครื่องเสียง เก้าอี้ โต๊ะพร้อมผ้าคลุม"
				class="promotion-banner-img">
		</div>

	</div>

	<%-- ========== FOOTER BAR ========== --%>
	<div class="cd-footer">
		<div class="cd-footer-inner">
			<div class="cd-footer-note">
				<span>ไม่อยากเลือกแพ็กเกจสำเร็จรูป? กรอกรายละเอียดเองได้</span>
			</div>
			<a
				href="${pageContext.request.contextPath}/booking3?ceremonyId=${ceremony.ceremonyId}&custom=true"
				class="cd-btn-book">จองเเบบระบุเอง (ทำบุญบริษัท)</a>
		</div>
	</div>

	<%-- ========== FOOTER (คัดลอกจาก home.jsp ให้ตรงกันเป๊ะ: แบรนด์ + โซเชียล + ติดต่อเรา) ========== --%>
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
<stop offset="100%" stop-color="rgba(217,164,65,0.15)" />
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
					<span class="footer-brand-text">บุญมี รับจัดงานบุญ</span>
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
				<%-- TODO: ใส่เบอร์โทร / LINE OA / อีเมลจริงของร้านแทนที่ตรงนี้ --%>
				<p>📞 โทร. 08X-XXX-XXXX</p>
				<p>💬 LINE OA: @boonmee</p>
				<p>✉️ boonmee.booking@gmail.com</p>
				<p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
			</div>
		</div>
	</footer>

	<script>
		function toggleDetail(id, btn) {
			var el = document.getElementById('detail-' + id);
			el.classList.toggle('cd-detail-collapsed');
			btn.textContent = el.classList.contains('cd-detail-collapsed') ? 'ดูรายละเอียดแพ็กเกจนี้ ▾'
					: 'ซ่อนรายละเอียด ▴';
		}

		document.addEventListener('DOMContentLoaded', function() {
			var pill = document.querySelector('.user-profile-pill');
			var menu = document.getElementById('dropdownMenu');
			if (pill && menu) {
				pill.addEventListener('click', function(e) {
					e.stopPropagation();
					menu.classList.toggle('show');
				});
				document.addEventListener('click', function() {
					menu.classList.remove('show');
				});
			}
		});
	</script>

	<script
		src="${pageContext.request.contextPath}/static/js/ceremonyDetail.js"></script>
</body>
</html>
