<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>เข้าสู่ระบบ - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/loginOrganizer.css">
</head>
<body>

    <!-- NAVBAR -->
    <nav class="main-navbar">
        <a class="navbar-brand-wrap"
            href="${pageContext.request.contextPath}/home"
            style="text-decoration: none;">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
            <span class="nav-brand-text">บุญมีนำพา
                จัดงานบุญ</span>
        </a>
    </nav>

    <!-- MAIN CONTENT -->
    <div class="page-wrapper">

        <div class="login-card">

            <div class="card-lotus-top">🪷</div>

            <div class="card-header-section">
                <h4 class="title-main">เข้าสู่ระบบผู้จัดงาน</h4>
                <p class="subtitle-muted">โปรดระบุข้อมูลเพื่อจัดการระบบงานบุญ</p>
                <div class="gold-line"></div>
            </div>

            <!-- Alert -->
            <c:if test="${not empty error}">
                <div class="alert-login">⚠️ ${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert-success">✓ ${success}</div>
            </c:if>

            <!-- Form Login (Organizer / Head Staff รวมกัน) -->
            <form id="form-login"
                  action="${pageContext.request.contextPath}/login"
                  method="post" class="login-form">

                <div class="form-group">
                    <label class="login-label">อีเมล</label>
                    <input type="email" name="email" class="login-input" placeholder="example@mail.com" required>
                </div>

                <div class="form-group">
                    <label class="login-label">รหัสผ่าน</label>
                    <input type="password" id="password" name="password" class="login-input" placeholder="รหัสผ่าน 8-16 ตัวอักษร" required>
                </div>

                <button type="submit" class="btn-login">เข้าสู่ระบบ →</button>
            </form>

        </div>
    </div>

    <!-- FOOTER STRIP -->
    <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;margin-top:auto;">
        <rect width="1200" height="8" fill="url(#footerGrad)"/>
        <defs>
            <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%"   stop-color="#6E1930"/>
                <stop offset="25%"  stop-color="#E0577F"/>
                <stop offset="50%"  stop-color="#F49CB9"/>
                <stop offset="75%"  stop-color="#E0577F"/>
                <stop offset="100%" stop-color="#6E1930"/>
            </linearGradient>
        </defs>
    </svg>

    <script src="${pageContext.request.contextPath}/static/js/loginOrganizer.js"></script>
</body>
</html>
