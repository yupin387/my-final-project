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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/review.css">
</head>
<body>

<%-- ========== NAVBAR ========== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
            alt="บุญมี รับจัดงานบุญ" class="lotus-icon">
        <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item">หน้าหลัก</a>
        <c:if test="${not empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/myBookings" class="nav-link-item">การจอง</a>
        
        </c:if>
        <a href="${pageContext.request.contextPath}/reviews" class="nav-link-item active">รีวิว</a>
        <c:if test="${empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/loginMember" class="nav-link-item">เข้าสู่ระบบ</a>
        </c:if>
    </div>
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <div class="dropdown-wrap">
                <div class="user-profile-pill" onclick="toggleDropdown()">
                    <div class="avatar-circle-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
                    <div class="user-info-text">
                        <span class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
                        <span class="user-role-nav">สมาชิก</span>
                    </div>
                </div>
                <div class="dropdown-menu-custom" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-link">โปรไฟล์ของฉัน</a>
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">ออกจากระบบ</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/register" class="btn-register-nav">สมัครสมาชิก</a>
        </c:otherwise>
    </c:choose>
</nav>

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
    alt="บุญมี รับจัดงานบุญ" class="lotus-icon">
                <span class="footer-brand-text">บุญมีนำพา รับจัดงานบุญ</span>
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

<script src="${pageContext.request.contextPath}/static/js/review.js"></script>
</body>
</html>
