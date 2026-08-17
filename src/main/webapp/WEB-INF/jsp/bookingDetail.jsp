<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ใบสรุปรายละเอียดการจอง #${b.bookingId} - บุญมีนำพา</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookingDetail.css">
    <style>
        /* ซ่อนดอกไม้/ใบบัวตกแต่งที่อาจบังข้อความ */
        .sheet-header .lotus-overlay, .document-title-box::after, .document-title-box::before, .sheet-header::after {
            display: none !important;
        }

        /* ===== สรุปค่าใช้จ่ายโดยประมาณ (คำนวณฝั่ง JS/JSTL เทียบเท่าฝั่ง Member) ===== */
        .cost-summary-wrapper {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }
        .cost-summary-box {
            border: 2px solid var(--accent-gold, #d4af37);
            border-radius: 14px;
            overflow: hidden;
            background: #fff;
            width: 100%;
            max-width: 380px;
        }
        .cost-summary-title {
            background: var(--cream-warm, #fdf3e7);
            padding: 10px 16px;
            font-weight: 700;
            font-size: 0.92rem;
            color: var(--accent-brown, #7a4a1e);
            border-bottom: 1px solid var(--accent-gold-pale, #e8d3a0);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .cost-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 9px 16px;
            border-bottom: 1px dashed var(--cream-border-soft, #eee2cf);
            font-size: 0.86rem;
        }
        .cost-row:last-child { border-bottom: none; }
        .cost-row .cost-label { color: var(--text-mid, #555); }
        .cost-row .cost-value { font-weight: 600; color: #222; }
        .cost-row.cost-discount .cost-value { color: #d9534f; }
        .cost-row.cost-total {
            background: #fff8f0;
            padding: 11px 16px;
        }
        .cost-row.cost-total .cost-label { font-weight: 700; color: var(--accent-brown, #7a4a1e); font-size: 0.86rem; }
        .cost-row.cost-total .cost-value { font-size: 1.05rem; font-weight: 800; color: #d9534f; }
        .cost-summary-note {
            padding: 6px 16px 10px;
            font-size: 0.74rem;
            color: #999;
            font-style: italic;
        }
        @media (max-width: 868px) {
            .cost-summary-wrapper { justify-content: stretch; }
            .cost-summary-box { max-width: 100%; }
        }
    </style>
</head>
<body>

<%-- ===== NAVBAR (คงเดิมตามระบบ Organizer) ===== --%>
<nav class="navbar">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/organizer/bookings" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon" onerror="this.style.display='none'">
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
        <a href="${pageContext.request.contextPath}/organizer/bookings" class="back-link"><i class="bi bi-arrow-left"></i> กลับรายการจอง</a>
    </div>

    <%-- กระดาษเอกสารใบสรุปการจอง --%>
    <div class="booking-sheet-document">
        
        <%-- Header เอกสาร --%>
        <div class="sheet-header" style="flex-direction: row; justify-content: space-between; align-items: flex-start; text-align: left;">
            <div class="company-brand" style="align-self: center;">
                <div class="brand-logo">
                    <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา" onerror="this.style.display='none'">
                </div>
                <div>
                    <h1 class="company-name" style="text-align: left;">บุญมีนำพา รับจัดงานบุญ</h1>
                    <p class="company-sub" style="text-align: left;">บริการรับจัดงานบุญ พิธีทำบุญบ้าน และงานพิธีสงฆ์ทุกรูปแบบ</p>
                </div>
            </div>
            
            <div class="document-title-box" style="padding-top: 0; text-align: right;">
                <h2 class="doc-title">ใบสรุปรายละเอียดการจอง</h2>
                <div class="doc-no">รหัสรายการจอง: <strong>#${b.bookingId}</strong></div>
                <div class="mt-2">
                    <span class="status-pill status-${fn:toLowerCase(b.bookingStatus)}">
                        <c:choose>
                            <c:when test="${b.bookingStatus == 'Pending'}">รอดำเนินการ</c:when>
                            <c:when test="${b.bookingStatus == 'Approved'}">อนุมัติแล้ว</c:when>
                            <c:when test="${b.bookingStatus == 'Quoted'}">ออกใบเสนอราคาแล้ว</c:when>
                            <c:when test="${b.bookingStatus == 'Confirmed'}">ยืนยันแล้ว</c:when>
                            <c:when test="${b.bookingStatus == 'Completed'}">เสร็จสิ้น</c:when>
                            <c:when test="${b.bookingStatus == 'Rejected'}">ปฏิเสธแล้ว</c:when>
                            <c:when test="${b.bookingStatus == 'Cancelled'}">ยกเลิกแล้ว</c:when>
                            <c:otherwise>${b.bookingStatus}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>

        <hr class="sheet-divider-bold">

        <%-- 1. ข้อมูลผู้ใช้บริการ & กำหนดการ --%>
        <div class="section">
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="sheet-box">
                        <div class="section-title"><i class="bi bi-person-fill"></i> ข้อมูลผู้ใช้บริการ</div>
                        <div class="info-row">
                            <span class="info-label">ชื่อ-นามสกุล</span>
                            <span class="info-value">คุณ ${b.member.memberFirstName} ${b.member.memberLastName}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">เบอร์โทรศัพท์</span>
                            <span class="info-value">${b.member.phoneNumber}</span>
                        </div>
                        <c:if test="${not empty b.member.memberEmail}">
                            <div class="info-row">
                                <span class="info-label">อีเมล</span>
                                <span class="info-value">${b.member.memberEmail}</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="sheet-box">
                        <div class="section-title"><i class="bi bi-calendar-event-fill"></i> กำหนดการและสถานที่</div>
                        <div class="info-row">
                            <span class="info-label">วันที่จัดงาน</span>
                            <span class="info-value"><fmt:formatDate value="${b.eventDate}" pattern="dd MMMM yyyy"/></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">เวลาเริ่มพิธี</span>
                            <span class="info-value">${b.eventTime} น.</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">สถานที่จัดงาน</span>
                            <span class="info-value">${b.eventAddress}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 2. แผนที่และรูปภาพสถานที่ --%>
        <c:if test="${not empty b.eventAddress}">
            <div class="section pt-0">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="section-title"><i class="bi bi-geo-alt-fill"></i> แผนที่ปักหมุดสถานที่</div>
                        <c:set var="mapQuery" value="${not empty b.eventLat && not empty b.eventLng ? b.eventLat += ',' += b.eventLng : fn:escapeXml(b.eventAddress)}" />
                        <div class="map-container">
                            <iframe class="map-iframe" loading="lazy" allowfullscreen
                                src="https://maps.google.com/maps?q=${mapQuery}&t=&z=16&ie=UTF8&iwloc=&output=embed">
                            </iframe>
                        </div>
                        <a href="https://www.google.com/maps/search/?api=1&query=${mapQuery}" target="_blank" class="btn-map-link">
                            <i class="bi bi-box-arrow-up-right"></i> เปิดนำทางใน Google Maps
                        </a>
                    </div>

                    <div class="col-md-6">
                        <div class="section-title"><i class="bi bi-images"></i> รูปภาพสถานที่ประกอบ</div>
                        <c:choose>
                            <c:when test="${not empty b.addressImage}">
                                <div class="image-gallery">
                                    <c:forEach items="${fn:split(b.addressImage, ',')}" var="imgFile">
                                        <c:set var="trimmed" value="${fn:trim(imgFile)}"/>
                                        <c:if test="${not empty trimmed}">
                                            <img src="${pageContext.request.contextPath}/uploads/address/${trimmed}" class="location-img" alt="สถานที่จัดงาน" onerror="this.style.display='none'">
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="no-img-box">
                                    <i class="bi bi-image"></i> ไม่มีรูปภาพสถานที่
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:if>

        <hr class="divider">

        <%-- ตัวแปรควบคุมการแสดงผล --%>
        <c:set var="basePriceVal" value="${b.ceremony.basePrice}" />
        <c:set var="isCustomRequest" value="${empty basePriceVal || basePriceVal == 0 || fn:indexOf(b.ceremony.ceremonyName, 'กรอกความต้องการ') ne -1}" />

        <c:set var="sanghaChoice" value="" />
        <c:forEach items="${b.details}" var="dd">
            <c:if test="${dd.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ'}">
                <c:set var="sanghaChoice" value="${fn:trim(dd.answer)}" />
            </c:if>
        </c:forEach>
        <c:set var="showSanghaSeparately" value="${isCustomRequest || (not empty sanghaChoice && sanghaChoice ne 'ชุดสังฆทานมาตรฐาน')}" />
        <c:set var="hideSangha" value="${!showSanghaSeparately}" />

        <%-- 3. รายละเอียดแพ็กเกจ / ความต้องการ --%>
        <div class="section">
            <div class="section-title">
                <i class="bi bi-box-seam-fill"></i>
                <c:choose>
                    <c:when test="${isCustomRequest}">รายละเอียดงานบุญ (แจ้งความต้องการเบื้องต้น)</c:when>
                    <c:otherwise>รายละเอียดแพ็กเกจงานบุญ</c:otherwise>
                </c:choose>
            </div>
            
            <div class="sheet-box mb-3">
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="info-row mb-0">
                            <span class="info-label">ประเภทงานบุญ</span>
                            <span class="info-value">${b.ceremony.ceremonyType}</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-row mb-0">
                            <span class="info-label">
                                <c:choose>
                                    <c:when test="${isCustomRequest}">รูปแบบบริการ</c:when>
                                    <c:otherwise>ชื่อแพ็กเกจ</c:otherwise>
                                </c:choose>
                            </span>
                            <span class="info-value">${b.ceremony.ceremonyName}</span>
                        </div>
                    </div>
                    <c:if test="${not isCustomRequest && not empty b.ceremony.basePrice}">
                        <div class="col-12 mt-2 pt-2 border-top">
                            <div class="info-row mb-0">
                                <span class="info-label">ราคาเริ่มต้นแพ็กเกจ</span>
                                <span class="info-value price-text">
                                    ฿<fmt:formatNumber value="${b.ceremony.basePrice}" pattern="#,###"/>
                                </span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="package-inclusions-box">
                <div class="package-inclusions-title">
                    <i class="bi bi-check-circle-fill" style="color: #28a745;"></i>
                    <c:choose>
                        <c:when test="${isCustomRequest}">รายการบริการพื้นฐานที่จัดให้ :</c:when>
                        <c:otherwise>สิ่งที่รวมอยู่ในแพ็กเกจ :</c:otherwise>
                    </c:choose>
                </div>

                <c:choose>
                    <c:when test="${not empty packageItems}">
                        <div class="package-items-grid" id="packageItemsGrid">
                            <c:forEach var="pi" items="${packageItems}">
                                <c:if test="${pi.item.itemType.itemTypeId != 5 && pi.item.itemType.itemTypeId != 6
                                              && !(showSanghaSeparately && pi.item.itemName eq 'ชุดสังฆทานมาตรฐาน')}">
                                    <div class="package-item-chip" data-price="${pi.item.pricePerUnit}" data-qty="${pi.quantity}" data-name="${fn:trim(pi.item.itemName)}">
                                        <i class="bi bi-check2"></i>
                                        <span class="flex-grow-1">${pi.item.itemName}</span>
                                        <strong class="text-secondary ms-1">${pi.quantity} ${pi.item.unit}</strong>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-muted fst-italic py-1">- ไม่มีรายการอุปกรณ์ในระบบ -</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- 4. ตัวเลือกและความต้องการเพิ่มเติม --%>
        <c:if test="${not empty b.details}">

            <c:set var="sanghaHeaderPrinted" value="false" />
            <c:set var="additionalHeadingPrinted" value="false" />

            <hr class="divider">
            <div class="section" id="bookingDetailsSection">
                <c:forEach items="${b.details}" var="d">

                    <c:set var="isSanghaQuestion" value="${d.question.questionsText eq 'ต้องการสังฆทานหรือไม่' or d.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ' or d.question.questionsText eq 'จำนวนชุดสังฆทาน'}" />
                    
                    <c:if test="${not (isSanghaQuestion and hideSangha)}">
                    
                        <%-- แสดงหัวข้อใหญ่ "รายการเพิ่มเติมนอกเหนือจากแพ็กเกจ" พร้อมคลาส .section-title ให้เป็นสีเขียวเหมือนหัวข้ออื่นๆ --%>
                        <c:if test="${!isCustomRequest && not additionalHeadingPrinted && (d.question.questionsText eq 'รูปแบบการนิมนต์พระสงฆ์' or d.question.questionsText eq 'ต้องการชุดภัตตาหารปิ่นโตหรือไม่' or d.question.questionsText eq 'ต้องการสังฆทานหรือไม่')}">
                            <div class="section-title mt-4">
                                <i class="bi bi-plus-circle-fill"></i> รายการเพิ่มเติมนอกเหนือจากแพ็กเกจ
                            </div>
                            <c:set var="additionalHeadingPrinted" value="true" />
                        </c:if>

                        <c:if test="${d.question.questionsText eq 'รูปแบบการนิมนต์พระสงฆ์'}">
                            <div class="section-title mt-3">
                                <i class="bi bi-journal-text"></i> การนิมนต์พระสงฆ์
                            </div>
                        </c:if>

                        <c:if test="${d.question.questionsText eq 'ต้องการชุดภัตตาหารปิ่นโตหรือไม่'}">
                            <div class="section-title mt-4">
                                <i class="bi bi-box-seam"></i> ชุดภัตตาหารปิ่นโต
                            </div>
                        </c:if>

                        <c:if test="${isSanghaQuestion and showSanghaSeparately and not sanghaHeaderPrinted}">
                            <div class="section-title mt-4">
                                <i class="bi bi-gift"></i> ชุดสังฆทาน
                            </div>
                            <c:set var="sanghaHeaderPrinted" value="true" />
                        </c:if>

                        <c:if test="${d.question.questionsText eq 'มีความต้องการเพิ่มเติมหรือไม่'}">
                            <div class="section-title mt-4">
                                <i class="bi bi-plus-circle"></i> รายการเพิ่มเติม
                            </div>
                        </c:if>

                        <div class="info-row" data-qtext="${fn:trim(d.question.questionsText)}" data-answer="${fn:trim(d.answer)}">
						    <span class="info-label" style="width: 300px;"><c:out value="${d.question.questionsText}" default="รายการ"/></span>
						    <span class="info-value">
						        <c:out value="${d.answer}" default="-"/>
						        <c:if test="${d.question.questionsText eq 'เลือกชุดภัตตาหารปิ่นโต' or d.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ'}">
						            <c:choose>
						                <c:when test="${d.answer eq 'ปิ่นโตชุดประหยัด' or d.answer eq 'ชุดสังฆทานมาตรฐาน'}">(299 บาท)</c:when>
						                <c:when test="${d.answer eq 'ปิ่นโตชุดมาตรฐาน' or d.answer eq 'ชุดสังฆทานพรีเมียม'}">(399 บาท)</c:when>
						                <c:when test="${d.answer eq 'ปิ่นโตชุดพรีเมียม' or d.answer eq 'ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน'}">(499 บาท)</c:when>
						                <c:when test="${d.answer eq 'ปิ่นโตชุดพิเศษ'}">(599 บาท)</c:when>
						            </c:choose>
						        </c:if>
						    </span>
						</div>
                    </c:if>

                </c:forEach>
            </div>
        </c:if>

        <%-- สรุปค่าใช้จ่ายโดยประมาณ --%>
        <div class="cost-summary-wrapper">
            <div class="cost-summary-box" id="costSummaryBox">
                <div class="cost-summary-title"><i class="bi bi-calculator-fill"></i> สรุปค่าใช้จ่ายโดยประมาณ</div>
                <div class="cost-row">
                    <span class="cost-label" id="costPackageLabel">ราคาแพ็กเกจ:</span>
                    <span class="cost-value" id="costPackageValue">-</span>
                </div>
                <div class="cost-row" id="costAdditionalRow" style="display:none;">
                    <span class="cost-label">รายการเพิ่มเติม:</span>
                    <span class="cost-value" id="costAdditionalValue">-</span>
                </div>
                <div class="cost-row cost-discount" id="costDiscountRow" style="display:none;">
                    <span class="cost-label">ส่วนลดนิมนต์เอง:</span>
                    <span class="cost-value" id="costDiscountValue">-</span>
                </div>
                <div class="cost-row cost-total">
                    <span class="cost-label">ยอดรวมสุทธิ:</span>
                    <span class="cost-value" id="costTotalValue">-</span>
                </div>
                <div class="cost-summary-note">* หมายเหตุ: ราคาดังกล่าวเป็นเพียงราคาโดยประมาณเบื้องต้น และยังไม่รวมค่าใช้จ่ายเพิ่มเติมตามความต้องการของลูกค้า โดยทีมงานจะตรวจสอบรายละเอียดและยืนยันราคาอีกครั้ง</div>
            </div>
        </div>

        <%-- Action Bar --%>
        <div class="action-bar">
            <div>
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
                        <a href="${pageContext.request.contextPath}/organizer/quotation/create/${b.bookingId}" class="btn btn-approve text-decoration-none">จัดการใบเสนอราคา</a>
                    </c:when>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/organizer/bookings" class="btn-back">← กลับรายการจอง</a>
        </div>
    </div>
</div>

<%-- Footer --%>
<footer class="site-footer" style="padding: 30px 0; background: #fff; border-top: 1px solid #eee; text-align: center;">
    <div class="container">
        <p class="text-muted mb-0" style="font-size: 13.5px;">ระบบจัดการงานบุญสำหรับทีมงานและผู้ดูแลระบบ — บุญมีนำพา จัดงานบุญ</p>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>

<%-- Script คำนวณค่าใช้จ่ายอัตโนมัติ --%>
<script>
(function () {
    var PRICE_MAP = {
        "ปิ่นโตชุดประหยัด": 299,
        "ปิ่นโตชุดมาตรฐาน": 399,
        "ปิ่นโตชุดพรีเมียม": 499,
        "ปิ่นโตชุดพิเศษ": 599,
        "ชุดสังฆทานมาตรฐาน": 299,
        "ชุดสังฆทานพรีเมียม": 399,
        "ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน": 499
    };

    var MONK_COST_PER_RUP = 500 + 250 + 350 + 200; // 1,300 บาท/รูป
    var SELF_INVITE_DISCOUNT = 1500;

    function fmtMoney(n) {
        n = Math.round((n || 0) * 100) / 100;
        return '฿' + n.toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function collectAnswers() {
        var answers = {};
        document.querySelectorAll('#bookingDetailsSection .info-row[data-qtext]').forEach(function (row) {
            var q = row.getAttribute('data-qtext');
            var a = row.getAttribute('data-answer');
            if (q && !(q in answers)) {
                answers[q] = a;
            }
        });
        return answers;
    }

    function appendPricesToAnswers() {
        document.querySelectorAll('#bookingDetailsSection .info-row[data-qtext]').forEach(function (row) {
            var qText = row.getAttribute('data-qtext');
            if (qText === 'เลือกชุดภัตตาหารปิ่นโต' || qText === 'เลือกชุดสังฆทานที่ต้องการ') {
                var valueSpan = row.querySelector('.info-value');
                if (valueSpan) {
                    var choiceName = valueSpan.textContent.trim();
                    if (PRICE_MAP[choiceName] !== undefined && choiceName.indexOf('(') === -1) {
                        var price = PRICE_MAP[choiceName];
                        valueSpan.textContent = choiceName + ' (' + price.toLocaleString('th-TH') + ' บาท)';
                    }
                }
            }
        });
    }

    function calcCostSummary() {
        var box = document.getElementById('costSummaryBox');
        if (!box) return;

        appendPricesToAnswers();

        var basePriceRaw = "${b.ceremony.basePrice}";
        var basePrice = parseFloat(basePriceRaw) || 0;
        var ceremonyName = "${fn:trim(b.ceremony.ceremonyName)}";
        var isCustomRequest = (basePrice === 0) || (ceremonyName.indexOf('กรอกความต้องการ') !== -1);

        var answers = collectAnswers();

        var pintoTotal = 0;
        var wantPinto = answers['ต้องการชุดภัตตาหารปิ่นโตหรือไม่'];
        var pintoName = answers['เลือกชุดภัตตาหารปิ่นโต'];
        var pintoQty = parseInt(answers['จำนวนชุดภัตตาหารปิ่นโต'], 10) || 0;
        if (pintoName && pintoQty > 0 && (!wantPinto || wantPinto.indexOf('ไม่') === -1)) {
            pintoTotal = (PRICE_MAP[pintoName] || 0) * pintoQty;
        }

        var sanghaTotal = 0;
        var wantSangha = answers['ต้องการสังฆทานหรือไม่'];
        var sanghaName = answers['เลือกชุดสังฆทานที่ต้องการ'];
        var sanghaQty = parseInt(answers['จำนวนชุดสังฆทาน'], 10) || 0;
        if (sanghaName && sanghaQty > 0 && (!wantSangha || wantSangha.indexOf('ไม่') === -1)) {
            sanghaTotal = (PRICE_MAP[sanghaName] || 0) * sanghaQty;
        }

        var additionalTotal = pintoTotal + sanghaTotal;

        var inviteAnswer = answers['รูปแบบการนิมนต์พระสงฆ์'] || '';
        var isSelfInvite = inviteAnswer.indexOf('นิมนต์เอง') !== -1;

        var packageLabel, packageValue, discount = 0;

        if (isCustomRequest) {
            var fixedItemsTotal = 0;
            document.querySelectorAll('#packageItemsGrid .package-item-chip[data-price]').forEach(function (chip) {
                if (chip.getAttribute('data-name') === 'ชุดสังฆทานมาตรฐาน') return;
                var price = parseFloat(chip.getAttribute('data-price')) || 0;
                var qty = parseFloat(chip.getAttribute('data-qty')) || 0;
                fixedItemsTotal += price * qty;
            });

            var monkTotal = 0;
            if (!isSelfInvite) {
                var monkQty = parseInt(answers['จำนวนพระสงฆ์'], 10) || 0;
                monkTotal = monkQty * MONK_COST_PER_RUP;
            }

            packageLabel = 'ค่าบริการพื้นฐาน (ตามรายการที่จัดให้):';
            packageValue = fixedItemsTotal + monkTotal;
            discount = 0;
        } else {
            packageLabel = 'ราคาแพ็กเกจ:';
            packageValue = basePrice;
            discount = isSelfInvite ? SELF_INVITE_DISCOUNT : 0;
        }

        var grandTotal = packageValue + additionalTotal - discount;
        if (grandTotal < 0) grandTotal = 0;

        document.getElementById('costPackageLabel').textContent = packageLabel;
        document.getElementById('costPackageValue').textContent = fmtMoney(packageValue);

        var addRow = document.getElementById('costAdditionalRow');
        if (additionalTotal > 0) {
            addRow.style.display = '';
            document.getElementById('costAdditionalValue').textContent = fmtMoney(additionalTotal);
        } else {
            addRow.style.display = 'none';
        }

        var discRow = document.getElementById('costDiscountRow');
        if (discount > 0) {
            discRow.style.display = '';
            document.getElementById('costDiscountValue').textContent = '- ' + fmtMoney(discount);
        } else {
            discRow.style.display = 'none';
        }

        document.getElementById('costTotalValue').textContent = fmtMoney(grandTotal);
    }

    document.addEventListener('DOMContentLoaded', calcCostSummary);
})();
</script>

<script src="${pageContext.request.contextPath}/static/js/bookingDetail.js"></script>
</body>
</html>