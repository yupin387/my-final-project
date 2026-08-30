<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการจอง - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bookingList.css">
</head>
<body>

   <!-- ===== NAVBAR (same style as home) ===== -->
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
        <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"    class="nav-item active">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff"  class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"   class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"   class="nav-item">จัดการใบเสนอราคา</a>
        </nav>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">A</div>
            <div class="user-detail">
                <span class="user-name">Admin Organizer</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</nav>

<!-- ===== PAGE WRAPPER ===== -->
<div class="page-wrapper">

    <!-- ===== Flash Message ===== -->
    <c:if test="${not empty success}">
        <div class="flash-banner flash-banner-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="flash-banner flash-banner-error">${error}</div>
    </c:if>


    <!-- Page header with ornament -->
    <div class="list-header">
        <div class="section-ornament">
            <div class="ornament-line"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-diamond"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-line right"></div>
        </div>
        <h1>จัดการรายการจอง</h1>
        <div class="gold-line"></div>
    </div>

    <!-- ===== STATUS FILTER DROPDOWN ===== -->
    <div class="status-filter-wrapper">
        <span class="status-filter-label">▼ สถานะการจอง :</span>

        <div class="status-filter-box" onclick="toggleStatusFilter()">
            <span class="status-filter-current">
                <c:choose>
                    <c:when test="${currentStatus == 'All'}">
                        <span class="dot dot-all"></span> ทั้งหมด <span class="count-badge">${countAll}</span>
                    </c:when>
                    <c:when test="${currentStatus == 'Pending'}">
                        <span class="dot dot-pending"></span> งานใหม่ <span class="count-badge">${countPending}</span>
                    </c:when>
                    <c:when test="${currentStatus == 'Confirmed'}">
                        <span class="dot dot-confirmed"></span> ยืนยันแล้ว <span class="count-badge">${countConfirmed}</span>
                    </c:when>
                    <c:when test="${currentStatus == 'Completed'}">
                        <span class="dot dot-completed"></span> เสร็จสิ้นแล้ว <span class="count-badge">${countCompleted}</span>
                    </c:when>
                    <c:when test="${currentStatus == 'Rejected'}">
                        <span class="dot dot-rejected"></span> ปฏิเสธ <span class="count-badge">${countRejected}</span>
                    </c:when>
                </c:choose>
            </span>
            <span class="status-filter-arrow" id="statusFilterArrow">▾</span>
        </div>

        <div class="status-filter-dropdown" id="statusFilterDropdown">
            <a href="${pageContext.request.contextPath}/organizer/bookings?status=All" class="status-filter-item ${currentStatus == 'All' ? 'selected' : ''}">
                <span class="dot dot-all"></span> ทั้งหมด <span class="count-badge">${countAll}</span>
            </a>
            <a href="${pageContext.request.contextPath}/organizer/bookings?status=Pending" class="status-filter-item ${currentStatus == 'Pending' ? 'selected' : ''}">
                <span class="dot dot-pending"></span> งานใหม่ <span class="count-badge">${countPending}</span>
            </a>
            <a href="${pageContext.request.contextPath}/organizer/bookings?status=Confirmed" class="status-filter-item ${currentStatus == 'Confirmed' ? 'selected' : ''}">
                <span class="dot dot-confirmed"></span> ยืนยันแล้ว <span class="count-badge">${countConfirmed}</span>
            </a>
            <a href="${pageContext.request.contextPath}/organizer/bookings?status=Completed" class="status-filter-item ${currentStatus == 'Completed' ? 'selected' : ''}">
                <span class="dot dot-completed"></span> เสร็จสิ้นแล้ว <span class="count-badge">${countCompleted}</span>
            </a>
            <a href="${pageContext.request.contextPath}/organizer/bookings?status=Rejected" class="status-filter-item ${currentStatus == 'Rejected' ? 'selected' : ''}">
                <span class="dot dot-rejected"></span> ปฏิเสธ <span class="count-badge">${countRejected}</span>
            </a>
        </div>
    </div>

    <!-- TABLE CARD -->
    <div class="content-card">
        <div class="card-header-bar">
            <span class="header-count">พบทั้งหมด ${fn:length(bookings)} รายการ</span>
        </div>

        <table>
            <thead>
                <tr>
                    <th>วันจัดงาน</th>
                    <th>ชื่อลูกค้า</th>
                    <th>ประเภทพิธี</th>
                    <th>หัวหน้างานปัจจุบัน</th>
                    <th>สถานะงาน</th>
                    <th>ดำเนินการ</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="b" items="${bookings}">
                    <tr>
                        <td><strong><fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy"/></strong></td>
                        <td>
                            <span class="customer-name">${b.member.memberFirstName} ${b.member.memberLastName}</span>
                        </td>
                        <td>${b.ceremony.ceremonyType}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty b.quotation.staff}">
                                    <span class="staff-badge">${b.quotation.staff.staffFirstName} ${b.quotation.staff.staffLastName}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-staff">ยังไม่ได้มอบหมาย</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="badge badge-${b.bookingStatus}">
                                <c:choose>
                                    <c:when test="${b.bookingStatus == 'Pending'}">รอดำเนินการ</c:when>
                                    <c:when test="${b.bookingStatus == 'Quoted'}">เสนอราคาแล้ว</c:when>
                                    <c:when test="${b.bookingStatus == 'Approved'}">อนุมัติแล้ว</c:when>
                                    <c:when test="${b.bookingStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
                                    <c:when test="${b.bookingStatus == 'Assigned'}">มอบหมายงานแล้ว</c:when>
                                    <c:when test="${b.bookingStatus == 'Preparing'}">กำลังเตรียมงาน</c:when>
                                    <c:when test="${b.bookingStatus == 'In_Progress'}">กำลังดำเนินงาน</c:when>
                                    <c:when test="${b.bookingStatus == 'Completed'}">เสร็จสิ้นแล้ว</c:when>
                                    <c:when test="${b.bookingStatus == 'Rejected'}">ปฏิเสธแล้ว</c:when>
                                    <c:otherwise>${b.bookingStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${empty b.quotation.staff}">
                                    <a href="${pageContext.request.contextPath}/organizer/assignments/assign/${b.bookingId}"
                                       class="btn-action btn-assign">มอบหมายงาน</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/organizer/assignments/assign/${b.bookingId}?mode=change"
                                       class="btn-action btn-change">เปลี่ยนตัว</a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty bookings}">
                    <tr>
                        <td colspan="6">
                            <div class="empty-state">
                                <div style="font-size:3rem;"></div>
                                <p>ไม่มีรายการในสถานะนี้</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- ===== FOOTER ===== -->
<footer class="site-footer">
    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับทีมงานและผู้ดูแลระบบ</p>
    </div>

</footer>

<script>
function toggleStatusFilter() {
    var dropdown = document.getElementById('statusFilterDropdown');
    var arrow = document.getElementById('statusFilterArrow');
    dropdown.classList.toggle('show');
    arrow.textContent = dropdown.classList.contains('show') ? '▴' : '▾';
}
document.addEventListener('click', function(e) {
    if (!e.target.closest('.status-filter-wrapper')) {
        document.getElementById('statusFilterDropdown').classList.remove('show');
        document.getElementById('statusFilterArrow').textContent = '▾';
    }
});

function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}
document.addEventListener('click', function(e) {
    if (!e.target.closest('.user-info')) {
        document.getElementById('dropdownMenu').classList.remove('show');
    }
});
</script>
</body>
</html>
