<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ใบสรุปรายละเอียดการจอง ${b.bookingId} - บุญมีนำพา</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookingDetail.css?v=2">
</head>
<body>

<%-- ===== NAVBAR ===== --%>
<nav class="navbar">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/manager/bookings" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon" onerror="this.style.display='none'">
        <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/manager/bookings"   class="nav-item active">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/manager/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/manager/questions"  class="nav-item">จัดการแพ็กเกจ</a>
            <a href="${pageContext.request.contextPath}/manager/quotation"  class="nav-item">จัดการใบเสนอราคา</a>
        </nav>
        <div class="dropdown-wrap">
              <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">M</div>
            <div class="user-detail">
                <span class="user-name">Manager</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
                <span class="arrow">▾</span>
            </div>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/manager/logout" class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</nav>

<%-- ===== PAGE WRAPPER ===== --%>
<div class="page-wrapper">

  <%-- ===== Flash Message (success / error) ===== --%>
    <c:if test="${not empty success}">
        <div style="background:#e8f5e9; border:1.5px solid #43a047; color:#1b5e20;
                    padding:14px 20px; border-radius:10px; margin-bottom:18px;
                    font-weight:600; font-size:0.92rem; display:flex; align-items:center; gap:10px;">
            <i class="bi bi-check-circle-fill"></i> ${success}
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div style="background:#fdecea; border:1.5px solid #c62828; color:#8B0000;
                    padding:14px 20px; border-radius:10px; margin-bottom:18px;
                    font-weight:600; font-size:0.92rem; display:flex; align-items:center; gap:10px;">
            <i class="bi bi-exclamation-triangle-fill"></i> ${error}
        </div>
    </c:if>

    <div class="back-link-row">
        <a href="${pageContext.request.contextPath}/manager/bookings" class="back-link"><i class="bi bi-arrow-left"></i> กลับรายการจอง</a>
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
                <div class="doc-no">รหัสรายการจอง: <strong>${b.bookingId}</strong></div>
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
    <span class="info-value"><fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy"/></span>
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

        <%-- ===== ตัวแปรควบคุมการแสดงผล คำนวณล่วงหน้าก่อนเข้าส่วนที่ 3 ===== --%>
        <%-- เปลี่ยนจาก b.pkg เป็น b.packageEntity --%>
        <c:set var="basePriceVal" value="${b.packageEntity.basePrice}" />
        <c:set var="isCustomRequest" value="${empty basePriceVal || basePriceVal == 0 || fn:indexOf(b.packageEntity.optionType, 'กรอกความต้องการ') ne -1}" />

        <%-- อ่านชุดสังฆทานที่ลูกค้าเลือก และจำนวนชุดที่สั่ง --%>
        <c:set var="sanghaChoice" value="" />
        <c:set var="sanghaQtyRaw" value="0" />
        <c:forEach items="${b.details}" var="dd">
            <c:if test="${dd.question.questionsText eq 'เลือกชุดสังฆทานที่ต้องการ'}">
                <c:set var="sanghaChoice" value="${fn:trim(dd.answer)}" />
            </c:if>
            <c:if test="${dd.question.questionsText eq 'จำนวนชุดสังฆทาน' && not empty fn:trim(dd.answer)}">
                <c:set var="sanghaQtyRaw" value="${fn:trim(dd.answer)}" />
            </c:if>
        </c:forEach>

        <%-- หาชุดสังฆทานที่ "รวมอยู่ในแพ็กเกจ" จาก PackageItem (โหมดกรอกเองจะไม่มี) --%>
        <c:set var="includedName" value="" />
        <c:set var="includedPrice" value="0" />
        <c:set var="includedQty" value="0" />
        <c:if test="${not isCustomRequest}">
            <c:forEach items="${packageItems}" var="pk">
                <c:if test="${pk.item.itemType.itemTypeName eq 'สังฆทาน'}">
                    <c:set var="includedName" value="${pk.item.itemName}" />
                    <c:set var="includedPrice" value="${pk.item.pricePerUnit}" />
                    <c:set var="includedQty" value="${pk.quantity}" />
                </c:if>
            </c:forEach>
        </c:if>

        <%-- สังฆทานอยู่ในแพ็กเกจทั้งหมด (ไม่ต้องคิดเงินเพิ่ม) = เลือกชุดเดียวกับที่รวมในแพ็กเกจ และจำนวนไม่เกินโควตา
             ถ้าไม่เข้าเงื่อนไข (เลือกชุดอื่น หรือสั่งเกินโควตา) จะแสดงในส่วน "รายการเพิ่มเติม" เพื่อคิดส่วนต่าง/ราคาเต็ม --%>
        <c:set var="sanghaFullyIncluded" value="${not isCustomRequest && not empty includedName && sanghaChoice eq includedName && sanghaQtyRaw <= includedQty}" />
        <c:set var="showSanghaSeparately" value="${isCustomRequest || (not empty sanghaChoice && not sanghaFullyIncluded)}" />
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
                            <%-- เปลี่ยนจาก b.pkg เป็น b.packageEntity --%>
                            <span class="info-value">${b.packageEntity.packageType}</span>
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
                            <%-- เปลี่ยนจาก b.pkg เป็น b.packageEntity --%>
                            <span class="info-value">${b.packageEntity.optionType}</span>
                        </div>
                    </div>
                    <%-- เปลี่ยนจาก b.pkg เป็น b.packageEntity --%>
                    <c:if test="${not isCustomRequest && not empty b.packageEntity.basePrice}">
                        <div class="col-12 mt-2 pt-2 border-top">
                            <div class="info-row mb-0">
                                <span class="info-label">ราคาเริ่มต้นแพ็กเกจ</span>
                                <span class="info-value price-text">
                                    <%-- เปลี่ยนจาก b.pkg เป็น b.packageEntity --%>
                                    ฿<fmt:formatNumber value="${b.packageEntity.basePrice}" pattern="#,###"/>
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
                        <c:otherwise>รายการในแพ็กเกจ :</c:otherwise>
                    </c:choose>
                </div>

                <c:choose>
                    <c:when test="${not empty packageItems}">
                        <div class="package-items-grid" id="packageItemsGrid">
                            <%-- แสดงชุดสังฆทานที่รวมในแพ็กเกจไว้เสมอ (ไม่ซ่อนแล้ว) เพราะราคาส่วนต่างของชุดที่อัปเกรดอ้างอิงจากชุดนี้ --%>
                            <c:forEach var="pi" items="${packageItems}">
                                <c:if test="${pi.item.itemType.itemTypeId != 5 && pi.item.itemType.itemTypeId != 6}">
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
                        <c:if test="${!isCustomRequest && not additionalHeadingPrinted && (d.question.questionsText eq 'รูปแบบการนิมนต์พระสงฆ์' or d.question.questionsText eq 'ต้องการชุดภัตตาหารปิ่นโตหรือไม่' or (isSanghaQuestion and showSanghaSeparately))}">
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

                        <c:set var="trimmedAnswer" value="${fn:trim(d.answer)}" />
                        <div class="info-row" data-qtext="${fn:trim(d.question.questionsText)}" data-answer="${trimmedAnswer}">
						    <span class="info-label" style="width: 300px;"><c:out value="${d.question.questionsText}" default="รายการ"/></span>
						    <span class="info-value">
						        <c:choose>
						            <c:when test="${empty trimmedAnswer}">-</c:when>
						            <c:otherwise>
						                <c:out value="${trimmedAnswer}"/>
						                <%-- ปิ่นโต: แสดงราคาต่อชุดตามเดิม
						                     สังฆทาน: ไม่ใส่ราคาตรงนี้ ให้ JavaScript (bookingDetail.js) เติมหมายเหตุตามกฎแพ็กเกจ (ส่วนต่าง/ราคาเต็ม) --%>
						                <c:if test="${d.question.questionsText eq 'เลือกชุดภัตตาหารปิ่นโต'}">
						                    <c:choose>
						                        <c:when test="${trimmedAnswer eq 'ปิ่นโตชุดประหยัด'}">(299 บาท)</c:when>
						                        <c:when test="${trimmedAnswer eq 'ปิ่นโตชุดมาตรฐาน'}">(399 บาท)</c:when>
						                        <c:when test="${trimmedAnswer eq 'ปิ่นโตชุดพรีเมียม'}">(499 บาท)</c:when>
						                        <c:when test="${trimmedAnswer eq 'ปิ่นโตชุดพิเศษ'}">(599 บาท)</c:when>
						                    </c:choose>
						                </c:if>
						            </c:otherwise>
						        </c:choose>
						    </span>
						</div>
                    </c:if>

                </c:forEach>
            </div>
        </c:if>

        <%-- สรุปค่าใช้จ่ายโดยประมาณ (ตัวเลขทั้งหมดคำนวณโดย bookingDetail.js) --%>
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
                            onclick="openApproveModal('${b.bookingId}', '${pageContext.request.contextPath}/manager/bookings/approve/${b.bookingId}')">
                            รับงานและเตรียมใบเสนอราคา
                        </button>
                        <button type="button" class="btn btn-reject"
                            onclick="openRejectModal('${b.bookingId}', '${pageContext.request.contextPath}/manager/bookings/reject/${b.bookingId}')">
                            ปฏิเสธงาน
                        </button>
                    </c:when>
                    <c:when test="${b.bookingStatus == 'Approved' || b.bookingStatus == 'Quoted'}">
                        <a href="${pageContext.request.contextPath}/manager/quotation/create/${b.bookingId}" class="btn btn-approve text-decoration-none">จัดการใบเสนอราคา</a>
                    </c:when>
                </c:choose>
            </div>
            <a href="${pageContext.request.contextPath}/manager/bookings" class="btn-back">← กลับรายการจอง</a>
        </div>
    </div>
</div>

<%-- Footer --%>
<footer class="site-footer">
    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับผู้จัดการ</p>
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
            <div class="reject-reason-group">
                <label for="rejectDetail" class="reject-reason-label">เหตุผลที่ปฏิเสธงาน<span class="required-mark">*</span></label>
                <textarea id="rejectDetail" name="rejectDetail" rows="3"
                          class="reject-reason-textarea"
                          required placeholder="โปรดระบุเหตุผลที่ปฏิเสธการจองนี้..."></textarea>
            </div>

            <p class="modal-footer-note" style="margin-top: 10px;">การปฏิเสธไม่สามารถย้อนกลับได้</p>
            <div class="modal-btn-group">
                <button type="button" class="btn-modal-cancel" onclick="closeRejectModal()">ยกเลิก</button>
                <button type="submit" class="btn-modal-reject">ยืนยันการปฏิเสธ</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<%-- ค่าที่ต้องส่งจาก server ให้ JS (ต้องอยู่ใน JSP เพราะใช้ EL) — ตรรกะคำนวณอยู่ใน bookingDetail.js --%>
<script>
    const contextPath = "${pageContext.request.contextPath}";

    window.BOOKING_DETAIL_CONFIG = {
        // ราคาจริงจากฐานข้อมูล (เติมด้านล่าง) จะเขียนทับราคาตั้งต้นใน JS
        priceMap: {},
        // ชุดสังฆทานที่รวมในแพ็กเกจ (qty = 0 หมายถึงไม่มี เช่นโหมดกรอกเอง)
        includedSangha: {
            price: ${includedPrice},
            qty: ${includedQty}
        },
        isCustomRequest: ${isCustomRequest},
        <%-- เปลี่ยนจาก b.pkg เป็น b.packageEntity --%>
        basePrice: "${b.packageEntity.basePrice}",
        optionType: "${fn:trim(b.packageEntity.optionType)}"
    };

    <c:forEach items="${pintoItems}" var="pItem">
    BOOKING_DETAIL_CONFIG.priceMap["${pItem.itemName}"] = ${pItem.pricePerUnit};
    </c:forEach>
    <c:forEach items="${sanghatharnItems}" var="sItem">
    BOOKING_DETAIL_CONFIG.priceMap["${sItem.itemName}"] = ${sItem.pricePerUnit};
    </c:forEach>
</script>

<script src="${pageContext.request.contextPath}/static/js/bookingDetail.js?v=2"></script>
</body>
</html>
