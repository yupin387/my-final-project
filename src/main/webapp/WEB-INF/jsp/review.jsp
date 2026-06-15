<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รีวิวการจัดงานบุญ - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/review.css">
</head>
<body>

<%-- ========== NAVBAR ========== --%>
<div class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="navbar-title">
        <span class="navbar-logo">🪷</span>
        ระบบรับจัดงานบุญ
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/home"         class="nav-item">หน้าหลัก</a>
            <a href="${pageContext.request.contextPath}/latestBooking" class="nav-item">การจอง</a>
            <a href="${pageContext.request.contextPath}/reviews"       class="nav-item active">รีวิว</a>
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
                <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-item">โปรไฟล์ของฉัน</a>
                <a href="${pageContext.request.contextPath}/logout"      class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</div>

<%-- ========== PAGE ========== --%>
<div class="page-wrapper">
    <div class="review-card">

        <%-- Header --%>
        <div class="review-card-header">
            <h2>รีวิวการจัดงานบุญ</h2>
            <div class="booking-badge">รหัสการจอง #${b.bookingId}</div>
            <div class="ceremony-name">${b.ceremony.ceremonyName}</div>
        </div>

        <%-- Body --%>
        <div class="review-card-body">
            <form action="${pageContext.request.contextPath}/review/save"
                  method="post"
                  enctype="multipart/form-data">

                <input type="hidden" name="bookingId" value="${b.bookingId}">

                <%-- ดาว --%>
                <div class="form-group star-section">
                    <span class="section-label">ระดับความพึงพอใจ</span>
                    <div class="star-rating">
                        <input type="radio" id="s5" name="rating" value="5" required>
                        <label for="s5">&#9733;</label>
                        <input type="radio" id="s4" name="rating" value="4">
                        <label for="s4">&#9733;</label>
                        <input type="radio" id="s3" name="rating" value="3">
                        <label for="s3">&#9733;</label>
                        <input type="radio" id="s2" name="rating" value="2">
                        <label for="s2">&#9733;</label>
                        <input type="radio" id="s1" name="rating" value="1">
                        <label for="s1">&#9733;</label>
                    </div>
                </div>

                <hr class="divider">

                <%-- อัปโหลดรูป --%>
                <div class="form-group">
                    <span class="section-label">แนบรูปภาพบรรยากาศงาน</span>
                    <div class="upload-area">
                        <input type="file" name="imageFile" id="imageFile" accept="image/*">
                        <div class="upload-icon">&#128247;</div>
                        <div class="upload-text">คลิกเพื่อเลือกรูปภาพ</div>
                        <div class="upload-hint">รองรับ JPG, PNG (ไม่บังคับ)</div>
                    </div>
                </div>

                <%-- ความคิดเห็น --%>
                <div class="form-group">
                    <span class="section-label">
                        ความคิดเห็นเพิ่มเติม <span style="color:#c62828;">*</span>
                    </span>
                    <textarea name="comment" class="form-control" rows="4"
                        placeholder="เล่าความประทับใจจากการใช้บริการ..." required></textarea>
                </div>

                <%-- ปุ่ม --%>
                <div class="form-actions">
                    <button type="submit" class="btn-submit">ส่งรีวิว</button>
                    <a href="${pageContext.request.contextPath}/home" class="btn-skip">ไว้คราวหลัง</a>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/review.js"></script>
</body>
</html>
