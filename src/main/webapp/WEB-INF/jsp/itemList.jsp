<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>รายการอุปกรณ์ - บุญมีนำพา จัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/itemList.css?v=4">

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
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">งานที่ได้รับมอบหมาย</a>
                <a href="${pageContext.request.contextPath}/staff/items" class="nav-item active">จัดการรายการอุปกรณ์</a>
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
                <h1>รายการอุปกรณ์</h1>
                <p>จัดการอุปกรณ์และบริการทั้งหมดในระบบ</p>
                <div class="gold-line"></div>
            </div>
            <a href="${pageContext.request.contextPath}/staff/items/add" class="btn-add">+ เพิ่มอุปกรณ์</a>
        </div>

        <%-- ========== FILTER (แบบเดียวกับหน้ารายการจอง) ========== --%>
        <c:set var="curType" value="${empty selectedType ? 'all' : selectedType}" />
        <c:set var="curPackage" value="${empty selectedPackageType ? 'all' : selectedPackageType}" />

        <div class="filter-wrapper">

            <%-- ----- กรองตามประเภทอุปกรณ์ ----- --%>
            <div class="status-filter-group">
                <span class="status-filter-label">▼ ประเภทอุปกรณ์ :</span>
                <div class="status-filter-box" onclick="toggleFilter('typeDropdown', 'typeArrow')">
                    <span class="status-filter-current">
                        <c:choose>
                            <c:when test="${curType == 'all'}">
                                <span class="dot-sm dot-type-all"></span> ทั้งหมด
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="t" items="${itemTypes}">
                                    <c:if test="${t.itemTypeId.toString() == curType.toString()}">
                                        <span class="dot-sm dot-type"></span> ${t.itemTypeName}
                                    </c:if>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span class="status-filter-arrow" id="typeArrow">▾</span>
                </div>
                <div class="status-filter-dropdown" id="typeDropdown">
                    <a href="${pageContext.request.contextPath}/staff/items?typeId=all&packageType=${curPackage}"
                       class="status-filter-item ${curType == 'all' ? 'selected' : ''}">
                        <span class="dot-sm dot-type-all"></span> ทั้งหมด
                    </a>
                    <c:forEach var="t" items="${itemTypes}">
                        <a href="${pageContext.request.contextPath}/staff/items?typeId=${t.itemTypeId}&packageType=${curPackage}"
                           class="status-filter-item ${curType.toString() == t.itemTypeId.toString() ? 'selected' : ''}">
                            <span class="dot-sm dot-type"></span> ${t.itemTypeName}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <%-- ----- กรองตามประเภทงาน ----- --%>
            <div class="status-filter-group">
                <span class="status-filter-label">▼ ประเภทงาน :</span>
                <div class="status-filter-box" onclick="toggleFilter('ceremonyDropdown', 'ceremonyArrow')">
                    <span class="status-filter-current">
                        <c:choose>
                            <c:when test="${curPackage == 'all'}">
                                <span class="dot-sm dot-type-all"></span> ทั้งหมด
                            </c:when>
                            <c:when test="${curPackage == 'ทำบุญบ้าน'}">
                                <span class="dot-sm dot-home"></span> ${curPackage}
                            </c:when>
                            <c:when test="${curPackage == 'ขึ้นบ้านใหม่'}">
                                <span class="dot-sm dot-newhome"></span> ${curPackage}
                            </c:when>
                            <c:when test="${curPackage == 'ทำบุญบริษัทหรือออฟฟิศ'}">
                                <span class="dot-sm dot-company"></span> ${curPackage}
                            </c:when>
                            <c:otherwise>
                                <span class="dot-sm dot-type"></span> ${curPackage}
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span class="status-filter-arrow" id="ceremonyArrow">▾</span>
                </div>
                <div class="status-filter-dropdown" id="ceremonyDropdown">
                    <a href="${pageContext.request.contextPath}/staff/items?typeId=${curType}&packageType=all"
                       class="status-filter-item ${curPackage == 'all' ? 'selected' : ''}">
                        <span class="dot-sm dot-type-all"></span> ทั้งหมด
                    </a>
                    <c:forEach var="pType" items="${packageTypeOrder}">
                        <a href="${pageContext.request.contextPath}/staff/items?typeId=${curType}&packageType=${pType}"
                           class="status-filter-item ${curPackage == pType ? 'selected' : ''}">
                            <c:choose>
                                <c:when test="${pType == 'ทำบุญบ้าน'}">
                                    <span class="dot-sm dot-home"></span>
                                </c:when>
                                <c:when test="${pType == 'ขึ้นบ้านใหม่'}">
                                    <span class="dot-sm dot-newhome"></span>
                                </c:when>
                                <c:when test="${pType == 'ทำบุญบริษัทหรือออฟฟิศ'}">
                                    <span class="dot-sm dot-company"></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="dot-sm dot-type"></span>
                                </c:otherwise>
                            </c:choose>
                            ${pType}
                        </a>
                    </c:forEach>
                </div>
            </div>

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
                        <th width="35%">ชื่ออุปกรณ์</th>
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
                                <c:forEach var="t" items="${itemPackageTypes[item.itemId]}">
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
                                <c:if test="${empty itemPackageTypes[item.itemId]}">
                                    <span class="ceremony-tag ceremony-tag-none">ยังไม่ผูกกับพิธี</span>
                                </c:if>
                            </td>
                            <td>
                                <div class="action-links">
                                    <a href="${pageContext.request.contextPath}/staff/items/edit/${item.itemId}"
                                        class="btn-edit">แก้ไข</a>

                                    <form action="${pageContext.request.contextPath}/staff/items/delete/${item.itemId}"
                                          method="post" style="display:inline;"
                                          data-item-name="${item.itemName}"
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
    
<%-- ===== FOOTER ===== --%>
<footer class="site-footer">

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

    <div class="modal-overlay" id="confirmModal">
        <div class="modal-box">
            <div class="modal-title">ยืนยันการลบข้อมูล</div>
            <div class="modal-desc">คุณต้องการลบข้อมูลนี้ใช่หรือไม่?</div>
            <div class="modal-item-pill" id="modalItemName"></div>
            <div class="modal-desc-sub">การลบนี้ไม่สามารถย้อนกลับได้</div>
            <div class="modal-actions">
                <button class="modal-btn-cancel" onclick="closeModal()">ยกเลิก</button>
                <button class="modal-btn-confirm" onclick="confirmDelete()">ลบข้อมูล</button>
            </div>
        </div>
    </div>

 
    <script src="${pageContext.request.contextPath}/static/js/itemList.js"></script>

</body>
</html>