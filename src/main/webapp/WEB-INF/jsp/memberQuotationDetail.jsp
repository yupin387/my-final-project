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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/memberQuotationDetail.css?v=2">
</head>
<body>

<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">🪷</div>
        <span class="nav-brand-text">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home"          class="nav-link-item">หน้าหลัก</a>
        <a href="${pageContext.request.contextPath}/latestBooking" class="nav-link-item">การจอง</a>
        <a href="${pageContext.request.contextPath}/quotation"     class="nav-link-item active">ใบเสนอราคา</a>
        <a href="${pageContext.request.contextPath}/reviews"       class="nav-link-item">รีวิว</a>
    </div>
    <div class="user-profile-pill">
        <div class="avatar-circle-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
        <div class="user-info-text">
            <span class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
            <span class="user-role-nav">สมาชิก</span>
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

        <div class="info-grid-section">
            <div class="info-line"><strong>ประเภทพิธี:</strong> ${q.bookingForm.ceremony.ceremonyName}</div>
            <div class="info-line" style="text-align:right;"><strong>วันที่จัดงาน:</strong> <fmt:formatDate value="${q.bookingForm.eventDate}" pattern="dd/MM/yyyy"/></div>
            <div class="info-line"><strong>รหัสการจอง:</strong> ${q.bookingForm.bookingId}</div>
            <div class="info-line" style="text-align:right;"><strong>เวลาเริ่มงาน:</strong> ${q.bookingForm.eventTime} น.</div>
            <%-- 🟢 เพิ่มข้อมูลหัวหน้างานที่นี่ --%>
            <div class="info-line" style="grid-column: span 2; margin-top: 10px; border-top: 1px solid #eee; padding-top: 10px;">
                <strong>หัวหน้างานรับผิดชอบ:</strong> 
                <c:choose>
                    <c:when test="${not empty q.staff}">
                        ${q.staff.staffFirstName} ${q.staff.staffLastName} (โทร: ${q.staff.staffPhone})
                    </c:when>
                    <c:otherwise>อยู่ระหว่างการมอบหมายหัวหน้างาน</c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="section-wrap">
            <div class="section-title">รายละเอียดรายการอุปกรณ์และบริการ</div>
            
            <table>
                <thead>
                    <tr>
                        <th width="50" style="text-align:center;">ลำดับ</th>
                        <th>รายการวัสดุ/งานบริการ</th>
                        <th width="110" style="text-align:center;">จำนวน</th>
                        <th width="140" style="text-align:right;">รวมเงิน (฿)</th>
                        <th width="280">พิมพ์รายละเอียดแจ้งแก้ไขที่นี่</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="count" value="1"/>

                    <tr class="group-row"><td colspan="5">หมวดอุปกรณ์พิธีกรรม</td></tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType.itemTypeName.contains('อุปกรณ์')}">
                            <tr class="item-row-data">
                                <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    <span class="item-name">${d.item.itemName}</span>
                                    <span class="item-desc">${d.item.itemDetail}</span>
                                </td>
                                <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
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

                    <tr class="group-row"><td colspan="5">หมวดภัตตาหาร</td></tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType.itemTypeName.contains('ภัตตาหาร')}">
                            <tr class="item-row-data">
                                <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    <span class="item-name">${d.item.itemName}</span>
                                    <span class="item-desc">${d.item.itemDetail}</span>
                                </td>
                                <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
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
                    
                    <tr class="group-row"><td colspan="5">หมวดสังฆทาน</td></tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType.itemTypeName.contains('สังฆทาน')}">
                            <tr class="item-row-data">
                                <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td>
                                    <span class="item-name">${d.item.itemName}</span>
                                    <span class="item-desc">${d.item.itemDetail}</span>
                                </td>
                                <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
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

                    <tr class="group-row"><td colspan="5">หมวดบริการและการดำเนินการ</td></tr>
                    <c:forEach var="d" items="${details}">
                        <c:if test="${d.item != null && d.item.itemType.itemTypeName.contains('บริการ')}">
                            <tr class="item-row-data">
                                <td style="text-align:center; color:#aaa;">${count}</td> <c:set var="count" value="${count + 1}"/>
                                <td><span class="item-name">${d.item.itemName}</span></td>
                                <td style="text-align:center;">${d.quantity} ${d.item.unit}</td>
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
                </tbody>
            </table>
        </div>

        <div class="total-section">
            <div class="total-amount">฿ <fmt:formatNumber value="${q.totalAmount}" pattern="#,###.00"/></div>
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
</script>
</body>
</html>
