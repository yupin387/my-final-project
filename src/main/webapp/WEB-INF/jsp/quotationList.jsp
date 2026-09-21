<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการใบเสนอราคา - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/quotationList.css">
</head>
<body>


<%-- ========== NAVBAR ========== --%>
<div class="navbar">
    <a href="${pageContext.request.contextPath}/manager/bookings" class="navbar-brand">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
        <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/manager/bookings"   class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/manager/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/manager/questions"  class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/manager/quotation"  class="nav-item active">จัดการใบเสนอราคา</a>
        </nav>
          <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">M</div>
            <div class="user-detail">
                <span class="user-name">Manager</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <span class="arrow">▾</span>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/manager/logout" class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</div>


<%-- ========== PAGE WRAPPER ========== --%>
<div class="page-wrapper">

    <%-- ========== LIST HEADER ========== --%>
    <div class="list-header">
        <div>
            <div class="section-ornament">
                <div class="ornament-line"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-line right"></div>
            </div>
            <h1>ใบเสนอราคา</h1>
            <p>ติดตามสถานะเอกสารและการตอบกลับของลูกค้า</p>
        </div>
    </div>

    <%-- ========== STATUS FILTER (dropdown) ========== --%>
    <c:set var="currentStatus" value="${empty param.status ? 'Pending' : param.status}" />
    <c:choose>
        <c:when test="${currentStatus == 'Pending'}">
            <c:set var="dotClass" value="dot-pending" />
            <c:set var="selectedText" value="รอยืนยัน" />
            <c:set var="selectedCount" value="${statusCounts.Pending}" />
        </c:when>
        <c:when test="${currentStatus == 'Revised'}">
            <c:set var="dotClass" value="dot-revised" />
            <c:set var="selectedText" value="ต้องการแก้ไข" />
            <c:set var="selectedCount" value="${statusCounts.Revised}" />
        </c:when>
        <c:when test="${currentStatus == 'Confirmed'}">
            <c:set var="dotClass" value="dot-confirmed" />
            <c:set var="selectedText" value="ยืนยันแล้ว" />
            <c:set var="selectedCount" value="${statusCounts.Confirmed}" />
        </c:when>
        <c:otherwise>
            <c:set var="dotClass" value="dot-all" />
            <c:set var="selectedText" value="ทั้งหมด" />
            <c:set var="selectedCount" value="${statusCounts.All}" />
        </c:otherwise>
    </c:choose>

    <div class="status-filter-wrapper" id="statusFilterWrapper">
        <button type="button" class="status-filter-btn" id="statusFilterBtn" onclick="toggleStatusFilter()">
            <span class="filter-caret-label">▾</span>
            <span class="filter-label-text">สถานะใบเสนอราคา :</span>
            <span class="filter-selected-pill">
                <span class="status-dot ${dotClass}"></span>
                <span class="filter-selected-text">${selectedText}</span>
                <span class="filter-count-badge">${selectedCount}</span>
            </span>
            <span class="filter-caret" id="filterCaret">▴</span>
        </button>

        <div class="status-filter-dropdown" id="statusFilterDropdown">
            <a href="?status=All" class="status-filter-item ${currentStatus == 'All' ? 'active' : ''}">
                <span class="status-dot dot-all"></span>
                <span class="status-filter-text">ทั้งหมด</span>
                <span class="status-filter-count">${statusCounts.All}</span>
            </a>
            <a href="?status=Pending" class="status-filter-item ${currentStatus == 'Pending' ? 'active' : ''}">
                <span class="status-dot dot-pending"></span>
                <span class="status-filter-text">รอยืนยัน</span>
                <span class="status-filter-count">${statusCounts.Pending}</span>
            </a>
            <a href="?status=Revised" class="status-filter-item ${currentStatus == 'Revised' ? 'active' : ''}">
                <span class="status-dot dot-revised"></span>
                <span class="status-filter-text">ต้องการแก้ไข</span>
                <span class="status-filter-count">${statusCounts.Revised}</span>
            </a>
            <a href="?status=Confirmed" class="status-filter-item ${currentStatus == 'Confirmed' ? 'active' : ''}">
                <span class="status-dot dot-confirmed"></span>
                <span class="status-filter-text">ยืนยันแล้ว</span>
                <span class="status-filter-count">${statusCounts.Confirmed}</span>
            </a>
        </div>
    </div>

    <%-- ========== TABLE CARD ========== --%>
    <div class="content-card">
        <div class="card-header-bar">
            <span>รายการใบเสนอราคา</span>
            <span class="header-count">จำนวนทั้งหมด ${quotations.size()} รายการ</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th width="10%">เลขที่ใบ</th>
                    <th width="22%">ลูกค้า</th>
                    <th width="20%">พิธี</th>
                    <th width="15%">วันจัดงาน</th>
                    <th width="16%">สถานะ</th>
                    <th width="17%">จัดการ</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="q" items="${quotations}">
                    <tr>
                        <td><span class="quotation-id">${q.quotationId}</span></td>
                        <td>
                            <span class="customer-name">
                                ${q.bookingForm.member.memberFirstName} ${q.bookingForm.member.memberLastName}
                            </span>
                        </td>
                        <td>
                            <span class="customer-name">${q.bookingForm.ceremony.ceremonyType}</span>
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
                            <a href="${pageContext.request.contextPath}/manager/quotation/detail/${q.quotationId}"
                               class="btn-view">ดูรายละเอียด →</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty quotations}">
                    <tr>
                        <td colspan="6" class="empty-state">
                           <p>ไม่พบรายการใบเสนอราคาในหมวด
   <strong>"${selectedText}"</strong>
</p>
                            <a href="?status=All" class="empty-link">กลับไปดูรายการทั้งหมด</a>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</div>

<%-- ===== FOOTER ===== --%>
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

<script src="${pageContext.request.contextPath}/static/js/quotationList.js"></script>
</body>
</html>