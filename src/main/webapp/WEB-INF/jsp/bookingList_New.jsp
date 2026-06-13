<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <title>รายการจองใหม่ - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
    <a href="?status=Pending"   class="tab-btn ${currentStatus == 'Pending'   ? 'active' : ''}">งานใหม่</a>
    <a href="?status=Confirmed" class="tab-btn ${currentStatus == 'Confirmed' ? 'active' : ''}">ยืนยันแล้ว</a>
    <a href="?status=Completed" class="tab-btn tab-completed ${currentStatus == 'Completed' ? 'active' : ''}">เสร็จสิ้นแล้ว</a>
    <a href="?status=Rejected"  class="tab-btn tab-rejected ${currentStatus == 'Rejected' ? 'active' : ''}">ปฏิเสธ</a>
</div>

        <!-- TABLE CARD -->
        <div class="content-card">
            <div class="card-header-bar">
                <span>รายการ: ${currentStatus}</span>
                <span class="header-count">พบทั้งหมด ${fn:length(bookings)} รายการ</span>
            </div>

            <c:choose>
                <c:when test="${empty bookings}">
                    <div class="empty-state">
                        <p>ไม่พบรายการในสถานะนี้</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>วันที่จอง</th>
                                <th>ชื่อลูกค้า / เบอร์โทร</th>
                                <th>ประเภทพิธี</th>
                                <th>วันจัดงาน</th>
                                <th>สถานะ</th>
                                <th>จัดการงาน</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td><fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <span class="customer-name">${b.member.memberFirstName} ${b.member.memberLastName}</span>
                                        <span class="customer-phone">${b.member.phoneNumber}</span>
                                    </td>
                                    <td>
                                        <span class="ceremony-badge">${b.ceremony.ceremonyName}</span>
                                    </td>
                                    <td><fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <span class="badge badge-${b.bookingStatus}">${b.bookingStatus}</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/organizer/bookings/detail/${b.bookingId}"
                                           class="btn-action btn-view"> ดูรายละเอียด</a>
                                      
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <script src="${pageContext.request.contextPath}/static/js/bookingList.js"></script>
</body>
</html>
