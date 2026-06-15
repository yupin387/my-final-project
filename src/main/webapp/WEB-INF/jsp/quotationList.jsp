<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการใบเสนอราคา - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/quotationList.css">
</head>
<body>

<%-- ========== NAVBAR ========== --%>
<div class="navbar">
    <a href="${pageContext.request.contextPath}/organizer/bookings" class="navbar-brand">
        <div class="navbar-lotus">🪷</div>
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"  class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item active">ใบเสนอราคา</a>
        </nav>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">A</div>
            <div class="user-detail">
                <span class="user-name">Admin Organizer</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <span class="arrow">▾</span>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</div>

<%-- ========== FLASH BANNER ========== --%>
<c:if test="${not empty success}">
    <div class="flash-banner flash-banner-success" id="flashBanner">
        ✓ ${success}
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="flash-banner flash-banner-error" id="flashBanner">
        ⚠ ${error}
    </div>
</c:if>

<%-- ========== PAGE CONTENT ========== --%>
<div class="page-wrapper">

    <div class="list-header">
        <div>
            <h1>ใบเสนอราคา</h1>
            <p>ติดตามสถานะเอกสารและการตอบกลับของลูกค้า</p>
        </div>
    </div>

    <%-- Tabs --%>
    <div class="tabs-wrapper">
        <a href="?status=All"       class="tab-btn ${(param.status == 'All' || empty param.status) ? 'active' : ''}">ทั้งหมด</a>
        <a href="?status=Pending"   class="tab-btn ${param.status == 'Pending'   ? 'active' : ''}">รอยืนยัน</a>
        <a href="?status=Revised"   class="tab-btn ${param.status == 'Revised'   ? 'active' : ''}">ต้องการแก้ไข</a>
        <a href="?status=Confirmed" class="tab-btn ${param.status == 'Confirmed' ? 'active' : ''}">ยืนยันแล้ว</a>
    </div>

    <div class="content-card">
        <div class="card-header-bar">
            <span>รายการใบเสนอราคา</span>
            <span class="header-count">จำนวนทั้งหมด ${quotations.size()} รายการ</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th width="12%">เลขที่ใบ</th>
                    <th width="35%">ลูกค้า / พิธี</th>
                    <th width="18%">วันจัดงาน</th>
                    <th width="18%">สถานะ</th>
                    <th width="17%">จัดการ</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="q" items="${quotations}">
                    <tr>
                        <td><span class="quotation-id">#${q.quotationId}</span></td>
                        <td>
                            <span class="customer-name">
                                ${q.bookingForm.member.memberFirstName} ${q.bookingForm.member.memberLastName}
                            </span>
                            <span class="ceremony-name">${q.bookingForm.ceremony.ceremonyName}</span>
                        </td>
                        <td class="date-cell">
                            <fmt:formatDate value="${q.bookingForm.eventDate}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td>
                            <span class="status-badge status-${q.quotationStatus.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${q.quotationStatus == 'Pending'}">รอยืนยัน</c:when>
                                    <c:when test="${q.quotationStatus == 'Revised'}">ต้องแก้ไข</c:when>
                                    <c:when test="${q.quotationStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
                                    <c:otherwise>${q.quotationStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/organizer/quotation/detail/${q.quotationId}"
                               class="btn-view">ดูรายละเอียด →</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty quotations}">
                    <tr>
                        <td colspan="5" class="empty-state">
                          
                            <p>ไม่พบรายการใบเสนอราคาในหมวด
                               <strong>"${empty param.status ? 'ทั้งหมด' : param.status}"</strong>
                            </p>
                            <a href="?status=All" class="empty-link">กลับไปดูรายการทั้งหมด</a>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</div>

<script src="${pageContext.request.contextPath}/static/js/quotationList.js"></script>

</body>
</html>
