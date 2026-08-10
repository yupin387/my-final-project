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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberQuotationDetail.css?v=5">
</head>
<body>

<%-- ========== NAVBAR (เหมือนหน้า Home ทุกสี/ขนาด) ========== --%>
<%-- ========== NAVBAR (ครบเมนูเหมือนหน้า Home ทุกอย่าง) ========== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมี รับจัดงานบุญ" class="lotus-icon">
        <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
    </a>

    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item">หน้าหลัก</a>

        <%-- เมนูบริการ/แพ็กเกจ (dropdown) --%>
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

        <%-- เมนูปฏิทิน (dropdown) --%>
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

    <%-- โปรไฟล์ผู้ใช้ + dropdown (โปรไฟล์ของฉัน / ออกจากระบบ) --%>
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

    <div class="main-card">
        <div class="card-header-bar">
            <h2>ใบเสนอราคา #${q.quotationId}</h2>
            <span class="status-badge ${q.quotationStatus == 'Confirmed' ? 'status-confirmed' : q.quotationStatus == 'Revised' ? 'status-revised' : 'status-pending'}">
                <c:choose>
                    <c:when test="${q.quotationStatus == 'Confirmed'}">✓ ยืนยันรายการแล้ว</c:when>
                    <c:when test="${q.quotationStatus == 'Revised'}">↩ ต้องแก้ไข</c:when>
                    <c:otherwise>● รอยืนยัน</c:otherwise>
                </c:choose>
            </span>
        </div>

        <%-- ===== INFO GRID (ปรับให้เป็นแบบ label/value เหมือนหน้า organizer) ===== --%>
        <div class="info-card">
            <div class="info-grid-section">
                <div class="info-box">
                    <span class="info-label">รหัสการจอง</span>
                    <span class="info-value highlight">${q.bookingForm.bookingId}</span>
                </div>
                <div class="info-box">
                    <span class="info-label">ประเภทพิธี</span>
                    <span class="info-value">${q.bookingForm.ceremony.ceremonyType}</span>
                </div>
                <div class="info-box">
                    <span class="info-label">รูปแบบการจอง</span>
                    <span class="info-value">${q.bookingForm.ceremony.ceremonyName}</span>
                </div>
                <div class="info-box">
                    <span class="info-label">วันที่จัดงาน</span>
                    <span class="info-value"><fmt:formatDate value="${q.bookingForm.eventDate}" pattern="dd/MM/yyyy"/></span>
                </div>
                <div class="info-box">
                    <span class="info-label">เวลาเริ่มงาน</span>
                    <span class="info-value">${q.bookingForm.eventTime} น.</span>
                </div>
                <div class="info-box">
                    <span class="info-label">หัวหน้างานรับผิดชอบ</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${not empty q.staff}">
                                ${q.staff.staffFirstName} ${q.staff.staffLastName}<br>
                                <small style="color:#666;">โทร: ${q.staff.staffPhone}</small>
                            </c:when>
                            <c:otherwise>อยู่ระหว่างการมอบหมายหัวหน้างาน</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>

        <div class="section-wrap">
            <div class="quote-frame">
                <div class="section-title">รายละเอียดรายการอุปกรณ์และบริการ</div>

                <table>
                    <thead>
                        <tr>
                            <th width="50" style="text-align:center;">ลำดับ</th>
                            <th>รายการ</th>
                            <th width="90" style="text-align:center;">จำนวน</th>
                            <th width="120" style="text-align:right;">ราคา/หน่วย</th>
                            <th width="120" style="text-align:right;">รวม (บาท)</th>
                            <th width="260">พิมพ์รายละเอียดแจ้งแก้ไขที่นี่</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="count" value="1"/>
                        <c:set var="packageName" value="${q.bookingForm.ceremony.ceremonyName}"/>

                        <%-- เช็คจำนวนพระที่นิมนต์ ใช้คำนวณจำนวนของอุปกรณ์ที่รวมในแพ็กเกจ
                             ที่ต้อง "คูณตามจำนวนพระ" (คีย์เวิร์ด "ต่อรูป") — ใช้ตรรกะเดียวกับ
                             หน้า organizer (quotationDetail.jsp) --%>
                        <c:set var="monkCount" value=""/>
                        <c:forEach var="bd" items="${q.bookingForm.details}">
                            <c:if test="${fn:contains(bd.question.questionsText,'จำนวนพระ')}">
                                <c:set var="monkCount" value="${bd.answer}"/>
                            </c:if>
                        </c:forEach>

                        <%-- เช็คก่อนว่าแต่ละหมวดมีรายการจริงหรือไม่ ถ้าไม่มีจะไม่แสดง header เลย
                             (ไม่โชว์หมวด/แพ็กเกจที่ไม่มีรายการอยู่ข้างใน) --%>
                        <c:set var="hasPackageRow" value="false"/>
                        <c:set var="hasEquipmentRow" value="false"/>
                        <c:set var="hasExtraRow" value="false"/>
                        <c:set var="hasFoodRow" value="false"/>
                        <c:set var="hasSangkathanRow" value="false"/>
                        <c:set var="hasServiceRow" value="false"/>
                        <c:forEach var="d" items="${details}">
                            <c:if test="${d.item != null}">
                                <c:choose>
                                    <c:when test="${d.item.itemName == packageName}">
                                        <c:set var="hasPackageRow" value="true"/>
                                    </c:when>
                                    <c:when test="${d.item.itemType.itemTypeName.contains('อุปกรณ์พิธีกรรม')}">
                                        <c:set var="hasEquipmentRow" value="true"/>
                                    </c:when>
                                    <c:when test="${d.item.itemType.itemTypeName.contains('อุปกรณ์เสริม')}">
                                        <c:set var="hasExtraRow" value="true"/>
                                    </c:when>
                                    <c:when test="${d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                                        <c:set var="hasFoodRow" value="true"/>
                                    </c:when>
                                    <c:when test="${d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                                        <c:set var="hasSangkathanRow" value="true"/>
                                    </c:when>
                                    <c:when test="${d.item.itemType.itemTypeName.contains('บริการ')}">
                                        <c:set var="hasServiceRow" value="true"/>
                                    </c:when>
                                </c:choose>
                            </c:if>
                        </c:forEach>


                        <%-- หมวดแพ็กเกจหลัก (โชว์เฉพาะเมื่อมีรายการแพ็กเกจจริง) --%>
                        <c:if test="${hasPackageRow}">
                            <tr class="group-row"><td colspan="6">แพ็กเกจ: ${q.bookingForm.ceremony.ceremonyType} (${packageName})</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName == packageName}">
                                    <tr class="item-row-data">
                                        <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <c:if test="${not empty d.item.itemDetail}">
                                                <span class="item-desc">${d.item.itemDetail}</span>
                                            </c:if>
                                        </td>
                                        <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${d.subtotal / d.quantity}" pattern="#,###.00"/></td>
                                        <td style="text-align:right;" class="amount-cell"><fmt:formatNumber value="${d.subtotal}" pattern="#,###.00"/></td>
                                        <td>
                                            <c:if test="${q.quotationStatus != 'Confirmed'}">
                                                <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                                <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องแพ็กเกจ (ถ้ามี)...">
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>

                            <%-- ✅ อุปกรณ์ที่รวมในแพ็กเกจ: แสดงเป็นแถวตารางเต็มต่อจากแถวแพ็กเกจ
                                 เหมือนหน้า organizer (quotationDetail.jsp) แทนที่ bullet list เดิม
                                 ไม่นับลำดับ ไม่นับราคาเข้ายอดรวม เพราะรวมอยู่ในราคาแพ็กเกจข้างบนแล้ว --%>
                            <c:if test="${not empty packageIncludedItems}">
                                <c:forEach var="pkgItem" items="${packageIncludedItems}">
                                    <c:set var="pkgItemQty" value="1"/>
                                    <c:if test="${(not empty pkgItem.itemDetail && fn:contains(pkgItem.itemDetail,'ต่อรูป')) || fn:contains(pkgItem.itemName,'ต่อรูป')}">
                                        <c:set var="pkgItemQty" value="${monkCount}"/>
                                    </c:if>
                                    <tr class="item-row-data package-included-row">
                                        <td style="text-align:center; color:#ccc;"></td>
                                        <td>
                                            <span class="item-name" style="color:#666;">${pkgItem.itemName}</span>
                                            <c:if test="${not empty pkgItem.itemDetail}">
                                                <span class="item-desc">${pkgItem.itemDetail}</span>
                                            </c:if>
                                        </td>
                                        <td style="text-align:center;">${pkgItemQty} ${pkgItem.unit}</td>
                                        <td style="text-align:center; color:#888;"><span class="package-included-label">รวมในแพ็กเกจ</span></td>
                                        <td style="text-align:right; color:#888;">-</td>
                                        <td>-</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                        </c:if>


                        <%-- หมวดอุปกรณ์พิธีกรรม (โชว์เฉพาะเมื่อมีรายการจริง) --%>
                        <c:if test="${hasEquipmentRow}">
                            <tr class="group-row"><td colspan="6">หมวดอุปกรณ์พิธีกรรม</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์พิธีกรรม')}">
                                    <tr class="item-row-data">
                                        <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <span class="item-desc">${d.item.itemDetail}</span>
                                        </td>
                                        <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${d.item.pricePerUnit}" pattern="#,###.00"/></td>
                                        <td style="text-align:right;" class="amount-cell"><fmt:formatNumber value="${d.subtotal}" pattern="#,###.00"/></td>
                                        <td>
                                            <c:if test="${q.quotationStatus != 'Confirmed'}">
                                                <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                                <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องอุปกรณ์ชิ้นนี้ (ถ้ามี)...">
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <%-- หมวดอุปกรณ์เสริม (โชว์เฉพาะเมื่อมีรายการจริง) --%>
                        <c:if test="${hasExtraRow}">
                            <tr class="group-row"><td colspan="6">หมวดอุปกรณ์เสริม</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('อุปกรณ์เสริม')}">
                                    <tr class="item-row-data">
                                        <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <span class="item-desc">${d.item.itemDetail}</span>
                                        </td>
                                        <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${d.item.pricePerUnit}" pattern="#,###.00"/></td>
                                        <td style="text-align:right;" class="amount-cell"><fmt:formatNumber value="${d.subtotal}" pattern="#,###.00"/></td>
                                        <td>
                                            <c:if test="${q.quotationStatus != 'Confirmed'}">
                                                <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                                <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องอุปกรณ์ชิ้นนี้ (ถ้ามี)...">
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <%-- หมวดภัตตาหาร (โชว์เฉพาะเมื่อมีรายการจริง) --%>
                        <c:if test="${hasFoodRow}">
                            <tr class="group-row"><td colspan="6">หมวดภัตตาหาร</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                                    <tr class="item-row-data">
                                        <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <span class="item-desc">${d.item.itemDetail}</span>
                                        </td>
                                        <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${d.item.pricePerUnit}" pattern="#,###.00"/></td>
                                        <td style="text-align:right;" class="amount-cell"><fmt:formatNumber value="${d.subtotal}" pattern="#,###.00"/></td>
                                        <td>
                                            <c:if test="${q.quotationStatus != 'Confirmed'}">
                                                <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                                <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องอาหารชุดนี้ (ถ้ามี)...">
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <%-- หมวดสังฆทาน (โชว์เฉพาะเมื่อมีรายการจริง) --%>
                        <c:if test="${hasSangkathanRow}">
                            <tr class="group-row"><td colspan="6">หมวดสังฆทาน</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                                    <tr class="item-row-data">
                                        <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                        <td>
                                            <span class="item-name">${d.item.itemName}</span>
                                            <span class="item-desc">${d.item.itemDetail}</span>
                                        </td>
                                        <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${d.item.pricePerUnit}" pattern="#,###.00"/></td>
                                        <td style="text-align:right;" class="amount-cell"><fmt:formatNumber value="${d.subtotal}" pattern="#,###.00"/></td>
                                        <td>
                                            <c:if test="${q.quotationStatus != 'Confirmed'}">
                                                <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                                <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์เพิ่มเรื่องสังฆทานชุดนี้ (ถ้ามี)...">
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <%-- หมวดบริการและการดำเนินการ (โชว์เฉพาะเมื่อมีรายการจริง) --%>
                        <c:if test="${hasServiceRow}">
                            <tr class="group-row"><td colspan="6">หมวดบริการและการดำเนินการ</td></tr>
                            <c:forEach var="d" items="${details}">
                                <c:if test="${d.item != null && d.item.itemName != packageName && d.item.itemType.itemTypeName.contains('บริการ')}">
                                    <tr class="item-row-data">
                                        <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                        <td><span class="item-name">${d.item.itemName}</span></td>
                                        <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${d.item.pricePerUnit}" pattern="#,###.00"/></td>
                                        <td style="text-align:right;" class="amount-cell"><fmt:formatNumber value="${d.subtotal}" pattern="#,###.00"/></td>
                                        <td>
                                            <c:if test="${q.quotationStatus != 'Confirmed'}">
                                                <input type="hidden" class="row-item-id" value="${d.item.itemId}">
                                                <input type="text" class="member-inline-input row-item-note" placeholder="พิมพ์แจ้งขอแก้ไข...">
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="total-section">
            <div class="total-amount">รวมทั้งสิ้น ฿ <fmt:formatNumber value="${q.totalAmount}" pattern="#,###.00"/></div>
        </div>

        <div class="action-section">
            <c:choose>
                <c:when test="${q.quotationStatus != 'Confirmed'}">
                    <div class="btn-flex-group">
                        <button type="button" class="btn-revise-submit" onclick="packAndSubmitReviseForm()">↩ ส่งข้อมูลแจ้งขอแก้ไขรายการ</button>
                        <button type="button" class="btn-confirm btn-confirm-custom" onclick="showConfirmModal()">✓ ยืนยันรายการจองนี้</button>
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

    <div class="back-link-wrap">
        <a href="${pageContext.request.contextPath}/home" class="back-link">← กลับสู่หน้าหลัก</a>
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

<%-- ========== FOOTER (เหมือนหน้า Home ทั้งสี/ขนาด/โครงสร้าง) ========== --%>
<footer class="site-footer">
    <div class="footer-top">
        <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
             style="display: block; width: 100%; height: 8px;">
            <rect width="1200" height="8" fill="url(#footerGrad)" />
            <defs>
                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                    <stop offset="0%" stop-color="rgba(217,164,65,0.15)" />
<stop offset="50%" stop-color="rgba(217,164,65,0.9)" />
<stop offset="100%" stop-color="rgba(217,164,65,0.15)" />
                </linearGradient>
            </defs>
        </svg>
    </div>
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
        const rows = document.querySelectorAll('.item-row-data');
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