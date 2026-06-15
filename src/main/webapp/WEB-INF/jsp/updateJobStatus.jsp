<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>อัปเดตสถานะงาน - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/updateStatus.css?v=2">
</head>
<body>

    <%-- ===== NAVBAR ===== --%>
    <div class="navbar">
        <div class="navbar-brand-wrap">
            <div class="navbar-lotus">🪷</div>
            <span class="navbar-title">ระบบรับจัดงานบุญ</span>
        </div>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item active">รายการงาน</a>
                <a href="${pageContext.request.contextPath}/staff/items"       class="nav-item">จัดการ Item</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile"    class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </div>

    <%-- ===== CONTENT ===== --%>
    <div class="page-wrapper">
        <div class="status-card">

            <div class="card-header">
                <h2>อัปเดตสถานะงาน</h2>
                <p>เลือกสถานะปัจจุบันของงานพิธีกรรม</p>
            </div>

            <div class="card-body">
                <form action="${pageContext.request.contextPath}/staff/assignments/update-status/save" method="post">
                    <input type="hidden" name="bookingId" value="${b.bookingId}">

                    <div class="status-list">

                        <label class="status-option">
                            <input type="radio" name="jobStatus" value="Assigned"
                                   ${b.bookingStatus == 'Assigned' ? 'checked' : ''}>
                            <div class="text-group">
                                <strong><span class="dot" style="background:#94a3b8;"></span>มอบหมายงานแล้ว (Assigned)</strong>
                                <small>พนักงานรับทราบงานแล้ว รอเริ่มดำเนินการ</small>
                            </div>
                        </label>

                        <label class="status-option">
                            <input type="radio" name="jobStatus" value="Preparing"
                                   ${b.bookingStatus == 'Preparing' ? 'checked' : ''}>
                            <div class="text-group">
                                <strong><span class="dot" style="background:#f59e0b;"></span>กำลังเตรียมงาน (Preparing)</strong>
                                <small>จัดหาอุปกรณ์และของใช้สำหรับพิธีกรรม</small>
                            </div>
                        </label>

                        <label class="status-option">
                            <input type="radio" name="jobStatus" value="In_Progress"
                                   ${b.bookingStatus == 'In_Progress' ? 'checked' : ''}>
                            <div class="text-group">
                                <strong><span class="dot" style="background:#3b82f6;"></span>กำลังดำเนินการ (In Progress)</strong>
                                <small>พนักงานกำลังปฏิบัติงานที่สถานที่จัดงาน</small>
                            </div>
                        </label>

                        <label class="status-option">
                            <input type="radio" name="jobStatus" value="Completed"
                                   ${b.bookingStatus == 'Completed' ? 'checked' : ''}>
                            <div class="text-group">
                                <strong><span class="dot" style="background:#22c55e;"></span>เสร็จสิ้นงานบุญ (Completed)</strong>
                                <small>งานเสร็จสมบูรณ์ เคลียร์หน้างานเรียบร้อย</small>
                            </div>
                        </label>

                    </div>

                    <div class="footer-btns">
                        <a href="${pageContext.request.contextPath}/staff/assignments" class="btn btn-cancel">← ย้อนกลับ</a>
                        <button type="submit" class="btn btn-save">บันทึกสถานะ</button>
                    </div>
                </form>
            </div>

        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/updateStatus.js"></script>
</body>
</html>
