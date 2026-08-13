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
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/viewBooking.css?v=21">
</head>
<body>

<%-- Navbar --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home">
        <div class="lotus-icon">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา รับจัดงานบุญ" onerror="this.style.display='none'">
        </div>
        <span class="nav-brand-text">บุญมีนำพา รับจัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item">หน้าหลัก</a>

        <div class="dropdown-wrap nav-dropdown-wrap">
            <a href="javascript:void(0);" class="nav-link-item">บริการ/แพ็กเกจ ▾</a>
            <div class="dropdown-menu-custom nav-dropdown-panel">
                <c:if test="${not empty ceremonyTypes}">
                    <c:forEach var="t" items="${ceremonyTypes}">
                        <a href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}" class="dropdown-link">${t.mainName}</a>
                    </c:forEach>
                </c:if>
            </div>
        </div>

        <div class="dropdown-wrap nav-dropdown-wrap">
            <a href="${pageContext.request.contextPath}/calendar" class="nav-link-item">ปฏิทิน ▾</a>
            <div class="dropdown-menu-custom nav-dropdown-panel">
                <a href="${pageContext.request.contextPath}/calendar#calendarSection" class="dropdown-link">ปฏิทิน (ฤกษ์ดี)</a>
                <a href="${pageContext.request.contextPath}/calendar#lannaCalendarSection" class="dropdown-link">ปฏิทิน (ล้านนา)</a>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/latestBooking" class="nav-link-item active">การจอง</a>
        <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-link-item">ใบเสนอราคา</a>
        <a href="${pageContext.request.contextPath}/reviews" class="nav-link-item">รีวิว</a>
    </div>

    <div class="dropdown-wrap">
        <div class="user-profile-pill" onclick="toggleDropdown(event)">
            <div class="avatar-circle-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.user && not empty sessionScope.user.memberFirstName}">
                        ${fn:substring(sessionScope.user.memberFirstName, 0, 1)}
                    </c:when>
                    <c:otherwise>U</c:otherwise>
                </c:choose>
            </div>
            <div class="user-info-text">
                <span class="user-name-nav">
                    <c:out value="${sessionScope.user.memberFirstName}" default="สมาชิก"/> 
                    <c:out value="${sessionScope.user.memberLastName}" default=""/>
                </span>
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
        <div class="notice-icon"><i class="bi bi-telephone-inbound-fill"></i></div>
        <div class="notice-content">
            <strong>รอการติดต่อจากทีมงาน</strong>
            <p>ทีมงานจะติดต่อกลับเพื่อนัดหมายวันและเวลาสำหรับลงพื้นที่สำรวจสถานที่จัดงาน</p>
        </div>
    </div>

    <div class="detail-card">
        <%-- Header --%>
        <div class="card-header-bar">
            <div>
                <span class="booking-id-badge">รหัสการจอง: #${booking.bookingId}</span>
                <h2>สรุปรายละเอียดการจองพิธีทำบุญ</h2>
            </div>
            <span class="status-pill status-${fn:toLowerCase(booking.bookingStatus)}">
                <c:choose>
                    <c:when test="${booking.bookingStatus == 'Pending'}">รอดำเนินการ</c:when>
                    <c:when test="${booking.bookingStatus == 'Approved'}">อนุมัติแล้ว</c:when>
                    <c:when test="${booking.bookingStatus == 'Quoted'}">ออกใบเสนอราคาแล้ว</c:when>
                    <c:when test="${booking.bookingStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
                    <c:when test="${booking.bookingStatus == 'Completed'}">เสร็จสิ้น</c:when>
                    <c:when test="${booking.bookingStatus == 'Rejected'}">ปฏิเสธแล้ว</c:when>
                    <c:when test="${booking.bookingStatus == 'Cancelled'}">ยกเลิกแล้ว</c:when>
                    <c:otherwise>${booking.bookingStatus}</c:otherwise>
                </c:choose>
            </span>
        </div>

        <%-- 1. ข้อมูลผู้จอง --%>
        <div class="section">
            <div class="section-title"><i class="bi bi-person-fill"></i> ข้อมูลผู้จอง</div>
            <div class="info-row">
                <span class="info-label">ชื่อ-นามสกุล</span>
                <span class="info-value">คุณ ${booking.member.memberFirstName} ${booking.member.memberLastName}</span>
            </div>
            <div class="info-row">
                <span class="info-label">เบอร์โทรศัพท์</span>
                <span class="info-value">${booking.member.phoneNumber}</span>
            </div>
            <c:if test="${not empty booking.member.memberEmail}">
                <div class="info-row">
                    <span class="info-label">อีเมล</span>
                    <span class="info-value">${booking.member.memberEmail}</span>
                </div>
            </c:if>
        </div>

        <hr class="divider">

        <%-- 2. วันและสถานที่จัดงาน + แผนที่ --%>
        <div class="section">
            <div class="section-title"><i class="bi bi-geo-alt-fill"></i> รายละเอียดวันที่และสถานที่จัดงาน</div>
            <div class="info-row">
                <span class="info-label">วันที่จัดงาน</span>
                <span class="info-value"><fmt:formatDate value="${booking.eventDate}" pattern="dd MMMM yyyy"/></span>
            </div>
            <div class="info-row">
                <span class="info-label">เวลาเริ่มพิธี</span>
                <span class="info-value">${booking.eventTime} น.</span>
            </div>
            <div class="info-row">
                <span class="info-label">สถานที่จัดงาน</span>
                <span class="info-value">${booking.eventAddress}</span>
            </div>

            <c:if test="${not empty booking.eventAddress}">
                <div class="info-row" style="margin-top:12px;">
                    <span class="info-label">แผนที่ปักหมุด</span>
                    <div class="info-value" style="width:100%;">
                        <div class="map-container">
                            <iframe class="map-iframe" loading="lazy" allowfullscreen
                                src="https://maps.google.com/maps?q=${fn:escapeXml(booking.eventAddress)}&t=&z=15&ie=UTF8&iwloc=&output=embed">
                            </iframe>
                        </div>
                        <a href="https://www.google.com/maps/search/?api=1&query=${fn:escapeXml(booking.eventAddress)}" 
                           target="_blank" class="btn-map-link">
                            <i class="bi bi-box-arrow-up-right"></i> เปิดนำทางใน Google Maps
                        </a>
                    </div>
                </div>
            </c:if>

            <div class="info-row" style="margin-top:12px;">
                <span class="info-label">รูปภาพสถานที่</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty booking.addressImage}">
                            <div class="image-gallery">
                                <c:forEach items="${fn:split(booking.addressImage, ',')}" var="imgFile">
                                    <c:set var="trimmed" value="${fn:trim(imgFile)}"/>
                                    <c:if test="${not empty trimmed}">
                                        <img src="${pageContext.request.contextPath}/uploads/address/${trimmed}" class="location-img" alt="สถานที่จัดงาน" onerror="this.style.display='none'">
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <span style="color:var(--text-muted); font-weight:normal;">- ไม่มีรูปภาพสถานที่ -</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <hr class="divider">

        <%-- 3. แพ็กเกจที่จอง (ดึงจากตาราง ceremony และ item ใน DB จริง) --%>
        <div class="section">
            <div class="section-title"><i class="bi bi-box-seam-fill"></i> แพ็กเกจงานบุญที่เลือก</div>
            
            <div class="info-row">
                <span class="info-label">ประเภทงานบุญ</span>
                <span class="info-value">${booking.ceremony.ceremonyType}</span>
            </div>
            
            <div class="info-row">
                <span class="info-label">รูปแบบ/แพ็กเกจ</span>
                <span class="info-value">${booking.ceremony.ceremonyName}</span>
            </div>
            
            <c:if test="${not empty booking.ceremony.basePrice}">
                <div class="info-row">
                    <span class="info-label">ราคาเริ่มต้นแพ็กเกจ</span>
                    <span class="info-value price-text">
                        ฿<fmt:formatNumber value="${booking.ceremony.basePrice}" pattern="#,###"/>
                    </span>
                </div>
            </c:if>

            <%-- รายละเอียดคำอธิบายแพ็กเกจ --%>
            <c:if test="${not empty booking.ceremony.ceremonyDetail}">
                <div class="package-inclusions-box" style="margin-top: 15px;">
                    <div class="package-inclusions-title">
                        <i class="bi bi-info-circle-fill"></i> รายละเอียดแพ็กเกจ:
                    </div>
                    <div style="padding: 10px 5px; color: var(--text-dark); line-height: 1.7; font-size: 0.95rem;">
                        ${booking.ceremony.ceremonyDetail}
                    </div>
                </div>
            </c:if>

            <%-- รายการอุปกรณ์และบริการที่รวมในแพ็กเกจ (Dynamic จาก DB) --%>
            <div class="package-inclusions-box" style="margin-top: 15px;">
                <div class="package-inclusions-title" style="margin-bottom: 12px; font-weight: 600;">
                    <i class="bi bi-check-circle-fill" style="color: #28a745;"></i> สิ่งที่รวมอยู่ในแพ็กเกจนี้ (อุปกรณ์และบริการ):
                </div>
                
                <c:choose>
                    <c:when test="${not empty packageItems}">
                        <div class="package-items-grid" style="display: flex; flex-wrap: wrap; gap: 8px;">
                            <c:forEach var="item" items="${packageItems}">
                                <%-- กรองเอาเฉพาะอุปกรณ์/บริการหลัก (ไม่เอา itemTypeId 5: แพ็กเกจ และ 6: ตัวเลือกเสริม) --%>
                                <c:if test="${item.itemType.itemTypeId != 5 && item.itemType.itemTypeId != 6}">
                                    <div class="package-item-chip" style="background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 20px; padding: 5px 12px; font-size: 0.9rem;">
                                        <i class="bi bi-check2" style="color: #28a745;"></i> ${item.itemName}
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="color: var(--text-muted); font-style: italic; padding: 5px 0;">
                            - ไม่มีรายการอุปกรณ์ในระบบ -
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <hr class="divider">

        <%-- 4. รายละเอียดคำตอบเพิ่มเติม (แยกหัวข้อย่อยสีทองตามหมวดหมู่) --%>
		<c:if test="${not empty booking.details}">
		    <div class="section">
		        <c:forEach items="${booking.details}" var="d">
		
		            <%-- หัวข้อที่ 1: การนิมนต์พระสงฆ์ --%>
		            <c:if test="${d.question.questionsText eq 'รูปแบบการนิมนต์พระสงฆ์'}">
		                <div class="section-title mt-3"><i class="bi bi-person-badge"></i> การนิมนต์พระสงฆ์</div>
		            </c:if>
		
		            <%-- หัวข้อที่ 2: ชุดภัตตาหารปิ่นโต --%>
		            <c:if test="${d.question.questionsText eq 'ต้องการชุดภัตตาหารปิ่นโตหรือไม่'}">
		                <div class="section-title mt-4"><i class="bi bi-box-seam"></i> ชุดภัตตาหารปิ่นโต</div>
		            </c:if>
		
		            <%-- หัวข้อที่ 3: ชุดสังฆทาน --%>
		            <c:if test="${d.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ'}">
		                <div class="section-title mt-4"><i class="bi bi-gift"></i> ชุดสังฆทาน</div>
		            </c:if>
		
		            <%-- หัวข้อที่ 4: รายการเพิ่มเติม --%>
		            <c:if test="${d.question.questionsText eq 'มีความต้องการเพิ่มเติมหรือไม่'}">
		                <div class="section-title mt-4"><i class="bi bi-plus-circle"></i> รายการเพิ่มเติม</div>
		            </c:if>
		
		            <%-- แถวแสดงคำถาม - คำตอบ ตาม CSS เดิมของคุณ --%>
		            <div class="info-row">
		                <span class="info-label"><c:out value="${d.question.questionsText}" default="รายการ"/></span>
		                <span class="info-value"><c:out value="${d.answer}" default="-"/></span>
		            </div>
		
		        </c:forEach>
		    </div>
		    <hr class="divider">
		</c:if>

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
                            ยกเลิกรายการจอง
                        </button>
                    </c:when>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn-back">← กลับหน้าหลัก</a>
        </div>
    </div>
</div>

<%-- Modal ยกเลิก --%>
<div class="modal fade" id="cancelModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:16px; border:2px solid var(--accent-gold); overflow:hidden;">
            <div class="modal-header" style="background:var(--cream-warm); border-bottom:1px solid var(--accent-gold-pale);">
                <h5 class="modal-title w-100 text-center fw-bold" style="color:var(--accent-brown); font-family:'Charmonman', sans-serif;">ยืนยันการยกเลิกการจอง</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center" style="padding:24px 15px; color:var(--text-mid);">
                คุณต้องการยกเลิกรายการจองนี้ใช่หรือไม่? <br><small class="text-muted">(หากยกเลิกแล้วจะไม่สามารถย้อนกลับได้)</small>
            </div>
            <div class="modal-footer" style="justify-content:center; gap:15px; border-top:1px solid var(--cream-border-soft); background:#fafafa;">
                <button type="button" class="btn" style="background:#e0e0e0; color:#333; font-weight:600;" data-bs-dismiss="modal">ปิดหน้าต่าง</button>
                <a id="confirmCancelUrl" href="#" class="btn btn-cancel" style="padding:10px 20px;">ยืนยันยกเลิก</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/static/js/viewBooking.js?v=21"></script>
</body>
</html>