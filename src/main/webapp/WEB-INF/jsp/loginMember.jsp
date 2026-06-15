<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>เข้าสู่ระบบสมาชิก - ระบบรับจัดงานบุญ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/loginMember.css">
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

        <!-- Section ornament -->
        <div class="section-ornament">
            <div class="ornament-line"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-diamond"></div>
            <div class="ornament-diamond-sm"></div>
            <div class="ornament-line right"></div>
        </div>

        <div class="login-card">

            <!-- Lotus top decoration -->
            <div class="card-lotus-top">🪷</div>

            <!-- Title -->
            <div class="card-header-section">
                <h4 class="title-main">เข้าสู่ระบบสมาชิก</h4>
                <p class="subtitle-muted">กรุณากรอกข้อมูลเพื่อเข้าใช้งานระบบ</p>
                <div class="gold-line"></div>
            </div>

            <%-- แสดง error จาก Spring (ถ้ามี) --%>
            <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                if (errorMsg != null) {
            %>
                <div class="alert-login">⚠️ <%= errorMsg %></div>
            <% } %>

            <!-- FORM -->
            <form action="/loginMember" method="post" class="login-form">

                <div class="form-group">
                    <label class="login-label">อีเมล</label>
                    <input type="email" name="memberemail" class="login-input" placeholder="example@email.com" required>
                </div>

                <div class="form-group">
                    <label class="login-label">รหัสผ่าน</label>
                    <input type="password" name="memberpassword" class="login-input" placeholder="รหัสผ่าน 8-16 ตัวอักษร" minlength="8" maxlength="16" required>
                </div>

                <button type="submit" class="btn-login">เข้าสู่ระบบ →</button>

                <div class="or-divider">หรือ</div>

                <div class="footer-links">
                    <a href="/register" class="footer-link">ยังไม่เป็นสมาชิก? <b>สมัครสมาชิกที่นี่</b></a>
                    <a href="${pageContext.request.contextPath}/loginorganizer" class="footer-link">
                        สำหรับออแกไนเซอร์? <b>เข้าสู่ระบบผู้จัดงานที่นี่</b>
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="back-link">← กลับหน้าหลัก</a>
                </div>

            </form>
        </div>

    </div>

    <!-- FOOTER STRIP -->
    <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;margin-top:auto;">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
