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
    <%-- TODO: ย้าย style ชุดนี้ไปไว้ใน viewReview.css ทีหลัง (ใส่ inline ไว้ก่อนเพราะยังไม่มีไฟล์ viewReview.css ให้แก้) --%>
    <style>
        .review-img-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            max-width: 220px;
        }
        .review-img-grid .review-img {
            width: 90px;
            height: 90px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid #C9944A;
            cursor: pointer;
            transition: transform 0.15s ease;
        }
        .review-img-grid .review-img:hover {
            transform: scale(1.04);
        }
        .review-img-lightbox-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.75);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            padding: 24px;
        }
        .review-img-lightbox-overlay.show {
            display: flex;
        }
        .review-img-lightbox-overlay img {
            max-width: 90vw;
            max-height: 85vh;
            border-radius: 10px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
        }
        .review-img-lightbox-close {
            position: fixed;
            top: 20px;
            right: 28px;
            font-size: 34px;
            color: #fff;
            cursor: pointer;
            line-height: 1;
            font-weight: 300;
        }

        /* .reviews-grid ตอนนี้อยู่ใน .reviews-section ซึ่งเป็น section แยกจาก .page-wrapper แล้ว
           (ไม่ได้ถูกบีบด้วย max-width: 860px ของ .page-wrapper อีกต่อไป)
           เลยกำหนดความกว้างตรงๆ ด้วย max-width + margin:auto ธรรมดา ไม่ต้องใช้ 100vw/translateX
           จึงไม่มีปัญหาล้นขอบจอหรือ scrollbar แนวนอนอีก และไม่ชิดขอบซ้าย-ขวาเกินไป
           ไม่กระจุกตรงกลางเท่า .page-wrapper (860px) เพราะกว้างกว่าอย่างชัดเจน */
        .reviews-section {
            width: 100%;
            box-sizing: border-box;
            padding: 0 40px 56px;
        }

        .reviews-grid {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            box-sizing: border-box;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 28px;
            align-items: stretch;
        }
        .reviews-grid .review-card {
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        /* การ์ดแคบลง เลยให้เนื้อหารีวิวกับรูปเรียงต่อกันแนวตั้งแทนซ้าย-ขวา */
        .reviews-grid .review-body {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .reviews-grid .review-img-grid {
            max-width: 100%;
        }
        .reviews-grid .review-img-grid .review-img {
            width: 72px;
            height: 72px;
        }
        @media (max-width: 1100px) {
            .reviews-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .reviews-section {
                padding: 0 24px 48px;
            }
        }
        @media (max-width: 640px) {
            .reviews-grid {
                grid-template-columns: 1fr;
            }
            .reviews-section {
                padding: 0 16px 40px;
            }
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

            <div class="nav-dropdown">
                <button type="button" class="nav-item nav-dropdown-toggle">บริการ/แพ็กเกจ <span class="caret">▾</span></button>
                <div class="nav-dropdown-menu">
                    <c:forEach var="t" items="${ceremonyTypes}">
                        <a href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}">${t.mainName}</a>
                    </c:forEach>
                </div>
            </div>

            <div class="nav-dropdown">
                <button type="button" class="nav-item nav-dropdown-toggle">ปฏิทิน <span class="caret">▾</span></button>
                <div class="nav-dropdown-menu">
                    <a href="${pageContext.request.contextPath}/calendar">ปฏิทินคิวงาน</a>
                </div>
            </div>

            <c:if test="${not empty sessionScope.user}">
               <a href="${pageContext.request.contextPath}/myBookings" class="nav-item">รายการจอง</a>
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

    <%-- ========== SUMMARY CARD (เหลือแค่กล่องคะแนนเฉลี่ยรวม) ========== --%>
    <div class="summary-card summary-card-solo">
        <div class="rating-big">
            <h1><fmt:formatNumber value="${avgRating}" pattern="0.00"/></h1>
            <div class="rating-label-sub">คะแนนเฉลี่ยรวม</div>
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
    </div>

    <%-- ===== แถวตัวกรองด้านล่าง: [ดรอปดาวน์เลือกประเภทงาน รวม "ดูรีวิวทั้งหมด"] [กรองดาว 5-1]
     FIX: กดปุ่มดาวที่กำลังกรองอยู่ซ้ำ (toggle) จะเอาตัวกรอง rating ออก
     กลับไปแสดงทั้งหมด หรือทั้งหมดของประเภทงานที่เลือกอยู่ (ถ้ามีการกรอง type ค้างอยู่) ===== --%>
	<div class="star-filter-row">
	    <c:url var="urlAll" value="/reviews">
	        <c:if test="${not empty selectedRating}"><c:param name="rating" value="${selectedRating}"/></c:if>
	    </c:url>
	    <c:url var="urlHome" value="/reviews">
	        <c:param name="type" value="ทำบุญบ้าน"/>
	        <c:if test="${not empty selectedRating}"><c:param name="rating" value="${selectedRating}"/></c:if>
	    </c:url>
	    <c:url var="urlNewHouse" value="/reviews">
	        <c:param name="type" value="ขึ้นบ้านใหม่"/>
	        <c:if test="${not empty selectedRating}"><c:param name="rating" value="${selectedRating}"/></c:if>
	    </c:url>
	    <c:url var="urlCompany" value="/reviews">
	        <c:param name="type" value="ทำบุญบริษัทหรือออฟฟิศ"/>
	        <c:if test="${not empty selectedRating}"><c:param name="rating" value="${selectedRating}"/></c:if>
	    </c:url>

	    <c:choose>
	        <c:when test="${empty selectedCeremonyType}"><c:set var="ceremonyLabel" value="ดูรีวิวทั้งหมด"/></c:when>
	        <c:when test="${selectedCeremonyType == 'ทำบุญบ้าน'}"><c:set var="ceremonyLabel" value="งานทำบุญบ้าน"/></c:when>
	        <c:when test="${selectedCeremonyType == 'ขึ้นบ้านใหม่'}"><c:set var="ceremonyLabel" value="งานขึ้นบ้านใหม่"/></c:when>
	        <c:otherwise><c:set var="ceremonyLabel" value="งานทำบุญออฟฟิศ"/></c:otherwise>
	    </c:choose>

	    <div class="ceremony-dropdown">
	        <button type="button"
	                class="ceremony-dropdown-toggle ${not empty selectedCeremonyType ? 'active-link' : ''}"
	                onclick="toggleCeremonyDropdown(event)">
	            <span>${ceremonyLabel}</span>
	            <span class="ceremony-dropdown-arrow">▾</span>
	        </button>
	        <div class="ceremony-dropdown-menu" id="ceremonyDropdownMenu">
	            <a href="${urlAll}" class="ceremony-dropdown-item ${empty selectedCeremonyType ? 'is-selected' : ''}">ดูรีวิวทั้งหมด</a>
	            <a href="${urlHome}" class="ceremony-dropdown-item ${selectedCeremonyType == 'ทำบุญบ้าน' ? 'is-selected' : ''}">งานทำบุญบ้าน</a>
	            <a href="${urlNewHouse}" class="ceremony-dropdown-item ${selectedCeremonyType == 'ขึ้นบ้านใหม่' ? 'is-selected' : ''}">งานขึ้นบ้านใหม่</a>
	            <a href="${urlCompany}" class="ceremony-dropdown-item ${selectedCeremonyType == 'ทำบุญบริษัทหรือออฟฟิศ' ? 'is-selected' : ''}">งานทำบุญออฟฟิศ</a>
	        </div>
	    </div>

	    <c:forEach begin="1" end="5" var="i">
	        <c:set var="star"  value="${6 - i}"/>
	        <c:set var="count" value="${starCounts[star] != null ? starCounts[star] : 0}"/>
	        <c:set var="isActiveStar" value="${selectedRating == star}"/>
	
	        <c:url var="urlStarBtn" value="/reviews">
	            <c:if test="${not empty selectedCeremonyType}"><c:param name="type" value="${selectedCeremonyType}"/></c:if>
	            <c:if test="${!isActiveStar}"><c:param name="rating" value="${star}"/></c:if>
	        </c:url>
	
	        <a href="${urlStarBtn}" class="btn-star-filter ${isActiveStar ? 'active-link' : ''}">
	            ${star}<span class="btn-star-filter-icon">★</span>
	            <span class="btn-star-filter-count">(${count})</span>
	        </a>
	    </c:forEach>
	</div>

    <%-- ========== KANOK DIVIDER ========== --%>
    <svg viewBox="0 0 860 32" xmlns="http://www.w3.org/2000/svg" style="display:block; width:100%; height:32px; margin: 12px 0 28px;">
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

    <%-- ========== REVIEW CARDS ==========
         หมายเหตุ: ปิด .page-wrapper ไว้ตรงนี้ก่อน แล้วเปิด .reviews-section ใหม่แยกออกมา
         เพราะ .page-wrapper ล็อก max-width: 860px ไว้ ถ้าใส่ .reviews-grid ไว้ข้างในจะขยายกว้างกว่านั้นไม่ได้เลย
         (เทคนิค 100vw full-bleed ที่เคยลองก่อนหน้านี้ ทำให้ล้นขอบจอ/เกิด scrollbar แนวนอน)
         การแยกเป็น section ของตัวเองแบบนี้ทำให้กำหนดความกว้างได้ตรงๆ ด้วย max-width + margin:auto
         โดยไม่ต้องพึ่ง viewport unit เลย ปลอดภัยกว่า ไม่ล้นจอ --%>
</div>

<div class="reviews-section">
    <div class="reviews-grid">
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
                <div class="review-body">
                    <div class="review-content">
                        <p class="review-text">"${r.comment}"</p>
                    </div>
                    <c:if test="${not empty r.reviewImage}">
                        <div class="review-img-grid">
                            <c:forEach items="${fn:split(r.reviewImage, ',')}" var="imgName">
                                <c:if test="${not empty imgName}">
                                    <img src="${pageContext.request.contextPath}/uploads/review/${imgName}"
                                         class="review-img" alt="ภาพรีวิว"
                                         onclick="openReviewImageLightbox(this.src)">
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<div class="page-wrapper">
    <c:if test="${empty reviews}">
        <div class="empty-state">
            <div class="empty-icon">🪷</div>
            <p>ยังไม่มีข้อมูลการรีวิวในขณะนี้</p>
        </div>
    </c:if>

</div>

<%-- ========== LIGHTBOX สำหรับคลิกขยายภาพรีวิว ========== --%>
<div class="review-img-lightbox-overlay" id="reviewImageLightbox" onclick="closeReviewImageLightbox()">
    <span class="review-img-lightbox-close" onclick="closeReviewImageLightbox()">&times;</span>
    <img id="reviewImageLightboxImg" src="" alt="ภาพรีวิวขยาย">
</div>

<%-- ========== FOOTER ========== --%>
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
            <p class="footer-tagline">รับจัดงานบุญ ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
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

// ===== Lightbox คลิกขยายภาพรีวิว =====
function openReviewImageLightbox(src) {
    const overlay = document.getElementById('reviewImageLightbox');
    const img = document.getElementById('reviewImageLightboxImg');
    if (!overlay || !img) return;
    img.src = src;
    overlay.classList.add('show');
}

function closeReviewImageLightbox() {
    const overlay = document.getElementById('reviewImageLightbox');
    if (overlay) overlay.classList.remove('show');
}

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeReviewImageLightbox();
});

// กันไม่ให้คลิกบนรูปในกล่อง lightbox แล้วปิดตัวเอง (ต้องคลิกพื้นหลังหรือปุ่ม × เท่านั้น)
document.getElementById('reviewImageLightboxImg')?.addEventListener('click', function (e) {
    e.stopPropagation();
});

// ===== Dropdown ตัวกรองประเภทงาน (หน้ารีวิว) =====
function toggleCeremonyDropdown(event) {
    if (event) event.stopPropagation();
    document.getElementById('ceremonyDropdownMenu')?.classList.toggle('show');
    event.currentTarget.classList.toggle('menu-open');
}

document.addEventListener('click', function (e) {
    const wrap = document.querySelector('.ceremony-dropdown');
    const menu = document.getElementById('ceremonyDropdownMenu');
    const toggleBtn = document.querySelector('.ceremony-dropdown-toggle');
    if (menu && wrap && !wrap.contains(e.target)) {
        menu.classList.remove('show');
        toggleBtn?.classList.remove('menu-open');
    }
});
</script>
</body>
</html>