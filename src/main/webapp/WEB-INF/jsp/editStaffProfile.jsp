<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>แก้ไขข้อมูลส่วนตัว - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/editStaffProfile.css">

</head>
<body>

    <div class="navbar">...</div>

    <div class="page-wrapper">
        <div class="profile-card">
            <div class="card-header">
                <h2>แก้ไขข้อมูลส่วนตัว</h2>
                <p>อัปเดตข้อมูลชื่อ เบอร์โทร และรหัสผ่านของคุณ</p>
            </div>

            <div class="card-body">
                <c:if test="${not empty success}">
                    <div class="alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert-error">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/staff/profile/update" method="post">
                    <input type="hidden" name="staffId" value="${staff.staffId}">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">ชื่อ</label> 
                            <input type="text" name="staffFirstName" class="form-control" value="${staff.staffFirstName}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">นามสกุล</label> 
                            <input type="text" name="staffLastName" class="form-control" value="${staff.staffLastName}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">อีเมล (ไม่สามารถแก้ไขได้)</label> 
                        <input type="email" name="staffEmail" class="form-control form-control-readonly" value="${staff.staffEmail}" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label">เบอร์โทรศัพท์</label> 
                        <input type="text" name="staffPhone" class="form-control" value="${staff.staffPhone}" maxlength="10" required>
                    </div>

                    <hr class="divider">

                    <div class="form-group">
                        <label class="form-label">รหัสผ่านใหม่ (ปล่อยว่างถ้าไม่ต้องการเปลี่ยน)</label> 
                        <input type="password" name="staffPassword" class="form-control" placeholder="ระบุรหัสผ่านใหม่ 8 ตัวขึ้นไป">
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-submit">บันทึกการแก้ไข</button>
                        <a href="${pageContext.request.contextPath}/staff/assignments" class="btn-back">ย้อนกลับ</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // ให้แจ้งเตือนหายไปเองหลัง 3 วินาที
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-success, .alert-error');
            alerts.forEach(a => a.style.display = 'none');
        }, 3000);
    </script>
</body>
</html>