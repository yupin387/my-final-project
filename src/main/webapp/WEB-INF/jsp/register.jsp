<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>สมัครสมาชิกใหม่ - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons สำหรับไอคอนรูปตา -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/register.css">
    <style>
        .error-message {
            color: #dc3545;
            font-size: 11px; /* ปรับขนาดตัวหนังสือให้เล็กเท่ากัน */
            margin-top: 4px;
            display: none;
            font-weight: normal; /* เอาตัวหนาออกเพื่อให้ดูซอฟต์ลง */
        }
        .password-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        .password-wrapper .reg-input {
            width: 100%;
            padding-right: 45px;
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

        <div class="reg-card">

            <div class="card-lotus-top">🪷</div>

            <div class="card-header-section">
                <h4 class="title-main">สมัครสมาชิกใหม่</h4>
                <p class="subtitle-muted">กรอกข้อมูลเพื่อเข้าถึงฟังก์ชันเฉพาะสมาชิก</p>
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
            <form action="${pageContext.request.contextPath}/saveMember" method="post" onsubmit="return validateRegisterForm();">

                <div class="row-grid">
                    <!-- ชื่อ (memberfirstname) -->
                    <div class="form-group">
                        <label class="reg-label">ชื่อ</label>
                        <input type="text" id="memberFirstName" name="memberFirstName" class="reg-input" placeholder="ชื่อจริง">
                        <div id="firstNameError" class="error-message"></div>
                    </div>
                    <!-- นามสกุล (memberlastname) -->
                    <div class="form-group">
                        <label class="reg-label">นามสกุล</label>
                        <input type="text" id="memberLastName" name="memberLastName" class="reg-input" placeholder="นามสกุล">
                        <div id="lastNameError" class="error-message"></div>
                    </div>
                </div>

                <!-- เบอร์โทรศัพท์ (phonenumber) -->
                <div class="form-group">
                    <label class="reg-label">เบอร์โทรศัพท์</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" class="reg-input" placeholder="0XXXXXXXXX" maxlength="10">
                    <div id="phoneError" class="error-message"></div>
                </div>

                <!-- อีเมล (memberemail) -->
                <div class="form-group">
                    <label class="reg-label">อีเมล</label>
                    <input type="text" id="memberEmail" name="memberEmail" class="reg-input" placeholder="example@mail.com">
                    <div id="emailError" class="error-message"></div>
                </div>

                <!-- รหัสผ่าน (memberpassword) -->
                <div class="form-group">
                    <label class="reg-label">รหัสผ่าน</label>
                    <div class="password-wrapper">
                        <input type="password" id="memberPassword" name="memberPassword" class="reg-input" placeholder="8-16 ตัวอักษร">
                        <button type="button" class="toggle-password" onclick="togglePassword('memberPassword', 'eye1')">
                            <i class="bi bi-eye-slash" id="eye1"></i>
                        </button>
                    </div>
                    <div id="passwordError" class="error-message"></div>
                </div>

                <!-- ยืนยันรหัสผ่าน -->
                <div class="form-group">
                    <label class="reg-label">ยืนยันรหัสผ่าน</label>
                    <div class="password-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="reg-input" placeholder="กรอกรหัสผ่านอีกครั้ง">
                        <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword', 'eye2')">
                            <i class="bi bi-eye-slash" id="eye2"></i>
                        </button>
                    </div>
                    <div id="confirmError" class="error-message"></div>
                </div>

                <button type="submit" class="btn-reg">สมัครสมาชิก →</button>

                <div class="or-divider">หรือ</div>

                <div class="footer-links">
                    <a href="${pageContext.request.contextPath}/home" class="back-link">← กลับหน้าหลัก</a>
                </div>

            </form>
        </div>
    </div>

    <!-- FOOTER STRIP -->
    <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;">
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
    
    <!-- สคริปต์ตรวจสอบเงื่อนไขทั้งหมด -->
    <script>
        function togglePassword(fieldId, iconId) {
            const inputField = document.getElementById(fieldId);
            const eyeIcon = document.getElementById(iconId);
            if (inputField.type === 'password') {
                inputField.type = 'text';
                eyeIcon.classList.remove('bi-eye-slash');
                eyeIcon.classList.add('bi-eye');
            } else {
                inputField.type = 'password';
                eyeIcon.classList.remove('bi-eye');
                eyeIcon.classList.add('bi-eye-slash');
            }
        }

        function validateRegisterForm() {
            const firstName = document.getElementById('memberFirstName').value.trim();
            const lastName = document.getElementById('memberLastName').value.trim();
            const phone = document.getElementById('phoneNumber').value.trim();
            const email = document.getElementById('memberEmail').value.trim();
            const password = document.getElementById('memberPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            const firstNameError = document.getElementById('firstNameError');
            const lastNameError = document.getElementById('lastNameError');
            const phoneError = document.getElementById('phoneError');
            const emailError = document.getElementById('emailError');
            const passwordError = document.getElementById('passwordError');
            const confirmError = document.getElementById('confirmError');

            // เคลียร์ค่า error ทั้งหมดก่อน
            [firstNameError, lastNameError, phoneError, emailError, passwordError, confirmError].forEach(el => {
                el.style.display = 'none';
                el.innerHTML = '';
            });

            let isValid = true;

            // 1. ตรวจสอบชื่อ (memberfirstname)
            const nameRegex = /^[a-zA-Zก-๙\s]+$/;
            if (firstName === "") {
                firstNameError.innerHTML = "กรุณากรอกชื่อ";
                firstNameError.style.display = 'block';
                isValid = false;
            } else if (!nameRegex.test(firstName) || /\d/.test(firstName)) {
                firstNameError.innerHTML = "ชื่อต้องเป็นตัวอักษรภาษาไทยหรือภาษาอังกฤษเท่านั้น";
                firstNameError.style.display = 'block';
                isValid = false;
            } else if (firstName.length < 2 || firstName.length > 100) {
                firstNameError.innerHTML = "ชื่อต้องมีความยาวไม่น้อยกว่า 2 ตัวอักษร และไม่เกิน 100 ตัวอักษร";
                firstNameError.style.display = 'block';
                isValid = false;
            }

            // 2. ตรวจสอบนามสกุล (memberlastname)
            if (lastName === "") {
                lastNameError.innerHTML = "กรุณากรอกนามสกุล";
                lastNameError.style.display = 'block';
                isValid = false;
            } else if (!nameRegex.test(lastName) || /\d/.test(lastName)) {
                lastNameError.innerHTML = "นามสกุลต้องเป็นตัวอักษรภาษาไทยหรือภาษาอังกฤษเท่านั้น";
                lastNameError.style.display = 'block';
                isValid = false;
            }

            // 3. ตรวจสอบเบอร์โทรศัพท์ (phonenumber)
            const phoneRegex = /^0\d{9}$/;
            if (phone === "") {
                phoneError.innerHTML = "กรุณากรอกเบอร์โทรศัพท์";
                phoneError.style.display = 'block';
                isValid = false;
            } else if (/\s/.test(phone)) {
                phoneError.innerHTML = "เบอร์โทรศัพท์ต้องไม่มีช่องว่าง";
                phoneError.style.display = 'block';
                isValid = false;
            } else if (!phoneRegex.test(phone)) {
                phoneError.innerHTML = "เบอร์โทรศัพท์ต้องเป็นตัวเลข 10 หลัก และขึ้นต้นด้วยเลข 0 เท่านั้น";
                phoneError.style.display = 'block';
                isValid = false;
            }

            // 4. ตรวจสอบอีเมล (memberemail)
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            const hasNumberInEmail = /\d/.test(email);
            if (email === "") {
                emailError.innerHTML = "กรุณากรอกอีเมล";
                emailError.style.display = 'block';
                isValid = false;
            } else if (/\s/.test(email)) {
                emailError.innerHTML = "อีเมลต้องไม่มีช่องว่าง";
                emailError.style.display = 'block';
                isValid = false;
            } else if (!emailRegex.test(email) || !hasNumberInEmail) {
                emailError.innerHTML = "อีเมลต้องมีรูปแบบที่ถูกต้อง และต้องประกอบด้วยตัวอักษรภาษาอังกฤษ ตัวเลข และอักขระพิเศษ (@, .)";
                emailError.style.display = 'block';
                isValid = false;
            }

            // 5. ตรวจสอบรหัสผ่าน (memberpassword)
            const passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$/;
            if (password === "") {
                passwordError.innerHTML = "กรุณากรอกรหัสผ่าน";
                passwordError.style.display = 'block';
                isValid = false;
            } else if (/\s/.test(password)) {
                passwordError.innerHTML = "รหัสผ่านต้องไม่มีเว้นวรรค หรือช่องว่าง";
                passwordError.style.display = 'block';
                isValid = false;
            } else if (password.length < 8 || password.length > 16) {
                passwordError.innerHTML = "รหัสผ่านต้องมีความยาวตั้งแต่ 8 ตัวอักษร และไม่เกิน 16 ตัวอักษร";
                passwordError.style.display = 'block';
                isValid = false;
            } else if (!passwordRegex.test(password)) {
                passwordError.innerHTML = "รหัสผ่านต้องเป็นตัวอักษรภาษาอังกฤษหรือตัวเลข รวมอักขระพิเศษได้เท่านั้น";
                passwordError.style.display = 'block';
                isValid = false;
            }

            // 6. ตรวจสอบยืนยันรหัสผ่าน
            if (confirmPassword === "") {
                confirmError.innerHTML = "กรุณายืนยันรหัสผ่าน";
                confirmError.style.display = 'block';
                isValid = false;
            } else if (password !== confirmPassword) {
                confirmError.innerHTML = "รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน";
                confirmError.style.display = 'block';
                isValid = false;
            }

            return isValid;
        }
    </script>
</body>
</html>