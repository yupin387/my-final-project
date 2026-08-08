<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>

<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>แก้ไขใบเสนอราคา #${q.quotationId} - บุญมีนำพา จัดงานบุญ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/quotationCreate.css?v=7">
</head>
<body>

<%-- ===== NAVBAR ===== --%>
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon">
        <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"  class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item active">ใบเสนอราคา</a>
        </nav>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">A</div>
            <div class="user-detail">
                <span class="user-name">Admin Organizer</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <span class="arrow">▾</span>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</nav>



<div class="page-wrapper">

    <%-- Page Title --%>
    <div class="page-title-row">
        <div class="section-ornament">
            <div class="ornament-line"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-diamond"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-line right"></div>
        </div>
        <h1>แก้ไขใบเสนอราคา ${q.quotationId}</h1>
        <div class="gold-line"></div>
        <p>ปรับปรุงแก้ไขรายการวัสดุและคำนวณเงินใบเสนอราคาใหม่</p>
    </div>

    <%-- INFO CARD --%>
    <div class="info-card">
        <div class="info-grid">
            <div class="info-box">
                <span class="info-label">รหัสการจอง</span>
                <span class="info-value highlight">${q.bookingForm.bookingId}</span>
            </div>
            <div class="info-box">
                <span class="info-label">ประเภทพิธี</span>
                <span class="info-value">${q.bookingForm.ceremony.ceremonyType}</span>
            </div>
            <div class="info-box">
                <span class="info-label">รูปแบบการจอง</span>
                <span class="info-value">${q.bookingForm.ceremony.ceremonyName}</span>
            </div>
            <div class="info-box">
                <span class="info-label">ลูกค้า</span>
                <span class="info-value">${q.bookingForm.member.memberFirstName} ${q.bookingForm.member.memberLastName}</span>
            </div>
            <div class="info-box">
                <span class="info-label">วันที่จัดงาน</span>
                <span class="info-value"><fmt:formatDate value="${q.bookingForm.eventDate}" pattern="dd/MM/yyyy"/></span>
            </div>
            <div class="info-box">
                <span class="info-label">เวลา</span>
                <span class="info-value">${q.bookingForm.eventTime} น.</span>
            </div>
        </div>
    </div>

    <%-- FORM --%>
    <form id="quotationForm"
          action="${pageContext.request.contextPath}/organizer/quotation/update"
          method="post" onsubmit="return validateForm()">
        <input type="hidden" name="quotationId" value="${q.quotationId}">

        <c:set var="packageName" value="${q.bookingForm.ceremony.ceremonyName}"/>

        <c:set var="monkInviteType" value=""/>
        <c:set var="monkCount" value=""/>
        <c:forEach var="bd" items="${q.bookingForm.details}">
            <c:if test="${fn:contains(bd.question.questionsText,'รูปแบบการนิมนต์')}">
                <c:set var="monkInviteType" value="${bd.answer}"/>
            </c:if>
            <c:if test="${fn:contains(bd.question.questionsText,'จำนวนพระ')}">
                <c:set var="monkCount" value="${bd.answer}"/>
            </c:if>
        </c:forEach>

        <c:set var="monkSelfInviteDiscount" value="${1500}"/>
        <c:set var="isMonkSelfInvite" value="${fn:contains(monkInviteType,'นิมนต์เอง')}"/>
        <c:choose>
            <c:when test="${!isCustomRequest && isMonkSelfInvite}">
                <c:set var="packageDisplayPrice" value="${q.bookingForm.ceremony.basePrice - monkSelfInviteDiscount}"/>
            </c:when>
            <c:otherwise>
                <c:set var="packageDisplayPrice" value="${q.bookingForm.ceremony.basePrice}"/>
            </c:otherwise>
        </c:choose>

        <%-- ===================================================================
             เช็คก่อนล่วงหน้าว่าแต่ละหมวดมีรายการอยู่จริงไหม (ไว้ใช้ตัดสินใจว่าจะ
             แสดงหัวข้อ group-row ของหมวดนั้นหรือไม่)
             หมายเหตุ: hasEquipmentItems นับเฉพาะอุปกรณ์ที่ผู้จัดงานเพิ่มเข้ามาเอง
             (อยู่ใน details จริง) ไม่รวมอุปกรณ์ที่ "รวมในแพ็กเกจ" ซึ่งย้ายไปแสดง
             ต่อจากแถวแพ็กเกจใน group-package แล้ว
             =================================================================== --%>
        <c:set var="hasEquipmentItems" value="false"/>
        <c:set var="hasFoodItems" value="false"/>
        <c:set var="hasSangkathanItems" value="false"/>
        <c:set var="hasServiceItems" value="false"/>
        <c:set var="monkInviteServiceFound" value="false"/>
        <c:forEach var="d" items="${details}">
            <c:if test="${d.item != null && d.item.itemName != packageName}">
                <c:if test="${d.item.itemType.itemTypeName.contains('อุปกรณ์')}">
                    <c:set var="hasEquipmentItems" value="true"/>
                </c:if>
                <c:if test="${d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                    <c:set var="hasFoodItems" value="true"/>
                </c:if>
                <c:if test="${d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                    <c:set var="hasSangkathanItems" value="true"/>
                </c:if>
                <c:if test="${d.item.itemType.itemTypeName.contains('บริการ')}">
                    <c:set var="hasServiceItems" value="true"/>
                    <c:if test="${fn:trim(d.item.itemName) eq 'บริการประสานงานนิมนต์พระ'}">
                        <c:set var="monkInviteServiceFound" value="true"/>
                    </c:if>
                </c:if>
            </c:if>
        </c:forEach>
        <c:set var="willShowServiceFallback"
               value="${isCustomRequest && !monkInviteServiceFound && !isMonkSelfInvite && not empty monkCount}"/>

        <%-- อุปกรณ์ที่รวมอยู่ในแพ็กเกจ (แสดงเฉพาะกรณีแพ็กเกจจริง) — ดูหมายเหตุเรื่องคีย์เวิร์ด
             "ต่อรูป" ในไฟล์ quotationCreate.jsp ประกอบ ใช้ตรรกะเดียวกัน --%>
        <c:set var="hasPackageEquip" value="${!isCustomRequest && not empty packageIncludedItems}"/>

        <div class="main-layout">
            <div class="card">
                <div class="card-header">แก้ไขรายการประมาณการวัสดุและงานดำเนินการ</div>
                <div class="card-body">

                    <table id="mainQuotationTable">
                        <colgroup>
                            <col class="col-no"><col class="col-item"><col class="col-qty">
                            <col class="col-unit"><col class="col-price"><col class="col-total">
                            <col class="col-note"><col class="col-del">
                        </colgroup>
                        <thead>
                            <tr>
                                <th style="text-align:center;">ลำดับ</th>
                                <th>รายการ</th>
                                <th style="text-align:center;">จำนวน</th>
                                <th style="text-align:center;">หน่วย</th>
                                <th style="text-align:right;">ราคา/หน่วย</th>
                                <th style="text-align:right;">รวมเงิน (฿)</th>
                                <th>หมายเหตุ</th>
                                <th style="text-align:center;">ลบ</th>
                            </tr>
                        </thead>

                        <%-- หมวดแพ็กเกจหลัก / รูปแบบการจอง (แถวราคาแพ็กเกจ ล็อกจำนวน = 1 เสมอ)
                             อุปกรณ์ที่ "รวมในแพ็กเกจ" แสดงต่อจากแถวแพ็กเกจในหมวดนี้เลย
                             ไม่แยกเป็นหมวด "อุปกรณ์พิธีกรรม" อีกต่อไปเมื่อเลือกแพ็กเกจ --%>
                        <tbody id="group-package">
                            <tr class="group-row">
                                <td colspan="8">
                                    <c:choose>
                                        <c:when test="${isCustomRequest}">
                                            รูปแบบการจอง: ${q.bookingForm.ceremony.ceremonyType} (กรอกความต้องการเบื้องต้น
                                            — ไม่มีแพ็กเกจตายตัว รายการทั้งหมดอยู่ในหมวดต่าง ๆ ด้านล่าง)
                                        </c:when>
                                        <c:otherwise>
                                            แพ็กเกจ: ${q.bookingForm.ceremony.ceremonyType} (${packageName})
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <c:choose>
                                <c:when test="${!isCustomRequest}">
                                    <c:set var="packageDetailFound" value="false"/>
                                    <c:forEach var="d" items="${details}">
                                        <c:if test="${d.item != null && d.item.itemName == packageName}">
                                            <c:set var="packageDetailFound" value="true"/>
                                            <tr class="static-row no-qty-convert" data-item-id="${d.item.itemId}">
                                                <td class="row-number" style="text-align:center;">1</td>
                                                <td>
                                                    <span class="item-name">${d.item.itemName}</span>
                                                    <c:if test="${not empty d.item.itemDetail}">
                                                        <span class="item-desc">${d.item.itemDetail}</span>
                                                    </c:if>
                                                    <c:if test="${not empty monkCount}">
                                                        <span class="item-desc" style="display:block;margin-top:4px;">
                                                            นิมนต์พระสงฆ์ ${monkCount} รูป
                                                            <c:if test="${isMonkSelfInvite}">
                                                                <span style="color:#c0392b;font-weight:600;"> (ลูกค้านิมนต์เอง)</span>
                                                            </c:if>
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${isMonkSelfInvite}">
                                                        <span class="item-desc" style="color:#c0392b;display:block;margin-top:4px;">
                                                            * ราคานี้หักส่วนลด <fmt:formatNumber value="${monkSelfInviteDiscount}" minFractionDigits="0"/> บาท
                                                            เนื่องจากลูกค้านิมนต์พระสงฆ์เอง
                                                        </span>
                                                    </c:if>
                                                    <%-- อุปกรณ์ที่รวมในแพ็กเกจแสดงเป็นแถวจริงต่อจากแถวนี้
                                                         ด้านล่างเลย (ดู packageIncludedItems loop) ไม่ต้อง
                                                         list bullet ซ้ำตรงนี้ --%>
                                                    <input type="hidden" name="bookingItemNames" value="${d.item.itemName}">
                                                </td>
                                                <td>
                                                  <input type="number" name="bookingQtys" value="1" min="1"
       class="qty-input" readonly style="text-align: center; background: #f4f4f4;">
                                                </td>
                                                <td style="text-align:center;">${d.item.unit}</td>
                                                <td>
                                                    <input type="number" name="bookingPrices" value="${packageDisplayPrice}"
                                                           step="0.01" min="0" class="price-input" style="text-align:right;"
                                                           onchange="calculateGrandTotal()">
                                                </td>
                                                <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
                                                <td><input type="text" name="detailNotes" value="${d.note}" class="note-input" placeholder="หมายเหตุ"></td>
                                                <td style="text-align:center;">-</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${!packageDetailFound}">
                                        <tr class="static-row no-qty-convert">
                                            <td class="row-number" style="text-align:center;">1</td>
                                            <td>
                                                <span class="item-name">${packageName}</span>
                                                <span class="item-desc">${q.bookingForm.ceremony.ceremonyDetail}</span>
                                                <c:if test="${not empty monkCount}">
                                                    <span class="item-desc" style="display:block;margin-top:4px;">
                                                        นิมนต์พระสงฆ์ ${monkCount} รูป
                                                        <c:if test="${isMonkSelfInvite}">
                                                            <span style="color:#c0392b;font-weight:600;"> (ลูกค้านิมนต์เอง)</span>
                                                        </c:if>
                                                    </span>
                                                </c:if>
                                                <c:if test="${isMonkSelfInvite}">
                                                    <span class="item-desc" style="color:#c0392b;display:block;margin-top:4px;">
                                                        * ราคานี้หักส่วนลด <fmt:formatNumber value="${monkSelfInviteDiscount}" minFractionDigits="0"/> บาท
                                                        เนื่องจากลูกค้านิมนต์พระสงฆ์เอง
                                                    </span>
                                                </c:if>
                                                <input type="hidden" name="bookingItemNames" value="${packageName}">
                                            </td>
                                            <td>
                                                <input type="number" name="bookingQtys" value="1" min="1"
                                                       class="qty-input" readonly disabled style="text-align:center; background:#f4f4f4;">
                                            </td>
                                            <td style="text-align:center;">แพ็กเกจ</td>
                                            <td>
                                                <input type="number" name="bookingPrices" value="${packageDisplayPrice}"
                                                       step="0.01" min="0" class="price-input" style="text-align:right;"
                                                       onchange="calculateGrandTotal()">
                                            </td>
                                            <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
                                            <td><input type="text" name="detailNotes" class="note-input" placeholder="หมายเหตุ"></td>
                                            <td style="text-align:center;">-</td>
                                        </tr>
                                    </c:if>

                                    <%-- ✅ อุปกรณ์ที่รวมในแพ็กเกจ ย้ายมาอยู่ต่อจากแถวแพ็กเกจตรงนี้เลย
                                         (แสดงไม่ว่าจะเจอ packageDetailFound หรือไม่ก็ตาม) --%>
                                    <c:if test="${hasPackageEquip}">
                                        <c:forEach var="pkgItem" items="${packageIncludedItems}">
                                            <c:set var="pkgItemQty" value="1"/>
                                            <c:if test="${(not empty pkgItem.itemDetail && fn:contains(pkgItem.itemDetail,'ต่อรูป')) || fn:contains(pkgItem.itemName,'ต่อรูป')}">
                                                <c:set var="pkgItemQty" value="${monkCount}"/>
                                            </c:if>
                                            <tr class="static-row no-qty-convert package-included-row">
                                                <td class="row-number no-index" style="text-align:center;"></td>
                                                <td>
                                                    <span class="item-name">${pkgItem.itemName}</span>
                                                    <c:if test="${not empty pkgItem.itemDetail}">
                                                        <span class="item-desc">${pkgItem.itemDetail}</span>
                                                    </c:if>
                                                </td>
                                                <td><input type="number" value="${pkgItemQty}" class="qty-input" readonly disabled style="text-align:center;"></td>
                                                <td style="text-align:center;">${pkgItem.unit}</td>
                                                <td style="text-align:center;"><span class="package-included-label">รวมในแพ็กเกจ</span></td>
                                                <td style="text-align:right;">-</td>
                                                <td><span class="item-desc">-</span></td>
                                                <td style="text-align:center;">-</td>
                                            </tr>
                                        </c:forEach>
                                    </c:if>
                                </c:when>

                                <c:otherwise>
                                    <tr class="static-row no-qty-convert">
                                        <td class="row-number no-index" style="text-align:center;"></td>
                                        <td colspan="7">
                                            <span class="item-name">${packageName}</span>
                                            <c:if test="${not empty q.bookingForm.ceremony.ceremonyDetail}">
                                                <span class="item-desc">${q.bookingForm.ceremony.ceremonyDetail}</span>
                                            </c:if>
                                            <c:if test="${not empty monkCount}">
                                                <span class="item-desc" style="display:block;margin-top:4px;">
                                                    นิมนต์พระสงฆ์ ${monkCount} รูป
                                                    <c:if test="${isMonkSelfInvite}">
                                                        <span style="color:#c0392b;font-weight:600;"> (ลูกค้านิมนต์เอง)</span>
                                                    </c:if>
                                                </span>
                                            </c:if>
                                            <div class="item-desc" style="margin-top:6px; color:#c0392b;">
                                                * งานนี้ไม่มีแพ็กเกจตายตัว รายการวัสดุ/บริการทั้งหมดที่เลือกไว้
                                                แสดงอยู่ในหมวดต่าง ๆ ด้านล่าง กดปุ่ม "เลือกรายการวัสดุอุปกรณ์เสริมเพิ่มเติม"
                                                เพื่อเพิ่ม/แก้ไขรายการได้
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>

                        <%-- หมวดอุปกรณ์พิธีกรรม (เสริม)
                             ตอนนี้ใช้เก็บเฉพาะอุปกรณ์ที่ผู้จัดงานเพิ่มเองผ่านป๊อปอัพเท่านั้น
                             (อุปกรณ์ที่รวมในแพ็กเกจย้ายไปแสดงใน group-package ด้านบนแล้ว จึงไม่มี
                             .package-included-row เหลืออยู่ในหมวดนี้อีก) --%>
                        <tbody id="group-equipment">
                            <c:if test="${hasEquipmentItems}">
                                <tr class="group-row"><td colspan="8">หมวดอุปกรณ์พิธีกรรมเสริม</td></tr>
                            </c:if>

                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์')}">
                                    <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <span class="item-desc">${d.item.itemDetail}</span>
                                            </c:if>
                                            <input type="hidden" name="extraItemIds" value="${d.item.itemId}">
                                        </td>
                                        <td>
                                            <input type="number" name="extraQtys" value="${d.quantity}" min="1"
                                                   class="qty-input" style="text-align:center;" onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:center;">${d.item.unit}</td>
                                        <td>
                                            <input type="number" name="extraPrices" value="${d.item.pricePerUnit}"
                                                   step="0.01" min="0" class="price-input" style="text-align:right;"
                                                   onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
                                        <td><input type="text" name="detailNotes" value="${d.note}" class="note-input" placeholder="หมายเหตุ"></td>
                                        <td style="text-align:center;">
                                            <button type="button" class="btn-remove" onclick="removeRow(this)">✕</button>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </tbody>

                        <%-- หมวดภัตตาหารปิ่นโต (ไม่แตะ) --%>
                        <tbody id="group-food">
                            <c:if test="${hasFoodItems}">
                                <tr class="group-row"><td colspan="8">หมวดภัตตาหารปิ่นโต</td></tr>
                            </c:if>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                                    <tr class="static-row" data-item-id="${d.item.itemId}">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <span class="item-desc">${d.item.itemDetail}</span>
                                            </c:if>
                                            <input type="hidden" name="bookingItemNames" value="${d.item.itemName}">
                                        </td>
                                        <td>
                                            <input type="number" name="bookingQtys" value="${d.quantity}" min="1"
                                                   class="qty-input" style="text-align:center;" onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:center;">${d.item.unit}</td>
                                        <td>
                                            <input type="number" name="bookingPrices" value="${d.item.pricePerUnit}"
                                                   step="0.01" min="0" class="price-input" style="text-align:right;"
                                                   onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
                                        <td><input type="text" name="detailNotes" value="${d.note}" class="note-input" placeholder="หมายเหตุ"></td>
                                        <td style="text-align:center;">
                                            <button type="button" class="btn-remove" onclick="removeRow(this)">✕</button>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </tbody>

                        <%-- หมวดสังฆทาน (ไม่แตะ) --%>
                        <tbody id="group-sangkathan">
                            <c:if test="${hasSangkathanItems}">
                                <tr class="group-row"><td colspan="8">หมวดสังฆทาน</td></tr>
                            </c:if>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                                    <tr class="static-row" data-item-id="${d.item.itemId}">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <span class="item-desc">${d.item.itemDetail}</span>
                                            </c:if>
                                            <input type="hidden" name="bookingItemNames" value="${d.item.itemName}">
                                        </td>
                                        <td>
                                            <input type="number" name="bookingQtys" value="${d.quantity}" min="1"
                                                   class="qty-input" style="text-align:center;" onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:center;">${d.item.unit}</td>
                                        <td>
                                            <input type="number" name="bookingPrices" value="${d.item.pricePerUnit}"
                                                   step="0.01" min="0" class="price-input" style="text-align:right;"
                                                   onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
                                        <td><input type="text" name="detailNotes" value="${d.note}" class="note-input" placeholder="หมายเหตุ"></td>
                                        <td style="text-align:center;">
                                            <button type="button" class="btn-remove" onclick="removeRow(this)">✕</button>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </tbody>

                        <%-- หมวดบริการและการดำเนินการ (รวมบริการนิมนต์พระ) --%>
                        <tbody id="group-service">
                            <c:if test="${hasServiceItems || willShowServiceFallback}">
                                <tr class="group-row"><td colspan="8">หมวดบริการและการดำเนินการเสริม</td></tr>
                            </c:if>

                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('บริการ')}">
                                    <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <span class="item-desc">${d.item.itemDetail}</span>
                                            </c:if>
                                            <input type="hidden" name="extraItemIds" value="${d.item.itemId}">
                                        </td>
                                        <td>
                                            <input type="number" name="extraQtys" value="${d.quantity}" min="1"
                                                   class="qty-input" style="text-align:center;" onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:center;">${d.item.unit}</td>
                                        <td>
                                            <input type="number" name="extraPrices" value="${d.item.pricePerUnit}"
                                                   step="0.01" min="0" class="price-input" style="text-align:right;"
                                                   onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
                                        <td><input type="text" name="detailNotes" value="${d.note}" class="note-input" placeholder="หมายเหตุ"></td>
                                        <td style="text-align:center;">
                                            <button type="button" class="btn-remove" onclick="removeRow(this)">✕</button>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>

                            <c:if test="${willShowServiceFallback}">
                                <c:forEach var="item" items="${items}">
                                    <c:if test="${fn:trim(item.itemName) eq 'บริการประสานงานนิมนต์พระ'}">
                                        <tr class="dynamic-row" data-item-id="${item.itemId}">
                                            <td class="row-number" style="text-align:center;"></td>
                                            <td>
                                                <span class="item-name">${item.itemName}</span>
                                                <c:if test="${not empty item.itemDetail}">
                                                    <span class="item-desc">${item.itemDetail}</span>
                                                </c:if>
                                                <input type="hidden" name="extraItemIds" value="${item.itemId}">
                                            </td>
                                            <td>
                                                <input type="number" name="extraQtys" value="${monkCount}" min="1"
                                                       class="qty-input" style="text-align:center;" onchange="calculateGrandTotal()">
                                            </td>
                                            <td style="text-align:center;">${item.unit}</td>
                                            <td>
                                                <input type="number" name="extraPrices" value="${item.pricePerUnit}"
                                                       step="0.01" min="0" class="price-input" style="text-align:right;"
                                                       onchange="calculateGrandTotal()">
                                            </td>
                                            <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
                                            <td><input type="text" name="detailNotes" class="note-input" placeholder="หมายเหตุ"></td>
                                            <td style="text-align:center;">
                                                <button type="button" class="btn-remove" onclick="removeRow(this)">✕</button>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </tbody>
                    </table>

                    <button type="button" class="btn-open-popup" onclick="openItemModal()">
                        <span>＋</span> เลือกรายการวัสดุอุปกรณ์เสริมเพิ่มเติม
                    </button>

                </div>
            </div>
        </div>
    </form>
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

<%-- STICKY TOTAL BAR --%>
<div class="total-bar">
    <div class="total-bar-inner">
        <div class="total-bar-meta">
            <span class="total-bar-label">ยอดรวมสุทธิทั้งสิ้น</span>
            <span class="total-bar-sub">* คำนวณเฉพาะรายการที่เลือก</span>
        </div>
        <div class="total-bar-amount">฿ <span id="grandTotal">0.00</span></div>
        <button type="submit" form="quotationForm" class="btn-submit">บันทึกการแก้ไข</button>
    </div>
</div>

<%-- ITEM DATA STORE: ใช้ extraSelectableItems (ไม่รวมของที่ผูกกับทุกแพ็กเกจอยู่แล้ว) ให้ตรงกับหน้า create --%>
<div id="itemDataStore" style="display:none;">
    <c:forEach var="item" items="${extraSelectableItems}">
        <div class="item-data"
             data-id="${item.itemId}"
             data-name="${item.itemName}"
             data-detail="${item.itemDetail}"
             data-unit="${item.unit}"
             data-price="${item.pricePerUnit}"
             data-type="${item.itemType.itemTypeName}"></div>
    </c:forEach>
</div>


<%-- ITEM SELECTION MODAL --%>
<div id="itemSelectionModal" class="modal-overlay">
    <div class="modal-card">
        <div class="modal-header">
            <h3> เลือกอุปกรณ์และบริการเสริมสำหรับจัดงานบุญ</h3>
            <button type="button" class="close-btn" onclick="closeItemModal()">✕</button>
        </div>
        <div class="category-tabs">
            <button type="button" class="category-tab active" data-category="all"      onclick="switchCategoryTab(this,'all')">ทั้งหมด</button>
            <button type="button" class="category-tab"        data-category="อุปกรณ์"  onclick="switchCategoryTab(this,'อุปกรณ์')">อุปกรณ์พิธีกรรม</button>
            <button type="button" class="category-tab"        data-category="ภัตตาหาร" onclick="switchCategoryTab(this,'ภัตตาหาร')">ภัตตาหารปิ่นโต</button>
            <button type="button" class="category-tab"        data-category="สังฆทาน"  onclick="switchCategoryTab(this,'สังฆทาน')">สังฆทาน</button>
            <button type="button" class="category-tab"        data-category="บริการ"   onclick="switchCategoryTab(this,'บริการ')">บริการและดำเนินการ</button>
        </div>
        <div class="modal-body">
            <div class="picker-toolbar">
                <label class="select-all-label">
                    <input type="checkbox" id="selectAllVisible" onchange="toggleSelectAllVisible(this)">
                    เลือกทั้งหมดทุกหมวด
                </label>
                <span class="selected-count-badge">เลือกแล้ว <span id="selectedCount">0</span> รายการ</span>
            </div>
            <div class="item-picker-grid" id="itemPickerGrid"></div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-cancel-modal" onclick="closeItemModal()">ยกเลิก</button>
            <button type="button" class="btn-submit-modal" onclick="addSelectedItemsToTable()">ตกลงเพิ่มรายการที่เลือก</button>
        </div>
    </div>
</div>


<script src="${pageContext.request.contextPath}/static/js/quotationEdit.js"></script>

</body>
</html>
