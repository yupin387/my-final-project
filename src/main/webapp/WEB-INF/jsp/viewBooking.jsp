<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>สรุปการจอง - ระบบรับจัดงานบุญ</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/viewBooking.css?v=10">
</head>
<body>

<%-- ===== Navbar ===== --%>
<div class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="navbar-title">ระบบรับจัดงานบุญ</a>
    
    <div class="navbar-right">
        <%-- ลิงก์เมนู --%>
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/home" class="nav-item">หน้าหลัก</a>
            <a href="${pageContext.request.contextPath}/latestBooking" class="nav-item active">การจอง</a>
            <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-item">ใบเสนอราคา</a>
            <a href="${pageContext.request.contextPath}/reviews" class="nav-item">รีวิว</a>
        </nav>
        
        <%-- ปุ่มโปรไฟล์สมาชิก และ ดรอปดาวน์ --%>
        <div class="dropdown-wrap">
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">
                    ${fn:substring(sessionScope.user.memberFirstName, 0, 1)}
                </div>
                <div class="user-detail">
                    <span class="user-name">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
                    <span class="user-role">สมาชิก</span>
                </div>
            </div>
            
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-item">โปรไฟล์ของฉัน</a>
                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</div>

<div class="page-wrapper">
    <div class="detail-card">

        <%-- Card Header --%>
        <div class="card-header-bar">
            <div>
                <span class="booking-id-badge">รหัสการจอง: ${booking.bookingId}</span>
                <h2>ใบสรุปการจอง ${booking.ceremony.ceremonyName}</h2>
            </div>
            <span class="status-pill status-${fn:toLowerCase(booking.bookingStatus)}">
                <c:choose>
                    <c:when test="${booking.bookingStatus == 'Pending'}">รอดำเนินการ</c:when>
                    <c:when test="${booking.bookingStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
                    <c:when test="${booking.bookingStatus == 'Completed'}">เสร็จสิ้น</c:when>
                    <c:when test="${booking.bookingStatus == 'Rejected'}">ปฏิเสธแล้ว</c:when>
                    <c:when test="${booking.bookingStatus == 'Cancelled'}">ยกเลิกแล้ว</c:when>
                    <c:otherwise>${booking.bookingStatus}</c:otherwise>
                </c:choose>
            </span>
        </div>

        <%-- ส่วนเนื้อหาข้อมูลผู้จอง --%>
        <div class="section">
            <div class="section-title">ข้อมูลผู้จอง</div>
            <div class="info-row"><span class="info-label">ชื่อ-นามสกุล</span><span class="info-value">คุณ ${booking.member.memberFirstName} ${booking.member.memberLastName}</span></div>
            <div class="info-row"><span class="info-label">เบอร์โทรศัพท์</span><span class="info-value">${booking.member.phoneNumber}</span></div>
        </div>

        <hr class="divider">

        <div class="section">
            <div class="section-title">วันและสถานที่</div>
            <div class="info-row"><span class="info-label">วันที่จัดงาน</span><span class="info-value "><fmt:formatDate value="${booking.eventDate}" pattern="dd MMMM yyyy"/></span></div>
            <div class="info-row"><span class="info-label">เวลาเริ่มพิธี</span><span class="info-value">${booking.eventTime} น.</span></div>
            <div class="info-row"><span class="info-label">สถานที่</span><span class="info-value">${booking.eventAddress}</span></div>
        </div>

        <hr class="divider">

        <%-- รายละเอียดการจัดพิธี --%>
		<div class="section">
		    <div class="section-title">รายละเอียดการจัดพิธี</div>
		    <c:forEach items="${booking.details}" var="d">
		        <c:if test="${fn:contains(d.question.questionsText, 'แขก') 
		                   || fn:contains(d.question.questionsText, 'จำนวนผู้')
		                   || fn:contains(d.question.questionsText, 'ผูกข้อมือ')
		                   || fn:contains(d.question.questionsText, 'บ้านใหม่')}">
		            <div class="info-row">
		                <span class="info-label">${d.question.questionsText}</span>
		                <span class="info-value">
		                    <c:choose>
		                        <c:when test="${empty d.answer || d.answer == ''}">-</c:when>
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
		    <c:forEach items="${booking.details}" var="d">
		        <c:if test="${fn:contains(d.question.questionsText, 'นิมนต์') 
		                   || fn:contains(d.question.questionsText, 'พระ')}">
		            <div class="info-row">
		                <span class="info-label">${d.question.questionsText}</span>
		                <span class="info-value">
		                    <c:choose>
		                        <c:when test="${empty d.answer || d.answer == ''}">-</c:when>
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
		    <c:forEach items="${booking.details}" var="d">
		        <c:if test="${fn:contains(d.question.questionsText, 'ปิ่นโต')}">
		            <div class="info-row">
		                <span class="info-label">${d.question.questionsText}</span>
		                <span class="info-value">
		                    <c:choose>
		                        <c:when test="${empty d.answer || d.answer == '' || d.answer == 'ไม่ต้องการ'}">-</c:when>
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
		    <c:forEach items="${booking.details}" var="d">
		        <c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน')}">
		            <div class="info-row">
		                <span class="info-label">${d.question.questionsText}</span>
		                <span class="info-value">
		                    <c:choose>
		                        <c:when test="${empty d.answer || d.answer == '' || d.answer == 'ไม่ต้องการ'}">-</c:when>
		                        <c:otherwise>${d.answer}</c:otherwise>
		                    </c:choose>
		                </span>
		            </div>
		        </c:if>
		    </c:forEach>
		</div>


        <%-- Action Bar ปุ่มกดด้านล่าง --%>
        <div class="action-bar">
            <div>
                <c:choose>
                    <c:when test="${booking.bookingStatus == 'Completed'}">
                        <c:choose>
                            <c:when test="${empty hasReview || !hasReview}">
                                <a href="${pageContext.request.contextPath}/review/write/${booking.bookingId}" class="btn btn-review">เขียนรีวิวความประทับใจ</a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-reviewed" disabled>คุณได้รีวิวงานนี้แล้ว</button>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${booking.bookingStatus == 'Pending'}">
                        <%-- 🟢 ปุ่มเรียกเปิดป๊อปอัปคัดกรองอย่างปลอดภัย --%>
                        <button type="button" class="btn btn-cancel" onclick="showCancelModal('${booking.bookingId}')">
                            ยกเลิกรายการ
                        </button>
                    </c:when>
                    <c:otherwise>
                        <span style="color:#aaa; font-size:13px; font-style:italic;">สถานะปัจจุบัน: ${booking.bookingStatus}</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn-back" style="text-decoration: none;">← กลับหน้าหลัก</a>
        </div>
    </div>
</div>

<div class="modal fade" id="cancelModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title w-100 text-center fw-bold">ยืนยันการยกเลิก</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center" style="font-family: 'Sarabun', sans-serif;">
                ต้องการยกเลิกการจองนี้ใช่หรือไม่?
            </div>
            <div class="modal-footer" style="justify-content: center; gap: 15px;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="font-family: 'Sarabun'; padding: 8px 20px;">ยกเลิก</button>
                <%-- 🟢 ปุ่มตกลงที่จะผูกลิ้งค์ยิงไปหลังบ้าน ย้ายตำแหน่ง href ด่วนผ่านสคริปต์ --%>
                <a id="confirmCancelUrl" href="#" class="btn btn-danger" style="font-family: 'Sarabun'; padding: 8px 25px; text-decoration: none;">ตกลง</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<%-- 🟢 ฝังฟังก์ชัน JavaScript จัดการทางเดิน URL ของ Modal ไว้ตรงนี้เพื่อสยบบั๊กไฟล์แยกเอ๋อค้างครับ --%>
<script>
function showCancelModal(bookingId) {
    var cancelUrl = "${pageContext.request.contextPath}/booking/cancel/" + bookingId;
    document.getElementById('confirmCancelUrl').setAttribute('href', cancelUrl);
    
    var myModal = new bootstrap.Modal(document.getElementById('cancelModal'));
    myModal.show();
}
</script>

<script src="${pageContext.request.contextPath}/static/js/bookingForm.js"></script>
</body>
</html>