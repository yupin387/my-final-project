<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ใบรายละเอียดการจอง - ระบบรับจัดงานบุญ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/viewBooking.css?v=14">
</head>
<body>



<%-- ===== Navbar (ให้ตรงกับหน้า home: มีเมนู บริการ/แพ็กเกจ และ ปฏิทิน แบบ dropdown) ===== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา รับจัดงานบุญ">
        </div>
        <span class="nav-brand-text">บุญมีนำพา รับจัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item">หน้าหลัก</a>

        <%-- ===== เมนู บริการ/แพ็กเกจ (dropdown) ===== --%>
        <div class="nav-dropdown-wrap">
            <a href="javascript:void(0);" class="nav-link-item nav-dropdown-toggle">
                บริการ/แพ็กเกจ <span class="nav-caret">▾</span>
            </a>
            <div class="nav-dropdown-panel">
                <c:forEach var="t" items="${ceremonyTypes}">
                    <a href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}"
                        class="nav-dropdown-link">${t.mainName}</a>
                </c:forEach>
            </div>
        </div>

        <%-- ===== เมนู ปฏิทิน (dropdown แยกฤกษ์ดี / ล้านนา) ===== --%>
        <div class="nav-dropdown-wrap">
            <a href="${pageContext.request.contextPath}/calendar" class="nav-link-item nav-dropdown-toggle">
                ปฏิทิน <span class="nav-caret">▾</span>
            </a>
            <div class="nav-dropdown-panel">
                <a href="${pageContext.request.contextPath}/calendar#calendarSection"
                    class="nav-dropdown-link">ปฏิทิน (ฤกษ์ดี)</a>
                <a href="${pageContext.request.contextPath}/calendar#lannaCalendarSection"
                    class="nav-dropdown-link">ปฏิทิน (ล้านนา)</a>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/latestBooking" class="nav-link-item active">การจอง</a>
        <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-link-item">ใบเสนอราคา</a>
        <a href="${pageContext.request.contextPath}/reviews" class="nav-link-item">รีวิว</a>
    </div>
    <div class="dropdown-wrap">
        <div class="user-profile-pill" onclick="toggleDropdown()">
            <div class="avatar-circle-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
            <div class="user-info-text">
                <span class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
                <span class="user-role-nav">สมาชิก</span>
            </div>
        </div>
        <div class="dropdown-menu-custom" id="dropdownMenu">
            <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-link">โปรไฟล์ของฉัน</a>
            <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">ออกจากระบบ</a>
        </div>
    </div>
</nav>

<div class="page-wrapper">

    <div class="booking-notice">
        <span class="notice-icon">📞</span>
        <div class="notice-content">
            <strong>รอการติดต่อจากทีมงาน</strong>
			<p>ทีมงานจะติดต่อกลับเพื่อนัดหมายวันและเวลาสำหรับลงพื้นที่สำรวจสถานที่</p>
        </div>
    </div>
    

    <div class="detail-card">
        <%-- Card Header --%>
        <div class="card-header-bar">
            <div>
                <span class="booking-id-badge">รหัสการจอง: ${booking.bookingId}</span>
                <h2>สรุปรายละเอียดการจอง${not empty booking.ceremony.ceremonyType ? ' ' : ''}${booking.ceremony.ceremonyType}</h2>
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

        <%-- งานบุญที่จอง / แพ็กเกจที่เลือก --%>
        <div class="section">
            <div class="section-title">งานบุญที่จอง</div>
            <div class="info-row">
                <span class="info-label">ประเภทงานบุญ</span>
                <span class="info-value">${booking.ceremony.ceremonyType}</span>
            </div>
            <div class="info-row">
                <span class="info-label">รูปแบบการจอง</span>
                <span class="info-value">
                    ${booking.ceremony.ceremonyName}
                    <c:if test="${not empty booking.ceremony.ceremonyDetail}">
                        <div style="font-weight:400;font-size:13px;color:var(--text-muted);margin-top:2px;">${booking.ceremony.ceremonyDetail}</div>
                    </c:if>
                </span>
            </div>
            <c:if test="${booking.ceremony.basePrice > 0}">
                <div class="info-row">
                    <span class="info-label">ราคาเริ่มต้น</span>
                    <span class="info-value">฿<fmt:formatNumber value="${booking.ceremony.basePrice}" pattern="#,###"/></span>
                </div>
            </c:if>
        </div>

        <hr class="divider">

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
                                             style="width:130px;height:130px;object-fit:cover;border-radius:10px;border:2px solid var(--accent-gold);box-shadow:0 2px 8px rgba(0,0,0,0.12);"
                                             onerror="this.style.display='none'">
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <span style="color:var(--text-muted);">ไม่มีรูปภาพสถานที่</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
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

            <%-- 2. รายละเอียดการนิมนต์พระสงฆ์ (เลือกวัด) — แสดง "-" เมื่อ "นิมนต์เอง" เพราะไม่เกี่ยวข้อง (ผู้จองเป็นคนนิมนต์เอง ไม่ต้องเลือกให้ร้านช่วยเลือกวัด) --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รายละเอียดการนิมนต์พระสงฆ์')}">
                    <div class="info-row" style="margin-bottom:8px;"><span class="info-label">${d.question.questionsText}</span><span class="info-value" style="white-space:pre-line;"><c:choose><c:when test="${monkType == 'นิมนต์เอง'}">-</c:when><c:when test="${not empty fn:trim(d.answer) && fn:trim(d.answer) != ','}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- 3. จำนวนพระสงฆ์ — แสดงคำตอบเสมอ ไม่ว่าจะ "นิมนต์เอง" หรือ "ให้ทางร้านนิมนต์"
                 เพราะฟอร์มจองเก็บค่าจำนวนพระในทุกกรณี (ผู้จองเป็นคนกรอกเองเมื่อนิมนต์เอง) --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวนพระ')}">
                    <div class="info-row" style="margin-bottom:8px;"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer) && fn:trim(d.answer) != ','}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <hr class="divider">

        <%-- ชุดสังฆทาน (สลับลำดับมาไว้ก่อนปิ่นโต) --%>
        <div class="section">
            <div class="section-title">ชุดสังฆทาน</div>

            <%-- หาคำตอบคำถามแรก
                 หมายเหตุ: โหมดแพ็กเกจแนะนำไม่มีคำถาม "ต้องการสังฆทานหรือไม่" (สังฆทานรวมอยู่ในแพ็กเกจเสมอ)
                 จึงตั้งค่าเริ่มต้นเป็น "ต้องการ" ไว้ก่อน แล้วให้คำตอบจริง (ถ้ามี จากโหมดกรอกเอง) มาทับทีหลัง --%>
            <c:set var="sangWant" value="ต้องการ"/>
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
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${sangWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}<c:forEach items="${sanghatharnItems}" var="sItem"><c:if test="${sItem.itemName == fn:trim(d.answer)}"><span style="color:var(--accent-gold);font-size:13px;"> — ฿<fmt:formatNumber value="${sItem.pricePerUnit}" pattern="#,###"/> / ${sItem.unit}</span></c:if></c:forEach></c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามจำนวน: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'สังฆทาน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${sangWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <hr class="divider">

        <%-- ชุดภัตตาหารปิ่นโต (สลับลำดับมาไว้หลังสังฆทาน) --%>
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
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${pintoWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}<c:forEach items="${pintoItems}" var="pItem"><c:if test="${pItem.itemName == fn:trim(d.answer)}"><span style="color:var(--accent-gold);font-size:13px;"> — ฿<fmt:formatNumber value="${pItem.pricePerUnit}" pattern="#,###"/> / ${pItem.unit}</span></c:if></c:forEach></c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามจำนวน: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${booking.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${pintoWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <%-- หมายเหตุเพิ่มเติม (สิ่งที่ผู้จองกรอกเพิ่มเติมตอนจอง) --%>
        <c:forEach items="${booking.details}" var="d">
            <c:if test="${fn:contains(d.question.questionsText, 'ความต้องการเพิ่มเติม')}">
                <hr class="divider">
                <div class="section">
                    <div class="section-title">หมายเหตุเพิ่มเติม</div>
                    <div class="info-row">
                        <span class="info-label">${d.question.questionsText}</span>
                        <span class="info-value" style="white-space:pre-line;">
                            <c:choose>
                                <c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </c:if>
        </c:forEach>

        <hr class="divider">



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

<%-- ========== FOOTER (ธีมเดียวกับหน้า home / จองงาน) ========== --%>
<footer class="site-footer">
    <div class="footer-top">
        <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;">
            <rect width="1200" height="8" fill="url(#footerGradViewBooking)" />
            <defs>
                <linearGradient id="footerGradViewBooking" x1="0%" y1="0%" x2="100%" y2="0%">
                    <stop offset="0%" stop-color="rgba(255,255,255,0.15)" />
                    <stop offset="50%" stop-color="rgba(255,255,255,0.9)" />
                    <stop offset="100%" stop-color="rgba(255,255,255,0.15)" />
                </linearGradient>
            </defs>
        </svg>
    </div>
    <div class="container footer-content">
        <div class="footer-col footer-brand-col">
            <div class="footer-brand">
                <div class="lotus-icon">
                    <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา รับจัดงานบุญ">
                </div>
                <span class="footer-brand-text">บุญมีนำพา รับจัดงานบุญ</span>
            </div>
            <p class="footer-tagline">รับจัดงานบุญ ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
        </div>
			<div class="footer-col footer-contact-col">
				<h4 class="footer-heading">ติดต่อเรา</h4>
				<%-- TODO: ใส่เบอร์โทร / LINE OA / อีเมลจริงของร้านแทนที่ตรงนี้ --%>
				<p>📞 โทร. 08X-XXX-XXXX</p>
				<p>💬 LINE OA: @boonmee</p>
				<p>✉️ boonmee.booking@gmail.com</p>
				<p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
			</div>
		</div>
	</footer>

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

<style>
/* ===== Navbar dropdown (บริการ/แพ็กเกจ, ปฏิทิน) — ให้ตรงกับหน้า home ===== */
.nav-dropdown-wrap {
    position: relative;
    display: inline-block;
}
.nav-dropdown-toggle {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    cursor: pointer;
}
.nav-caret {
    font-size: 0.7rem;
    transition: transform 0.2s ease;
}
.nav-dropdown-wrap:hover .nav-caret {
    transform: rotate(180deg);
}
.nav-dropdown-panel {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    min-width: 220px;
    background: var(--white, #fff);
    border: 1px solid var(--gold-pale, #e8cc70);
    border-radius: 10px;
    box-shadow: 0 8px 24px rgba(61, 37, 0, 0.15);
    padding: 8px 0;
    z-index: 100;
}
.nav-dropdown-wrap:hover .nav-dropdown-panel,
.nav-dropdown-wrap:focus-within .nav-dropdown-panel {
    display: block;
}
.nav-dropdown-link {
    display: block;
    padding: 10px 18px;
    font-size: 0.92rem;
    color: var(--brown-dark, #3d2500);
    text-decoration: none;
    white-space: nowrap;
}
.nav-dropdown-link:hover {
    background: var(--gold-pale, #fff8e1);
}
.nav-dropdown-divider {
    border: 0;
    border-top: 1px solid var(--gold-pale, #e8cc70);
    margin: 6px 0;
}
</style>

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
