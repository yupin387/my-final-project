<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>จัดการการมอบหมายงาน - ระบบรับจัดงานบุญ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bookingList.css">
</head>
<body>

<!-- ===== NAVBAR (same style as home) ===== -->
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings">
        <div class="lotus-icon">🪷</div>
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"    class="nav-item active">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff"  class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"   class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"   class="nav-item">ใบเสนอราคา</a>
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

    <!-- TABS -->
    <div class="tabs-wrapper">
        <a href="?status=Pending"   class="tab-btn ${currentStatus == 'Pending'   ? 'active' : ''}"> งานใหม่</a>
        <a href="?status=Confirmed" class="tab-btn ${currentStatus == 'Confirmed' ? 'active' : ''}"> ยืนยันแล้ว</a>
        <a href="?status=Completed" class="tab-btn tab-completed ${currentStatus == 'Completed' ? 'active' : ''}">เสร็จสิ้นแล้ว</a>
        <a href="?status=Rejected"  class="tab-btn tab-rejected  ${currentStatus == 'Rejected'  ? 'active' : ''}">ปฏิเสธ</a>
    </div>

    <!-- TABLE CARD -->
    <div class="content-card">
        <div class="card-header-bar">
            <span>รายการสถานะ: ${currentStatus}</span>
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
                        <td>${b.ceremony.ceremonyName}</td>
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
                            <span class="badge badge-${b.bookingStatus}">${b.bookingStatus}</span>
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


<script>
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
