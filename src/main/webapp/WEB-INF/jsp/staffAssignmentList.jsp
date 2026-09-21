<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>จัดการการมอบหมายงาน - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/staffAssignmentList.css?v=7">
</head>
<body>

    <%-- ===== Navbar ===== --%>
    <nav class="navbar">
        <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/staff/assignments">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon">
            <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item active">งานที่ได้รับมอบหมาย</a>
                <a href="${pageContext.request.contextPath}/staff/items" class="nav-item">จัดการรายการอุปกรณ์</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName}
                    ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile" class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="page-wrapper">

        <%-- ===== Flash Message ===== --%>
        <c:if test="${not empty success}">
            <div class="flash-banner flash-banner-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash-banner flash-banner-error">${error}</div>
        </c:if>

        <div class="list-header">
            <div class="section-ornament">
                <div class="ornament-line"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-diamond"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-line right"></div>
            </div>
            <h1>รายการงานที่ได้รับมอบหมาย</h1>
            <p>งานที่ได้รับมอบหมายทั้งหมดในระบบ</p>
            <div class="gold-line"></div>
        </div>

        <%-- ===== Tabbed Card: แท็บติดกับการ์ดเป็นชิ้นเดียว ===== --%>
        <div class="tabbed-card">

            <div class="tabs-attached">
                <button type="button" class="tab-attached-btn active" data-tab="active" onclick="switchTab('active')">
                    กำลังดำเนินการ <span class="tab-count">${fn:length(activeAssignments)}</span>
                </button>
                <button type="button" class="tab-attached-btn" data-tab="history" onclick="switchTab('history')">
                    ประวัติการจอง <span class="tab-count">${fn:length(completedAssignments)}</span>
                </button>
            </div>

            <%-- ===== แท็บ: กำลังดำเนินการ ===== --%>
            <div class="tab-panel show" id="tab-active">
                <div class="card-header-bar">
                    <span>รายการที่กำลังดำเนินการ</span>
                    <span class="header-count">จำนวนทั้งหมด ${fn:length(activeAssignments)} รายการ</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th width="13%">รหัสมอบหมาย</th>
                            <th width="13%">วันที่มอบหมาย</th>
                            <th width="13%">วันจัดงาน</th>
                            <th width="18%">ประเภทพิธี</th>
                            <th width="18%">ชื่อลูกค้า</th>
                            <th width="13%">สถานะงาน</th>
                            <th width="12%" style="text-align: center;">จัดการ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${activeAssignments}">
                            <tr>
                                <td><span class="assign-id">${a.assignId}</span></td>
                                <td><fmt:formatDate value="${a.assignDate}" pattern="dd/MM/yyyy"/></td>
                                <td><strong><fmt:formatDate value="${a.bookingForm.eventDate}" pattern="dd/MM/yyyy"/></strong></td>
                                <td><span class="ceremony-name">${a.bookingForm.ceremony.ceremonyType}</span></td>
                                <td>${a.bookingForm.member.memberFirstName}</td>
                                <td>
                                    <span class="status-badge status-${a.jobStatus}">
                                        <c:choose>
                                            <c:when test="${a.jobStatus == 'Assigned'}">มอบหมายแล้ว</c:when>
                                            <c:when test="${a.jobStatus == 'Preparing'}">เตรียมงาน</c:when>
                                            <c:when test="${a.jobStatus == 'In_Progress'}">กำลังดำเนินงาน</c:when>
                                            <c:when test="${a.jobStatus == 'Completed'}">เสร็จสิ้น</c:when>
                                            <c:otherwise>${a.jobStatus}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <a href="${pageContext.request.contextPath}/staff/assignments/detail/${a.assignId}" class="btn-view">ดูรายละเอียด</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty activeAssignments}">
                            <tr>
                                <td colspan="7" class="empty-state">ไม่มีงานที่กำลังดำเนินการ</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <%-- ===== แท็บ: ประวัติการจอง (Completed) ===== --%>
            <div class="tab-panel" id="tab-history">
                <div class="card-header-bar">
                    <span>ประวัติการจองที่สิ้นสุดแล้ว</span>
                    <span class="header-count">จำนวนทั้งหมด ${fn:length(completedAssignments)} รายการ</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th width="13%">รหัสมอบหมาย</th>
                            <th width="13%">วันที่มอบหมาย</th>
                            <th width="13%">วันจัดงาน</th>
                            <th width="18%">ประเภทพิธี</th>
                            <th width="18%">ชื่อลูกค้า</th>
                            <th width="13%">สถานะงาน</th>
                            <th width="12%" style="text-align: center;">จัดการ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${completedAssignments}">
                            <tr>
                                <td><span class="assign-id">${a.assignId}</span></td>
                                <td><fmt:formatDate value="${a.assignDate}" pattern="dd/MM/yyyy"/></td>
                                <td><strong><fmt:formatDate value="${a.bookingForm.eventDate}" pattern="dd/MM/yyyy"/></strong></td>
                                <td><span class="ceremony-name">${a.bookingForm.ceremony.ceremonyType}</span></td>
                                <td>${a.bookingForm.member.memberFirstName}</td>
                                <td>
                                    <span class="status-badge status-${a.jobStatus}">
                                        <c:choose>
                                            <c:when test="${a.jobStatus == 'Assigned'}">มอบหมายแล้ว</c:when>
                                            <c:when test="${a.jobStatus == 'Preparing'}">เตรียมงาน</c:when>
                                            <c:when test="${a.jobStatus == 'In_Progress'}">กำลังดำเนินงาน</c:when>
                                            <c:when test="${a.jobStatus == 'Completed'}">เสร็จสิ้น</c:when>
                                            <c:otherwise>${a.jobStatus}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <a href="${pageContext.request.contextPath}/staff/assignments/detail/${a.assignId}" class="btn-view">ดูรายละเอียด</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty completedAssignments}">
                            <tr>
                                <td colspan="7" class="empty-state">ยังไม่มีประวัติการจองที่สิ้นสุดแล้ว</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div>

    </div>


<footer class="site-footer">

    <%-- ===== ลายดอกบัวมุมล่างขวา (เกาะติด footer) ===== --%>
    <img src="${pageContext.request.contextPath}/static/images/lotus-corner.png"
         alt="" class="lotus-decoration" aria-hidden="true">

    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับหัวหน้างาน</p>
    </div>

</footer>

    <script src="${pageContext.request.contextPath}/static/js/staffAssignmentList.js"></script>
    <script>
    function toggleDropdown() {
        document.getElementById('dropdownMenu').classList.toggle('show');
    }
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.user-info')) {
            document.getElementById('dropdownMenu').classList.remove('show');
        }
    });

    function switchTab(tab) {
        document.querySelectorAll('.tab-attached-btn').forEach(function(btn) {
            btn.classList.toggle('active', btn.dataset.tab === tab);
        });
        document.querySelectorAll('.tab-panel').forEach(function(panel) {
            panel.classList.toggle('show', panel.id === 'tab-' + tab);
        });
    }
    </script>
</body>
</html>