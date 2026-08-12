<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายละเอียดการจอง - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookingDetail.css">
</head>
<body>

<%-- ===== NAVBAR ===== --%>
<nav class="navbar">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/organizer/bookings" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon">
        <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item active">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"  class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item">จัดการใบเสนอราคา</a>
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
</nav>

<%-- ===== PAGE WRAPPER ===== --%>
<div class="page-wrapper">

    <div class="back-link-row">
        <a href="${pageContext.request.contextPath}/organizer/bookings" class="back-link">⬅ กลับรายการจอง</a>
    </div>

    <div class="detail-card">

        <%-- Card Header --%>
        <div class="card-header-bar">
            <div>
                <span class="booking-id-badge">รหัสการจอง: ${b.bookingId}</span>
                <h2>สรุปรายละเอียดการจอง${not empty b.ceremony.ceremonyType ? ' ' : ''}${b.ceremony.ceremonyType}</h2>
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

        <%-- งานบุญที่จอง / แพ็กเกจที่เลือก --%>
        <div class="section">
            <div class="section-title">งานบุญที่จอง</div>
            <div class="info-row">
                <span class="info-label">ประเภทงานบุญ</span>
                <span class="info-value">${b.ceremony.ceremonyType}</span>
            </div>
            <div class="info-row">
                <span class="info-label">รูปเเบบการจอง</span>
                <span class="info-value">
                    ${b.ceremony.ceremonyName}
                    <c:if test="${not empty b.ceremony.ceremonyDetail}">
                        <div style="font-weight:400;font-size:13px;color:var(--gold-mid);margin-top:2px;">${b.ceremony.ceremonyDetail}</div>
                    </c:if>
                </span>
            </div>
            <c:if test="${b.ceremony.basePrice > 0}">
                <div class="info-row">
                    <span class="info-label">ราคาเริ่มต้น</span>
                    <span class="info-value">฿<fmt:formatNumber value="${b.ceremony.basePrice}" pattern="#,###"/></span>
                </div>
            </c:if>
        </div>

        <hr class="divider">

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

            <%-- รูปภาพสถานที่ --%>
            <div class="info-row" style="margin-top:12px;">
                <span class="info-label">รูปภาพสถานที่</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty b.addressImage}">
                            <div style="display:flex;flex-wrap:wrap;gap:10px;margin-top:4px;">
                                <c:forEach items="${fn:split(b.addressImage, ',')}" var="imgFile">
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
                            <span style="color:var(--gold-mid);">ไม่มีรูปภาพสถานที่</span>
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
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รูปแบบการนิมนต์')}">
                    <c:set var="monkType" value="${fn:trim(d.answer)}"/>
                </c:if>
            </c:forEach>

            <%-- 1. รูปแบบการนิมนต์ (แสดงเสมอ) --%>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รูปแบบการนิมนต์')}">
                    <div class="info-row" style="margin-bottom:8px;"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- 2. รายละเอียดการนิมนต์พระสงฆ์ (เลือกวัด) — แสดง "-" เมื่อ "นิมนต์เอง" เพราะไม่เกี่ยวข้อง --%>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รายละเอียดการนิมนต์พระสงฆ์')}">
                    <div class="info-row" style="margin-bottom:8px;"><span class="info-label">${d.question.questionsText}</span><span class="info-value" style="white-space:pre-line;"><c:choose><c:when test="${monkType == 'นิมนต์เอง'}">-</c:when><c:when test="${not empty fn:trim(d.answer) && fn:trim(d.answer) != ','}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- 3. จำนวนพระสงฆ์ — แสดงคำตอบเสมอ ไม่ว่าจะ "นิมนต์เอง" หรือ "ให้ทางร้านนิมนต์"
                 เพราะฟอร์มจองเก็บค่าจำนวนพระในทุกกรณี (ผู้จองเป็นคนกรอกเองเมื่อนิมนต์เอง) --%>
            <c:forEach items="${b.details}" var="d">
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
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน') && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <c:set var="sangWant" value="${fn:trim(d.answer)}"/>
                </c:if>
            </c:forEach>

            <%-- คำถามแรก: แสดงเสมอ --%>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน') && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>ไม่ต้องการ</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามเลือกชุด: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'เลือก') && fn:contains(d.question.questionsText, 'สังฆทาน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${sangWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}<c:forEach items="${sanghatharnItems}" var="sItem"><c:if test="${sItem.itemName == fn:trim(d.answer)}"><span style="color:var(--accent-gold);font-size:13px;"> — ฿<fmt:formatNumber value="${sItem.pricePerUnit}" pattern="#,###"/> / ${sItem.unit}</span></c:if></c:forEach></c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามจำนวน: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${b.details}" var="d">
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
            <c:forEach items="${b.details}" var="d">
                <c:if test="${(fn:contains(d.question.questionsText, 'ภัตตาหาร') || fn:contains(d.question.questionsText, 'ปิ่นโต')) && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <c:set var="pintoWant" value="${fn:trim(d.answer)}"/>
                </c:if>
            </c:forEach>

            <%-- คำถามแรก: แสดงเสมอ --%>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${(fn:contains(d.question.questionsText, 'ภัตตาหาร') || fn:contains(d.question.questionsText, 'ปิ่นโต')) && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>ไม่ต้องการ</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามเลือกชุด: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'เลือก') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${pintoWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}<c:forEach items="${pintoItems}" var="pItem"><c:if test="${pItem.itemName == fn:trim(d.answer)}"><span style="color:var(--accent-gold);font-size:13px;"> — ฿<fmt:formatNumber value="${pItem.pricePerUnit}" pattern="#,###"/> / ${pItem.unit}</span></c:if></c:forEach></c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <%-- คำถามจำนวน: แสดงค่าถ้าต้องการ, - ถ้าไม่ต้องการ --%>
            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${pintoWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <%-- หมายเหตุเพิ่มเติม (สิ่งที่ผู้จองกรอกเพิ่มเติมตอนจอง) --%>
        <c:forEach items="${b.details}" var="d">
            <c:if test="${fn:contains(d.question.questionsText, 'ความต้องการเพิ่มเติม')}">
                <hr class="divider">
                <div class="section">
                    <div class="section-title">หมายเหตุเพิ่มเติม</div>
                    <%-- เพิ่ม style display: flex; align-items: flex-start; ตรงนี้เพื่อบังคับแถวนี้โดยเฉพาะ --%>
                    <div class="info-row" style="display: flex; flex-direction: row; align-items: flex-start;">
                        <span class="info-label" style="width: 200px; min-width: 200px; flex-shrink: 0;">${d.question.questionsText}</span>
                        <span class="info-value" style="flex: 1; white-space: pre-line; display: inline-block;">
                            <c:choose>
                                <c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </c:if>
        </c:forEach>

       
        <%-- Action Bar --%>
        <div class="action-bar">
            <div class="action-btn-group">
                <c:choose>
                    <c:when test="${b.bookingStatus == 'Pending'}">
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
</div>

<%-- ===== FOOTER ===== --%>
<footer class="site-footer">
    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับทีมงานและผู้ดูแลระบบ</p>
    </div>
   
</footer>

<%-- Modal อนุมัติ --%>
<div id="approveModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
        <h3 class="modal-title">ยืนยันอนุมัติการจอง</h3>
        <p class="modal-subtitle">การดำเนินการนี้จะเปลี่ยนสถานะเป็น "อนุมัติแล้ว"</p>
        <div class="modal-id-container">
            <span id="displayBookingId" class="modal-id-text"></span>
        </div>
        <p class="modal-footer-note">หลังอนุมัติสามารถทำใบเสนอราคาได้ทันที</p>
        <div class="modal-btn-group">
            <button type="button" class="btn-modal-cancel" onclick="closeApproveModal()">ยกเลิก</button>
            <a id="confirmApproveLink" href="#" class="btn-modal-approve">ยืนยันอนุมัติ</a>
        </div>
    </div>
</div>

<%-- Modal ปฏิเสธ --%>
<div id="rejectModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
        <h3 class="modal-title">ยืนยันการปฏิเสธงาน</h3>
        <p class="modal-subtitle">การดำเนินการนี้จะเปลี่ยนสถานะเป็น "ปฏิเสธแล้ว"</p>
        <div class="modal-id-container modal-id-reject">
            <span id="displayRejectBookingId" class="modal-id-text modal-id-text-reject"></span>
        </div>
        
        <!-- เปลี่ยนเป็น Form เพื่อส่งค่า rejectDetail ไปที่ Controller -->
        <form id="rejectForm" method="POST" action="">
            <div style="margin-top: 15px; text-align: left;">
                <label for="rejectDetail" style="font-weight: 600; font-size: 14px; color: #333;">เหตุผลที่ปฏิเสธงาน <span style="color:red;">*</span></label>
                <textarea id="rejectDetail" name="rejectDetail" rows="3" 
                          style="width: 100%; margin-top: 5px; padding: 8px; border-radius: 5px; border: 1px solid #ccc; font-family: 'Sarabun', sans-serif;" 
                          required placeholder="โปรดระบุเหตุผลที่ปฏิเสธการจองนี้..."></textarea>
            </div>

            <p class="modal-footer-note" style="margin-top: 10px;">การปฏิเสธไม่สามารถย้อนกลับได้</p>
            <div class="modal-btn-group">
                <button type="button" class="btn-modal-cancel" onclick="closeRejectModal()">ยกเลิก</button>
                <button type="submit" class="btn-modal-reject">ยืนยันปฏิเสธ</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bookingDetail.js"></script>
</body>
</html>
