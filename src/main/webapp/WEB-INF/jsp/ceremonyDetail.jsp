<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${ceremony.ceremonyName} - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ceremonyDetail.css">
</head>
<body>

<%-- ========== NAVBAR ========== --%>
<nav class="cd-navbar">
    <a class="cd-nav-brand" href="${pageContext.request.contextPath}/home">
        <div class="cd-lotus-icon">🪷</div>
        <span class="cd-nav-title">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="cd-nav-links">
        <a href="${pageContext.request.contextPath}/home"    class="cd-nav-link">หน้าหลัก</a>
        <a href="${pageContext.request.contextPath}/reviews" class="cd-nav-link">รีวิว</a>
    </div>
</nav>

<%-- ========== HERO BANNER ========== --%>
<c:choose>
    <c:when test="${ceremony.ceremonyId == 1}">
        <div class="cd-hero" style="background-image:url('${pageContext.request.contextPath}/static/images/ceremony1.webp');">
    </c:when>
    <c:otherwise>
        <div class="cd-hero" style="background-image:url('${pageContext.request.contextPath}/static/images/ceremony2.jpg');">
    </c:otherwise>
</c:choose>
    <div class="cd-hero-overlay"></div>
    <div class="cd-hero-content">
        <div class="cd-hero-tag">พิธีกรรมไทย</div>
        <h1 class="cd-hero-title">${ceremony.ceremonyName}</h1>
        <p class="cd-hero-desc">${ceremony.ceremonyDetail}</p>
        <div class="cd-hero-divider"></div>
        <div class="cd-hero-note">ราคาขึ้นอยู่กับขนาดงาน — ทางร้านจะแจ้งใบเสนอราคาภายหลัง</div>
    </div>
</div>

<%-- ========== KANOK DIVIDER ========== --%>
<svg viewBox="0 0 1200 48" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="display:block;width:100%;height:48px;background:#FFFBF0;">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#E8CC70" stroke-width="1" opacity="0.6"/>
    <g fill="#D4A017" opacity="0.55">
        <ellipse cx="600" cy="24" rx="18" ry="6" transform="rotate(-30 600 24)"/>
        <ellipse cx="600" cy="24" rx="18" ry="6" transform="rotate(30 600 24)"/>
        <ellipse cx="600" cy="24" rx="18" ry="6"/>
        <circle  cx="600" cy="24" r="4"   fill="#E8BB3A"/>
        <ellipse cx="480" cy="24" rx="14" ry="5" transform="rotate(-30 480 24)"/>
        <ellipse cx="480" cy="24" rx="14" ry="5" transform="rotate(30 480 24)"/>
        <circle  cx="480" cy="24" r="3"   fill="#E8BB3A"/>
        <ellipse cx="720" cy="24" rx="14" ry="5" transform="rotate(-30 720 24)"/>
        <ellipse cx="720" cy="24" rx="14" ry="5" transform="rotate(30 720 24)"/>
        <circle  cx="720" cy="24" r="3"   fill="#E8BB3A"/>
        <ellipse cx="360" cy="24" rx="10" ry="4" transform="rotate(-30 360 24)"/>
        <ellipse cx="360" cy="24" rx="10" ry="4" transform="rotate(30 360 24)"/>
        <circle  cx="360" cy="24" r="2.5" fill="#E8BB3A"/>
        <ellipse cx="840" cy="24" rx="10" ry="4" transform="rotate(-30 840 24)"/>
        <ellipse cx="840" cy="24" rx="10" ry="4" transform="rotate(30 840 24)"/>
        <circle  cx="840" cy="24" r="2.5" fill="#E8BB3A"/>
        <ellipse cx="240" cy="24" rx="7"  ry="3" transform="rotate(-30 240 24)"/>
        <ellipse cx="240" cy="24" rx="7"  ry="3" transform="rotate(30 240 24)"/>
        <ellipse cx="960" cy="24" rx="7"  ry="3" transform="rotate(-30 960 24)"/>
        <ellipse cx="960" cy="24" rx="7"  ry="3" transform="rotate(30 960 24)"/>
    </g>
    <line x1="0" y1="6"  x2="1200" y2="6"  stroke="#E8CC70" stroke-width="0.5" opacity="0.35"/>
    <line x1="0" y1="42" x2="1200" y2="42" stroke="#E8CC70" stroke-width="0.5" opacity="0.35"/>
</svg>

<%-- ========== MAIN CONTENT ========== --%>
<div class="cd-container">

    <div class="cd-section-ornament">
        <div class="cd-ornament-line"></div>
        <div class="cd-ornament-diamond-sm"></div>
        <div class="cd-ornament-diamond"></div>
        <div class="cd-ornament-diamond-sm"></div>
        <div class="cd-ornament-line right"></div>
    </div>
    <div class="cd-section-header">
        <h2 class="cd-section-title">รายละเอียดงาน${ceremony.ceremonyName}</h2>
        <div class="cd-gold-line"></div>
    </div>

    <%-- ========== โซน 1: เงื่อนไขการจอง ========== --%>
    <div class="cd-card cd-condition-card">
        <div class="cd-card-title">📌 เงื่อนไขการใช้บริการ</div>
        <ul class="cd-condition-list">
            <c:choose>
                <c:when test="${ceremony.ceremonyId == 1}">
                    <li>✅ ให้บริการจัดงานขึ้นบ้านใหม่ตามประเพณีภาคเหนือเท่านั้น</li>
                </c:when>
                <c:otherwise>
                    <li>✅ ให้บริการจัดพิธีสืบชะตาตามประเพณีล้านนาเท่านั้น</li>
                </c:otherwise>
            </c:choose>
            <li>✅ รัศมีการนิมนต์พระสงฆ์ไม่เกิน 10 กิโลเมตร</li>
            <li>✅ ราคาขึ้นอยู่กับขนาดงานและจำนวนแขก ทางร้านจะส่งใบเสนอราคาให้หลังรับจอง</li>
            <li>✅ กรุณากรอกข้อมูลให้ครบถ้วน เพื่อความสะดวกในการจัดเตรียม</li>
        </ul>
    </div>

    <%-- ========== โซน 2: อุปกรณ์พื้นฐานที่รวมมาให้ ========== --%>
    <div class="cd-card">
        <div class="cd-card-title">อุปกรณ์ที่ทางร้านเตรียมให้</div>
        <p class="cd-pinto-sub">รายการด้านล่างนี้รวมอยู่ในบริการแล้ว ไม่มีค่าใช้จ่ายเพิ่มเติม</p>
        <ul class="cd-item-list">
            <c:forEach items="${equipments}" var="item">
                <li>
                    <span class="cd-dot"></span>
                    <span>${item.itemName}</span>
                </li>
            </c:forEach>
            <c:if test="${empty equipments}">
                <li><span class="cd-dot"></span><span>กำลังอัปเดตข้อมูลอุปกรณ์...</span></li>
            </c:if>
        </ul>
    </div>

    <%-- ========== โซน 3: รายการที่เลือกเพิ่มได้ (บอกสั้นๆ ไม่แสดงรายละเอียด) ========== --%>
    <div class="cd-card">
        <div class="cd-card-title">รายการที่เลือกเพิ่มได้ในฟอร์มจอง</div>
        <p class="cd-pinto-sub">สามารถเลือกเพิ่มรายการด้านล่างได้เมื่อกรอกแบบฟอร์มจองค่ะ</p>
        <div class="cd-addon-list">
            <div class="cd-addon-row">
                <span class="cd-addon-icon">🍱</span>
                <div>
                    <div class="cd-addon-name">ชุดภัตตาหารปิ่นโตถวายพระ</div>
                    <div class="cd-addon-desc">มีให้เลือก 5 แบบ ปรุงสดใหม่ทุกวัน</div>
                </div>
            </div>
            <div class="cd-addon-row">
                <span class="cd-addon-icon">🎁</span>
                <div>
                    <div class="cd-addon-name">ชุดสังฆทาน</div>
                    <div class="cd-addon-desc">มีให้เลือก 5 แบบ คัดสรรของใช้คุณภาพถวายพระสงฆ์</div>
                </div>
            </div>
        </div>
    </div>

</div>

<%-- ========== LOTUS WAVE DIVIDER ========== --%>
<svg viewBox="0 0 1200 48" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="display:block;width:100%;height:48px;background:#FFFBF0;">
    <path d="M0,32 Q60,16 120,32 Q180,48 240,32 Q300,16 360,32 Q420,48 480,32 Q540,16 600,32 Q660,48 720,32 Q780,16 840,32 Q900,48 960,32 Q1020,16 1080,32 Q1140,48 1200,32" stroke="#D4A017" stroke-width="1.5" fill="none" opacity="0.45"/>
    <g fill="#D4A017" opacity="0.6">
        <circle cx="120" cy="32" r="2.5"/><circle cx="360" cy="32" r="2.5"/>
        <circle cx="600" cy="32" r="3.5"/><circle cx="840" cy="32" r="2.5"/>
        <circle cx="1080" cy="32" r="2.5"/>
    </g>
</svg>

<%-- ========== FOOTER BAR ========== --%>
<div class="cd-footer">
    <div class="cd-footer-inner">
        <div class="cd-footer-note">
            💬 สนใจจองงาน? กรอกแบบฟอร์มเพื่อรับใบเสนอราคา
        </div>
        <c:choose>
            <c:when test="${ceremony.ceremonyId == 1}">
                <a href="${pageContext.request.contextPath}/booking"  class="cd-btn-book">จองงานขึ้นบ้านใหม่</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/booking2" class="cd-btn-book">จองงานสืบชะตา</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- ========== FOOTER STRIP ========== --%>
<svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;margin-bottom:72px;">
    <rect width="1200" height="8" fill="url(#cdFooterGrad)"/>
    <defs>
        <linearGradient id="cdFooterGrad" x1="0%" y1="0%" x2="100%" y2="0%">
            <stop offset="0%"   stop-color="#3D2500"/>
            <stop offset="25%"  stop-color="#D4A017"/>
            <stop offset="50%"  stop-color="#E8BB3A"/>
            <stop offset="75%"  stop-color="#D4A017"/>
            <stop offset="100%" stop-color="#3D2500"/>
        </linearGradient>
    </defs>
</svg>

<script src="${pageContext.request.contextPath}/static/js/ceremonyDetail.js"></script>
</body>
</html>
