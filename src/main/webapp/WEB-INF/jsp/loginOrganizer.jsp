<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>เข้าสู่ระบบ - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/loginOrganizer.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="main-navbar">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">🪷</div>
        <span class="nav-brand-text">ระบบรับจัดงานบุญ</span>
    </a>
</nav>

<!-- THAI WAVE DIVIDER -->
<svg viewBox="0 0 1200 36" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="display:block;width:100%;height:36px;background:#3D2500;">
    <path d="M0,8 Q150,32 300,14 Q450,-4 600,18 Q750,36 900,16 Q1050,-4 1200,14 L1200,36 L0,36 Z" fill="#FFFBF0"/>
    <path d="M0,22 Q100,8 200,22 Q300,36 400,22 Q500,8 600,22 Q700,36 800,22 Q900,8 1000,22 Q1100,36 1200,22" stroke="#D4A017" stroke-width="1.2" fill="none" opacity="0.5"/>
    <circle cx="200" cy="22" r="2.5" fill="#D4A017" opacity="0.5"/>
    <circle cx="400" cy="22" r="2.5" fill="#D4A017" opacity="0.5"/>
    <circle cx="600" cy="22" r="2.5" fill="#D4A017" opacity="0.5"/>
    <circle cx="800" cy="22" r="2.5" fill="#D4A017" opacity="0.5"/>
    <circle cx="1000" cy="22" r="2.5" fill="#D4A017" opacity="0.5"/>
</svg>

<!-- MAIN CONTENT -->
<div class="page-wrapper">

    <div class="section-ornament">
        <div class="ornament-line"></div>
        <div class="ornament-diamond-sm"></div>
        <div class="ornament-diamond"></div>
        <div class="ornament-diamond-sm"></div>
        <div class="ornament-line right"></div>
    </div>

    <div class="login-card">

        <div class="card-lotus-top">🪷</div>

        <div class="card-header-section">
            <h4 class="title-main">เข้าสู่ระบบ Organizer</h4>
            <p class="subtitle-muted">โปรดระบุข้อมูลเพื่อจัดการระบบงานบุญ</p>
            <div class="gold-line"></div>
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
            <div class="alert-login">⚠️ ${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert-success">✓ ${success}</div>
        </c:if>

        <!-- Form Organizer -->
        <form id="form-organizer"
              action="${pageContext.request.contextPath}/loginorganizer"
              method="post" class="login-form">

            <div class="form-group">
                <label class="login-label">อีเมล</label>
                <input type="email" name="email" class="login-input" placeholder="example@mail.com" required>
            </div>

            <div class="form-group">
                <label class="login-label">รหัสผ่าน</label>
                <div class="input-wrapper">
                    <input type="password" id="password" name="password" class="login-input" placeholder="รหัสผ่าน 8-16 ตัวอักษร" required>
                    <button type="button" class="toggle-visibility" onclick="togglePassword('password', this)">👁</button>
                </div>
            </div>

            <button type="submit" class="btn-login">เข้าสู่ระบบ →</button>
        </form>

        <!-- Form HeadStaff -->
        <form id="form-headstaff"
              action="${pageContext.request.contextPath}/loginheadstaff"
              method="post" class="login-form" style="display:none;">

            <div class="form-group">
                <label class="login-label">อีเมล</label>
                <input type="email" name="email" class="login-input" placeholder="example@mail.com" required>
            </div>

            <div class="form-group">
                <label class="login-label">รหัสผ่าน</label>
                <div class="input-wrapper">
                    <input type="password" id="password2" name="password" class="login-input" placeholder="รหัสผ่าน 8-16 ตัวอักษร" required>
                    <button type="button" class="toggle-visibility" onclick="togglePassword('password2', this)">👁</button>
                </div>
            </div>

            <button type="submit" class="btn-login">เข้าสู่ระบบ →</button>
        </form>

        <div class="or-divider">หรือ</div>

        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/loginMember" class="footer-link">
                สำหรับสมาชิก? <b>เข้าสู่ระบบสมาชิกที่นี่</b>
            </a>
            <a href="${pageContext.request.contextPath}/home" class="back-link">← กลับหน้าหลัก</a>
        </div>

    </div>
</div>

<!-- FOOTER STRIP -->
<svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;">
    <rect width="1200" height="8" fill="url(#footerGrad)"/>
    <defs>
        <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
            <stop offset="0%"   stop-color="#3D2500"/>
            <stop offset="25%"  stop-color="#D4A017"/>
            <stop offset="50%"  stop-color="#E8BB3A"/>
            <stop offset="75%"  stop-color="#D4A017"/>
            <stop offset="100%" stop-color="#3D2500"/>
        </linearGradient>
    </defs>
</svg>

<script src="${pageContext.request.contextPath}/static/js/loginOrganizer.js"></script>
</body>
</html>
