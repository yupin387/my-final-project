<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>แก้ไขคำถาม - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/addQuestion.css">
    <style>
    /* ===== FIX: เปลี่ยนจาก dropdown เลือกประเภทงานได้ทีละอัน เป็น checkbox
       เลือกได้พร้อมกันหลายประเภท เพราะ 1 คำถามผูกได้กับหลายประเภทงานพร้อมกัน
       (เหมือนหน้าเพิ่มคำถาม) — ค่าที่ติ๊กไว้มาจาก selectedCeremonyTypes ของ controller ===== */
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
 
<!-- Navbar -->
<div class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/bookings" style="text-decoration: none;">
        <img src="${pageContext.request.contextPath}/static/images/logoo.png"
             alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
        <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-right">
        <nav class="navbar-menu">
            <a href="${pageContext.request.contextPath}/organizer/bookings" class="nav-item">รายการจอง</a>
            <a href="${pageContext.request.contextPath}/organizer/head-staff" class="nav-item">หัวหน้างาน</a>
            <a href="${pageContext.request.contextPath}/organizer/questions" class="nav-item active">จัดการพิธี</a>
            <a href="${pageContext.request.contextPath}/organizer/quotation" class="nav-item">จัดการใบเสนอราคา</a>
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

                <%-- ===== FIX: checkbox หลายอัน แทน dropdown เดี่ยว
                     ติ๊กตาม selectedCeremonyTypes ที่ controller ส่งมา (ทุกประเภทที่ผูกอยู่จริง
                     ไม่ใช่แค่ตัวแรกเหมือนเดิม) ===== --%>
                <div class="form-group">
                    <label>ประเภทงาน</label>
                    <p class="checkbox-group-hint">เลือกได้มากกว่า 1 ประเภท — คำถามข้อนี้จะถูกใช้กับทุกประเภทงานที่ติ๊กไว้</p>
                    <div class="ceremony-checkbox-group">
                        <c:forEach var="type" items="${ceremonyTypes}">
                            <c:set var="isChecked" value="false" />
                            <c:forEach var="selType" items="${selectedCeremonyTypes}">
                                <c:if test="${selType == type}">
                                    <c:set var="isChecked" value="true" />
                                </c:if>
                            </c:forEach>
                            <div class="ceremony-checkbox-item">
                                <input type="checkbox" name="ceremonyTypes" value="${type}" id="ct_${type}"
                                    ${isChecked ? 'checked' : ''}>
                                <label for="ct_${type}">${type}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
 
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
                 alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
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
