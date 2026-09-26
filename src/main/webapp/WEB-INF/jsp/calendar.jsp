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
<title>ปฏิทินฤกษ์ดี - บุญมีนำพา จัดงานบุญ</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/home.css?v=15">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/calendarPage.css?v=3">
<style>
.yearly-summary-hidden {
    display: none;
}
</style>
</head>
<body>

	<%-- ========== NAVBAR ========== --%>
	<nav class="navbar-custom">
		<a class="navbar-brand-wrap"
			href="${pageContext.request.contextPath}/home"
			style="text-decoration: none;"> <img
			src="${pageContext.request.contextPath}/static/images/logoo.png"
			alt="บุญมี รับจัดงานบุญ" class="lotus-icon"> <span
			class="nav-brand-text">บุญมีนำพา รับจัดงานบุญ</span>
		</a>
		<div class="navbar-center">
			<a href="${pageContext.request.contextPath}/home"
				class="nav-link-item">หน้าหลัก</a>

			<%-- ตัดลิงก์ "แพ็กเกจงานบุญทั้งหมด" ออก เหลือแค่ 3 งานบุญหลัก --%>
			<div class="nav-dropdown-wrap">
				<a href="${pageContext.request.contextPath}/home#packagesSection"
					class="nav-link-item nav-dropdown-toggle"> บริการ/แพ็กเกจ <span
					class="nav-caret">▾</span>
				</a>
				<div class="nav-dropdown-panel">
					<c:forEach var="t" items="${ceremonyTypes}">
						
							href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}"
							class="nav-dropdown-link">${t.mainName}</a>
					</c:forEach>
					<hr class="nav-dropdown-divider">

				</div>
			</div>

			<div class="nav-dropdown-wrap">
				<a href="${pageContext.request.contextPath}/calendar"
					class="nav-link-item nav-dropdown-toggle active"> ปฏิทิน <span
					class="nav-caret">▾</span>
				</a>
				<div class="nav-dropdown-panel">
					
						href="${pageContext.request.contextPath}/calendar#calendarSection"
						class="nav-dropdown-link">ปฏิทิน (ฤกษ์ดี)</a>
				</div>
			</div>

			<c:if test="${not empty sessionScope.user}">
				<a href="${pageContext.request.contextPath}/myBookings"
					class="nav-link-item">รายการจอง</a>

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
					พร้อมวันดี-วันฤกษ์มงคลของแต่ละวัน</p>
				<div class="gold-line"></div>
			</div>

			<%-- ========== กล่องคำอธิบาย "ฤกษ์ดี หมายถึง" ========== --%>
			<div class="cal-explain-box">
				<h3 class="cal-explain-title">ฤกษ์ดี หมายถึงอะไร?</h3>
				<p class="cal-explain-text">
					<strong>ฤกษ์ดี</strong> หมายถึง
					คราวหรือเวลาที่กำหนดหรือคาดว่าจะให้ผลดี
					เป็นความเชื่อทางโหราศาสตร์ไทยที่สืบทอดกันมาแต่โบราณ
					โดยอาศัยการคำนวณตำแหน่งของดวงดาวและการโคจรของดวงจันทร์ ดวงอาทิตย์
					ประกอบกับวันทางจันทรคติและสุริยคติ
					เพื่อกำหนดว่าวันใดเหมาะสมกับการเริ่มต้นทำกิจการงานใด
					ซึ่งส่วนใหญ่เราจะใช้คำนี้ในความหมายว่า <strong>"ฤกษ์ดีทำบุญ"</strong>
					ในการจัดงานบุญต่างๆ เช่น งานทำบุญบ้าน งานขึ้นบ้านใหม่
					งานเปิดสำนักงาน/เปิดออฟฟิศ
					โดยส่วนใหญ่จะนิยมจัดงานให้ตรงกับวันฤกษ์ดี
					เพื่อความเป็นสิริมงคลแก่เจ้าภาพและผู้มาร่วมงาน
					เชื่อกันว่าจะช่วยส่งเสริมให้กิจการงานนั้นราบรื่น เจริญรุ่งเรือง
					และประสบความสำเร็จ
				</p>

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
				<hr
					style="border: 0; border-top: 1px solid #f0e8c8; margin: 18px 0 14px;">
				<div class="cal-legend">
					<span><span class="legend-dot"
						style="background: var(--cal-booked-bg); border: 1.5px solid var(--cal-booked-border);"></span>เต็มคิว/มีงานแล้ว</span>
					<span><span class="legend-dot"
						style="background: var(--cal-almost-bg); border: 1.5px solid var(--cal-almost-border);"></span>เหลือคิวสุดท้าย</span>
					<span><span class="legend-dot"
						style="background: var(--cal-free-bg); border: 1.5px solid var(--cal-free-border);"></span>ว่าง</span>
					<span><span class="legend-dot"
						style="background: var(--cal-today-bg); border: 1.5px solid var(--cal-today-border);"></span>วันนี้</span>
					<span><span class="legend-star">★</span>ฤกษ์ดี</span>
				</div>
		
				<p class="cal-hint">ปฏิทินนี้แสดงสำหรับดูข้อมูลวันฤกษ์ดีและคิวว่างเท่านั้น
					กรุณาไปที่หน้า "บริการ/แพ็กเกจ" เพื่อทำการจองงานบุญ</p>
			</div>

			<div class="meaning-block">
				<h3 class="meaning-block-title">
					ความหมาย <span class="highlight">ฤกษ์ดี</span> จัดงานบุญ
				</h3>
				<div class="meaning-grid">
					<div class="meaning-card">
						<div class="meaning-card-title">วันราชาโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานที่ต้องขอความช่วยเหลือจากผู้ใหญ่
							เหมาะกับพิธีขึ้นบ้านใหม่หรือเปิดสำนักงานที่ต้องการแรงสนับสนุนจากผู้หลักผู้ใหญ่</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันมหาสิทธิโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานสำคัญที่เป็นโครงการระยะยาว
							เหมาะกับการเปิดสำนักงาน/ออฟฟิศใหม่ที่ต้องการความมั่นคงในระยะยาว</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันชัยโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานที่ต้องการความสำเร็จและชัยชนะ
							เหมาะกับการทำบุญขึ้นบ้านใหม่หรือเปิดกิจการ/เปิดสำนักงาน</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันอำมฤตโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานทั่วไปที่ต้องการความราบรื่น
							เหมาะกับพิธีทำบุญบ้านทั่วไป</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันอธิบดี</div>
						<div class="meaning-card-desc">ดีสำหรับงานสำคัญที่ต้องการความมั่นคง
							เป็นหลักฐาน เจริญก้าวหน้า เหมาะกับการเปิดสำนักงาน/ออฟฟิศ</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันธงชัย</div>
						<div class="meaning-card-desc">ดีสำหรับงานมงคลที่มีการเคลื่อนย้ายที่อยู่
							ให้ผลสำเร็จดี มีชัยชนะ
							เหมาะกับพิธีขึ้นบ้านใหม่หรือย้ายที่ทำการสำนักงาน</div>
					</div>
					<div class="meaning-card">
						<div class="meaning-card-title">วันสิทธิโชค</div>
						<div class="meaning-card-desc">ดีสำหรับงานสำคัญที่เป็นโครงการระยะสั้น
							เหมาะกับพิธีทำบุญบ้านหรืองานมงคลขนาดเล็ก</div>
					</div>
				</div>
			</div>

			<div class="yearly-summary-block">
				<h3 class="meaning-block-title">
					สรุป <span class="highlight">ฤกษ์ดีทำบุญ ปี 2569</span>
				</h3>
				<p class="section-subtitle" style="margin-bottom: 24px;">
					รวมวันฤกษ์ดีทั้ง 7 ประเภทของแต่ละเดือน ปี พ.ศ. 2569
					(ข้อมูลอัปเดตล่วงหน้า
					โปรดตรวจสอบวันที่แน่นอนอีกครั้งในปฏิทินด้านบนก่อนทำการจอง)</p>

				<c:choose>
					<c:when test="${not empty monthlyGoodDaysByWeekday}">
						<div class="yearly-summary-grid">
							<c:forEach var="month" items="${monthlyGoodDaysByWeekday}" varStatus="mStatus">
								<div class="yearly-summary-card${mStatus.index >= 4 ? ' yearly-summary-hidden' : ''}">
									<h4 class="yearly-summary-month">ฤกษ์ดีประจำเดือน
										${month.monthName} 2569</h4>
									<ul class="yearly-summary-list">
										<c:forEach var="row" items="${month.weekdayRows}">
											<li>วัน${row.weekday} ${row.daysText}</li>
										</c:forEach>
									</ul>
								</div>
							</c:forEach>
						</div>
						<c:if test="${fn:length(monthlyGoodDaysByWeekday) > 4}">
							<div style="text-align:center; margin-top:20px;">
								<button type="button" id="yearlySummaryToggleBtn"
										class="tab-btn" onclick="toggleYearlySummary()">
									ดูเพิ่มเติม ▾
								</button>
							</div>
						</c:if>
					</c:when>
					<c:otherwise>
						<p class="section-subtitle">ยังไม่มีข้อมูลฤกษ์ดีสรุปรายเดือนในขณะนี้</p>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</section>

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

    function toggleYearlySummary() {
        var hiddenCards = document.querySelectorAll('.yearly-summary-hidden');
        if (hiddenCards.length === 0) return;
        var btn = document.getElementById('yearlySummaryToggleBtn');
        var isCurrentlyHidden = window.getComputedStyle(hiddenCards[0]).display === 'none';

        hiddenCards.forEach(function (card) {
            card.style.display = isCurrentlyHidden ? 'block' : 'none';
        });

        btn.textContent = isCurrentlyHidden ? 'ย่อกลับ ▴' : 'ดูเพิ่มเติม ▾';
    }
    </script>
	<script src="${pageContext.request.contextPath}/static/js/home.js?v=13"></script>
	<script
		src="${pageContext.request.contextPath}/static/js/calendar.js?v=2"></script>
</body>
</html>