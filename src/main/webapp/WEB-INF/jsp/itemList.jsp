<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>รายการ Item - บุญมีนำพา จัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/itemList.css?v=3">
</head>
<body>

    <%-- Flash Attribute --%>
    <c:if test="${not empty success}">
        <span id="flash-success" data-msg="${success}" style="display:none;"></span>
    </c:if>
    <c:if test="${not empty error}">
        <span id="flash-error" data-msg="${error}" style="display:none;"></span>
    </c:if>

    <%-- ========== NAVBAR ========== --%>
    <nav class="navbar">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/assignments">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon">
            <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">รายการงานที่ได้รับมอบหมาย</a>
                <a href="${pageContext.request.contextPath}/staff/items" class="nav-item active">จัดการ Item</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile" class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <%-- ========== PAGE WRAPPER ========== --%>
    <div class="page-wrapper">

        <%-- ========== LIST HEADER ========== --%>
        <div class="list-header">
            <div>
                <div class="section-ornament">
                    <div class="ornament-line"></div>
                    <div class="ornament-diamond-sm"></div>
                    <div class="ornament-diamond"></div>
                    <div class="ornament-diamond-sm"></div>
                    <div class="ornament-line right"></div>
                </div>
                <h1>รายการ Item</h1>
                <p>จัดการอุปกรณ์และบริการทั้งหมดในระบบ</p>
                <div class="gold-line"></div>
            </div>
            <a href="${pageContext.request.contextPath}/staff/items/add" class="btn-add">+ เพิ่ม Item</a>
        </div>

        <%-- ========== FILTER — dropdown ประเภท Item + dropdown ประเภทงานพิธี (ทั้ง 3 ประเภท) ========== --%>
        <%-- FIX: เอาอิโมจิออกจากทั้งสอง dropdown ตามที่ขอ เหลือแค่ข้อความล้วน --%>
        <div class="filter-wrapper">
            <label for="typeFilter" class="filter-label">กรองตามประเภท:</label>
            <select id="typeFilter" class="filter-select" onchange="applyFilters()">
                <option value="all" ${(empty selectedType or selectedType eq 'all') ? 'selected' : ''}>
                    ทั้งหมด
                </option>
                <c:forEach var="type" items="${itemTypes}">
                    <option value="${type.itemTypeId}"
                        ${selectedType.toString() eq type.itemTypeId.toString() ? 'selected' : ''}>
                        ${type.itemTypeName}
                    </option>
                </c:forEach>
            </select>

            <%-- FIX: เพิ่มตัวกรองประเภทงานพิธีทั้ง 3 ประเภท (ทำบุญบ้าน / ขึ้นบ้านใหม่ / ทำบุญบริษัทหรือออฟฟิศ)
                 ใช้ ceremonyTypeOrder ที่ controller ส่งมา เพื่อให้ลำดับตรงกับที่ใช้ทั่วทั้งระบบ --%>
           <label for="ceremonyTypeFilter" class="filter-label">กรองตามประเภทงาน:</label>
            <select id="ceremonyTypeFilter" class="filter-select" onchange="applyFilters()">
                <option value="all" ${(empty selectedCeremonyType or selectedCeremonyType eq 'all') ? 'selected' : ''}>
                    ⚪ ทั้งหมด
                </option>
                <c:forEach var="cType" items="${ceremonyTypeOrder}">
                    <c:choose>
                        <c:when test="${cType eq 'ทำบุญบ้าน'}">
                            <option value="${cType}" ${selectedCeremonyType eq cType ? 'selected' : ''}>
                                🔴 ${cType}
                            </option>
                        </c:when>
                        <c:when test="${cType eq 'ขึ้นบ้านใหม่'}">
                            <option value="${cType}" ${selectedCeremonyType eq cType ? 'selected' : ''}>
                                🟢 ${cType}
                            </option>
                        </c:when>
                        <c:when test="${cType eq 'ทำบุญบริษัทหรือออฟฟิศ'}">
                            <option value="${cType}" ${selectedCeremonyType eq cType ? 'selected' : ''}>
                                🔵 ${cType}
                            </option>
                        </c:when>
                        <c:otherwise>
                            <option value="${cType}" ${selectedCeremonyType eq cType ? 'selected' : ''}>
                                ⚪ ${cType}
                            </option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </div>

        <%-- ========== CONTENT CARD ========== --%>
        <div class="content-card">
            <div class="card-header-bar">
                <span>รายการอุปกรณ์และบริการ</span>
                <span class="header-count">จำนวนทั้งหมด ${items.size()} รายการ</span>
            </div>
            <table class="table">
                <thead>
                    <tr>
                        <th width="35%">ชื่อ Item</th>
                        <th width="20%">ประเภท</th>
                        <th width="25%">ใช้กับพิธี</th>
                        <th width="20%">จัดการ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td class="item-name">${item.itemName}</td>
                            <td><span class="type-badge">${item.itemType.itemTypeName}</span></td>
                            <td>
                                <%-- FIX: เปลี่ยนจากอิโมจิเป็นจุดสี (เหมือนหน้าคำถาม) --%>
                                <c:forEach var="t" items="${itemCeremonyTypes[item.itemId]}">
                                    <c:choose>
                                        <c:when test="${t eq 'ทำบุญบ้าน'}">
                                            <span class="ceremony-dot ceremony-dot-lg dot-home" title="${t}"></span>
                                        </c:when>
                                        <c:when test="${t eq 'ขึ้นบ้านใหม่'}">
                                            <span class="ceremony-dot ceremony-dot-lg dot-newhome" title="${t}"></span>
                                        </c:when>
                                        <c:when test="${t eq 'ทำบุญบริษัทหรือออฟฟิศ'}">
                                            <span class="ceremony-dot ceremony-dot-lg dot-company" title="${t}"></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="ceremony-dot ceremony-dot-lg dot-all" title="${t}"></span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${empty itemCeremonyTypes[item.itemId]}">
                                    <span class="ceremony-tag ceremony-tag-none">ยังไม่ผูกกับพิธี</span>
                                </c:if>
                            </td>
                            <td>
                                <div class="action-links">
                                    <a href="${pageContext.request.contextPath}/staff/items/edit/${item.itemId}"
                                        class="btn-edit">แก้ไข</a>

                                    <form action="${pageContext.request.contextPath}/staff/items/delete/${item.itemId}"
                                          method="post" style="display:inline;"
                                          onsubmit="event.preventDefault(); showDeleteModal(this);">
                                        <button type="submit" class="btn-del">ลบ</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty items}">
                        <tr>
                            <td colspan="4" class="empty-state">ไม่พบรายการอุปกรณ์</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </div>
    
<%-- ===== Footer (สำหรับหัวหน้างาน) ===== --%>
<footer class="site-footer">

    <%-- ===== ลายดอกบัวมุมล่างขวา (เกาะติด footer) ===== --%>
    <img src="${pageContext.request.contextPath}/static/images/lotus-corner.png"
         alt="" class="lotus-decoration" aria-hidden="true">

    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับหัวหน้างาน</p>
    </div>

</footer>

    <%-- ========== CONFIRM DELETE MODAL ========== --%>
    <div class="modal-overlay" id="confirmModal">
        <div class="modal-box">
            <div class="modal-ornament">
                <div class="orn-line"></div>
                <div class="orn-diamond-sm"></div>
                <div class="orn-diamond"></div>
                <div class="orn-diamond-sm"></div>
                <div class="orn-line right"></div>
            </div>
            <div class="modal-title">ยืนยันการลบ</div>
            <div class="modal-desc">คุณต้องการลบรายการนี้ใช่หรือไม่?<br>การกระทำนี้ไม่สามารถย้อนกลับได้</div>
            <div class="modal-actions">
                <button class="modal-btn-cancel" onclick="closeModal()">ยกเลิก</button>
                <button class="modal-btn-confirm" onclick="confirmDelete()">ยืนยันลบ</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/itemList.js"></script>
    <script>
    function toggleDropdown() {
        document.getElementById('dropdownMenu').classList.toggle('show');
    }
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.user-info')) {
            document.getElementById('dropdownMenu').classList.remove('show');
        }
    });

    // FIX: รวมค่าจาก dropdown ทั้งสองตัว (ประเภท Item + ประเภทงานพิธี)
    // แล้ว navigate ไป URL เดียวที่มีทั้งสอง query param เพื่อให้กรองซ้อนกันได้
    function applyFilters() {
        var typeId = document.getElementById('typeFilter').value;
        var ceremonyType = document.getElementById('ceremonyTypeFilter').value;
        var base = '${pageContext.request.contextPath}/staff/items';
        location = base + '?typeId=' + encodeURIComponent(typeId)
                        + '&ceremonyType=' + encodeURIComponent(ceremonyType);
    }
    </script>
</body>
</html>