<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการคำถามแต่ละพิธี - ระบบรับจัดงานบุญ</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/questionList.css">
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
    <circle cx="200" cy="22" r="2.5" fill="#D4A017" opacity="0.6"/>
    <circle cx="400" cy="22" r="2.5" fill="#D4A017" opacity="0.6"/>
    <circle cx="600" cy="22" r="3"   fill="#D4A017" opacity="0.6"/>
    <circle cx="800" cy="22" r="2.5" fill="#D4A017" opacity="0.6"/>
    <circle cx="1000" cy="22" r="2.5" fill="#D4A017" opacity="0.6"/>
</svg>

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

    <%-- ========== TABS ========== --%>
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

    <%-- ========== CONTENT CARD ========== --%>
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

    <%-- ========== KANOK DIVIDER ========== --%>
    <svg class="kanok-divider" viewBox="0 0 1200 32" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none">
        <line x1="0" y1="16" x2="1200" y2="16" stroke="#E8CC70" stroke-width="1" opacity="0.6"/>
        <g fill="#D4A017" opacity="0.55">
            <ellipse cx="600" cy="16" rx="18" ry="6" transform="rotate(-30 600 16)"/>
            <ellipse cx="600" cy="16" rx="18" ry="6" transform="rotate(30 600 16)"/>
            <ellipse cx="600" cy="16" rx="18" ry="6"/>
            <circle cx="600" cy="16" r="4" fill="#E8BB3A"/>
            <ellipse cx="480" cy="16" rx="13" ry="5" transform="rotate(-30 480 16)"/>
            <ellipse cx="480" cy="16" rx="13" ry="5" transform="rotate(30 480 16)"/>
            <circle cx="480" cy="16" r="3" fill="#E8BB3A"/>
            <ellipse cx="720" cy="16" rx="13" ry="5" transform="rotate(-30 720 16)"/>
            <ellipse cx="720" cy="16" rx="13" ry="5" transform="rotate(30 720 16)"/>
            <circle cx="720" cy="16" r="3" fill="#E8BB3A"/>
            <ellipse cx="360" cy="16" rx="9" ry="3.5" transform="rotate(-30 360 16)"/>
            <ellipse cx="360" cy="16" rx="9" ry="3.5" transform="rotate(30 360 16)"/>
            <circle cx="360" cy="16" r="2.5" fill="#E8BB3A"/>
            <ellipse cx="840" cy="16" rx="9" ry="3.5" transform="rotate(-30 840 16)"/>
            <ellipse cx="840" cy="16" rx="9" ry="3.5" transform="rotate(30 840 16)"/>
            <circle cx="840" cy="16" r="2.5" fill="#E8BB3A"/>
            <ellipse cx="240" cy="16" rx="6" ry="2.5" transform="rotate(-30 240 16)"/>
            <ellipse cx="240" cy="16" rx="6" ry="2.5" transform="rotate(30 240 16)"/>
            <ellipse cx="960" cy="16" rx="6" ry="2.5" transform="rotate(-30 960 16)"/>
            <ellipse cx="960" cy="16" rx="6" ry="2.5" transform="rotate(30 960 16)"/>
        </g>
        <line x1="0"  y1="4"  x2="1200" y2="4"  stroke="#E8CC70" stroke-width="0.5" opacity="0.3"/>
        <line x1="0"  y1="28" x2="1200" y2="28" stroke="#E8CC70" stroke-width="0.5" opacity="0.3"/>
    </svg>

</div><%-- /page-wrapper --%>

<%-- ========== DELETE MODAL ========== --%>
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <div class="w-100">
                    <div class="modal-ornament">
                        <div class="ornament-line" style="max-width:50px;"></div>
                        <div class="ornament-diamond-sm"></div>
                        <div class="ornament-diamond"></div>
                        <div class="ornament-diamond-sm"></div>
                        <div class="ornament-line right" style="max-width:50px;"></div>
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

<%-- ========== SCRIPTS ========== --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
