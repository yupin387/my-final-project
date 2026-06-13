<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายละเอียดการจอง - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookingDetail.css">
</head>
<body>

<div class="navbar">
    <span class="navbar-title">ระบบรับจัดงานบุญ</span>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings" class="nav-item active">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions" class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation" class="nav-item">ใบเสนอราคา</a>
        </nav>
        <div class="dropdown-wrap">
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">A</div>
                <div class="user-detail">
                    <span class="user-name">Admin Organizer</span>
                    <span class="user-role">ผู้จัดการ</span>
                </div>
                <span class="arrow">▾</span>
            </div>

            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <%-- back-link ชิดซ้ายสุดของหน้า ไม่จำกัด max-width --%>
    <div class="back-link-row">
        <a href="${pageContext.request.contextPath}/organizer/bookings" class="back-link">⬅ กลับรายการจอง</a>
    </div>

    <div class="detail-card">
        <div class="card-header-bar">
            <div>
                <span class="booking-id-badge">รหัสการจอง: ${b.bookingId}</span>
                <h2>ใบสรุปการจอง ${b.ceremony.ceremonyName}</h2>
            </div>
            <span class="status-pill status-${fn:toLowerCase(b.bookingStatus)}">
                <c:choose>
                    <c:when test="${b.bookingStatus == 'Pending'}">รอดำเนินการ</c:when>
                    <c:when test="${b.bookingStatus == 'Approved'}">รับงานแล้ว</c:when>
                    <c:when test="${b.bookingStatus == 'Quoted'}">เสนอราคาแล้ว</c:when>
                    <c:when test="${b.bookingStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
                    <c:when test="${b.bookingStatus == 'Rejected'}">ปฏิเสธแล้ว</c:when>
                    <c:when test="${b.bookingStatus == 'Completed'}">เสร็จสิ้น</c:when>
                    <c:otherwise>${b.bookingStatus}</c:otherwise>
                </c:choose>
            </span>
        </div>

        <%-- ข้อมูลผู้จอง --%>
        <div class="section">
            <div class="section-title">ข้อมูลผู้จอง</div>
            <div class="info-row"><span class="info-label">ชื่อ-นามสกุล</span><span class="info-value">คุณ ${b.member.memberFirstName} ${b.member.memberLastName}</span></div>
            <div class="info-row"><span class="info-label">เบอร์โทรศัพท์</span><span class="info-value">${b.member.phoneNumber}</span></div>
        </div>

        <hr class="divider">

        <%-- วันและสถานที่ --%>
        <div class="section">
            <div class="section-title">วันและสถานที่จัดงาน</div>
            <div class="info-row"><span class="info-label">วันที่จัดงาน</span><span class="info-value"><fmt:formatDate value="${b.eventDate}" pattern="dd MMMM yyyy"/></span></div>
            <div class="info-row"><span class="info-label">เวลาเริ่มพิธี</span><span class="info-value">${b.eventTime} น.</span></div>
            <div class="info-row"><span class="info-label">สถานที่</span><span class="info-value">${b.eventAddress}</span></div>
        </div>

        <hr class="divider">

        <%-- รายละเอียดการจัดพิธี --%>
        <div class="section">
            <div class="section-title">รายละเอียดการจัดพิธี</div>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวนแขก') || fn:contains(d.question.questionsText, 'อุปกรณ์')}">
                    <div class="info-row">
                        <span class="info-label">${d.question.questionsText}</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${empty d.answer || d.answer == 'ไม่ต้องการ'}">-</c:when>
                                <c:otherwise>${d.answer}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <hr class="divider">

        <%-- การนิมนต์พระสงฆ์ --%>
        <div class="section">
            <div class="section-title">การนิมนต์พระสงฆ์</div>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'นิมนต์') || fn:contains(d.question.questionsText, 'พระสงฆ์')}">
                    <div class="info-row">
                        <span class="info-label">${d.question.questionsText}</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${empty d.answer || d.answer == 'ไม่ต้องการ'}">-</c:when>
                                <c:otherwise>${d.answer}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <hr class="divider">

        <%-- ชุดภัตตาหารปิ่นโต --%>
        <div class="section">
            <div class="section-title">ชุดภัตตาหารปิ่นโต</div>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'ปิ่นโต') || fn:contains(d.question.questionsText, 'เลือกชุดปิ่นโต')}">
                    <div class="info-row">
                        <span class="info-label">${d.question.questionsText}</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${empty d.answer || d.answer == 'ไม่ต้องการ'}">-</c:when>
                                <c:otherwise>${d.answer}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <hr class="divider">

        <%-- รายละเอียดสังฆทาน --%>
        <div class="section">
            <div class="section-title">รายละเอียดสังฆทาน</div>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน') || fn:contains(d.question.questionsText, 'ชุดสังฆทาน')}">
                    <div class="info-row">
                        <span class="info-label">${d.question.questionsText}</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${empty d.answer || d.answer == 'ไม่ต้องการ'}">-</c:when>
                                <c:otherwise>${d.answer}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </c:if>
            </c:forEach>
        </div>
        
        <div class="action-bar">
            <c:choose>
                <c:when test="${b.bookingStatus == 'Pending'}">
		            <%-- เพิ่มปุ่มรับงานกลับมา --%>
		            <button type="button" class="btn btn-approve" 
		                onclick="openApproveModal('${b.bookingId}', '${pageContext.request.contextPath}/organizer/bookings/approve/${b.bookingId}')">
		                รับงานและเตรียมใบเสนอราคา
		            </button>
		            <button type="button" class="btn btn-reject"
		                onclick="openRejectModal('${b.bookingId}', '${pageContext.request.contextPath}/organizer/bookings/reject/${b.bookingId}')">
		                ปฏิเสธงาน
		            </button>
		        </c:when>
                <c:when test="${b.bookingStatus == 'Approved' || b.bookingStatus == 'Quoted'}">
                    <a href="${pageContext.request.contextPath}/organizer/quotation/create/${b.bookingId}" class="btn btn-approve">จัดการใบเสนอราคา</a>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>

<!-- Modal -->
<div id="approveModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
        <h3 class="modal-title">ยืนยันอนุมัติการจอง</h3>
        <p class="modal-subtitle">การดำเนินการนี้จะเปลี่ยนสถานะเป็น "อนุมัติแล้ว"</p>
        <div class="modal-id-container">
            <span id="displayBookingId" class="modal-id-text"></span>
        </div>
        <p class="modal-footer-note">หลังอนุมัติสามารถทำใบเสนอราคาได้ทันที</p>
        <div class="modal-btn-group">
            <button type="button" class="btn-cancel" onclick="closeApproveModal()">ยกเลิก</button>
            <a id="confirmApproveLink" href="#" class="btn-confirm-approve">ยืนยันอนุมัติ</a>
        </div>
    </div>
</div>

<div id="rejectModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
        <h3 class="modal-title">ยืนยันการปฏิเสธงาน</h3>
        <p class="modal-subtitle">การดำเนินการนี้จะเปลี่ยนสถานะเป็น "ปฏิเสธแล้ว"</p>
        <div class="modal-id-container" style="border-color:#ef9a9a; background:#fdecea;">
            <span id="displayRejectBookingId" class="modal-id-text" style="color:#c62828;"></span>
        </div>
        <p class="modal-footer-note">การปฏิเสธไม่สามารถย้อนกลับได้</p>
        <div class="modal-btn-group">
            <button type="button" class="btn-cancel" onclick="closeRejectModal()">ยกเลิก</button>
            <a id="confirmRejectLink" href="#" class="btn-confirm-reject">ยืนยันปฏิเสธ</a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bookingDetail.js"></script>
</body>
</html>
