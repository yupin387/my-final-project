<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>จัดการรายการจอง - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bookingList.css">
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <span class="navbar-title">ระบบรับจัดงานบุญ</span>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"  class="nav-item active">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"  class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item">ใบเสนอราคา</a>
        </nav>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">A</div>
            <div class="user-detail">
                <span class="user-name">Admin Organizer</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <span class="arrow">▾</span>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</div>

<div class="page-wrapper">

    <div class="list-header">
        <div>
            <h1>จัดการรายการจอง</h1>
            <p>บริหารจัดการและติดตามสถานะงานพิธีกรรม</p>
        </div>
    </div>

    <%-- ✅ ย้าย banner มาไว้ใต้ list-header --%>
    <c:if test="${not empty success}">
        <div class="success-banner"> ${success}</div>
    </c:if>

    <!-- Tabs -->
    <div class="tabs-wrapper">
        <a href="?status=Pending"   class="tab-btn ${currentStatus == 'Pending'   || empty currentStatus ? 'active' : ''}">งานใหม่</a>
        <a href="?status=Quoted"    class="tab-btn ${currentStatus == 'Quoted'    ? 'active' : ''}">เสนอราคาแล้ว</a>
        <a href="?status=Confirmed" class="tab-btn ${currentStatus == 'Confirmed' ? 'active' : ''}">ยืนยันแล้ว</a>
        <a href="?status=Completed" class="tab-btn ${currentStatus == 'Completed' ? 'active' : ''}">✅ เสร็จสิ้นแล้ว</a>
        <a href="?status=Rejected"  class="tab-btn ${currentStatus == 'Rejected'  ? 'active' : ''}">ปฏิเสธ</a>
    </div>

    <!-- Table Card -->
    <div class="content-card">
        <div class="card-header-bar">
            <span>รายการ: ${empty currentStatus ? 'งานใหม่' : currentStatus}</span>
            <span class="header-count">พบทั้งหมด ${bookings.size()} รายการ</span>
        </div>

        <table>
            <thead>
                <tr>
                    <th width="12%">วันที่จอง</th>
                    <th width="22%">ชื่อลูกค้า / เบอร์โทร</th>
                    <th width="18%">ประเภทพิธี</th>
                    <th width="14%">วันจัดงาน</th>
                    <th width="12%">สถานะ</th>
                    <th width="22%">จัดการงาน</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="b" items="${bookings}">
                    <tr>
                        <td class="date-cell">
                            <fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy" />
                        </td>
                        <td>
                            <span class="customer-name">${b.member.memberFirstName} ${b.member.memberLastName}</span>
                            <span class="customer-phone"> ${b.member.phoneNumber}</span>
                        </td>
                        <td><span class="ceremony-name">${b.ceremony.ceremonyName}</span></td>
                        <td class="date-cell">
                            <strong><fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy" /></strong>
                        </td>
                        <td>
                            <span class="status-badge badge-${b.bookingStatus}">
                                <c:choose>
                                    <c:when test="${b.bookingStatus == 'Pending'}">รอดำเนินการ</c:when>
                                    <c:when test="${b.bookingStatus == 'Quoted'}">เสนอราคาแล้ว</c:when>
                                    <c:when test="${b.bookingStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
                                    <c:when test="${b.bookingStatus == 'Assigned'}">มอบหมายแล้ว</c:when>
                                    <c:when test="${b.bookingStatus == 'Preparing'}">กำลังเตรียม</c:when>
                                    <c:when test="${b.bookingStatus == 'In_Progress'}">กำลังดำเนินการ</c:when>
                                    <c:when test="${b.bookingStatus == 'Completed'}">เสร็จสิ้น</c:when>
                                    <c:otherwise>${b.bookingStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <div class="btn-group">
                                <c:choose>
                                    <c:when test="${b.bookingStatus == 'Pending'}">
                                        <a href="${pageContext.request.contextPath}/organizer/bookings/detail/${b.bookingId}" class="btn-action btn-view"> ดูข้อมูล</a>
                                        <a href="${pageContext.request.contextPath}/organizer/quotation/create/${b.bookingId}" class="btn-action btn-create"> ทำใบเสนอราคา</a>
                                    </c:when>
                                    <c:when test="${b.bookingStatus == 'Quoted'}">
                                        <a href="${pageContext.request.contextPath}/organizer/quotation/detail/QT-${b.bookingId}" class="btn-action btn-view">ดูใบเสนอราคา</a>
                                    </c:when>
                                    <c:when test="${b.bookingStatus == 'Confirmed'}">
                                        <a href="${pageContext.request.contextPath}/organizer/assignment/assign/${b.bookingId}" class="btn-action btn-assign">มอบหมายงาน</a>
                                    </c:when>
                                    <c:when test="${b.bookingStatus == 'Assigned' || b.bookingStatus == 'Preparing' || b.bookingStatus == 'In_Progress'}">
                                        <a href="${pageContext.request.contextPath}/organizer/assignment/update-status/${b.bookingId}" class="btn-action btn-status">อัปเดตงาน</a>
                                        <a href="${pageContext.request.contextPath}/organizer/assignment/assign/${b.bookingId}?mode=change" class="btn-action btn-change">เปลี่ยนหัวหน้างาน</a>
                                    </c:when>
                                    <c:when test="${b.bookingStatus == 'Completed'}">
                                        <span class="completed-text">งานสำเร็จเรียบร้อย</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/organizer/bookings/detail/${b.bookingId}" class="btn-action btn-view"> ดูข้อมูล</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty bookings}">
                    <tr>
                        <td colspan="6" class="empty-state">
                            <span class="empty-icon"></span>
                            <p>ไม่พบรายการในหมวดหมู่นี้</p>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</div>

<script src="${pageContext.request.contextPath}/static/js/bookingList.js"></script>
</body>
</html>