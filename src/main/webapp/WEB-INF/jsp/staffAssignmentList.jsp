<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการงานมอบหมาย - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/staffAssignmentList.css">
</head>
<body>

    <%-- ===== Navbar ===== --%>
    <div class="navbar">
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item active">รายการงาน</a>
                <a href="${pageContext.request.contextPath}/staff/items" class="nav-item">จัดการ Item</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName}
                    ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile" class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </div>

    <div class="page-wrapper">

        <div class="list-header">
            <div>
                <h1>รายการงานมอบหมาย</h1>
                <p>งานที่ได้รับมอบหมายทั้งหมดในระบบ</p>
            </div>
        </div>

        <div class="content-card">
            <div class="card-header-bar">
                <span>รายการงานทั้งหมด</span>
                <span class="header-count">จำนวนทั้งหมด ${assignments.size()} รายการ</span>
            </div>
            <table>
                <thead>
                    <tr>
                        <th width="15%">รหัสมอบหมาย</th>
                        <th width="15%">วันที่มอบหมาย</th>
                        <th width="20%">ประเภทพิธี</th>
                        <th width="20%">ชื่อลูกค้า</th>
                        <th width="15%">สถานะงาน</th>
                        <th width="15%" style="text-align: center;">จัดการ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${assignments}">
                        <tr>
                            <td><span class="assign-id">${a.assignId}</span></td>
                            <td><fmt:formatDate value="${a.assignDate}" pattern="dd/MM/yyyy"/></td>
                            <td><span class="ceremony-name">${a.bookingForm.ceremony.ceremonyName}</span></td>
                            <td>${a.bookingForm.member.memberFirstName}</td>
                            <td><span class="status-badge status-${a.jobStatus}">${a.jobStatus}</span></td>
                            <td style="text-align: center;">
                                <a href="${pageContext.request.contextPath}/staff/assignments/detail/${a.assignId}" class="btn-view">ดูรายละเอียด</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty assignments}">
                        <tr>
                            <td colspan="6" class="empty-state">ไม่พบรายการงานมอบหมาย</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </div>

    <script src="${pageContext.request.contextPath}/static/js/staffAssignmentList.js"></script>
</body>
</html>
