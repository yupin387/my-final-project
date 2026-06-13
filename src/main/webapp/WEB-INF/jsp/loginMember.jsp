<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>เข้าสู่ระบบสมาชิก - ระบบรับจัดงานบุญ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/loginMember.css">
</head>
<body>

    <!-- NAVBAR -->
    <div class="main-navbar">
        <span class="nav-title">ระบบรับจัดงานบุญ</span>
    </div>

    <div class="container">
        <div class="login-card">

            <!-- Title -->
            <div class="card-header-section">
                <h4 class="title-main">เข้าสู่ระบบสมาชิก</h4>
                <p class="subtitle-muted">กรุณากรอกข้อมูลเพื่อเข้าใช้งานระบบ</p>
            </div>

            <div class="divider-label">กรอกข้อมูลด้านล่าง</div>

            <%-- แสดง error จาก Spring (ถ้ามี) --%>
            <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                if (errorMsg != null) {
            %>
                <div class="alert-login"> <%= errorMsg %></div>
            <% } %>

            <!-- FORM -->
            <form action="/loginMember" method="post" class="text-start">

                <!-- อีเมล -->
                <div class="mb-3">
                    <label class="login-label">อีเมล</label>
                    <input type="email" name="memberemail" class="login-input" placeholder="example@email.com" required>
                </div>

                <!-- รหัสผ่าน -->
                <div class="mb-4">
                    <label class="login-label">รหัสผ่าน</label>
                    <input type="password" name="memberpassword" class="login-input" placeholder="รหัสผ่าน 8-16 ตัวอักษร" minlength="8" maxlength="16" required>
                </div>

                <!-- Submit -->
                <button type="submit" class="btn-login">เข้าสู่ระบบ →</button>

                <!-- OR divider -->
                <div class="or-divider">หรือ</div>

                <!-- สมัครสมาชิก -->
                <div class="text-center mb-2">
                    <a href="/register" class="footer-link">ยังไม่เป็นสมาชิก? <b>สมัครสมาชิกที่นี่</b></a>
                </div>

                <!-- ลิงก์ไปหน้าออแกไนเซอร์ -->
                <div class="text-center mb-3">
                    <a href="${pageContext.request.contextPath}/loginorganizer" class="footer-link">
                        สำหรับออแกไนเซอร์? <b>เข้าสู่ระบบผู้จัดงานที่นี่</b>
                    </a>
                </div>

                <!-- กลับหน้าหลัก -->
                <div class="text-center mt-1">
                    <a href="${pageContext.request.contextPath}/home" class="back-link">← กลับหน้าหลัก</a>
                </div>

            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
