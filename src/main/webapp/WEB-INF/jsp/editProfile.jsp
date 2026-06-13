<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>แก้ไขข้อมูลส่วนตัว - ระบบรับจัดงานบุญ</title>
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
<div class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="navbar-title">ระบบรับจัดงานบุญ</a>

    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/home"          class="nav-item">หน้าหลัก</a>
            <a href="${pageContext.request.contextPath}/latestBooking"  class="nav-item">การจอง</a>
            <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-item">ใบเสนอราคา</a>
            <a href="${pageContext.request.contextPath}/reviews"        class="nav-item">รีวิว</a>
        </nav>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">
                ${fn:substring(sessionScope.user.memberFirstName, 0, 1)}
            </div>
            <div style="display:flex;flex-direction:column;line-height:1.2;">
                <span class="user-name">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
                <span class="user-role">สมาชิก</span>
            </div>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-item active">โปรไฟล์ของฉัน</a>
                <a href="${pageContext.request.contextPath}/logout"      class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</div>

<%-- Flash Banner --%>
<div id="flash-banner-container"></div>

<%-- ========== PAGE ========== --%>
<div class="page-wrapper">

    <%-- Profile Banner --%>
    <div class="profile-banner">
        <div class="avatar-circle">
            ${fn:substring(member.memberFirstName, 0, 1)}
        </div>
        <div>
            <div class="profile-name">${member.memberFirstName} ${member.memberLastName}</div>
            <div class="profile-email">${member.memberEmail}</div>
        </div>
    </div>

    <%-- Form Card --%>
    <div class="form-card">
        <div class="form-card-header">
            แก้ไขข้อมูลส่วนตัว
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
                    <button type="submit" class="btn-save">บันทึกการเปลี่ยนแปลง</button>
                </div>
            </form>
        </div>
    </div>

</div>

<script src="${pageContext.request.contextPath}/static/js/editProfile.js"></script>
</body>
</html>
