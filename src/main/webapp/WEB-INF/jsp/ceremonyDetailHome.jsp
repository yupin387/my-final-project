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
            background: linear-gradient(to bottom, rgba(255,255,255,0), rgba(255,255,255,0.95));
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
    </style>
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

<%-- ========== รู้จักงานทำบุญบ้าน: ย้ายขึ้นบนสุด เป็นแบนเนอร์ภาพ + ไล่สี ========== --%>
<section class="cd-intro-banner">
    <div class="cd-intro-banner-img">
        <img src="${pageContext.request.contextPath}/static/images/b1.jpg" alt="ทีมงานให้คำปรึกษาการจัดงาน">
    </div>
    <div class="cd-intro-banner-text">
        <div class="cd-intro-banner-text-inner">
            <div class="cd-intro-banner-title">รู้จักงานทำบุญบ้าน</div>
            <p class="cd-intro-banner-desc">
                งานทำบุญบ้าน คือการนิมนต์พระสงฆ์มาสวดเจริญพระพุทธมนต์ที่บ้าน เพื่อความเป็นสิริมงคลแก่ผู้อยู่อาศัย
                นิยมจัดในโอกาสต่างๆ เช่น ทำบุญประจำปี ทำบุญวันเกิด ทำบุญครบรอบ หรือเมื่อรู้สึกว่าอยากเสริมดวงให้บ้าน
                เชื่อกันว่าการทำบุญบ้านจะช่วยปัดเป่าสิ่งไม่ดี เสริมความเป็นอยู่ให้ร่มเย็น และเป็นการรักษาประเพณีการทำบุญ
                ของครอบครัวไทยที่สืบทอดกันมา
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

    <%-- ========== โซน 2: เปรียบเทียบแพ็กเกจ
         แต่ละแพ็กเกจกดดูรายละเอียดได้ก่อน แล้วมีปุ่ม "เลือกจองแพ็กเกจนี้" แยกต่อใบ
         เพื่อไม่ให้ลูกค้างงว่าต้องกดตรงไหนถึงจะไปฟอร์มของแพ็กเกจที่ต้องการ ========== --%>
    <div class="cd-card cd-package-card">
        <div class="cd-card-title">📦 เปรียบเทียบแพ็กเกจ${mainType}</div>
        <p style="font-size:13px;color:var(--text-muted);margin-bottom:16px;line-height:1.6;">
            แต่ละแพ็กเกจมีจำนวนพระสงฆ์เท่ากัน แต่รายละเอียดรายการอื่นๆ ที่ได้รับแตกต่างกัน
            กดปุ่ม <strong>"ดูรายละเอียดแพ็กเกจนี้"</strong> เพื่ออ่านก่อนตัดสินใจ
            แล้วกด <strong>"เลือกจองแพ็กเกจนี้"</strong> เพื่อไปกรอกแบบฟอร์มของแพ็กเกจที่ต้องการได้เลย
        </p>
        <div class="cd-package-grid">
            <c:forEach items="${packages}" var="p">
                <div class="cd-package-option ${p.ceremonyId == ceremony.ceremonyId ? 'active' : ''}">
                    <div class="cd-package-option-name">${p.ceremonyName}</div>
                    <div class="cd-package-option-price"><fmt:formatNumber value="${p.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> บาท</div>

                    <div class="cd-package-option-detail cd-detail-collapsed" id="detail-${p.ceremonyId}">
                        ${p.ceremonyDetail}
                    </div>
                    <button type="button" class="cd-btn-view-detail"
                            onclick="toggleDetail('${p.ceremonyId}', this)">
                        ดูรายละเอียดแพ็กเกจนี้ ▾
                    </button>

                    <a href="${pageContext.request.contextPath}/booking?ceremonyId=${p.ceremonyId}${not empty selectedDates ? '&dates=' : ''}${selectedDates}"
                       class="cd-btn-select-package">
                        เลือกจองแพ็กเกจนี้
                    </a>
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

            <li>✅ เลือกสินค้าและบริการเพิ่มเติมได้ เช่น ชุดสังฆทาน ชุดปิ่นโต </li>
        </ul>
    </div>


    <%-- ========== FOOTER BAR
         ปุ่มนี้ตอนนี้เป็นทางเลือก "ไม่เลือกแพ็กเกจสำเร็จรูป กรอกเองแทน"
         ส่วนการจองแพ็กเกจจริงย้ายไปอยู่ที่ปุ่ม "เลือกจองแพ็กเกจนี้" ในแต่ละใบด้านบนแล้ว ========== --%>
    <div class="cd-footer">
        <div class="cd-footer-inner">
            <div class="cd-footer-note">
                <span>ไม่อยากเลือกแพ็กเกจสำเร็จรูป? กรอกรายละเอียดเองได้</span>
            </div>
            <a href="${pageContext.request.contextPath}/booking?custom=true${not empty selectedDates ? '&dates=' : ''}${selectedDates}" class="cd-btn-book">จองแบบระบุเอง</a>
        </div>
    </div>

	<%-- ========== FOOTER (สีเดียวกับหน้า home: ใช้ทองไล่โปร่งแสง แทนชมพู/แดง) ========== --%>
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

<script>
    function toggleDetail(id, btn) {
        var el = document.getElementById('detail-' + id);
        el.classList.toggle('cd-detail-collapsed');
        btn.textContent = el.classList.contains('cd-detail-collapsed')
            ? 'ดูรายละเอียดแพ็กเกจนี้ ▾'
            : 'ซ่อนรายละเอียด ▴';
    }
</script>
<script src="${pageContext.request.contextPath}/static/js/ceremonyDetail.js"></script>
</body>
</html>
