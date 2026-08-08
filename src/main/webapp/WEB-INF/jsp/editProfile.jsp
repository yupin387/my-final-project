<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>แก้ไขข้อมูลส่วนตัว - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
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
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
        <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
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



</div>

<%-- ========== FOOTER ========== --%>
<footer class="site-footer">
    <div class="footer-top">
        <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
            style="display: block; width: 100%; height: 8px;">
        <rect width="1200" height="8" fill="url(#footerGrad)" />
        <defs>
            <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%" stop-color="rgba(217,164,65,0.15)" />
                <stop offset="50%" stop-color="rgba(217,164,65,0.9)" />
                <stop offset="100%" stop-color="rgba(217,164,65,0.15)" />
            </linearGradient>
        </defs>
        </svg>
    </div>
    <div class="container footer-content footer-content-slim">
        <div class="footer-col footer-brand-col">
            <div class="footer-brand">
                <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                     alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon footer-lotus-icon">
                <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
            </div>
            <p class="footer-tagline">รับจัดงานบุญ ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
            <div class="footer-social">
                <a href="#" class="footer-social-link">📘 Facebook</a>
                <a href="#" class="footer-social-link">▶️ YouTube</a>
                <a href="#" class="footer-social-link">💬 LINE OA</a>
            </div>
        </div>

        <div class="footer-col footer-contact-col">
            <h4 class="footer-heading">ติดต่อเรา</h4>
            <p>📞 โทร. 08X-XXX-XXXX</p>
            <p>💬 LINE OA: @boonmee</p>
            <p>✉️ boonmee@gmail.com</p>
            <p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
        </div>
    </div>
  
</footer>

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