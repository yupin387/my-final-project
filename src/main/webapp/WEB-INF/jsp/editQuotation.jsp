<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>แก้ไขใบเสนอราคา #${q.quotationId} - ระบบรับจัดงานบุญ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/quotationCreate.css?v=3">
</head>
<body>

<%-- ===== NAVBAR ===== --%>
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings">
        <div class="navbar-lotus">🪷</div>
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
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

                        <%-- หมวดอุปกรณ์พิธีกรรม --%>
                        <tbody id="group-equipment">
                            <tr class="group-row"><td colspan="8">หมวดอุปกรณ์พิธีกรรม</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemType.itemTypeName.contains('อุปกรณ์')}">
                                    <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <br><small style="color:#888;">${d.item.itemDetail}</small>
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

                        <%-- หมวดภัตตาหารปิ่นโต --%>
                        <tbody id="group-food">
                            <tr class="group-row"><td colspan="8">หมวดภัตตาหารปิ่นโต</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                                    <tr class="static-row" data-item-id="${d.item.itemId}">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <br><small style="color:#888;">${d.item.itemDetail}</small>
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

                        <%-- หมวดสังฆทาน --%>
                        <tbody id="group-sangkathan">
                            <tr class="group-row"><td colspan="8">หมวดสังฆทาน</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                                    <tr class="static-row" data-item-id="${d.item.itemId}">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <br><small style="color:#888;">${d.item.itemDetail}</small>
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

                        <%-- หมวดบริการและการดำเนินการ --%>
                        <tbody id="group-service">
                            <tr class="group-row"><td colspan="8">หมวดบริการและการดำเนินการ</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemId == 1}">
                                    <tr class="static-row" data-item-id="1">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">นิมนต์พระสงฆ์</span>
                                            <input type="hidden" name="extraItemIds" value="1">
                                        </td>
                                        <td>
                                            <input type="number" name="extraQtys" value="${d.quantity}" min="1"
                                                   class="qty-input" style="text-align:center;" onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:center;">รูป</td>
                                        <td>
                                            <input type="number" name="extraPrices" value="200.00"
                                                   step="0.01" min="0" class="price-input" style="text-align:right;"
                                                   onchange="calculateGrandTotal()">
                                        </td>
                                        <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
                                        <td><input type="text" name="detailNotes" value="${d.note}" class="note-input"></td>
                                        <td style="text-align:center;">-</td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemId != 1 && d.item.itemType.itemTypeName.contains('บริการ')}">
                                    <tr class="dynamic-row" data-item-id="${d.item.itemId}">
                                        <td class="row-number" style="text-align:center;"></td>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <br><small style="color:#888;">${d.item.itemDetail}</small>
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

                    </table>

                    <button type="button" class="btn-open-popup" onclick="openItemModal()">
                        <span>＋</span> เลือกรายการวัสดุอุปกรณ์เสริมเพิ่มเติม
                    </button>

                </div>
            </div>
        </div>
    </form>
</div>

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

<%-- ITEM DATA STORE (เพิ่มเข้ามา — จำเป็นสำหรับ popup เลือกสินค้า) --%>
<div id="itemDataStore" style="display:none;">
    <c:forEach var="item" items="${items}">
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
            <div class="item-picker-grid" id="itemPickerGrid"></div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-cancel-modal" onclick="closeItemModal()">ยกเลิก</button>
            <button type="button" class="btn-submit-modal" onclick="addSelectedItemsToTable()">ตกลงเพิ่มรายการที่เลือก</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/quotationCreate.js"></script>

</body>
</html>
