<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>เข้าสู่ระบบสมาชิก - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons สำหรับไอคอนรูปตา -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/loginMember.css">
    <style>
        .error-message {
            color: #dc3545;
            font-size: 11px; /* ปรับขนาดตัวหนังสือให้เล็กเท่าหน้าตะกี้ */
            margin-top: 4px;
            display: none;
            font-weight: normal; /* เอาตัวหนาออกเพื่อให้ดูซอฟต์ลง */
        }
        /* จัดตำแหน่งกล่องรหัสผ่านและไอคอนรูปตา */
        .password-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        .password-wrapper .login-input {
            width: 100%;
            padding-right: 45px; /* เว้นที่ไว้สำหรับไอคอน */
        }
        .toggle-password {
            position: absolute;
            right: 15px;
            background: none;
            border: none;
            cursor: pointer;
            color: #888;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }
        .toggle-password:hover {
            color: #333;
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="main-navbar">
        <a class="navbar-brand-wrap"
            href="${pageContext.request.contextPath}/home"
            style="text-decoration: none;">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
            <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </a>
    </nav>

    <!-- MAIN CONTENT -->
    <div class="page-wrapper">

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
                <div class="alert-login" style="background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 10px; border-radius: 5px; margin-bottom: 15px; font-size: 12px;"><%= errorMsg %></div>
            <% } %>

            <!-- FORM -->
            <form action="${pageContext.request.contextPath}/loginMember" method="post" class="login-form" onsubmit="return validateLoginForm();">

                <!-- อีเมล (memberemail) -->
                <div class="form-group">
                    <label class="login-label">อีเมล</label>
                    <input type="text" id="memberemail" name="memberemail" class="login-input" placeholder="example@email.com">
                    <div id="emailError" class="error-message"></div>
                </div>

                <!-- รหัสผ่าน (memberpassword) พร้อมปุ่มไอคอนรูปตา -->
                <div class="form-group">
                    <label class="login-label">รหัสผ่าน</label>
                    <div class="password-wrapper">
                        <input type="password" id="memberpassword" name="memberpassword" class="login-input" placeholder="รหัสผ่าน 8-16 ตัวอักษร">
                        <button type="button" id="togglePasswordBtn" class="toggle-password" onclick="togglePasswordVisibility()">
                            <i class="bi bi-eye-slash" id="eyeIcon"></i>
                        </button>
                    </div>
                    <div id="passwordError" class="error-message"></div>
                </div>

                <button type="submit" class="btn-login">เข้าสู่ระบบ →</button>

                <div class="or-divider">หรือ</div>

                <div class="footer-links">
                    <a href="${pageContext.request.contextPath}/home" class="back-link">← กลับหน้าหลัก</a>
                    <a href="${pageContext.request.contextPath}/register" class="footer-link"><b>สมัครสมาชิก</b></a>
                </div>

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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- สคริปต์ตรวจสอบฟอร์ม และฟังก์ชันสลับการแสดงรหัสผ่าน -->
    <script>
        // ฟังก์ชันสลับการแสดง/ซ่อนรหัสผ่าน
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('memberpassword');
            const eyeIcon = document.getElementById('eyeIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                eyeIcon.classList.remove('bi-eye-slash');
                eyeIcon.classList.add('bi-eye'); // เปลี่ยนเป็นรูปตาเปิด
            } else {
                passwordInput.type = 'password';
                eyeIcon.classList.remove('bi-eye');
                eyeIcon.classList.add('bi-eye-slash'); // เปลี่ยนเป็นรูปตาปิด
            }
        }

        function validateLoginForm() {
            const emailInput = document.getElementById('memberemail').value.trim();
            const passwordInput = document.getElementById('memberpassword').value;
            
            const emailError = document.getElementById('emailError');
            const passwordError = document.getElementById('passwordError');

            // เคลียร์ข้อความแจ้งเตือนเดิมก่อนตรวจสอบ
            emailError.style.display = 'none';
            emailError.innerHTML = '';
            passwordError.style.display = 'none';
            passwordError.innerHTML = '';

            let isValid = true;

            // --- 1. ตรวจสอบอีเมล (memberemail) ---
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            const hasNumberInEmail = /\d/.test(emailInput);

            if (emailInput === "") {
                emailError.innerHTML = "กรุณากรอกอีเมล";
                emailError.style.display = 'block';
                isValid = false;
            } else if (/\s/.test(emailInput)) {
                emailError.innerHTML = "อีเมลต้องไม่มีช่องว่าง";
                emailError.style.display = 'block';
                isValid = false;
            } else if (!emailRegex.test(emailInput) || !hasNumberInEmail) {
                emailError.innerHTML = "อีเมลต้องประกอบด้วยตัวอักษรภาษาอังกฤษ ตัวเลข และอักขระพิเศษที่ถูกต้อง(@, .)";
                emailError.style.display = 'block';
                isValid = false;
            }

            // --- 2. ตรวจสอบรหัสผ่าน (memberpassword) ---
            const passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$/;

            if (passwordInput === "") {
                passwordError.innerHTML = "กรุณากรอกรหัสผ่าน";
                passwordError.style.display = 'block';
                isValid = false;
            } else if (/\s/.test(passwordInput)) {
                passwordError.innerHTML = "รหัสผ่านต้องไม่มีเว้นวรรค หรือช่องว่าง";
                passwordError.style.display = 'block';
                isValid = false;
            } else if (passwordInput.length < 8 || passwordInput.length > 16) {
                passwordError.innerHTML = "รหัสผ่านต้องมีความยาวตั้งแต่ 8 ตัวอักษร และไม่เกิน 16 ตัวอักษร";
                passwordError.style.display = 'block';
                isValid = false;
            } else if (!passwordRegex.test(passwordInput)) {
                passwordError.innerHTML = "ต้องเป็นตัวอักษรภาษาอังกฤษหรือตัวเลข รวมอักขระพิเศษได้เท่านั้น";
                passwordError.style.display = 'block';
                isValid = false;
            }

            return isValid;
        }
    </script>
</body>
</html>