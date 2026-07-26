<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>แก้ไขคำถาม - บุญมี รับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/addQuestion.css">
</head>
<body>
 
<!-- Navbar -->
<div class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมี รับจัดงานบุญ" class="lotus-icon">
        <span class="navbar-title">บุญมี รับจัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings" class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions" class="nav-item active">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation" class="nav-item">ใบเสนอราคา</a>
        </nav>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">A</div>
            <div class="user-detail">
                <span class="user-name">Admin Organizer</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item danger">
                     ออกจากระบบ
                </a>
            </div>
        </div>
    </div>
</div>


<!-- Content -->
<div class="page-wrapper">
    <div class="form-container">
 
        <!-- Card Header -->
        <div class="card-header-bar">
            <div class="header-ornament">
                <span class="orn-line"></span>
                <span class="orn-diamond-sm"></span>
                <span class="orn-diamond"></span>
                <span class="orn-diamond-sm"></span>
                <span class="orn-line"></span>
            </div>
            <div class="header-lotus">🪷</div>
            <span class="question-id-badge">ID: ${question.questionsId}</span>
            <h1>แก้ไขคำถาม</h1>
            <p>ปรับปรุงข้อความคำถามหรือเปลี่ยนประเภทพิธี</p>
            <div class="header-gold-line"></div>
        </div>
 
        <!-- Form Body -->
        <div class="card-body">
 
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
 
            <form action="${pageContext.request.contextPath}/organizer/questions/update"
                  method="post" class="form-section">
 
                <input type="hidden" name="questionsId" value="${question.questionsId}">
 
                <div class="section-label">ข้อมูลคำถาม</div>
 
                <div class="form-group">
                    <label for="questionsText">ข้อความคำถาม</label>
                    <input type="text" id="questionsText" name="questionsText"
                           value="${question.questionsText}" required/>
                </div>

                <%-- แก้ไข: เหลือ dropdown เดียวให้เลือกแค่ "ประเภทงาน" ไม่ต้องเลือกแพ็กเกจ
                     ระบบจะเลือกแพ็กเกจแรกของประเภทนั้นให้อัตโนมัติฝั่ง service
                     auto-select ค่าเดิมจาก question.ceremony.ceremonyType --%>
                <div class="form-group">
                    <label for="ceremonyType">ประเภทงาน</label>
                    <div class="select-wrapper">
                        <select id="ceremonyType" name="ceremonyType" required>
                            <option value="">-- เลือกประเภทงาน --</option>
                            <c:forEach var="type" items="${ceremonyTypes}">
                                <option value="${type}"
                                    ${question.ceremony != null && type == question.ceremony.ceremonyType ? 'selected' : ''}>${type}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
 
                <hr class="divider">
 
                <div class="form-actions">
                    <button type="submit" class="btn-submit">บันทึกการแก้ไข</button>
                    <button type="button" class="btn-cancel"
                            onclick="window.location.href='${pageContext.request.contextPath}/organizer/questions'">
                        ยกเลิก
                    </button>
                </div>
 
            </form>
        </div>
 
    </div>
</div>

<!-- Footer -->
<footer class="site-footer">
    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมี รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมี รับจัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับทีมงานและผู้ดูแลระบบ</p>
    </div>
   
</footer>
 
<script src="${pageContext.request.contextPath}/static/js/addHeadStaff.js"></script>
<script>
    function toggleDropdown() {
        document.getElementById('dropdownMenu').classList.toggle('show');
    }
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.user-info')) {
            document.getElementById('dropdownMenu').classList.remove('show');
        }
    });
</script>
</body>
</html>
