<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>เพิ่มหัวหน้างาน - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/addHeadStaff.css">
</head>
<body>

<!-- ========== NAVBAR ========== -->
<div class="navbar">
    <a href="${pageContext.request.contextPath}/organizer/bookings" class="navbar-brand">
        <div class="navbar-lotus">🪷</div>
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item active">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"  class="nav-item">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item">ใบเสนอราคา</a>
        </nav>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">A</div>
            <div class="user-detail">
                <span class="user-name">Admin Organizer</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <span class="arrow">▾</span>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item danger">
                    ออกจากระบบ
                </a>
            </div>
        </div>
    </div>
</div>

<!-- ========== PAGE WRAPPER ========== -->
<div class="page-wrapper">
    <div class="content-card">

        <!-- Header -->
        <div class="card-header-bar">
            <div class="card-header-orn">
                <div class="orn-line"></div>
                <div class="orn-ds"></div>
                <div class="orn-d"></div>
                <div class="orn-ds"></div>
                <div class="orn-line r"></div>
            </div>
            <h1>ลงทะเบียนหัวหน้างาน</h1>
            <p>กรอกข้อมูลเพื่อเพิ่มหัวหน้างานเข้าสู่ระบบ</p>
        </div>

        <!-- Form Body -->
        <div class="card-body">

            <c:if test="${not empty error}">
                <div class="alert error">⚠ ${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert success">✓ ${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/organizer/head-staff/add"
                  method="post" class="form-section">

                <div class="section-label">ข้อมูลส่วนตัว</div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">ชื่อ</label>
                        <input type="text" id="firstName" name="firstName"
                               placeholder="ชื่อจริง" required value="${param.firstName}"/>
                    </div>
                    <div class="form-group">
                        <label for="lastName">นามสกุล</label>
                        <input type="text" id="lastName" name="lastName"
                               placeholder="นามสกุล" required value="${param.lastName}"/>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">อีเมล</label>
                    <input type="email" id="email" name="email"
                           placeholder="staff@mail.com" required value="${param.email}"/>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="password">รหัสผ่าน</label>
                        <div class="input-wrapper">
                            <input type="password" id="password" name="password"
                                   placeholder="รหัสผ่าน 8-16 ตัวอักษร"
                                   minlength="8" maxlength="16" required/>
                            <button type="button" class="toggle-visibility"
                                    onclick="togglePassword('password', this)">👁</button>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="phone">เบอร์โทรศัพท์</label>
                        <input type="tel" id="phone" name="phone"
                               placeholder="0XXXXXXXXX"
                               pattern="0[0-9]{9}" maxlength="10" required
                               value="${param.phone}"/>
                    </div>
                </div>

                <hr class="divider">

                <div class="form-actions">
                    <button type="submit" class="btn-submit">✓ ยืนยันการเพิ่มหัวหน้างาน</button>
                    <button type="button" class="btn-cancel"
                            onclick="window.location.href='${pageContext.request.contextPath}/organizer/head-staff'">
                        ยกเลิก
                    </button>
                </div>

            </form>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/addHeadStaff.js"></script>

</body>
</html>
