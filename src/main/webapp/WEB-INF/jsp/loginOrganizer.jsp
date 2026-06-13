<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>เข้าสู่ระบบ - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/loginOrganizer.css">
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <span class="navbar-title">ระบบรับจัดงานบุญ</span>
 
</div>

<!-- Page Body -->
<div class="page-wrapper">
<div class="container">

    <div class="header">
        <h2>เข้าสู่ระบบ Organizer</h2>
        <p>โปรดระบุข้อมูลเพื่อจัดการระบบงานบุญ</p>
    </div>

    <!-- Role Selector -->
    <div class="role-label">— เลือกประเภทผู้ใช้งาน —</div>
    <div class="role-selector">
        <button type="button" class="role-btn active" id="btn-organizer"
                onclick="selectRole('organizer')">Organizer</button>
        <button type="button" class="role-btn" id="btn-headstaff"
                onclick="selectRole('headstaff')">Head Staff</button>
    </div>

    <!-- Alert -->
    <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert success">${success}</div>
    </c:if>

    <!-- Form Organizer -->
    <form id="form-organizer"
          action="${pageContext.request.contextPath}/loginorganizer"
          method="post" class="form-section">

        <div class="form-group">
            <label for="email">อีเมล (Email)</label>
            <input type="email" id="email" name="email" placeholder="example@mail.com" required />
        </div>

        <div class="form-group">
            <label for="password">รหัสผ่าน (Password)</label>
            <div class="input-wrapper">
                <input type="password" id="password" name="password" placeholder="รหัสผ่าน 8-16 ตัวอักษร" required />
                <button type="button" class="toggle-visibility" onclick="togglePassword('password', this)">👁</button>
            </div>
        </div>

        <button type="submit" class="btn-submit">เข้าสู่ระบบ →</button>
    </form>

    <!-- Form HeadStaff -->
    <form id="form-headstaff"
          action="${pageContext.request.contextPath}/loginheadstaff"
          method="post" class="form-section" style="display:none;">

        <div class="form-group">
            <label for="email2">อีเมล (Email)</label>
            <input type="email" id="email2" name="email"
                   placeholder="example@mail.com" required />
        </div>

        <div class="form-group">
            <label for="password2">รหัสผ่าน (Password)</label>
            <div class="input-wrapper">
                <input type="password" id="password2" name="password"
                       placeholder="รหัสผ่าน 8-16 ตัวอักษร" required />
                <button type="button" class="toggle-visibility"
                        onclick="togglePassword('password2', this)">👁</button>
            </div>
        </div>

        <button type="submit" class="btn-submit">เข้าสู่ระบบ →</button>
    </form>


<div class="back-link">
    <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; color: inherit;">
        ← กลับไปหน้าหลักสมาชิก
    </a>
</div>

</div>
</div>

<script src="${pageContext.request.contextPath}/static/js/loginOrganizer.js"></script>
</body>
</html>