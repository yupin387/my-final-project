<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>รายการ Item - ระบบรับจัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/itemList.css">
</head>
<body>

    <%-- Flash Attribute --%>
    <c:if test="${not empty success}">
        <span id="flash-success" data-msg="${success}" style="display:none;"></span>
    </c:if>
    <c:if test="${not empty error}">
        <span id="flash-error" data-msg="${error}" style="display:none;"></span>
    </c:if>

    <%-- Navbar --%>
    <div class="navbar">
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">รายการงาน</a>
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
    </div>

    <div class="page-wrapper">

        <div class="list-header">
            <div>
                <h1>รายการ Item</h1>
                <p>จัดการอุปกรณ์และบริการทั้งหมดในระบบ</p>
            </div>
            <a href="${pageContext.request.contextPath}/staff/items/add" class="btn-add">+ เพิ่ม Item</a>
        </div>

        <div class="tabs-wrapper">
            <a href="?typeId=all"
                class="tab-btn ${(empty selectedType or selectedType eq 'all') ? 'active' : ''}">ทั้งหมด</a>
            <c:forEach var="type" items="${itemTypes}">
                <a href="?typeId=${type.itemTypeId}"
                    class="tab-btn ${selectedType.toString() eq type.itemTypeId.toString() ? 'active' : ''}">
                    ${type.itemTypeName}
                </a>
            </c:forEach>
        </div>

        <div class="content-card">
            <div class="card-header-bar">
                <span>รายการอุปกรณ์และบริการ</span>
                <span class="header-count">จำนวนทั้งหมด ${items.size()} รายการ</span>
            </div>
            <table>
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
                                <c:forEach var="c" items="${item.ceremonies}">
                                    <span class="ceremony-tag">${c.ceremonyName}</span>
                                </c:forEach>
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

    <div class="modal-overlay" id="confirmModal">
        <div class="modal-box">
            <div class="modal-icon">🗑️</div>
            <div class="modal-title">ยืนยันการลบ</div>
            <div class="modal-desc">คุณต้องการลบรายการนี้ใช่หรือไม่?<br>การกระทำนี้ไม่สามารถย้อนกลับได้</div>
            <div class="modal-actions">
                <button class="modal-btn-cancel" onclick="closeModal()">ยกเลิก</button>
                <button class="modal-btn-confirm" onclick="confirmDelete()">ยืนยันลบ</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/itemList.js"></script>
</body>
</html>
