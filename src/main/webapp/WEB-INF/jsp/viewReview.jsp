	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<!DOCTYPE html>
	<html lang="th">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1">
	    <title>รีวิว: ระบบรับจัดงานบุญ</title>
	    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/viewReview.css">
	</head>
	<body>
	
	<%-- ========== NAVBAR (ให้ตรงกับ home / ceremonyDetail: 92px, โลโก้จริง 58px) ========== --%>
	<nav class="navbar">
	    <a class="navbar-title" href="${pageContext.request.contextPath}/home">
	        <span class="navbar-logo">
	            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
	        </span>
	        บุญมี รับจัดงานบุญ
	    </a>
	    <div class="navbar-right">
	        <div class="navbar-menu">
	            <a href="${pageContext.request.contextPath}/home"          class="nav-item">หน้าหลัก</a>
	            <c:if test="${not empty sessionScope.user}">
	                <a href="${pageContext.request.contextPath}/latestBooking"  class="nav-item">การจอง</a>
	                <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-item">ใบเสนอราคา</a>
	            </c:if>
	            <a href="${pageContext.request.contextPath}/reviews"        class="nav-item active">รีวิว</a>
	            <c:if test="${empty sessionScope.user}">
	                <a href="${pageContext.request.contextPath}/loginMember" class="nav-item">เข้าสู่ระบบ</a>
	            </c:if>
	        </div>
	        <c:if test="${not empty sessionScope.user}">
	            <div class="user-info" onclick="this.querySelector('.dropdown-menu').classList.toggle('show')">
	                <div class="user-avatar-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
	                <div class="user-info-text">
	                    <div class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</div>
	                    <div class="user-role-nav">สมาชิก</div>
	                </div>
	                <div class="dropdown-menu">
	                    <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-link">โปรไฟล์ของฉัน</a>
	                    <a href="${pageContext.request.contextPath}/logout"          class="dropdown-link danger">ออกจากระบบ</a>
	                </div>
	            </div>
	        </c:if>
	    </div>
	</nav>
	
	<%-- ========== MAIN CONTENT ========== --%>
	<div class="page-wrapper">
	
	    <%-- Section ornament --%>
	    <div class="section-ornament">
	        <div class="ornament-line"></div>
	        <div class="ornament-diamond-sm"></div>
	        <div class="ornament-diamond"></div>
	        <div class="ornament-diamond-sm"></div>
	        <div class="ornament-line right"></div>
	    </div>
	    <div class="section-header">
	        <h2 class="section-title">รีวิวจากผู้ใช้บริการ</h2>
	        <p class="section-subtitle">เสียงตอบรับจากเจ้าภาพที่เคยใช้บริการระบบรับจัดงานบุญของเรา</p>
	        <div class="gold-line"></div>
	    </div>
	
	    <%-- ========== Filter: 3 ประเภทงานจริงตาม Ceremony.ceremonyType ==========
	         หมายเหตุ: เปลี่ยนจากกรองด้วย ceremonyId (path variable) เป็นกรองด้วย ceremonyType (query param "type")
	         เพราะ 1 ประเภทงานมีได้หลายแพ็กเกจ/หลาย ceremonyId
	         *** ฝั่ง Controller ต้องรับพารามิเตอร์ "type" และกรอง reviews ที่
	             booking.ceremony.ceremonyType ตรงกับค่านั้น พร้อมส่ง selectedCeremonyType กลับมาที่ view *** --%>
	    <div class="filter-wrapper">
	        <a href="${pageContext.request.contextPath}/reviews"
	           class="btn-filter ${empty selectedCeremonyType ? 'active-link' : ''}">ทั้งหมด</a>
	        <a href="<c:url value='/reviews'><c:param name='type' value='ทำบุญบ้าน'/></c:url>"
	           class="btn-filter ${selectedCeremonyType == 'ทำบุญบ้าน' ? 'active-link' : ''}">งานทำบุญบ้าน</a>
	        <a href="<c:url value='/reviews'><c:param name='type' value='ขึ้นบ้านใหม่'/></c:url>"
	           class="btn-filter ${selectedCeremonyType == 'ขึ้นบ้านใหม่' ? 'active-link' : ''}">งานขึ้นบ้านใหม่</a>
	        <a href="<c:url value='/reviews'><c:param name='type' value='ทำบุญออฟฟิศ'/></c:url>"
	           class="btn-filter ${selectedCeremonyType == 'ทำบุญออฟฟิศ' ? 'active-link' : ''}">งานทำบุญออฟฟิศ</a>
	    </div>
	
	    <%-- ========== SUMMARY CARD ========== --%>
	    <div class="summary-card">
	        <div class="rating-big">
	            <h1><fmt:formatNumber value="${avgRating}" pattern="0.00"/></h1>
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
	        <div class="summary-divider-v"></div>
	        <div class="rating-bars">
	            <div class="rating-bars-title">สัดส่วนการให้คะแนน</div>
	            <c:forEach begin="1" end="5" var="i">
	                <c:set var="star"  value="${6 - i}"/>
	                <c:set var="count" value="${starCounts[star] != null ? starCounts[star] : 0}"/>
	                <c:set var="total" value="${reviews.size() > 0 ? reviews.size() : 1}"/>
	                <c:set var="pct"   value="${count * 100 / total}"/>
	                <div class="bar-row">
	                    <span class="bar-label">${star} ดาว</span>
	                    <div class="bar-track">
	                        <div class="bar-fill" style="width:${pct}%"></div>
	                    </div>
	                    <span style="width:24px; font-size:12px; color:var(--text-muted);">${count}</span>
	                </div>
	            </c:forEach>
	        </div>
	    </div>
	
	    <%-- ========== KANOK DIVIDER ========== --%>
	    <svg viewBox="0 0 860 32" xmlns="http://www.w3.org/2000/svg" style="display:block; width:100%; height:32px; margin-bottom:28px;">
	        <line x1="0" y1="16" x2="860" y2="16" stroke="#F3B6C8" stroke-width="1" opacity="0.7"/>
	        <g fill="#EC6E96" opacity="0.6">
	            <circle cx="430" cy="16" r="4.5"/>
	            <circle cx="410" cy="16" r="2.5"/>
	            <circle cx="450" cy="16" r="2.5"/>
	            <circle cx="390" cy="16" r="1.8"/>
	            <circle cx="470" cy="16" r="1.8"/>
	            <circle cx="370" cy="16" r="1.2"/>
	            <circle cx="490" cy="16" r="1.2"/>
	        </g>
	        <g fill="none" stroke="#EC6E96" stroke-width="1" opacity="0.45">
	            <path d="M80,16 Q100,6 120,16 Q140,26 160,16"/>
	            <path d="M700,16 Q720,6 740,16 Q760,26 780,16"/>
	        </g>
	        <line x1="0" y1="5"  x2="860" y2="5"  stroke="#F3B6C8" stroke-width="0.5" opacity="0.3"/>
	        <line x1="0" y1="27" x2="860" y2="27" stroke="#F3B6C8" stroke-width="0.5" opacity="0.3"/>
	    </svg>
	
	    <%-- ========== REVIEW CARDS ========== --%>
	    <c:forEach items="${reviews}" var="r">
	        <div class="review-card">
	            <div class="review-top">
	                <div class="reviewer-left">
	                    <div class="avatar">${fn:substring(r.bookingForm.member.memberFirstName, 0, 1)}</div>
	                    <div>
	                        <div class="reviewer-name">
	                            ${r.bookingForm.member.memberFirstName} ${r.bookingForm.member.memberLastName}
	                        </div>
	                        <div class="stars-review">
	                            <c:forEach begin="1" end="${r.rating}">★</c:forEach>
	                            <c:forEach begin="${r.rating + 1}" end="5"><span class="stars-empty">☆</span></c:forEach>
	                        </div>
	                    </div>
	                </div>
	                <div class="review-date">
	                    <fmt:formatDate value="${r.reviewDate}" pattern="dd MMM yyyy"/>
	                </div>
	            </div>
	            <div class="ceremony-badge">🪷 งาน: ${r.bookingForm.ceremony.ceremonyType}</div>
	            <p class="review-text">"${r.comment}"</p>
	            <c:if test="${not empty r.reviewImage}">
	                <div class="review-img-wrapper">
	                    <img src="${pageContext.request.contextPath}/uploads/review/${r.reviewImage}"
	                         class="review-img" alt="ภาพรีวิว">
	                </div>
	            </c:if>
	        </div>
	    </c:forEach>
	
	    <c:if test="${empty reviews}">
	        <div class="empty-state">
	            <div class="empty-icon">🪷</div>
	            <p>ยังไม่มีข้อมูลการรีวิวในขณะนี้</p>
	        </div>
	    </c:if>
	
	</div>
	
	<%-- ========== FOOTER (ให้ตรงกับ home / ceremonyDetail — ใช้โลโก้จริง ไม่มี Copyright) ========== --%>
	<footer class="site-footer">
	    <div class="footer-top">
	        <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
	             style="display: block; width: 100%; height: 8px;">
	            <rect width="1200" height="8" fill="url(#footerGrad)" />
	            <defs>
	                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
	                    <stop offset="0%" stop-color="#6E1930" />
	                    <stop offset="25%" stop-color="#EC6E96" />
	                    <stop offset="50%" stop-color="#FBD0DE" />
	                    <stop offset="75%" stop-color="#EC6E96" />
	                    <stop offset="100%" stop-color="#6E1930" />
	                </linearGradient>
	            </defs>
	        </svg>
	    </div>
	    <div class="container footer-content">
	        <div class="footer-col footer-brand-col">
	            <div class="footer-brand">
	                <div class="lotus-icon">
	                    <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
	                </div>
	                <span class="footer-brand-text">บุญมี รับจัดงานบุญ</span>
	            </div>
	            <p class="footer-tagline">รับจัดงานบุญ
	                ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
	        </div>
	
	        <div class="footer-col">
	            <h4 class="footer-heading">เมนู</h4>
	            <a href="${pageContext.request.contextPath}/home">หน้าหลัก</a>
	            <a href="${pageContext.request.contextPath}/reviews">รีวิว</a>
	            <a href="${pageContext.request.contextPath}/loginMember">เข้าสู่ระบบ</a>
	            <a href="${pageContext.request.contextPath}/register">สมัครสมาชิก</a>
	        </div>
	
	        <div class="footer-col">
	            <h4 class="footer-heading">งานบุญของเรา</h4>
	            <a href="<c:url value='/reviews'><c:param name='type' value='ทำบุญบ้าน'/></c:url>">งานทำบุญบ้าน</a>
	            <a href="<c:url value='/reviews'><c:param name='type' value='ขึ้นบ้านใหม่'/></c:url>">งานขึ้นบ้านใหม่</a>
	            <a href="<c:url value='/reviews'><c:param name='type' value='ทำบุญออฟฟิศ'/></c:url>">งานทำบุญออฟฟิศ</a>
	        </div>
	
	        <div class="footer-col footer-contact-col">
	            <h4 class="footer-heading">ติดต่อเรา</h4>
	            <p>📞 โทร. 08X-XXX-XXXX</p>
	            <p>💬 LINE OA: @boonmee</p>
	            <p>✉️ boonmee.booking@gmail.com</p>
	            <p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
	        </div>
	    </div>
	</footer>
	
	</body>
	</html>
