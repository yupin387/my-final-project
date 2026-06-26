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
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/viewBooking.css?v=10">
</head>
<body>

<%-- ===== Navbar ===== --%>
<nav class="navbar">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">🪷</div>
        <span class="nav-brand-text">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/home" class="nav-item">หน้าหลัก</a>
            <a href="${pageContext.request.contextPath}/latestBooking" class="nav-item active">การจอง</a>
            <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-item">ใบเสนอราคา</a>
            <a href="${pageContext.request.contextPath}/reviews" class="nav-item">รีวิว</a>
        </nav>
        <div class="dropdown-wrap">
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
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
</nav>

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

        <%-- ข้อมูลผู้จอง --%>
        <div class="section">
            <div class="section-title">ข้อมูลผู้จอง</div>
            <div class="info-row">
                <span class="info-label">ชื่อ-นามสกุล</span>
                <span class="info-value">คุณ ${booking.member.memberFirstName} ${booking.member.memberLastName}</span>
            </div>
            <div class="info-row">
                <span class="info-label">เบอร์โทรศัพท์</span>
                <span class="info-value">${booking.member.phoneNumber}</span>
            </div>
        </div>

        <hr class="divider">

        <%-- วันและสถานที่ --%>
        <div class="section">
            <div class="section-title">วันและสถานที่</div>
            <div class="info-row">
                <span class="info-label">วันที่จัดงาน</span>
                <span class="info-value"><fmt:formatDate value="${booking.eventDate}" pattern="dd MMMM yyyy"/></span>
            </div>
            <div class="info-row">
                <span class="info-label">เวลาเริ่มพิธี</span>
                <span class="info-value">${booking.eventTime} น.</span>
            </div>
            <div class="info-row">
                <span class="info-label">สถานที่</span>
                <span class="info-value">${booking.eventAddress}</span>
            </div>

            <%-- รูปภาพสถานที่ --%>
            <div class="info-row" style="margin-top:12px;">
                <span class="info-label">รูปภาพสถานที่</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty booking.addressImage}">
                            <div style="display:flex;flex-wrap:wrap;gap:10px;margin-top:4px;">
                                <c:forEach items="${fn:split(booking.addressImage, ',')}" var="imgFile">
                                    <c:set var="trimmed" value="${fn:trim(imgFile)}"/>
                                    <c:if test="${not empty trimmed}">
                                        <img src="${pageContext.request.contextPath}/uploads/address/${trimmed}"
                                             style="width:130px;height:130px;object-fit:cover;border-radius:10px;border:2px solid #D4A017;box-shadow:0 2px 8px rgba(0,0,0,0.12);"
                                             onerror="this.style.display='none'">
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <span style="color:#A08840;">ไม่มีรูปภาพสถานที่</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <hr class="divider">

        <%-- รายละเอียดการจัดพิธี (รองรับทั้ง "แขก" ขึ้นบ้านใหม่ และ "จำนวนผู้"/"ผูกข้อมือ" สืบชะตา) --%>
        <div class="section">
            <div class="section-title">รายละเอียดการจัดพิธี</div>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'แขก') || fn:contains(d.question.questionsText, 'จำนวนผู้') || fn:contains(d.question.questionsText, 'ผูกข้อมือ')}">
                    <div class="info-row">
                        <span class="info-label">${d.question.questionsText}</span>
                        <span class="info-value"><c:choose><c:when test="${empty fn:trim(d.answer)}">-</c:when><c:otherwise>${d.answer}</c:otherwise></c:choose></span>
                    </div>
                </c:if>
            </c:forEach>
        </div>

        <hr class="divider">

        <%-- การนิมนต์พระสงฆ์ --%>
        <div class="section">
            <div class="section-title">การนิมนต์พระสงฆ์</div>

            <%-- หาคำตอบรูปแบบการนิมนต์ก่อน --%>
            <c:set var="monkType" value=""/>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รูปแบบการนิมนต์')}">
                    <c:set var="monkType" value="${fn:trim(d.answer)}"/>
                </c:if>
            </c:forEach>

            <%-- 1. รูปแบบการนิมนต์ (แสดงเสมอ) --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รูปแบบการนิมนต์')}">
                    <div class="info-row" style="margin-bottom:8px;"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- 2. รายละเอียดการนิมนต์พระสงฆ์ (- ถ้านิมนต์เอง) --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รายละเอียดการนิมนต์พระสงฆ์')}">
                    <div class="info-row" style="margin-bottom:8px;"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${monkType == 'นิมนต์เอง'}">-</c:when><c:when test="${not empty fn:trim(d.answer) && fn:trim(d.answer) != ','}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- 3. จำนวนพระสงฆ์ (- ถ้านิมนต์เอง) --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวนพระ')}">
                    <div class="info-row" style="margin-bottom:8px;"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${monkType == 'นิมนต์เอง'}">-</c:when><c:when test="${not empty fn:trim(d.answer) && fn:trim(d.answer) != ','}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <hr class="divider">

        <%-- ชุดภัตตาหารปิ่นโต --%>
        <div class="section">
            <div class="section-title">ชุดภัตตาหารปิ่นโต</div>

            <%-- หาคำตอบคำถามแรก --%>
            <c:set var="pintoWant" value="ไม่ต้องการ"/>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${(fn:contains(d.question.questionsText, 'ภัตตาหาร') || fn:contains(d.question.questionsText, 'ปิ่นโต')) && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <c:set var="pintoWant" value="${fn:trim(d.answer)}"/>
                </c:if>
            </c:forEach>

            <%-- คำถามแรก: แสดงเสมอ --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${(fn:contains(d.question.questionsText, 'ภัตตาหาร') || fn:contains(d.question.questionsText, 'ปิ่นโต')) && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>ไม่ต้องการ</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามเลือกชุด: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'เลือก') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${pintoWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}<c:forEach items="${pintoItems}" var="pItem"><c:if test="${pItem.itemName == fn:trim(d.answer)}"><span style="color:#A08840;font-size:13px;"> — ฿<fmt:formatNumber value="${pItem.pricePerUnit}" pattern="#,###"/> / ${pItem.unit}</span></c:if></c:forEach></c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามจำนวน: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${pintoWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <hr class="divider">

        <%-- ชุดสังฆทาน --%>
        <div class="section">
            <div class="section-title">ชุดสังฆทาน</div>

            <%-- หาคำตอบคำถามแรก --%>
            <c:set var="sangWant" value="ไม่ต้องการ"/>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน') && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <c:set var="sangWant" value="${fn:trim(d.answer)}"/>
                </c:if>
            </c:forEach>

            <%-- คำถามแรก: แสดงเสมอ --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน') && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>ไม่ต้องการ</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามเลือกชุด: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'เลือก') && fn:contains(d.question.questionsText, 'สังฆทาน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${sangWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}<c:forEach items="${sanghatharnItems}" var="sItem"><c:if test="${sItem.itemName == fn:trim(d.answer)}"><span style="color:#A08840;font-size:13px;"> — ฿<fmt:formatNumber value="${sItem.pricePerUnit}" pattern="#,###"/> / ${sItem.unit}</span></c:if></c:forEach></c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามจำนวน: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'สังฆทาน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${sangWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <%-- Action Bar --%>
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
                        <button type="button" class="btn btn-cancel" onclick="showCancelModal('${booking.bookingId}')">
                            ยกเลิกรายการ
                        </button>
                    </c:when>
                    <c:otherwise>
                        <span style="color:#aaa;font-size:13px;font-style:italic;">สถานะปัจจุบัน: ${booking.bookingStatus}</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn-back" style="text-decoration:none;">← กลับหน้าหลัก</a>
        </div>
    </div>
</div>

<%-- Modal ยืนยันยกเลิก --%>
<div class="modal fade" id="cancelModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title w-100 text-center fw-bold">ยืนยันการยกเลิก</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center" style="font-family:'Sarabun',sans-serif;">
                ต้องการยกเลิกการจองนี้ใช่หรือไม่?
            </div>
            <div class="modal-footer" style="justify-content:center;gap:15px;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                        style="font-family:'Sarabun';padding:8px 20px;">ยกเลิก</button>
                <a id="confirmCancelUrl" href="#" class="btn btn-danger"
                   style="font-family:'Sarabun';padding:8px 25px;text-decoration:none;">ตกลง</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}
document.addEventListener('click', function(e) {
    const wrap = document.querySelector('.dropdown-wrap');
    const menu = document.getElementById('dropdownMenu');
    if (menu && wrap && !wrap.contains(e.target)) {
        menu.classList.remove('show');
    }
});
function showCancelModal(bookingId) {
    var cancelUrl = "${pageContext.request.contextPath}/booking/cancel/" + bookingId;
    document.getElementById('confirmCancelUrl').setAttribute('href', cancelUrl);
    new bootstrap.Modal(document.getElementById('cancelModal')).show();
}
</script>
</body>
</html>
