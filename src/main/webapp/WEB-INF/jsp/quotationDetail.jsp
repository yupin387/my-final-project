<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ใบเสนอราคา #${q.quotationId} - บุญมีนำพา จัดงานบุญ</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/quotationDetail.css?v=1">
<style>
    .standard-table tr.group-row td.category-header-text {
        text-align: left !important;
        padding-left: 8px !important;
        white-space: nowrap;
        color: var(--brand-green-dark);
        font-weight: bold;
    }
    .standard-table tr.group-row td {
        background-color: var(--green-glow);
    }

    .flash-banner {
        padding: 12px 20px;
        margin: 0 auto 20px;
        max-width: 800px;
        border-radius: 6px;
        text-align: center;
        font-weight: 600;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    .flash-banner-success {
        background-color: #DBEAFE;
        color: #1D4ED8;
        border: 1px solid #93C5FD;
    }
    
    .flash-banner-error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .remarks-box {
        flex: 1;
        margin-right: 20px;
        border: 1px solid var(--green-banana-light);
        border-radius: 8px;
        padding: 16px;
        background: var(--green-glow);
        box-sizing: border-box;
    }
    .remarks-box .remarks-header {
        margin-bottom: 8px;
    }
    .remarks-box .remarks-header strong {
        color: var(--brand-green-dark);
    }
    .remarks-box .remarks-textarea {
        white-space: pre-wrap;
        min-height: 90px;
        padding: 10px 12px;
        border: 1px solid var(--green-banana-light);
        border-radius: 6px;
        background: #FFFFFF;
        font-size: 14px;
        line-height: 1.6;
    }
    .remarks-box .note-empty {
        color: var(--text-muted);
        font-style: normal;
    }
</style>
</head>
<body>

    <nav class="navbar">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings"> 
            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon"> 
            <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/organizer/bookings" class="nav-item">รายการจอง</a> 
                <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a> 
                <a href="${pageContext.request.contextPath}/organizer/questions" class="nav-item">จัดการพิธี</a> 
                <a href="${pageContext.request.contextPath}/organizer/quotation" class="nav-item active">จัดการใบเสนอราคา</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">A</div>
                <div class="user-detail">
                    <span class="user-name">Admin Organizer</span> 
                    <span class="user-role">ผู้จัดการ</span>
                </div>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="page-wrapper">
        
        <c:if test="${not empty success}">
            <div class="flash-banner flash-banner-success" id="flashBanner">✓ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash-banner flash-banner-error" id="flashBanner">⚠ ${error}</div>
        </c:if>

        <div class="a4-document">

            <c:set var="monkInviteType" value="" />
            <c:set var="monkCount" value="" />
            <c:forEach var="d" items="${b.details}">
                <c:if test="${fn:contains(d.question.questionsText,'รูปแบบการนิมนต์')}"><c:set var="monkInviteType" value="${d.answer}" /></c:if>
                <c:if test="${fn:contains(d.question.questionsText,'จำนวนพระ')}"><c:set var="monkCount" value="${d.answer}" /></c:if>
            </c:forEach>
            <c:set var="isMonkSelfInvite" value="${fn:contains(monkInviteType,'นิมนต์เอง')}" />
            <c:set var="isCustomRequest" value="${b.ceremony.ceremonyName == 'กรอกความต้องการเบื้องต้น'}" />

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

            <div class="doc-meta-row">
                <div class="meta-box-left">
                    <table class="layout-table">
                        <tr>
                            <td class="label">ชื่อลูกค้า:</td>
                            <td class="value">คุณ ${b.member.memberFirstName} ${b.member.memberLastName}</td>
                        </tr>
                        <tr>
                            <td class="label">สถานที่จัดงาน:</td>
                            <td class="value">${b.eventAddress}</td>
                        </tr>
                        <tr>
                            <td class="label">วันที่จัดงาน:</td>
                            <td class="value"><fmt:formatDate value="${b.eventDate}" pattern="dd/MM/yyyy" /> เวลา ${b.eventTime} น.</td>
                        </tr>
                        <tr>
                            <td class="label">รูปแบบพิธี:</td>
                            <td class="value">${b.ceremony.ceremonyType}</td>
                        </tr>
                        <tr>
                            <td class="label">รูปแบบการจอง:</td>
                            <td class="value">
                                <c:choose>
                                    <c:when test="${isCustomRequest}">กรอกความต้องการเอง</c:when>
                                    <c:otherwise>${b.ceremony.ceremonyName}</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="meta-box-right">
                    <table class="layout-table bordered">
                        <tr>
                            <td class="label">เลขที่:</td>
                            <td class="value">${q.quotationId}</td>
                        </tr>
                        <tr>
                            <td class="label">วันที่:</td>
                            <td class="value"><fmt:formatDate value="${q.quotationDate}" pattern="dd/MM/yyyy"/></td>
                        </tr>
                        <tr>
                            <td class="label">สถานะ:</td>
                            <td class="value"><span class="status-pill status-${q.quotationStatus}">${q.quotationStatus}</span></td>
                        </tr>
                        <tr>
                            <td class="label">หัวหน้างาน:</td>
                            <td class="value">
                                <c:choose>
                                    <c:when test="${not empty q.staff}">คุณ ${q.staff.staffFirstName}</c:when>
                                    <c:otherwise><span class="text-danger" style="font-weight:700;">รอมอบหมาย</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: right; margin-top: 12px;" class="no-print">
                        <a href="${pageContext.request.contextPath}/organizer/quotation/edit/${q.quotationId}" class="btn-blue-edit">✏️ แก้ไขใบเสนอราคา</a>
                    </div>
                </div>
            </div>

            <table class="standard-table">
                <colgroup>
                    <col style="width: 60px;">  
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

<c:if test="${!isCustomRequest}">
    <tr class="static-row">
        <td class="text-center row-number"></td>
        <td>
            <strong>แพ็กเกจ: ${b.ceremony.ceremonyName}</strong>
            <c:if test="${isMonkSelfInvite}"><br><span class="text-muted">(ลูกค้านิมนต์เอง)</span></c:if>
        </td>
        <td class="text-center">1</td>
        <td class="text-center">แพ็กเกจ</td>
        <td class="text-right">
            <fmt:formatNumber value="${b.ceremony.basePrice}" minFractionDigits="2" />
        </td>
        <td class="text-right">
            <fmt:formatNumber value="${b.ceremony.basePrice}" minFractionDigits="2" />
        </td>
    </tr>
</c:if>

                    <c:if test="${not empty packageIncludedItems && !isCustomRequest}">
                        <tr class="package-included-row">
                            <td></td>
                            <td class="package-includes-title text-left" style="padding-left: 20px !important;">ประกอบไปด้วยรายการดังนี้:</td>
                            <td></td><td></td><td></td><td></td>
                        </tr>
                        <c:forEach var="pkgItem" items="${packageIncludedItems}">
                            <c:set var="pkgItemQty" value="1" />
                            <c:if test="${(not empty pkgItem.itemDetail && fn:contains(pkgItem.itemDetail,'ต่อรูป')) || fn:contains(pkgItem.itemName,'ต่อรูป')}"><c:set var="pkgItemQty" value="${monkCount}" /></c:if>
                            <tr class="package-included-row">
                                <td></td>
                                <td class="indented-item">- ${pkgItem.itemName}</td>
                                <td class="text-center">${pkgItemQty}</td>
                                <td class="text-center">${pkgItem.unit}</td>
                                <td class="text-center text-muted">-</td>
                                <td class="text-center text-muted">-</td>
                            </tr>
                        </c:forEach>
                    </c:if>

                    <c:set var="equipBlock">
                        <c:set var="printedEquip" value="false"/>
                        <c:forEach var="d" items="${details}">
                            <c:if test="${fn:trim(d.item.itemName) ne fn:trim(b.ceremony.ceremonyName) && d.item.itemType.itemTypeName.contains('อุปกรณ์พิธีกรรม')}">
                                <c:if test="${!printedEquip}">
                                    <tr class="group-row">
                                        <td></td>
                                        <td class="category-header-text">หมวดอุปกรณ์พิธีกรรม</td>
                                        <td></td><td></td><td></td><td></td>
                                    </tr>
                                    <c:set var="printedEquip" value="true"/>
                                </c:if>
                                <tr>
                                    <td class="text-center row-number"></td>
                                    <td>
                                        ${d.item.itemName}
                                        <c:if test="${not empty d.item.itemDetail && !isCustomRequest}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    </td>
                                    <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0" /></td>
                                    <td class="text-center">${d.item.unit}</td>
                                    <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2" /></c:if></td>
                                    <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2" /></td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </c:set>

                    <c:set var="sangBlock">
                        <c:set var="printedSang" value="false"/>
                        <c:forEach var="d" items="${details}">
                            <c:if test="${fn:trim(d.item.itemName) ne fn:trim(b.ceremony.ceremonyName) && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                                <c:if test="${!printedSang}">
                                    <tr class="group-row">
                                        <td></td>
                                        <td class="category-header-text">หมวดสังฆทาน</td>
                                        <td></td><td></td><td></td><td></td>
                                    </tr>
                                    <c:set var="printedSang" value="true"/>
                                </c:if>
                                <tr>
                                    <td class="text-center row-number"></td>
                                    <td>
                                        ${d.item.itemName}
                                        <c:set var="isFreeSang" value="${!isCustomRequest && (d.item.pricePerUnit == 299.0 || d.item.pricePerUnit == 299)}" />
                                        <c:if test="${isFreeSang}"><span class="text-danger" style="font-size:12px; font-weight:bold;"> (ฟรี / รวมในแพ็กเกจ)</span></c:if>
                                        <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    </td>
                                    <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0" /></td>
                                    <td class="text-center">${d.item.unit}</td>
                                    <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${isFreeSang ? 0.00 : d.subtotal / d.quantity}" minFractionDigits="2" /></c:if></td>
                                    <td class="text-right"><fmt:formatNumber value="${isFreeSang ? 0.00 : d.subtotal}" minFractionDigits="2" /></td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </c:set>

                    <c:set var="foodBlock">
                        <c:set var="printedFood" value="false"/>
                        <c:forEach var="d" items="${details}">
                            <c:if test="${fn:trim(d.item.itemName) ne fn:trim(b.ceremony.ceremonyName) && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                                <c:if test="${!printedFood}">
                                    <tr class="group-row">
                                        <td></td>
                                        <td class="category-header-text">หมวดภัตตาหารปิ่นโต</td>
                                        <td></td><td></td><td></td><td></td>
                                    </tr>
                                    <c:set var="printedFood" value="true"/>
                                </c:if>
                                <tr>
                                    <td class="text-center row-number"></td>
                                    <td>
                                        ${d.item.itemName}
                                        <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    </td>
                                    <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0" /></td>
                                    <td class="text-center">${d.item.unit}</td>
                                    <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2" /></c:if></td>
                                    <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2" /></td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </c:set>

                    <c:set var="servBlock">
                        <c:set var="printedServ" value="false"/>
                        <c:forEach var="d" items="${details}">
                            <c:if test="${fn:trim(d.item.itemName) ne fn:trim(b.ceremony.ceremonyName) && d.item.itemType.itemTypeName.contains('บริการ')}">
                                <c:if test="${!printedServ}">
                                    <tr class="group-row">
                                        <td></td>
                                        <td class="category-header-text">หมวดบริการและการดำเนินการ</td>
                                        <td></td><td></td><td></td><td></td>
                                    </tr>
                                    <c:set var="printedServ" value="true"/>
                                </c:if>
                                <tr>
                                    <td class="text-center row-number"></td>
                                    <td>
                                        ${d.item.itemName}
                                        <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    </td>
                                    <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0" /></td>
                                    <td class="text-center">${d.item.unit}</td>
                                    <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2" /></c:if></td>
                                    <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2" /></td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </c:set>
                    
                    <c:set var="extraBlock">
                        <c:set var="printedExtra" value="false"/>
                        <c:forEach var="d" items="${details}">
                            <c:if test="${fn:trim(d.item.itemName) ne fn:trim(b.ceremony.ceremonyName) && d.item.itemType.itemTypeName.contains('อุปกรณ์เสริม')}">
                                <c:if test="${!printedExtra}">
                                    <tr class="group-row">
                                        <td></td>
                                        <td class="category-header-text">หมวดอุปกรณ์เสริม</td>
                                        <td></td><td></td><td></td><td></td>
                                    </tr>
                                    <c:set var="printedExtra" value="true"/>
                                </c:if>
                                <tr>
                                    <td class="text-center row-number"></td>
                                    <td>
                                        ${d.item.itemName}
                                        <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    </td>
                                    <td class="text-center"><fmt:formatNumber value="${d.quantity}" minFractionDigits="0" /></td>
                                    <td class="text-center">${d.item.unit}</td>
                                    <td class="text-right"><c:if test="${d.quantity > 0}"><fmt:formatNumber value="${d.subtotal / d.quantity}" minFractionDigits="2" /></c:if></td>
                                    <td class="text-right"><fmt:formatNumber value="${d.subtotal}" minFractionDigits="2" /></td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </c:set>

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

            <div class="doc-footer" style="justify-content: space-between; align-items: flex-start;">
                <div class="remarks-box">
                    <div class="remarks-header">
                        <strong>ความต้องการเพิ่มเติม:</strong>
                    </div>
                    <div class="remarks-textarea">
                        <c:choose>
                            <c:when test="${not empty q.note}">${q.note}</c:when>
                            <c:otherwise><span class="note-empty">ไม่มีความต้องการเพิ่มเติม</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>

<div class="totals-box" style="width: 350px;">
                    <c:set var="sumExtra" value="0" />
                    <c:set var="sumPackage" value="${isCustomRequest ? 0 : b.ceremony.basePrice}" />
                    
                    <c:forEach var="d" items="${details}">
                        <c:choose>
                            <%-- ถ้าไม่ใช่เคสกรอกเอง ให้เช็คตัดชื่อแพ็กเกจออกปกติ --%>
                            <c:when test="${!isCustomRequest && fn:trim(d.item.itemName) eq fn:trim(b.ceremony.ceremonyName)}">
                            </c:when>
                            <c:otherwise>
                                <c:set var="itemVal" value="${d.subtotal}" />
                                <c:if test="${!isCustomRequest && d.item.itemType.itemTypeName.contains('สังฆทาน') && (d.item.pricePerUnit == 299.0 || d.item.pricePerUnit == 299)}">
                                    <c:set var="itemVal" value="0" />
                                </c:if>
                                <c:set var="sumExtra" value="${sumExtra + itemVal}" />
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- หากเป็นกรอกเอง ให้เอายอดรวมทั้งหมดจาก sumExtra มาเป็นราคาตามรายการ --%>
                    <c:set var="displayPackagePrice" value="${isCustomRequest ? sumExtra : sumPackage}" />
                    <c:set var="calculatedGrandTotal" value="${isCustomRequest ? sumExtra : (sumPackage + sumExtra - (isMonkSelfInvite ? 1500 : 0))}" />

                    <table class="totals-table">
                        <tr>
                            <td class="tot-label">
                                <c:choose>
                                    <c:when test="${isCustomRequest}">ราคาตามรายการ:</c:when>
                                    <c:otherwise>ราคาแพ็กเกจ:</c:otherwise>
                                </c:choose>
                            </td>
                            <%-- เปลี่ยนมาแสดงผลด้วยตัวแปร displayPackagePrice --%>
                            <td class="tot-value">฿ <fmt:formatNumber value="${displayPackagePrice}" minFractionDigits="2"/></td>
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
                            <td class="total-amount">฿ <fmt:formatNumber value="${calculatedGrandTotal}" minFractionDigits="2"/></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="back-bottom-wrap no-print">
        <a href="${pageContext.request.contextPath}/organizer/quotation" class="btn-back-bottom">← กลับไปรายการใบเสนอราคา</a>
    </div>
    
    <footer class="site-footer">
        <div class="footer-content">
            <div class="footer-brand">
                <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                     alt="บุญมีนำพา รับจัดงานบุญ" class="footer-lotus-icon">
                <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
            </div>
            <p class="footer-tagline">ระบบจัดการงานบุญสำหรับทีมงานและผู้ดูแลระบบ</p>
        </div>
    </footer>

<script>
    function toggleDropdown() { document.getElementById('dropdownMenu').classList.toggle('show'); }
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.user-info')) document.getElementById('dropdownMenu').classList.remove('show');
    });

    document.addEventListener('DOMContentLoaded', function() {
        var rows = document.querySelectorAll('.standard-table tbody tr:not(.group-row):not(.package-included-row)');
        var count = 1;
        rows.forEach(function(row) {
            var numCell = row.querySelector('.row-number');
            if(numCell) numCell.innerText = count++;
        });

        setTimeout(function() { 
            var banner = document.getElementById('flashBanner'); 
            if(banner) banner.style.display = 'none'; 
        }, 5000);
    });
</script>
</body>
</html>