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
<title>${ceremony.ceremonyName}- บุญมีรับจัดงานบุญ</title>
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/ceremonyDetail.css">
<style>
/* ===== ดูรายละเอียดแพ็กเกจ (collapse/expand) ===== */
.cd-detail-collapsed {
	max-height: 60px;
	overflow: hidden;
	position: relative;
}

.cd-detail-collapsed::after {
	content: "";
	position: absolute;
	bottom: 0;
	left: 0;
	width: 100%;
	height: 24px;
	background: linear-gradient(to bottom, rgba(255, 255, 255, 0),
		rgba(255, 255, 255, 0.95));
}

.cd-btn-view-detail {
	display: block;
	width: 100%;
	margin-top: 8px;
	padding: 6px;
	background: transparent;
	border: 1px solid var(--brown-dark, #3d2500);
	border-radius: 6px;
	font-size: 0.85rem;
	cursor: pointer;
	color: var(--brown-dark, #3d2500);
}

.cd-btn-view-detail:hover {
	background: var(--gold-pale, #fff8e1);
}

.cd-btn-select-package {
	display: block;
	text-align: center;
	margin-top: 10px;
	padding: 10px;
	background: var(--brown-dark, #3d2500);
	color: #fff;
	border-radius: 8px;
	text-decoration: none;
	font-weight: 600;
	transition: opacity 0.2s ease;
}

.cd-btn-select-package:hover {
	opacity: 0.88;
}

/* 1. จัด Layout ให้แสดง 3 คอลัมน์แบบมีระยะห่าง */
.cd-package-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
	margin-top: 20px;
	padding: 0 10px;
	align-items: start;
}

.cd-package-option {
	border: 1px solid #eee;
	border-radius: 12px;
	padding: 24px;
	background: #fff;
	display: flex;
	flex-direction: column;
	align-items: center;
	transition: box-shadow 0.3s ease;
}

.cd-package-option:hover {
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.cd-package-img-container {
	width: 100%;
	height: 340px;
	display: flex;
	justify-content: center;
	align-items: center;
	margin-bottom: 15px;
}

.cd-package-img-container img {
	max-width: 100%;
	max-height: 100%;
	object-fit: contain;
	border-radius: 8px;
}

.cd-package-option-name {
	font-size: 1.25rem;
	font-weight: 700;
	margin-bottom: 5px;
	color: #333;
}

.cd-package-option-price {
	font-size: 1.1rem;
	font-weight: 600;
	color: #d6336c;
	margin-bottom: 15px;
}

.cd-btn-select-package {
	width: 100%;
	padding: 12px;
	background: #333;
	color: #fff;
	border-radius: 8px;
	text-align: center;
	text-decoration: none;
	margin-top: auto;
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

/* ============================================================
           ===== HERO BANNER (ใส่ไว้ในไฟล์เองกันไฟล์ CSS ภายนอกโหลดไม่ครบ) =====
           ============================================================ */
.cd-hero {
	position: relative;
	height: 320px;
	background-size: cover;
	background-position: center 30%;
	background-color: #A6335A;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
}

.cd-hero-overlay {
	position: absolute;
	inset: 0;
	background: linear-gradient(to bottom, rgba(0, 0, 0, 0.50) 0%,
		rgba(0, 0, 0, 0.32) 50%, rgba(0, 0, 0, 0.68) 100%);
}

.cd-hero::after {
	content: '';
	position: absolute;
	bottom: 0;
	left: 0;
	right: 0;
	height: 3px;
	background: linear-gradient(90deg, transparent, #FBD0DE, #F49CB9, #FBD0DE,
		transparent);
}

.cd-hero-content {
	position: relative;
	z-index: 2;
	text-align: center;
	color: white;
	padding: 0 24px;
	max-width: 680px;
}

.cd-hero-title {
	font-family: 'Noto Serif Thai', serif;
	font-size: 2.4rem;
	font-weight: 700;
	line-height: 1.25;
	text-shadow: 0 2px 16px rgba(0, 0, 0, 0.5);
	margin-bottom: 12px;
	color: #FFFFFF;
}

.cd-hero-divider {
	width: 70px;
	height: 2px;
	background: linear-gradient(90deg, transparent, #F49CB9, transparent);
	margin: 0 auto 18px;
	border-radius: 2px;
}

.cd-hero-note {
	display: inline-block;
	background: rgba(255, 255, 255, 0.9);
	color: #1A1A1A;
	padding: 10px 28px;
	border-radius: 50px;
	font-size: 0.95rem;
	font-weight: 600;
	border: 1.5px solid #EC6E96;
}

/* ============================================================
           ===== ชวนสงสัย (การ์ดคำถาม-คำตอบ) — ใส่ไว้ในไฟล์เองด้วย =====
           ============================================================ */
.cd-curiosity-teaser {
	background: linear-gradient(180deg, #FFF8F3 0%, #FCE9EF 100%);
	padding: 50px 20px 60px;
	text-align: center;
	position: relative;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 24px;
}

.cd-curiosity-side-img {
	flex-shrink: 0;
	width: 140px;
}

.cd-curiosity-side-img img {
	width: 100%;
	height: auto;
	display: block;
}

.cd-curiosity-side-img.left img {
	transform: scaleX(-1);
}

@media ( max-width : 900px) {
	.cd-curiosity-side-img {
		display: none;
	}
}

.cd-curiosity-card {
	max-width: 720px;
	margin: 0 auto;
	background: #FFFDF9;
	border: 2px solid #D9A441;
	border-radius: 4px;
	padding: 34px 50px 30px;
	position: relative;
	box-shadow: 0 8px 24px rgba(61, 37, 0, 0.1);
}

.cd-curiosity-card::before {
	content: "";
	position: absolute;
	inset: 7px;
	border: 1px solid #E8C878;
	border-radius: 2px;
	pointer-events: none;
}

.cd-curiosity-corner {
	position: absolute;
	width: 42px;
	height: 42px;
}

.cd-curiosity-corner.tl {
	top: -1px;
	left: -1px;
}

.cd-curiosity-corner.tr {
	top: -1px;
	right: -1px;
	transform: scaleX(-1);
}

.cd-curiosity-corner.bl {
	bottom: -1px;
	left: -1px;
	transform: scaleY(-1);
}

.cd-curiosity-corner.br {
	bottom: -1px;
	right: -1px;
	transform: scale(-1, -1);
}

.cd-curiosity-icon {
	margin: 0 auto 12px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.cd-curiosity-question {
	font-family: 'Noto Serif Thai', serif;
	font-size: 1.3rem;
	font-weight: 700;
	color: #A6222F;
	margin-bottom: 14px;
	line-height: 1.6;
}

.cd-curiosity-divider {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 10px;
	margin-bottom: 18px;
}

.cd-curiosity-divider span {
	width: 40px;
	height: 1px;
	background: #D9A441;
}

.cd-curiosity-divider i {
	color: #D9A441;
	font-size: 0.7rem;
}

.cd-curiosity-answer {
	font-size: 0.98rem;
	color: #5c4033;
	line-height: 1.95;
}

/* ============================================================
           ===== NAVBAR (คัดลอกมาจาก home.css / home.jsp ให้ตรงกันเป๊ะ =====
           ============================================================ */
.navbar-custom {
	background: linear-gradient(135deg, #C7405F 0%, #D94F76 50%, #E0577F 100%);
	padding: 0 40px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	border-bottom: 3px solid #FBD0DE;
	position: sticky;
	top: 0;
	z-index: 10000;
	min-height: 92px;
	overflow: visible;
	box-shadow: 0 4px 20px rgba(224, 87, 127, 0.35);
}

.navbar-custom::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.6),
		rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 0.6), transparent);
}

.navbar-brand-wrap {
	display: flex;
	align-items: center;
	text-decoration: none;
	gap: 12px;
}

.navbar-custom .lotus-icon {
	background: rgba(255, 255, 255, 0.18);
	width: 76px;
	height: 76px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 32px;
	border: 1.5px solid rgba(255, 255, 255, 0.55);
	box-shadow: 0 0 10px rgba(255, 255, 255, 0.25);
	flex-shrink: 0;
	overflow: hidden;
}

.navbar-custom .lotus-icon img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	border-radius: 50%;
}

.navbar-custom .nav-brand-text {
	color: #FFFFFF;
	font-family: 'Noto Serif Thai', serif;
	font-style: italic;
	font-size: 30px;
	font-weight: 800;
	letter-spacing: 0.5px;
	white-space: nowrap;
	text-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

.navbar-center {
	display: flex;
	gap: 2px;
	align-items: center;
	margin-left: auto;
	margin-right: 24px;
}

.nav-link-item {
	color: #FFFFFF;
	text-decoration: none;
	font-size: 14px;
	font-weight: 600;
	padding: 8px 16px;
	border-radius: 6px;
	transition: background 0.2s, color 0.2s;
	white-space: nowrap;
	text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
}

.nav-link-item:hover {
	background: rgba(255, 255, 255, 0.2);
	color: #FFFFFF;
}

.nav-link-item.active {
	background: #FFFFFF;
	color: #E0577F;
	font-weight: 700;
}

.btn-register-nav {
	background: #FFFFFF;
	color: #E0577F;
	font-weight: 700;
	border: none;
	border-radius: 8px;
	padding: 9px 22px;
	text-decoration: none;
	font-size: 14px;
	transition: all 0.2s;
	white-space: nowrap;
	font-family: 'Sarabun', sans-serif;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.btn-register-nav:hover {
	background: #FFF3F7;
	color: #B0345A;
	transform: translateY(-1px);
	box-shadow: 0 4px 14px rgba(0, 0, 0, 0.2);
}

.user-profile-pill {
	background: rgba(255, 255, 255, 0.15);
	border: 1.5px solid rgba(255, 255, 255, 0.45);
	padding: 6px 16px 6px 6px;
	border-radius: 50px;
	display: flex;
	align-items: center;
	gap: 10px;
	color: #FFFFFF;
	cursor: pointer;
	transition: background 0.2s;
	position: relative;
	text-decoration: none;
}

.user-profile-pill:hover {
	background: rgba(255, 255, 255, 0.25);
}

.avatar-circle-nav {
	background: #FFFFFF;
	color: #E0577F;
	width: 34px;
	height: 34px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 800;
	font-size: 1rem;
	flex-shrink: 0;
}

.user-info-text {
	display: flex;
	flex-direction: column;
	line-height: 1.2;
}

.user-name-nav {
	font-size: 0.88rem;
	font-weight: 700;
	color: #FFFFFF;
}

.user-role-nav {
	font-size: 0.7rem;
	color: rgba(255, 255, 255, 0.75);
}

.dropdown-wrap {
	position: relative;
	display: inline-block;
	padding-bottom: 10px;
}

.dropdown-menu-custom {
	visibility: hidden;
	opacity: 0;
	position: absolute;
	top: calc(100% - 10px);
	right: 0;
	background-color: #FFFFFF;
	border: 1px solid var(--card-border-soft, #F6D4E1);
	border-radius: 10px;
	min-width: 175px;
	box-shadow: 0 8px 28px rgba(224, 87, 127, 0.18);
	z-index: 99999;
	padding: 0;
	transform: translateY(-8px);
	transition: all 0.25s ease;
}

.dropdown-menu-custom.show {
	visibility: visible;
	opacity: 1;
	transform: translateY(0);
}

.dropdown-link {
	display: block;
	padding: 13px 20px;
	font-family: 'Sarabun', sans-serif;
	font-size: 14px;
	font-weight: 600;
	color: var(--text-mid, #333333);
	text-decoration: none;
	background: #FFFFFF;
	border-bottom: 1px solid var(--cream-mid, #FDEEF3);
	transition: background 0.2s;
	text-align: left;
}

.dropdown-link:last-child {
	border-bottom: none;
	border-radius: 0 0 10px 10px;
}

.dropdown-link:first-child {
	border-radius: 10px 10px 0 0;
}

.dropdown-link:hover {
	background: #FFF3F7;
}

.dropdown-link.danger {
	color: #c0392b;
}

.dropdown-link.danger:hover {
	background: #fff5f5;
}

.nav-dropdown-wrap {
	position: relative;
	display: inline-block;
}

.nav-dropdown-toggle {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	cursor: pointer;
}

.nav-caret {
	font-size: 0.7rem;
	transition: transform 0.2s ease;
}

.nav-dropdown-wrap:hover .nav-caret {
	transform: rotate(180deg);
}

.nav-dropdown-panel {
	display: none;
	position: absolute;
	top: 100%;
	left: 0;
	min-width: 220px;
	background: #FFFFFF;
	border: 1px solid var(--gold-pale, #FBD0DE);
	border-radius: 10px;
	box-shadow: 0 8px 24px rgba(61, 37, 0, 0.15);
	padding: 8px 0;
	z-index: 100;
}

.nav-dropdown-wrap:hover .nav-dropdown-panel, .nav-dropdown-wrap:focus-within .nav-dropdown-panel
	{
	display: block;
}

.nav-dropdown-link {
	display: block;
	padding: 10px 18px;
	font-size: 0.92rem;
	color: var(--brown-dark, #1A1A1A);
	text-decoration: none;
	white-space: nowrap;
}

.nav-dropdown-link:hover {
	background: var(--gold-pale, #FBD0DE);
}

.nav-dropdown-divider {
	border: 0;
	border-top: 1px solid var(--gold-pale, #FBD0DE);
	margin: 6px 0;
}

.login-alert-toast {
	position: fixed;
	top: 24px;
	left: 50%;
	background: #FFFFFF;
	border: 1.5px solid var(--gold-mid);
	color: var(--brown-dark);
	padding: 16px 24px;
	border-radius: 12px;
	box-shadow: 0 8px 32px var(--shadow-gold);
	display: flex;
	align-items: center;
	gap: 14px;
	z-index: 999999;
	transform: translate(-50%, -150%);
	transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275),
		opacity 0.4s ease;
	opacity: 0;
}

.login-alert-toast.show {
	transform: translate(-50%, 0);
	opacity: 1;
}

.toast-icon {
	font-size: 1.4rem;
}

.toast-body {
	display: flex;
	flex-direction: column;
	gap: 2px;
}

.toast-title {
	font-weight: 700;
	font-size: 0.95rem;
}

.toast-user {
	font-size: 0.85rem;
	color: var(--brown-mid);
}

/* ============================================================
           ===== FOOTER (คัดลอกจาก home ให้ตรงกันเป๊ะ) =====
           ============================================================ */
.site-footer {
	background: linear-gradient(135deg, #C7405F 0%, #D94F76 55%, #E0577F 100%);
	color: rgba(255, 255, 255, 0.92);
	padding-top: 0;
	border-top: 3px solid #FBD0DE;
	box-shadow: 0 -8px 24px rgba(0, 0, 0, 0.18);
	position: relative;
	z-index: 2;
}

.footer-top {
	display: block;
}

.footer-content {
	display: grid;
	grid-template-columns: 1.3fr 1fr;
	gap: 30px;
	padding: 44px 20px 26px;
	max-width: 1100px;
	margin: 0 auto;
}

@media ( max-width : 520px) {
	.footer-content {
		grid-template-columns: 1fr;
	}
}

.footer-brand {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 10px;
}

.footer-brand .lotus-icon {
	background: rgba(255, 255, 255, 0.18);
	width: 40px;
	height: 40px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	border: 1.5px solid rgba(255, 255, 255, 0.5);
	flex-shrink: 0;
	overflow: hidden;
}

.footer-brand .lotus-icon img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	border-radius: 50%;
}

.footer-brand-text {
	font-family: 'Noto Serif Thai', serif;
	font-size: 1.15rem;
	font-weight: 700;
	color: #FFFFFF;
}

.footer-tagline {
	font-size: 0.88rem;
	line-height: 1.7;
	color: rgba(255, 255, 255, 0.9);
	max-width: 280px;
}

.footer-heading {
	font-family: 'Noto Serif Thai', serif;
	color: #FFFFFF;
	font-size: 1rem;
	font-weight: 700;
	margin-bottom: 14px;
}

.footer-contact-col p {
	font-size: 0.9rem;
	color: rgba(255, 255, 255, 0.8);
	margin: 0 0 10px;
}

.footer-social {
	display: flex;
	gap: 10px;
	margin-top: 16px;
	flex-wrap: wrap;
}

.footer-social-link {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	color: #FFFFFF;
	text-decoration: none;
	font-size: 0.82rem;
	font-weight: 600;
	background: rgba(255, 255, 255, 0.16);
	border: 1px solid rgba(255, 255, 255, 0.35);
	padding: 7px 14px;
	border-radius: 20px;
	transition: background 0.2s;
}

.footer-social-link:hover {
	background: rgba(255, 255, 255, 0.3);
}

@media ( max-width : 768px) {
	.navbar-custom {
		flex-wrap: wrap;
		gap: 10px;
		padding: 12px 16px;
	}
	.navbar-custom .nav-brand-text {
		font-size: 20px;
	}
	.navbar-custom .lotus-icon {
		width: 46px;
		height: 46px;
		font-size: 24px;
	}
}

.promotion-banner-wrap {
	margin-top: 36px;
	text-align: center;
}

.promotion-banner-img {
	width: 100%;
	max-width: 1200px;
	height: auto;
	border-radius: 16px;
	display: inline-block;
	box-shadow: 0 6px 24px rgba(61, 37, 0, 0.15);
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
			class="nav-brand-text">บุญมี รับจัดงานบุญ</span>
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
				<a href="${pageContext.request.contextPath}/latestBooking"
					class="nav-link-item">การจอง</a>
				<a href="${pageContext.request.contextPath}/member/quotation/list"
					class="nav-link-item">ใบเสนอราคา</a>
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
		style="background-image:url('${pageContext.request.contextPath}/static/images/cover.png');">
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

	<%-- ========== ชวนสงสัย: ทำไมต้องทำบุญขึ้นบ้านใหม่ (ธีมไทย) พร้อมรูปเณรน้อย 2 ฝั่งหันเข้าหากล่อง ========== --%>
	<section class="cd-curiosity-teaser">

		<div class="cd-curiosity-side-img left">
			<img src="${pageContext.request.contextPath}/static/images/img23.png"
				alt="เณรน้อย">
		</div>

		<div class="cd-curiosity-card">
			<svg class="cd-curiosity-corner tl" viewBox="0 0 42 42">
            <path
					d="M0 0 H14 C14 4 12 6 8 6 C10 10 8 14 4 14 C4 18 2 20 0 20 Z"
					fill="#D9A441" />
            <path d="M0 0 H42 V3 H3 V42 H0 Z" fill="#D9A441" />
        </svg>
			<svg class="cd-curiosity-corner tr" viewBox="0 0 42 42">
            <path
					d="M0 0 H14 C14 4 12 6 8 6 C10 10 8 14 4 14 C4 18 2 20 0 20 Z"
					fill="#D9A441" />
            <path d="M0 0 H42 V3 H3 V42 H0 Z" fill="#D9A441" />
        </svg>
			<svg class="cd-curiosity-corner bl" viewBox="0 0 42 42">
            <path
					d="M0 0 H14 C14 4 12 6 8 6 C10 10 8 14 4 14 C4 18 2 20 0 20 Z"
					fill="#D9A441" />
            <path d="M0 0 H42 V3 H3 V42 H0 Z" fill="#D9A441" />
        </svg>
			<svg class="cd-curiosity-corner br" viewBox="0 0 42 42">
            <path
					d="M0 0 H14 C14 4 12 6 8 6 C10 10 8 14 4 14 C4 18 2 20 0 20 Z"
					fill="#D9A441" />
            <path d="M0 0 H42 V3 H3 V42 H0 Z" fill="#D9A441" />
        </svg>

			<div class="cd-curiosity-icon">
				<svg width="48" height="34" viewBox="0 0 48 34">
                <path d="M24 4 C24 4 20 12 24 20 C28 12 24 4 24 4 Z"
						fill="#A6222F" />
                <path d="M24 8 C24 8 16 13 15 22 C21 20 24 14 24 8 Z"
						fill="#D9A441" />
                <path d="M24 8 C24 8 32 13 33 22 C27 20 24 14 24 8 Z"
						fill="#D9A441" />
                <path d="M14 22 C14 22 22 24 24 30 C16 30 14 26 14 22 Z"
						fill="#A6222F" />
                <path d="M34 22 C34 22 26 24 24 30 C32 30 34 26 34 22 Z"
						fill="#A6222F" />
                <ellipse cx="24" cy="30" rx="10" ry="2" fill="#D9A441"
						opacity="0.4" />
            </svg>
			</div>

			<div class="cd-curiosity-question">
				ทำไมบริษัทหรือออฟฟิศจึงนิยมทำบุญ? ทำแล้วดีอย่างไร?</div>
			<div class="cd-curiosity-divider">
				<span></span><i>◆</i><span></span>
			</div>
			<div class="cd-curiosity-answer">การทำบุญบริษัทหรือออฟฟิศ
				เป็นโอกาสในการเสริมสิริมงคลให้กับสถานที่ทำงานและผู้ที่ปฏิบัติงานภายในองค์กร
				หลายบริษัทนิยมจัดพิธีทำบุญเพื่อสร้างขวัญและกำลังใจ
				รวมถึงเป็นการเริ่มต้นช่วงเวลาใหม่ ๆ ด้วยความเป็นสิริมงคล
				นอกจากนี้ยังช่วยสร้างความสามัคคีและความสัมพันธ์อันดีระหว่างผู้บริหารและพนักงาน
				ให้ทุกคนได้ร่วมกันทำกิจกรรมดี ๆ และสร้างบรรยากาศที่ดีในการทำงาน</div>
		</div>

		<div class="cd-curiosity-side-img right">
			<img src="${pageContext.request.contextPath}/static/images/img23.png"
				alt="เณรน้อย">
		</div>

	</section>

	<%-- ========== รู้จักงานทำบุญออฟฟิศ: ย้ายขึ้นบนสุด เป็นแบนเนอร์ภาพ + ไล่สีชมพู ========== --%>
	<section class="cd-intro-banner">
		<div class="cd-intro-banner-img">
			<img src="${pageContext.request.contextPath}/static/images/b3.jpg"
				alt="ทีมงานให้คำปรึกษาการจัดงาน">
		</div>
		<div class="cd-intro-banner-text">
			<div class="cd-intro-banner-text-inner">
				<div class="cd-intro-banner-title">รู้จักงานทำบุญออฟฟิศ</div>
				<p class="cd-intro-banner-desc">งานทำบุญออฟฟิศหรือบริษัท
					คือการนิมนต์พระสงฆ์มาประกอบพิธีสงฆ์ในสถานที่ทำงาน
					เพื่อความเป็นสิริมงคล ในการดำเนินธุรกิจ นิยมจัดเมื่อเปิดบริษัทใหม่
					ย้ายสำนักงาน หรือทำบุญประจำปีของกิจการ เชื่อว่าจะช่วยเสริมดวงการงาน
					สร้างขวัญกำลังใจให้พนักงาน และเป็นการแสดงความเคารพต่อสถานที่ทำงาน
					ก่อนเริ่มดำเนินกิจการหรือช่วงเวลาสำคัญของบริษัท</p>
			</div>
		</div>
	</section>

	<%-- ========== KANOK DIVIDER ========== --%>
	<svg viewBox="0 0 1200 48" xmlns="http://www.w3.org/2000/svg"
		preserveAspectRatio="none"
		style="display: block; width: 100%; height: 48px; background: #FFF5F8;">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#F3B6C8"
			stroke-width="1" opacity="0.6" />
    <g fill="#D6336C" opacity="0.55">
        <ellipse cx="600" cy="24" rx="18" ry="6"
			transform="rotate(-30 600 24)" />
        <ellipse cx="600" cy="24" rx="18" ry="6"
			transform="rotate(30 600 24)" />
        <ellipse cx="600" cy="24" rx="18" ry="6" />
        <circle cx="600" cy="24" r="4" fill="#F48FB1" />
        <ellipse cx="480" cy="24" rx="14" ry="5"
			transform="rotate(-30 480 24)" />
        <ellipse cx="480" cy="24" rx="14" ry="5"
			transform="rotate(30 480 24)" />
        <circle cx="480" cy="24" r="3" fill="#F48FB1" />
        <ellipse cx="720" cy="24" rx="14" ry="5"
			transform="rotate(-30 720 24)" />
        <ellipse cx="720" cy="24" rx="14" ry="5"
			transform="rotate(30 720 24)" />
        <circle cx="720" cy="24" r="3" fill="#F48FB1" />
        <ellipse cx="360" cy="24" rx="10" ry="4"
			transform="rotate(-30 360 24)" />
        <ellipse cx="360" cy="24" rx="10" ry="4"
			transform="rotate(30 360 24)" />
        <circle cx="360" cy="24" r="2.5" fill="#F48FB1" />
        <ellipse cx="840" cy="24" rx="10" ry="4"
			transform="rotate(-30 840 24)" />
        <ellipse cx="840" cy="24" rx="10" ry="4"
			transform="rotate(30 840 24)" />
        <circle cx="840" cy="24" r="2.5" fill="#F48FB1" />
        <ellipse cx="240" cy="24" rx="7" ry="3"
			transform="rotate(-30 240 24)" />
        <ellipse cx="240" cy="24" rx="7" ry="3"
			transform="rotate(30 240 24)" />
        <ellipse cx="960" cy="24" rx="7" ry="3"
			transform="rotate(-30 960 24)" />
        <ellipse cx="960" cy="24" rx="7" ry="3"
			transform="rotate(30 960 24)" />
    </g>
    <line x1="0" y1="6" x2="1200" y2="6" stroke="#F3B6C8"
			stroke-width="0.5" opacity="0.35" />
    <line x1="0" y1="42" x2="1200" y2="42" stroke="#F3B6C8"
			stroke-width="0.5" opacity="0.35" />
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

							<div class="cd-package-option-name"
								style="font-weight: bold; font-size: 1.1rem;">${p.ceremonyName}</div>
							<div class="cd-package-option-price"
								style="color: #d6336c; margin: 5px 0;">
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
											<li>ภาชนะ และภัตตาหาร ถวายข้าวพระพุทธ</li>
											<li>ดอกไม้ ธูปเทียน สายสิญจน์ แป้งเจิม</li>
											<li>เจ้าหน้าที่จัดเตรียมงาน, พิธีกร ค่าขนส่งอุปกรณ์</li>
										</c:when>
										<c:when test="${p.ceremonyName == 'แพ็กเกจอิ่มบุญ'}">
											<li>ติดต่อวัด นิมนต์คณะพระภิกษุสงฆ์ 7 รูป</li>
											<li>ชุดโต๊ะหมู่บูชา และพระประธาน</li>
											<li>ชุดอาสนะพระภิกษุสงฆ์ จำนวน 7 ชุด</li>
											<li>เครื่องใช้ และอุปกรณ์ประกอบพิธีสงฆ์</li>
											<li>พิธีกรดำเนินพิธีการสงฆ์</li>
											<li>ภาชนะ และภัตตาหาร ถวายข้าวพระพุทธ</li>
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
											<li>ภาชนะ และภัตตาหาร ถวายข้าวพระพุทธ</li>
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

				<li>✅ เลือกสินค้าและบริการเพิ่มเติมได้ เช่น ชุดสังฆทาน
					ชุดปิ่นโต อุปกรณ์พิธีอื่น ๆ เพื่อให้เหมาะกับความต้องการของแต่ละงาน</li>
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
				href="${pageContext.request.contextPath}/booking2?ceremonyId=${ceremony.ceremonyId}${not empty selectedDates ? '&dates=' : ''}${selectedDates}"
				class="cd-btn-book">จองเเบบระบุเอง${mainType}</a>
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
                    <stop offset="0%"
					stop-color="rgba(255,255,255,0.15)" />
                    <stop offset="50%"
					stop-color="rgba(255,255,255,0.9)" />
                    <stop offset="100%"
					stop-color="rgba(255,255,255,0.15)" />
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
