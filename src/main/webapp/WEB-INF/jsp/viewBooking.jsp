<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ใบสรุปรายละเอียดการจอง ${booking.bookingId} - บุญมีนำพา</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/viewBooking.css?v=28">
    <style>
        /* ===== สรุปค่าใช้จ่ายโดยประมาณ (คำนวณฝั่ง JS ล้วน ไม่แตะ backend) ===== */
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

        /* ===== กล่องแจ้งเตือน "ปฏิเสธการจอง" (ใช้โครงเดียวกับ .booking-notice เดิม แต่สลับเป็นโทนแดง) ===== */
        .booking-notice.notice-rejected {
            border-color: #f2b8b5;
            background: #fff5f5;
        }
        .booking-notice.notice-rejected .notice-icon {
            color: #ffffff;
            background: #c62828;
        }
        .booking-notice.notice-rejected .notice-content strong {
            color: #c62828;
        }
        .booking-notice.notice-rejected .notice-content p {
            color: #7a3b3b;
        }
        .notice-reject-reason {
            margin-top: 6px;
            padding: 8px 12px;
            background: #ffffff;
            border: 1px solid #f2b8b5;
            border-radius: 8px;
            font-size: 0.85rem;
            color: #5c2b2b;
            line-height: 1.5;
        }
        .notice-reject-reason strong {
            color: #c62828;
        }
    </style>
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

        <a href="${pageContext.request.contextPath}/myBookings" class="nav-link-item active">รายการจอง</a>

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

    <%-- แจ้งเตือนกรณีรอการติดต่อ --%>
    <c:if test="${booking.bookingStatus == 'Pending'}">
        <div class="booking-notice">
            <div class="notice-icon"><i class="bi bi-telephone-inbound-fill"></i></div>
            <div class="notice-content">
                <strong>รอการติดต่อจากทีมงาน</strong>
                <p>หลังจากท่านส่งยืนยันการจองแล้ว กรุณารอการติดต่อจากทีมงานเพื่อประสานงานรายละเอียดเพิ่มเติม พร้อมจัดทำใบเสนอราคาเพื่อยืนยันการจองอีกครั้ง</p>
            </div>
        </div>	
    </c:if>

    <%-- แจ้งเตือนกรณีถูกปฏิเสธ พร้อมเหตุผลที่ทีมงานระบุไว้ --%>
    <c:if test="${booking.bookingStatus == 'Rejected'}">
        <div class="booking-notice notice-rejected">
            <div class="notice-icon"><i class="bi bi-x-circle-fill"></i></div>
            <div class="notice-content">
                <strong>รายการจองนี้ถูกปฏิเสธ</strong>
                <p>ทีมงานได้พิจารณาและไม่สามารถรับงานนี้ได้ กรุณาดูเหตุผลด้านล่าง หากมีข้อสงสัยสามารถติดต่อทีมงานเพื่อสอบถามเพิ่มเติมได้</p>
                <div class="notice-reject-reason">
                    <strong>เหตุผลที่ปฏิเสธ:</strong>
                    <c:out value="${booking.rejectDetail}" default="ไม่ได้ระบุเหตุผล"/>
                </div>
            </div>
        </div>
    </c:if>

    <%-- กระดาษเอกสารใบสรุปการจอง --%>
    <div class="booking-sheet-document">
        
        <%-- Header เอกสาร --%>
        <div class="sheet-header">
            <div class="company-brand">
                <div class="brand-logo">
                    <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา" onerror="this.style.display='none'">
                </div>
                <div>
                    <h1 class="company-name">บุญมีนำพา รับจัดงานบุญ</h1>
                    <p class="company-sub">บริการรับจัดงานบุญ พิธีทำบุญบ้าน และงานพิธีสงฆ์ทุกรูปแบบ</p>
                </div>
            </div>
            
            <div class="document-title-box">
                <h2 class="doc-title">ใบสรุปรายละเอียดการจอง</h2>
                <div class="doc-no">รหัสรายการจอง: <strong>${booking.bookingId}</strong></div>
                <div class="mt-2">
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
                </div>

                <div class="col-md-6">
                    <div class="sheet-box">
                        <div class="section-title"><i class="bi bi-calendar-event-fill"></i> กำหนดการและสถานที่</div>
                       <div class="info-row">
    <span class="info-label">วันที่จัดงาน</span>
    <span class="info-value"><fmt:formatDate value="${booking.eventDate}" pattern="dd/MM/yyyy"/></span>
</div>
                        <div class="info-row">
                            <span class="info-label">เวลาเริ่มพิธี</span>
                            <span class="info-value">${booking.eventTime} น.</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">สถานที่จัดงาน</span>
                            <span class="info-value">${booking.eventAddress}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 2. แผนที่และรูปภาพสถานที่ --%>
        <c:if test="${not empty booking.eventAddress}">
            <div class="section pt-0">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="section-title"><i class="bi bi-geo-alt-fill"></i> แผนที่ปักหมุดสถานที่</div>
                        <c:set var="mapQuery" value="${not empty booking.eventLat && not empty booking.eventLng ? booking.eventLat += ',' += booking.eventLng : fn:escapeXml(booking.eventAddress)}" />
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

        <%-- ===== ตัวแปรควบคุมการแสดงผล คำนวณล่วงหน้าก่อนเข้าส่วนที่ 3 ===== --%>
        <c:set var="basePriceVal" value="${booking.ceremony.basePrice}" />
        <c:set var="isCustomRequest" value="${empty basePriceVal || basePriceVal == 0 || fn:indexOf(booking.ceremony.ceremonyName, 'กรอกความต้องการ') ne -1}" />

        <c:set var="sanghaChoice" value="" />
        <c:forEach items="${booking.details}" var="dd">
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
                            <span class="info-value">${booking.ceremony.ceremonyType}</span>
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
                            <span class="info-value">${booking.ceremony.ceremonyName}</span>
                        </div>
                    </div>
                    <c:if test="${not isCustomRequest && not empty booking.ceremony.basePrice}">
                        <div class="col-12 mt-2 pt-2 border-top">
                            <div class="info-row mb-0">
                                <span class="info-label">ราคาเริ่มต้นแพ็กเกจ</span>
                                <span class="info-value price-text">
                                    ฿<fmt:formatNumber value="${booking.ceremony.basePrice}" pattern="#,###"/>
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
        <c:if test="${not empty booking.details}">

            <c:set var="sanghaHeaderPrinted" value="false" />

            <hr class="divider">
            <div class="section" id="bookingDetailsSection">
                <%-- เพิ่มหัวข้อ "รายการเพิ่มเติมนอกเหนือจากแพ็กเกจ" ไว้ด้านบนสุด ให้เหมือนฝั่ง Organizer โดยใช้สไตล์ section-title ของ Member --%>
				<c:if test="${not isCustomRequest}">
				    <div class="section-title">
				        <i class="bi bi-plus-circle"></i> รายการเพิ่มเติมนอกเหนือจากแพ็กเกจ
				    </div>
				</c:if>
                <c:forEach items="${booking.details}" var="d">

                    <c:set var="isSanghaQuestion" value="${d.question.questionsText eq 'ต้องการสังฆทานหรือไม่' or d.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ' or d.question.questionsText eq 'จำนวนชุดสังฆทาน'}" />
                    
                    <c:if test="${not (isSanghaQuestion and hideSangha)}">
                    
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
						        <c:choose>
						            <c:when test="${not empty d.answer and fn:trim(d.answer) ne ''}">
						                <c:out value="${d.answer}"/>
						                <c:if test="${d.question.questionsText eq 'เลือกชุดภัตตาหารปิ่นโต' or d.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ'}">
						                    <c:choose>
						                        <c:when test="${d.answer eq 'ปิ่นโตชุดประหยัด' or d.answer eq 'ชุดสังฆทานมาตรฐาน'}">(299 บาท)</c:when>
						                        <c:when test="${d.answer eq 'ปิ่นโตชุดมาตรฐาน' or d.answer eq 'ชุดสังฆทานพรีเมียม'}">(399 บาท)</c:when>
						                        <c:when test="${d.answer eq 'ปิ่นโตชุดพรีเมียม' or d.answer eq 'ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน'}">(499 บาท)</c:when>
						                        <c:when test="${d.answer eq 'ปิ่นโตชุดพิเศษ'}">(599 บาท)</c:when>
						                    </c:choose>
						                </c:if>
						            </c:when>
						            <c:otherwise>-</c:otherwise>
						        </c:choose>
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
                    <c:when test="${booking.bookingStatus == 'Completed'}">
                        <c:choose>
                            <c:when test="${empty hasReview || !hasReview}">
                                <a href="${pageContext.request.contextPath}/review/write/${booking.bookingId}" class="btn btn-review">
                                    <i class="bi bi-star-fill me-1"></i> เขียนรีวิวความประทับใจ
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-reviewed" disabled>คุณได้รีวิวงานนี้แล้ว</button>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${booking.bookingStatus == 'Pending'}">
                        <button type="button" class="btn btn-cancel" onclick="showCancelModal('${booking.bookingId}')">
                            <i class="bi bi-x-circle me-1"></i> ยกเลิกรายการจอง
                        </button>
                    </c:when>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn-back">← กลับหน้าหลัก</a>
        </div>
    </div>
</div>

<%-- Footer --%>
<footer class="site-footer">
		<div class="footer-top">
			<svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
				style="display: block; width: 100%; height: 8px;">
            <rect width="1200" height="8" fill="url(#footerGrad)" />
            <defs>
                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%"
					y2="0%">
                    <stop offset="0%" stop-color="rgba(217,164,65,0.15)" />
                    <stop offset="50%" stop-color="rgba(217,164,65,0.9)" />
                    <stop offset="100%" stop-color="rgba(217,164,65,0.15)" />
                </linearGradient>
            </defs>
        </svg>
		</div>
		<div class="container footer-content footer-content-slim">
			<div class="footer-col footer-brand-col">
				<div class="footer-brand">
					<div class="lotus-icon">
						<img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
					</div>
					<span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
				</div>
				<p class="footer-tagline">รับจัดงานบุญ
					ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
				<div class="footer-social">
					<a href="#" class="footer-social-link">📘 Facebook</a>
					<a href="#" class="footer-social-link">▶️ YouTube</a>
					<a href="#" class="footer-social-link">💬 LINE OA</a>
				</div>
			</div>

			<div class="footer-col footer-contact-col">
				<h4 class="footer-heading">ติดต่อเรา</h4>
				<p>📞 โทร. 08X-XXX-XXXX</p>
				<p>💬 LINE OA: @boonmee</p>
				<p>✉️ boonmee@gmail.com</p>
				<p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
			</div>
		</div>
</footer>

<%-- Modal ยกเลิกการจอง (โครงสร้างตามแบบรูปที่ 1 + ปุ่มยืนยันสีแดง) --%>
<div class="modal fade" id="cancelModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modal-custom-card">
            <div class="modal-body text-center p-4">
                
                <%-- หัวข้อหลัก --%>
                <h4 class="modal-title-custom mb-2">ยืนยันการยกเลิกการจอง</h4>
                
                <p class="text-muted small mb-3">
                    การดำเนินการนี้จะเปลี่ยนสถานะเป็น "ยกเลิกแล้ว"
                </p>

                <%-- Badge แสดงรหัสการจอง (สไตล์รูปที่ 1) --%>
                <div class="booking-code-badge mb-3">
                    รหัส: <span id="cancelBookingId">${booking.bookingId}</span>
                </div>

                <p class="text-muted small mb-4">
                    หากยกเลิกแล้วจะไม่สามารถย้อนกลับได้
                </p>

                <%-- กลุ่มปุ่มกด (ยกเลิกอยู่ซ้าย / ยืนยันสีแดงอยู่ขวา) --%>
                <div class="d-flex justify-content-center gap-3">
                    <button type="button" class="btn btn-modal-cancel" data-bs-dismiss="modal">
                        ยกเลิก
                    </button>
                    <a id="confirmCancelUrl" href="#" class="btn btn-modal-danger">
                        ยืนยันยกเลิก
                    </a>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
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

        var basePriceRaw = "${booking.ceremony.basePrice}";
        var basePrice = parseFloat(basePriceRaw) || 0;
        var ceremonyName = "${fn:trim(booking.ceremony.ceremonyName)}";
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

            packageLabel = 'ค่าบริการพื้นฐาน (ตามรายการที่จัดให้):';
            packageValue = fixedItemsTotal;
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
<script src="${pageContext.request.contextPath}/static/js/viewBooking.js?v=28"></script>
</body>
</html>
