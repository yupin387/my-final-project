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
	href="${pageContext.request.contextPath}/static/css/home.css?v=16">
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
		box-shadow: 0 6px 24px rgba(61, 37, 0, 0.15);
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
		border: 1px solid var(--gold-pale, #e8cc70);
		border-radius: 10px;
		box-shadow: 0 8px 24px rgba(61, 37, 0, 0.15);
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
		color: var(--brown-dark, #3d2500);
		text-decoration: none;
		white-space: nowrap;
	}
	.nav-dropdown-link:hover {
		background: var(--gold-pale, #fff8e1);
	}
	.nav-dropdown-divider {
		border: 0;
		border-top: 1px solid var(--gold-pale, #e8cc70);
		margin: 6px 0;
	}
	/* การ์ดเงื่อนไขเดี่ยวเต็มความกว้าง (ตัด "ขั้นตอนการจอง" ออกแล้ว) */
	.conditions-grid-single {
		display: block;
	}

	/* ===== reviews teaser section (การ์ดใช้ CSS .review-card เดิมจาก home.css) ===== */
	.reviews-teaser .reviews-grid {
		margin-bottom: 24px;
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
			<span class="nav-brand-text">บุญมี
				รับจัดงานบุญ</span>
		</a>
		<div class="navbar-center">
			<a href="${pageContext.request.contextPath}/home"
				class="nav-link-item active">หน้าหลัก</a>

			<%-- ===== เมนู บริการ/แพ็กเกจ (dropdown)
			     แพ็กเกจย้ายไปอยู่ในหน้ารายละเอียดของแต่ละงานบุญแล้ว ตัวเมนูหลักจึงไม่ลิงก์ไปที่ไหน
			     เป็นแค่ตัวเปิด dropdown ให้เลือกงานบุญที่ต้องการดูแพ็กเกจแทน ===== --%>
			<div class="nav-dropdown-wrap">
				<a href="javascript:void(0);" class="nav-link-item nav-dropdown-toggle">
					บริการ/แพ็กเกจ <span class="nav-caret">▾</span>
				</a>
				<div class="nav-dropdown-panel">
					<c:forEach var="t" items="${ceremonyTypes}">
						<a href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}"
							class="nav-dropdown-link">${t.mainName}</a>
					</c:forEach>
					<hr class="nav-dropdown-divider">
					<a href="${pageContext.request.contextPath}/calendar"
						class="nav-dropdown-link">📅 ดูปฏิทินเพื่อเลือกวัน</a>
				</div>
			</div>
			

			<%-- ===== เมนู ปฏิทิน (dropdown แยกฤกษ์ดี / ล้านนา) — ลิงก์ไปหน้า /calendar ===== --%>
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
							class="dropdown-link">โปรไฟล์ของฉัน</a> 
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

	<%-- ========== HERO (ข้อความชิดฝั่งซ้าย ทับรูปวัด) ========== --%>
	<div class="hero-section">
		<div class="hero-overlay"></div>
		<div class="hero-content">
			<h1 class="hero-quote">"จัดงานบุญให้ง่ายขึ้น<br>มีทีมงานช่วยดูแล"</h1>
			<p class="hero-desc">มีทีมงานคอยช่วยดูแลเรื่องพิธีสงฆ์
				ตั้งแต่การนิมนต์พระไปจนถึงวันจัดงานจริง<br>
				
			<div style="display: flex; gap: 14px; justify-content: flex-start; flex-wrap: wrap;">
				<a href="#conditionsSection" class="hero-cta">ดูขั้นตอนและเงื่อนไขการจอง</a>

			</div>
			<div class="hero-divider"></div>
		</div>
	</div>

	<%-- ========== BANNER SLIDER ========== --%>
	<section class="banner-slider-section">
		<div class="container">
			<div class="banner-slider" id="bannerSlider">
				<div class="banner-slide active">
					<img src="${pageContext.request.contextPath}/static/images/Bn1.png"
						alt="Bn1">
				</div>
				<div class="banner-slide">
					<img src="${pageContext.request.contextPath}/static/images/Bn2.png"
						alt="Bn2">
				</div>
				<div class="banner-slide">
					<img src="${pageContext.request.contextPath}/static/images/Bn3.png"
						alt="Bn3">
				</div>
			</div>
			<div class="banner-dots" id="bannerDots"></div>
		</div>
	</section>

	<%-- ========== THAI WAVE DIVIDER: HERO → CONDITIONS ========== --%>
	<svg class="thai-divider" viewBox="0 0 1200 48"
		xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none"
		style="display: block; background: #ffffff;">
    <path
			d="M0,0 L1200,0 L1200,16 Q1100,40 1000,20 Q900,2 800,28 Q700,48 600,28 Q500,8 400,30 Q300,48 200,24 Q100,4 0,22 Z"
			fill="#3D2500" opacity="0.07" />
    <path
			d="M0,8 Q150,44 300,18 Q450,-6 600,22 Q750,48 900,20 Q1050,-6 1200,18 L1200,48 L0,48 Z"
			fill="#FFF8E1" />
    <path
			d="M0,26 Q100,10 200,26 Q300,44 400,26 Q500,10 600,26 Q700,44 800,26 Q900,10 1000,26 Q1100,44 1200,26"
			stroke="#D4A017" stroke-width="1.5" fill="none" opacity="0.5" />
    <circle cx="200" cy="26" r="3" fill="#D4A017" opacity="0.5" />
    <circle cx="400" cy="26" r="3" fill="#D4A017" opacity="0.5" />
    <circle cx="600" cy="26" r="3" fill="#D4A017" opacity="0.5" />
    <circle cx="800" cy="26" r="3" fill="#D4A017" opacity="0.5" />
    <circle cx="1000" cy="26" r="3" fill="#D4A017" opacity="0.5" />
</svg>

	<%-- ========== CONDITIONS (เหลือเฉพาะ "เงื่อนไขการให้บริการ") ========== --%>
	<section class="section-pad section-conditions" id="conditionsSection">
		<div class="container">
			<div class="section-ornament">
				<div class="ornament-line"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-diamond"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-line right"></div>
			</div>
			<div class="section-header">
				<h2 class="section-title">บริการรับจัดงานบุญตามประเพณีภาคเหนือ</h2>
				<p class="section-subtitle">เงื่อนไขการให้บริการ
					โปรดอ่านก่อนทำการจอง</p>
				<div class="gold-line"></div>
			</div>

			<div class="conditions-grid conditions-grid-single">
				<div class="condition-card condition-card-full">
					<h3 class="condition-card-title">เงื่อนไขการให้บริการ</h3>
					<ul class="condition-list">
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
	</section>

	<%-- ========== THAI KANOK DIVIDER: CONDITIONS → RITUAL STEPS ========== --%>
	<svg class="thai-divider" viewBox="0 0 1200 48"
		xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none"
		style="display: block; background: linear-gradient(#fff, #FFF8E1);">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#E8CC70"
			stroke-width="1" opacity="0.6" />
    <g fill="#D4A017" opacity="0.55">
        <ellipse cx="600" cy="24" rx="18" ry="6"
			transform="rotate(-30 600 24)" />
        <ellipse cx="600" cy="24" rx="18" ry="6"
			transform="rotate(30 600 24)" />
        <ellipse cx="600" cy="24" rx="18" ry="6" />
        <circle cx="600" cy="24" r="4" fill="#E8BB3A" />
        <ellipse cx="480" cy="24" rx="14" ry="5"
			transform="rotate(-30 480 24)" />
        <ellipse cx="480" cy="24" rx="14" ry="5"
			transform="rotate(30 480 24)" />
        <circle cx="480" cy="24" r="3" fill="#E8BB3A" />
        <ellipse cx="720" cy="24" rx="14" ry="5"
			transform="rotate(-30 720 24)" />
        <ellipse cx="720" cy="24" rx="14" ry="5"
			transform="rotate(30 720 24)" />
        <circle cx="720" cy="24" r="3" fill="#E8BB3A" />
        <ellipse cx="360" cy="24" rx="10" ry="4"
			transform="rotate(-30 360 24)" />
        <ellipse cx="360" cy="24" rx="10" ry="4"
			transform="rotate(30 360 24)" />
        <circle cx="360" cy="24" r="2.5" fill="#E8BB3A" />
        <ellipse cx="840" cy="24" rx="10" ry="4"
			transform="rotate(-30 840 24)" />
        <ellipse cx="840" cy="24" rx="10" ry="4"
			transform="rotate(30 840 24)" />
        <circle cx="840" cy="24" r="2.5" fill="#E8BB3A" />
        <ellipse cx="240" cy="24" rx="7" ry="3"
			transform="rotate(-30 240 24)" />
        <ellipse cx="240" cy="24" rx="7" ry="3"
			transform="rotate(30 240 24)" />
        <ellipse cx="960" cy="24" rx="7" ry="3"
			transform="rotate(-30 960 24)" />
        <ellipse cx="960" cy="24" rx="7" ry="3"
			transform="rotate(30 960 24)" />
    </g>
    <line x1="0" y1="4" x2="1200" y2="4" stroke="#E8CC70"
			stroke-width="0.5" opacity="0.4" />
    <line x1="0" y1="44" x2="1200" y2="44" stroke="#E8CC70"
			stroke-width="0.5" opacity="0.4" />
</svg>

    <%-- ========== ขั้นตอนการให้บริการ (หัวข้อใหญ่กึ่งกลาง เหมือนหัวข้ออื่น ๆ) ========== --%>
	<section class="section-pad section-conditions" id="ritualStepsSection">
	    <div class="container">
	        <div class="section-ornament">
				<div class="ornament-line"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-diamond"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-line right"></div>
			</div>
			<div class="section-header">
				<h2 class="section-title">ขั้นตอนการให้บริการ</h2>
				<p class="section-subtitle">ตรวจสอบและจองงานบุญกับเราได้ง่าย ๆ เพียงไม่กี่ขั้นตอน</p>
				<div class="gold-line"></div>
			</div>

	        <div class="condition-card condition-card-full">
	            <div class="ritual-steps-grid">
	                <%-- ขั้นตอนที่ 1: เลือกวันและฤกษ์งาน --%>
	                <div class="ritual-step-item">
	                    <div class="ritual-step-content-wrap">
	                         <p class="ritual-step-label" style="margin-bottom: 25px;">ขั้นตอนที่ 1: <strong>เลือกวันและฤกษ์งาน</strong></p>
	                         <div class="ritual-step-img-wrap">
	                             <img src="${pageContext.request.contextPath}/static/images/img18.png"
	                                  alt="เลือกวันและฤกษ์งาน" class="ritual-step-img">
	                         </div>
	                         <p class="ritual-step-desc">ตรวจสอบวันว่างและฤกษ์ดีผ่านปฏิทิน (ไทย/ล้านนา) โดยสัญลักษณ์สีเขียวคือวันว่างที่คุณสามารถจองได้ และกากบาทคือวันที่เต็มแล้ว</p>
	                    </div>
	                </div>
	
	                <%-- ขั้นตอนที่ 2: เลือกแพ็กเกจหรือแจ้งรายละเอียด --%>
	                <div class="ritual-step-item">
	                    <div class="ritual-step-content-wrap">
	                         <p class="ritual-step-label" style="margin-bottom: 25px;">ขั้นตอนที่ 2: <strong>เลือกแพ็กเกจหรือแจ้งรายละเอียด</strong></p>
	                         <div class="ritual-step-img-wrap">
	                             <img src="${pageContext.request.contextPath}/static/images/img13.jpg"
	                                  alt="เลือกแพ็กเกจหรือแจ้งรายละเอียด" class="ritual-step-img">
	                         </div>
	                         <p class="ritual-step-desc">เลือกใช้บริการผ่านแพ็กเกจที่ทางร้านจัดไว้ หรือกรอกแบบฟอร์มเพื่อระบุความต้องการเฉพาะตัว เช่น จำนวนพระสงฆ์ และรูปแบบชุดภัตตาหาร/สังฆทาน</p>
	                    </div>
	                </div>
	                
	                <%-- ขั้นตอนที่ 3: ทีมงานเข้าดูสถานที่จริง --%>
	                <div class="ritual-step-item">
	                    <div class="ritual-step-content-wrap">
	                         <p class="ritual-step-label" style="margin-bottom: 25px;">ขั้นตอนที่ 3: <strong>ทีมงานเข้าดูสถานที่จริง</strong></p>
	                         <div class="ritual-step-img-wrap">
	                             <img src="${pageContext.request.contextPath}/static/images/img19.jpeg"
	                                  alt="ทีมงานเข้าดูสถานที่จริง" class="ritual-step-img">
	                         </div>
	                         <p class="ritual-step-desc">ทีมงานติดต่อเพื่อเข้าสำรวจพื้นที่ วางแผนจัดอุปกรณ์ และให้คำแนะนำในการเตรียมสถานที่เพื่อให้พิธีเป็นไปอย่างเหมาะสม</p>
	                    </div>
	                </div>
	
	                <%-- ขั้นตอนที่ 4: ออกใบเสนอราคา --%>
	                <div class="ritual-step-item">
	                    <div class="ritual-step-content-wrap">
	                         <p class="ritual-step-label" style="margin-bottom: 25px;">ขั้นตอนที่ 4: <strong>ออกใบเสนอราคา</strong></p>
	                         <div class="ritual-step-img-wrap">
	                             <img src="${pageContext.request.contextPath}/static/images/img20.png"
	                                  alt="ออกใบเสนอราคา" class="ritual-step-img">
	                         </div>
	                         <p class="ritual-step-desc">ทางร้านสรุปรายละเอียดงานและจัดทำใบเสนอราคา ซึ่งสามารถยืดหยุ่นปรับเปลี่ยนได้ตามความต้องการจริงของลูกค้า</p>
	                    </div>
	                </div>
	
	                <%-- ขั้นตอนที่ 5: ยืนยันการจอง --%>
	                <div class="ritual-step-item">
	                    <div class="ritual-step-content-wrap">
	                        <p class="ritual-step-label" style="margin-bottom: 25px;">ขั้นตอนที่ 5: <strong>ยืนยันการจอง</strong></p>
	                        <div class="ritual-step-img-wrap">
	                             <img src="${pageContext.request.contextPath}/static/images/img21.png"
	                                  alt="ยืนยันการจอง" class="ritual-step-img">
	                        </div>
	                         <p class="ritual-step-desc">ลูกค้าทำการยืนยันใบเสนอราคา เพื่อเสร็จสิ้นการจอง</p>
	                    </div>
	                </div>
	
	                <%-- ขั้นตอนที่ 6: เตรียมงานและประกอบพิธี --%>
	                <div class="ritual-step-item">
	                    <div class="ritual-step-content-wrap">
	                        <p class="ritual-step-label" style="margin-bottom: 25px;">ขั้นตอนที่ 6: <strong>เตรียมงานและประกอบพิธี</strong></p>
	                        <div class="ritual-step-img-wrap">
	                             <img src="${pageContext.request.contextPath}/static/images/img15.jpg"
	                                  alt="เตรียมงานและประกอบพิธี" class="ritual-step-img">
	                        </div>
	                         <p class="ritual-step-desc">ทีมงานจัดเตรียมโต๊ะหมู่บูชา อาสนะสงฆ์ และเครื่องสักการะให้พร้อม ก่อนดำเนินการประกอบพิธีตามลำดับขั้นตอนทางศาสนา</p>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</section>

	<%-- ========== THAI KANOK DIVIDER: RITUAL STEPS → WHY CHOOSE US ========== --%>
	<svg class="thai-divider" viewBox="0 0 1200 48"
		xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none"
		style="display: block; background: #FFF8E1;">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#E8CC70"
			stroke-width="1" opacity="0.6" />
    <circle cx="600" cy="24" r="4" fill="#E8BB3A" />
</svg>

	<%-- ========== ทำไมเลือกบุญมี (ใช้แทนที่ packages showcase เดิม)
	     ใช้ .meaning-block / .meaning-grid / .meaning-card ที่มีอยู่แล้วใน home.css
	     (เดิมเตรียมไว้สำหรับ "ความหมายวันดี" แต่ไม่เคยถูกเรียกใช้ในหน้านี้)
	     ตัวเลขด้านล่างเป็นตัวอย่าง โปรดแก้เป็นข้อมูลจริงของร้าน ========== --%>
	<section class="section-pad section-packages" id="whyChooseSection">
		<div class="container">
			<div class="section-ornament">
				<div class="ornament-line"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-diamond"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-line right"></div>
			</div>
			<div class="section-header">
				<h2 class="section-title">ทำไมต้องเลือกบุญมี</h2>
				<p class="section-subtitle">ดูแลพิธีสงฆ์ให้ครบ จบในที่เดียว
					ด้วยทีมงานที่เข้าใจประเพณีภาคเหนือ</p>
				<div class="gold-line"></div>
			</div>

			<div class="meaning-block" style="margin-top: 0;">
				<div class="meaning-grid">
					<div class="meaning-card">
						<div class="meaning-card-title">🙏 ประสบการณ์</div>
						<div class="meaning-card-desc"><%-- TODO: ใส่จำนวนปีที่เปิดให้บริการจริง --%>รับจัดงานบุญตามประเพณีภาคเหนือมาอย่างต่อเนื่อง</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">📿 ทีมงานมืออาชีพ</div>
						<div class="meaning-card-desc">ดูแลตั้งแต่การนิมนต์พระ
							จนถึงจัดอุปกรณ์พิธีสงฆ์ให้ครบทุกขั้นตอน</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">🎉 จัดมาแล้วหลายพื้นที่</div>
						<div class="meaning-card-desc"><%-- TODO: ใส่จำนวนงานที่จัดมาแล้วจริง --%>ครอบคลุมงานบุญบ้าน งานขึ้นบ้านใหม่ และงานออฟฟิศ</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">⭐ ลูกค้าไว้วางใจ</div>
						<div class="meaning-card-desc">อ่านรีวิวจากเจ้าภาพที่เคยใช้บริการได้ที่ด้านล่าง
							หรือหน้า<a href="${pageContext.request.contextPath}/reviews">รีวิวทั้งหมด</a></div>
					</div>
				</div>
			</div>

		</div>
	</section>

	<%-- ========== THAI KANOK DIVIDER: WHY CHOOSE US → GALLERY ========== --%>
	<svg class="thai-divider" viewBox="0 0 1200 48"
		xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none"
		style="display: block; background: #FFF8E1;">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#E8CC70"
			stroke-width="1" opacity="0.6" />
    <circle cx="600" cy="24" r="4" fill="#E8BB3A" />
</svg>

	<%-- ========== GALLERY SECTION ========== --%>
	<section class="section-pad section-gallery">
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
				<p style="margin-top: 15px; font-size: 0.9rem; color: #A08840;">[อัปเดตบรรยากาศงานจริงแบบเรียลไทม์ได้ที่
					Facebook และ YouTube ของเรา]</p>
			</div>
			<div class="gallery-grid" id="galleryGrid"></div>
		</div>
	</section>

	<%-- ========== FOOTER ========== --%>
	<footer class="site-footer">
		<div class="footer-top">
			<svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
				style="display: block; width: 100%; height: 8px;">
            <rect width="1200" height="8" fill="url(#footerGrad)" />
            <defs>
                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%"
					y2="0%">
                    <stop offset="0%" stop-color="rgba(255,255,255,0.15)" />
                    <stop offset="50%" stop-color="rgba(255,255,255,0.9)" />
                    <stop offset="100%" stop-color="rgba(255,255,255,0.15)" />
                </linearGradient>
            </defs>
        </svg>
		</div>
		<div class="container footer-content footer-content-slim">
			<div class="footer-col footer-brand-col">
				<div class="footer-brand">
					<div class="lotus-icon">🪷</div>
					<span class="footer-brand-text">บุญมี รับจัดงานบุญ</span>
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

    // ประเภทงานบุญหลัก 3 แบบ ยังใช้ในหน้านี้สำหรับเมนู dropdown
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

    // ===== Banner slider — เลื่อนอัตโนมัติทุก 4 วินาที + จุดกดเลือกเองได้ =====
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