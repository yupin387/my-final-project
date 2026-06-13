<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการคำถามแต่ละพิธี - ระบบรับจัดงานบุญ</title>
    
    <!-- ✅ 1. เพิ่ม Bootstrap 5 CSS (สำคัญมาก: เพื่อให้ Modal ซ่อนตัวและทำงานได้) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/questionList.css">
</head>
<body>

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
                <a href="${pageContext.request.contextPath}/organizer/logout" class="dropdown-item">ออกจากระบบ</a>
            </div>
        </div>
    </div>
</div>

<div class="page-wrapper">

    <c:if test="${not empty success}">
        <div class="alert alert-success"> ${success}</div>
    </c:if>

    <div class="list-header">
        <div>
            <h1>รายการคำถามแต่ละพิธี</h1>
            <p>ดูแลและจัดการคำถามทั้งหมดที่ปรากฏในฟอร์มจองของลูกค้า</p>
        </div>
        <a href="${pageContext.request.contextPath}/organizer/questions/add" class="btn-add" style="text-decoration: none;">+ เพิ่มคำถาม</a>
    </div>

    <div class="tabs-wrapper">
        <a href="${pageContext.request.contextPath}/organizer/questions?ceremonyId=all"
           class="tab-btn ${(empty selectedCeremony or selectedCeremony eq 'all') ? 'active' : ''}">ทั้งหมด</a>
        
        <c:forEach var="c" items="${ceremonies}">
            <a href="${pageContext.request.contextPath}/organizer/questions?ceremonyId=${c.ceremonyId}"
               class="tab-btn ${selectedCeremony.toString() eq c.ceremonyId.toString() ? 'active' : ''}">
                ${c.ceremonyName}
            </a>
        </c:forEach>
    </div>

    <div class="content-card">
        <div class="card-header-bar">
            <span>
                <c:choose>
                    <c:when test="${selectedCeremony eq 'all'}">แสดงทุกประเภทพิธี</c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${ceremonies}">
                            <c:if test="${c.ceremonyId.toString() eq selectedCeremony.toString()}">พิธี${c.ceremonyName}</c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </span>
            <span class="header-count">จำนวนทั้งหมด ${questions.size()} รายการ</span>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th width="8%">ลำดับ</th>
                    <th width="52%">ข้อความคำถาม</th>
                    <th width="22%">ประเภทพิธี</th>
                    <th width="18%">จัดการ</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="q" items="${questions}" varStatus="status">
                    <tr>
                        <td><div class="circle-num">${status.index + 1}</div></td>
                        <td class="question-text">${q.questionsText}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty q.ceremony}">
                                    <span class="ceremony-tag">${q.ceremony.ceremonyName}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="ceremony-tag all-tag">ใช้กับทุกประเภทพิธี</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-links">
                                <a href="${pageContext.request.contextPath}/organizer/questions/edit/${q.questionsId}" class="btn-edit" style="text-decoration: none;">แก้ไข</a>
                                <%-- ✅ ปุ่มลบแบบใหม่ที่เรียกใช้งาน JavaScript prepareDelete --%>
                                <button type="button" class="btn-del" onclick="prepareDelete('${q.questionsId}')">ลบ</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty questions}">
                    <tr>
                        <td colspan="4" class="empty-state"> ยังไม่มีข้อมูลคำถามสำหรับพิธีนี้</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- ✅ 2. โครงสร้าง Modal (วางไว้ก่อนปิด body) -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
            <div class="modal-header" style="border-bottom: none; padding: 20px 20px 10px;">
                <h5 class="modal-title w-100 text-center fw-bold" style="color: #8D4118;">ยืนยันการลบข้อมูล</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center" style="padding: 10px 20px 20px;">
                คุณแน่ใจหรือไม่ว่าต้องการลบคำถามนี้ออกจากระบบ?
            </div>
            <div class="modal-footer" style="border-top: none; justify-content: center; padding-bottom: 25px;">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal" style="border-radius: 10px; padding: 8px 25px;">ยกเลิก</button>
                
                <%-- ฟอร์มส่งไป Controller --%>
                <form id="confirmDeleteForm" method="post">
                    <button type="submit" class="btn-del" style="border: none; padding: 8px 25px; border-radius: 10px;">ตกลง</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- ✅ 3. โหลด Bootstrap JS ก่อน (จำเป็นสำหรับการเรียกใช้ bootstrap.Modal) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/questionList.js"></script>

</body>
</html>