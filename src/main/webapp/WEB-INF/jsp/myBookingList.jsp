<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการจองของฉัน - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/myBooking.css?v=15">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/myBooking.css?v=16">
</head>
<body>

<%-- ===== NAVBAR ===== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
        </div>
        <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item">หน้าหลัก</a>
        <div class="dropdown-wrap nav-dropdown">
            <a href="javascript:void(0);" class="nav-link-item" onclick="toggleServiceDropdown(event)">
                บริการ/แพ็กเกจ ▾
            </a>
            <div class="dropdown-menu-custom" id="serviceDropdownMenu">
                <c:forEach var="ct" items="${ceremonyTypes}">
                    <a href="${pageContext.request.contextPath}/ceremony/detail/${ct.representativeId}"
                       class="dropdown-link">${ct.mainName}</a>
                </c:forEach>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/calendar" class="nav-link-item">ปฏิทิน</a>
        <a href="${pageContext.request.contextPath}/myBookings" class="nav-link-item active">รายการจอง</a>
        <a href="${pageContext.request.contextPath}/reviews" class="nav-link-item">รีวิว</a>
    </div>
    <div class="dropdown-wrap">
        <div class="user-profile-pill" onclick="toggleDropdown()">
            <div class="avatar-circle-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
            <div class="user-info-text">
                <span class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
                <span class="user-role-nav">สมาชิก</span>
            </div>
        </div>
        <div class="dropdown-menu-custom" id="dropdownMenu">
            <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-link">โปรไฟล์ของฉัน</a>
            <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">ออกจากระบบ</a>
        </div>
    </div>
</nav>

<%-- ===== SECTION HEADER (แบบหน้า Home: มีรูปดอกบัวและเส้นคั่นทอง) ===== --%>
<div class="page-wrapper">
    <div class="section-header-wrap" style="text-align: center; margin-top: 30px; margin-bottom: 30px;">
        <div class="header-lotus-icon" style="margin-bottom: 8px;">
            <img src="${pageContext.request.contextPath}/static/images/img25.png" alt="ดอกบัว" style="width: 48px; height: auto;">
        </div>
        <div class="section-ornament" style="display: flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 10px;">
            <span class="ornament-line" style="width: 100px; height: 1px; background: #D9A441;"></span>
            <span class="ornament-diamond" style="width: 6px; height: 6px; background: #D9A441; transform: rotate(45deg);"></span>
            <span class="ornament-line right" style="width: 100px; height: 1px; background: #D9A441;"></span>
        </div>
        <h1 style="font-family: 'Sarabun', sans-serif; font-size: 2rem; font-weight: 700; color: #1A1A1A; margin-bottom: 6px;">รายการจองงานบุญ</h1>
        <p style="color: #777777; font-size: 0.95rem;">ดูสถานะ รายละเอียด และใบเสนอราคาของการจองแต่ละรายการ</p>
    </div>

    <div class="mybooking-card">
        <div class="mybooking-card-header">
            <span>รายการจองทั้งหมดของฉัน</span>
            <span class="mybooking-count">พบทั้งหมด ${fn:length(bookings)} รายการ</span>
        </div>

        <c:choose>
        <c:when test="${empty bookings}">
            <div class="mybooking-empty">
                <p>คุณยังไม่มีรายการจอง</p>
                <a href="${pageContext.request.contextPath}/home" class="btn-mybooking btn-mybooking-primary">จองงานบุญเลย</a>
            </div>
        </c:when>
        <c:otherwise>
        <div class="mybooking-table-wrap">
            <table class="mybooking-table">
                <thead>
                    <tr>
                        <th>รหัสจอง</th>
                        <th>วันที่จอง</th>
                        <th>วันจัดงาน</th>
                        <th>ประเภทพิธี</th>
                        <th>สถานะ</th>
                        <th>ดำเนินการ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td><strong>${b.bookingId}</strong></td>
                            <td><fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy"/></td>
                            <td>${b.ceremony.ceremonyType}</td>
                            <td>
                                <span class="mb-badge mb-badge-${b.bookingStatus}">${b.bookingStatus}</span>
                            </td>
                            <td class="mybooking-actions">
                                <a href="${pageContext.request.contextPath}/viewBooking/${b.bookingId}"
                                   class="btn-mybooking btn-mybooking-view">ดูรายละเอียด</a>

                                <c:choose>
                                    <c:when test="${not empty b.quotation}">
                                        <a href="${pageContext.request.contextPath}/member/quotation/detail/${b.quotation.quotationId}"
                                           class="btn-mybooking btn-mybooking-quote">ใบเสนอราคา</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="btn-mybooking btn-mybooking-disabled">รอใบเสนอราคา</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- ===== FOOTER ===== --%>
<footer class="site-footer">
    <div class="footer-top">
        <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
             style="display: block; width: 100%; height: 8px;">
            <rect width="1200" height="8" fill="url(#footerGrad)" />
            <defs>
                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
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
                    <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
                </div>
                <span class="footer-brand-text">บุญมี รับจัดงานบุญ</span>
            </div>
            <p class="footer-tagline">รับจัดงานบุญ ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
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
</footer>

<script>
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}
function toggleServiceDropdown(e) {
    e.stopPropagation();
    document.getElementById('serviceDropdownMenu').classList.toggle('show');
}
document.addEventListener('click', function(e) {
    if (!e.target.closest('.user-profile-pill')) {
        var m = document.getElementById('dropdownMenu');
        if (m) m.classList.remove('show');
    }
    if (!e.target.closest('.nav-dropdown')) {
        var s = document.getElementById('serviceDropdownMenu');
        if (s) s.classList.remove('show');
    }
});
</script>
</body>
</html>
