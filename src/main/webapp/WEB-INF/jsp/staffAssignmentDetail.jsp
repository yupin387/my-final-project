<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ข้อมูลงาน - ${a.assignId}</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/assignmentDetail.css?v=6">
  
</head>
<body>

    <c:if test="${not empty success}"><span id="flash-success" data-msg="${success}" style="display:none;"></span></c:if>
    <c:if test="${not empty error}"><span id="flash-error" data-msg="${error}" style="display:none;"></span></c:if>

    <%-- ===== NAVBAR ===== --%>
    <nav class="navbar">
        <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/staff/assignments">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon">
            <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item active">งานที่ได้รับมอบหมาย</a>
                <a href="${pageContext.request.contextPath}/staff/items"       class="nav-item">จัดการรายการอุปกรณ์</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile"    class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <div id="flash-banner-container"></div>

    <div class="container">

        <c:set var="status" value="${a.jobStatus}"/>

        <%-- Top Actions --%>
        <div class="top-actions">
            <a href="${pageContext.request.contextPath}/staff/assignments" class="btn-back">← กลับหน้ารายการ</a>

            <c:choose>
                <c:when test="${status == 'Completed'}">
                    <c:choose>
                        <c:when test="${not empty a.reportNote}">
                            <span class="btn-damage-sent" title="ส่งรายงานความเสียหายไปแล้ว ไม่สามารถส่งซ้ำได้">
                                ✅ ส่งรายงานความเสียหายแล้ว
                            </span>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn-damage" onclick="openDamageModal()">⚠️ รายงานความเสียหาย</button>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <span class="btn-damage-disabled" title="ต้องอัปเดตสถานะงานเป็น เสร็จสิ้น ก่อน จึงจะรายงานความเสียหายได้">
                        ⚠️ รายงานความเสียหาย (ต้องจบงานก่อน)
                    </span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="card">
            <div class="card-header-bar">
                <span>รายละเอียดข้อมูลงาน</span>

                <%-- ปุ่มอัปเดตสถานะ: กดแล้วไปสถานะถัดไปทันที ไม่มี modal --%>
                <c:choose>
                    <c:when test="${status != 'Completed'}">
                       <form action="${pageContext.request.contextPath}/staff/assignments/update-status/save"
      method="post" style="margin:0;">
    <input type="hidden" name="bookingId" value="${a.bookingForm.bookingId}">
    <button type="submit" class="btn-status-next">
        <c:choose>
            <c:when test="${status == 'Assigned'}">➡️ เริ่มเตรียมงาน</c:when>
            <c:when test="${status == 'Preparing'}">➡️ เริ่มดำเนินการ</c:when>
            <c:when test="${status == 'In_Progress'}">✅ จบงาน (เสร็จสิ้น)</c:when>
        </c:choose>
    </button>
</form>
                    </c:when>
                    <c:otherwise>
                        <span class="status-done-badge">✅ งานเสร็จสิ้นแล้ว</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card-body">

                <%-- Progress Tracker --%>
                <div class="progress-container">
                    <div class="progress-step">
                        <div class="step-circle ${status == 'Assigned' || status == 'Preparing' || status == 'In_Progress' || status == 'Completed' ? 'done' : ''}">✓</div>
                        <span class="step-label">มอบหมาย</span>
                    </div>
                    <div class="progress-step">
                        <div class="step-circle ${status == 'Preparing' || status == 'In_Progress' || status == 'Completed' ? 'done' : ''}">✓</div>
                        <span class="step-label">เตรียมงาน</span>
                    </div>
                    <div class="progress-step">
                        <div class="step-circle ${status == 'In_Progress' || status == 'Completed' ? 'done' : ''}">✓</div>
                        <span class="step-label">ดำเนินการ</span>
                    </div>
                    <div class="progress-step">
                        <div class="step-circle ${status == 'Completed' ? 'done' : ''}">✓</div>
                        <span class="step-label">เสร็จสิ้น</span>
                    </div>
                </div>

                <%-- Assignment Info --%>
                <div class="section-heading">ข้อมูลการมอบหมาย</div>
                <div class="info-grid">
                    <div class="info-group">
                        <span class="label">รหัสมอบหมาย</span>
                        <span class="value">${a.assignId}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">วันที่ได้รับมอบหมาย</span>
                        <span class="value"><fmt:formatDate value="${a.assignDate}" pattern="dd/MM/yyyy"/></span>
                    </div>
                </div>

                <hr class="divider">

                <%-- Booking Info --%>
                <div class="section-heading">ข้อมูลการจองและลูกค้า</div>
                <div class="info-grid">
                    <div class="info-group">
                        <span class="label">รหัสการจอง</span>
                        <span class="value">${a.bookingForm.bookingId}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">ประเภทงาน</span>
                        <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                        <span class="value">${a.bookingForm.packageEntity.packageType}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">รูปแบบการจอง</span>
                        <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                        <span class="value" >${a.bookingForm.packageEntity.optionType}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">ลูกค้า</span>
                        <span class="value">${a.bookingForm.member.memberFirstName} ${a.bookingForm.member.memberLastName}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">เบอร์โทรศัพท์</span>
                        <span class="value">${a.bookingForm.member.phoneNumber}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">วันที่จัดงาน</span>
                        <span class="value">
                            <fmt:formatDate value="${a.bookingForm.eventDate}" pattern="dd/MM/yyyy"/>
                        </span>
                    </div>
                    <div class="info-group">
                        <span class="label">เวลาเริ่มงาน</span>
                        <span class="value">${a.bookingForm.eventTime} น.</span>
                    </div>
                </div>

                <hr class="divider">

                <div class="section-heading">สถานที่จัดงาน</div>
                <div class="address-box">${a.bookingForm.eventAddress}</div>

                <hr class="divider">

                <%-- ===== รายการที่ต้องเตรียม: ดึงรูปแบบมาจากใบเสนอราคาเป๊ะๆ ===== --%>
                <div class="section-heading">รายการที่ต้องเตรียม (จากใบเสนอราคา)</div>

                <c:choose>
                    <c:when test="${empty q}">
                        <p class="text-muted">ยังไม่มีใบเสนอราคาสำหรับงานนี้</p>
                    </c:when>
                    <c:otherwise>

                        <c:set var="monkCount" value="" />
                        <c:forEach var="d" items="${a.bookingForm.details}">
                            <c:if test="${fn:contains(d.question.questionsText,'จำนวนพระ')}">
                                <c:set var="monkCount" value="${d.answer}" />
                            </c:if>
                        </c:forEach>

                        <div class="quote-preview">
                            <table class="qp-table">
                                <colgroup>
                                    <col style="width: 50px;">
                                    <col style="width: auto;">
                                    <col style="width: 60px;">
                                    <col style="width: 60px;">
                                    <col style="width: 90px;">
                                    <col style="width: 90px;">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th class="text-center">ลำดับ</th>
                                        <th class="text-left">รายการ</th>
                                        <th class="text-center">จำนวน</th>
                                        <th class="text-center">หน่วย</th>
                                        <th class="text-right">ราคา/หน่วย</th>
                                        <th class="text-right">จำนวนเงิน</th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <c:if test="${!isCustomRequest}">
                                        <tr class="qp-package-row">
                                            <td class="text-center"></td>
                                            <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                                            <td><strong>แพ็กเกจ: ${a.bookingForm.packageEntity.optionType}</strong></td>
                                            <td class="text-center">1</td>
                                            <td class="text-center">แพ็กเกจ</td>
                                            <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                                            <td class="text-right"><fmt:formatNumber value="${a.bookingForm.packageEntity.basePrice}" minFractionDigits="2"/></td>
                                            <td class="text-right"><fmt:formatNumber value="${a.bookingForm.packageEntity.basePrice}" minFractionDigits="2"/></td>
                                        </tr>
                                    </c:if>

                                    <c:if test="${not empty packageIncludedItems && !isCustomRequest}">
                                        <tr class="qp-package-row">
                                            <td></td>
                                            <td class="qp-indented text-left">ประกอบไปด้วยรายการดังนี้:</td>
                                            <td></td><td></td><td></td><td></td>
                                        </tr>
                                        <c:forEach var="pkgItem" items="${packageIncludedItems}">
                                            <c:set var="pkgItemQty" value="1" />
                                            <c:if test="${(not empty pkgItem.itemDetail && fn:contains(pkgItem.itemDetail,'ต่อรูป')) || fn:contains(pkgItem.itemName,'ต่อรูป')}">
                                                <c:set var="pkgItemQty" value="${monkCount}" />
                                            </c:if>
                                            <tr class="qp-package-row">
                                                <td></td>
                                                <td class="qp-indented">- ${pkgItem.itemName}</td>
                                                <td class="text-center">${pkgItemQty}</td>
                                                <td class="text-center">${pkgItem.unit}</td>
                                                <td class="text-center text-muted">-</td>
                                                <td class="text-center text-muted">-</td>
                                            </tr>
                                        </c:forEach>
                                    </c:if>

                                    <%-- ---- หมวดอุปกรณ์พิธีกรรม ---- --%>
                                    <c:set var="printedEquip" value="false" />
                                    <c:forEach var="d" items="${details}">
                                        <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                                        <c:if test="${d.item != null && d.item.itemType != null && fn:trim(d.item.itemName) ne fn:trim(a.bookingForm.packageEntity.optionType) && d.item.itemType.itemTypeName.contains('อุปกรณ์พิธีกรรม')}">
                                            <c:if test="${!printedEquip}">
                                                <tr class="qp-group-row"><td colspan="6">หมวดอุปกรณ์พิธีกรรม</td></tr>
                                                <c:set var="printedEquip" value="true" />
                                            </c:if>
                                            <tr>
                                                <td class="text-center"></td>
                                                <td>${d.item.itemName}
                                                    <c:if test="${not empty d.item.itemDetail}">
                                                        <br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span>
                                                    </c:if>
                                                </td>
                                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                                <td class="text-center">${d.item.unit}</td>
                                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>

                                    <%-- ---- หมวดสังฆทาน ---- --%>
                                    <c:set var="printedSang" value="false" />
                                    <c:forEach var="d" items="${details}">
                                        <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                                        <c:if test="${d.item != null && d.item.itemType != null && fn:trim(d.item.itemName) ne fn:trim(a.bookingForm.packageEntity.optionType) && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                                            <c:if test="${!printedSang}">
                                                <tr class="qp-group-row"><td colspan="6">หมวดสังฆทาน</td></tr>
                                                <c:set var="printedSang" value="true" />
                                            </c:if>
                                            <c:set var="isFreeSang" value="${!isCustomRequest && d.quantity > 0 && d.subtotal == 0}" />
                                            <tr>
                                                <td class="text-center"></td>
                                                <td>${d.item.itemName}
                                                    <c:if test="${isFreeSang}"><span class="text-danger" style="font-size:12px;font-weight:bold;"> (ฟรี / รวมในแพ็กเกจ)</span></c:if>
                                                    <c:if test="${not empty d.item.itemDetail}">
                                                        <br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span>
                                                    </c:if>
                                                </td>
                                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                                <td class="text-center">${d.item.unit}</td>
                                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${isFreeSang ? 0.00 : d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                                <td class="text-right"><fmt:formatNumber value="${isFreeSang ? 0.00 : d.subtotal}" minFractionDigits="2"/></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>

                                    <%-- ---- หมวดภัตตาหารปิ่นโต ---- --%>
                                    <c:set var="printedFood" value="false" />
                                    <c:forEach var="d" items="${details}">
                                        <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                                        <c:if test="${d.item != null && d.item.itemType != null && fn:trim(d.item.itemName) ne fn:trim(a.bookingForm.packageEntity.optionType) && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                                            <c:if test="${!printedFood}">
                                                <tr class="qp-group-row"><td colspan="6">หมวดภัตตาหารปิ่นโต</td></tr>
                                                <c:set var="printedFood" value="true" />
                                            </c:if>
                                            <tr>
                                                <td class="text-center"></td>
                                                <td>${d.item.itemName}
                                                    <c:if test="${not empty d.item.itemDetail}">
                                                        <br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span>
                                                    </c:if>
                                                </td>
                                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                                <td class="text-center">${d.item.unit}</td>
                                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>

                                    <%-- ---- หมวดบริการและการดำเนินการ ---- --%>
                                    <c:set var="printedServ" value="false" />
                                    <c:forEach var="d" items="${details}">
                                        <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                                        <c:if test="${d.item != null && d.item.itemType != null && fn:trim(d.item.itemName) ne fn:trim(a.bookingForm.packageEntity.optionType) && d.item.itemType.itemTypeName.contains('บริการ')}">
                                            <c:if test="${!printedServ}">
                                                <tr class="qp-group-row"><td colspan="6">หมวดบริการและการดำเนินการ</td></tr>
                                                <c:set var="printedServ" value="true" />
                                            </c:if>
                                            <c:set var="isFreeMonkService" value="${d.item.itemName == 'บริการประสานงานนิมนต์พระ' && isMonkSelfInvite}" />
                                            <tr>
                                                <td class="text-center"></td>
                                                <td>${d.item.itemName}
                                                    <c:if test="${isFreeMonkService}"><span class="text-danger" style="font-size:12px;font-weight:bold;"> (ฟรี / นิมนต์เอง)</span></c:if>
                                                </td>
                                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                                <td class="text-center">${d.item.unit}</td>
                                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${isFreeMonkService ? 0.00 : d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                                <td class="text-right"><fmt:formatNumber value="${isFreeMonkService ? 0.00 : d.subtotal}" minFractionDigits="2"/></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>

                                    <%-- ---- หมวดอุปกรณ์เสริม ---- --%>
                                    <c:set var="printedExtra" value="false" />
                                    <c:forEach var="d" items="${details}">
                                        <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                                        <c:if test="${d.item != null && d.item.itemType != null && fn:trim(d.item.itemName) ne fn:trim(a.bookingForm.packageEntity.optionType) && d.item.itemType.itemTypeName.contains('อุปกรณ์เสริม')}">
                                            <c:if test="${!printedExtra}">
                                                <tr class="qp-group-row"><td colspan="6">หมวดอุปกรณ์เสริม</td></tr>
                                                <c:set var="printedExtra" value="true" />
                                            </c:if>
                                            <tr>
                                                <td class="text-center"></td>
                                                <td>${d.item.itemName}</td>
                                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                                <td class="text-center">${d.item.unit}</td>
                                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>

                                </tbody>
                            </table>

                            <%-- ===== กล่องสรุปยอด (คำนวณเหมือนหน้าใบเสนอราคาต้นฉบับ) ===== --%>
                            <c:set var="sumExtra" value="0" />
                            <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                            <c:set var="sumPackage" value="${isCustomRequest ? 0 : a.bookingForm.packageEntity.basePrice}" />
                            <c:set var="extraItemsList" value="" />

                            <c:forEach var="d" items="${details}">
                                <c:choose>
                                    <%-- แก้: bookingForm.pkg -> bookingForm.packageEntity --%>
                                    <c:when test="${!isCustomRequest && d.item != null && fn:trim(d.item.itemName) eq fn:trim(a.bookingForm.packageEntity.optionType)}">
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="itemVal" value="${d.subtotal}" />
                                        <c:set var="isFreeInTotal" value="false" />

                                        <c:if test="${!isCustomRequest && d.item != null && d.item.itemType != null && d.item.itemType.itemTypeName.contains('สังฆทาน') && d.subtotal == 0}">
                                            <c:set var="itemVal" value="0" />
                                            <c:set var="isFreeInTotal" value="true" />
                                        </c:if>

                                        <c:if test="${d.item != null && d.item.itemName == 'บริการประสานงานนิมนต์พระ' && isMonkSelfInvite}">
                                            <c:set var="itemVal" value="0" />
                                            <c:set var="isFreeInTotal" value="true" />
                                        </c:if>

                                        <c:choose>
                                            <c:when test="${isCustomRequest}">
                                                <c:choose>
                                                    <c:when test="${d.item != null && d.item.itemType != null && d.item.itemType.itemTypeName.contains('อุปกรณ์เสริม')}">
                                                        <c:set var="sumExtra" value="${sumExtra + itemVal}" />
                                                        <c:set var="extraItemsList" value="${extraItemsList}${empty extraItemsList ? '' : ', '}${d.item.itemName}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="sumPackage" value="${sumPackage + itemVal}" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="sumExtra" value="${sumExtra + itemVal}" />
                                                <c:if test="${d.item != null && !isFreeInTotal}">
                                                    <c:set var="extraItemsList" value="${extraItemsList}${empty extraItemsList ? '' : ', '}${d.item.itemName}" />
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:set var="calculatedGrandTotal" value="${sumPackage + sumExtra - (isMonkSelfInvite ? 1500 : 0)}" />

                            <div class="qp-totals-wrap">
                                <table class="qp-totals-table">
                                    <tr>
                                        <td class="qp-tot-label">
                                            <c:choose>
                                                <c:when test="${isCustomRequest}">ราคาตามรายการ:</c:when>
                                                <c:otherwise>ราคาแพ็กเกจ:</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="qp-tot-value">฿ <fmt:formatNumber value="${sumPackage}" minFractionDigits="2"/></td>
                                    </tr>
                                    <tr>
                                        <td class="qp-tot-label">
                                            รายการเพิ่มเติม:
                                            <c:if test="${not empty extraItemsList}">
                                                <div class="qp-extra-detail">(${extraItemsList})</div>
                                            </c:if>
                                        </td>
                                        <td class="qp-tot-value">฿ <fmt:formatNumber value="${sumExtra}" minFractionDigits="2"/></td>
                                    </tr>
                                    <c:if test="${!isCustomRequest && isMonkSelfInvite}">
                                        <tr>
                                            <td class="qp-tot-label">ส่วนลดนิมนต์เอง:</td>
                                            <td class="qp-tot-value text-danger">- ฿ 1,500.00</td>
                                        </tr>
                                    </c:if>
                                    <tr class="qp-grand-total">
                                        <td class="qp-tot-label">ยอดรวมสุทธิ:</td>
                                        <td class="qp-tot-value">฿ <fmt:formatNumber value="${calculatedGrandTotal}" minFractionDigits="2"/></td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>


<footer class="site-footer">

    <img src="${pageContext.request.contextPath}/static/images/lotus-corner.png"
         alt="" class="lotus-decoration" aria-hidden="true">

    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับหัวหน้างาน</p>
    </div>

</footer>

    <%-- Modal รายงานความเสียหาย (เหมือนเดิม) --%>
    <div class="modal-overlay" id="damageModal">
        <div class="modal-box">
            <div class="modal-header">
                <span class="modal-title">⚠️ รายงานความเสียหาย</span>
                <span class="modal-close" onclick="closeDamageModal()">&times;</span>
            </div>
            <form id="damageForm"
                  action="${pageContext.request.contextPath}/staff/assignments/report-damage/save"
                  method="post" enctype="multipart/form-data">
                <input type="hidden" name="assignId" value="${a.assignId}">
                <div class="form-group">
                    <label class="form-label">รายละเอียด <span class="required">*</span></label>
                    <textarea name="reportNote" rows="4" required placeholder="อธิบายความเสียหายที่พบ..."></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">แนบรูปภาพ</label>
                    <div class="upload-area" id="uploadArea" onclick="document.getElementById('fileInput').click()">
                        <input type="file" id="fileInput" name="damageImages" multiple accept=".jpg,.jpeg,.png"
                               style="display:none;" onchange="handleFileSelect(this)">
                        <div class="upload-placeholder" id="uploadPlaceholder">
                            <div class="upload-icon">📷</div>
                            <div class="upload-text">คลิกเลือกรูปภาพ</div>
                            <div class="upload-hint">รองรับ JPG, PNG</div>
                        </div>
                        <div class="upload-preview" id="uploadPreview"></div>
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel-modal" onclick="closeDamageModal()">ยกเลิก</button>
                    <button type="submit" class="btn-send">ส่งรายงาน</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/assignmentDetail.js"></script>


</body>
</html>