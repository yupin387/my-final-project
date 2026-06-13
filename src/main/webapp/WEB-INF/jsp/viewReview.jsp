<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>รีวิว: ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/viewReview.css">
</head>
<body>

    <%-- ========== NAVBAR ========== --%>
    <nav class="navbar">
        <a class="navbar-title" href="${pageContext.request.contextPath}/home">ระบบรับจัดงานบุญ</a>

        <div class="navbar-right">
            <div class="navbar-menu">
                <a href="${pageContext.request.contextPath}/home"         class="nav-item">หน้าหลัก</a>
                <a href="${pageContext.request.contextPath}/latestBooking" class="nav-item">การจอง</a>
                <a href="${pageContext.request.contextPath}/reviews"       class="nav-item active">รีวิว</a>
                <c:if test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-item">ใบเสนอราคา</a>
                </c:if>
            </div>

            <c:if test="${not empty sessionScope.user}">
                <div class="user-info" onclick="this.querySelector('.dropdown-menu').classList.toggle('show')">
                    <div class="user-avatar-nav">
                        ${fn:substring(sessionScope.user.memberFirstName, 0, 1)}
                    </div>
                    <div class="user-info-text">
				        <%-- เปลี่ยนจาก span เป็น div ทั้งสองบรรทัด --%>
				        <div class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</div>
				        <div class="user-role-nav">สมาชิก</div>
				    </div>
                    <div class="dropdown-menu">
                        <a href="${pageContext.request.contextPath}/member/profile" class="dropdown-link">โปรไฟล์ของฉัน</a>
                        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">ออกจากระบบ</a>
                    </div>
                </div>
            </c:if>
        </div>
    </nav>

    <%-- ========== MAIN CONTENT ========== --%>
    <div class="page-wrapper">

        <div class="section-header">
            <h2 class="section-title">รีวิวจากผู้ใช้บริการ</h2>
            <p class="section-subtitle">เสียงตอบรับจากเจ้าภาพที่เคยใช้บริการระบบรับจัดงานบุญของเรา</p>
            <div class="gold-line"></div>
        </div>
        
        <div class="filter-wrapper">
		    <a href="${pageContext.request.contextPath}/reviews" 
		       class="btn-filter ${empty selectedCeremonyId ? 'active-link' : ''}">ทั้งหมด</a>
		    
		    <a href="${pageContext.request.contextPath}/reviews/1" 
		       class="btn-filter ${selectedCeremonyId == 1 ? 'active-link' : ''}">งานขึ้นบ้านใหม่</a>
		       
		    <a href="${pageContext.request.contextPath}/reviews/2" 
		       class="btn-filter ${selectedCeremonyId == 2 ? 'active-link' : ''}">งานสืบชะตา</a>
		</div>

        <%-- ========== SUMMARY CARD ========== --%>
        <div class="summary-card">
            <div class="rating-big">
                <h1><fmt:formatNumber value="${avgRating}" pattern="0.00" /></h1>
                <div class="stars-big">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= avgRating + 0.5}">★</c:when>
                            <c:otherwise><span class="stars-empty">☆</span></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <div class="rating-count">จากผู้ใช้บริการทั้งหมด ${reviews.size()} ท่าน</div>
            </div>

            <%-- Rating Bars — ใช้ starCounts Map ที่ส่งมาจาก Controller (key=1..5, value=count) --%>
            <div class="rating-bars">
                <div class="rating-bars-title">สัดส่วนการให้คะแนน</div>
                <c:forEach begin="1" end="5" var="i">
                    <c:set var="star" value="${6 - i}" /><%-- วนจาก 5 ลงมา 1 --%>
                    <c:set var="count" value="${starCounts[star] != null ? starCounts[star] : 0}" />
                    <c:set var="total" value="${reviews.size() > 0 ? reviews.size() : 1}" />
                    <c:set var="pct"   value="${count * 100 / total}" />
                    <div class="bar-row">
                        <span class="bar-label">${star} ดาว</span>
                        <div class="bar-track">
                            <div class="bar-fill" style="width: ${pct}%"></div>
                        </div>
                        <span style="width:24px; font-size:12px; color:var(--text-muted);">${count}</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <%-- ========== REVIEW CARDS ========== --%>
        <c:forEach items="${reviews}" var="r">
            <div class="review-card">
                <div class="review-top">
                    <div class="reviewer-left">
                        <div class="avatar">
                            ${fn:substring(r.bookingForm.member.memberFirstName, 0, 1)}
                        </div>
                        <div>
                            <div class="reviewer-name">
                                ${r.bookingForm.member.memberFirstName} ${r.bookingForm.member.memberLastName}
                            </div>
                            <div class="stars-review">
                                <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                                <c:forEach begin="${r.rating + 1}" end="5">
                                    <span class="stars-empty">☆</span>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    <div class="review-date">
                        <fmt:formatDate value="${r.reviewDate}" pattern="dd MMM yyyy" />
                    </div>
                </div>

                <div class="ceremony-badge">งาน: ${r.bookingForm.ceremony.ceremonyName}</div>

                <p class="review-text">"${r.comment}"</p>

                <c:if test="${not empty r.reviewImage}">
                    <img src="${pageContext.request.contextPath}/uploads/review/${r.reviewImage}"
                         class="review-img" alt="ภาพรีวิว">
                </c:if>
            </div>
        </c:forEach>

        <%-- กรณีไม่มีรีวิว --%>
        <c:if test="${empty reviews}">
            <div class="empty-state">
                <p>ยังไม่มีข้อมูลการรีวิวในขณะนี้</p>
            </div>
        </c:if>

    </div>



</body>
</html>
