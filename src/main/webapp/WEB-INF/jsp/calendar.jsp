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
<title>ปฏิทินฤกษ์ดี - บุญมี รับจัดงานบุญ</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/home.css?v=15">
<%-- CSS เฉพาะหน้าปฏิทิน แยกไฟล์ออกมาจาก inline <style> เดิม --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/calendarPage.css?v=1">
<%-- CSS เฉพาะส่วนปฏิทินล้านนา แยกไฟล์เดี่ยวๆ ไม่ผูกกับ home.css --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/lannaCalendar.css?v=1">
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
				class="nav-link-item">หน้าหลัก</a>

			<%-- ตัดลิงก์ "แพ็กเกจงานบุญทั้งหมด" ออก เหลือแค่ 3 งานบุญหลัก --%>
			<div class="nav-dropdown-wrap">
				<a href="${pageContext.request.contextPath}/home#packagesSection"
					class="nav-link-item nav-dropdown-toggle">
					บริการ/แพ็กเกจ <span class="nav-caret">▾</span>
				</a>
				<div class="nav-dropdown-panel">
					<c:forEach var="t" items="${ceremonyTypes}">
						<a href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}"
							class="nav-dropdown-link">${t.mainName}</a>
					</c:forEach>
					<hr class="nav-dropdown-divider">
					<a href="${pageContext.request.contextPath}/calendar"
						class="nav-dropdown-link">📅 ดูปฏิทินฤกษ์ดี</a>
				</div>
			</div>

			<div class="nav-dropdown-wrap">
				<a href="${pageContext.request.contextPath}/calendar"
					class="nav-link-item nav-dropdown-toggle active">
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

	<%-- ========== หัวหน้าปฏิทิน ========== --%>
	<div class="calendar-page-header">
		<h1>ปฏิทินฤกษ์ดีจัดงานบุญ</h1>
		<p>ดูวันฤกษ์มงคล วันว่าง วันเต็มคิว — จองงานบุญได้ที่หน้าแพ็กเกจ</p>
		<div class="calendar-tabs">
			<a href="#calendarSection" class="calendar-tab-link">ปฏิทิน (ฤกษ์ดี)</a>
			<a href="#lannaCalendarSection" class="calendar-tab-link">ปฏิทิน (ล้านนา)</a>
		</div>
	</div>

	<%-- ========== CALENDAR (ฤกษ์ดี) ========== --%>
	<section class="section-pad section-calendar" id="calendarSection">
		<div class="container">
			<div class="section-ornament">
				<div class="ornament-line"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-diamond"></div>
				<div class="ornament-diamond-sm"></div>
				<div class="ornament-line right"></div>
			</div>
			<div class="section-header">
				<h2 class="section-title">ปฏิทินฤกษ์ดีจัดงานบุญ (ไทย)</h2>
				<p class="section-subtitle">ดูวันว่าง วันมีงานแล้ว
					พร้อมวันดี-วันฤกษ์มงคลของแต่ละวัน
					</p>
				<div class="gold-line"></div>
			</div>

			<div class="calendar-card">
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
				<hr style="border: 0; border-top: 1px solid #f0e8c8; margin: 18px 0 14px;">
				<div class="cal-legend">
					<span><span class="legend-dot"
						style="background: var(--cal-booked-bg); border: 1.5px solid var(--cal-booked-border);"></span>เต็มคิว/มีงานแล้ว</span>
					<span><span class="legend-dot"
						style="background: var(--cal-almost-bg); border: 1.5px solid var(--cal-almost-border);"></span>เหลือคิวสุดท้าย</span>
					<span><span class="legend-dot"
						style="background: var(--cal-free-bg); border: 1.5px solid var(--cal-free-border);"></span>ว่าง</span>
					<span><span class="legend-dot"
						style="background: var(--cal-today-bg); border: 1.5px solid var(--cal-today-border);"></span>วันนี้</span>
					<span><span class="legend-dot"
						style="background: var(--cal-past-bg); border: 1.5px solid var(--cal-past-border);"></span>วันที่ผ่านมาแล้ว</span>
					<span><span class="legend-star">★</span>ฤกษ์ดี</span>
					<span><span class="legend-warn">▲</span>ควรเลี่ยง</span>
				</div>
				<%-- เปลี่ยนข้อความ hint: ปฏิทินนี้ดูข้อมูลอย่างเดียว ไม่ใช้เลือกวันเพื่อจองแล้ว --%>
				<p class="cal-hint">ปฏิทินนี้แสดงสำหรับดูข้อมูลวันฤกษ์ดีและคิวว่างเท่านั้น
					กรุณาไปที่หน้า "บริการ/แพ็กเกจ" เพื่อทำการจองงานบุญ</p>
			</div>

			<%-- ========== ความหมายฤกษ์ดี (ครบทั้ง 7 แบบ ตรงกับ KNOWN_LABELS ใน AuspiciousCalendarService) ========== --%>
			<div class="meaning-block">
				<h3 class="meaning-block-title">ความหมาย <span class="highlight">ฤกษ์ดี</span> จัดงานบุญ</h3>
				<div class="meaning-grid">
					<div class="meaning-card">
						<div class="meaning-card-title">วันราชาโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานที่ต้อง
							ขอความช่วยเหลือจากผู้ใหญ่</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันมหาสิทธิโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานสำคัญ
							ที่เป็นโครงการระยะยาว</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันชัยโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานที่ต้องต่อสู้แข่งขัน
							หรือรบทัพจับศึก</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันอำมฤตโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานทั่วไป
							เกี่ยวกับความราบรื่นและสมรส</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันอธิบดี</div>
						<div class="meaning-card-desc">ดีสำหรับงานสำคัญ
							ที่ต้องการความมั่นคง เป็นหลักฐาน เจริญก้าวหน้า</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันธงชัย</div>
						<div class="meaning-card-desc">ดีสำหรับงานมงคล
							ที่มีการเคลื่อนย้ายที่ ให้ผลสำเร็จดี มีชัยชนะ</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันสิทธิโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานสำคัญ
							ที่เป็นโครงการระยะสั้น</div>
					</div>
				</div>
			</div>

			<div class="yearly-summary-block">
				<h3 class="meaning-block-title">สรุป <span class="highlight">ฤกษ์ดีทำบุญ ปี 2569</span></h3>
				<p class="section-subtitle" style="margin-bottom: 24px;">
					รวมวันฤกษ์ดีทั้ง 7 ประเภทของแต่ละเดือน ปี พ.ศ. 2569
					(ข้อมูลอัปเดตล่วงหน้า โปรดตรวจสอบวันที่แน่นอนอีกครั้งในปฏิทินด้านบนก่อนทำการจอง)
				</p>

				<c:choose>
    <c:when test="${not empty monthlyGoodDaysByWeekday}">
        <div class="yearly-summary-grid">
            <c:forEach var="month" items="${monthlyGoodDaysByWeekday}">
                <div class="yearly-summary-card">
                    <h4 class="yearly-summary-month">ฤกษ์ดีประจำเดือน ${month.monthName} 2569</h4>
                    <ul class="yearly-summary-list">
                        <c:forEach var="row" items="${month.weekdayRows}">
                            <li>วัน${row.weekday} ${row.daysText}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <p class="section-subtitle">ยังไม่มีข้อมูลฤกษ์ดีสรุปรายเดือนในขณะนี้</p>
    </c:otherwise>
</c:choose>
			</div>
		</div>
	</section>

	<%-- ========== THAI KANOK DIVIDER ========== --%>
	<svg class="thai-divider" viewBox="0 0 1200 48"
		xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none"
		style="display: block; background: #FFF8E1;">
    <line x1="0" y1="24" x2="1200" y2="24" stroke="#E8CC70"
			stroke-width="1" opacity="0.6" />
    <circle cx="600" cy="24" r="4" fill="#E8BB3A" />
</svg>

	<%-- ========== ปฏิทินล้านนา ========== --%>
	<section class="section-pad section-calendar" id="lannaCalendarSection">
		<div class="container">
			<div class="section-header">
				<h2 class="section-title">ปฏิทินล้านนา</h2>
				<p class="section-subtitle">ฤกษ์ดีตามปฏิทินล้านนา
					สำหรับผู้ที่ต้องการยึดตามธรรมเนียมคนเมือง</p>
				<div class="gold-line"></div>
			</div>

			<div class="lc-calendar">
				<div id="lc-year-card" class="lc-year-card loading">กำลังโหลดข้อมูลปี...</div>

				<div class="lc-controls">
					<button type="button" class="lc-nav-btn" id="lc-prev-month">&#8249;</button>
					<div class="lc-month-title" id="lc-month-title"></div>
					<button type="button" class="lc-nav-btn" id="lc-next-month">&#8250;</button>
				</div>

				<div class="lc-card">
					<div class="lc-grid" id="lc-grid">
						<div class="lc-day-label">อา</div>
						<div class="lc-day-label">จ</div>
						<div class="lc-day-label">อ</div>
						<div class="lc-day-label">พ</div>
						<div class="lc-day-label">พฤ</div>
						<div class="lc-day-label">ศ</div>
						<div class="lc-day-label">ส</div>
					</div>

					<div class="lc-legend">
						<span><span class="lc-legend-dot" style="background: var(--lc-good-bg); border: 1.5px solid var(--lc-good-border);"></span>วันดี</span>
						<span><span class="lc-legend-dot" style="background: var(--lc-bad-bg); border: 1.5px solid var(--lc-bad-border);"></span>วันควรเลี่ยง</span>
						<span><span class="lc-legend-dot" style="background: var(--lc-today-bg); border: 1.5px solid var(--lc-today-border);"></span>วันนี้</span>
					</div>
				</div>

				<div class="lc-day-detail" id="lc-day-detail">
					<p class="lc-day-detail-empty">คลิกวันที่ในตารางเพื่อดูรายละเอียดฤกษ์ของวันนั้น</p>
				</div>
			</div>
		</div>
	</section>

	<%-- ========== FOOTER (ใหม่ — ไม่มีเมนู, สีตรงกับแถบเมนูบนสุด) ========== --%>
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
				<p>📞 โทร. 08X-XXX-XXXX</p>
				<p>💬 LINE OA: @boonmee</p>
				<p>✉️ boonmee@gmail.com</p>
				<p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
			</div>
		</div>
		<div class="footer-bottom">
			<p>ด้วยใจที่ตั้งใจดูแลทุกพิธี 🪷 บุญมี รับจัดงานบุญ</p>
		</div>
	</footer>

	<%-- ========== SCRIPT ZONE: ปฏิทิน (ฤกษ์ดี) ========== --%>
	<script>
    window.contextPath = "${pageContext.request.contextPath}";

    window.bookedDates = [
        <c:forEach var="d" items="${bookedDates}" varStatus="st">
            "${d}"<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    window.teamCount = ${empty teamCount ? 2 : teamCount};
    window.bookingsPerDate = {
        <c:forEach var="entry" items="${bookingsPerDate}" varStatus="st">
            "${entry.key}": ${entry.value}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    };

    window.dayQuality = {
        <c:forEach var="entry" items="${dayQuality}" varStatus="st">
            "${entry.key}": [
                <c:forEach var="tag" items="${entry.value}" varStatus="st2">
                    { type: "${tag.type}", label: "${tag.label}" }<c:if test="${!st2.last}">,</c:if>
                </c:forEach>
            ]<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    };

    // ปฏิทินหน้านี้ใช้ดูข้อมูลอย่างเดียว ไม่เปิด popup เลือกประเภทงานบุญจากการคลิกวันแล้ว
    // (การจองย้ายไปเริ่มที่หน้าแพ็กเกจ/รายละเอียดงานบุญแทน)
    window.calendarReadOnly = true;

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
    </script>
	<script src="${pageContext.request.contextPath}/static/js/home.js?v=13"></script>

	<%-- ========== SCRIPT ZONE: ปฏิทินล้านนา ==========
	     calendar.js รวม data layer (LannaCalendar) กับตัวแสดงผลแบบ grid ไว้ในไฟล์เดียว
	     แล้วสั่ง init ทีเดียว — ไม่มี logic ฝังใน JSP อีกต่อไป --%>
	<script src="${pageContext.request.contextPath}/static/js/calendar.js?v=1"></script>
	<script>
		document.addEventListener("DOMContentLoaded", function () {
			initLannaCalendar('${pageContext.request.contextPath}/static/data');
		});
	</script>

</body>
</html>
