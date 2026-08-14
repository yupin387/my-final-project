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
	    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/viewReview.css">
	    <%-- FIX: เพิ่มสไตล์สำหรับแถบดาวที่กดกรองได้ (bar-row กลายเป็น <a> แล้ว) และแท็ก
	         "กำลังกรอง" — ใส่ inline ไว้ในหน้านี้เพื่อไม่ต้องรอแก้ไฟล์ viewReview.css แยก
	         ย้ายไปไว้ใน viewReview.css ทีหลังได้ถ้าต้องการ --%>
	    <style>
	        .bar-row-link {
	            text-decoration: none;
	            color: inherit;
	            cursor: pointer;
	            border-radius: 8px;
	            padding: 2px 4px;
	            transition: background-color 0.15s ease;
	        }
	        .bar-row-link:hover {
	            background-color: rgba(217, 164, 65, 0.12);
	        }
	        .bar-row-active {
	            background-color: rgba(217, 164, 65, 0.22);
	            outline: 1px solid #D9A441;
	        }
	        .active-rating-tag {
	            display: inline-flex;
	            align-items: center;
	            gap: 8px;
	            margin: 10px 0 20px;
	            font-size: 14px;
	            color: var(--text-muted);
	        }
	        .clear-rating-link {
	            color: #C7405F;
	            text-decoration: underline;
	            font-weight: 600;
	        }
	    </style>
	</head>
	<body>
	
	<%-- ========== NAVBAR ========== --%>
	<nav class="navbar">
	    <a class="navbar-title" href="${pageContext.request.contextPath}/home">
	        <span class="navbar-logo">
	            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา จัดงานบุญ">
	        </span>
	        บุญมีนำพา จัดงานบุญ
	    </a>
	    <div class="navbar-right">
	        <div class="navbar-menu">
	            <a href="${pageContext.request.contextPath}/home" class="nav-item">หน้าหลัก</a>

	            <%-- ===== เมนู บริการ/แพ็กเกจ (dropdown)
	                 ใช้ ${ceremonyTypes} ที่ ReviewController ส่งมาให้ (buildCeremonyTypesForFooter())
	                 ลิงก์ไปหน้ารายละเอียดพิธี /ceremony/detail/{representativeId} ให้ตรงกับ route จริง
	                 (เดิมลิงก์ไป /ceremonies?type=... ซึ่งไม่มี route นี้อยู่จริง) ===== --%>
	            <div class="nav-dropdown">
	                <button type="button" class="nav-item nav-dropdown-toggle">บริการ/แพ็กเกจ <span class="caret">▾</span></button>
	                <div class="nav-dropdown-menu">
	                    <c:forEach var="t" items="${ceremonyTypes}">
	                        <a href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}">${t.mainName}</a>
	                    </c:forEach>
	                </div>
	            </div>

	            <%-- หมายเหตุ: ปรับ href ให้ตรงกับ route จริงของหน้าปฏิทินคิวงาน --%>
	            <div class="nav-dropdown">
	                <button type="button" class="nav-item nav-dropdown-toggle">ปฏิทิน <span class="caret">▾</span></button>
	                <div class="nav-dropdown-menu">
	                    <a href="${pageContext.request.contextPath}/calendar">ปฏิทินคิวงาน</a>
	                   
	                </div>
	            </div>

	            <c:if test="${not empty sessionScope.user}">
	               <a href="${pageContext.request.contextPath}/myBookings" class="nav-link-item">การจอง</a>
	            </c:if>
	            <a href="${pageContext.request.contextPath}/reviews" class="nav-item active">รีวิว</a>
	            <c:if test="${empty sessionScope.user}">
	                <a href="${pageContext.request.contextPath}/loginMember" class="nav-item">เข้าสู่ระบบ</a>
	            </c:if>
	        </div>
	        <c:if test="${empty sessionScope.user}">
	            <a href="${pageContext.request.contextPath}/register" class="btn-register">สมัครสมาชิก</a>
	        </c:if>
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
	         หมายเหตุ: ค่า type ต้องตรงกับ Ceremony.ceremonyType ในฐานข้อมูลเป๊ะ ๆ
	         ("ทำบุญบริษัทหรือออฟฟิศ" ไม่ใช่ "ทำบุญออฟฟิศ" — อิงตาม UserController)
	         Controller (/reviews) กรอง reviews ที่ booking.ceremony.ceremonyType ตรงกับค่านี้
	         และส่ง selectedCeremonyType กลับมาที่ view
	         FIX: แต่ละลิงก์ตอนนี้พ่วงค่า rating (ถ้ามีการกรองดาวอยู่) ไปด้วย เพื่อให้สลับ
	         ประเภทงานโดยไม่ทำให้ตัวกรองดาวที่เลือกไว้หายไป ==== --%>
	    <div class="filter-wrapper">
	        <c:url var="urlAll" value="/reviews">
	            <c:if test="${not empty selectedRating}"><c:param name="rating" value="${selectedRating}"/></c:if>
	        </c:url>
	        <a href="${urlAll}" class="btn-filter ${empty selectedCeremonyType ? 'active-link' : ''}">ทั้งหมด</a>

	        <c:url var="urlHome" value="/reviews">
	            <c:param name="type" value="ทำบุญบ้าน"/>
	            <c:if test="${not empty selectedRating}"><c:param name="rating" value="${selectedRating}"/></c:if>
	        </c:url>
	        <a href="${urlHome}" class="btn-filter ${selectedCeremonyType == 'ทำบุญบ้าน' ? 'active-link' : ''}">งานทำบุญบ้าน</a>

	        <c:url var="urlNewHouse" value="/reviews">
	            <c:param name="type" value="ขึ้นบ้านใหม่"/>
	            <c:if test="${not empty selectedRating}"><c:param name="rating" value="${selectedRating}"/></c:if>
	        </c:url>
	        <a href="${urlNewHouse}" class="btn-filter ${selectedCeremonyType == 'ขึ้นบ้านใหม่' ? 'active-link' : ''}">งานขึ้นบ้านใหม่</a>

	        <c:url var="urlCompany" value="/reviews">
	            <c:param name="type" value="ทำบุญบริษัทหรือออฟฟิศ"/>
	            <c:if test="${not empty selectedRating}"><c:param name="rating" value="${selectedRating}"/></c:if>
	        </c:url>
	        <a href="${urlCompany}" class="btn-filter ${selectedCeremonyType == 'ทำบุญบริษัทหรือออฟฟิศ' ? 'active-link' : ''}">งานทำบุญออฟฟิศ</a>
	    </div>

	    <%-- FIX: แท็กบอกว่ากำลังกรองดาวอยู่ + ปุ่มล้าง (คงค่า type เดิมไว้ ถ้ามี) --%>
	    <c:if test="${not empty selectedRating}">
	        <c:url var="urlClearRating" value="/reviews">
	            <c:if test="${not empty selectedCeremonyType}"><c:param name="type" value="${selectedCeremonyType}"/></c:if>
	        </c:url>
	        <div class="active-rating-tag">
	            กำลังกรอง: ${selectedRating} ดาว
	            <a href="${urlClearRating}" class="clear-rating-link">✕ ล้างตัวกรองดาว</a>
	        </div>
	    </c:if>
	
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
	        <%-- FIX: แถบสัดส่วนดาวแต่ละแถวตอนนี้เป็นลิงก์ที่กดกรองรีวิวตามจำนวนดาวนั้นได้
	             ไปที่ /reviews?rating={star} (พ่วง type เดิมไปด้วยถ้ามีการกรองประเภทงานอยู่) --%>
	        <div class="rating-bars">
	            <div class="rating-bars-title">สัดส่วนการให้คะแนน (กดเพื่อกรอง)</div>
	            <c:forEach begin="1" end="5" var="i">
	                <c:set var="star"  value="${6 - i}"/>
	                <c:set var="count" value="${starCounts[star] != null ? starCounts[star] : 0}"/>
	                <c:set var="total" value="${reviews.size() > 0 ? reviews.size() : 1}"/>
	                <c:set var="pct"   value="${count * 100 / total}"/>

	                <c:url var="urlStar" value="/reviews">
	                    <c:if test="${not empty selectedCeremonyType}"><c:param name="type" value="${selectedCeremonyType}"/></c:if>
	                    <c:param name="rating" value="${star}"/>
	                </c:url>

	                <a href="${urlStar}" class="bar-row bar-row-link ${selectedRating == star ? 'bar-row-active' : ''}">
	                    <span class="bar-label">${star} ดาว</span>
	                    <div class="bar-track">
	                        <div class="bar-fill" style="width:${pct}%"></div>
	                    </div>
	                    <span style="width:24px; font-size:12px; color:var(--text-muted);">${count}</span>
	                </a>
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
	            <div class="ceremony-badge">🪷 ประเภทงาน: ${r.bookingForm.ceremony.ceremonyType}</div>
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
	<%-- ========== FOOTER (โครงเดียวกับ home.jsp — แบบ slim: แบรนด์+โซเชียล / ติดต่อเรา) ========== --%>
	<footer class="site-footer">
	    <div class="footer-top">
	        <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg"
	             style="display: block; width: 100%; height: 8px;">
	            <rect width="1200" height="8" fill="url(#footerGrad)" />
	            <defs>
	                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
	                    <stop offset="0%" stop-color="rgba(217,164,65,0.15)" />
	                    <stop offset="50%" stop-color="rgba(217,164,65,0.9)" />
	                    <stop offset="100%" stop-color="rgba(217,164,65,0.15)" />
	                </linearGradient>
	            </defs>
	        </svg>
	    </div>
	    <div class="container footer-content footer-content-slim">
	        <div class="footer-col footer-brand-col">
	            <div class="footer-brand">
	                <div class="lotus-icon">
	                    <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมีนำพา จัดงานบุญ">
	                </div>
	                <span class="footer-brand-text">บุญมี รับจัดงานบุญ</span>
	            </div>
	            <p class="footer-tagline">รับจัดงานบุญ
	                ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
	            <div class="footer-social">
	                <a href="#" class="footer-social-link">📘 Facebook</a>
	                <a href="#" class="footer-social-link">▶️ YouTube</a>
	                <a href="#" class="footer-social-link">💬 LINE OA</a>
	            </div>
	        </div>

	        <div class="footer-col footer-contact-col">
	            <h4 class="footer-heading">ติดต่อเรา</h4>
	            <p>📞 โทร. 08X-XXX-XXXX</p>
	            <p>💬 LINE OA: @boonmee</p>
	            <p>✉️ boonmee@gmail.com</p>
	            <p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
	        </div>
	    </div>
	</footer>
	
	<script>
	document.querySelectorAll('.nav-dropdown-toggle').forEach(function (btn) {
	    btn.addEventListener('click', function (e) {
	        e.stopPropagation();
	        var dropdown = btn.closest('.nav-dropdown');
	        document.querySelectorAll('.nav-dropdown.show').forEach(function (d) {
	            if (d !== dropdown) d.classList.remove('show');
	        });
	        dropdown.classList.toggle('show');
	    });
	});
	document.addEventListener('click', function () {
	    document.querySelectorAll('.nav-dropdown.show').forEach(function (d) {
	        d.classList.remove('show');
	    });
	});
	</script>
	</body>
	</html>
