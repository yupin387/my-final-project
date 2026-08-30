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
<style>
/* =====================================================================
   FIX: ตัวกรอง (ประเภทอุปกรณ์ / ประเภทงาน) เปลี่ยนจาก <select> ธรรมดา
   เป็น dropdown แบบเดียวกับหน้ารายการจอง (bookingList) — กล่องคลิกเปิด/ปิด
   พร้อมจุดสีบอกหมวด, ใช้ <a href="..."> ต่อรายการเพื่อคง state ของ
   ตัวกรองอีกตัวไว้ (ไม่ล้างค่ากันเอง) ตรงตาม pattern เดิมของ bookingList
   ===================================================================== */
.filter-wrapper {
    display: flex;
    flex-wrap: wrap;
    gap: 16px;
    margin-bottom: 24px;
}

.status-filter-group {
    position: relative;
    display: flex;
    align-items: center;
    gap: 10px;
    background: var(--white);
    border: 1.5px solid var(--card-border);
    border-radius: 30px;
    padding: 8px 18px;
    box-shadow: 0 3px 10px var(--shadow-soft);
}

.status-filter-label {
    font-size: 13px;
    font-weight: 700;
    color: var(--brown-muted);
    white-space: nowrap;
}

.status-filter-box {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    min-width: 190px;
    padding: 8px 16px;
    background: var(--peach-pale);
    border: 1.5px solid var(--accent-pink);
    border-radius: 22px;
    cursor: pointer;
    font-weight: 700;
    font-size: 14px;
    color: var(--brown-text);
    user-select: none;
    transition: box-shadow 0.2s;
}
.status-filter-box:hover { box-shadow: 0 3px 10px var(--shadow-soft); }

.status-filter-current {
    display: flex;
    align-items: center;
    gap: 8px;
}

.status-filter-arrow {
    font-size: 10px;
    color: var(--accent-pink);
    flex-shrink: 0;
}

.status-filter-dropdown {
    display: none;
    position: absolute;
    top: calc(100% + 8px);
    left: 0;
    min-width: 240px;
    background: var(--white);
    border: 1.5px solid var(--card-border);
    border-radius: 14px;
    box-shadow: 0 10px 28px var(--shadow-soft);
    z-index: 500;
    overflow: hidden;
}
.status-filter-dropdown.show { display: block; }

.status-filter-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 11px 16px;
    text-decoration: none;
    color: var(--brown-text);
    font-size: 14px;
    font-weight: 600;
    border-bottom: 1px solid var(--bg-light);
    transition: background 0.15s;
}
.status-filter-item:last-child { border-bottom: none; }
.status-filter-item:hover { background: var(--peach-pale); }
.status-filter-item.selected {
    background: var(--accent-pink-pale);
    color: var(--accent-pink);
    font-weight: 700;
}

.dot-sm {
    width: 9px;
    height: 9px;
    border-radius: 50%;
    display: inline-block;
    flex-shrink: 0;
}
.dot-type-all { background: var(--accent-pink); }
.dot-type     { background: var(--gold-primary); }
</style>
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
        <c:set var="curCeremony" value="${empty selectedCeremonyType ? 'all' : selectedCeremonyType}" />

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
                    <a href="${pageContext.request.contextPath}/staff/items?typeId=all&ceremonyType=${curCeremony}"
                       class="status-filter-item ${curType == 'all' ? 'selected' : ''}">
                        <span class="dot-sm dot-type-all"></span> ทั้งหมด
                    </a>
                    <c:forEach var="t" items="${itemTypes}">
                        <a href="${pageContext.request.contextPath}/staff/items?typeId=${t.itemTypeId}&ceremonyType=${curCeremony}"
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
                            <c:when test="${curCeremony == 'all'}">
                                <span class="dot-sm dot-type-all"></span> ทั้งหมด
                            </c:when>
                            <c:when test="${curCeremony == 'ทำบุญบ้าน'}">
                                <span class="dot-sm dot-home"></span> ${curCeremony}
                            </c:when>
                            <c:when test="${curCeremony == 'ขึ้นบ้านใหม่'}">
                                <span class="dot-sm dot-newhome"></span> ${curCeremony}
                            </c:when>
                            <c:when test="${curCeremony == 'ทำบุญบริษัทหรือออฟฟิศ'}">
                                <span class="dot-sm dot-company"></span> ${curCeremony}
                            </c:when>
                            <c:otherwise>
                                <span class="dot-sm dot-type"></span> ${curCeremony}
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span class="status-filter-arrow" id="ceremonyArrow">▾</span>
                </div>
                <div class="status-filter-dropdown" id="ceremonyDropdown">
                    <a href="${pageContext.request.contextPath}/staff/items?typeId=${curType}&ceremonyType=all"
                       class="status-filter-item ${curCeremony == 'all' ? 'selected' : ''}">
                        <span class="dot-sm dot-type-all"></span> ทั้งหมด
                    </a>
                    <c:forEach var="cType" items="${ceremonyTypeOrder}">
                        <a href="${pageContext.request.contextPath}/staff/items?typeId=${curType}&ceremonyType=${cType}"
                           class="status-filter-item ${curCeremony == cType ? 'selected' : ''}">
                            <c:choose>
                                <c:when test="${cType == 'ทำบุญบ้าน'}">
                                    <span class="dot-sm dot-home"></span>
                                </c:when>
                                <c:when test="${cType == 'ขึ้นบ้านใหม่'}">
                                    <span class="dot-sm dot-newhome"></span>
                                </c:when>
                                <c:when test="${cType == 'ทำบุญบริษัทหรือออฟฟิศ'}">
                                    <span class="dot-sm dot-company"></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="dot-sm dot-type"></span>
                                </c:otherwise>
                            </c:choose>
                            ${cType}
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

    <%-- ========== CONFIRM DELETE MODAL ========== --%>
    <div class="modal-overlay" id="confirmModal">
        <div class="modal-box">
            <div class="modal-title">ยืนยันการลบ</div>
            <div class="modal-desc">คุณต้องการลบรายการนี้ใช่หรือไม่?<br>เมื่อทำการลบแล้วไม่สามารถย้อนกลับได้</div>
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

    /* ===== ตัวกรอง: เปิด/ปิด dropdown แบบเดียวกับหน้ารายการจอง ===== */
    function toggleFilter(dropdownId, arrowId) {
        var dropdown = document.getElementById(dropdownId);
        var arrow = document.getElementById(arrowId);
        var isOpen = dropdown.classList.contains('show');

        // ปิด dropdown ตัวกรองอื่นก่อนเสมอ กันเปิดซ้อนกันสองอัน
        document.querySelectorAll('.status-filter-dropdown.show').forEach(function (el) {
            el.classList.remove('show');
        });
        document.querySelectorAll('.status-filter-arrow').forEach(function (el) {
            el.textContent = '▾';
        });

        if (!isOpen) {
            dropdown.classList.add('show');
            arrow.textContent = '▴';
        }
    }
    document.addEventListener('click', function (e) {
        if (!e.target.closest('.status-filter-group')) {
            document.querySelectorAll('.status-filter-dropdown.show').forEach(function (el) {
                el.classList.remove('show');
            });
            document.querySelectorAll('.status-filter-arrow').forEach(function (el) {
                el.textContent = '▾';
            });
        }
    });
    </script>
</body>
</html>
