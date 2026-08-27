<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>หน้าหลัก - บุญมี รับจัดงานบุญ</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/home.css?v=23">
<style>
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
		box-shadow: 0 6px 24px rgba(184, 134, 47, 0.18);
	}

	/* ===== navbar dropdown (บริการ/แพ็กเกจ, ปฏิทิน) ===== */
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
		background: var(--white, #fff);
		border: 1px solid var(--accent-gold-pale, #EFDBA8);
		border-radius: 10px;
		box-shadow: 0 8px 24px rgba(184, 134, 47, 0.2);
		padding: 8px 0;
		z-index: 100;
	}
	.nav-dropdown-wrap:hover .nav-dropdown-panel,
	.nav-dropdown-wrap:focus-within .nav-dropdown-panel {
		display: block;
	}
	.nav-dropdown-link {
		display: block;
		padding: 10px 18px;
		font-size: 0.92rem;
		color: var(--brown-dark, #7A2340);
		text-decoration: none;
		white-space: nowrap;
	}
	.nav-dropdown-link:hover {
		background: var(--gold-pale, #F3D2DD);
	}
	.nav-dropdown-divider {
		border: 0;
		border-top: 1px solid var(--accent-gold-pale, #EFDBA8);
		margin: 6px 0;
	}
	/* การ์ดเงื่อนไขเดี่ยวเต็มความกว้าง */
	.conditions-grid-single {
		display: block;
	}

	/* ===== Hero: จัดข้อความให้ชิดฝั่งซ้าย (ฝั่งรูปวัด) แทนการจัดกึ่งกลาง ===== */
	.hero-content {
		text-align: left;
		margin-left: 5%;
		margin-right: auto;
		max-width: 620px;
	}
	.hero-content .hero-quote,
	.hero-content .hero-desc {
		text-align: left;
	}
	.hero-content .hero-divider {
		margin-left: 0;
		margin-right: auto;
	}

	/* ===== "ทำไมต้องเลือกบุญมี" — ขยายการ์ดให้ใหญ่ขึ้น (แยกสโคปจาก .meaning-grid ของหน้าปฏิทิน) ===== */
#whyChooseSection .meaning-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 30px 26px;
    max-width: 900px;
    margin: 30px auto 0;
}
#whyChooseSection .meaning-card {
    padding: 30px 26px;
    border-radius: 18px;
}
#whyChooseSection .meaning-card-title {
    font-size: 1.4rem;   /* เดิม 1.15rem */
    margin-bottom: 12px;
}
#whyChooseSection .meaning-card-desc {
    font-size: 0.95rem;
    line-height: 1.8;
}
@media (max-width: 860px) {
    #whyChooseSection .meaning-grid {
        grid-template-columns: 1fr;
    }
}

/* ===== ปุ่ม "ดูรีวิวทั้งหมด" ในการ์ด "ลูกค้าไว้วางใจ" ===== */
.btn-review-all {
	display: inline-block;
	margin-top: 10px;
	padding: 8px 22px;
	background: linear-gradient(90deg, #B85073, #CC7796);
	color: #fff;
	font-size: 0.9rem;
	font-weight: 600;
	border-radius: 30px;
	text-decoration: none;
	box-shadow: 0 4px 14px rgba(184, 80, 115, 0.25);
	transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.btn-review-all:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 18px rgba(184, 80, 115, 0.35);
	color: #fff;
}

/* ===== ดอกบัวตกแต่งด้านบนหัวข้อ "ขั้นตอนและเงื่อนไขการให้บริการ" ===== */
.section-lotus-deco {
	text-align: center;
	margin-bottom: 6px;
}
.section-lotus-img {
	width: 72px;
	height: 72px;
	object-fit: contain;
	opacity: 0.92;
}

/* ===== ขั้นตอนการให้บริการ: จัดเป็นแนวลูกศรเชื่อมขั้นตอน แถวเดียว 1-6 + ใช้ฟอนต์ Sarabun ทั้งหมด (ยกเว้นชื่อระบบ) ===== */
#stepsConditionsSection .section-title,
#stepsConditionsSection .subsection-title {
	font-family: 'Sarabun', sans-serif;
}

.ritual-flow-wrap {
	margin: 30px 0 8px;
}
.ritual-flow-row {
	display: flex;
	align-items: flex-start;
	justify-content: center;
	gap: 2px;
}

/* ให้กรอบของหัวข้อ "ขั้นตอนการให้บริการ" กว้างขึ้นกว่า container ปกติ
   เพื่อให้ 6 ขั้นตอน (พร้อมคำอธิบาย) อยู่แถวเดียวกันได้แบบอ่านง่าย */
#stepsConditionsSection .container {
	max-width: 1320px;
}
</style>
</head>
<body>

	<%-- ========== NAVBAR ========== --%>
<nav class="navbar-custom">
		<a class="navbar-brand-wrap"
			href="${pageContext.request.contextPath}/home"
			style="text-decoration: none;">
			<img src="${pageContext.request.contextPath}/static/images/logoo.png"
				alt="บุญมี รับจัดงานบุญ" class="lotus-icon">
			<span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
		</a>
		<div class="navbar-center">
			<a href="${pageContext.request.contextPath}/home"
				class="nav-link-item active">หน้าหลัก</a>

		<div class="nav-dropdown-wrap">
            <a href="javascript:void(0);" class="nav-link-item nav-dropdown-toggle">
                บริการ/แพ็กเกจ <span class="nav-caret">▾</span>
            </a>
            <div class="nav-dropdown-panel">
                <c:forEach var="t" items="${ceremonyTypes}">
                    <a href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}"
                       class="nav-dropdown-link">${t.mainName}</a>
                </c:forEach>
            </div>
        </div>

			<div class="nav-dropdown-wrap">
				<a href="${pageContext.request.contextPath}/calendar"
					class="nav-link-item nav-dropdown-toggle">
					ปฏิทิน <span class="nav-caret">▾</span>
				</a>
				<div class="nav-dropdown-panel">
					<a href="${pageContext.request.contextPath}/calendar#calendarSection"
						class="nav-dropdown-link">ปฏิทิน (ฤกษ์ดี)</a>
					<a href="${pageContext.request.contextPath}/calendar#lannaCalendarSection"
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
							class="dropdown-link">โปรไฟล์ของฉัน</a>
						<a href="${pageContext.request.contextPath}/logout"
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

	<%-- ========== LOGIN SUCCESS ALERT ========== --%>
	<c:if test="${param.loginSuccess != null}">
		<div id="loginAlert" class="login-alert-toast">
			<div class="toast-icon">✓</div>
			<div class="toast-body">
				<span class="toast-title">เข้าสู่ระบบสำเร็จ!</span> <span
					class="toast-user">ยินดีต้อนรับคุณ
					${sessionScope.user.memberFirstName}
					${sessionScope.user.memberLastName}</span>
			</div>
		</div>
	</c:if>

	<%-- ========== HERO ========== --%>
	<div class="hero-section">
			<div class="hero-slider" id="heroSlider">
			    <div class="hero-slide active">
			        <img src="${pageContext.request.contextPath}/static/images/Hero-banner/cover1.png" alt="cover">
			    </div>
			    <div class="hero-slide">
			        <img src="${pageContext.request.contextPath}/static/images/Hero-banner/cover.png" alt="cover3">
			    </div>
			    <div class="hero-slide">
			        <img src="${pageContext.request.contextPath}/static/images/Hero-banner/cover6.png" alt="cover4">
			    </div>
			    <div class="hero-slide">
			        <img src="${pageContext.request.contextPath}/static/images/Hero-banner/cover7.png" alt="cover5">
			    </div>
			</div>
		<div class="hero-overlay"></div>

		<div class="hero-content">
			<h1 class="hero-quote">"จัดงานบุญให้ง่ายขึ้น<br>มีทีมงานช่วยดูแล"</h1>
			<p class="hero-desc">มีทีมงานคอยดูแลทุกขั้นตอนของพิธีสงฆ์<br>
            ตั้งแต่การนิมนต์พระ ไปจนถึงการจัดงานอย่างครบครัน<br>

			<div style="display: flex; gap: 14px; justify-content: flex-start; flex-wrap: wrap;">
				<a href="#stepsConditionsSection" class="hero-cta">ดูขั้นตอนและเงื่อนไขการจอง</a>
			</div>
			<div class="hero-divider"></div>
		</div>
	</div>
	<%-- ========== UNIFIED CARD: ขั้นตอน + เงื่อนไข + ทำไมต้องเลือกเรา + แกลเลอรี ========== --%>
	<div class="unified-home-wrap">
	<div class="unified-home-card">

	<%-- ========== ขั้นตอนและเงื่อนไขการให้บริการ ========== --%>
	<section class="section-pad-unified section-conditions" id="stepsConditionsSection">
	    <div class="container">
	        <div class="section-lotus-deco">
				<img src="${pageContext.request.contextPath}/static/images/img25.png"
					alt="ดอกบัว" class="section-lotus-img">
			</div>
	        <div class="section-ornament">
				<div class="ornament-line"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-diamond"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-line right"></div>
			</div>
			<div class="section-header">
				<h2 class="section-title">ขั้นตอนและเงื่อนไขการให้บริการ</h2>
				<p class="section-subtitle">บริการรับจัดงานบุญตามประเพณีภาคเหนือ
					ตรวจสอบและจองงานบุญกับเราได้ง่าย ๆ พร้อมเงื่อนไขที่ควรทราบก่อนจอง</p>
				<div class="gold-line"></div>
			</div>

			<%-- ----- หัวข้อย่อยที่ 1: ขั้นตอนการให้บริการ (แถวเดียว 1-6) ----- --%>
			<div class="subsection-block">
				<h3 class="subsection-title"><span class="subsection-num">1</span>ขั้นตอนการให้บริการ</h3>
				<div class="condition-card condition-card-full">
					<div class="ritual-flow-wrap">
						<div class="ritual-flow-row ritual-flow-row-single">

							<div class="ritual-step-item">
								<p class="ritual-step-title">เลือกวันและฤกษ์งาน</p>
								<div class="ritual-step-img-wrap">
									<img src="${pageContext.request.contextPath}/static/images/img18.png"
										 alt="เลือกวันและฤกษ์งาน" class="ritual-step-img">
									<span class="ritual-step-num">1</span>
								</div>
								<p class="ritual-step-desc">ตรวจสอบวันว่างและฤกษ์ดีผ่านปฏิทิน (ไทย/ล้านนา) โดยสัญลักษณ์สีเขียวคือวันว่างที่คุณสามารถจองได้ สีแดงคือวันที่รับงานเต็มแล้ว</p>
							</div>

							<div class="ritual-flow-arrow" aria-hidden="true">
								<svg viewBox="0 0 40 24" xmlns="http://www.w3.org/2000/svg">
									<path d="M2 12 H30" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-dasharray="2 6"/>
									<path d="M23 4 L35 12 L23 20" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>
							</div>

							<div class="ritual-step-item">
								<p class="ritual-step-title">เลือกแพ็กเกจหรือแจ้งรายละเอียด</p>
								<div class="ritual-step-img-wrap">
									<img src="${pageContext.request.contextPath}/static/images/img13.jpg"
										 alt="เลือกแพ็กเกจหรือแจ้งรายละเอียด" class="ritual-step-img">
									<span class="ritual-step-num">2</span>
								</div>
								<p class="ritual-step-desc">เลือกใช้บริการผ่านแพ็กเกจที่ทางร้านจัดไว้ หรือกรอกแบบฟอร์มเพื่อระบุความต้องการเฉพาะตัว เช่น จำนวนพระสงฆ์ และรูปแบบชุดภัตตาหาร/สังฆทาน</p>
							</div>

							<div class="ritual-flow-arrow" aria-hidden="true">
								<svg viewBox="0 0 40 24" xmlns="http://www.w3.org/2000/svg">
									<path d="M2 12 H30" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-dasharray="2 6"/>
									<path d="M23 4 L35 12 L23 20" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>
							</div>

							<div class="ritual-step-item">
								<p class="ritual-step-title">ทีมงานเข้าดูสถานที่จริง</p>
								<div class="ritual-step-img-wrap">
									<img src="${pageContext.request.contextPath}/static/images/img19.jpeg"
										 alt="ทีมงานเข้าดูสถานที่จริง" class="ritual-step-img">
									<span class="ritual-step-num">3</span>
								</div>
								<p class="ritual-step-desc">ทีมงานติดต่อเพื่อเข้าสำรวจพื้นที่ วางแผนจัดอุปกรณ์ และให้คำแนะนำในการเตรียมสถานที่เพื่อให้พิธีเป็นไปอย่างเหมาะสม</p>
							</div>

							<div class="ritual-flow-arrow" aria-hidden="true">
								<svg viewBox="0 0 40 24" xmlns="http://www.w3.org/2000/svg">
									<path d="M2 12 H30" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-dasharray="2 6"/>
									<path d="M23 4 L35 12 L23 20" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>
							</div>

							<div class="ritual-step-item">
								<p class="ritual-step-title">ออกใบเสนอราคา</p>
								<div class="ritual-step-img-wrap">
									<img src="${pageContext.request.contextPath}/static/images/img20.png"
										 alt="ออกใบเสนอราคา" class="ritual-step-img">
									<span class="ritual-step-num">4</span>
								</div>
								<p class="ritual-step-desc">ทางร้านสรุปรายละเอียดงานและจัดทำใบเสนอราคา ซึ่งสามารถยืดหยุ่นปรับเปลี่ยนได้ตามความต้องการจริงของลูกค้า</p>
							</div>

							<div class="ritual-flow-arrow" aria-hidden="true">
								<svg viewBox="0 0 40 24" xmlns="http://www.w3.org/2000/svg">
									<path d="M2 12 H30" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-dasharray="2 6"/>
									<path d="M23 4 L35 12 L23 20" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>
							</div>

							<div class="ritual-step-item">
								<p class="ritual-step-title">ยืนยันการจอง</p>
								<div class="ritual-step-img-wrap">
									<img src="${pageContext.request.contextPath}/static/images/img21.png"
										 alt="ยืนยันการจอง" class="ritual-step-img">
									<span class="ritual-step-num">5</span>
								</div>
								<p class="ritual-step-desc">ลูกค้าทำการยืนยันใบเสนอราคา เพื่อเสร็จสิ้นการจอง</p>
							</div>

							<div class="ritual-flow-arrow" aria-hidden="true">
								<svg viewBox="0 0 40 24" xmlns="http://www.w3.org/2000/svg">
									<path d="M2 12 H30" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-dasharray="2 6"/>
									<path d="M23 4 L35 12 L23 20" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>
							</div>

							<div class="ritual-step-item">
								<p class="ritual-step-title">เตรียมงานและประกอบพิธี</p>
								<div class="ritual-step-img-wrap">
									<img src="${pageContext.request.contextPath}/static/images/img15.jpg"
										 alt="เตรียมงานและประกอบพิธี" class="ritual-step-img">
									<span class="ritual-step-num">6</span>
								</div>
								<p class="ritual-step-desc">ทีมงานจัดเตรียมโต๊ะหมู่บูชา อาสนะสงฆ์ และเครื่องสักการะให้พร้อม ก่อนดำเนินการประกอบพิธีตามลำดับขั้นตอนทางศาสนา</p>
							</div>

						</div>
					</div>
				</div>
			</div>

			<div class="unified-divider"></div>

			<%-- ----- หัวข้อย่อยที่ 2: เงื่อนไขการให้บริการ (2 คอลัมน์ รูป + list) ----- --%>
			<div class="subsection-block">
				<h3 class="subsection-title"><span class="subsection-num">2</span>เงื่อนไขการให้บริการ</h3>
				<div class="condition-card condition-card-split">
					<div class="condition-image-side">
						<img src="${pageContext.request.contextPath}/static/images/condition-showcase.png"
							alt="เครื่องสักการะและดอกบัว">
					</div>
					<div class="condition-list-side">
						<ul class="condition-list-check">
							<li>รับจัดงานบุญตามประเพณีภาคเหนือ
								ถูกต้องตามหลักพิธีการ</li>
							<li>การนิมนต์พระ ทางร้านเป็นผู้ดำเนินการนิมนต์ให้
								โดยครอบคลุมพื้นที่ห่างจากสถานที่จัดงานไม่เกิน 50 กิโลเมตร
								(ไม่ข้ามจังหวัด)</li>
							<li>การจองคิวขึ้นอยู่กับจำนวนทีมงานที่ว่างในวันนั้น ๆ
								หากทีมงานเต็มทุกทีมในวันที่เลือก ระบบจะแจ้งว่าวันนั้นไม่สามารถจองได้</li>
							<li>ลูกค้าเตรียมเพียงปัจจัยถวายพระ
								ส่วนอุปกรณ์และการจัดเตรียมอื่น ๆ ทางร้านดูแลให้ทั้งหมด</li>
							<li>ส่วนลด 1,500 บาท หากคุณลูกค้า นิมนต์ และ รับส่งพระเอง</li>
						</ul>
					</div>
				</div>
			</div>
	    </div>
	</section>

	<div class="unified-divider"></div>

	<%-- ========== ทำไมต้องเลือกบุญมี ========== --%>
	<section class="section-pad-unified section-packages" id="whyChooseSection">
		<div class="container">
			<div class="section-ornament">
				<div class="ornament-line"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-diamond"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-line right"></div>
			</div>
			<div class="section-header">
				<h2 class="section-title">ทำไมต้องเลือกบริการจากเรา</h2>
				<p class="section-subtitle">ดูแลพิธีสงฆ์ให้ครบ จบในที่เดียว
					ด้วยทีมงานที่เข้าใจประเพณีภาคเหนือ</p>
				<div class="gold-line"></div>
			</div>

			<div class="meaning-block" style="margin-top: 0;">
				<div class="meaning-grid">
					<div class="meaning-card">
						<div class="meaning-card-icon">🙏</div>
						<div class="meaning-card-title">ประสบการณ์</div>
						<div class="meaning-card-desc"><%-- TODO: ใส่จำนวนปีที่เปิดให้บริการจริง --%>รับจัดงานบุญตามประเพณีภาคเหนือมาอย่างต่อเนื่อง</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-icon">📿</div>
						<div class="meaning-card-title">ทีมงานมืออาชีพ</div>
						<div class="meaning-card-desc">ดูแลตั้งแต่การนิมนต์พระ
							จนถึงจัดอุปกรณ์พิธีสงฆ์ให้ครบทุกขั้นตอน</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-icon">⭐</div>
						<div class="meaning-card-title">ลูกค้าไว้วางใจ</div>
						<div class="meaning-card-desc">อ่านรีวิวจากเจ้าภาพ<br>ที่เคยใช้บริการจริง</div>
						<a href="${pageContext.request.contextPath}/reviews" class="btn-review-all">ดูรีวิวทั้งหมด</a>
					</div>
				</div>
			</div>

		</div>
	</section>

	<div class="unified-divider"></div>

	<%-- ========== GALLERY SECTION ========== --%>
	<section class="section-pad-unified section-gallery">
		<div class="container">
			<div class="section-ornament">
				<div class="ornament-line"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-diamond"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-line right"></div>
			</div>
			<div class="section-header">
				<h2 class="section-title">จากความตั้งใจ
					สู่ความประทับใจที่บอกต่อ</h2>
				<p class="section-subtitle">ร่วมสัมผัสรอยยิ้มและความสำเร็จในทุกพิธีสำคัญที่ได้รับความไว้วางใจจากครอบครัวมากมาย</p>
				<div class="gold-line"></div>
				<p style="margin-top: 15px; font-size: 0.9rem; color: #C98A2F;">[อัปเดตบรรยากาศงานจริงแบบเรียลไทม์ได้ที่
					Facebook และ YouTube ของเรา]</p>
			</div>
			<div class="gallery-grid" id="galleryGrid"></div>
		</div>
	</section>

	</div>
	</div>
	<%-- ========== END UNIFIED CARD ========== --%>

	<%-- ========== FOOTER ========== --%>
	<footer class="site-footer">
		<div class="footer-top">
			<svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
				style="display: block; width: 100%; height: 8px;">
            <rect width="1200" height="8" fill="url(#footerGrad)" />
            <defs>
                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%"
					y2="0%">
                    <stop offset="0%" stop-color="rgba(204,154,63,0.15)" />
                    <stop offset="50%" stop-color="rgba(204,154,63,0.9)" />
                    <stop offset="100%" stop-color="rgba(204,154,63,0.15)" />
                </linearGradient>
            </defs>
        </svg>
		</div>
		<div class="container footer-content footer-content-slim">
			<div class="footer-col footer-brand-col">
				<div class="footer-brand">
					<img src="${pageContext.request.contextPath}/static/images/logoo.png"
						alt="บุญมี รับจัดงานบุญ" class="lotus-icon">
					<span class="footer-brand-text">บุญมีนำพา รับจัดงานบุญ</span>
				</div>
				<p class="footer-tagline">รับจัดงานบุญ
					ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
				<div class="footer-social">
					<a href="#" class="footer-social-link">📘 Facebook</a>
					<a href="#" class="footer-social-link">▶️ YouTube</a>
					<a href="#" class="footer-social-link">💬 LINE OA</a>
				</div>
			</div>

			<div class="footer-col footer-contact-col">
				<h4 class="footer-heading">ติดต่อเรา</h4>
				<%-- TODO: ใส่เบอร์โทร / LINE OA / อีเมลจริงของร้านแทนที่ตรงนี้ --%>
				<p>📞 โทร. 08X-XXX-XXXX</p>
				<p>💬 LINE OA: @boonmee</p>
				<p>✉️ boonmee@gmail.com</p>
				<p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
			</div>
		</div>

	</footer>

	<%-- ========== SCRIPT ZONE ========== --%>
	<script>
    window.contextPath = "${pageContext.request.contextPath}";

    window.ceremonyTypes = [
        <c:forEach var="t" items="${ceremonyTypes}" varStatus="st">
            {
                id: ${t.representativeId},
                name: "${t.mainName}",
                image: window.contextPath + "/static/images/${t.image}",
                packageCount: ${t.packageCount}
            }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    (function () {
        var heroSlides = document.querySelectorAll('#heroSlider .hero-slide');
        if (!heroSlides.length) return;
        var heroCurrent = 0;
        setInterval(function () {
            heroSlides[heroCurrent].classList.remove('active');
            heroCurrent = (heroCurrent + 1) % heroSlides.length;
            heroSlides[heroCurrent].classList.add('active');
        }, 5000);
    })();

    (function () {
        var slides = document.querySelectorAll('#bannerSlider .banner-slide');
        var dotsWrap = document.getElementById('bannerDots');
        if (!slides.length || !dotsWrap) return;

        var current = 0;
        var timer = null;

        slides.forEach(function (_, i) {
            var dot = document.createElement('button');
            dot.className = 'banner-dot' + (i === 0 ? ' active' : '');
            dot.setAttribute('aria-label', 'สไลด์ที่ ' + (i + 1));
            dot.addEventListener('click', function () {
                goTo(i);
                restartTimer();
            });
            dotsWrap.appendChild(dot);
        });

        var dots = dotsWrap.querySelectorAll('.banner-dot');

        function goTo(index) {
            slides[current].classList.remove('active');
            dots[current].classList.remove('active');
            current = index;
            slides[current].classList.add('active');
            dots[current].classList.add('active');
        }

        function next() {
            goTo((current + 1) % slides.length);
        }

        function restartTimer() {
            if (timer) clearInterval(timer);
            timer = setInterval(next, 4000);
        }

        restartTimer();
    })();
    </script>
	<script src="${pageContext.request.contextPath}/static/js/home.js?v=13"></script>
</body>
</html>
