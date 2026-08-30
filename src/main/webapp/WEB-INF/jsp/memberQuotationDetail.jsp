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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberQuotationDetail.css?v=13">
    <style>
        /* ===== รายชื่อ "รายการเพิ่มเติม" แสดงในวงเล็บใต้ label ให้ตรงกับฝั่ง Organizer ===== */
        .tot-extra-detail {
            font-size: 12px;
            color: #888;
            font-weight: 400;
            font-style: italic;
            text-align: left;
            margin-top: 4px;
            line-height: 1.5;
        }
    </style>
</head>
<body>

<%-- ========== NAVBAR ========== --%>
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

        <a href="${pageContext.request.contextPath}/myBookings" class="nav-link-item">รายการจอง</a>

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
    <div class="flash-banner flash-banner-success no-print" id="ajaxConfirmBanner" style="display:none;">✓ ยืนยันข้อมูลใบเสนอราคาเรียบร้อยแล้ว</div>

    <div class="sheet">

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

        <%-- ===== หัวเอกสาร ===== --%>
        <div class="doc-header">
            <div class="company-info">
              <h2>บริษัท บุญมีนำพา จัดงานบุญ </h2>
						<p>รับจัดพิธีสงฆ์ นิมนต์พระ สังฆทาน และงานบุญครบวงจร</p>
						<p>โทร. 080-123-4567 | อีเมล: boonmee@gmail.com</p>
            </div>
            <div class="doc-title-box">
                <h1>ใบเสนอราคา</h1>
                <p>(Quotation)</p>
            </div>
        </div>

        <%-- ===== แถวข้อมูลเมตา ===== --%>
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
        <table class="items-table">
            <colgroup>
                <col style="width: 70px;">
                <col style="width: auto;">
                <col style="width: 70px;">
                <col style="width: 70px;">
                <col style="width: 100px;">
                <col style="width: 100px;">
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
                <c:set var="count" value="1"/>

                <%-- ===== 1. แสดงชื่อแพ็กเกจหลัก (พร้อมราคาและลำดับ) ===== --%>
                <c:if test="${!isCustomRequest}">
                    <tr class="static-row">
                        <td class="text-center row-number">1</td>
                        <td>
                            <strong>แพ็กเกจ: ${b.ceremony.ceremonyName}</strong>
                        </td>
                        <td class="text-center">1</td>
                        <td class="text-center">แพ็กเกจ</td>
                        <td class="text-right"><fmt:formatNumber value="${b.ceremony.basePrice}" minFractionDigits="2" /></td>
                        <td class="text-right"><fmt:formatNumber value="${b.ceremony.basePrice}" minFractionDigits="2" /></td>
                    </tr>
                </c:if>

                <%-- ===== 2. แสดงรายการประกอบ (Sub-items) ===== --%>
                <c:if test="${not empty packageIncludedItems}">
                    <tr class="package-included-row">
                        <td class="text-center"></td>
                        <td class="package-includes-title">ประกอบไปด้วยรายการดังนี้:</td>
                        <td class="text-center"></td><td class="text-center"></td><td class="text-right"></td><td class="text-right"></td>
                    </tr>
                    <c:forEach var="subItem" items="${packageIncludedItems}">
                        <c:set var="subItemQty" value="1"/>
                        <c:if test="${(not empty subItem.itemDetail && fn:contains(subItem.itemDetail,'ต่อรูป')) || fn:contains(subItem.itemName,'ต่อรูป') || fn:contains(subItem.itemName,'พระสงฆ์')}">
                            <c:set var="subItemQty" value="${not empty monkCount ? monkCount : 1}"/>
                        </c:if>
                        <tr class="package-included-row">
                            <td class="text-center"></td>
                            <td class="indented-item">- ${subItem.itemName}</td>
                            <td class="text-center">${subItemQty}</td>
                            <td class="text-center">${subItem.unit}</td>
                            <td class="text-right text-muted">-</td>
                            <td class="text-right text-muted">-</td>
                        </tr>
                    </c:forEach>
                </c:if>

                <%-- ===== หมวดอุปกรณ์พิธีกรรม ===== --%>
                <c:set var="equipBlock">
                    <c:set var="printedEquip" value="false"/>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์พิธีกรรม')}">
                            <c:if test="${!printedEquip}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดอุปกรณ์พิธีกรรม</td><td></td><td></td><td></td><td></td></tr>
                                <c:set var="printedEquip" value="true"/>
                            </c:if>
                            <tr>
                                <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>${d.item.itemName}</td>
                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
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
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดสังฆทาน</td><td></td><td></td><td></td><td></td></tr>
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
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดภัตตาหารปิ่นโต</td><td></td><td></td><td></td><td></td></tr>
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
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดบริการและการดำเนินการ</td><td></td><td></td><td></td><td></td></tr>
                                <c:set var="printedServ" value="true"/>
                            </c:if>
                            <%-- บริการประสานงานนิมนต์พระ: ถ้าลูกค้าเลือก "นิมนต์เอง" ให้ยังคงแสดงรายการนี้ไว้
                                 แต่บังคับราคาที่แสดงเป็น 0.00 พร้อมป้ายกำกับ (ตามที่จารย์ต้องการให้แสดงรายการนี้เสมอ) --%>
                            <c:set var="isFreeMonkService" value="${d.item.itemName == 'บริการประสานงานนิมนต์พระ' && isMonkSelfInvite}"/>
                            <tr>
                                <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    ${d.item.itemName}
                                    <c:if test="${isFreeMonkService}"><span class="text-danger" style="font-size:12px; font-weight:bold;"> (ฟรี / นิมนต์เอง)</span></c:if>
                                </td>
                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${isFreeMonkService ? 0.00 : d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                <td class="text-right"><fmt:formatNumber value="${isFreeMonkService ? 0.00 : d.subtotal}" minFractionDigits="2"/></td>
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
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดอุปกรณ์เสริม</td><td></td><td></td><td></td><td></td></tr>
                                <c:set var="printedExtra" value="true"/>
                            </c:if>
                            <tr>
                                <td class="text-center">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>${d.item.itemName}</td>
                                <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0"/></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2"/></c:if></td>
                                <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2"/></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <%-- ===== ลำดับการแสดงผล ===== --%>
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

        <div class="summary-flex-row">
            <c:if test="${q.quotationStatus != 'Confirmed'}">
                <div class="member-note-section no-print">
                    <label for="memberNoteInput">ความต้องการเพิ่มเติม:</label>
                    <textarea id="memberNoteInput" placeholder="ระบุความต้องการเพิ่มเติมที่นี่..."></textarea>
                </div>
            </c:if>

            <%-- ===== สรุปยอด (แก้ไขการคำนวณ) ===== --%>
            <div class="totals-wrap">
                <div class="totals-box">
                    <c:set var="sumExtra" value="0"/>
                    <c:set var="sumPackage" value="${isCustomRequest ? 0 : q.bookingForm.ceremony.basePrice}"/>
                    <c:set var="extraItemsList" value=""/>

                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null}">
                            <c:choose>
                                <%-- ข้ามชื่อแพ็กเกจ (กรณีโหมดแพ็กเกจ) --%>
                                <c:when test="${!isCustomRequest && d.item.itemName == packageName}">
                                </c:when>
                                <c:otherwise>
                                    <c:set var="itemVal" value="${d.subtotal}"/>
                                    <c:set var="isFreeInTotal" value="false"/>
                                    
                                    <%-- หักลบของแถม (สังฆทานฟรี) สำหรับแพ็กเกจ --%>
                                    <c:if test="${!isCustomRequest && d.item.itemType.itemTypeName.contains('สังฆทาน') && (d.item.pricePerUnit == 299.0 || d.item.pricePerUnit == 299)}">
                                        <c:set var="itemVal" value="0"/>
                                        <c:set var="isFreeInTotal" value="true"/>
                                    </c:if>

                                    <%-- หักบริการประสานงานนิมนต์พระ เมื่อลูกค้าเลือก "นิมนต์เอง"
                                         (ใช้ได้ทั้งโหมดกรอกเองและโหมดแพ็กเกจ) --%>
                                    <c:if test="${d.item.itemName == 'บริการประสานงานนิมนต์พระ' && isMonkSelfInvite}">
                                        <c:set var="itemVal" value="0"/>
                                        <c:set var="isFreeInTotal" value="true"/>
                                    </c:if>
                                    
                                    <%-- ===== ลอจิกแยกราคาตามโหมด ===== --%>
                                    <c:choose>
                                        <c:when test="${isCustomRequest}">
                                            <%-- ถ้าโหมดกรอกเอง ให้เฉพาะของในหมวด "อุปกรณ์เสริม" ไปเป็นราคาเพิ่มเติม นอกนั้นรวมในราคาตั้งต้น --%>
                                            <c:choose>
                                                <c:when test="${d.item.itemType.itemTypeName.contains('อุปกรณ์เสริม')}">
                                                    <c:set var="sumExtra" value="${sumExtra + itemVal}"/>
                                                    <c:set var="extraItemsList" value="${extraItemsList}${empty extraItemsList ? '' : ', '}${d.item.itemName}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="sumPackage" value="${sumPackage + itemVal}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- ถ้าโหมดแพ็กเกจ ทุกอย่างที่โผล่มา (และไม่ฟรี) คือราคาเพิ่มเติมทั้งหมด --%>
                                            <c:set var="sumExtra" value="${sumExtra + itemVal}"/>
                                            <c:if test="${!isFreeInTotal}">
                                                <c:set var="extraItemsList" value="${extraItemsList}${empty extraItemsList ? '' : ', '}${d.item.itemName}"/>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
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
                            <td class="tot-value">฿ <fmt:formatNumber value="${sumPackage}" minFractionDigits="2"/></td>
                        </tr>
                        
                        <%-- นำเงื่อนไขดักออก เพื่อให้ช่อง "รายการเพิ่มเติม" แสดงเสมอแม้เป็นงานกรอกเอง --%>
                        <tr>
                            <td class="tot-label">
                                รายการเพิ่มเติม:
                                <c:if test="${not empty extraItemsList}">
                                    <div class="tot-extra-detail">(${extraItemsList})</div>
                                </c:if>
                            </td>
                            <td class="tot-value">฿ <fmt:formatNumber value="${sumExtra}" minFractionDigits="2"/></td>
                        </tr>

                        <c:if test="${!isCustomRequest && isMonkSelfInvite}">
                            <tr>
                                <td class="tot-label">ส่วนลดนิมนต์เอง:</td>
                                <td class="tot-value text-danger">- ฿ 1,500.00</td>
                            </tr>
                        </c:if>
                        <tr class="grand-total-row">
                            <td class="tot-label">ยอดรวมสุทธิ:</td>
                            <td class="total-amount">
                                ฿ <fmt:formatNumber value="${sumPackage + sumExtra - (isMonkSelfInvite && !isCustomRequest ? 1500 : 0)}" minFractionDigits="2"/>
                            </td>
                        </tr>                    
                    </table>
                </div>
            </div>

        </div>

        <%-- ===== ปุ่มยืนยัน / แจ้งขอแก้ไข ===== --%>
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
    <input type="hidden" id="memberNoteHidden" name="memberNote" value="">
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
            <form id="confirmQuotationForm" action="${pageContext.request.contextPath}/member/quotation/confirm" method="post" style="margin:0;">
                <input type="hidden" name="quotationId" value="${q.quotationId}">
                <button type="submit" class="btn-confirm-final" style="background-color: #28a745; color: #ffffff;">ยืนยันอนุมัติ</button>
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
        const noteInput = document.getElementById('memberNoteInput');
        const note = noteInput ? noteInput.value.trim() : "";
        if (note === "") {
            alert('กรุณากรอกข้อความแจ้งขอแก้ไข');
            return;
        }
        document.getElementById('memberNoteHidden').value = note;
        document.getElementById('cleanSubmitForm').submit();
    }
    function showConfirmModal() { document.getElementById('confirmModal').style.display = 'flex'; }
    function closeConfirmModal() { document.getElementById('confirmModal').style.display = 'none'; }
    setTimeout(function() { const banner = document.getElementById('flashBanner'); if(banner) { banner.style.display = 'none'; } }, 5000);

    function showAjaxConfirmBanner() {
        const banner = document.getElementById('ajaxConfirmBanner');
        if (!banner) return;
        banner.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
        setTimeout(function () { banner.style.display = 'none'; }, 5000);
    }

    function lockQuotationAsConfirmed() {
        const statusPill = document.querySelector('.status-pill');
        if (statusPill) {
            statusPill.className = 'status-pill status-Confirmed';
            statusPill.innerText = '✓ ยืนยันรายการแล้ว';
        }

        const actionSection = document.querySelector('.action-section');
        if (actionSection) {
            actionSection.innerHTML = '';
            const lockMsg = document.createElement('div');
            lockMsg.className = 'lock-message';
            const title = document.createElement('div');
            title.className = 'lock-title';
            title.innerText = 'ขอบคุณสำหรับการยืนยันการจอง';
            const desc = document.createElement('p');
            desc.className = 'lock-desc';
            desc.innerText = 'ทางเราได้รับข้อมูลของท่านแล้ว และกำลังจัดเตรียมอุปกรณ์พร้อมเจ้าหน้าที่เพื่อให้บริการท่านอย่างดีที่สุด';
            lockMsg.appendChild(title);
            lockMsg.appendChild(desc);
            actionSection.appendChild(lockMsg);
        }

        const noteSection = document.querySelector('.member-note-section.no-print');
        if (noteSection) {
            const textarea = document.getElementById('memberNoteInput');
            const noteVal = textarea ? textarea.value.trim() : '';
            noteSection.classList.remove('no-print');
            noteSection.innerHTML = '';
            if (noteVal !== '') {
                const label = document.createElement('label');
                label.innerText = 'หมายเหตุ';
                const p = document.createElement('p');
                p.style.margin = '0';
                p.innerText = noteVal;
                noteSection.appendChild(label);
                noteSection.appendChild(p);
            } else {
                noteSection.remove();
            }
        }
    }

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

        var confirmForm = document.getElementById('confirmQuotationForm');
        if (confirmForm) {
            confirmForm.addEventListener('submit', function (e) {
                e.preventDefault();
                var submitBtn = confirmForm.querySelector('.btn-confirm-final');
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.innerText = 'กำลังยืนยัน...';
                }
                fetch(confirmForm.action, {
                    method: 'POST',
                    body: new FormData(confirmForm)
                }).then(function (res) {
                    if (res.ok) {
                        closeConfirmModal();
                        lockQuotationAsConfirmed();
                        showAjaxConfirmBanner();
                    } else {
                        alert('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง');
                        if (submitBtn) {
                            submitBtn.disabled = false;
                            submitBtn.innerText = 'ยืนยันรายการ';
                        }
                    }
                }).catch(function () {
                    alert('เชื่อมต่อไม่สำเร็จ กรุณาลองใหม่อีกครั้ง');
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.innerText = 'ยืนยันรายการ';
                    }
                });
            });
        }
    });
</script>
</body>
</html>
