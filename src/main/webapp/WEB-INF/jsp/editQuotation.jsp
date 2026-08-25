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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/quotationCreate.css?v=18">
   <style>
    /* ===== ปรับคอลัมน์ "จำนวน" (ปุ่ม +/-) ให้กว้างขึ้นและอยู่แถวเดียวกัน ===== */
    #mainQuotationTable .qty-wrapper{
        display:flex;
        align-items:center;
        justify-content:center;
        flex-wrap:nowrap;
        white-space:nowrap;
        gap:6px;
    }
    #mainQuotationTable .btn-qty-minus,
    #mainQuotationTable .btn-qty-plus{
        flex:0 0 auto;
        width:26px;
        height:26px;
        border:1px solid var(--rose-deep);
        background:#FFFFFF;
        color:var(--rose-deep);
        border-radius:4px;
        font-size:15px;
        line-height:1;
        cursor:pointer;
    }
    #mainQuotationTable .btn-qty-minus:hover,
    #mainQuotationTable .btn-qty-plus:hover{
        background:var(--rose-glow);
    }
    #mainQuotationTable .qty-wrapper .qty-input{
        flex:0 0 auto;
        width:52px;
        text-align:center;
    }
    /* ===== ปุ่มลบ (ถังขยะ) ให้เล็กและเป็นสีแดง (คงสีแดงไว้เพื่อสื่อความหมาย "ลบ") ===== */
    #mainQuotationTable td.delete-col{
        padding:4px !important;
        text-align:center;
    }
    #mainQuotationTable .btn-remove{
        width:26px;
        height:26px;
        padding:0;
        border:1px solid #FCA5A5;
        background:#FEE2E2;
        color:#DC2626;
        border-radius:6px;
        font-size:13px;
        line-height:1;
        cursor:pointer;
    }
    #mainQuotationTable .btn-remove:hover{
        background:#DC2626;
        border-color:#DC2626;
        color:#FFFFFF;
    }
    
    /* สไตล์สำหรับช่อง input ที่เป็น readonly ให้ดูเหมือนข้อความธรรมดา หรือดูแก้ไม่ได้ */
    .price-input[readonly] {
        background-color: transparent;
        border: none;
        outline: none;
        color: #333;
        font-weight: 600;
    }

    /* ===== สไตล์หัวข้อหมวดหมู่ให้เหมือนหน้าสร้างใบเสนอราคา (พร้อมปุ่ม + ในแถวเดียวกัน) ===== */
    #mainQuotationTable tr.group-row td.category-header-text {
        text-align: left !important;
        padding-left: 8px !important;
        padding-right: 12px !important;
        white-space: nowrap;
        color: var(--rose-deep);
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    #mainQuotationTable tr.group-row td {
        background-color: var(--rose-glow); /* สีพื้นหลังอ่อนๆ โทนกุหลาบให้เข้ากับธีมหมวดหมู่ */
    }
    #mainQuotationTable .btn-add-group-inline{
        flex: 0 0 auto;
        width: 22px;
        height: 22px;
        border-radius: 50%;
        border: 1px solid var(--rose-deep);
        background: #FFFFFF;
        color: var(--rose-deep);
        font-size: 14px;
        line-height: 1;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0;
    }
    #mainQuotationTable .btn-add-group-inline:hover{
        background: #FFFFFF;
        transform: scale(1.05);
    }

    /* ===== รายชื่อ "รายการเพิ่มเติม" แสดงในวงเล็บใต้ label เหมือนหน้ารายละเอียดใบเสนอราคา ===== */
    .tot-extra-detail{
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

<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
        <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"  class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item active">จัดการใบเสนอราคา</a>
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
    <form id="quotationForm"
          action="${pageContext.request.contextPath}/organizer/quotation/update"
          method="post" onsubmit="return validateForm()">
        <input type="hidden" name="quotationId" value="${q.quotationId}">

        <c:set var="packageName" value="${q.bookingForm.ceremony.ceremonyName}"/>
        <c:set var="isCustomRequest" value="${packageName == 'กรอกความต้องการเบื้องต้น'}" />

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

        <%-- ดึง "ความต้องการเพิ่มเติม" ที่ลูกค้ากรอกไว้ตอนจอง เอาไว้เป็นค่าเริ่มต้นของช่องหมายเหตุในใบเสนอราคา --%>
        <c:set var="customerAdditionalNote" value=""/>
        <c:forEach var="bd" items="${q.bookingForm.details}">
            <c:if test="${fn:contains(bd.question.questionsText,'เพิ่มเติม')}">
                <c:set var="customerAdditionalNote" value="${bd.answer}"/>
            </c:if>
        </c:forEach>
        <%-- ถ้าใบเสนอราคาถูกกรอก/แก้ไข note ไว้แล้ว (โดยแอดมิน) ให้ใช้ค่านั้นแทนของลูกค้า --%>
        <c:set var="noteDisplayValue" value="${not empty q.note ? q.note : customerAdditionalNote}"/>

        <%-- ราคาแพ็กเกจแสดงเต็มจำนวนเสมอ ส่วนลด (ถ้ามี) ไปหักที่สรุปยอดด้านล่างเท่านั้น ไม่หักซ้ำตรงนี้ --%>
        <c:choose>
            <c:when test="${isCustomRequest}">
                <c:set var="packageDisplayPrice" value="0.00"/>
            </c:when>
            <c:otherwise>
                <c:set var="packageDisplayPrice" value="${q.bookingForm.ceremony.basePrice}"/>
            </c:otherwise>
        </c:choose>

        <div class="a4-document">

            <div class="doc-header">
                <div class="company-info">
                    <h2>บริษัท บุญมีนำพา จัดงานบุญ </h2>
						<p>รับจัดพิธีสงฆ์ นิมนต์พระ สังฆทาน และงานบุญครบวงจร</p>
						<p>โทร. 080-123-4567 | อีเมล: boonmee@gmail.com</p>
                </div>
                <div class="doc-title-box">
                    <h1>แก้ไขใบเสนอราคา ${q.quotationId}</h1>
                    <p>(Quotation)</p>
                </div>
            </div>

            <div class="doc-meta-row">
                <div class="meta-box-left">
                    <table class="layout-table">
                        <tr>
                            <td class="label">ชื่อลูกค้า:</td>
                            <td class="value">คุณ ${q.bookingForm.member.memberFirstName} ${q.bookingForm.member.memberLastName}</td>
                        </tr>
                        <tr>
                            <td class="label">สถานที่จัดงาน:</td>
                            <td class="value">${q.bookingForm.eventAddress}</td>
                        </tr>
                        <tr>
                            <td class="label">วันที่จัดงาน:</td>
                            <td class="value"><fmt:formatDate value="${q.bookingForm.eventDate}" pattern="dd/MM/yyyy" /> เวลา ${q.bookingForm.eventTime} น.</td>
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
                                    <c:otherwise>${packageName}</c:otherwise>
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
                            <td class="value">${q.quotationStatus}</td>
                        </tr>
                    </table>
                </div>
            </div>

            <table id="mainQuotationTable" class="standard-table is-editing">
               <colgroup>
                    <col style="width: 60px;">
                    <col style="width: auto;">
                    <col style="width: 160px;">
                    <col style="width: 70px;">
                    <col style="width: 110px;">
                    <col style="width: 110px;">
                    <col class="delete-col" style="width: 40px;">
                </colgroup>
                <thead>
                    <tr>
                        <th class="text-center">ลำดับ</th>
                        <th class="text-left">รายการ</th>
                        <th class="text-center">จำนวน</th>
                        <th class="text-center">หน่วย</th>
                        <th class="text-right">ราคา/หน่วย</th>
                        <th class="text-right">จำนวนเงิน</th>
                        <th class="text-center delete-col">ลบ</th>
                    </tr>
                </thead>

                <tbody>
                    <c:if test="${!isCustomRequest}">
                    <tr class="static-row package-main-row no-qty-convert">
                        <td class="text-center row-number">1</td>
                        <td>
                            <strong>แพ็กเกจ: ${packageName}</strong>
                            <input type="hidden" name="bookingItemNames" value="${packageName}">
                        </td>
                        <td class="text-center">1<input type="hidden" name="bookingQtys" value="1" class="qty-input"></td>
                        <td class="text-center">แพ็กเกจ</td>
                        <td><input type="number" name="bookingPrices" value="${packageDisplayPrice}" step="0.01" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                        <td class="text-right"><span class="subtotal">0.00</span></td>
                        <td class="text-center delete-col">-</td>
                    </tr>
                    </c:if>

                    <c:if test="${not empty packageIncludedItems && !isCustomRequest}">
                        <tr class="package-included-row no-qty-convert static-row">
                            <td></td>
                            <td class="package-includes-title" style="padding-left: 20px !important;">ประกอบไปด้วยรายการดังนี้:</td>
                            <td></td><td></td><td></td><td></td><td class="delete-col"></td>
                        </tr>
                        <c:forEach var="pkgItem" items="${packageIncludedItems}">
                            <c:set var="pkgItemQty" value="1"/>
                            <c:if test="${(not empty pkgItem.itemDetail && fn:contains(pkgItem.itemDetail,'ต่อรูป')) || fn:contains(pkgItem.itemName,'ต่อรูป')}">
                                <c:set var="pkgItemQty" value="${monkCount}"/>
                            </c:if>
                            <tr class="package-included-row no-qty-convert static-row">
                                <td class="no-index"></td>
                                <td class="indented-item">- ${pkgItem.itemName}</td>
                                <td class="text-center">${pkgItemQty}</td>
                                <td class="text-center">${pkgItem.unit}</td>
                                <td class="text-center text-muted">-</td>
                                <td class="text-center text-muted">-</td>
                                <td class="text-center delete-col">-</td>
                            </tr>
                        </c:forEach>
                    </c:if>
                </tbody>

                <!-- บล็อกสำหรับหมวดอุปกรณ์พิธีกรรม -->
                <c:set var="equipmentBlockEdit">
                    <tr class="group-row">
                        <td class="no-index"></td>
                        <td class="category-header-text">
                            หมวดอุปกรณ์พิธีกรรม
                            <button type="button" class="btn-add-group-inline" onclick="openItemModal('อุปกรณ์พิธีกรรม')" title="เพิ่มรายการหมวดนี้">+</button>
                        </td>
                        <td></td><td></td><td></td><td></td><td class="delete-col"></td>
                    </tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์พิธีกรรม')}">
                            <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                <td class="text-center row-number"></td>
                                <td>
                                    ${d.item.itemName} 
                                    <input type="hidden" name="extraItemIds" value="${d.item.itemId}">
                                </td>
                                <td><input type="number" name="extraQtys" value="${d.quantity}" class="clean-input text-center qty-input" min="1" onchange="calculateGrandTotal()"></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td><input type="number" name="extraPrices" value="${d.item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <!-- บล็อกสำหรับหมวดสังฆทาน -->
                <c:set var="sangkathanBlockEdit">
                    <tr class="group-row">
                        <td class="no-index"></td>
                        <td class="category-header-text">
                            หมวดสังฆทาน
                            <button type="button" class="btn-add-group-inline" onclick="openItemModal('สังฆทาน')" title="เพิ่มรายการหมวดนี้">+</button>
                        </td>
                        <td></td><td></td><td></td><td></td><td class="delete-col"></td>
                    </tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                            <tr class="static-row" data-item-id="${d.item.itemId}">
                                <td class="text-center row-number"></td>
                                <td>
                                    ${d.item.itemName} 
                                    <c:set var="isFreeSangEdit" value="${!isCustomRequest && (d.item.pricePerUnit == 299.0 || d.item.pricePerUnit == 299)}" />
                                    <c:if test="${isFreeSangEdit}">
                                        <span class="text-danger" style="font-size:12px; font-weight:bold;"> (ฟรี / รวมในแพ็กเกจ)</span>
                                    </c:if>
                                    <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    <input type="hidden" name="bookingItemNames" value="${d.item.itemName}">
                                </td>
                                <td><input type="number" name="bookingQtys" value="${d.quantity}" class="clean-input text-center qty-input" min="1" onchange="calculateGrandTotal()"></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td>
                                    <c:set var="sangPriceEdit" value="${isFreeSangEdit ? '0.00' : d.item.pricePerUnit}" />
                                    <input type="number" name="bookingPrices" value="${sangPriceEdit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly>
                                </td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <!-- บล็อกสำหรับหมวดภัตตาหารปิ่นโต -->
                <c:set var="foodBlockEdit">
                    <tr class="group-row">
                        <td class="no-index"></td>
                        <td class="category-header-text">
                            หมวดภัตตาหารปิ่นโต
                            <button type="button" class="btn-add-group-inline" onclick="openItemModal('ภัตตาหาร')" title="เพิ่มรายการหมวดนี้">+</button>
                        </td>
                        <td></td><td></td><td></td><td></td><td class="delete-col"></td>
                    </tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                            <tr class="static-row" data-item-id="${d.item.itemId}">
                                <td class="text-center row-number"></td>
                                <td>
                                    ${d.item.itemName} <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    <input type="hidden" name="bookingItemNames" value="${d.item.itemName}">
                                </td>
                                <td><input type="number" name="bookingQtys" value="${d.quantity}" class="clean-input text-center qty-input" min="1" onchange="calculateGrandTotal()"></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td><input type="number" name="bookingPrices" value="${d.item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <!-- บล็อกสำหรับหมวดบริการและการดำเนินการ -->
                <c:set var="serviceBlockEdit">
                    <tr class="group-row">
                        <td class="no-index"></td>
                        <td class="category-header-text">
                            หมวดบริการและการดำเนินการ
                            <button type="button" class="btn-add-group-inline" onclick="openItemModal('บริการ')" title="เพิ่มรายการหมวดนี้">+</button>
                        </td>
                        <td></td><td></td><td></td><td></td><td class="delete-col"></td>
                    </tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('บริการ')}">
                            <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                <td class="text-center row-number"></td>
                               <td>
                                    ${d.item.itemName}
                                    <input type="hidden" name="extraItemIds" value="${d.item.itemId}">
                                </td>
                                <td><input type="number" name="extraQtys" value="${d.quantity}" class="clean-input text-center qty-input" min="1" onchange="calculateGrandTotal()"></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td><input type="number" name="extraPrices" value="${d.item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <!-- บล็อกสำหรับหมวดอุปกรณ์เสริม -->
                <c:set var="extraEquipmentBlockEdit">
                    <tr class="group-row">
                        <td class="no-index"></td>
                        <td class="category-header-text">
                            หมวดอุปกรณ์เสริม
                            <button type="button" class="btn-add-group-inline" onclick="openItemModal('อุปกรณ์เสริม')" title="เพิ่มรายการหมวดนี้">+</button>
                        </td>
                        <td></td><td></td><td></td><td></td><td class="delete-col"></td>
                    </tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์เสริม')}">
                            <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                <td class="text-center row-number"></td>
                              <td>
                                    ${d.item.itemName}
                                    <input type="hidden" name="extraItemIds" value="${d.item.itemId}">
                                </td>
                                <td><input type="number" name="extraQtys" value="${d.quantity}" class="clean-input text-center qty-input" min="1" onchange="calculateGrandTotal()"></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td><input type="number" name="extraPrices" value="${d.item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <%-- แสดงผลตามโหมด --%>
                <c:choose>
                    <c:when test="${isCustomRequest}">
                        <tbody id="group-equipment">${equipmentBlockEdit}</tbody>
                        <tbody id="group-sangkathan">${sangkathanBlockEdit}</tbody>
                        <tbody id="group-food">${foodBlockEdit}</tbody>
                        <tbody id="group-service">${serviceBlockEdit}</tbody>
                        <tbody id="group-extra">${extraEquipmentBlockEdit}</tbody>
                    </c:when>
                    <c:otherwise>
                        <tbody id="group-sangkathan">${sangkathanBlockEdit}</tbody>
                        <tbody id="group-food">${foodBlockEdit}</tbody>
                        <tbody id="group-extra">${extraEquipmentBlockEdit}</tbody>
                    </c:otherwise>
                </c:choose>

            </table>

            <div class="doc-footer">
                <div class="remarks-box">
                    <div class="remarks-header">
                        <strong>ความต้องการเพิ่มเติม:</strong>
                    </div>
                    <textarea name="note" class="remarks-textarea" placeholder="ระบุความต้องการเพิ่มเติมที่นี่...">${noteDisplayValue}</textarea>
                </div>
                
                <div class="totals-box">
                    <c:set var="discountValue" value="${!isCustomRequest && isMonkSelfInvite ? 1500 : 0}" />
                    <input type="hidden" id="discountValue" value="${discountValue}">
                    <table class="totals-table">
                      
                        <tr>
                            <td class="tot-label">
                                <c:choose>
                                    <c:when test="${isCustomRequest}">ราคาตามรายการ:</c:when>
                                    <c:otherwise>ราคาแพ็กเกจ:</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="tot-value">฿ <span id="summaryPackage">0.00</span></td>
                        </tr>
                        <%-- เอาบรรทัดนี้แสดงเสมอ ไม่ต้องดักด้วย c:if --%>
                        <tr>
                            <td class="tot-label">
                                รายการเพิ่มเติม:
                                <div class="tot-extra-detail" id="extraItemsDetail"></div>
                            </td>
                            <td class="tot-value">฿ <span id="summaryExtra">0.00</span></td>
                        </tr>
                        <c:if test="${!isCustomRequest && isMonkSelfInvite}">
                            <tr>
                                <td class="tot-label">ส่วนลดนิมนต์เอง:</td>
                                <td class="tot-value text-danger">- ฿ <fmt:formatNumber value="${discountValue}" pattern="#,##0.00" /></td>
                            </tr>
                        </c:if>
                        <tr class="grand-total-row">
                            <td class="tot-label">ยอดรวมสุทธิ:</td>
                            <td class="total-amount">฿ <span id="grandTotal">0.00</span></td>
                        </tr>
                    </table>
                </div>
            </div>

        </div>

        <div style="text-align: center; margin-top: 30px;">
            <button type="submit" class="btn-save-doc">บันทึกการแก้ไขใบเสนอราคา</button>
        </div>
    </form>
</div>

<div id="itemDataStore" style="display: none;">
    <%-- ดึงประเภทงาน (ceremonyType) จากตัวแปร q (หน้าแก้ไข) --%>
    <c:set var="currentCeremonyType" value="${not empty q ? q.bookingForm.ceremony.ceremonyType : ''}" />
    
    <c:forEach var="item" items="${extraSelectableItems}">
        <c:set var="skipItem" value="false" />
        
        <%-- กรองอุปกรณ์พิธีกรรมให้ตรงกับประเภทงาน --%>
        <c:if test="${item.itemType.itemTypeName == 'อุปกรณ์พิธีกรรม'}">
            <c:choose>
                <c:when test="${currentCeremonyType == 'ทำบุญบ้าน'}">
                    <c:if test="${item.itemName == 'โต๊ะหมู่บูชาไม้สัก' || item.itemName == 'พระพุทธรูปประดิษฐาน' || item.itemName == 'ชุดเจิมประตูหน้าต่าง' || item.itemName == 'ป้ายฤกษ์เปิดกิจการ' || item.itemName == 'พุ่มเงินพุ่มทอง' || fn:contains(item.itemName, 'สำนักงาน') || fn:contains(item.itemName, 'เปิดกิจการ')}">
                        <c:set var="skipItem" value="true"/>
                    </c:if>
                </c:when>
                <c:when test="${currentCeremonyType == 'ขึ้นบ้านใหม่'}">
                    <c:if test="${item.itemName == 'พานพุ่มดอกไม้สดถวายพระ' || item.itemName == 'ป้ายฤกษ์เปิดกิจการ' || item.itemName == 'พุ่มเงินพุ่มทอง' || fn:contains(item.itemName, 'สำนักงาน') || fn:contains(item.itemName, 'เปิดกิจการ')}">
                        <c:set var="skipItem" value="true"/>
                    </c:if>
                </c:when>
                <c:when test="${currentCeremonyType == 'ทำบุญบริษัทหรือออฟฟิศ'}">
                    <c:if test="${item.itemName == 'พานพุ่มดอกไม้สดถวายพระ' || item.itemName == 'ชุดเจิมประตูหน้าต่าง' || item.itemName == 'พระพุทธรูปประดิษฐาน'}">
                        <c:set var="skipItem" value="true"/>
                    </c:if>
                </c:when>
            </c:choose>
        </c:if>
        
        <c:if test="${!skipItem}">
            <div class="item-data" 
                 data-id="${item.itemId}" 
                 data-name="${item.itemName}" 
                 data-detail="${item.itemDetail}" 
                 data-unit="${item.unit}" 
                 data-price="${item.pricePerUnit}" 
                 data-type="${item.itemType.itemTypeName}"></div>
        </c:if>
    </c:forEach>
</div>

<div id="itemSelectionModal" class="modal-overlay">
    <div class="modal-card">
        <div class="modal-header">
            <h3 id="itemModalTitle">เลือกรายการเพิ่มเติม</h3>
            <button type="button" class="close-btn" onclick="closeItemModal()">✕</button>
        </div>
        <div class="modal-body">
            <div class="picker-toolbar">
                <label class="select-all-label"> <input type="checkbox" id="selectAllVisible" onchange="toggleSelectAllVisible(this)"> เลือกทั้งหมดในหมวดนี้</label>
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

<script src="${pageContext.request.contextPath}/static/js/quotationEdit.js"></script>
<script>
    window.CEREMONY_MONK_COUNT = ${empty monkCount ? 0 : monkCount};
    window.IS_CUSTOM_REQUEST = ${isCustomRequest};

    // ป้ายหมวดหมู่ (สำหรับตั้งชื่อหัวข้อป๊อปอัพ ให้เหมือนหน้าสร้าง)
    var CATEGORY_LABELS_EDIT = {
        'อุปกรณ์พิธีกรรม': 'อุปกรณ์พิธีกรรม',
        'ภัตตาหาร':        'ภัตตาหารปิ่นโต',
        'สังฆทาน':         'สังฆทาน',
        'บริการ':          'บริการและดำเนินการ',
        'อุปกรณ์เสริม':     'อุปกรณ์เสริม'
    };

    // หมวดหมู่ที่กำลังเปิดป๊อปอัพอยู่ ณ ขณะนี้ (แทนที่การใช้แท็บแบบเดิม ให้เหมือนหน้าสร้างที่กดปุ่ม + ในแต่ละหมวดโดยตรง)
    var currentEditCategory = null;

    // เปิดป๊อปอัพเพิ่มรายการ โดยระบุหมวดหมู่ตรงจากปุ่ม + ของแต่ละหมวด (เหมือนหน้าสร้างใบเสนอราคา)
    window.openItemModal = function (category) {
        currentEditCategory = category || null;

        var title = document.getElementById('itemModalTitle');
        if (title) {
            title.textContent = currentEditCategory
                ? 'เพิ่มรายการหมวด: ' + (CATEGORY_LABELS_EDIT[currentEditCategory] || currentEditCategory)
                : 'เลือกรายการเพิ่มเติม';
        }

        renderItemPicker(currentEditCategory);
        document.getElementById('itemSelectionModal').style.display = 'flex';
    };

    window.closeItemModal = function () {
        document.getElementById('itemSelectionModal').style.display = 'none';
        selectedItemIds.clear();
        currentEditCategory = null;
    };

    // ให้ toggleSelectAllVisible / updateSelectAllState (ในไฟล์ quotationEdit.js) อ้างอิงหมวดหมู่ปัจจุบันจากตัวแปรนี้แทนแท็บ
    window.getCurrentCategory = function () {
        return currentEditCategory;
    };

    // อัปเดตฟังก์ชันสร้างหัวข้อให้หน้าตาเหมือนหน้าสร้างใบเสนอราคา (เว้นช่องแรกให้สีและโครงสร้างตรงกัน)
    window.ensureGroupHeader = function(tbody) {
        if (!tbody) return;
        if (tbody.querySelector('.group-row')) return;
        var GROUP_LABELS = {
            'group-equipment':  'หมวดอุปกรณ์พิธีกรรม',
            'group-food':       'หมวดภัตตาหารปิ่นโต',
            'group-sangkathan': 'หมวดสังฆทาน',
            'group-service':    'หมวดบริการและการดำเนินการ',
            'group-extra':      'หมวดอุปกรณ์เสริม'
        };
        var category = {
            'group-equipment':  'อุปกรณ์พิธีกรรม',
            'group-food':       'ภัตตาหาร',
            'group-sangkathan': 'สังฆทาน',
            'group-service':    'บริการ',
            'group-extra':      'อุปกรณ์เสริม'
        }[tbody.id] || '';
        var label = GROUP_LABELS[tbody.id] || '';
        var headerRow = document.createElement('tr');
        headerRow.className = 'group-row';
        headerRow.innerHTML = '<td class="no-index"></td><td class="category-header-text">' + label +
            (category ? ' <button type="button" class="btn-add-group-inline" onclick="openItemModal(\'' + category + '\')" title="เพิ่มรายการหมวดนี้">+</button>' : '') +
            '</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>';
        tbody.prepend(headerRow);
    };

    window.addSelectedItemsToTable = function() {
        if (selectedItemIds.size === 0) {
            alert('กรุณาเลือกรายการอย่างน้อย 1 รายการ');
            return;
        }

        var dataStore = document.getElementById('itemDataStore');

        selectedItemIds.forEach(function(itemId) {
            var dataEl = dataStore.querySelector('.item-data[data-id="' + itemId + '"]');
            if (!dataEl) return;

            var itemName = dataEl.getAttribute('data-name');
            var itemDesc = dataEl.getAttribute('data-detail') || '';
            var price    = parseFloat(dataEl.getAttribute('data-price')) || 0;
            var unit     = dataEl.getAttribute('data-unit');
            var itemType = dataEl.getAttribute('data-type') || '';

            var scalesByMonk = itemName.includes('ต่อรูป') || itemDesc.includes('ต่อรูป');
            var monkCount    = parseInt(window.CEREMONY_MONK_COUNT, 10) || 1;
            var initialQty   = scalesByMonk ? monkCount : 1;

            var targetBody = document.getElementById('group-service');
            var isEquipment = itemType.includes('อุปกรณ์พิธีกรรม');

            if (isEquipment) targetBody = document.getElementById('group-equipment');
            else if (itemType.includes('อุปกรณ์เสริม')) targetBody = document.getElementById('group-extra');
            else if (itemType.includes('ภัตตาหาร')) targetBody = document.getElementById('group-food');
            else if (itemType.includes('สังฆทาน'))  targetBody = document.getElementById('group-sangkathan');

            if (!targetBody) return; // หมวดนี้ไม่มีในโหมดปัจจุบัน (เช่น แพ็กเกจไม่มีหมวดอุปกรณ์พิธีกรรม/บริการ)

            ensureGroupHeader(targetBody);

            var tr = document.createElement('tr');
            tr.className = 'dynamic-row';
            tr.setAttribute('data-item-id', itemId);

            // ซ่อนรายละเอียด (itemDesc) สำหรับหมวดอุปกรณ์พิธีกรรม บริการ และอุปกรณ์เสริม
            var showDesc = itemType.includes('ภัตตาหาร') || itemType.includes('สังฆทาน');
            var descHtml = (itemDesc && showDesc) ? '<br><span class="text-muted" style="font-size:12px;">' + itemDesc + '</span>' : '';

            // ใช้ buildQtyCell (มีปุ่ม +/-) จาก quotationEdit.js เพื่อให้แถวที่เพิ่มใหม่หน้าตาเหมือนแถวเดิมทุกประการ
            var qtyCellHtml = (typeof buildQtyCell === 'function')
                ? buildQtyCell(initialQty, 'extraQtys')
                : '<input type="number" name="extraQtys" value="' + initialQty + '" min="1" class="clean-input text-center qty-input" onchange="calculateGrandTotal()">';

            tr.innerHTML = 
                '<td class="text-center row-number"></td>' +
                '<td>' + itemName + descHtml + '<input type="hidden" name="extraItemIds" value="' + itemId + '"></td>' +
                '<td>' + qtyCellHtml + '</td>' +
                '<td class="text-center">' + unit + '</td>' +
                '<td><input type="number" name="extraPrices" value="' + price.toFixed(2) + '" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>' +
                '<td class="text-right"><span class="subtotal">0.00</span></td>' +
                '<td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>';

            targetBody.appendChild(tr);
        });
        
        selectedItemIds.clear();
        closeItemModal();
        if(typeof reIndexRows === 'function') reIndexRows();
        calculateGrandTotal();
    };

    window.calculateGrandTotal = function() {
        var packageTotal = 0.0;
        var extraTotal = 0.0;
        var discount = parseFloat(document.getElementById('discountValue').value) || 0;
        var isCustomRequest = window.IS_CUSTOM_REQUEST === true;
        var extraItemNames = [];

        document.querySelectorAll('.static-row, .dynamic-row').forEach(function(row) {
            if (row.classList.contains('package-included-row')) return;

            var qInput = row.querySelector('input[name="extraQtys"], input[name="bookingQtys"]');
            var pInput = row.querySelector('input[name="extraPrices"], input[name="bookingPrices"]');

            if (qInput && pInput) {
                var qty = parseFloat(qInput.value) || 0;
                var price = parseFloat(pInput.value) || 0;
                var subtotal = qty * price;

                var subtotalSpan = row.querySelector('.subtotal');
                if (subtotalSpan) subtotalSpan.innerText = subtotal.toLocaleString('th-TH', {minimumFractionDigits: 2});

                var parentTbody = row.closest('tbody');
                var isManuallyAddedExtra = parentTbody && parentTbody.id === 'group-extra';

                if (row.classList.contains('package-main-row')) {
                    packageTotal += subtotal;
                } else if (isCustomRequest && !isManuallyAddedExtra) {
                    /* กรอกความต้องการเอง: รายการอุปกรณ์/สังฆทาน/อาหาร/บริการที่มาจากคำตอบ ถือเป็น "รายการหลัก" ไม่ใช่ของเพิ่มเติม */
                    packageTotal += subtotal;
                } else {
                    extraTotal += subtotal;

                    // เก็บชื่อรายการไว้แสดงในวงเล็บใต้ label "รายการเพิ่มเติม" (ข้ามรายการที่ฟรี/รวมในแพ็กเกจ)
                    var isFreeItem = !!row.querySelector('.text-danger');
                    if (!isFreeItem) {
                        var nameCell = row.children[1];
                        var nameText = (nameCell && nameCell.childNodes[0]) ? nameCell.childNodes[0].textContent.trim() : '';
                        if (nameText) extraItemNames.push(nameText);
                    }
                }
            }
        });

        var summaryPackage = document.getElementById('summaryPackage');
        if (summaryPackage) summaryPackage.innerText = packageTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});

        var summaryExtra = document.getElementById('summaryExtra');
        if (summaryExtra) summaryExtra.innerText = extraTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});

        var extraDetailDiv = document.getElementById('extraItemsDetail');
        if (extraDetailDiv) extraDetailDiv.innerText = extraItemNames.length ? ('(' + extraItemNames.join(', ') + ')') : '';

        var grandTotal = packageTotal + extraTotal - discount;
        if (grandTotal < 0) grandTotal = 0;

        var grandTotalSpan = document.getElementById('grandTotal');
        if (grandTotalSpan) grandTotalSpan.innerText = grandTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});
    };

    document.addEventListener('DOMContentLoaded', function () {
        calculateGrandTotal();
    });
    
</script>
</body>
</html>