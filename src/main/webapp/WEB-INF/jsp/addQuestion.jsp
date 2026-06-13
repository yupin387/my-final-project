<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>เพิ่มคำถามพิธี - ระบบรับจัดงานบุญ</title>
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/addQuestion.css">
</head>
<body>

	<!-- Navbar -->
	<div class="navbar">
		<span class="navbar-title">ระบบรับจัดงานบุญ</span>
		<div class="navbar-right">
			<nav class="navbar-menu">
				<a href="${pageContext.request.contextPath}/organizer/bookings"
					class="nav-item">รายการจอง</a> <a
					href="${pageContext.request.contextPath}/organizer/head-staff"
					class="nav-item">หัวหน้างาน</a> <a
					href="${pageContext.request.contextPath}/organizer/questions"
					class="nav-item active">จัดการพิธี</a> <a
					href="${pageContext.request.contextPath}/organizer/quotation"
					class="nav-item">ใบเสนอราคา</a>
			</nav>
			<div class="user-info" onclick="toggleDropdown()">
				<div class="user-avatar">A</div>
				<div class="user-detail">
					<span class="user-name">Admin Organizer</span> <span
						class="user-role">ผู้จัดการ</span>
				</div>
				<span class="arrow">▾</span>
				<div class="dropdown-menu" id="dropdownMenu">
					<a href="${pageContext.request.contextPath}/organizer/logout"
						class="dropdown-item">  ออกจากระบบ </a>
				</div>
			</div>
		</div>
	</div>

	<!-- Content -->
	<div class="page-wrapper">
		<div class="content-card">

			<!-- Red Header Bar -->
			<div class="card-header-bar">
				<h1>เพิ่มคำถามใหม่</h1>
				<p>ระบุข้อความคำถามและเลือกประเภทพิธีที่เกี่ยวข้อง</p>
			</div>

			<!-- Form Body -->
			<div class="card-body">

				<c:if test="${not empty error}">
					<div class="alert error">${error}</div>
				</c:if>

				<form
				    action="${pageContext.request.contextPath}/organizer/questions/add"
				    method="post" class="form-section">
				
				    <div class="section-label">ข้อมูลคำถาม</div>
				
				    <div class="form-group">
				        <label for="questionText">ข้อความคำถาม</label> 
				        <input type="text" id="questionText" name="questionText"
				            placeholder="เช่น จำนวนพระสงฆ์ที่ต้องการนิมนต์" required
				            value="${param.questionText}" />
				    </div>
				
				    <div class="form-group">
				        <label for="ceremonyId">สำหรับประเภทพิธี</label> 
				        <select id="ceremonyId" name="ceremonyId" required>
				            <option value="">-- เลือกประเภทพิธี --</option>
				            <%-- ลบตัวเลือก ALL ออกเรียบร้อยแล้ว --%>
				            <c:forEach var="c" items="${ceremonies}">
				                <option value="${c.ceremonyId}"
				                    ${param.ceremonyId == c.ceremonyId ? 'selected' : ''}>${c.ceremonyName}</option>
				            </c:forEach>
				        </select>
				    </div>
				
				    <hr class="divider">
				
				    <div class="form-actions">
				        <button type="submit" class="btn-submit">ยืนยันการเพิ่มคำถาม</button>
				        <button type="button" class="btn-cancel"
				            onclick="window.location.href='${pageContext.request.contextPath}/organizer/questions'">
				            ยกเลิก</button>
				    </div>
				
				</form>

		</div>
	</div>

	<script
		src="${pageContext.request.contextPath}/static/js/addHeadStaff.js"></script>
</body>
</html>
