<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>แก้ไขข้อมูลส่วนตัว - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/editStaffProfile.css?v=2">
</head>
<body>

    <%-- ===== NAVBAR ===== --%>
    <nav class="navbar-custom">
        <div class="navbar-brand-wrap">
            <div class="navbar-lotus">🪷</div>
            <span class="navbar-title">ระบบรับจัดงานบุญ</span>
        </div>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">รายการงาน</a>
                <a href="${pageContext.request.contextPath}/staff/items"       class="nav-item">จัดการ Item</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile"    class="dropdown-item active">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <%-- ===== CONTENT ===== --%>
    <div class="page-wrapper">
        <div class="profile-card">

            <div class="card-header">
                <div class="card-header-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <h2>แก้ไขข้อมูลส่วนตัว</h2>
                <p>อัปเดตข้อมูลชื่อ เบอร์โทร และรหัสผ่านของคุณ</p>
            </div>

            <div class="card-body">

                <c:if test="${not empty success}">
                    <div class="alert-success">✓ ${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert-error">⚠ ${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/profile/update" method="post">
                    <input type="hidden" name="staffId" value="${staff.staffId}">

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">ชื่อ</label>
                            <input type="text" name="staffFirstName" class="form-control"
                                   value="${staff.staffFirstName}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">นามสกุล</label>
                            <input type="text" name="staffLastName" class="form-control"
                                   value="${staff.staffLastName}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">อีเมล (ไม่สามารถแก้ไขได้)</label>
                        <input type="email" name="staffEmail" class="form-control form-control-readonly"
                               value="${staff.staffEmail}" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label">เบอร์โทรศัพท์</label>
                        <input type="text" name="staffPhone" class="form-control"
                               value="${staff.staffPhone}" maxlength="10" required>
                    </div>

                    <hr class="divider">

                    <div class="form-group">
                        <label class="form-label">รหัสผ่านใหม่ (ปล่อยว่างถ้าไม่ต้องการเปลี่ยน)</label>
                        <input type="password" name="staffPassword" class="form-control"
                               placeholder="ระบุรหัสผ่านใหม่ 8 ตัวขึ้นไป">
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/staff/assignments" class="btn-back">← ย้อนกลับ</a>
                        <button type="submit" class="btn-submit">บันทึกการแก้ไข</button>
                    </div>
                </form>

            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/updateStatus.js"></script>
    
</body>
</html>
