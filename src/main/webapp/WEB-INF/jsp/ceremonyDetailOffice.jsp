<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${ceremony.ceremonyName} - บุญมีรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ceremonyDetail.css">
</head>
<body>

<%-- ========== NAVBAR (ให้ตรงกับ home: 92px / โลโก้ 58px / ใช้รูปจริงแทน emoji) ========== --%>
<nav class="cd-navbar">
    <a class="cd-nav-brand" href="${pageContext.request.contextPath}/home">
        <div class="cd-lotus-icon">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
        </div>
        <span class="cd-nav-title">บุญมีรับจัดงานบุญ</span>
    </a>
    <div class="cd-nav-links">
        <a href="${pageContext.request.contextPath}/home"    class="cd-nav-link">หน้าหลัก</a>
        <a href="${pageContext.request.contextPath}/reviews" class="cd-nav-link">รีวิว</a>
    </div>
</nav>

<%-- ========== HEADER: เหลือแค่ชื่องาน + วันที่เลือก ========== --%>
<div class="cd-hero" style="background-image:url('${pageContext.request.contextPath}/static/images/bue.jpg');">
    <div class="cd-hero-overlay"></div>
    <div class="cd-hero-content">
        <h1 class="cd-hero-title">รายละเอียดงาน${mainType}</h1>
        <div class="cd-hero-divider"></div>
        <c:if test="${not empty selectedDates}">
            <div class="cd-hero-note">📅 วันที่คุณเลือกไว้: <strong>${selectedDates}</strong></div>
        </c:if>
    </div>
</div>

<%-- ========== รู้จักงานทำบุญออฟฟิศ: ย้ายขึ้นบนสุด เป็นแบนเนอร์ภาพ + ไล่สีชมพู ========== --%>
<section class="cd-intro-banner">
    <div class="cd-intro-banner-img">
        <img src="${pageContext.request.contextPath}/static/images/b3.jpg" alt="ทีมงานให้คำปรึกษาการจัดงาน">
    </div>
    <div class="cd-intro-banner-text">
        <div class="cd-intro-banner-text-inner">
            <div class="cd-intro-banner-title">รู้จักงานทำบุญออฟฟิศ</div>
            <p class="cd-intro-banner-desc">
                งานทำบุญออฟฟิศหรือบริษัท คือการนิมนต์พระสงฆ์มาประกอบพิธีสงฆ์ในสถานที่ทำงาน เพื่อความเป็นสิริมงคล
                ในการดำเนินธุรกิจ นิยมจัดเมื่อเปิดบริษัทใหม่ ย้ายสำนักงาน หรือทำบุญประจำปีของกิจการ
                เชื่อว่าจะช่วยเสริมดวงการงาน สร้างขวัญกำลังใจให้พนักงาน และเป็นการแสดงความเคารพต่อสถานที่ทำงาน
                ก่อนเริ่มดำเนินกิจการหรือช่วงเวลาสำคัญของบริษัท
            </p>
        </div>
    </div>
</section>

<%-- ========== KANOK DIVIDER ========== --%>
<svg viewBox="0 0 1200 48" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="display:block;width:100%;height:48px;background:#FFF5F8;">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#F3B6C8" stroke-width="1" opacity="0.6"/>
    <g fill="#D6336C" opacity="0.55">
        <ellipse cx="600" cy="24" rx="18" ry="6" transform="rotate(-30 600 24)"/>
        <ellipse cx="600" cy="24" rx="18" ry="6" transform="rotate(30 600 24)"/>
        <ellipse cx="600" cy="24" rx="18" ry="6"/>
        <circle  cx="600" cy="24" r="4"   fill="#F48FB1"/>
        <ellipse cx="480" cy="24" rx="14" ry="5" transform="rotate(-30 480 24)"/>
        <ellipse cx="480" cy="24" rx="14" ry="5" transform="rotate(30 480 24)"/>
        <circle  cx="480" cy="24" r="3"   fill="#F48FB1"/>
        <ellipse cx="720" cy="24" rx="14" ry="5" transform="rotate(-30 720 24)"/>
        <ellipse cx="720" cy="24" rx="14" ry="5" transform="rotate(30 720 24)"/>
        <circle  cx="720" cy="24" r="3"   fill="#F48FB1"/>
        <ellipse cx="360" cy="24" rx="10" ry="4" transform="rotate(-30 360 24)"/>
        <ellipse cx="360" cy="24" rx="10" ry="4" transform="rotate(30 360 24)"/>
        <circle  cx="360" cy="24" r="2.5" fill="#F48FB1"/>
        <ellipse cx="840" cy="24" rx="10" ry="4" transform="rotate(-30 840 24)"/>
        <ellipse cx="840" cy="24" rx="10" ry="4" transform="rotate(30 840 24)"/>
        <circle  cx="840" cy="24" r="2.5" fill="#F48FB1"/>
        <ellipse cx="240" cy="24" rx="7"  ry="3" transform="rotate(-30 240 24)"/>
        <ellipse cx="240" cy="24" rx="7"  ry="3" transform="rotate(30 240 24)"/>
        <ellipse cx="960" cy="24" rx="7"  ry="3" transform="rotate(-30 960 24)"/>
        <ellipse cx="960" cy="24" rx="7"  ry="3" transform="rotate(30 960 24)"/>
    </g>
    <line x1="0" y1="6"  x2="1200" y2="6"  stroke="#F3B6C8" stroke-width="0.5" opacity="0.35"/>
    <line x1="0" y1="42" x2="1200" y2="42" stroke="#F3B6C8" stroke-width="0.5" opacity="0.35"/>
</svg>

<%-- ========== MAIN CONTENT ========== --%>
<div class="cd-container">



    <%-- ========== โซน 2: เปรียบเทียบแพ็กเกจ (บน 2 ล่าง 2 — ดูอย่างเดียว กดไม่ได้ ไม่มี hover) ========== --%>
    <div class="cd-card cd-package-card">
        <div class="cd-card-title">📦 เปรียบเทียบแพ็กเกจ${mainType}</div>
        <p style="font-size:13px;color:var(--text-muted);margin-bottom:16px;line-height:1.6;">
            แต่ละแพ็กเกจมีจำนวนพระสงฆ์เท่ากัน แต่รายละเอียดรายการอื่นๆ ที่ได้รับแตกต่างกัน ดูเปรียบเทียบคร่าวๆ ได้ที่นี่ —
            ส่วนการ<strong>เลือกแพ็กเกจจริง</strong>จะทำในขั้นตอนกรอกแบบฟอร์มจองอีกที
        </p>
        <div class="cd-package-grid">
            <c:forEach items="${packages}" var="p">
                <div class="cd-package-option ${p.ceremonyId == ceremony.ceremonyId ? 'active' : ''}">
                    <div class="cd-package-option-name">${p.ceremonyName}</div>
                    <div class="cd-package-option-price"><fmt:formatNumber value="${p.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> บาท</div>
                    <div class="cd-package-option-detail">
                        ${p.ceremonyDetail}
                    </div>
                   
                </div>
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

        <li>✅ จัดเตรียมอุปกรณ์ประกอบพิธีครบชุด พร้อมจัดสถานที่สำหรับประกอบพิธี</li>

        <li>✅ ทีมงานดูแลและอำนวยความสะดวกตลอดพิธี</li>
        
        <li>✅ มัคนายกดำเนินพิธี </li>

        <li>✅ เลือกสินค้าและบริการเพิ่มเติมได้ เช่น ชุดสังฆทาน ชุดปิ่นโต อุปกรณ์พิธีอื่น ๆ เพื่อให้เหมาะกับความต้องการของแต่ละงาน</li>
    </ul>
</div>



<%-- ========== FOOTER BAR (ปุ่มจองขยายใหญ่ขึ้น สีเข้มขึ้น) ========== --%>
<div class="cd-footer">
    <div class="cd-footer-inner">
        <div class="cd-footer-note">
            <span>เริ่มต้น — เลือกแพ็กเกจจริงในหน้าจอง</span>
        </div>
        <a href="${pageContext.request.contextPath}/booking3?ceremonyId=${ceremony.ceremonyId}${not empty selectedDates ? '&dates=' : ''}${selectedDates}" class="cd-btn-book">จอง${mainType}</a>
    </div>
</div>

	<%-- ========== FOOTER (ใช้โลโก้จริงแทน emoji, ตัด Copyright ออก) ========== --%>
	<footer class="site-footer">
		<div class="footer-top">
			<svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
				style="display: block; width: 100%; height: 8px;">
            <rect width="1200" height="8" fill="url(#footerGrad)" />
            <defs>
                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%"
					y2="0%">
                    <stop offset="0%" stop-color="#6E1930" />
                    <stop offset="25%" stop-color="#EC6E96" />
                    <stop offset="50%" stop-color="#FBD0DE" />
                    <stop offset="75%" stop-color="#EC6E96" />
                    <stop offset="100%" stop-color="#6E1930" />
                </linearGradient>
            </defs>
        </svg>
		</div>
		<div class="container footer-content">
			<div class="footer-col footer-brand-col">
				<div class="footer-brand">
					<div class="lotus-icon">
						<img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
					</div>
					<span class="footer-brand-text">บุญมี รับจัดงานบุญ</span>
				</div>
				<p class="footer-tagline">รับจัดงานบุญ
					ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
			</div>

		
			<div class="footer-col">
				<h4 class="footer-heading">เมนู</h4>
				<a href="${pageContext.request.contextPath}/home">หน้าหลัก</a>
				<a href="${pageContext.request.contextPath}/reviews">รีวิว</a>
				<a href="${pageContext.request.contextPath}/loginMember">เข้าสู่ระบบ</a>
				<a href="${pageContext.request.contextPath}/register">สมัครสมาชิก</a>
			</div>

<div class="footer-col">
    <%-- เพิ่ม style="margin-bottom: 25px;" ตรงนี้เพื่อดันรายการด้านล่างลงไป --%>
    <h5 style="margin-bottom: 25px;">งานบุญของเรา</h5>
    
    <ul class="list-unstyled" style="list-style: none; padding: 0;">
        <li style="margin-bottom: 20px;"><a href="#" style="color: #fff; text-decoration: none;">พิธีทำบุญบ้าน</a></li>
        <li style="margin-bottom: 15px;"><a href="#" style="color: #fff; text-decoration: none;">พิธีแต่งงาน</a></li>
        <li style="margin-bottom: 15px;"><a href="#" style="color: #fff; text-decoration: none;">พิธีทำบุญอุทิศส่วนกุศล</a></li>
    </ul>
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

<script src="${pageContext.request.contextPath}/static/js/ceremonyDetail.js"></script>
</body>
</html>
