<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>เพิ่มรายการอุปกรณ์ - ระบบรับจัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/addItem.css">
</head>
<body>

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
                        
                    </div>
                    <span class="arrow">▾</span>
                </div>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile"    class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <%-- PAGE --%>
    <div class="page-wrapper">
        <div class="content-card">

            <div class="card-header-bar">
                <h1>เพิ่มรายการอุปกรณ์ใหม่</h1>
                <p>ระบุรายละเอียดไอเทมและประเภทพิธีที่สามารถใช้งานได้</p>
            </div>

            <div class="card-body">

                <c:if test="${not empty error}">
                    <div class="alert error">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/items/save" method="post" class="form-section">

                    <%-- ประเภท Item --%>
                    <div class="form-group">
                        <div class="section-label">ประเภท Item</div>
                        <div class="type-options">
                            <c:forEach var="t" items="${itemTypes}">
                                <input type="radio" name="typeId" value="${t.itemTypeId}" id="type_${t.itemTypeId}" required>
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
                                    <input type="checkbox" name="ceremonyIds" value="${c.ceremonyId}" id="cer_${c.ceremonyId}">
                                    <label for="cer_${c.ceremonyId}" class="ceremony-check-label">${c.ceremonyName}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <hr class="divider">

                    <%-- รายละเอียดอุปกรณ์ --%>
                    <div class="form-group">
                        <div class="section-label">รายละเอียดอุปกรณ์</div>
                        <div style="display:flex; flex-direction:column; gap:12px;">
                            <div class="form-group">
                                <label>ชื่อ Item</label>
                                <input type="text" name="itemName" placeholder="เช่น ชุดสายสิญจน์มงคล" required value="${param.itemName}">
                            </div>
                            <div class="form-group">
                                <label>คำอธิบายเพิ่มเติม</label>
                                <textarea name="itemDetail" placeholder="คำอธิบายเพิ่มเติมเกี่ยวกับอุปกรณ์...">${param.itemDetail}</textarea>
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
                                <input type="number" name="pricePerUnit" placeholder="0.00" step="0.01" required value="${param.pricePerUnit}">
                            </div>
                            <div class="form-group">
                                <label>หน่วยนับ</label>
                                <select name="unit" required>
                                    <option value="">-- เลือกหน่วย --</option>
                                    <option value="ชุด"     ${param.unit == 'ชุด'     ? 'selected' : ''}>ชุด</option>
                                    <option value="ชิ้น"    ${param.unit == 'ชิ้น'    ? 'selected' : ''}>ชิ้น</option>
                                    <option value="โหล"     ${param.unit == 'โหล'     ? 'selected' : ''}>โหล</option>
                                    <option value="เครื่อง" ${param.unit == 'เครื่อง' ? 'selected' : ''}>เครื่อง</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <hr class="divider">

                    <div class="form-actions">
                        <button type="submit" class="btn-submit">บันทึกอุปกรณ์</button>
                        <button type="button" class="btn-cancel"
                            onclick="window.location.href='${pageContext.request.contextPath}/staff/items'">ยกเลิก</button>
                    </div>

                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/itemList.js"></script>
</body>
</html>
