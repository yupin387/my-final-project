<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>แก้ไขรายการอุปกรณ์ - ระบบรับจัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/editItem.css">
</head>
<body>

    <c:if test="${not empty success}">
        <span id="flash-success" data-msg="${success}" style="display:none;"></span>
    </c:if>
    <c:if test="${not empty error}">
        <span id="flash-error" data-msg="${error}" style="display:none;"></span>
    </c:if>

    <%-- NAVBAR --%>
    <nav class="navbar">
        <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/staff/assignments" style="text-decoration:none;">
            <div class="lotus-icon">🪷</div>
            <span class="nav-brand-text">ระบบรับจัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">รายการงาน</a>
                <a href="${pageContext.request.contextPath}/staff/items"       class="nav-item active">จัดการ Item</a>
            </nav>
            <div class="dropdown-wrap">
                <div class="user-info" onclick="toggleDropdown()">
                    <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                    <div class="user-detail">
                        <span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
                        <span class="user-role">Head Staff</span>
                    </div>
                    <span class="arrow">▾</span>
                </div>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile" class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/staff/logout"  class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <%-- PAGE --%>
    <div class="page-wrapper">
        <div class="content-card">

            <div class="card-header-bar">
                <h1>แก้ไขข้อมูลอุปกรณ์</h1>
                <p>แก้ไขรายละเอียดอุปกรณ์และบริการในระบบ</p>
            </div>

            <div class="card-body">

                <c:if test="${not empty error}">
                    <div class="alert error">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/items/save" method="post">
                    <input type="hidden" name="itemId" value="${item.itemId}">

                    <div class="form-section">

                        <%-- ประเภท Item --%>
                        <div class="form-group">
                            <div class="section-label">ประเภท Item</div>
                            <div class="type-options">
                                <c:forEach var="t" items="${itemTypes}">
                                    <input type="radio" name="typeId" value="${t.itemTypeId}"
                                        id="type_${t.itemTypeId}"
                                        ${item.itemType.itemTypeId == t.itemTypeId ? 'checked' : ''}
                                        required>
                                    <label for="type_${t.itemTypeId}" class="type-label">${t.itemTypeName}</label>
                                </c:forEach>
                            </div>
                        </div>

                        <hr class="divider">

                        <%-- ใช้กับพิธี --%>
                        <div class="form-group">
                            <div class="section-label">ใช้กับพิธีไหนได้บ้าง</div>
                            <div class="ceremony-box">
                                <c:forEach var="c" items="${ceremonies}">
                                    <div class="ceremony-item">
                                        <input type="checkbox" name="ceremonyIds"
                                            value="${c.ceremonyId}" id="cer_${c.ceremonyId}"
                                            <c:forEach var="ic" items="${item.ceremonies}">
                                                <c:if test="${ic.ceremonyId == c.ceremonyId}">checked</c:if>
                                            </c:forEach>>
                                        <label for="cer_${c.ceremonyId}" class="ceremony-check-label">${c.ceremonyName}</label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <hr class="divider">

                        <%-- ชื่อ & รายละเอียด --%>
                        <div class="form-group">
                            <div class="section-label">ข้อมูล Item</div>
                            <div style="display:flex; flex-direction:column; gap:12px;">
                                <div class="form-group">
                                    <label>ชื่ออุปกรณ์ / บริการ</label>
                                    <input type="text" name="itemName" value="${item.itemName}" required placeholder="ระบุชื่ออุปกรณ์หรือบริการ">
                                </div>
                                <div class="form-group">
                                    <label>รายละเอียด</label>
                                    <textarea name="itemDetail" placeholder="รายละเอียดเพิ่มเติม (ถ้ามี)">${item.itemDetail}</textarea>
                                </div>
                            </div>
                        </div>

                        <hr class="divider">

                        <%-- ราคา & หน่วย --%>
                        <div class="form-group">
                            <div class="section-label">ราคาและหน่วยนับ</div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label>ราคาต่อหน่วย (บาท)</label>
                                    <input type="number" name="pricePerUnit" value="${item.pricePerUnit}" step="0.01" required placeholder="0.00">
                                </div>
                                <div class="form-group">
                                    <label>หน่วยนับ</label>
                                    <select name="unit" required>
                                        <option value="ชุด"     ${item.unit == 'ชุด'     ? 'selected' : ''}>ชุด</option>
                                        <option value="ชิ้น"    ${item.unit == 'ชิ้น'    ? 'selected' : ''}>ชิ้น</option>
                                        <option value="โหล"     ${item.unit == 'โหล'     ? 'selected' : ''}>โหล</option>
                                        <option value="เครื่อง" ${item.unit == 'เครื่อง' ? 'selected' : ''}>เครื่อง</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <hr class="divider">

                        <div class="form-actions">
                            <button type="submit" class="btn-submit">บันทึกการแก้ไข</button>
                            <a href="${pageContext.request.contextPath}/staff/items" class="btn-cancel">ยกเลิก</a>
                        </div>

                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/editItem.js"></script>
</body>
</html>
