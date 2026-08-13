<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>จัดทำใบเสนอราคา - บุญมีนำพา จัดงานบุญ</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/quotationCreate.css?v=18">
<style>
    /* สไตล์สำหรับปุ่ม +/- และช่องกรอกจำนวนของรายการเพิ่มเติม */
    #mainQuotationTable .qty-wrapper{
        display:flex;
        align-items:center;
        justify-content:center;
        flex-wrap:nowrap;
        white-space:nowrap;
        gap: 4px; /* ลดช่องว่างลงนิดนึงเพื่อไม่ให้ล้นตาราง */
    }
    #mainQuotationTable .btn-qty-minus,
    #mainQuotationTable .btn-qty-plus{
        flex:0 0 auto;
        width: 24px;
        height: 24px;
        border: 1px solid #9C6B3E;
        background: #FFFFFF;
        color: #9C6B3E;
        border-radius: 4px;
        font-size: 14px;
        line-height: 1;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }
    #mainQuotationTable .btn-qty-minus:hover,
    #mainQuotationTable .btn-qty-plus:hover{
        background:#FBF2E3;
    }
    #mainQuotationTable .qty-wrapper .qty-input{
        flex:0 0 auto;
        width: 38px; /* ลดความกว้างกล่องตัวเลขลงนิดนึง */
        text-align:center;
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 2px 0;
    }
    /* ซ่อนช่อง input จำนวน ให้อ่านได้อย่างเดียว */
    .qty-input[readonly] {
        background-color: transparent !important;
        border: none !important;
        outline: none !important;
        color: #333 !important;
        font-weight: 600 !important;
        box-shadow: none !important;
        padding: 0 !important;
        width: 100% !important;
        -moz-appearance: textfield;
        text-align: center;
    }
    .qty-input[readonly]::-webkit-outer-spin-button,
    .qty-input[readonly]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }
    /* ปุ่มดินสอสำหรับกดโชว์ +/- */
    .btn-pencil-toggle {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 14px;
        color: #D9A441;
        padding: 2px;
        transition: transform 0.2s;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }
    .btn-pencil-toggle:hover {
        transform: scale(1.15);
    }
</style>
</head>
<body>

	<%-- ===== NAVBAR ===== --%>
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
					<a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item">ออกจากระบบ</a>
				</div>
			</div>
		</div>
	</nav>

	<div class="page-wrapper">
		<form id="quotationForm" action="${pageContext.request.contextPath}/organizer/quotation/save" method="post" onsubmit="return validateForm()">
			<input type="hidden" name="bookingId" value="${b.bookingId}">

			<div class="a4-document">

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
								<td class="value">รอออกเลขที่</td>
							</tr>
							<tr>
								<td class="label">วันที่:</td>
								<td class="value"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy" /></td>
							</tr>
							<tr>
								<td class="label">ยืนยันภายใน (วัน):</td>
								<td class="value"><input type="number" name="validDays" value="5" class="inline-input" style="width: 50px;"> วัน</td>
							</tr>
						</table>
					</div>
				</div>

				<table id="mainQuotationTable" class="standard-table">
                    <colgroup>
                        <col style="width: 50px;">  
                        <col style="width: auto;">  
                        <col style="width: 140px;">  <!-- ขยายเป็น 140px เพื่อให้ปุ่ม +/- ไม่โดนตัดล้นกรอบ -->
                        <col style="width: 80px;">  
                        <col style="width: 120px;"> 
                        <col style="width: 120px;"> 
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

					<%-- กำหนดตัวแปรแพ็กเกจและการนิมนต์พระ --%>
					<c:set var="monkInviteType" value="" />
					<c:set var="monkCount" value="" />
					<c:forEach var="d" items="${b.details}">
						<c:if test="${fn:contains(d.question.questionsText,'รูปแบบการนิมนต์')}"><c:set var="monkInviteType" value="${d.answer}" /></c:if>
						<c:if test="${fn:contains(d.question.questionsText,'จำนวนพระ')}"><c:set var="monkCount" value="${d.answer}" /></c:if>
					</c:forEach>
                    
                    <c:set var="isMonkSelfInvite" value="${fn:contains(monkInviteType,'นิมนต์เอง')}" />
                    <c:set var="discountValue" value="0" />
                    
                    <%-- ตั้งค่าตัวแปรกรณีที่เป็นงาน กรอกความต้องการเบื้องต้น --%>
                    <c:set var="isCustomRequest" value="${fn:contains(b.ceremony.ceremonyName, 'ความต้องการเบื้องต้น')}" />
                    <c:choose>
                        <c:when test="${isCustomRequest}">
                            <c:set var="packageDisplayPrice" value="0.00" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="packageDisplayPrice" value="${b.ceremony.basePrice}" />
                            <c:if test="${isMonkSelfInvite}">
                                <c:set var="discountValue" value="1500" />
                            </c:if>
                        </c:otherwise>
                    </c:choose>

					<tbody>
						<%-- 1. แถวราคาแพ็กเกจ --%>
						<c:if test="${!isCustomRequest}">
						<tr class="static-row package-main-row no-qty-convert">
							<td class="text-center row-number">1</td>
							<td>
								<strong>แพ็กเกจ: ${b.ceremony.ceremonyName}</strong>
								<input type="hidden" name="bookingItemNames" value="${b.ceremony.ceremonyName}">
							</td>
                            <!-- ล็อกช่องจำนวน -->
							<td><input type="number" name="bookingQtys" value="1" class="qty-input" readonly></td>
							<td class="text-center">แพ็กเกจ</td>
							<!-- ใส่ readonly -->
							<td><input type="number" name="bookingPrices" value="${packageDisplayPrice}" step="0.01" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
							<td class="text-right"><span class="subtotal">0.00</span></td>
						</tr>
						</c:if>

						<%-- ลิสต์รายการที่อยู่ในแพ็กเกจ --%>
						<c:if test="${not empty packageIncludedItems && !isCustomRequest}">
							<tr class="package-included-row no-qty-convert static-row">
                                <td colspan="6" class="package-includes-title text-left" style="padding-left: 20px !important;">ประกอบไปด้วยรายการดังนี้:</td>
							</tr>
							<c:forEach var="pkgItem" items="${packageIncludedItems}">
								<tr class="package-included-row no-qty-convert static-row">
									<td class="no-index"></td>
									<td class="indented-item">- ${pkgItem.itemName}</td>
									<td class="text-center">
										<c:choose>
											<c:when test="${fn:contains(pkgItem.itemName,'ต่อรูป') || (not empty pkgItem.itemDetail && fn:contains(pkgItem.itemDetail,'ต่อรูป'))}">${monkCount}</c:when>
											<c:otherwise>1</c:otherwise>
										</c:choose>
									</td>
									<td class="text-center">${pkgItem.unit}</td>
									<td class="text-center text-muted">-</td>
									<td class="text-center text-muted">-</td>
								</tr>
							</c:forEach>
						</c:if>
                    </tbody>

                    <%-- สลับลำดับตารางตามประเภทงาน --%>
                    <c:choose>
                        <c:when test="${isCustomRequest}">
                            <tbody id="group-equipment"></tbody>

                            <c:set var="sangQty" value="1" />
                            <c:forEach var="d" items="${b.details}">
                                <c:if test="${fn:contains(d.question.questionsText,'สังฆทาน') && fn:contains(d.question.questionsText,'จำนวน')}">
                                    <c:if test="${not empty d.answer && d.answer != '0'}"><c:set var="sangQty" value="${d.answer}" /></c:if>
                                </c:if>
                            </c:forEach>
                            <tbody id="group-sangkathan">
                                <c:set var="printedSangHeader" value="false" />
                                <c:forEach var="detail" items="${validDetails}">
                                    <c:if test="${fn:contains(detail.question.questionsText,'สังฆทาน') && fn:contains(detail.question.questionsText,'เลือก')}">
                                        <c:set var="selectedSangName" value="${fn:trim(detail.answer)}" />
                                        <c:forEach var="item" items="${items}">
                                            <c:if test="${fn:trim(item.itemName) eq selectedSangName}">
                                                <c:if test="${!printedSangHeader}">
                                                    <tr class="group-row">
                                                        <td colspan="6" class="category-header-text" style="text-align: left !important;">หมวดสังฆทาน</td>
                                                    </tr>
                                                    <c:set var="printedSangHeader" value="true" />
                                                </c:if>
                                                <tr class="static-row">
                                                    <td class="text-center row-number"></td>
                                                    <td>
                                                        ${item.itemName} 
                                                        <c:set var="isFreeSang" value="${!isCustomRequest && (item.pricePerUnit == 299.0 || item.pricePerUnit == 299)}" />
                                                        <c:if test="${isFreeSang}">
                                                            <span class="text-danger" style="font-size:12px; font-weight:bold;"> (ฟรี / รวมในแพ็กเกจ)</span>
                                                        </c:if>
                                                        <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                        <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                    </td>
                                                    <td><input type="number" name="bookingQtys" value="${sangQty}" class="qty-input" readonly></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td>
                                                        <c:set var="sangPrice" value="${isFreeSang ? '0.00' : item.pricePerUnit}" />
                                                        <input type="number" name="bookingPrices" value="${sangPrice}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly>
                                                    </td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </tbody>

                            <c:set var="foodQty" value="1" />
                            <c:forEach var="d" items="${b.details}">
                                <c:if test="${fn:contains(d.question.questionsText,'ภัตตาหาร') && fn:contains(d.question.questionsText,'จำนวน')}">
                                    <c:if test="${not empty d.answer && d.answer != '0'}"><c:set var="foodQty" value="${d.answer}" /></c:if>
                                </c:if>
                            </c:forEach>
                            <tbody id="group-food">
                                <c:set var="printedFoodHeader" value="false" />
                                <c:forEach var="detail" items="${validDetails}">
                                    <c:if test="${fn:contains(detail.question.questionsText,'ภัตตาหาร') && fn:contains(detail.question.questionsText,'เลือก')}">
                                        <c:set var="selectedFoodName" value="${fn:trim(detail.answer)}" />
                                        <c:forEach var="item" items="${items}">
                                            <c:if test="${fn:trim(item.itemName) eq selectedFoodName}">
                                                <c:if test="${!printedFoodHeader}">
                                                    <tr class="group-row">
                                                        <td colspan="6" class="category-header-text" style="text-align: left !important;">หมวดภัตตาหารปิ่นโต</td>
                                                    </tr>
                                                    <c:set var="printedFoodHeader" value="true" />
                                                </c:if>
                                                <tr class="static-row">
                                                    <td class="text-center row-number"></td>
                                                    <td>
                                                        ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                        <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                    </td>
                                                    <td><input type="number" name="bookingQtys" value="${foodQty}" class="qty-input" readonly></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </tbody>

                            <tbody id="group-service">
                                <c:if test="${not isMonkSelfInvite && not empty monkCount}">
                                    <c:forEach var="item" items="${items}">
                                        <c:if test="${fn:trim(item.itemName) eq 'บริการประสานงานนิมนต์พระ'}">
                                            <tr class="group-row">
                                                <td colspan="6" class="category-header-text" style="text-align: left !important;">หมวดบริการและการดำเนินการ</td>
                                            </tr>
                                            <tr class="static-row">
                                                <td class="text-center row-number"></td>
                                                <td>
                                                    ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                    <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                </td>
                                                <td><input type="number" name="bookingQtys" value="${monkCount}" class="qty-input" readonly></td>
                                                <td class="text-center">${item.unit}</td>
                                                <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </tbody>
                            <tbody id="group-extra"></tbody>
                        </c:when>

                        <c:otherwise>
                            <%-- แพ็กเกจปกติ --%>
                            <c:set var="sangQty" value="1" />
                            <c:forEach var="d" items="${b.details}">
                                <c:if test="${fn:contains(d.question.questionsText,'สังฆทาน') && fn:contains(d.question.questionsText,'จำนวน')}">
                                    <c:if test="${not empty d.answer && d.answer != '0'}"><c:set var="sangQty" value="${d.answer}" /></c:if>
                                </c:if>
                            </c:forEach>
                            <tbody id="group-sangkathan">
                                <c:set var="printedSangHeader" value="false" />
                                <c:forEach var="detail" items="${validDetails}">
                                    <c:if test="${fn:contains(detail.question.questionsText,'สังฆทาน') && fn:contains(detail.question.questionsText,'เลือก')}">
                                        <c:set var="selectedSangName" value="${fn:trim(detail.answer)}" />
                                        <c:forEach var="item" items="${items}">
                                            <c:if test="${fn:trim(item.itemName) eq selectedSangName}">
                                                <c:if test="${!printedSangHeader}">
                                                    <tr class="group-row">
                                                        <td colspan="6" class="category-header-text" style="text-align: left !important;">หมวดสังฆทาน</td>
                                                    </tr>
                                                    <c:set var="printedSangHeader" value="true" />
                                                </c:if>
                                                <tr class="static-row">
                                                    <td class="text-center row-number"></td>
                                                    <td>
                                                        ${item.itemName} 
                                                        <c:set var="isFreeSang" value="${!isCustomRequest && (item.pricePerUnit == 299.0 || item.pricePerUnit == 299)}" />
                                                        <c:if test="${isFreeSang}">
                                                            <span class="text-danger" style="font-size:12px; font-weight:bold;"> (ฟรี / รวมในแพ็กเกจ)</span>
                                                        </c:if>
                                                        <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                        <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                    </td>
                                                    <td><input type="number" name="bookingQtys" value="${sangQty}" class="qty-input" readonly></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td>
                                                        <c:set var="sangPrice" value="${isFreeSang ? '0.00' : item.pricePerUnit}" />
                                                        <input type="number" name="bookingPrices" value="${sangPrice}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly>
                                                    </td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </tbody>

                            <c:set var="foodQty" value="1" />
                            <c:forEach var="d" items="${b.details}">
                                <c:if test="${fn:contains(d.question.questionsText,'ภัตตาหาร') && fn:contains(d.question.questionsText,'จำนวน')}">
                                    <c:if test="${not empty d.answer && d.answer != '0'}"><c:set var="foodQty" value="${d.answer}" /></c:if>
                                </c:if>
                            </c:forEach>
                            <tbody id="group-food">
                                <c:set var="printedFoodHeader" value="false" />
                                <c:forEach var="detail" items="${validDetails}">
                                    <c:if test="${fn:contains(detail.question.questionsText,'ภัตตาหาร') && fn:contains(detail.question.questionsText,'เลือก')}">
                                        <c:set var="selectedFoodName" value="${fn:trim(detail.answer)}" />
                                        <c:forEach var="item" items="${items}">
                                            <c:if test="${fn:trim(item.itemName) eq selectedFoodName}">
                                                <c:if test="${!printedFoodHeader}">
                                                    <tr class="group-row">
                                                        <td colspan="6" class="category-header-text" style="text-align: left !important;">หมวดภัตตาหารปิ่นโต</td>
                                                    </tr>
                                                    <c:set var="printedFoodHeader" value="true" />
                                                </c:if>
                                                <tr class="static-row">
                                                    <td class="text-center row-number"></td>
                                                    <td>
                                                        ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                        <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                    </td>
                                                    <td><input type="number" name="bookingQtys" value="${foodQty}" class="qty-input" readonly></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </tbody>

                            <tbody id="group-service"></tbody>
                            <tbody id="group-equipment"></tbody>
                            <tbody id="group-extra"></tbody>
                        </c:otherwise>
                    </c:choose>

				</table>

				<%-- 4. ส่วนท้าย --%>
				<div class="doc-footer">
					<div class="remarks-box">
                        <div class="remarks-header">
						    <strong>ความต้องการเพิ่มเติม:</strong>
                            <button type="button" class="btn-add-item" onclick="openItemModal()">+ เพิ่มรายการเพิ่มเติม</button>
                        </div>
						<textarea name="detailNotes" class="remarks-textarea" placeholder="ระบุความต้องการเพิ่มเติมที่นี่...">${additionalNote}</textarea>
					</div>
					
                    <div class="totals-box">
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
                            <c:if test="${!isCustomRequest}">
                            <tr>
                                <td class="tot-label">รายการเพิ่มเติม:</td>
                                <td class="tot-value">฿ <span id="summaryExtra">0.00</span></td>
                            </tr>
                            </c:if>
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

            <div class="bottom-toolbar" style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn-save-doc">บันทึกและออกใบเสนอราคา</button>
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

<script>
    window.CEREMONY_MONK_COUNT = ${empty monkCount ? 0 : monkCount};
    window.IS_CUSTOM_REQUEST = ${isCustomRequest};
</script>

<script src="${pageContext.request.contextPath}/static/js/quotationCreate.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        if(typeof calculateGrandTotal === 'function') calculateGrandTotal();
    });
</script>
</body>
</html>