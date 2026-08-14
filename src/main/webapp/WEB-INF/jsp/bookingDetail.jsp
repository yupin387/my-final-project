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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookingDetail.css">
    <style>
        /* ===== สรุปค่าใช้จ่ายโดยประมาณ (คำนวณฝั่ง JSTL ล้วน ไม่แตะ Controller/Java) ===== */
        .cost-summary-box {
            margin-top: 16px;
            border: 2px solid var(--gold-mid, #b8860b);
            border-radius: 14px;
            overflow: hidden;
            background: #fff;
        }
        .cost-summary-title {
            background: #fdf3e7;
            padding: 12px 18px;
            font-weight: 700;
            color: #7a4a1e;
            border-bottom: 1px solid #e8d3a0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .cost-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 18px;
            border-bottom: 1px dashed #eee2cf;
            font-size: 0.98rem;
        }
        .cost-row:last-child { border-bottom: none; }
        .cost-row .cost-label { color: #555; }
        .cost-row .cost-value { font-weight: 600; color: #222; }
        .cost-row.cost-discount .cost-value { color: #d9534f; }
        .cost-row.cost-total {
            background: #fff8f0;
            padding: 14px 18px;
        }
        .cost-row.cost-total .cost-label { font-weight: 700; color: #7a4a1e; }
        .cost-row.cost-total .cost-value { font-size: 1.25rem; font-weight: 800; color: #d9534f; }
        .cost-summary-note {
            padding: 8px 18px 14px;
            font-size: 0.82rem;
            color: #999;
            font-style: italic;
        }
    </style>
</head>
<body>

<%-- ===== NAVBAR (คงเดิมตามเงื่อนไข) ===== --%>
<nav class="navbar">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/organizer/bookings" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
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

    <%-- เอกสารแผ่นกระดาษ (Paper Sheet Document) --%>
    <div class="booking-sheet-document">

        <%-- Header เอกสารส่วนหัว --%>
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
                <h2 class="doc-title">สรุปรายละเอียดการจอง</h2>
                <div class="doc-no">รหัสการจอง: <strong>#${b.bookingId}</strong></div>
                <div style="margin-top: 8px;">
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
            </div>
        </div>

        <hr class="sheet-divider-bold">

        <%-- 1. ข้อมูลผู้จอง + วันและสถานที่ (ปรับเป็น 2 คอลัมน์) --%>
        <div class="section">
            <div class="sheet-cols">
                <div class="sheet-box">
                    <div class="section-title"><i class="bi bi-person-fill"></i> ข้อมูลผู้ใช้บริการ</div>
                    <div class="info-row"><span class="info-label">ชื่อ-นามสกุล</span><span class="info-value">คุณ ${b.member.memberFirstName} ${b.member.memberLastName}</span></div>
                    <div class="info-row"><span class="info-label">เบอร์โทรศัพท์</span><span class="info-value">${b.member.phoneNumber}</span></div>
                    <c:if test="${not empty b.member.memberEmail}">
                        <div class="info-row"><span class="info-label">อีเมล</span><span class="info-value">${b.member.memberEmail}</span></div>
                    </c:if>
                </div>
                <div class="sheet-box">
                    <div class="section-title"><i class="bi bi-calendar-event-fill"></i> กำหนดการและสถานที่</div>
                    <div class="info-row"><span class="info-label">วันที่จัดงาน</span><span class="info-value"><fmt:formatDate value="${b.eventDate}" pattern="dd MMMM yyyy"/></span></div>
                    <div class="info-row"><span class="info-label">เวลาเริ่มพิธี</span><span class="info-value">${b.eventTime} น.</span></div>
                    <div class="info-row"><span class="info-label">สถานที่จัดงาน</span><span class="info-value">${b.eventAddress}</span></div>
                </div>
            </div>
        </div>

        <%-- 2. แผนที่ + รูปภาพสถานที่จัดงาน (2 คอลัมน์) --%>
        <c:if test="${not empty b.eventAddress}">
            <div class="section" style="padding-top: 0;">
                <div class="sheet-cols">
                    <div>
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
                    <div>
                        <div class="section-title"><i class="bi bi-images"></i> รูปภาพสถานที่ประกอบ</div>
                        <c:choose>
                            <c:when test="${not empty b.addressImage}">
                                <div class="image-gallery">
                                    <c:forEach items="${fn:split(b.addressImage, ',')}" var="imgFile">
                                        <c:set var="trimmed" value="${fn:trim(imgFile)}"/>
                                        <c:if test="${not empty trimmed}">
                                            <img src="${pageContext.request.contextPath}/uploads/address/${trimmed}" class="location-img" onerror="this.style.display='none'">
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="no-img-box"><i class="bi bi-image"></i> ไม่มีรูปภาพสถานที่</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:if>
        
        <hr class="divider">

        <%-- ===================================================================
             คำนวณค่าใช้จ่ายโดยประมาณล่วงหน้า (JSTL ล้วน ไม่แตะ Java/Controller)
             ใช้ค่าจาก packageItems / pintoItems / sanghatharnItems ที่มีอยู่แล้ว
             =================================================================== --%>

        <%-- -- การนิมนต์พระสงฆ์ -- --%>
        <c:set var="monkType" value=""/>
        <c:set var="monkQty" value="0"/>
        <c:forEach items="${b.details}" var="d">
            <c:if test="${fn:contains(d.question.questionsText, 'รูปแบบการนิมนต์')}">
                <c:set var="monkType" value="${fn:trim(d.answer)}"/>
            </c:if>
            <c:if test="${fn:contains(d.question.questionsText, 'จำนวนพระ')}">
                <c:set var="monkQty" value="${empty fn:trim(d.answer) ? 0 : fn:trim(d.answer)}"/>
            </c:if>
        </c:forEach>
        <c:set var="isSelfInvite" value="${fn:contains(monkType, 'นิมนต์เอง')}"/>

        <%-- -- สังฆทาน -- --%>
        <c:set var="sangWant" value="ต้องการ"/>
        <c:set var="sanghaChoiceName" value=""/>
        <c:set var="sanghaQty" value="0"/>
        <c:forEach items="${b.details}" var="d">
            <c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน') && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                <c:set var="sangWant" value="${fn:trim(d.answer)}"/>
            </c:if>
            <c:if test="${fn:contains(d.question.questionsText, 'เลือก') && fn:contains(d.question.questionsText, 'สังฆทาน')}">
                <c:set var="sanghaChoiceName" value="${fn:trim(d.answer)}"/>
            </c:if>
            <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'สังฆทาน')}">
                <c:set var="sanghaQty" value="${empty fn:trim(d.answer) ? 0 : fn:trim(d.answer)}"/>
            </c:if>
        </c:forEach>
        <%-- ชุดสังฆทานมาตรฐาน (299) แถมฟรีในแพ็กเกจอยู่แล้ว: ถ้าเลือกชุดนี้ ให้ซ่อนหัวข้อทั้งหมด + ไม่คิดราคาเพิ่ม --%>
        <c:set var="hideSangha" value="${sanghaChoiceName eq 'ชุดสังฆทานมาตรฐาน'}"/>
        <c:set var="sanghaPrice" value="0"/>
        <c:if test="${not hideSangha}">
            <c:forEach items="${sanghatharnItems}" var="sItem2">
                <c:if test="${sItem2.itemName eq sanghaChoiceName}">
                    <c:set var="sanghaPrice" value="${sItem2.pricePerUnit}"/>
                </c:if>
            </c:forEach>
        </c:if>
        <c:set var="sanghaTotal" value="0"/>
        <c:if test="${sangWant == 'ต้องการ' && not hideSangha}">
            <c:set var="sanghaTotal" value="${sanghaPrice * sanghaQty}"/>
        </c:if>

        <%-- -- ปิ่นโต -- --%>
        <c:set var="pintoWant" value="ไม่ต้องการ"/>
        <c:set var="pintoChoiceName" value=""/>
        <c:set var="pintoQty" value="0"/>
        <c:forEach items="${b.details}" var="d">
            <c:if test="${(fn:contains(d.question.questionsText, 'ภัตตาหาร') || fn:contains(d.question.questionsText, 'ปิ่นโต')) && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                <c:set var="pintoWant" value="${fn:trim(d.answer)}"/>
            </c:if>
            <c:if test="${fn:contains(d.question.questionsText, 'เลือก') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                <c:set var="pintoChoiceName" value="${fn:trim(d.answer)}"/>
            </c:if>
            <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                <c:set var="pintoQty" value="${empty fn:trim(d.answer) ? 0 : fn:trim(d.answer)}"/>
            </c:if>
        </c:forEach>
        <c:set var="pintoPrice" value="0"/>
        <c:forEach items="${pintoItems}" var="pItem2">
            <c:if test="${pItem2.itemName eq pintoChoiceName}">
                <c:set var="pintoPrice" value="${pItem2.pricePerUnit}"/>
            </c:if>
        </c:forEach>
        <c:set var="pintoTotal" value="0"/>
        <c:if test="${pintoWant == 'ต้องการ'}">
            <c:set var="pintoTotal" value="${pintoPrice * pintoQty}"/>
        </c:if>

        <c:set var="additionalTotal" value="${pintoTotal + sanghaTotal}"/>

        <%-- -- ประเภทงาน: แพ็กเกจ หรือ กรอกความต้องการเบื้องต้น -- --%>
        <c:set var="isCustomRequest" value="${b.ceremony.basePrice == 0 || fn:contains(b.ceremony.ceremonyName, 'กรอกความต้องการ')}"/>

        <c:if test="${isCustomRequest}">
            <%-- รวมราคารายการที่ระบบจัดให้อัตโนมัติ (ไม่รวมประเภทแพ็กเกจ/อุปกรณ์เสริม) --%>
            <c:set var="fixedItemsTotal" value="0"/>
            <c:forEach var="pi2" items="${packageItems}">
                <c:if test="${pi2.item.itemType.itemTypeId != 5 && pi2.item.itemType.itemTypeId != 6}">
                    <c:set var="fixedItemsTotal" value="${fixedItemsTotal + (pi2.item.pricePerUnit * pi2.quantity)}"/>
                </c:if>
            </c:forEach>
            <%-- ค่านิมนต์พระ 1,300/รูป (บริการนิมนต์ 500 + อาสนะ 250 + ตาลปัตร 350 + กรวยดอกไม้ 200) เฉพาะกรณีไม่ได้นิมนต์เอง --%>
            <c:set var="monkCost" value="0"/>
            <c:if test="${not isSelfInvite}">
                <c:set var="monkCost" value="${monkQty * 1300}"/>
            </c:if>
            <c:set var="packageLabel" value="ค่าบริการพื้นฐาน (ตามรายการที่จัดให้)"/>
            <c:set var="packageValue" value="${fixedItemsTotal + monkCost}"/>
            <c:set var="discountValue" value="0"/>
        </c:if>
        <c:if test="${not isCustomRequest}">
            <c:set var="packageLabel" value="ราคาแพ็กเกจ"/>
            <c:set var="packageValue" value="${b.ceremony.basePrice}"/>
            <c:set var="discountValue" value="${isSelfInvite ? 1500 : 0}"/>
        </c:if>

        <c:set var="grandTotal" value="${packageValue + additionalTotal - discountValue}"/>

        <%-- 3. รายละเอียดงานบุญและแพ็กเกจ --%>
        <div class="section">
            <div class="section-title"><i class="bi bi-box-seam-fill"></i> รายละเอียดแพ็กเกจงานบุญ</div>
            
            <div class="sheet-box" style="margin-bottom: 16px;">
                <div class="info-row">
                    <span class="info-label">ประเภทงานบุญ</span>
                    <span class="info-value">${b.ceremony.ceremonyType}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">ชื่อแพ็กเกจ</span>
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
                        <span class="info-value price-text">฿<fmt:formatNumber value="${b.ceremony.basePrice}" pattern="#,###"/></span>
                    </div>
                </c:if>
            </div>

            <%-- สิ่งที่รวมอยู่ในแพ็กเกจ --%>
            <div class="package-inclusions-box">
                <div class="package-inclusions-title">
                    <i class="bi bi-check-circle-fill"></i> สิ่งที่รวมอยู่ในแพ็กเกจ :
                </div>

                <c:choose>
                    <c:when test="${not empty packageItems}">
                        <div class="package-items-grid">
                            <c:forEach var="pi" items="${packageItems}">
                                <c:if test="${pi.item.itemType.itemTypeId != 5 && pi.item.itemType.itemTypeId != 6}">
                                    <div class="package-item-chip">
                                        <i class="bi bi-check2"></i>
                                        <span class="chip-title">${pi.item.itemName}</span>
                                        <strong class="chip-qty">${pi.quantity} ${pi.item.unit}</strong>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-items-text">- ไม่มีรายการอุปกรณ์ในระบบ -</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- ===== สรุปค่าใช้จ่ายโดยประมาณ ===== --%>
            <div class="cost-summary-box">
                <div class="cost-summary-title"><i class="bi bi-calculator-fill"></i> สรุปค่าใช้จ่ายโดยประมาณ</div>
                <div class="cost-row">
                    <span class="cost-label">${packageLabel}:</span>
                    <span class="cost-value">฿<fmt:formatNumber value="${packageValue}" pattern="#,##0.00"/></span>
                </div>
                <c:if test="${additionalTotal > 0}">
                    <div class="cost-row">
                        <span class="cost-label">รายการเพิ่มเติม:</span>
                        <span class="cost-value">฿<fmt:formatNumber value="${additionalTotal}" pattern="#,##0.00"/></span>
                    </div>
                </c:if>
                <c:if test="${discountValue > 0}">
                    <div class="cost-row cost-discount">
                        <span class="cost-label">ส่วนลดนิมนต์เอง:</span>
                        <span class="cost-value">- ฿<fmt:formatNumber value="${discountValue}" pattern="#,##0.00"/></span>
                    </div>
                </c:if>
                <div class="cost-row cost-total">
                    <span class="cost-label">ยอดรวมสุทธิ:</span>
                    <span class="cost-value">฿<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/></span>
                </div>
                <div class="cost-summary-note">* เป็นราคาประมาณการเบื้องต้นเท่านั้น ราคาจริงยืนยันอีกครั้งตอนออกใบเสนอราคา</div>
            </div>
        </div>

        <hr class="divider">

        <%-- 4. การนิมนต์พระสงฆ์ --%>
        <div class="section">
            <div class="section-title"><i class="bi bi-journal-text"></i> การนิมนต์พระสงฆ์</div>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รูปแบบการนิมนต์')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'รายละเอียดการนิมนต์พระสงฆ์')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value" style="white-space:pre-line;"><c:choose><c:when test="${monkType == 'นิมนต์เอง'}">-</c:when><c:when test="${not empty fn:trim(d.answer) && fn:trim(d.answer) != ','}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวนพระ')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer) && fn:trim(d.answer) != ','}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <%-- 5. ชุดสังฆทาน — ซ่อนทั้งหมดถ้าเลือกเป็นเซตมาตรฐาน (299) เพราะรวมอยู่ในแพ็กเกจแล้ว --%>
        <c:if test="${not hideSangha}">
        <hr class="divider">
        <div class="section">
            <div class="section-title"><i class="bi bi-gift"></i> ชุดสังฆทาน</div>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'สังฆทาน') && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>ไม่ต้องการ</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'เลือก') && fn:contains(d.question.questionsText, 'สังฆทาน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${sangWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}<c:forEach items="${sanghatharnItems}" var="sItem"><c:if test="${sItem.itemName == fn:trim(d.answer)}"><span style="color:var(--gold-mid);font-size:13px;"> — ฿<fmt:formatNumber value="${sItem.pricePerUnit}" pattern="#,###"/> / ${sItem.unit}</span></c:if></c:forEach></c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'สังฆทาน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${sangWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>
        </c:if>

        <hr class="divider">

        <%-- 6. ชุดภัตตาหารปิ่นโต --%>
        <div class="section">
            <div class="section-title"><i class="bi bi-box-seam"></i> ชุดภัตตาหารปิ่นโต</div>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${(fn:contains(d.question.questionsText, 'ภัตตาหาร') || fn:contains(d.question.questionsText, 'ปิ่นโต')) && !fn:contains(d.question.questionsText, 'เลือก') && !fn:contains(d.question.questionsText, 'จำนวน')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>ไม่ต้องการ</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'เลือก') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${pintoWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}<c:forEach items="${pintoItems}" var="pItem"><c:if test="${pItem.itemName == fn:trim(d.answer)}"><span style="color:var(--gold-mid);font-size:13px;"> — ฿<fmt:formatNumber value="${pItem.pricePerUnit}" pattern="#,###"/> / ${pItem.unit}</span></c:if></c:forEach></c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>

            <c:forEach items="${b.details}" var="d">
                <c:if test="${fn:contains(d.question.questionsText, 'จำนวน') && fn:contains(d.question.questionsText, 'ปิ่นโต')}">
                    <div class="info-row"><span class="info-label">${d.question.questionsText}</span><span class="info-value"><c:choose><c:when test="${pintoWant != 'ต้องการ'}">-</c:when><c:when test="${not empty fn:trim(d.answer)}">${fn:trim(d.answer)}</c:when><c:otherwise>-</c:otherwise></c:choose></span></div>
                </c:if>
            </c:forEach>
        </div>

        <%-- 7. หมายเหตุเพิ่มเติม --%>
        <c:forEach items="${b.details}" var="d">
            <c:if test="${fn:contains(d.question.questionsText, 'ความต้องการเพิ่มเติม')}">
                <hr class="divider">
                <div class="section">
                    <div class="section-title"><i class="bi bi-plus-circle"></i> หมายเหตุเพิ่มเติม</div>
                    <div class="info-row">
                        <span class="info-label">${d.question.questionsText}</span>
                        <span class="info-value" style="white-space: pre-line;">${not empty fn:trim(d.answer) ? fn:trim(d.answer) : '-'}</span>
                    </div>
                </div>
            </c:if>
        </c:forEach>

        <%-- Action Bar (คงปุ่มกดและฟังก์ชันเดิมตามเงื่อนไข) --%>
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
            <a href="${pageContext.request.contextPath}/organizer/bookings" class="btn-back">← กลับรายการจอง</a>
        </div>
    </div>
</div>

<%-- ===== FOOTER (คงเดิมตามเงื่อนไข) ===== --%>
<footer class="footer-custom">
    <div class="footer-container">
        <div class="footer-left">
            <div class="footer-brand">
                <div class="footer-logo">
                    <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา" onerror="this.style.display='none'">
                </div>
                <span class="footer-brand-title">บุญมีนำพา จัดงานบุญ</span>
            </div>
            <p class="footer-desc">ระบบจัดการงานบุญสำหรับทีมงานและผู้ดูแลระบบ</p>
        </div>
        <div class="footer-right">
            <h5 class="footer-heading">ติดต่อเรา</h5>
            <div class="footer-contact-list">
                <div class="contact-item">📞 โทร. 08X-XXX-XXXX</div>
                <div class="contact-item">💬 LINE OA: @boonmee</div>
                <div class="contact-item">✉️ boonmee@gmail.com</div>
            </div>
        </div>
    </div>
</footer>

<%-- Modal อนุมัติ (คงเดิมตามเงื่อนไข) --%>
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

<%-- Modal ปฏิเสธ (คงเดิมตามเงื่อนไข) --%>
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

<script src="${pageContext.request.contextPath}/static/js/bookingDetail.js"></script>
</body>
</html>
