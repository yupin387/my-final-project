<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>สมัครสมาชิกใหม่ - ระบบรับจัดงานบุญ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/register.css">
</head>
<body>

    <!-- NAVBAR -->
    <div class="main-navbar">
        <span class="nav-title">ระบบรับจัดงานบุญ</span>
    </div>

    <div class="container">
        <div class="reg-card">

            <!-- Title -->
            <div class="card-header-section">
                <h4 class="title-main">สมัครสมาชิกใหม่</h4>
                <p class="subtitle-muted">กรอกข้อมูลเพื่อเข้าถึงฟังก์ชันเฉพาะสมาชิก</p>
            </div>

            <div class="divider-label">กรอกข้อมูลด้านล่าง</div>

            <!-- FORM -->
            <form action="${pageContext.request.contextPath}/saveMember" method="post" class="text-start">

                <!-- ชื่อ + นามสกุล -->
                <div class="row mb-3">
                    <div class="col">
                        <label class="reg-label">ชื่อ</label>
                        <input type="text" name="memberFirstName" class="reg-input" placeholder="ชื่อจริง" required>
                    </div>
                    <div class="col">
                        <label class="reg-label">นามสกุล</label>
                        <input type="text" name="memberLastName" class="reg-input" placeholder="นามสกุล" required>
                    </div>
                </div>

                <!-- เบอร์โทรศัพท์ -->
                <div class="mb-3">
                    <label class="reg-label">เบอร์โทรศัพท์</label>
                    <input type="text" name="phoneNumber" class="reg-input" placeholder="0XXXXXXXXX" maxlength="10" required>
                </div>

                <!-- อีเมล -->
                <div class="mb-3">
                    <label class="reg-label">อีเมล</label>
                    <input type="email" name="memberEmail" class="reg-input" placeholder="example@mail.com" required>
                </div>

                <!-- รหัสผ่าน -->
                <div class="mb-3">
                    <label class="reg-label">รหัสผ่าน</label>
                    <input type="password" name="memberPassword" id="memberPassword" class="reg-input" placeholder="8-16 ตัวอักษร" minlength="8" maxlength="16" required>
                </div>

                <!-- ยืนยันรหัสผ่าน -->
                <div class="mb-3">
                    <label class="reg-label">ยืนยันรหัสผ่าน</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" class="reg-input" placeholder="กรอกรหัสผ่านอีกครั้ง" minlength="8" maxlength="16" required>
                </div>

                <!-- Submit -->
                <button type="submit" class="btn-reg">สมัครสมาชิก →</button>

                <!-- Footer link -->
                <div class="footer-divider"></div>
                <div class="text-center">
                    <a href="/login" class="footer-link">มีบัญชีอยู่แล้ว? <b>เข้าสู่ระบบ</b></a>
                </div>

            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/register.js"></script>
</body>
</html>
