<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>หน้าหลัก - ระบบรับจัดงานบุญ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css?v=6">
</head>
<body>

<%-- ========== NAVBAR ========== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">🪷</div>
        <span class="nav-brand-text">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item active">หน้าหลัก</a>
        <c:if test="${not empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/latestBooking"         class="nav-link-item">การจอง</a>
            <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-link-item">ใบเสนอราคา</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/reviews" class="nav-link-item">รีวิว</a>
        <c:if test="${empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/loginMember" class="nav-link-item">เข้าสู่ระบบ</a>
        </c:if>
    </div>
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <div class="dropdown-wrap">
                <div class="user-profile-pill">
                    <div class="avatar-circle-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
                    <div class="user-info-text">
                        <span class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
                        <span class="user-role-nav">สมาชิก</span>
                    </div>
                </div>
                <div class="dropdown-menu-custom" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-link">โปรไฟล์ของฉัน</a>
                    <a href="${pageContext.request.contextPath}/logout"      class="dropdown-link danger">ออกจากระบบ</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/register" class="btn-register-nav">สมัครสมาชิก</a>
        </c:otherwise>
    </c:choose>
</nav>

<%-- ========== LOGIN SUCCESS ALERT ========== --%>
<c:if test="${param.loginSuccess != null}">
    <div id="loginAlert" class="login-alert-toast">
        <div class="toast-icon">✓</div>
        <div class="toast-body">
            <span class="toast-title">เข้าสู่ระบบสำเร็จ!</span>
            <span class="toast-user">ยินดีต้อนรับคุณ ${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
        </div>
    </div>
</c:if>

<%-- ========== HERO ========== --%>
<div class="hero-section">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <span class="hero-tag">บริการครบวงจร</span>
        <h1>บริการรับจัดงานบุญ<span>ถูกหลักพิธีการ</span></h1>
        <p>สะดวก สะอาด ตรงต่อเวลา สำหรับวันสำคัญของคุณและครอบครัว</p>
        <div class="hero-divider"></div>
    </div>
</div>

<%-- ========== THAI WAVE DIVIDER: HERO → CALENDAR ========== --%>
<svg class="thai-divider" viewBox="0 0 1200 48" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="display:block;background:#ffffff;">
    <path d="M0,0 L1200,0 L1200,16 Q1100,40 1000,20 Q900,2 800,28 Q700,48 600,28 Q500,8 400,30 Q300,48 200,24 Q100,4 0,22 Z" fill="#3D2500" opacity="0.07"/>
    <path d="M0,8 Q150,44 300,18 Q450,-6 600,22 Q750,48 900,20 Q1050,-6 1200,18 L1200,48 L0,48 Z" fill="#FFF8E1"/>
    <path d="M0,26 Q100,10 200,26 Q300,44 400,26 Q500,10 600,26 Q700,44 800,26 Q900,10 1000,26 Q1100,44 1200,26" stroke="#D4A017" stroke-width="1.5" fill="none" opacity="0.5"/>
    <circle cx="200" cy="26" r="3" fill="#D4A017" opacity="0.5"/>
    <circle cx="400" cy="26" r="3" fill="#D4A017" opacity="0.5"/>
    <circle cx="600" cy="26" r="3" fill="#D4A017" opacity="0.5"/>
    <circle cx="800" cy="26" r="3" fill="#D4A017" opacity="0.5"/>
    <circle cx="1000" cy="26" r="3" fill="#D4A017" opacity="0.5"/>
</svg>

<%-- ========== CALENDAR ========== --%>
<section class="section-pad section-calendar">
    <div class="container">
        <div class="section-ornament">
            <div class="ornament-line"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-diamond"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-line right"></div>
        </div>
        <div class="section-header">
            <h2 class="section-title">ตรวจสอบปฏิทินการจัดงาน</h2>
            <p class="section-subtitle">ดูว่าวันไหนมีงานแล้ว วันไหนยังว่างอยู่</p>
            <div class="gold-line"></div>
        </div>
        <div style="text-align:center; margin-top: 10px;">
            <button class="btn-open-calendar" onclick="openCalendarModal()">🗓 ตรวจสอบปฏิทิน</button>
        </div>
    </div>

    <%-- Modal Overlay --%>
    <div class="calendar-modal-overlay" id="calendarOverlay" onclick="closeCalendarModal(event)">
        <div class="calendar-modal-box">
            <button class="cal-modal-close" onclick="closeCalendarModal(null)">&times;</button>
            <div class="cal-header">
                <button class="cal-nav-btn" onclick="prevMonth()">&#8249;</button>
                <h5 id="calMonthTitle"></h5>
                <button class="cal-nav-btn" onclick="nextMonth()">&#8250;</button>
            </div>
            <div class="cal-grid" id="calGrid">
                <div class="cal-day-label">อา</div>
                <div class="cal-day-label">จ</div>
                <div class="cal-day-label">อ</div>
                <div class="cal-day-label">พ</div>
                <div class="cal-day-label">พฤ</div>
                <div class="cal-day-label">ศ</div>
                <div class="cal-day-label">ส</div>
            </div>
            <hr style="border:0;border-top:1px solid #f0e8c8;margin:18px 0 14px;">
            <div class="cal-legend">
                <span><span class="legend-dot" style="background:var(--cal-booked-bg);border:1.5px solid var(--cal-booked-border);"></span>มีงานแล้ว</span>
                <span><span class="legend-dot" style="background:var(--cal-free-bg);border:1.5px solid var(--cal-free-border);"></span>ว่าง</span>
                <span><span class="legend-dot" style="background:var(--cal-today-bg);border:2px solid var(--cal-today-border);"></span>วันนี้</span>
            </div>
        </div>
    </div>
</section>

<%-- ========== THAI KANOK DIVIDER: CALENDAR → EVENTS ========== --%>
<svg class="thai-divider" viewBox="0 0 1200 48" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="display:block; background:linear-gradient(#fff,#FFF8E1);">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#E8CC70" stroke-width="1" opacity="0.6"/>
    <g fill="#D4A017" opacity="0.55">
        <ellipse cx="600" cy="24" rx="18" ry="6" transform="rotate(-30 600 24)"/>
        <ellipse cx="600" cy="24" rx="18" ry="6" transform="rotate(30 600 24)"/>
        <ellipse cx="600" cy="24" rx="18" ry="6"/>
        <circle cx="600" cy="24" r="4" fill="#E8BB3A"/>
        <ellipse cx="480" cy="24" rx="14" ry="5" transform="rotate(-30 480 24)"/>
        <ellipse cx="480" cy="24" rx="14" ry="5" transform="rotate(30 480 24)"/>
        <circle cx="480" cy="24" r="3" fill="#E8BB3A"/>
        <ellipse cx="720" cy="24" rx="14" ry="5" transform="rotate(-30 720 24)"/>
        <ellipse cx="720" cy="24" rx="14" ry="5" transform="rotate(30 720 24)"/>
        <circle cx="720" cy="24" r="3" fill="#E8BB3A"/>
        <ellipse cx="360" cy="24" rx="10" ry="4" transform="rotate(-30 360 24)"/>
        <ellipse cx="360" cy="24" rx="10" ry="4" transform="rotate(30 360 24)"/>
        <circle cx="360" cy="24" r="2.5" fill="#E8BB3A"/>
        <ellipse cx="840" cy="24" rx="10" ry="4" transform="rotate(-30 840 24)"/>
        <ellipse cx="840" cy="24" rx="10" ry="4" transform="rotate(30 840 24)"/>
        <circle cx="840" cy="24" r="2.5" fill="#E8BB3A"/>
        <ellipse cx="240" cy="24" rx="7" ry="3" transform="rotate(-30 240 24)"/>
        <ellipse cx="240" cy="24" rx="7" ry="3" transform="rotate(30 240 24)"/>
        <ellipse cx="960" cy="24" rx="7" ry="3" transform="rotate(-30 960 24)"/>
        <ellipse cx="960" cy="24" rx="7" ry="3" transform="rotate(30 960 24)"/>
    </g>
    <line x1="0" y1="4"  x2="1200" y2="4"  stroke="#E8CC70" stroke-width="0.5" opacity="0.4"/>
    <line x1="0" y1="44" x2="1200" y2="44" stroke="#E8CC70" stroke-width="0.5" opacity="0.4"/>
</svg>

<%-- ========== EVENT TYPES ========== --%>
<section class="section-pad section-events">
    <div class="container">
        <div class="section-ornament">
            <div class="ornament-line"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-diamond"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-line right"></div>
        </div>
        <div class="section-header">
            <h2 class="section-title">เลือกประเภทงานบุญ</h2>
            <p class="section-subtitle">เลือกประเภทงานเพื่อดูรายละเอียดและดำเนินการจอง</p>
            <div class="gold-line"></div>
        </div>
        <div class="events-grid">
            <div class="event-card">
                <div class="event-card-icon">
                    <img src="${pageContext.request.contextPath}/static/images/ceremony1.webp" alt="${ceremony1.ceremonyName}">
                </div>
                <h5>งาน${ceremony1.ceremonyName}</h5>
                <div class="event-rating">
                    <span class="stars">
                        <c:forEach begin="1" end="${fn:substringBefore(avgRating1, '.')}">&#9733;</c:forEach>
                        <c:forEach begin="${fn:substringBefore(avgRating1, '.') + 1}" end="5">&#9734;</c:forEach>
                    </span>
                    <span class="rating-num"><fmt:formatNumber value="${avgRating1}" maxFractionDigits="1"/> / 5</span>
                </div>
                <p>${ceremony1.ceremonyDetail}</p>
                <div class="event-divider"></div>
                <div class="event-card-actions">
                    <a href="${pageContext.request.contextPath}/ceremony/detail/${ceremony1.ceremonyId}" class="btn-detail">ดูรายละเอียด</a>
                    <a href="${pageContext.request.contextPath}/reviews/${ceremony1.ceremonyId}" class="btn-outline-brown">ดูรีวิว</a>
                </div>
            </div>
            <div class="event-card">
                <div class="event-card-icon">
                    <img src="${pageContext.request.contextPath}/static/images/ceremony2.jpg" alt="${ceremony2.ceremonyName}">
                </div>
                <h5>งาน${ceremony2.ceremonyName}</h5>
                <div class="event-rating">
                    <span class="stars">
                        <c:forEach begin="1" end="${fn:substringBefore(avgRating2, '.')}">&#9733;</c:forEach>
                        <c:forEach begin="${fn:substringBefore(avgRating2, '.') + 1}" end="5">&#9734;</c:forEach>
                    </span>
                    <span class="rating-num"><fmt:formatNumber value="${avgRating2}" maxFractionDigits="1"/> / 5</span>
                </div>
                <p>${ceremony2.ceremonyDetail}</p>
                <div class="event-divider"></div>
                <div class="event-card-actions">
                    <a href="${pageContext.request.contextPath}/ceremony/detail/${ceremony2.ceremonyId}" class="btn-detail">ดูรายละเอียด</a>
                    <a href="${pageContext.request.contextPath}/reviews/${ceremony2.ceremonyId}" class="btn-outline-brown">ดูรีวิว</a>
                </div>
            </div>
        </div>
    </div>
</section>

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
            <h2 class="section-title">จากความตั้งใจ สู่ความประทับใจที่บอกต่อ</h2>
            <p class="section-subtitle">ร่วมสัมผัสรอยยิ้มและความสำเร็จในทุกพิธีสำคัญที่ได้รับความไว้วางใจจากครอบครัวมากมาย</p>
            <div class="gold-line"></div>
            <p style="margin-top: 15px; font-size: 0.9rem; color: #A08840;">[อัปเดตบรรยากาศงานจริงแบบเรียลไทม์ได้ที่ Facebook และ YouTube ของเรา]</p>
        </div>
        <div class="gallery-grid" id="galleryGrid"></div>
    </div>
</section>

<%-- ========== FOOTER STRIP ========== --%>
<div class="footer-strip">
    <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;">
        <rect width="1200" height="8" fill="url(#footerGrad)"/>
        <defs>
            <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%"   stop-color="#3D2500"/>
                <stop offset="25%"  stop-color="#D4A017"/>
                <stop offset="50%"  stop-color="#E8BB3A"/>
                <stop offset="75%"  stop-color="#D4A017"/>
                <stop offset="100%" stop-color="#3D2500"/>
            </linearGradient>
        </defs>
    </svg>
</div>

<%-- ========== SCRIPT ZONE ========== --%>
<script>
    window.contextPath = "${pageContext.request.contextPath}";
    window.bookedDates = [
        <c:forEach var="d" items="${bookedDates}" varStatus="st">
            "${d}"<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
</script>
<script src="${pageContext.request.contextPath}/static/js/home.js?v=7"></script>

</body>
</html>