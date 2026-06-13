<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>แก้ไขคำถาม - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/addQuestion.css">
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <span class="navbar-title">ระบบรับจัดงานบุญ</span>
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
            <span class="arrow">▾</span>
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item">
                     ออกจากระบบ
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Content -->
<div class="page-wrapper">
    <div class="content-card">

        <!-- Red Header Bar -->
        <div class="card-header-bar">
            <span class="question-id-badge">ID: ${question.questionsId}</span>
            <h1>แก้ไขคำถาม</h1>
            <p>ปรับปรุงข้อความคำถามหรือเปลี่ยนประเภทพิธี</p>
        </div>

        <!-- Form Body -->
        <div class="card-body">

            <c:if test="${not empty error}">
                <div class="alert error">${error}</div>
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

                <div class="form-group">
                    <label for="ceremonyId">สำหรับประเภทพิธี</label>
                    <select id="ceremonyId" name="ceremonyId" required>
					    <option value="">-- เลือกประเภทพิธี --</option>
					    <c:forEach var="c" items="${ceremonies}">
					        <option value="${c.ceremonyId}"
					            ${c.ceremonyId == question.ceremony.ceremonyId ? 'selected' : ''}>
					            ${c.ceremonyName}
					        </option>
					    </c:forEach>
					</select>
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

<script src="${pageContext.request.contextPath}/static/js/addHeadStaff.js"></script>
</body>
</html>
