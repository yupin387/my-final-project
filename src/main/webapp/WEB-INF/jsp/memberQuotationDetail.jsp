<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ใบเสนอราคาของฉัน - #${q.quotationId}</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberQuotationDetail.css?v=7">
    <style>
        /* สไตล์หัวข้อหมวดหมู่ให้เหมือนหน้าแก้ไข/สร้างใบเสนอราคา */
        .items-table tr.group-row td.category-header-text {
            text-align: left !important;
            padding-left: 8px !important;
            white-space: nowrap;
            color: #9C6B3E;
            font-weight: bold;
        }
        .items-table tr.group-row td {
            background-color: #FBF2E3; /* สีพื้นหลังอ่อนๆ */
        }
    </style>
</head>
<body>

<%-- ========== NAVBAR (เหมือนหน้า Home ทุกสี/ขนาด) ========== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมี รับจัดงานบุญ" class="lotus-icon">
        <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
    </a>

    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item">หน้าหลัก</a>

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

        <div class="nav-dropdown-wrap">
            <a href="${pageContext.request.contextPath}/calendar" class="nav-link-item nav-dropdown-toggle">
                ปฏิทิน <span class="nav-caret">▾</span>
            </a>
            <div class="nav-dropdown-panel">
                <a href="${pageContext.request.contextPath}/calendar#calendarSection" class="nav-dropdown-link">ปฏิทิน (ฤกษ์ดี)</a>
                <a href="${pageContext.request.contextPath}/calendar#lannaCalendarSection" class="nav-dropdown-link">ปฏิทิน (ล้านนา)</a>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/latestBooking" class="nav-link-item">การจอง</a>
        <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-link-item active">ใบเสนอราคา</a>
        <a href="${pageContext.request.contextPath}/reviews" class="nav-link-item">รีวิว</a>
    </div>

    <div class="dropdown-wrap">
        <div class="user-profile-pill" id="userProfileToggle">
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
    <c:if test="${not empty success}"><div class="flash-banner flash-banner-success" id="flashBanner">✓ ${success}</div></c:if>
    <c:if test="${not empty error}"><div class="flash-banner flash-banner-error" id="flashBanner">⚠ ${error}</div></c:if>

    <div class="sheet">

        <%-- ตัวแปรร่วมของเอกสาร: คำนวณไว้ตั้งแต่ต้นเพื่อใช้ทั้งในส่วนข้อมูลเมตาและตารางรายการ --%>
        <c:set var="packageName" value="${q.bookingForm.ceremony.ceremonyName}"/>
        <c:set var="isCustomRequest" value="${q.bookingForm.ceremony.ceremonyName == 'กรอกความต้องการเบื้องต้น'}"/>
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
        <c:set var="isMonkSelfInvite" value="${fn:contains(monkInviteType,'นิมนต์เอง')}"/>

        <%-- ===== หัวเอกสาร (เหมือนใบเสนอราคาฝั่ง organizer) ===== --%>
        <div class="doc-header">
            <div class="company-info">
                <h2>บริษัท บุญมีนำพา จัดงานบุญ จำกัด</h2>
                <p>รับจัดพิธีสงฆ์ นิมนต์พระ สังฆทาน และงานบุญครบวงจร</p>
                <p>โทร. 080-123-4567 | อีเมล: contact@boonmeenumpa.com</p>
            </div>
            <div class="doc-title-box">
                <h1>ใบเสนอราคา</h1>
                <p>(Quotation)</p>
            </div>
        </div>

        <%-- ===== แถวข้อมูลเมตา: ข้อมูลลูกค้า / เลขที่-สถานะ ===== --%>
        <div class="doc-meta-row">
            <div class="meta-box-left">
                <table class="layout-table">
                    <tr>
                        <td class="label">ชื่อลูกค้า:</td>
                        <td class="value">คุณ ${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</td>
                    </tr>
                    <tr>
                        <td class="label">สถานที่จัดงาน:</td>
                        <td class="value">${q.bookingForm.eventAddress}</td>
                    </tr>
                    <tr>
                        <td class="label">วันที่จัดงาน:</td>
                        <td class="value"><fmt:formatDate value="${q.bookingForm.eventDate}" pattern="dd/MM/yyyy"/> เวลา ${q.bookingForm.eventTime} น.</td>
                    </tr>
                  <tr>
                            <td class="label">รูปแบบพิธี:</td>
                            <td class="value">${q.bookingForm.ceremony.ceremonyType}</td>
                        </tr>
                        <tr>
                            <td class="label">รูปแบบการจอง:</td>
                            <td class="value">
                                <c:choose>
                                    <c:when test="${isCustomRequest}">กรอกความต้องการเอง</c:when>
                                    <c:otherwise>${q.bookingForm.ceremony.ceremonyName}</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                </table>
            </div>
            <div class="meta-box-right">
                <table class="layout-table bordered">
                    <tr>
                        <td class="meta-label">เลขที่:</td>
                        <td class="meta-value">${q.quotationId}</td>
                    </tr>
                    <tr>
                        <td class="meta-label">วันที่:</td>
                        <td class="meta-value"><fmt:formatDate value="${q.quotationDate}" pattern="dd/MM/yyyy"/></td>
                    </tr>
                    <tr>
                        <td class="meta-label">สถานะ:</td>
                        <td class="meta-value">
                            <span class="status-pill status-${q.quotationStatus}">
                                <c:choose>
                                    <c:when test="${q.quotationStatus == 'Confirmed'}">✓ ยืนยันรายการแล้ว</c:when>
                                    <c:when test="${q.quotationStatus == 'Revised'}">↩ ต้องแก้ไข</c:when>
                                    <c:otherwise>● รอยืนยัน</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="meta-label">หัวหน้างาน:</td>
                        <td class="meta-value">
                            <c:choose>
                                <c:when test="${not empty q.staff}">คุณ ${q.staff.staffFirstName}</c:when>
                                <c:otherwise><span class="text-danger" style="font-weight:700;">รอมอบหมาย</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <%-- ===== ตารางรายการ ===== --%>
        <table class="items-table ${not isCustomRequest ? 'no-border-table' : ''}">
            <colgroup>
                <col style="width: 70px;">
                <col style="width: auto;">
                <col style="width: 70px;">
                <col style="width: 70px;">
                <col style="width: 100px;">
                <col style="width: 100px;">
                <col style="width: 230px;">
            </colgroup>
            <thead>
                <tr>
                    <th class="text-center">ลำดับ</th>
                    <th class="text-left">รายการ</th>
                    <th class="text-center">จำนวน</th>
                    <th class="text-center">หน่วย</th>
                    <th class="text-right">ราคา/หน่วย</th>
                    <th class="text-right">จำนวนเงิน</th>
                    <th class="text-left">หมายเหตุ / แจ้งขอแก้ไข</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="count" value="1"/>

                <%-- ===== หมวดแพ็กเกจหลัก (เรียงอยู่บนสุดเสมอ) ===== --%>
                <c:forEach var="d" items="${details}">
                    <c:if test="${d.item != null && d.item.itemName == packageName}">
                        <tr>
                            <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                            <td>
                                <span class="item-name">
                                    <c:choose>
                                        <c:when test="${isCustomRequest}">แพ็กเกจ: ${d.item.itemName}</c:when>
                                        <c:otherwise><strong>แพ็กเกจ: ${d.item.itemName}</strong></c:otherwise>
                                    </c:choose>
                                </span>
                                <c:if test="${isMonkSelfInvite}"><br><span class="text-muted">(ลูกค้านิมนต์เอง)</span></c:if>
                            </td>
                            <td class="text-center">1</td>
                            <td class="text-center">แพ็กเกจ</td>
                            <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                            <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${q.quotationStatus != 'Confirmed'}">
                                        <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                        <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องแพ็กเกจ (ถ้ามี)...">
                                    </c:when>
                                    <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                <%-- ตัดซับไอเทม (packageIncludedItems) ออกตามความต้องการ --%>


                <%-- ===== หมวดอุปกรณ์พิธีกรรม ===== --%>
                <c:set var="equipBlock">
                    <c:set var="printedEquip" value="false"/>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์พิธีกรรม')}">
                            <c:if test="${!printedEquip}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดอุปกรณ์พิธีกรรม</td><td></td><td></td><td></td><td></td><td></td></tr>
                                <c:set var="printedEquip" value="true"/>
                            </c:if>
                            <tr>
                                <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    ${d.item.itemName}
                                    <%-- ซ่อนรายละเอียดอุปกรณ์พิธีกรรม --%>
                                </td>
                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.quotationStatus != 'Confirmed'}">
                                            <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                            <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องอุปกรณ์ (ถ้ามี)...">
                                        </c:when>
                                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <%-- ===== หมวดสังฆทาน ===== --%>
                <c:set var="sangBlock">
                    <c:set var="printedSang" value="false"/>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                            <c:if test="${!printedSang}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดสังฆทาน</td><td></td><td></td><td></td><td></td><td></td></tr>
                                <c:set var="printedSang" value="true"/>
                            </c:if>
                            <tr>
                                <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    ${d.item.itemName}
                                    <c:set var="isFreeSang" value="${!isCustomRequest && (d.item.pricePerUnit == 299.0 || d.item.pricePerUnit == 299)}"/>
                                    <c:if test="${isFreeSang}"><span class="text-danger" style="font-size:12px; font-weight:bold;"> (ฟรี / รวมในแพ็กเกจ)</span></c:if>
                                    <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                </td>
                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${isFreeSang ? 0.00 : d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                <td class="text-right"><fmt:formatNumber value="${isFreeSang ? 0.00 : d.subtotal}" minFractionDigits="2"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.quotationStatus != 'Confirmed'}">
                                            <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                            <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องสังฆทาน (ถ้ามี)...">
                                        </c:when>
                                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <%-- ===== หมวดภัตตาหาร ===== --%>
                <c:set var="foodBlock">
                    <c:set var="printedFood" value="false"/>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                            <c:if test="${!printedFood}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดภัตตาหารปิ่นโต</td><td></td><td></td><td></td><td></td><td></td></tr>
                                <c:set var="printedFood" value="true"/>
                            </c:if>
                            <tr>
                                <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    ${d.item.itemName}
                                    <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                </td>
                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.quotationStatus != 'Confirmed'}">
                                            <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                            <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องอาหาร (ถ้ามี)...">
                                        </c:when>
                                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <%-- ===== หมวดบริการและการดำเนินการ ===== --%>
                <c:set var="servBlock">
                    <c:set var="printedServ" value="false"/>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('บริการ')}">
                            <c:if test="${!printedServ}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดบริการและการดำเนินการ</td><td></td><td></td><td></td><td></td><td></td></tr>
                                <c:set var="printedServ" value="true"/>
                            </c:if>
                            <tr>
                                <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    ${d.item.itemName}
                                    <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                </td>
                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.quotationStatus != 'Confirmed'}">
                                            <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                            <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์แจ้งขอแก้ไข (ถ้ามี)...">
                                        </c:when>
                                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <%-- ===== หมวดอุปกรณ์เสริม ===== --%>
                <c:set var="extraBlock">
                    <c:set var="printedExtra" value="false"/>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์เสริม')}">
                            <c:if test="${!printedExtra}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดอุปกรณ์เสริม</td><td></td><td></td><td></td><td></td><td></td></tr>
                                <c:set var="printedExtra" value="true"/>
                            </c:if>
                            <tr>
                                <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    ${d.item.itemName}
                                    <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                </td>
                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.quotationStatus != 'Confirmed'}">
                                            <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                            <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องอุปกรณ์เสริม (ถ้ามี)...">
                                        </c:when>
                                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <%-- ===== ลำดับการแสดงผล (ตามประเภทงาน) ===== --%>
                <c:choose>
                    <c:when test="${isCustomRequest}">
                        ${equipBlock}
                        ${sangBlock}
                        ${foodBlock}
                        ${servBlock}
                        ${extraBlock}
                    </c:when>
                    <c:otherwise>
                        ${sangBlock}
                        ${foodBlock}
                        ${servBlock}
                        ${equipBlock}
                        ${extraBlock}
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- ===== สรุปยอด: ราคาแพ็กเกจ / รายการเพิ่มเติม / ส่วนลดนิมนต์เอง / ยอดรวมสุทธิ ===== --%>
        <div class="totals-wrap">
            <div class="totals-box">
                <c:set var="sumExtra" value="0"/>
                <c:set var="sumPackage" value="0"/>
                <c:forEach var="d" items="${details}">
                    <c:if test="${d.item != null}">
                        <c:choose>
                            <c:when test="${d.item.itemName == packageName}">
                                <c:set var="sumPackage" value="${d.subtotal}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="itemVal" value="${d.subtotal}"/>
                                <c:if test="${!isCustomRequest && d.item.itemType.itemTypeName.contains('สังฆทาน') && (d.item.pricePerUnit == 299.0 || d.item.pricePerUnit == 299)}">
                                    <c:set var="itemVal" value="0"/>
                                </c:if>
                                <c:set var="sumExtra" value="${sumExtra + itemVal}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </c:forEach>

                <table class="totals-table">
                    <tr>
                        <td class="tot-label">
                            <c:choose>
                                <c:when test="${isCustomRequest}">ราคาตามรายการ:</c:when>
                                <c:otherwise>ราคาแพ็กเกจ:</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="tot-value">฿ <fmt:formatNumber value="${isCustomRequest ? (sumPackage + sumExtra) : sumPackage}" minFractionDigits="2"/></td>
                    </tr>
                    <c:if test="${!isCustomRequest}">
                        <tr>
                            <td class="tot-label">รายการเพิ่มเติม:</td>
                            <td class="tot-value">฿ <fmt:formatNumber value="${sumExtra}" minFractionDigits="2"/></td>
                        </tr>
                    </c:if>
                    <c:if test="${!isCustomRequest && isMonkSelfInvite}">
                        <tr>
                            <td class="tot-label">ส่วนลดนิมนต์เอง:</td>
                            <td class="tot-value text-danger">- ฿ 1,500.00</td>
                        </tr>
                    </c:if>
                    <tr class="grand-total-row">
                        <td class="tot-label">ยอดรวมสุทธิ:</td>
                        <td class="total-amount">฿ <fmt:formatNumber value="${q.totalAmount}" minFractionDigits="2"/></td>
                    </tr>
                </table>
            </div>
        </div>

        <%-- ===== ปุ่มยืนยัน / แจ้งขอแก้ไข (โซนของสมาชิก ไม่พิมพ์ออกกระดาษ) ===== --%>
        <div class="action-section no-print">
            <c:choose>
                <c:when test="${q.quotationStatus != 'Confirmed'}">
                    <div class="btn-flex-group">
                        <button type="button" class="btn-revise-submit" onclick="packAndSubmitReviseForm()">↩ ส่งข้อมูลแจ้งขอแก้ไขรายการ</button>
                        <button type="button" class="btn-confirm-custom" onclick="showConfirmModal()">✓ ยืนยันรายการจองนี้</button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="lock-message">
                        <div class="lock-title">ขอบคุณสำหรับการยืนยันการจอง</div>
                        <p class="lock-desc">ทางเราได้รับข้อมูลของท่านแล้ว และกำลังจัดเตรียมอุปกรณ์พร้อมเจ้าหน้าที่เพื่อให้บริการท่านอย่างดีที่สุด</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div style="text-align:center; margin-bottom:30px;" class="no-print">
        <a href="${pageContext.request.contextPath}/home" class="btn-back-bottom">← กลับสู่หน้าหลัก</a>
    </div>
</div>

<form id="cleanSubmitForm" action="${pageContext.request.contextPath}/member/quotation/revise-all" method="post" style="display:none;">
    <input type="hidden" name="quotationId" value="${q.quotationId}">
    <div id="hiddenFieldsContainer"></div>
</form>

<div id="confirmModal" class="custom-modal">
    <div class="modal-content">
        <div class="modal-header"><h3>ยืนยันการจอง</h3></div>
        <div class="modal-body">
            <p>ท่านต้องการยืนยันการจองตามใบเสนอราคานี้ใช่หรือไม่?</p>
            <p class="text-danger">* เมื่อยืนยันแล้ว ระบบจะเริ่มดำเนินการจัดเตรียมงานทันทีและจะไม่สามารถแก้ไขรายการได้</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-secondary" onclick="closeConfirmModal()">ยกเลิก</button>
            <form action="${pageContext.request.contextPath}/member/quotation/confirm" method="post" style="margin:0;">
                <input type="hidden" name="quotationId" value="${q.quotationId}">
                <button type="submit" class="btn-confirm-final">ยืนยันรายการ</button>
            </form>
        </div>
    </div>
</div>

<%-- ========== FOOTER ========== --%>
<footer class="site-footer no-print">
    <div class="footer-content footer-content-slim">
        <div class="footer-col footer-brand-col">
            <div class="footer-brand">
                <img src="${pageContext.request.contextPath}/static/images/logoo.png"
     alt="บุญมี รับจัดงานบุญ" class="lotus-icon">
                <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
            </div>
            <p class="footer-tagline">รับจัดงานบุญ ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
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

<script>
    function packAndSubmitReviseForm() {
        const rows = document.querySelectorAll('.items-table tbody tr');
        const container = document.getElementById('hiddenFieldsContainer');
        container.innerHTML = "";
        let hasData = false;
        rows.forEach(row => {
            const idInput = row.querySelector('.row-item-id');
            const noteInput = row.querySelector('.row-item-note');
            if (idInput && noteInput && noteInput.value.trim() !== "") {
                hasData = true;
                const idHidden = document.createElement('input'); idHidden.name = 'itemIds'; idHidden.value = idInput.value;
                const noteHidden = document.createElement('input'); noteHidden.name = 'memberNotes'; noteHidden.value = noteInput.value.trim();
                container.appendChild(idHidden); container.appendChild(noteHidden);
            }
        });
        if (!hasData) { alert('กรุณากรอกข้อความร้องขอแก้ไขอย่างน้อย 1 รายการ'); return; }
        document.getElementById('cleanSubmitForm').submit();
    }
    function showConfirmModal() { document.getElementById('confirmModal').style.display = 'flex'; }
    function closeConfirmModal() { document.getElementById('confirmModal').style.display = 'none'; }
    setTimeout(function() { const banner = document.getElementById('flashBanner'); if(banner) { banner.style.display = 'none'; } }, 5000);

    document.addEventListener('DOMContentLoaded', function () {
        var toggle = document.getElementById('userProfileToggle');
        var menu = document.getElementById('dropdownMenu');
        if (toggle && menu) {
            toggle.addEventListener('click', function (e) {
                e.stopPropagation();
                menu.classList.toggle('show');
            });
            document.addEventListener('click', function () {
                menu.classList.remove('show');
            });
        }
    });
</script>
</body>
</html>