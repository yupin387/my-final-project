<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการคำถามแต่ละพิธี - บุญมีนำพา จัดงานบุญ</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/questionList.css">
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
            <a href="${pageContext.request.contextPath}/organizer/quotation"  class="nav-item">ใบเสนอราคา</a>
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

    <%-- Alert success --%>
    <c:if test="${not empty success}">
        <div class="alert alert-success">✓ &nbsp;${success}</div>
    </c:if>

    <%-- ========== LIST HEADER ========== --%>
    <div class="list-header">
        <div>
            <div class="section-ornament">
                <div class="ornament-line"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-diamond"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-line right"></div>
            </div>
            <h1>รายการคำถามแต่ละพิธี</h1>
            <p>ดูแลและจัดการคำถามทั้งหมดที่ปรากฏในฟอร์มจองของลูกค้า</p>
            <div class="gold-line"></div>
        </div>
        <a href="${pageContext.request.contextPath}/organizer/questions/add" class="btn-add" style="text-decoration: none;">+ เพิ่มคำถาม</a>
    </div>

    <%-- ========== TABS — กรองตามประเภทงานบุญ (3 ประเภท) ไม่ใช่รายแพ็กเกจ ========== --%>
    <div class="tabs-wrapper">
        <a href="${pageContext.request.contextPath}/organizer/questions?ceremonyType=all"
           class="tab-btn ${(empty selectedCeremonyType or selectedCeremonyType eq 'all') ? 'active' : ''}">ทั้งหมด</a>
        <c:forEach var="t" items="${ceremonyTypes}">
            <a href="${pageContext.request.contextPath}/organizer/questions?ceremonyType=${t}"
               class="tab-btn ${selectedCeremonyType eq t ? 'active' : ''}">
                ${t}
            </a>
        </c:forEach>
    </div>

    <%-- ========== CONTENT CARD ========== --%>
    <div class="content-card">
        <div class="card-header-bar">
            <span>
                <c:choose>
                    <c:when test="${empty selectedCeremonyType or selectedCeremonyType eq 'all'}">แสดงทุกประเภทพิธี</c:when>
                    <c:otherwise>พิธี${selectedCeremonyType}</c:otherwise>
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
                                    <span class="ceremony-tag">${q.ceremony.ceremonyType}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="ceremony-tag all-tag">ใช้กับทุกประเภทพิธี</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-links">
                                <a href="${pageContext.request.contextPath}/organizer/questions/edit/${q.questionsId}" class="btn-edit" style="text-decoration: none;">แก้ไข</a>
                                <button type="button" class="btn-del" onclick="prepareDelete('${q.questionsId}')">ลบ</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty questions}">
                    <tr>
                        <td colspan="4" class="empty-state">🪷 ยังไม่มีข้อมูลคำถามสำหรับพิธีนี้</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>



</div><%-- /page-wrapper --%>

<%-- ========== DELETE MODAL ========== --%>
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <div class="w-100">
                   <div class="section-ornament">
    <div class="ornament-line"></div>
    <div class="ornament-diamond-sm"></div>
    <div class="ornament-diamond"></div>
    <div class="ornament-diamond-sm"></div>
    <div class="ornament-line right"></div>
</div>
                    <h5 class="modal-title">ยืนยันการลบข้อมูล</h5>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                คุณแน่ใจหรือไม่ว่าต้องการลบคำถามนี้ออกจากระบบ?
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">ยกเลิก</button>
                <form id="confirmDeleteForm" method="post">
                    <button type="submit" class="btn-del" style="border: none; padding: 9px 26px; border-radius: 10px; font-size: 14px;">ตกลง</button>
                </form>
            </div>

        </div>
    </div>
</div>

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

<%-- ========== SCRIPTS ========== --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // กำหนด global variable ไว้ให้ไฟล์ js ใช้งาน
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/static/js/questionList.js"></script>
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
