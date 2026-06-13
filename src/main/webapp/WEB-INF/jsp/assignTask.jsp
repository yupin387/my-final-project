<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${isChangeMode ? 'เปลี่ยนหัวหน้างาน' : 'มอบหมายหัวหน้างาน'} - ระบบรับจัดงานบุญ</title>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/assignStaff.css">
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
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item active">รายการจอง</a>
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
</nav>



<%-- ===== PAGE CONTENT ===== --%>
<div class="page-wrapper">
    <div class="assign-card">

        <%-- Header --%>
        <div class="assign-header">
            <div class="header-ornament">
                <div class="h-orn-line"></div>
                <div class="h-orn-dot"></div>
                <div class="h-orn-diamond"></div>
                <div class="h-orn-dot"></div>
                <div class="h-orn-line r"></div>
            </div>
            <h2>${isChangeMode ? 'เปลี่ยนหัวหน้างาน' : 'มอบหมายหัวหน้างาน'}</h2>
            <p>${isChangeMode ? 'เลือกหัวหน้างานคนใหม่เพื่อรับผิดชอบงานนี้' : 'กำหนดหัวหน้างานที่จะดูแลพิธีนี้'}</p>
        </div>

        <%-- Booking Info Grid --%>
        <div class="booking-info-grid">
            <div class="info-cell">
                <span class="info-label">ลูกค้า</span>
                <span class="info-value">คุณ ${b.member.memberFirstName} ${b.member.memberLastName}</span>
            </div>
            <div class="info-cell">
                <span class="info-label">ประเภทพิธี</span>
                <span class="info-value">${b.ceremony.ceremonyName}</span>
            </div>
            <div class="info-cell">
                <span class="info-label">วันจัดงาน</span>
                    <fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy"/>
                </span>
            </div>
            <div class="info-cell">
                <span class="info-label">เวลาเริ่มพิธี</span>
                <span class="info-value">${b.eventTime} น.</span>
            </div>
            <div class="info-cell">
                <span class="info-label">รหัสการจอง</span>
                <span class="info-value">${b.bookingId}</span>
            </div>
            <div class="info-cell">
                <span class="info-label">เบอร์โทร</span>
                <span class="info-value">${b.member.phoneNumber}</span>
            </div>
            <div class="info-cell full">
                <span class="info-label">สถานที่จัดงาน</span>
                <span class="info-value">${b.eventAddress}</span>
            </div>
        </div>

        <%-- Current Staff Bar (Change Mode) --%>
        <c:if test="${isChangeMode && not empty b.quotation.staff}">
            <div class="current-staff-bar">
                <div class="current-staff-avatar">
                    ${b.quotation.staff.staffFirstName.substring(0,1)}
                </div>
                <div>
                    <div class="current-staff-label">หัวหน้างานปัจจุบัน</div>
                    <div class="current-staff-name">
                        คุณ ${b.quotation.staff.staffFirstName} ${b.quotation.staff.staffLastName}
                        <span class="current-staff-phone">${b.quotation.staff.staffPhone}</span>
                    </div>
                </div>
                <div class="change-arrow">→</div>
                <div class="new-label">หัวหน้างานคนใหม่</div>
            </div>
        </c:if>

        <%-- Form --%>
        <div class="form-section">

            <div class="form-section-title">
                <span> กรอกข้อมูลการมอบหมาย</span>
                <div class="form-title-line"></div>
            </div>

            <form action="${pageContext.request.contextPath}/organizer/assignments/save" method="post">
                <input type="hidden" name="bookingId" value="${b.bookingId}">
                <input type="hidden" name="mode"      value="${isChangeMode ? 'change' : ''}">

                <div class="form-row-2">
                    <div class="form-group">
                        <label>วันที่มอบหมายงาน</label>
                        <input type="date" name="assignDate" id="assignDate" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label>${isChangeMode ? 'เลือกหัวหน้างานคนใหม่' : 'ค้นหารายชื่อหัวหน้างาน'}</label>
                        <select name="staffId" id="staff-select" style="width:100%;" required>
                            <option value="">-- พิมพ์ชื่อเพื่อค้นหา --</option>
                            <c:forEach var="s" items="${staffList}">
                                <c:if test="${b.quotation.staff.staffId != s.staffId}">
                                    <option value="${s.staffId}">
                                        ${s.staffFirstName} ${s.staffLastName} (${s.staffPhone})
                                    </option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                     ${isChangeMode ? 'ยืนยันการเปลี่ยนหัวหน้างาน' : 'ยืนยันการมอบหมายงาน'}
                </button>

                <a href="javascript:history.back()" class="back-link">← ยกเลิกและกลับหน้าก่อนหน้า</a>
            </form>
        </div>

    </div>
</div>




<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/assignStaff.js"></script>

</body>
</html>
