<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายชื่อหัวหน้างาน - ระบบรับจัดงานบุญ</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/headStaffList.css">
</head>
<body>

<%-- ===== NAVBAR ===== --%>
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings">
        <div class="lotus-icon">🪷</div>
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item active">หัวหน้างาน</a>
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
</nav>


<%-- ===== PAGE WRAPPER ===== --%>
<div class="page-wrapper">

    <%-- Alert --%>
    <c:if test="${not empty success}">
        <div class="alert success">✓ ${success}</div>
    </c:if>

    <%-- Header --%>
    <div class="list-header">
        <div class="list-header-text">
            <div class="section-ornament">
                <div class="ornament-line"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-diamond"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-line right"></div>
            </div>
            <h1>รายชื่อหัวหน้างาน</h1>
            <p>ตรวจสอบและจัดการข้อมูลหัวหน้างานทั้งหมดในระบบ</p>
            <div class="gold-line"></div>
        </div>
        <a href="${pageContext.request.contextPath}/organizer/head-staff/add" class="btn-add">
            + เพิ่มหัวหน้างาน
        </a>
    </div>

    <%-- Table Card --%>
    <div class="content-card">
        <div class="card-header-bar">
            <span> รายชื่อหัวหน้างานทั้งหมด</span>
            <span class="header-count">จำนวนทั้งหมด ${staffList.size()} รายการ</span>
        </div>

        <table>
            <thead>
                <tr>
                    <th width="7%">ลำดับ</th>
                    <th width="32%">ชื่อ-นามสกุล</th>
                    <th width="20%">เบอร์โทรศัพท์</th>
                    <th width="28%">อีเมล</th>
                    <th width="13%" style="text-align:center;">จัดการ</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="staff" items="${staffList}" varStatus="status">
                    <tr>
                        <td style="color:var(--text-muted); font-weight:600;">${status.index + 1}</td>
                        <td>
                            <div class="staff-avatar-cell">
                                <div class="staff-avatar-mini">
                                    ${staff.staffFirstName.substring(0,1)}
                                </div>
                                <strong>${staff.staffFirstName} ${staff.staffLastName}</strong>
                            </div>
                        </td>
                        <td>${staff.staffPhone}</td>
                        <td style="color:var(--text-muted);">${staff.staffEmail}</td>
                        <td style="text-align:center;">
                            <form id="deleteForm-${staff.staffId}"
                                  action="${pageContext.request.contextPath}/organizer/head-staff/delete/${staff.staffId}"
                                  method="post">
                                <button type="button" class="btn-delete"
                                        onclick="confirmDelete('${staff.staffId}', '${staff.staffFirstName} ${staff.staffLastName}')">
                                    🗑 ลบ
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty staffList}">
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <div style="font-size:3rem; margin-bottom:12px;">🪷</div>
                                ยังไม่มีข้อมูลหัวหน้างานในระบบ
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>



<script src="${pageContext.request.contextPath}/static/js/headStaffList.js"></script>

</body>
</html>
