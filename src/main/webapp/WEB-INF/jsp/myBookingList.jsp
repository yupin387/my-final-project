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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/myBooking.css?v=16">

    <%-- สไตล์เฉพาะของแท็บและปุ่มรีวิว (เขียนไว้ในหน้านี้เพื่อไม่ต้องแก้ไฟล์ CSS เดิม) --%>
    <style>
        .mybooking-tabs {
            display: flex;
            gap: 8px;
            padding: 14px 18px 0;
            border-bottom: 1px solid #F2D9E2;
            flex-wrap: wrap;
        }
        .mybooking-tab {
            background: transparent;
            border: 1px solid transparent;
            border-bottom: none;
            padding: 9px 18px;
            border-radius: 10px 10px 0 0;
            font-family: 'Sarabun', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            color: #9A6B7B;
            cursor: pointer;
            transition: all .15s ease;
        }
        .mybooking-tab:hover { color: #B0345A; background: #FDF1F5; }
        .mybooking-tab.active {
            color: #B0345A;
            background: #FFFFFF;
            border-color: #F2D9E2;
            box-shadow: inset 0 3px 0 #E0577F;
        }
        .mybooking-tab .tab-count {
            display: inline-block;
            min-width: 20px;
            margin-left: 6px;
            padding: 1px 7px;
            border-radius: 999px;
            background: #FBD0DE;
            color: #B0345A;
            font-size: 0.78rem;
            font-weight: 700;
        }
        .mybooking-tab.active .tab-count { background: #E0577F; color: #FFFFFF; }
        .mybooking-tab-panel { display: none; }
        .mybooking-tab-panel.active { display: block; }

        .btn-mybooking-review {
            background: #D9A441;
            color: #FFFFFF !important;
            border: 1px solid #C08F2E;
        }
        .btn-mybooking-review:hover { background: #C08F2E; }
        .btn-mybooking-reviewed {
            background: #F3F3F3;
            color: #999999 !important;
            border: 1px solid #E5E5E5;
            cursor: default;
        }
    </style>
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

<%-- ===== นับจำนวนของแต่ละแท็บไว้ก่อน เพื่อเอาไปแสดงบนหัวแท็บ ===== --%>
<c:set var="activeCount" value="0"/>
<c:set var="historyCount" value="0"/>
<c:forEach var="b" items="${bookings}">
    <c:choose>
        <c:when test="${b.bookingStatus == 'Completed' or b.bookingStatus == 'Cancelled' or b.bookingStatus == 'Rejected'}">
            <c:set var="historyCount" value="${historyCount + 1}"/>
        </c:when>
        <c:otherwise>
            <c:set var="activeCount" value="${activeCount + 1}"/>
        </c:otherwise>
    </c:choose>
</c:forEach>

<%-- ===== SECTION HEADER ===== --%>
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
        <p style="color: #777777; font-size: 0.95rem;">ติดตามสถานะการจองที่กำลังดำเนินการ และดูประวัติงานบุญที่ผ่านมาของท่าน</p>
    </div>

    <div class="mybooking-card">

        <%-- ===== แท็บ: กำลังดำเนินการ / ประวัติการจอง ===== --%>
        <div class="mybooking-tabs">
            <button type="button" class="mybooking-tab active" data-tab="tabActive" onclick="switchBookingTab('tabActive', this)">
                กำลังดำเนินการ <span class="tab-count">${activeCount}</span>
            </button>
            <button type="button" class="mybooking-tab" data-tab="tabHistory" onclick="switchBookingTab('tabHistory', this)">
                ประวัติการจอง <span class="tab-count">${historyCount}</span>
            </button>
        </div>

        <%-- ================= แท็บที่ 1: กำลังดำเนินการ ================= --%>
        <div class="mybooking-tab-panel active" id="tabActive">
            <div class="mybooking-card-header">
                <span>รายการที่กำลังดำเนินการ</span>
                <span class="mybooking-count">พบทั้งหมด ${activeCount} รายการ</span>
            </div>

            <c:choose>
                <c:when test="${activeCount == 0}">
                    <div class="mybooking-empty">
                        <p>ขณะนี้ท่านไม่มีรายการจองที่กำลังดำเนินการ</p>
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
                                    <c:if test="${b.bookingStatus != 'Completed' and b.bookingStatus != 'Cancelled' and b.bookingStatus != 'Rejected'}">
                                        <tr>
                                            <td><strong>${b.bookingId}</strong></td>
                                            <td><fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>${b.ceremony.ceremonyType}</td>
                                            <td>
                                                <span class="mb-badge mb-badge-${b.bookingStatus}">
                                                    <c:choose>
                                                        <c:when test="${b.bookingStatus == 'Pending'}">รอดำเนินการ</c:when>
                                                        <c:when test="${b.bookingStatus == 'Approved'}">อนุมัติแล้ว</c:when>
                                                        <c:when test="${b.bookingStatus == 'Quoted'}">ออกใบเสนอราคาแล้ว</c:when>
                                                        <c:when test="${b.bookingStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
                                                        <c:otherwise>${b.bookingStatus}</c:otherwise>
                                                    </c:choose>
                                                </span>
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
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- ================= แท็บที่ 2: ประวัติการจอง ================= --%>
        <div class="mybooking-tab-panel" id="tabHistory">
            <div class="mybooking-card-header">
                <span>ประวัติการจองที่สิ้นสุดแล้ว</span>
                <span class="mybooking-count">พบทั้งหมด ${historyCount} รายการ</span>
            </div>

            <c:choose>
                <c:when test="${historyCount == 0}">
                    <div class="mybooking-empty">
                        <p>ยังไม่มีประวัติการจองที่สิ้นสุดแล้ว</p>
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
                                    <c:if test="${b.bookingStatus == 'Completed' or b.bookingStatus == 'Cancelled' or b.bookingStatus == 'Rejected'}">
                                        <tr>
                                            <td><strong>${b.bookingId}</strong></td>
                                            <td><fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>${b.ceremony.ceremonyType}</td>
                                            <td>
                                                <span class="mb-badge mb-badge-${b.bookingStatus}">
                                                    <c:choose>
                                                        <c:when test="${b.bookingStatus == 'Completed'}">เสร็จสิ้น</c:when>
                                                        <c:when test="${b.bookingStatus == 'Cancelled'}">ยกเลิกแล้ว</c:when>
                                                        <c:when test="${b.bookingStatus == 'Rejected'}">ปฏิเสธแล้ว</c:when>
                                                        <c:otherwise>${b.bookingStatus}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="mybooking-actions">
                                                <a href="${pageContext.request.contextPath}/viewBooking/${b.bookingId}"
                                                   class="btn-mybooking btn-mybooking-view">ดูรายละเอียด</a>

                                                <%-- ปุ่มรีวิว: กดรีวิวได้จากหน้ารายการนี้เลย ไม่ต้องเข้าไปหน้ารายละเอียดก่อน --%>
                                                <c:if test="${b.bookingStatus == 'Completed'}">
                                                    <c:set var="isReviewed"
                                                           value="${not empty reviewedBookingIds and reviewedBookingIds.contains(b.bookingId)}"/>
                                                    <c:choose>
                                                        <c:when test="${isReviewed}">
                                                            <span class="btn-mybooking btn-mybooking-reviewed">รีวิวแล้ว</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/review/write/${b.bookingId}"
                                                               class="btn-mybooking btn-mybooking-review">★ เขียนรีวิว</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

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

// สลับแท็บ "กำลังดำเนินการ" / "ประวัติการจอง"
function switchBookingTab(panelId, btn) {
    document.querySelectorAll('.mybooking-tab-panel').forEach(function(p) {
        p.classList.remove('active');
    });
    document.querySelectorAll('.mybooking-tab').forEach(function(t) {
        t.classList.remove('active');
    });
    var panel = document.getElementById(panelId);
    if (panel) panel.classList.add('active');
    if (btn) btn.classList.add('active');
    try { sessionStorage.setItem('myBookingTab', panelId); } catch (err) {}
}

// จำแท็บล่าสุดที่เปิดไว้ เวลากลับมาจากหน้ารายละเอียดจะได้อยู่แท็บเดิม
document.addEventListener('DOMContentLoaded', function() {
    var saved = null;
    try { saved = sessionStorage.getItem('myBookingTab'); } catch (err) {}
    if (saved) {
        var btn = document.querySelector('.mybooking-tab[data-tab="' + saved + '"]');
        if (btn) switchBookingTab(saved, btn);
    }
});
</script>
</body>
</html>
