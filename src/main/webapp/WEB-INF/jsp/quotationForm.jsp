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
						<%-- 1. แถวราคาแพ็กเกจ (ไม่แสดงถ้าเป็นแบบกรอกความต้องการเอง เพราะไม่มีแพ็กเกจ ให้ขึ้นรายการอุปกรณ์เลย) --%>
						<c:if test="${!isCustomRequest}">
						<tr class="static-row package-main-row no-qty-convert">
							<td class="text-center row-number">1</td>
							<td>
								<strong>แพ็กเกจ: ${b.ceremony.ceremonyName}</strong>
								<input type="hidden" name="bookingItemNames" value="${b.ceremony.ceremonyName}">
							</td>
							<td><input type="number" name="bookingQtys" value="1" class="clean-input text-center qty-input locked-look" readonly></td>
							<td class="text-center">แพ็กเกจ</td>
							<td><input type="number" name="bookingPrices" value="${packageDisplayPrice}" step="0.01" class="clean-input text-right price-input locked-look" readonly onchange="calculateGrandTotal()"></td>
							<td class="text-right"><span class="subtotal">0.00</span></td>
							<td class="text-center delete-col">-</td>
						</tr>
						</c:if>

						<%-- ลิสต์รายการที่อยู่ในแพ็กเกจ (ใช้ 7 คอลัมน์เดี่ยวๆ ห้ามใช้ colspan) --%>
						<c:if test="${not empty packageIncludedItems && !isCustomRequest}">
							<tr class="package-included-row no-qty-convert static-row">
								<td></td>
                                <td class="package-includes-title text-left" style="padding-left: 20px !important;">ประกอบไปด้วยรายการดังนี้:</td>
                                <td></td><td></td><td></td><td></td><td class="delete-col"></td>
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
									<td class="text-center delete-col">-</td>
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
                                                        <td></td><td class="category-header-text">หมวดสังฆทาน</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>
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
                                                    <td><input type="number" name="bookingQtys" value="${sangQty}" class="clean-input text-center qty-input locked-look" readonly min="1" onchange="calculateGrandTotal()"></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td>
                                                        <c:set var="sangPrice" value="${isFreeSang ? '0.00' : item.pricePerUnit}" />
                                                        <input type="number" name="bookingPrices" value="${sangPrice}" step="0.01" min="0" class="clean-input text-right price-input locked-look" readonly onchange="calculateGrandTotal()">
                                                    </td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                    <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
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
                                                        <td></td><td class="category-header-text">หมวดภัตตาหารปิ่นโต</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>
                                                    </tr>
                                                    <c:set var="printedFoodHeader" value="true" />
                                                </c:if>
                                                <tr class="static-row">
                                                    <td class="text-center row-number"></td>
                                                    <td>
                                                        ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                        <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                    </td>
                                                    <td><input type="number" name="bookingQtys" value="${foodQty}" class="clean-input text-center qty-input locked-look" readonly min="1" onchange="calculateGrandTotal()"></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input locked-look" readonly onchange="calculateGrandTotal()"></td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                    <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
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
                                                <td></td><td class="category-header-text">หมวดบริการและการดำเนินการ</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>
                                            </tr>
                                            <tr class="static-row">
                                                <td class="text-center row-number"></td>
                                                <td>
                                                    ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                    <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                </td>
                                                <td><input type="number" name="bookingQtys" value="${monkCount}" class="clean-input text-center qty-input locked-look" readonly min="1" onchange="calculateGrandTotal()"></td>
                                                <td class="text-center">${item.unit}</td>
                                                <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input locked-look" readonly onchange="calculateGrandTotal()"></td>
                                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                                <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </tbody>
                            <tbody id="group-extra"></tbody>
                        </c:when>

                        <c:otherwise>
                            <%-- แพ็กเกจปกติ: สังฆทาน -> อาหาร -> บริการ -> อุปกรณ์เสริม --%>
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
                                                        <td></td><td class="category-header-text">หมวดสังฆทาน</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>
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
                                                    <td><input type="number" name="bookingQtys" value="${sangQty}" class="clean-input text-center qty-input locked-look" readonly min="1" onchange="calculateGrandTotal()"></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td>
                                                        <c:set var="sangPrice" value="${isFreeSang ? '0.00' : item.pricePerUnit}" />
                                                        <input type="number" name="bookingPrices" value="${sangPrice}" step="0.01" min="0" class="clean-input text-right price-input locked-look" readonly onchange="calculateGrandTotal()">
                                                    </td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                    <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
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
                                                        <td></td><td class="category-header-text">หมวดภัตตาหารปิ่นโต</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>
                                                    </tr>
                                                    <c:set var="printedFoodHeader" value="true" />
                                                </c:if>
                                                <tr class="static-row">
                                                    <td class="text-center row-number"></td>
                                                    <td>
                                                        ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                        <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                    </td>
                                                    <td><input type="number" name="bookingQtys" value="${foodQty}" class="clean-input text-center qty-input locked-look" readonly min="1" onchange="calculateGrandTotal()"></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input locked-look" readonly onchange="calculateGrandTotal()"></td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                    <td class="text-center delete-col"><button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button></td>
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
						<textarea name="detailNotes" class="remarks-textarea locked-look" readonly placeholder="ระบุความต้องการเพิ่มเติมที่นี่...">${additionalNote}</textarea>
					</div>
					
                    <div class="totals-box">
                        <input type="hidden" id="discountValue" value="${discountValue}">
						<table class="totals-table">
                            <tr>
                                <td class="tot-label">รูปแบบพิธี:</td>
                                <td class="tot-value">
                                    <c:choose>
                                        <c:when test="${isCustomRequest}">กรอกความต้องการเอง</c:when>
                                        <c:otherwise>${b.ceremony.ceremonyName}</c:otherwise>
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

            <%-- ปุ่มแก้ไขรายการย้ายมาไว้มุมล่างของเอกสาร คู่กับปุ่มบันทึก --%>
            <div class="bottom-toolbar">
                <button type="button" id="toggleEditBtn" class="btn-toggle-edit" onclick="toggleEditMode()">
                    <span>✏️</span> แก้ไขรายการ
                </button>
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
            
            var isEditing = document.getElementById('mainQuotationTable').classList.contains('is-editing');
            var lockClass = isEditing ? '' : 'locked-look';
            var readOnlyAttr = isEditing ? '' : 'readonly';
            var descHtml = itemDesc ? '<br><span class="text-muted" style="font-size:12px;">' + itemDesc + '</span>' : '';

            tr.innerHTML = 
                '<td class="text-center row-number"></td>' +
                '<td>' + itemName + descHtml + '<input type="hidden" name="extraItemIds" value="' + itemId + '"></td>' +
                '<td><input type="number" name="extraQtys" value="' + initialQty + '" min="1" class="clean-input text-center qty-input ' + lockClass + '" ' + readOnlyAttr + ' onchange="calculateGrandTotal()"></td>' +
                '<td class="text-center">' + unit + '</td>' +
                '<td><input type="number" name="extraPrices" value="' + price.toFixed(2) + '" step="0.01" min="0" class="clean-input text-right price-input ' + lockClass + '" ' + readOnlyAttr + ' onchange="calculateGrandTotal()"></td>' +
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

    (function () {
        var editUnlocked = false;
        function applyLockState() {
            var inputs = document.querySelectorAll(
                '#mainQuotationTable .qty-input:not([data-locked]),' +
                '#mainQuotationTable .price-input,' +
                '#mainQuotationTable .note-input'
            );
            inputs.forEach(function (el) {
                el.readOnly = !editUnlocked;
                el.classList.toggle('locked-look', !editUnlocked);
            });
            var textarea = document.querySelector('.remarks-textarea');
            if (textarea) {
                textarea.readOnly = !editUnlocked;
                textarea.classList.toggle('locked-look', !editUnlocked);
            }
        }
        function updateToggleBtn() {
            var btn = document.getElementById('toggleEditBtn');
            if (!btn) return;
            btn.classList.toggle('active', editUnlocked);
            btn.innerHTML = editUnlocked ? '<span>🔒</span> ล็อกรายการ (ดูตัวอย่าง)' : '<span>✏️</span> แก้ไขรายการ';
        }
        window.toggleEditMode = function () {
            editUnlocked = !editUnlocked;
            var table = document.getElementById('mainQuotationTable');
            if (editUnlocked) {
                table.classList.add('is-editing'); 
            } else {
                table.classList.remove('is-editing');
            }
            applyLockState();
            updateToggleBtn();
        };
        document.addEventListener('DOMContentLoaded', function () {
            applyLockState();
            updateToggleBtn();
            var table = document.getElementById('mainQuotationTable');
            if (table && window.MutationObserver) {
                new MutationObserver(applyLockState).observe(table, { childList: true, subtree: true });
            }
        });
    })();
</script>
</body>
</html>
