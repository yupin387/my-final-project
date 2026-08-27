<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายการคำถามแต่ละพิธี - บุญมีนำพา จัดงานบุญ</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/questionList.css?v=2">
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

<%-- Alert success --%>
<c:if test="${not empty success}">
    <div class="alert-success">
        <span class="alert-icon">✓</span>
        <span>${success}</span>
    </div>
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
        <a href="${pageContext.request.contextPath}/organizer/questions?ceremonyType=all"
           class="tab-btn ${(empty selectedCeremonyType or selectedCeremonyType eq 'all') ? 'active' : ''}">
            <span class="ceremony-dot dot-all"></span>ทั้งหมด
        </a>
        <c:forEach var="t" items="${ceremonyTypes}">
            <c:choose>
                <c:when test="${t eq 'ทำบุญบ้าน'}"><c:set var="tDotClass" value="dot-home"/></c:when>
                <c:when test="${t eq 'ขึ้นบ้านใหม่'}"><c:set var="tDotClass" value="dot-newhome"/></c:when>
                <c:when test="${t eq 'ทำบุญบริษัทหรือออฟฟิศ'}"><c:set var="tDotClass" value="dot-company"/></c:when>
                <c:otherwise><c:set var="tDotClass" value="dot-all"/></c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/organizer/questions?ceremonyType=${t}"
               class="tab-btn ${selectedCeremonyType eq t ? 'active' : ''}">
                <span class="ceremony-dot ${tDotClass}"></span>${t}
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
                    <th width="40%">ข้อความคำถาม</th>
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
                                <c:when test="${not empty q.ceremonies}">
                                    <c:choose>
                                        <c:when test="${not empty selectedCeremonyType and selectedCeremonyType ne 'all'}">
                                            <c:choose>
                                                <c:when test="${selectedCeremonyType eq 'ทำบุญบ้าน'}">
                                                    <span class="ceremony-dot ceremony-dot-lg dot-home" title="${selectedCeremonyType}"></span>
                                                </c:when>
                                                <c:when test="${selectedCeremonyType eq 'ขึ้นบ้านใหม่'}">
                                                    <span class="ceremony-dot ceremony-dot-lg dot-newhome" title="${selectedCeremonyType}"></span>
                                                </c:when>
                                                <c:when test="${selectedCeremonyType eq 'ทำบุญบริษัทหรือออฟฟิศ'}">
                                                    <span class="ceremony-dot ceremony-dot-lg dot-company" title="${selectedCeremonyType}"></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="ceremony-dot ceremony-dot-lg dot-all" title="${selectedCeremonyType}"></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="shownTypes" value="|" />
                                            <c:forEach var="cm" items="${q.ceremonies}">
                                                <c:if test="${not fn:contains(shownTypes, '|'.concat(cm.ceremonyType).concat('|'))}">
                                                    <c:choose>
                                                        <c:when test="${cm.ceremonyType eq 'ทำบุญบ้าน'}">
                                                            <span class="ceremony-dot ceremony-dot-lg dot-home" title="${cm.ceremonyType}"></span>
                                                        </c:when>
                                                        <c:when test="${cm.ceremonyType eq 'ขึ้นบ้านใหม่'}">
                                                            <span class="ceremony-dot ceremony-dot-lg dot-newhome" title="${cm.ceremonyType}"></span>
                                                        </c:when>
                                                        <c:when test="${cm.ceremonyType eq 'ทำบุญบริษัทหรือออฟฟิศ'}">
                                                            <span class="ceremony-dot ceremony-dot-lg dot-company" title="${cm.ceremonyType}"></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="ceremony-dot ceremony-dot-lg dot-all" title="${cm.ceremonyType}"></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:set var="shownTypes" value="${shownTypes}${cm.ceremonyType}|" />
                                                </c:if>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span class="ceremony-dot ceremony-dot-lg dot-all" title="ใช้กับทุกประเภทพิธี"></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-links">
                                <a href="${pageContext.request.contextPath}/organizer/questions/edit/${q.questionsId}" class="btn-edit" style="text-decoration: none;">แก้ไข</a>
                                <button type="button" class="btn-del" onclick="confirmDelete('${q.questionsId}', '${fn:escapeXml(q.questionsText)}')">ลบ</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty questions}">
                    <tr>
                        <td colspan="4" class="empty-state"><span class="ceremony-dot dot-all"></span>ยังไม่มีข้อมูลคำถามสำหรับพิธีนี้</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
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
    const contextPath = "${pageContext.request.contextPath}";
</script>
<!-- เติม ?v=1 ต่อท้ายเพื่อบังคับอัปเดต cache -->
<script src="${pageContext.request.contextPath}/static/js/questionList.js?v=1"></script>
</body>
</html>