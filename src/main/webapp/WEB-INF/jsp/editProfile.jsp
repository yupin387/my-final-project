<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>แก้ไขข้อมูลส่วนตัว - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/editProfile.css">
</head>
<body>

<%-- Flash Attributes --%>
<c:if test="${not empty success}">
    <span id="flash-success" data-msg="${success}" style="display:none;"></span>
</c:if>
<c:if test="${not empty error}">
    <span id="flash-error" data-msg="${error}" style="display:none;"></span>
</c:if>

<%-- ========== NAVBAR ========== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home">
        <div class="lotus-icon">🪷</div>
        <span class="nav-brand-text">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home"                     class="nav-link-item">หน้าหลัก</a>
        <a href="${pageContext.request.contextPath}/latestBooking"            class="nav-link-item">การจอง</a>
        <a href="${pageContext.request.contextPath}/member/quotation/list"    class="nav-link-item">ใบเสนอราคา</a>
        <a href="${pageContext.request.contextPath}/reviews"                  class="nav-link-item">รีวิว</a>
    </div>
    <div class="dropdown-wrap">
        <div class="user-profile-pill" onclick="toggleDropdown()">
            <div class="avatar-circle-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
            <div class="user-info-text">
                <span class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
                <span class="user-role-nav">สมาชิก</span>
            </div>
        </div>
        <div class="dropdown-menu-custom" id="dropdownMenu">
            <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-link active">โปรไฟล์ของฉัน</a>
            <a href="${pageContext.request.contextPath}/logout"      class="dropdown-link danger">ออกจากระบบ</a>
        </div>
    </div>
</nav>

<%-- ========== WAVE DIVIDER หลัง NAVBAR ========== --%>
<svg class="navbar-wave" viewBox="0 0 1200 36" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none">
    <path d="M0,36 L1200,36 L1200,10 Q1100,32 1000,14 Q900,0 800,20 Q700,36 600,16 Q500,0 400,22 Q300,36 200,16 Q100,2 0,18 Z" fill="#FFFBF0"/>
    <path d="M0,22 Q100,8 200,22 Q300,36 400,22 Q500,8 600,22 Q700,36 800,22 Q900,8 1000,22 Q1100,36 1200,22" stroke="#D4A017" stroke-width="1.2" fill="none" opacity="0.5"/>
    <circle cx="200"  cy="22" r="2.5" fill="#D4A017" opacity="0.6"/>
    <circle cx="400"  cy="22" r="2.5" fill="#D4A017" opacity="0.6"/>
    <circle cx="600"  cy="22" r="3"   fill="#D4A017" opacity="0.6"/>
    <circle cx="800"  cy="22" r="2.5" fill="#D4A017" opacity="0.6"/>
    <circle cx="1000" cy="22" r="2.5" fill="#D4A017" opacity="0.6"/>
</svg>

<%-- Flash Banner --%>
<div id="flash-banner-container"></div>

<%-- ========== PAGE ========== --%>
<div class="page-wrapper">

    <%-- Profile Banner --%>
    <div class="profile-banner">
        <div class="banner-ornament">
            <div class="orn-line"></div>
            <div class="orn-diamond-sm"></div>
            <div class="orn-diamond"></div>
            <div class="orn-diamond-sm"></div>
            <div class="orn-line right"></div>
        </div>
        <div class="profile-banner-content">
            <div class="avatar-circle">
                ${fn:substring(member.memberFirstName, 0, 1)}
            </div>
            <div>
                <div class="profile-name">${member.memberFirstName} ${member.memberLastName}</div>
                <div class="profile-email">${member.memberEmail}</div>
            </div>
            <div class="banner-lotus">🪷</div>
        </div>
    </div>

    <%-- Form Card --%>
    <div class="form-card">
        <div class="form-card-header">
            <span class="header-text">แก้ไขข้อมูลส่วนตัว</span>
            <span class="form-card-subtitle">จัดการข้อมูลให้เป็นปัจจุบัน</span>
        </div>
        <div class="form-card-body">
            <form action="${pageContext.request.contextPath}/updateProfile" method="post">
                <input type="hidden" name="memberId" value="${member.memberId}">

                <%-- ชื่อ + นามสกุล --%>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">ชื่อ <span class="required">*</span></label>
                        <input type="text" name="memberFirstName" class="form-control"
                               value="${member.memberFirstName}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">นามสกุล <span class="required">*</span></label>
                        <input type="text" name="memberLastName" class="form-control"
                               value="${member.memberLastName}" required>
                    </div>
                </div>

                <%-- เบอร์โทร + อีเมล --%>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">เบอร์โทรศัพท์ <span class="required">*</span></label>
                        <input type="text" name="phoneNumber" class="form-control"
                               value="${member.phoneNumber}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">อีเมล</label>
                        <input type="email" name="memberEmail" class="form-control"
                               value="${member.memberEmail}" readonly>
                        <span class="form-hint">ไม่สามารถเปลี่ยนแปลงอีเมลได้</span>
                    </div>
                </div>

                <%-- Divider --%>
                <div class="section-divider">
                    <hr><span>เปลี่ยนรหัสผ่าน (ถ้าต้องการ)</span><hr>
                </div>

                <%-- รหัสผ่านใหม่ --%>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">รหัสผ่านใหม่</label>
                        <input type="password" name="newPassword" id="newPassword" class="form-control"
                               placeholder="8-16 ตัวอักษร">
                        <span class="form-hint">เว้นว่างไว้หากไม่ต้องการเปลี่ยนรหัสผ่าน</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label">ยืนยันรหัสผ่านใหม่</label>
                        <input type="password" id="confirmPassword" class="form-control"
                               placeholder="กรอกรหัสผ่านอีกครั้ง">
                    </div>
                </div>

                <%-- Actions --%>
                <div class="form-actions">
                    <button type="button" class="btn-cancel"
                            onclick="location.href='${pageContext.request.contextPath}/home'">ยกเลิก</button>
                    <button type="submit" class="btn-save">✓ &nbsp;บันทึกการเปลี่ยนแปลง</button>
                </div>
            </form>
        </div>
    </div>

    <%-- ========== KANOK DIVIDER ========== --%>
    <svg class="kanok-footer" viewBox="0 0 1200 32" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none">
        <line x1="0" y1="16" x2="1200" y2="16" stroke="#E8CC70" stroke-width="1" opacity="0.5"/>
        <g fill="#D4A017" opacity="0.45">
            <ellipse cx="600" cy="16" rx="18" ry="6" transform="rotate(-30 600 16)"/>
            <ellipse cx="600" cy="16" rx="18" ry="6" transform="rotate(30 600 16)"/>
            <ellipse cx="600" cy="16" rx="18" ry="6"/>
            <circle  cx="600" cy="16" r="4"   fill="#E8BB3A"/>
            <ellipse cx="480" cy="16" rx="12" ry="4.5" transform="rotate(-30 480 16)"/>
            <ellipse cx="480" cy="16" rx="12" ry="4.5" transform="rotate(30 480 16)"/>
            <circle  cx="480" cy="16" r="3"   fill="#E8BB3A"/>
            <ellipse cx="720" cy="16" rx="12" ry="4.5" transform="rotate(-30 720 16)"/>
            <ellipse cx="720" cy="16" rx="12" ry="4.5" transform="rotate(30 720 16)"/>
            <circle  cx="720" cy="16" r="3"   fill="#E8BB3A"/>
            <ellipse cx="360" cy="16" rx="8"  ry="3"   transform="rotate(-30 360 16)"/>
            <ellipse cx="360" cy="16" rx="8"  ry="3"   transform="rotate(30 360 16)"/>
            <ellipse cx="840" cy="16" rx="8"  ry="3"   transform="rotate(-30 840 16)"/>
            <ellipse cx="840" cy="16" rx="8"  ry="3"   transform="rotate(30 840 16)"/>
        </g>
    </svg>

</div>

<script src="${pageContext.request.contextPath}/static/js/editProfile.js"></script>
<script>
    function toggleDropdown() {
        document.getElementById('dropdownMenu').classList.toggle('show');
    }
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.dropdown-wrap')) {
            document.getElementById('dropdownMenu').classList.remove('show');
        }
    });
</script>
</body>
</html>
