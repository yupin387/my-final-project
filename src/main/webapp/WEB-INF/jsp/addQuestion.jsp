<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>เพิ่มคำถามพิธี - บุญมีนำพา จัดงานบุญ</title>
    <!-- เพิ่มฟอนต์ Charmonman ตรงนี้ครับ -->
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/addQuestion.css">
    <style>
    /* ===== FIX: เปลี่ยนจาก dropdown เลือกประเภทงานได้ทีละอัน เป็น checkbox
       เลือกได้พร้อมกันหลายประเภท เพราะ 1 คำถามผูกได้กับหลายประเภทงานพร้อมกัน ===== */
    .ceremony-checkbox-group {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .ceremony-checkbox-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 16px;
        border: 1.5px solid var(--card-border, #F3C4D5);
        border-radius: 10px;
        background: #FFFFFF;
        cursor: pointer;
        transition: border-color 0.2s, background 0.2s;
    }
    .ceremony-checkbox-item:hover {
        border-color: #EC6E96;
        background: #FEF6F9;
    }
    .ceremony-checkbox-item input[type="checkbox"] {
        width: 18px;
        height: 18px;
        cursor: pointer;
        accent-color: #EC6E96;
        flex-shrink: 0;
    }
    .ceremony-checkbox-item label {
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        flex: 1;
    }
    .checkbox-group-hint {
        font-size: 12px;
        color: #8A7666;
        margin: -4px 0 4px;
    }
    </style>
</head>
<body>

<%-- ========== NAVBAR ========== --%>
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
        <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <div class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings"   class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions"  class="nav-item active">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item">จัดการใบเสนอราคา</a>
        </div>
        <div class="user-info" onclick="toggleDropdown()">
            <div class="user-avatar">A</div>
            <div class="user-detail">
                <span class="user-name">Admin Organizer</span>
                <span class="user-role">ผู้จัดการ</span>
            </div>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item danger">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</nav>

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

                <%-- ===== FIX: checkbox หลายอัน แทน dropdown เดี่ยว
                     ติ๊กได้พร้อมกันหลายประเภทงาน — ไม่ติ๊กเลย = คำถามกลาง ไม่ผูกกับประเภทงานไหน ===== --%>
                <div class="form-group">
                    <label>ประเภทงาน</label>
                    <p class="checkbox-group-hint">เลือกได้มากกว่า 1 ประเภท — คำถามข้อนี้จะถูกใช้กับทุกประเภทงานที่ติ๊กไว้</p>
                    <div class="ceremony-checkbox-group">
                        <c:forEach var="type" items="${ceremonyTypes}">
                            <div class="ceremony-checkbox-item">
                                <input type="checkbox" name="ceremonyTypes" value="${type}" id="ct_${type}">
                                <label for="ct_${type}">${type}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <%-- ลายกนกคั่น --%>
                <div class="kanok-inline">
                    <svg viewBox="0 0 400 16" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none" style="width:100%;height:16px;">
                        <line x1="0" y1="8" x2="400" y2="8" stroke="#F3C4D5" stroke-width="0.8" opacity="0.6"/>
                        <g fill="#EC6E96" opacity="0.5">
                            <ellipse cx="200" cy="8" rx="10" ry="3.5" transform="rotate(-30 200 8)"/>
                            <ellipse cx="200" cy="8" rx="10" ry="3.5" transform="rotate(30 200 8)"/>
                            <ellipse cx="200" cy="8" rx="10" ry="3.5"/>
                            <circle  cx="200" cy="8" r="2.5" fill="#F49CB9"/>
                            <ellipse cx="155" cy="8" rx="7"  ry="2.5" transform="rotate(-30 155 8)"/>
                            <ellipse cx="155" cy="8" rx="7"  ry="2.5" transform="rotate(30 155 8)"/>
                            <circle  cx="155" cy="8" r="2"   fill="#F49CB9"/>
                            <ellipse cx="245" cy="8" rx="7"  ry="2.5" transform="rotate(-30 245 8)"/>
                            <ellipse cx="245" cy="8" rx="7"  ry="2.5" transform="rotate(30 245 8)"/>
                            <circle  cx="245" cy="8" r="2"   fill="#F49CB9"/>
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

<!-- ===== FOOTER ===== -->
<footer class="site-footer">
    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับทีมงานและผู้ดูแลระบบ</p>
    </div>
</footer>

<!-- แก้ไขชื่อสคริปต์ให้ถูกต้อง -->
<script src="${pageContext.request.contextPath}/static/js/addQuestion.js"></script>
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
