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
                    <h2>บริษัท บุญมีนำพา จัดงานบุญ จำกัด</h2>
                    <p>รับจัดพิธีสงฆ์ นิมนต์พระ สังฆทาน และงานบุญครบวงจร</p>
                    <p>โทร. 080-123-4567 | อีเมล: contact@boonmeenumpa.com</p>
                </div>
                <div class="doc-title-box">
                    <h1>แก้ไขใบเสนอราคา #${q.quotationId}</h1>
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
                            <td class="value">${q.bookingForm.ceremony.ceremonyType} (${packageName})</td>
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
                    <col style="width: 50px;">  
                    <col style="width: auto;">  
                    <col style="width: 80px;">  
                    <col style="width: 80px;">  
                    <col style="width: 120px;"> 
                    <col style="width: 120px;"> 
                    <col class="delete-col" style="width: 50px;">  
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
                        <td><input type="number" name="bookingQtys" value="1" class="clean-input text-center qty-input" readonly></td>
                        <td class="text-center">แพ็กเกจ</td>
                        <td><input type="number" name="bookingPrices" value="${packageDisplayPrice}" step="0.01" class="clean-input text-right price-input" onchange="calculateGrandTotal()"></td>
                        <td class="text-right"><span class="subtotal">0.00</span></td>
                        <td class="text-center delete-col">-</td>
                    </tr>
                    </c:if>

                    <c:if test="${not empty packageIncludedItems && !isCustomRequest}">
                        <tr class="package-included-row no-qty-convert static-row">
                            <td></td><td class="package-includes-title" style="padding-left: 20px !important;">ประกอบไปด้วยรายการดังนี้:</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>
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

                <c:set var="equipmentBlockEdit">
                    <c:set var="printedEquipHeaderEdit" value="false" />
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์')}">
                            <c:if test="${!printedEquipHeaderEdit}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดอุปกรณ์พิธีกรรม</td><td></td><td></td><td></td><td></td><td class="delete-col"></td></tr>
                                <c:set var="printedEquipHeaderEdit" value="true" />
                            </c:if>
                            <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                <td class="text-center row-number"></td>
                                <td>
                                    ${d.item.itemName} <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    <input type="hidden" name="extraItemIds" value="${d.item.itemId}">
                                </td>
                                <td><input type="number" name="extraQtys" value="${d.quantity}" class="clean-input text-center qty-input" min="1" onchange="calculateGrandTotal()"></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td><input type="number" name="extraPrices" value="${d.item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()"></td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <c:set var="sangkathanBlockEdit">
                    <c:set var="printedSangHeaderEdit" value="false" />
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                            <c:if test="${!printedSangHeaderEdit}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดสังฆทาน</td><td></td><td></td><td></td><td></td><td class="delete-col"></td></tr>
                                <c:set var="printedSangHeaderEdit" value="true" />
                            </c:if>
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
                                    <input type="number" name="bookingPrices" value="${sangPriceEdit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()">
                                </td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <c:set var="foodBlockEdit">
                    <c:set var="printedFoodHeaderEdit" value="false" />
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                            <c:if test="${!printedFoodHeaderEdit}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดภัตตาหารปิ่นโต</td><td></td><td></td><td></td><td></td><td class="delete-col"></td></tr>
                                <c:set var="printedFoodHeaderEdit" value="true" />
                            </c:if>
                            <tr class="static-row" data-item-id="${d.item.itemId}">
                                <td class="text-center row-number"></td>
                                <td>
                                    ${d.item.itemName} <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    <input type="hidden" name="bookingItemNames" value="${d.item.itemName}">
                                </td>
                                <td><input type="number" name="bookingQtys" value="${d.quantity}" class="clean-input text-center qty-input" min="1" onchange="calculateGrandTotal()"></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td><input type="number" name="bookingPrices" value="${d.item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()"></td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <c:set var="serviceBlockEdit">
                    <c:set var="printedServiceHeaderEdit" value="false" />
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('บริการ')}">
                            <c:if test="${!printedServiceHeaderEdit}">
                                <tr class="group-row"><td></td><td class="category-header-text">หมวดบริการและการดำเนินการ</td><td></td><td></td><td></td><td></td><td class="delete-col"></td></tr>
                                <c:set var="printedServiceHeaderEdit" value="true" />
                            </c:if>
                            <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                <td class="text-center row-number"></td>
                                <td>
                                    ${d.item.itemName} <c:if test="${not empty d.item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${d.item.itemDetail}</span></c:if>
                                    <input type="hidden" name="extraItemIds" value="${d.item.itemId}">
                                </td>
                                <td><input type="number" name="extraQtys" value="${d.quantity}" class="clean-input text-center qty-input" min="1" onchange="calculateGrandTotal()"></td>
                                <td class="text-center">${d.item.unit}</td>
                                <td><input type="number" name="extraPrices" value="${d.item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()"></td>
                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </c:set>

                <c:choose>
                    <c:when test="${isCustomRequest}">
                        <tbody id="group-equipment">${equipmentBlockEdit}</tbody>
                        <tbody id="group-sangkathan">${sangkathanBlockEdit}</tbody>
                        <tbody id="group-food">${foodBlockEdit}</tbody>
                        <tbody id="group-service">${serviceBlockEdit}</tbody>
                        <tbody id="group-extra"></tbody>
                    </c:when>
                    <c:otherwise>
                        <tbody id="group-sangkathan">${sangkathanBlockEdit}</tbody>
                        <tbody id="group-food">${foodBlockEdit}</tbody>
                        <tbody id="group-service">${serviceBlockEdit}</tbody>
                        <tbody id="group-equipment">${equipmentBlockEdit}</tbody>
                        <tbody id="group-extra"></tbody>
                    </c:otherwise>
                </c:choose>

            </table>

            <div class="doc-footer">
                <div class="remarks-box">
                    <div class="remarks-header">
                        <strong>ความต้องการเพิ่มเติม:</strong>
                        <button type="button" class="btn-add-item" onclick="openItemModal()">+ เพิ่มรายการเพิ่มเติม</button>
                    </div>
                    <textarea name="detailNotes" class="remarks-textarea" placeholder="ระบุความต้องการเพิ่มเติมที่นี่...">${additionalNote}</textarea>
                </div>
                
                <div class="totals-box">
                    <c:set var="discountValue" value="${!isCustomRequest && isMonkSelfInvite ? 1500 : 0}" />
                    <input type="hidden" id="discountValue" value="${discountValue}">
                    <table class="totals-table">
                        <tr>
                            <td class="tot-label">รูปแบบพิธี:</td>
                            <td class="tot-value">
                                <c:choose>
                                    <c:when test="${isCustomRequest}">กรอกความต้องการเอง</c:when>
                                    <c:otherwise>${packageName}</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td class="tot-label">
                                <c:choose>
                                    <c:when test="${isCustomRequest}">ราคาตามรายการ:</c:when>
                                    <c:otherwise>ราคาแพ็กเกจ:</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="tot-value">฿ <span id="summaryPackage">0.00</span></td>
                        </tr>
                        <tr>
                            <td class="tot-label">รายการเพิ่มเติม:</td>
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
    <c:forEach var="item" items="${extraSelectableItems}">
        <div class="item-data" data-id="${item.itemId}" data-name="${item.itemName}" data-detail="${item.itemDetail}" data-unit="${item.unit}" data-price="${item.pricePerUnit}" data-type="${item.itemType.itemTypeName}"></div>
    </c:forEach>
</div>

<div id="itemSelectionModal" class="modal-overlay">
    <div class="modal-card">
        <div class="modal-header">
            <h3>เลือกอุปกรณ์และบริการเสริม</h3>
            <button type="button" class="close-btn" onclick="closeItemModal()">✕</button>
        </div>
        <div class="category-tabs">
            <button type="button" class="category-tab active" data-category="อุปกรณ์พิธีกรรม" onclick="switchCategoryTab(this,'อุปกรณ์พิธีกรรม')">อุปกรณ์พิธีกรรม</button>
            <button type="button" class="category-tab" data-category="ภัตตาหาร" onclick="switchCategoryTab(this,'ภัตตาหาร')">ภัตตาหารปิ่นโต</button>
            <button type="button" class="category-tab" data-category="สังฆทาน" onclick="switchCategoryTab(this,'สังฆทาน')">สังฆทาน</button>
            <button type="button" class="category-tab" data-category="บริการ" onclick="switchCategoryTab(this,'บริการ')">บริการและดำเนินการ</button>
            <button type="button" class="category-tab" data-category="อุปกรณ์เสริม" onclick="switchCategoryTab(this,'อุปกรณ์เสริม')">อุปกรณ์เสริม</button>
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
        var label = GROUP_LABELS[tbody.id] || '';
        var headerRow = document.createElement('tr');
        headerRow.className = 'group-row';
        headerRow.innerHTML = '<td></td><td class="category-header-text">' + label + '</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>';
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
            if (itemType.includes('อุปกรณ์พิธีกรรม')) targetBody = document.getElementById('group-equipment');
            else if (itemType.includes('อุปกรณ์เสริม')) targetBody = document.getElementById('group-extra');
            else if (itemType.includes('ภัตตาหาร')) targetBody = document.getElementById('group-food');
            else if (itemType.includes('สังฆทาน'))  targetBody = document.getElementById('group-sangkathan');

            ensureGroupHeader(targetBody);

            var tr = document.createElement('tr');
            tr.className = 'dynamic-row';
            tr.setAttribute('data-item-id', itemId);

            var descHtml = itemDesc ? '<br><span class="text-muted" style="font-size:12px;">' + itemDesc + '</span>' : '';

            tr.innerHTML = 
                '<td class="text-center row-number"></td>' +
                '<td>' + itemName + descHtml + '<input type="hidden" name="extraItemIds" value="' + itemId + '"></td>' +
                '<td><input type="number" name="extraQtys" value="' + initialQty + '" min="1" class="clean-input text-center qty-input" onchange="calculateGrandTotal()"></td>' +
                '<td class="text-center">' + unit + '</td>' +
                '<td><input type="number" name="extraPrices" value="' + price.toFixed(2) + '" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()"></td>' +
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
                }
            }
        });

        var summaryPackage = document.getElementById('summaryPackage');
        if (summaryPackage) summaryPackage.innerText = packageTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});

        var summaryExtra = document.getElementById('summaryExtra');
        if (summaryExtra) summaryExtra.innerText = extraTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});

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
