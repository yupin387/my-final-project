<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>เพิ่มคำถามพิธี - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/addQuestion.css">
</head>
<body>

<%-- ========== NAVBAR ========== --%>
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings">
        <div class="lotus-icon">🪷</div>
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <div class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"  class="nav-item active">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item">ใบเสนอราคา</a>
        </div>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">A</div>
            <div class="user-detail">
                <span class="user-name">Admin Organizer</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <span class="arrow">▾</span>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item">ออกจากระบบ</a>
            </div>
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

<%-- ========== PAGE WRAPPER ========== --%>
<div class="page-wrapper">

    <div class="form-container">

        <%-- ---- Card Header ---- --%>
        <div class="card-header-bar">
            <div class="header-ornament">
                <div class="orn-line"></div>
                <div class="orn-diamond-sm"></div>
                <div class="orn-diamond"></div>
                <div class="orn-diamond-sm"></div>
                <div class="orn-line"></div>
            </div>
            <div class="header-lotus">🪷</div>
            <h1>เพิ่มคำถามใหม่</h1>
            <p>ระบุข้อความคำถามและเลือกประเภทพิธีที่เกี่ยวข้อง</p>
            <div class="header-gold-line"></div>
        </div>

        <%-- ---- Card Body ---- --%>
        <div class="card-body">

            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠ &nbsp;${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/organizer/questions/add" method="post" class="form-section">

                <div class="section-label">ข้อมูลคำถาม</div>

                <div class="form-group">
                    <label for="questionText">ข้อความคำถาม</label>
                    <input type="text" id="questionText" name="questionText"
                        placeholder="เช่น จำนวนพระสงฆ์ที่ต้องการนิมนต์"
                        required value="${param.questionText}" />
                </div>

                <div class="form-group">
                    <label for="ceremonyId">สำหรับประเภทพิธี</label>
                    <div class="select-wrapper">
                        <select id="ceremonyId" name="ceremonyId" required>
                            <option value="">-- เลือกประเภทพิธี --</option>
                            <c:forEach var="c" items="${ceremonies}">
                                <option value="${c.ceremonyId}"
                                    ${param.ceremonyId == c.ceremonyId ? 'selected' : ''}>${c.ceremonyName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <%-- ลายกนกคั่น --%>
                <div class="kanok-inline">
                    <svg viewBox="0 0 400 16" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="width:100%;height:16px;">
                        <line x1="0" y1="8" x2="400" y2="8" stroke="#E8CC70" stroke-width="0.8" opacity="0.6"/>
                        <g fill="#D4A017" opacity="0.5">
                            <ellipse cx="200" cy="8" rx="10" ry="3.5" transform="rotate(-30 200 8)"/>
                            <ellipse cx="200" cy="8" rx="10" ry="3.5" transform="rotate(30 200 8)"/>
                            <ellipse cx="200" cy="8" rx="10" ry="3.5"/>
                            <circle  cx="200" cy="8" r="2.5" fill="#E8BB3A"/>
                            <ellipse cx="155" cy="8" rx="7"  ry="2.5" transform="rotate(-30 155 8)"/>
                            <ellipse cx="155" cy="8" rx="7"  ry="2.5" transform="rotate(30 155 8)"/>
                            <circle  cx="155" cy="8" r="2"   fill="#E8BB3A"/>
                            <ellipse cx="245" cy="8" rx="7"  ry="2.5" transform="rotate(-30 245 8)"/>
                            <ellipse cx="245" cy="8" rx="7"  ry="2.5" transform="rotate(30 245 8)"/>
                            <circle  cx="245" cy="8" r="2"   fill="#E8BB3A"/>
                        </g>
                    </svg>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">✓ &nbsp;ยืนยันการเพิ่มคำถาม</button>
                    <button type="button" class="btn-cancel"
                        onclick="window.location.href='${pageContext.request.contextPath}/organizer/questions'">
                        ยกเลิก
                    </button>
                </div>

            </form>
        </div><%-- /card-body --%>

    </div><%-- /form-container --%>

</div><%-- /page-wrapper --%>

<%-- ========== KANOK DIVIDER ท้ายหน้า ========== --%>
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
