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
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/quotationCreate.css?v=19">
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
								<td class="value">รอออกเลขที่</td>
							</tr>
							<tr>
								<td class="label">วันที่:</td>
								<td class="value"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy" /></td>
							</tr>
							<tr>
								<td class="label">ยืนยันภายใน (วัน):</td>
								<td class="value">5 <input type="hidden" name="validDays" value="5"> วัน</td>
							</tr>
						</table>
					</div>
				</div>

				<table id="mainQuotationTable" class="standard-table">
                    <colgroup>
                        <col style="width: 50px;">  
                        <col style="width: auto;">  
                        <col style="width: 130px;">  
                        <col style="width: 80px;">  
                        <col style="width: 110px;"> 
                        <col style="width: 110px;"> 
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

					<c:set var="monkInviteType" value="" />
					<c:set var="monkCount" value="" />
					<c:forEach var="d" items="${b.details}">
						<c:if test="${fn:contains(d.question.questionsText,'รูปแบบการนิมนต์')}"><c:set var="monkInviteType" value="${d.answer}" /></c:if>
						<c:if test="${fn:contains(d.question.questionsText,'จำนวนพระ')}"><c:set var="monkCount" value="${d.answer}" /></c:if>
					</c:forEach>
                    
                    <c:set var="isMonkSelfInvite" value="${fn:contains(monkInviteType,'นิมนต์เอง')}" />
                    <c:set var="discountValue" value="0" />
                    
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
						<c:if test="${!isCustomRequest}">
						<tr class="static-row package-main-row no-qty-convert">
							<td class="text-center row-number">1</td>
							<td>
								<strong>แพ็กเกจ: ${b.ceremony.ceremonyName}</strong>
								<input type="hidden" name="bookingItemNames" value="${b.ceremony.ceremonyName}">
							</td>
							<td class="text-center">1<input type="hidden" name="bookingQtys" value="1" class="qty-input"></td>
							<td class="text-center">แพ็กเกจ</td>
							<td><input type="number" name="bookingPrices" value="${packageDisplayPrice}" step="0.01" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
							<td class="text-right"><span class="subtotal">0.00</span></td>
						</tr>
						</c:if>

						<c:if test="${not empty packageIncludedItems && !isCustomRequest}">
							<tr class="package-included-row no-qty-convert static-row">
                                <td class="no-index"></td>
                                <td colspan="5" class="package-includes-title text-left">ประกอบไปด้วยรายการดังนี้:</td>
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

                    <c:choose>
                        <%-- ============ โหมด: กรอกเอง (ครบ 5 หมวด) ============ --%>
                        <c:when test="${isCustomRequest}">

                            <tbody id="group-equipment" data-category="อุปกรณ์พิธีกรรม">
                                <tr class="group-row">
                                    <td class="no-index"></td>
                                    <td class="category-header-text">
                                        หมวดอุปกรณ์พิธีกรรม
                                        <button type="button" class="btn-add-group-inline" onclick="openItemModal('อุปกรณ์พิธีกรรม')" title="เพิ่มรายการหมวดนี้">+</button>
                                    </td>
                                    <td></td><td></td><td></td><td></td>
                                </tr>
                            </tbody>

                            <c:set var="sangQty" value="1" />
                            <c:forEach var="d" items="${b.details}">
                                <c:if test="${fn:contains(d.question.questionsText,'สังฆทาน') && fn:contains(d.question.questionsText,'จำนวน')}">
                                    <c:if test="${not empty d.answer && d.answer != '0'}"><c:set var="sangQty" value="${d.answer}" /></c:if>
                                </c:if>
                            </c:forEach>
                            <tbody id="group-sangkathan" data-category="สังฆทาน">
                                <tr class="group-row">
                                    <td class="no-index"></td>
                                    <td class="category-header-text">
                                        หมวดสังฆทาน
                                        <button type="button" class="btn-add-group-inline" onclick="openItemModal('สังฆทาน')" title="เพิ่มรายการหมวดนี้">+</button>
                                    </td>
                                    <td></td><td></td><td></td><td></td>
                                </tr>
                                <c:forEach var="detail" items="${validDetails}">
                                    <c:if test="${fn:contains(detail.question.questionsText,'สังฆทาน') && fn:contains(detail.question.questionsText,'เลือก')}">
                                        <c:set var="selectedSangName" value="${fn:trim(detail.answer)}" />
                                        <c:forEach var="item" items="${items}">
                                            <c:if test="${fn:trim(item.itemName) eq selectedSangName}">
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
                                                    <td class="text-center">${sangQty}<input type="hidden" name="bookingQtys" value="${sangQty}" class="qty-input"></td>
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
                            <tbody id="group-food" data-category="ภัตตาหาร">
                                <tr class="group-row">
                                    <td class="no-index"></td>
                                    <td class="category-header-text">
                                        หมวดภัตตาหารปิ่นโต
                                        <button type="button" class="btn-add-group-inline" onclick="openItemModal('ภัตตาหาร')" title="เพิ่มรายการหมวดนี้">+</button>
                                    </td>
                                    <td></td><td></td><td></td><td></td>
                                </tr>
                                <c:forEach var="detail" items="${validDetails}">
                                    <c:if test="${fn:contains(detail.question.questionsText,'ภัตตาหาร') && fn:contains(detail.question.questionsText,'เลือก')}">
                                        <c:set var="selectedFoodName" value="${fn:trim(detail.answer)}" />
                                        <c:forEach var="item" items="${items}">
                                            <c:if test="${fn:trim(item.itemName) eq selectedFoodName}">
                                                <tr class="static-row">
                                                    <td class="text-center row-number"></td>
                                                    <td>
                                                        ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                        <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                    </td>
                                                    <td class="text-center">${foodQty}<input type="hidden" name="bookingQtys" value="${foodQty}" class="qty-input"></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </tbody>

                            <tbody id="group-service" data-category="บริการ">
                                <tr class="group-row">
                                    <td class="no-index"></td>
                                    <td class="category-header-text">
                                        หมวดบริการและการดำเนินการ
                                        <button type="button" class="btn-add-group-inline" onclick="openItemModal('บริการ')" title="เพิ่มรายการหมวดนี้">+</button>
                                    </td>
                                    <td></td><td></td><td></td><td></td>
                                </tr>
                                <c:if test="${not isMonkSelfInvite && not empty monkCount}">
                                    <c:forEach var="item" items="${items}">
                                        <c:if test="${fn:trim(item.itemName) eq 'บริการประสานงานนิมนต์พระ'}">
                                            <tr class="static-row">
                                                <td class="text-center row-number"></td>
                                                <td>
                                                    ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                    <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                </td>
                                                <td class="text-center">${monkCount}<input type="hidden" name="bookingQtys" value="${monkCount}" class="qty-input"></td>
                                                <td class="text-center">${item.unit}</td>
                                                <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                                <td class="text-right"><span class="subtotal">0.00</span></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </tbody>

                            <tbody id="group-extra" data-category="อุปกรณ์เสริม">
                                <tr class="group-row">
                                    <td class="no-index"></td>
                                    <td class="category-header-text">
                                        หมวดอุปกรณ์เสริม
                                        <button type="button" class="btn-add-group-inline" onclick="openItemModal('อุปกรณ์เสริม')" title="เพิ่มรายการหมวดนี้">+</button>
                                    </td>
                                    <td></td><td></td><td></td><td></td>
                                </tr>
                            </tbody>

                        </c:when>

                        <%-- ============ โหมด: แพ็กเกจ ============ --%>
                        <c:otherwise>

                            <c:set var="sangQty" value="1" />
                            <c:forEach var="d" items="${b.details}">
                                <c:if test="${fn:contains(d.question.questionsText,'สังฆทาน') && fn:contains(d.question.questionsText,'จำนวน')}">
                                    <c:if test="${not empty d.answer && d.answer != '0'}"><c:set var="sangQty" value="${d.answer}" /></c:if>
                                </c:if>
                            </c:forEach>
                            <tbody id="group-sangkathan" data-category="สังฆทาน">
                                <tr class="group-row">
                                    <td class="no-index"></td>
                                    <td class="category-header-text">
                                        หมวดสังฆทาน
                                        <button type="button" class="btn-add-group-inline" onclick="openItemModal('สังฆทาน')" title="เพิ่มรายการหมวดนี้">+</button>
                                    </td>
                                    <td></td><td></td><td></td><td></td>
                                </tr>
                                <c:forEach var="detail" items="${validDetails}">
                                    <c:if test="${fn:contains(detail.question.questionsText,'สังฆทาน') && fn:contains(detail.question.questionsText,'เลือก')}">
                                        <c:set var="selectedSangName" value="${fn:trim(detail.answer)}" />
                                        <c:forEach var="item" items="${items}">
                                            <c:if test="${fn:trim(item.itemName) eq selectedSangName}">
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
                                                    <td class="text-center">${sangQty}<input type="hidden" name="bookingQtys" value="${sangQty}" class="qty-input"></td>
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
                            <tbody id="group-food" data-category="ภัตตาหาร">
                                <tr class="group-row">
                                    <td class="no-index"></td>
                                    <td class="category-header-text">
                                        หมวดภัตตาหารปิ่นโต
                                        <button type="button" class="btn-add-group-inline" onclick="openItemModal('ภัตตาหาร')" title="เพิ่มรายการหมวดนี้">+</button>
                                    </td>
                                    <td></td><td></td><td></td><td></td>
                                </tr>
                                <c:forEach var="detail" items="${validDetails}">
                                    <c:if test="${fn:contains(detail.question.questionsText,'ภัตตาหาร') && fn:contains(detail.question.questionsText,'เลือก')}">
                                        <c:set var="selectedFoodName" value="${fn:trim(detail.answer)}" />
                                        <c:forEach var="item" items="${items}">
                                            <c:if test="${fn:trim(item.itemName) eq selectedFoodName}">
                                                <tr class="static-row">
                                                    <td class="text-center row-number"></td>
                                                    <td>
                                                        ${item.itemName} <c:if test="${not empty item.itemDetail}"><br><span class="text-muted" style="font-size:12px;">${item.itemDetail}</span></c:if>
                                                        <input type="hidden" name="bookingItemNames" value="${item.itemName}">
                                                    </td>
                                                    <td class="text-center">${foodQty}<input type="hidden" name="bookingQtys" value="${foodQty}" class="qty-input"></td>
                                                    <td class="text-center">${item.unit}</td>
                                                    <td><input type="number" name="bookingPrices" value="${item.pricePerUnit}" step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly></td>
                                                    <td class="text-right"><span class="subtotal">0.00</span></td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </tbody>

                            <tbody id="group-extra" data-category="อุปกรณ์เสริม">
                                <tr class="group-row">
                                    <td class="no-index"></td>
                                    <td class="category-header-text">
                                        หมวดอุปกรณ์เสริม
                                        <button type="button" class="btn-add-group-inline" onclick="openItemModal('อุปกรณ์เสริม')" title="เพิ่มรายการหมวดนี้">+</button>
                                    </td>
                                    <td></td><td></td><td></td><td></td>
                                </tr>
                            </tbody>

                        </c:otherwise>
                    </c:choose>

				</table>

				<div class="doc-footer">
					<div class="remarks-box">
                        <div class="remarks-header">
						    <strong>ความต้องการเพิ่มเติม:</strong>
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
        <%-- ดึงประเภทงาน (ceremonyType) จากตัวแปร b (หน้าสร้าง) --%>
        <c:set var="currentCeremonyType" value="${not empty b ? b.ceremony.ceremonyType : ''}" />
        
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