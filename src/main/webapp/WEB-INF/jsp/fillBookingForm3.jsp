<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>จองงานทำบุญบริษัท - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bookingForm.css?v=10">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
      integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
      crossorigin=""/>
</head>
<body>

<%-- ========== NAVBAR (ให้ตรงกับหน้า home: มีเมนู บริการ/แพ็กเกจ และ ปฏิทิน แบบ dropdown) ========== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
        </div>
        <span class="nav-brand-text">บุญมีนำพา จัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item">หน้าหลัก</a>

        <%-- ===== เมนู บริการ/แพ็กเกจ (dropdown) ===== --%>
        <div class="nav-dropdown-wrap">
            <a href="javascript:void(0);" class="nav-link-item nav-dropdown-toggle">
                บริการ/แพ็กเกจ <span class="nav-caret">▾</span>
            </a>
            <div class="nav-dropdown-panel">
                <c:forEach var="t" items="${ceremonyTypes}">
                    <a href="${pageContext.request.contextPath}/ceremony/detail/${t.representativeId}"
                        class="nav-dropdown-link">${t.mainName}</a>
                </c:forEach>
            </div>
        </div>

        <%-- ===== เมนู ปฏิทิน (dropdown แยกฤกษ์ดี / ล้านนา) ===== --%>
        <div class="nav-dropdown-wrap">
            <a href="${pageContext.request.contextPath}/calendar" class="nav-link-item nav-dropdown-toggle">
                ปฏิทิน <span class="nav-caret">▾</span>
            </a>
            <div class="nav-dropdown-panel">
                <a href="${pageContext.request.contextPath}/calendar#calendarSection"
                    class="nav-dropdown-link">ปฏิทิน (ฤกษ์ดี)</a>
                <a href="${pageContext.request.contextPath}/calendar#lannaCalendarSection"
                    class="nav-dropdown-link">ปฏิทิน (ล้านนา)</a>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/myBookings" class="nav-link-item active">การจอง</a>

        <a href="${pageContext.request.contextPath}/reviews" class="nav-link-item">รีวิว</a>
    </div>
    <div class="dropdown-wrap">
        <div class="user-profile-pill" onclick="toggleDropdown()">
            <div class="avatar-circle-nav">${fn:substring(sessionScope.user.memberFirstName, 0, 1)}</div>
            <div class="user-info-text">
                <span class="user-name-nav">${sessionScope.user.memberFirstName} ${sessionScope.user.memberLastName}</span>
                <span class="user-role-nav">สมาชิก</span>
            </div>
        </div>
        <div class="dropdown-menu-custom" id="dropdownMenu">
            <a href="${pageContext.request.contextPath}/editProfile" class="dropdown-link">โปรไฟล์ของฉัน</a>
            <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">ออกจากระบบ</a>
        </div>
    </div>
</nav>

<%-- ========== HERO BANNER ========== --%>
<div class="hero-banner hero-company">
    <div class="hero-content">
        <span class="hero-tag">ระบบจองงานบุญ</span>
        <h1>จองงานทำบุญบริษัท</h1>
        <p>ระบุรายละเอียดให้ครบถ้วนเพื่อความถูกต้องของงานพิธี</p>
    </div>
</div>

<%-- ========== FORM ========== --%>
<div class="page-wrapper">
    <div class="form-container">
    <form action="${pageContext.request.contextPath}/saveBooking" method="post" novalidate onsubmit="return handleFormSubmit(this);">
        <c:set var="detailIndex" value="0"/>

        <%-- =========================================================
             โหมดการจอง (แพ็กเกจ / กรอกเอง) มาจากหน้า ceremonyDetail แล้ว
             (เลือก "เลือกจองแพ็กเกจนี้" หรือ "จองแบบระบุเอง" มาก่อนหน้านี้)
             ฉะนั้นไม่ต้องมีการ์ด "เลือกวิธีจอง" ซ้ำในฟอร์มนี้อีก — ใช้ค่าจาก
             param.custom เพื่อกำหนดโหมดการแสดงผลของฟอร์มแทน (ตัดการ์ดเลือกวิธีจอง
             และ bookingMode radio ที่เคยซ้อนอยู่ก่อนหน้านี้ทิ้ง เพื่อให้ทำงานแบบเดียว
             กับฟอร์มทำบุญบ้าน/ขึ้นบ้านใหม่ ไม่ต้องพึ่ง JS มา force โหมดซ้ำอีกชั้น)
             ========================================================= --%>
        <c:set var="startInCustomMode" value="${param.custom == 'true'}"/>

        <%-- =========================================================
             ข้อมูลร่วม (ใช้ทั้ง 2 โหมด) — วันเวลา / สถานที่ / รูปภาพ
             ========================================================= --%>
        <div class="form-grid">
		    <div>
		        <div class="form-card">
		            <div class="card-header">วันที่กรอกแบบฟอร์ม</div>
		            <div class="card-body">
		                <div class="form-group">
		                    <input type="text" class="form-control"
		                           value="<fmt:formatDate value='<%=new java.util.Date()%>' pattern='dd/MM/yyyy'/>"
		                           readonly>
		                </div>
		            </div>
		        </div>
		
		        <div class="form-card">
		            <div class="card-header">วันและเวลาจัดงาน</div>
		            <div class="card-body">
		                <div class="row-grid">
		                    <div class="form-group">
		                        <label class="form-label">วันที่จัดงาน <span class="required" style="color:red;">*</span></label>
		
		                        <div class="mini-cal-wrap" id="datePickerWrap">
		                            <div class="mini-cal-header">
		                                <button type="button" class="mini-cal-nav-btn" onclick="miniCalPrevMonth()">&#8249;</button>
		                                <span id="miniCalMonthTitle"></span>
		                                <button type="button" class="mini-cal-nav-btn" onclick="miniCalNextMonth()">&#8250;</button>
		                            </div>
		                            <div class="mini-cal-grid" id="miniCalGrid">
		                                <div class="mini-cal-day-label">อา</div>
		                                <div class="mini-cal-day-label">จ</div>
		                                <div class="mini-cal-day-label">อ</div>
		                                <div class="mini-cal-day-label">พ</div>
		                                <div class="mini-cal-day-label">พฤ</div>
		                                <div class="mini-cal-day-label">ศ</div>
		                                <div class="mini-cal-day-label">ส</div>
		                            </div>
		                            <div class="mini-cal-legend">
		                                <span><i class="mini-cal-dot mini-cal-dot-free"></i>ว่าง</span>
		                                <span><i class="mini-cal-dot mini-cal-dot-almost"></i>เหลือคิวสุดท้าย</span>
		                                <span><i class="mini-cal-dot mini-cal-dot-full"></i>เต็มคิว</span>
		                            </div>
		                            <p id="miniCalSelectedText" class="mini-cal-selected-text">ยังไม่ได้เลือกวันที่</p>
		                        </div>
		
		                        <input type="hidden" name="eventDate" id="eventDateInput"
		                               value="${not empty param.dates ? param.dates : selectedDates}">
		                    </div>
		                    <div class="form-group">
		                        <label class="form-label">เวลาเริ่มพิธี <span class="required" style="color:red;">*</span></label>
		                        <input type="time" name="eventTime" class="form-control" required>
		                    </div>
		                </div>
		            </div>
		        </div>
		    </div>
		
		    <div class="form-card">
		        <div class="card-header">สถานที่จัดพิธี</div>
		        <div class="card-body">
		            <!-- 1. ที่อยู่ -->
		            <div class="form-group">
		                <label class="form-label">ที่อยู่ที่ต้องการจัดงาน <span class="required" style="color:red;">*</span></label>
		                <textarea name="eventAddress" id="eventAddressField" class="form-control" rows="3" required
		                          placeholder="เช่น 123/45 หมู่บ้านบุญรักษา ตำบลสุทธิ อำเภอเมือง จังหวัดเชียงใหม่ 50000"></textarea>
		            </div>
		
		            <!-- 2. ปักหมุดแผนที่ -->
		            <div class="form-group" style="margin-top:16px;">
		                <label class="form-label">📍 ปักหมุดตำแหน่งที่จัดงาน <span class="required" style="color:red;">*</span></label>
		                <p style="font-size:12px;color:#B0345A;margin-bottom:10px;">
		                    คลิกบนแผนที่ หรือลากหมุดเพื่อระบุตำแหน่งจริงของสถานที่จัดงาน (ช่วยให้ทีมงานเดินทางไปถูกจุด)
		                </p>
		
		                <div class="map-picker-search-row">
		                    <input type="text" id="mapSearchInput" class="form-control"
		                           placeholder="พิมพ์ชื่อสถานที่ / ที่อยู่เพื่อค้นหาบนแผนที่...">
		                    <button type="button" class="map-picker-btn" onclick="searchLocationOnMap()">ค้นหา</button>
		                    <button type="button" class="map-picker-btn map-picker-btn-outline" onclick="useCurrentLocationOnMap()">
		                        ใช้ตำแหน่งปัจจุบัน
		                    </button>
		                </div>
		
		                <div id="locationMap" class="location-map-box"></div>
		
		                <p id="mapSelectedText" class="map-picker-selected-text">ยังไม่ได้ปักหมุดตำแหน่ง</p>
		                <a id="mapNavLink" href="#" target="_blank" rel="noopener" class="map-picker-nav-link" style="display:none;">
		                    🧭 เปิดนำทางใน Google Maps
		                </a>
		
		                <input type="hidden" name="eventLat" id="eventLat">
		                <input type="hidden" name="eventLng" id="eventLng">
		            </div>
		
		            <hr style="margin: 20px 0; border: 0; border-top: 1px solid #eee;">
		
		            <!-- 3. รูปภาพสถานที่ -->
		            <div class="form-group">
		                <label class="form-label">📸 รูปภาพสถานที่จัดงาน <span class="required" style="color:red;">*</span></label>
		                <p style="font-size:12px;color:#B0345A;margin-bottom:10px;">
		                    อัปโหลดได้หลายรูป เพื่อให้ทีมงานเตรียมการได้ถูกต้อง
		                </p>
		                <div id="imagePreviewBox" style="display:flex;flex-wrap:wrap;gap:8px;margin-bottom:10px;"></div>
		                <button type="button" onclick="document.getElementById('imgPicker').click()"
		                        style="cursor:pointer;background:#FBD0DE;border:1px dashed #E0577F;
		                               padding:8px 16px;border-radius:8px;color:#B0345A;font-size:13px;">
		                    + เพิ่มรูป
		                </button>
		                <input type="file" id="imgPicker" accept="image/*" style="display:none">
		                <div id="base64Container"></div>
		            </div>
		        </div>
		    </div>
		</div>
        <%-- =========================================================
             1. รายละเอียดการจอง — ใช้ชุดคำถามเดียวกันทั้ง 2 โหมด
             ========================================================= --%>

        <%-- 1.1 เลือกแพ็กเกจ — โชว์เฉพาะโหมดแพ็กเกจ --%>
        <div class="form-card" id="packageOnlyBlock" style="${startInCustomMode ? 'display:none;' : 'display:block;'}">
            <div class="card-header">แพ็กเกจที่เลือก</div>
            <div class="card-body">
                <%-- หมายเหตุ: เครื่องเสียง/โต๊ะหมู่บูชา รวมอยู่ในทุกแพ็กเกจอยู่แล้ว
                     ใส่ note บอกลูกค้าให้ชัดเจนแบบเดียวกับ note ของสังฆทาน --%>
                <p style="font-size:12px;color:#B0345A;margin:-4px 0 14px;">
                    ℹ️ ทุกแพ็กเกจรวมชุดเครื่องเสียง โต๊ะหมู่บูชา และพระประธานไว้ให้แล้ว ทางร้านเป็นผู้จัดเตรียมให้ทั้งหมด
                </p>
                <div class="item-card-grid">
                    <c:forEach items="${ceremonies}" var="pkg" varStatus="loop">
                        <c:set var="pkgNameSafe" value="${not empty pkg.ceremonyName ? pkg.ceremonyName : ''}"/>
                        <c:choose>
                            <c:when test="${fn:contains(pkgNameSafe, 'พรีเมียม')}">
                                <c:set var="pkgMonkCount" value="9"/>
                            </c:when>
                            <c:when test="${fn:contains(pkgNameSafe, 'อิ่มบุญ')}">
                                <c:set var="pkgMonkCount" value="7"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="pkgMonkCount" value="5"/>
                            </c:otherwise>
                        </c:choose>
                        <c:set var="isPkgSelected"
                               value="${(not empty param.ceremonyId and param.ceremonyId == pkg.ceremonyId) or (empty param.ceremonyId and loop.first)}"/>
                        <c:if test="${empty param.ceremonyId or param.ceremonyId == pkg.ceremonyId}">
                        <label class="item-card">
                            <input type="radio" name="ceremony.ceremonyId" value="${pkg.ceremonyId}"
                                   data-monkcount="${pkgMonkCount}"
                                   onchange="applyPackageMonkCount(this)"
                                   ${isPkgSelected ? 'checked' : ''}>
                        <div class="item-card-thumb">
    <img src="${pageContext.request.contextPath}/static/images/p${loop.index + 1}.png" alt="${pkg.ceremonyName}"
         onclick="event.preventDefault(); event.stopPropagation(); openLightbox(this);">
</div>
                            <div class="item-card-body">
                                <div class="item-card-name">${pkg.ceremonyName}</div>
                                <div class="item-card-desc">${pkg.ceremonyDetail}</div>
                                <div class="item-card-price">
                                    ฿<fmt:formatNumber value="${pkg.basePrice}" pattern="#,###"/>
                                </div>
                            </div>
                        </label>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div id="customCeremonyWrap" style="${startInCustomMode ? 'display:block;' : 'display:none;'}">
            <input type="hidden" name="ceremony.ceremonyId" id="customCeremonyId" value="${defaultCeremonyId}">
        </div>

        <%-- 1.2 การนิมนต์พระสงฆ์ — ใช้ร่วมกันทั้ง 2 โหมด --%>
		<div class="form-card">
		    <div class="card-header">การนิมนต์พระสงฆ์</div>
		    <div class="card-body">
		
		        <c:forEach items="${questions}" var="q">
		            <c:if test="${fn:contains(q.questionsText, 'รูปแบบการนิมนต์')}">
		                <div class="form-group">
		                    <label class="form-label">${q.questionsText} <span class="required" style="color:red;">*</span></label>
		                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
		                    <div class="checkbox-group">
		                        <label class="checkbox-label">
		                            <input type="radio" name="details[${detailIndex}].answer" value="ให้ทางร้านนิมนต์"
		                                   onchange="toggleWatDetailBlock('watDetail', true)" checked>
		                            <span>ให้ทางร้านนิมนต์</span>
		                        </label>
		                        <label class="checkbox-label">
		                            <input type="radio" name="details[${detailIndex}].answer" id="selfInviteRadio"
		                                   value="${startInCustomMode ? 'นิมนต์เอง' : 'นิมนต์เอง (ลด ฿1,500)'}"
		                                   onchange="toggleWatDetailBlock('watDetail', false)">
		                            <span>นิมนต์เอง <small id="selfInviteDiscountNote"
		                                  style="color:#2e7d32;${startInCustomMode ? 'display:none;' : ''}">(รับส่วนลด ฿1,500)</small></span>
		                        </label>
		                    </div>
		                    <p style="font-size:12px;color:red;margin-top:6px;">
		                        ⚠️ กรณีนิมนต์เอง วัดที่นิมนต์ต้องอยู่ในรัศมีพื้นที่ให้บริการที่ทางร้านกำหนดเท่านั้น
		                    </p>
		                </div>
		                <c:set var="detailIndex" value="${detailIndex + 1}"/>
		            </c:if>
		        </c:forEach>
		
		        <c:forEach items="${questions}" var="q">
		            <c:if test="${fn:contains(q.questionsText, 'จำนวนพระ')}">
		                <div class="form-group" id="monkCountGroup" style="margin-top:14px; ${startInCustomMode ? 'display:block;' : 'display:none;'}">
		                    <label class="form-label">${q.questionsText} <span class="required" style="color:red;">*</span></label>
		                    <p style="font-size:12px;color:#B0345A;margin-top:2px;">
		                        ระบุจำนวนพระสงฆ์ที่ต้องการก่อน เพื่อให้ระบบแสดงช่องเลือกวัดให้ครบตามจำนวน
		                    </p>
		                    <input type="hidden" name="details[${detailIndex}].question.questionsId" id="monkCountQuestionIdField" value="${q.questionsId}">
		                    <input type="number" name="details[${detailIndex}].answer" id="monkCountField"
		                           class="form-control" placeholder="เช่น 5" min="1" required
		                           oninput="onMonkCountInputChange(this.value)">
		                </div>
		                <c:set var="detailIndex" value="${detailIndex + 1}"/>
		            </c:if>
		        </c:forEach>
		
		        <div id="watDetail" style="display:block; margin-bottom:14px;">
		            <c:forEach items="${questions}" var="q">
		                <c:if test="${fn:contains(q.questionsText, 'รายละเอียดการนิมนต์')}">
		                    <div class="form-group">
		                        <label class="form-label">รายละเอียดการนิมนต์พระสงฆ์ <span class="required" style="color:red;">*</span></label>
		                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
		                        <div class="checkbox-group">
		                            <label class="checkbox-label">
		                                <input type="radio" name="watType" value="ต่างวัด"
		                                       onchange="toggleWatOwnField('watDiff', true);
		                                                 renderWatDropdowns('watDropdowns','watDiffAnswer', document.getElementById('monkCountField').value);">
		                                <span>ระบุวัดที่ต้องการเป็นรายรูป <small style="color:#B0345A;">(เลือกได้ครบตามจำนวนพระสงฆ์ที่นิมนต์)</small></span>
		                            </label>
		                            <label class="checkbox-label">
		                                <input type="radio" name="watType" value="ให้ร้านเลือกให้"
		                                       onchange="toggleWatOwnField('watDiff', false); document.getElementById('watDiffAnswer').value='ให้ร้านเลือกให้';" checked>
		                                <span>ให้ทางร้านเลือกให้ทั้งหมด <small style="color:#B0345A;">(เลือกวัดใกล้พื้นที่จัดงาน)</small></span>
		                            </label>
		                        </div>
		
		                        <textarea name="details[${detailIndex}].answer" id="watDiffAnswer"
		                                  class="form-control" style="display:none;">ให้ร้านเลือกให้</textarea>
		
		                        <p style="font-size:12px;color:red;margin:8px 0 0;">
		                            หมายเหตุ: วัดที่ระบุอาจมีการเปลี่ยนแปลงได้ตามความสะดวกของพระสงฆ์ในวันงาน
		                            หรือในกรณีที่วันจัดงานตรงกับวันฤกษ์ดีซึ่งอาจมีการนิมนต์ชนกัน
		                            ทางร้านจะติดต่อลูกค้าเพื่อยืนยันอีกครั้ง
		                        </p>
		
		                        <div id="watDiff" style="display:none; margin-top:12px;">
		                            <p style="font-size:12px;color:var(--text-muted);margin-bottom:8px;">
		                                ระบุวัดที่ต้องการสำหรับพระแต่ละรูปได้ครบตามจำนวนพระสงฆ์ที่นิมนต์ไว้ด้านบน
		                                รูปใดไม่มีวัดที่ต้องการเป็นพิเศษ เลือก "ให้ทางร้านเลือกให้" สำหรับรูปนั้นได้เลย
		                            </p>
		                            <div id="watDropdowns">
		                                <p class="wat-picker-empty">กรุณาระบุจำนวนพระสงฆ์ก่อน จึงจะแสดงช่องเลือกวัด</p>
		                            </div>
		                        </div>
		                    </div>
		                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
		                </c:if>
		            </c:forEach>
		        </div>
		
		    </div>
		</div>

        <%-- 1.3 เลือกชุดสังฆทาน --%>
        <div class="form-card">
            <div class="card-header">เลือกชุดสังฆทาน</div>
            <div class="card-body">

                <c:forEach items="${questions}" var="q">
                    <c:if test="${fn:contains(q.questionsText, 'จำนวนชุดสังฆทาน')}">
                        <div class="form-group" style="margin-bottom:14px;">
                            <label class="form-label">${q.questionsText} <span class="required" style="color:red;">*</span></label>
                            <p style="font-size:12px;color:#B0345A;margin-top:2px;">
                                ค่าเริ่มต้น = จำนวนพระสงฆ์ที่นิมนต์ไว้ด้านบน แก้ไขจำนวนเองได้หากต้องการ
                            </p>
                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                            <%-- FIX: เดิม value="5" ตายตัวไม่ว่าจะโหมดไหน ทำให้โหมด "จองแบบระบุเอง"
                                 ก็ขึ้นเลข 5 มาให้ทั้งที่ยังไม่ได้เลือกจำนวนพระสงฆ์เลย
                                 ค่า fix 5 ควรเกิดจากการเลือกแพ็กเกจมาตรฐานเท่านั้น (ผ่าน applyPackageMonkCount)
                                 โหมดกรอกเองจึงให้เริ่มว่าง ให้ผู้ใช้กรอกเอง --%>
                            <input type="number" name="details[${detailIndex}].answer" id="sanghatanQtyInput"
                                   class="form-control" value="${startInCustomMode ? '' : 5}" min="1"
                                   placeholder="ระบุจำนวนชุด..."
                                   oninput="this.dataset.userEdited = 'true';">
                        </div>
                        <c:set var="detailIndex" value="${detailIndex + 1}"/>
                    </c:if>
                </c:forEach>

                <c:forEach items="${questions}" var="q">
                    <c:if test="${fn:contains(q.questionsText, 'เลือกชุดสังฆทาน')}">
                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                        <div class="item-card-grid">
                            <c:forEach items="${sanghatharnItems}" var="item" varStatus="loop">
                                <label class="item-card">
                                    <input type="radio" name="details[${detailIndex}].answer"
                                           value="${item.itemName}" ${loop.first ? 'checked' : ''}>
                                    <div class="item-card-thumb">
                                        <img src="${pageContext.request.contextPath}/static/images/offeringsetimg/F${(loop.index % 3) + 1}.png" alt="${item.itemName}"
                                             onclick="event.preventDefault(); event.stopPropagation(); openLightbox(this);">
                                    </div>
                                    <div class="item-card-body">
                                        <div class="item-card-name">${item.itemName}</div>
                                        <div class="item-card-desc">${item.itemDetail}</div>
                                        <div class="item-card-price">
                                            ฿<fmt:formatNumber value="${item.pricePerUnit}" pattern="#,###"/> / ${item.unit}
                                        </div>
                                    </div>
                                </label>
                            </c:forEach>
                        </div>
                        <c:set var="detailIndex" value="${detailIndex + 1}"/>
                    </c:if>
                </c:forEach>

            </div>
        </div>

        <%-- 1.4 ชุดภัตตาหารปิ่นโต --%>
        <div class="form-card">
            <div class="card-header">ชุดภัตตาหารปิ่นโต</div>
            <div class="card-body">

                <c:forEach items="${questions}" var="q">
                    <c:if test="${fn:contains(q.questionsText, 'ต้องการชุดภัตตาหาร')}">
                        <c:set var="pintoWantIndex" value="${detailIndex}"/>
                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                        <c:set var="detailIndex" value="${detailIndex + 1}"/>
                    </c:if>
                </c:forEach>

                <div class="form-group">
                    <label class="form-label">ต้องการชุดภัตตาหารปิ่นโตหรือไม่? <span class="required" style="color:red;">*</span></label>
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="radio" name="details[${pintoWantIndex}].answer" value="ต้องการ"
                                   onchange="toggleSection('pintoDetail', true)" checked>
                            <span>ต้องการ</span>
                        </label>
                        <label class="checkbox-label">
                            <input type="radio" name="details[${pintoWantIndex}].answer" value="ไม่ต้องการ"
                                   onchange="toggleSection('pintoDetail', false)">
                            <span>ไม่ต้องการ</span>
                        </label>
                    </div>
                </div>

                <div id="pintoDetail" style="display:block; margin-top:14px;">

                    <c:forEach items="${questions}" var="q">
                        <c:if test="${fn:contains(q.questionsText, 'จำนวนชุดภัตตาหาร')}">
                            <div class="form-group" style="margin-bottom:14px;">
                                <label class="form-label">${q.questionsText}<span class="required" style="color:red;">*</span></label>
                                <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                <input type="number" name="details[${detailIndex}].answer"
                                       class="form-control" placeholder="ระบุจำนวนชุด..." min="1">
                            </div>
                            <c:set var="detailIndex" value="${detailIndex + 1}"/>
                        </c:if>
                    </c:forEach>

                    <c:forEach items="${questions}" var="q">
                        <c:if test="${fn:contains(q.questionsText, 'เลือกชุดภัตตาหาร')}">
                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                            <div class="item-card-grid">
                                <c:forEach items="${pintoItems}" var="item" varStatus="loop">
                                    <c:if test="${fn:contains(item.itemName, 'ชุด')}">
                                        <label class="item-card">
                                            <input type="radio" name="details[${detailIndex}].answer"
                                                   value="${item.itemName}" ${loop.first ? 'checked' : ''}>
                                            <div class="item-card-thumb">
                                                <img src="${pageContext.request.contextPath}/static/images/foodimg/food${(loop.index % 5) + 1}.png" alt="${item.itemName}"
                                                     onclick="event.preventDefault(); event.stopPropagation(); openLightbox(this);">
                                            </div>
                                            <div class="item-card-body">
                                                <div class="item-card-name">${item.itemName}</div>
                                                <div class="item-card-desc">${item.itemDetail}</div>
                                                <div class="item-card-price">
                                                    ฿<fmt:formatNumber value="${item.pricePerUnit}" pattern="#,###"/> / ${item.unit}
                                                </div>
                                            </div>
                                        </label>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <c:set var="detailIndex" value="${detailIndex + 1}"/>
                        </c:if>
                    </c:forEach>

                </div>

            </div>
        </div>

        <%-- 1.5 หมายเหตุเพิ่มเติม
             คำถามนี้ต้องดึงมาจาก ${questions} เหมือนคำถามอื่นๆ ในฟอร์ม (ผูกกับ
             details[].question.questionsId / details[].answer ตามแพทเทิร์นเดิม)
             ไม่ใช่ field แยกต่างหากแบบ additionalNote — ต้องมีแถวคำถามในตาราง
             Questionsdetail ที่มี questionsText = "มีความต้องการเพิ่มเติมหรือไม่?"
             ผูกกับ ceremony ที่เกี่ยวข้องไว้ก่อน ฟอร์มถึงจะดึงมาแสดงได้
             (เนื้อหาเป็นเรื่องอุปกรณ์/รายละเอียดอื่นๆ ไม่ใช่เรื่องอาหารแขก
              เพราะเรื่องอาหารมีคำถามของตัวเองอยู่แล้วในส่วนปิ่นโตด้านบน) --%>
        <c:forEach items="${questions}" var="q">
            <c:if test="${fn:contains(q.questionsText, 'ความต้องการเพิ่มเติม')}">
                <div class="form-card">
                    <div class="card-header">หมายเหตุเพิ่มเติม</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label">${q.questionsText}</label>
                            <p style="font-size:12px;color:#B0345A;margin-top:2px;">
                                เช่น อุปกรณ์เพิ่มเติม เก้าอี้ ผ้าคลุมโต๊ะ หรือรายละเอียดอื่นๆ พร้อมกรอกจำนวนที่ต้องการ
                            </p>
                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                            <textarea name="details[${detailIndex}].answer" class="form-control" rows="3"
                                      placeholder="เช่น ต้องการเก้าอี้เพิ่ม 10 ตัว เป็นต้น"></textarea>
                        </div>
                    </div>
                </div>
                <c:set var="detailIndex" value="${detailIndex + 1}"/>
            </c:if>
        </c:forEach>

        <div class="submit-row">
            <button type="submit" class="btn-submit">บันทึกข้อมูลการจอง</button>
        </div>
    </form>
    </div>
</div>

<%-- ========== FOOTER ========== --%>
<footer class="site-footer">
    <div class="footer-top">
        <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;">
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
                <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
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

<style>
.item-card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 10px;
}
.item-card {
    position: relative;
    display: flex;
    flex-direction: column;
    border: 1.5px solid var(--cream-border-soft);
    border-radius: 10px;
    padding: 10px;
    cursor: pointer;
    background: #FFFFFF;
    transition: border-color .15s, box-shadow .15s;
}
.item-card:hover { border-color: var(--gold-mid); }
.item-card:has(input:checked) {
    border-color: var(--gold-mid);
    box-shadow: 0 0 0 2px rgba(224,87,127,0.22);
}
.item-card-thumb {
    width: 100%; height: 72px;
    overflow: hidden;
    border-radius: 8px; margin-bottom: 6px;
    background: var(--cream-mid);
}
.item-card-thumb img {
    width: 100%; height: 100%;
    object-fit: cover; display: block;
    cursor: zoom-in;
}
.item-card-name {
    font-weight: 700; font-size: 12.5px; color: var(--brown-dark); margin-bottom: 3px;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.item-card-desc {
    font-size: 11px; color: var(--text-muted); line-height: 1.4; margin-bottom: 4px;
    display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.item-card-price { font-size: 12px; font-weight: 700; color: var(--gold); }

.image-lightbox {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.78);
    z-index: 100000;
    align-items: center;
    justify-content: center;
    padding: 30px;
    cursor: zoom-out;
}
.image-lightbox img {
    max-width: 90vw;
    max-height: 88vh;
    border-radius: 10px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.5);
    cursor: default;
}
.image-lightbox-close {
    position: absolute;
    top: 18px;
    right: 30px;
    color: #FFFFFF;
    font-size: 34px;
    line-height: 1;
    font-weight: 400;
    cursor: pointer;
}

/* ===== Mini Calendar (เลือกวันที่จัดงานในฟอร์ม) ===== */
.mini-cal-wrap {
    border: 1.5px solid var(--cream-border-soft);
    border-radius: 10px;
    padding: 12px;
    background: #FFF9FB;
}
.mini-cal-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 14px;
    font-weight: 700;
    color: var(--brown-dark, #5C3800);
    margin-bottom: 8px;
}
.mini-cal-nav-btn {
    background: #FBD0DE;
    border: none;
    border-radius: 6px;
    width: 26px;
    height: 26px;
    cursor: pointer;
    color: #B0345A;
    font-size: 15px;
}
.mini-cal-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 3px;
}
.mini-cal-day-label {
    text-align: center;
    font-size: 11px;
    color: var(--text-muted);
    padding: 2px 0;
}
.mini-cal-cell {
    position: relative;
    aspect-ratio: 1;
    border-radius: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    cursor: pointer;
    border: 1px solid transparent;
}
.mini-cal-cell-empty { cursor: default; }
.mini-cal-cell-free { background: #E9F7EF; border-color: #B7E4C7; }
.mini-cal-cell-almost { background: #FFF3D6; border-color: #F0CE7E; }
.mini-cal-cell-booked { background: #FBE3E7; border-color: #E9A9B4; cursor: not-allowed; }
.mini-cal-cell-past { background: #F0F0F0; border-color: #DADADA; cursor: not-allowed; color: #B0B0B0; }
.mini-cal-cell-today { outline: 2px solid #E0577F; }
.mini-cal-cell-selected { outline: 2px solid #B0345A; box-shadow: 0 0 0 2px rgba(224,87,127,0.25); }
.mini-cal-full-mark {
    position: absolute;
    top: 1px;
    right: 3px;
    font-size: 9px;
    color: #B0345A;
}
.mini-cal-legend {
    display: flex;
    gap: 12px;
    margin-top: 8px;
    font-size: 11px;
    color: var(--text-muted);
    flex-wrap: wrap;
}
.mini-cal-dot {
    display: inline-block;
    width: 9px;
    height: 9px;
    border-radius: 2px;
    margin-right: 4px;
}
.mini-cal-dot-free { background: #B7E4C7; }
.mini-cal-dot-almost { background: #F0CE7E; }
.mini-cal-dot-full { background: #E9A9B4; }
.mini-cal-selected-text {
    font-size: 12px;
    color: #B0345A;
    margin: 8px 0 0;
    font-weight: 600;
}

/* ===== Navbar dropdown (บริการ/แพ็กเกจ, ปฏิทิน) — ให้ตรงกับหน้า home ===== */
.nav-dropdown-wrap {
    position: relative;
    display: inline-block;
}
.nav-dropdown-toggle {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    cursor: pointer;
}
.nav-caret {
    font-size: 0.7rem;
    transition: transform 0.2s ease;
}
.nav-dropdown-wrap:hover .nav-caret {
    transform: rotate(180deg);
}
.nav-dropdown-panel {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    min-width: 220px;
    background: var(--white, #fff);
    border: 1px solid var(--gold-pale, #e8cc70);
    border-radius: 10px;
    box-shadow: 0 8px 24px rgba(61, 37, 0, 0.15);
    padding: 8px 0;
    z-index: 100;
}
.nav-dropdown-wrap:hover .nav-dropdown-panel,
.nav-dropdown-wrap:focus-within .nav-dropdown-panel {
    display: block;
}
.nav-dropdown-link {
    display: block;
    padding: 10px 18px;
    font-size: 0.92rem;
    color: var(--brown-dark, #3d2500);
    text-decoration: none;
    white-space: nowrap;
}
.nav-dropdown-link:hover {
    background: var(--gold-pale, #fff8e1);
}
</style>

<%-- ========== IMAGE LIGHTBOX ========== --%>
<div id="imageLightbox" class="image-lightbox" onclick="closeLightbox()">
    <span class="image-lightbox-close" onclick="closeLightbox()">&times;</span>
    <img id="lightboxImg" src="" alt="">
</div>


<script>
(function() {
    var imgPicker = document.getElementById('imgPicker');
    if (!imgPicker) return;
    var imageList = [];
    imgPicker.addEventListener('change', function() {
        var file = this.files[0];
        if (!file) return;
        var reader = new FileReader();
        reader.onload = function(e) {
            imageList.push(e.target.result);
            var box = document.getElementById('imagePreviewBox');
            var wrapper = document.createElement('div');
            wrapper.style.cssText = 'position:relative;width:80px;height:80px;';
            var img = document.createElement('img');
            img.src = e.target.result;
            img.style.cssText = 'width:80px;height:80px;object-fit:cover;border-radius:6px;border:1px solid #E0577F;';
            var del = document.createElement('button');
            del.type = 'button'; del.innerText = 'x';
            del.style.cssText = 'position:absolute;top:2px;right:2px;background:rgba(0,0,0,0.5);color:white;border:none;border-radius:50%;width:20px;height:20px;cursor:pointer;';
            var idx = imageList.length - 1;
            del.onclick = function() {
                imageList.splice(idx, 1);
                box.removeChild(wrapper);
                updateInputs();
            };
            wrapper.appendChild(img);
            wrapper.appendChild(del);
            box.appendChild(wrapper);
            updateInputs();
        };
        reader.readAsDataURL(file);
        this.value = '';
    });
    function updateInputs() {
        var container = document.getElementById('base64Container');
        container.innerHTML = '';
        for (var i = 0; i < imageList.length; i++) {
            var inp = document.createElement('input');
            inp.type = 'hidden';
            inp.name = 'imageBase64[' + i + ']';
            inp.value = imageList[i];
            container.appendChild(inp);
        }
    }
})();

function toggleWatOwnField(id, show) {
    var el = document.getElementById(id);
    if (el) el.style.display = show ? 'block' : 'none';
}

function openLightbox(imgEl) {
    var lb = document.getElementById('imageLightbox');
    var lbImg = document.getElementById('lightboxImg');
    if (!lb || !lbImg) return;
    lbImg.src = imgEl.src;
    lbImg.alt = imgEl.alt || '';
    lb.style.display = 'flex';
}

function closeLightbox() {
    var lb = document.getElementById('imageLightbox');
    if (lb) lb.style.display = 'none';
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeLightbox();
});

function toggleWatDetailBlock(id, show) {
    var el = document.getElementById(id);
    if (el) el.style.display = show ? 'block' : 'none';
}

function toggleSection(id, show) {
    var el = document.getElementById(id);
    if (el) el.style.display = show ? 'block' : 'none';
}

var watOptionList = [
    "ให้ทางร้านเลือกให้",
    "วัดพระสิงห์วรมหาวิหาร",
    "วัดเจดีย์หลวงวรวิหาร",
    "วัดสวนดอก (วัดบุพพาราม)",
    "วัดเชียงมั่น",
    "วัดพระธาตุดอยสุเทพราชวรวิหาร",
    "วัดอุโมงค์ (สวนพุทธธรรม)",
    "วัดโลกโมฬี",
    "วัดพันเตา",
    "วัดชัยมงคล",
    "วัดดับภัย",
    "วัดหมื่นล้าน",
    "วัดเจ็ดยอด (วัดโพธารามมหาวิหาร)",
    "อื่นๆ (ระบุวัดเอง)" // 1. เพิ่มตัวเลือกอื่นๆ
];

function renderWatDropdowns(containerId, textareaId, count) {
    var container = document.getElementById(containerId);
    var textarea = document.getElementById(textareaId);
    if (!container || !textarea) return;

    count = parseInt(count, 10);
    if (!count || count < 1) {
        container.innerHTML = '<p class="wat-picker-empty">กรุณาระบุจำนวนพระสงฆ์ก่อน จึงจะแสดงช่องเลือกวัด</p>';
        textarea.value = '';
        return;
    }

    container.innerHTML = '';
    container.dataset.totalCount = count;

    for (var i = 1; i <= count; i++) {
        var row = document.createElement('div');
        row.className = 'wat-picker-row';
        row.style.marginBottom = '8px';
        
        var label = document.createElement('span');
        label.className = 'wat-picker-label';
        label.innerText = 'รูปที่ ' + i;
        
        var select = document.createElement('select');
        select.className = 'form-select';
        watOptionList.forEach(function(w) {
            var opt = document.createElement('option');
            opt.value = w;
            opt.innerText = '▼ ' + w;
            select.appendChild(opt);
        });
        
        // 2. สร้างกล่อง input สำหรับพิมพ์ชื่อวัด (ซ่อนไว้เป็นค่าเริ่มต้น)
        var customInputWrap = document.createElement('div');
        customInputWrap.className = 'custom-wat-wrap';
        customInputWrap.style.display = 'none';
        customInputWrap.style.marginTop = '6px';
        
        var customInput = document.createElement('input');
        customInput.type = 'text';
        customInput.className = 'form-control custom-wat-input';
        customInput.placeholder = 'พิมพ์ชื่อวัดที่ต้องการ...';
        customInput.style.fontSize = '13px';
        
        // 3. สร้างข้อความแจ้งเตือนสีแดง
        var warningText = document.createElement('p');
        warningText.style.fontSize = '12px';
        warningText.style.color = '#c0392b';
        warningText.style.margin = '4px 0 0 0';
        warningText.innerText = '* วัดที่ระบุต้องอยู่บริเวณใกล้เคียงสถานที่จัดงานเท่านั้น และอาจมีการเปลี่ยนแปลงตามความสะดวกของพระสงฆ์';
        
        customInputWrap.appendChild(customInput);
        customInputWrap.appendChild(warningText);

        // 4. ผูก Event เปิด/ปิด กล่องพิมพ์ข้อความ
        select.addEventListener('change', (function(currentWrap) {
            return function() {
                if (this.value === 'อื่นๆ (ระบุวัดเอง)') {
                    currentWrap.style.display = 'block';
                } else {
                    currentWrap.style.display = 'none';
                }
                syncWatAnswer(containerId, textareaId);
            };
        })(customInputWrap));
        
        // 5. ผูก Event อัปเดตข้อมูลเมื่อมีการพิมพ์
        customInput.addEventListener('input', function() {
            syncWatAnswer(containerId, textareaId);
        });

        row.appendChild(label);
        row.appendChild(select);
        row.appendChild(customInputWrap);
        container.appendChild(row);
    }

    syncWatAnswer(containerId, textareaId);
}

function syncWatAnswer(containerId, textareaId) {
    var container = document.getElementById(containerId);
    var textarea = document.getElementById(textareaId);
    if (!container || !textarea) return;
    
    var rows = container.querySelectorAll('.wat-picker-row');
    var lines = [];
    
    rows.forEach(function(row, idx) {
        var select = row.querySelector('select');
        var customInput = row.querySelector('.custom-wat-input');
        var val = select.value;
        
        // 6. ถ้าเลือกอื่นๆ ให้ดึงค่าจากช่อง input ที่พิมพ์มาแทน
        if (val === 'อื่นๆ (ระบุวัดเอง)') {
            val = customInput.value.trim() ? ('(อื่นๆ) ' + customInput.value.trim()) : '(อื่นๆ) ยังไม่ระบุ';
        }
        
        lines.push('รูปที่ ' + (idx + 1) + ' ' + val);
    });
    
    textarea.value = lines.join('\n');
}

/* sync จาก dropdown เฉพาะตอนเลือก "ต่างวัด" เท่านั้น */
function syncAllWatAnswersBeforeSubmit() {
    var watTypeRadio = document.querySelector('input[name="watType"]:checked');
    if (watTypeRadio && watTypeRadio.value === 'ต่างวัด') {
        syncWatAnswer('watDropdowns', 'watDiffAnswer');
    }
    return true;
}

function applyPackageMonkCount(radio) {
    var input = document.getElementById('monkCountField');
    if (input && radio.dataset.monkcount) {
        input.value = radio.dataset.monkcount;
    }
    var qtyInput = document.getElementById('sanghatanQtyInput');
    if (qtyInput && qtyInput.dataset.userEdited !== 'true') {
        qtyInput.value = input.value;
    }
    var watDiff = document.getElementById('watDiff');
    if (watDiff && watDiff.style.display !== 'none') {
        renderWatDropdowns('watDropdowns', 'watDiffAnswer', input.value);
    }
}

function onMonkCountInputChange(value) {
    var watDiff = document.getElementById('watDiff');
    if (watDiff && watDiff.style.display !== 'none') {
        renderWatDropdowns('watDropdowns', 'watDiffAnswer', value || 0);
    }
    var sQty = document.getElementById('sanghatanQtyInput');
    if (sQty && sQty.dataset.userEdited !== 'true') {
        sQty.value = value;
    }
}

function isInHiddenBranch(el) {
    var node = el.parentElement;
    while (node && node !== document.body) {
        if (node.style && node.style.display === 'none') return true;
        node = node.parentElement;
    }
    return false;
}

function cleanupAndRenumberDetailsBeforeSubmit() {
    var form = document.querySelector('form');

    form.querySelectorAll('input, select, textarea').forEach(function(el) {
        if (isInHiddenBranch(el)) el.disabled = true;
    });

    var monkCountField = document.getElementById('monkCountField');
    var monkCountQId = document.getElementById('monkCountQuestionIdField');
    if (monkCountField) monkCountField.disabled = false;
    if (monkCountQId) monkCountQId.disabled = false;

    var pattern = /^details\[(\d+)\]\.(answer|question\.questionsId)$/;
    var order = [];
    var seen = {};
    form.querySelectorAll('input:not([disabled]), select:not([disabled]), textarea:not([disabled])').forEach(function(el) {
        var m = el.name && el.name.match(pattern);
        if (m && !seen[m[1]]) { seen[m[1]] = true; order.push(m[1]); }
    });
    var remap = {};
    order.forEach(function(oldIdx, i) { remap[oldIdx] = i; });
    form.querySelectorAll('input:not([disabled]), select:not([disabled]), textarea:not([disabled])').forEach(function(el) {
        var m = el.name && el.name.match(pattern);
        if (m) el.name = 'details[' + remap[m[1]] + '].' + m[2];
    });

    return true;
}

// -------------------------------------------------------------
// ระบบตรวจสอบแบบฟอร์ม (Validation)
// -------------------------------------------------------------
function showError(element, message) {
    // ลบ Error เก่าที่จุดเดียวกันถ้ามี
    if (element.nextElementSibling && element.nextElementSibling.classList.contains('custom-error-msg')) {
        element.nextElementSibling.remove();
    }

    var err = document.createElement('div');
    err.className = 'custom-error-msg';
    err.style.color = 'red';
    err.style.fontSize = '11px'; // ปรับขนาดให้เล็กลงกว่าตัวอื่นๆ
    err.style.marginTop = '4px';
    err.innerText = message; // เอาสัญลักษณ์ ❌ ออก

    // แทรกข้อความแจ้งเตือนต่อท้าย
    if(element.nextSibling) {
        element.parentNode.insertBefore(err, element.nextSibling);
    } else {
        element.parentNode.appendChild(err);
    }

    // ไฮไลต์ขอบสีแดง
    if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA' || element.tagName === 'SELECT') {
        element.style.borderColor = 'red';
        element.classList.add('validation-failed');

        var removeError = function() {
            element.style.borderColor = '';
            element.classList.remove('validation-failed');
            if (err.parentNode) err.parentNode.removeChild(err);
        };
        element.addEventListener('input', removeError, {once: true});
        element.addEventListener('change', removeError, {once: true});
    }
}

function handleFormSubmit(form) {
    // ล้างแจ้งเตือน Error ทั้งหมดก่อน
    document.querySelectorAll('.custom-error-msg').forEach(function(e) { e.remove(); });
    form.querySelectorAll('.validation-failed').forEach(function(el) { el.style.borderColor = ''; el.classList.remove('validation-failed'); });

    let isValid = true;
    let firstErrorElement = null;

    function markError(el, msg) {
        showError(el, msg);
        isValid = false;
        if (!firstErrorElement) firstErrorElement = el;
    }

    // 1. ตรวจสอบปฏิทิน
    var eventDateVal = document.getElementById('eventDateInput').value;
    if (!eventDateVal) {
        markError(document.getElementById('datePickerWrap'), 'กรุณาเลือกวันที่จัดงานจากปฏิทิน');
    }

    // 2. ตรวจสอบช่องที่จำเป็นทั้งหมด (required)
    form.querySelectorAll('input[required], textarea[required], select[required]').forEach(function(el) {
        if (!isInHiddenBranch(el)) {
            if (!el.value.trim()) {
                markError(el, 'กรุณากรอกข้อมูลในช่องนี้ให้ครบถ้วน');
            }
        }
    });

    // 3. ตรวจสอบช่องจำนวนตัวเลข (ต้องมากกว่า 0)
    form.querySelectorAll('input[type="number"]').forEach(function(el) {
        if (!isInHiddenBranch(el) && el.value !== '') {
            if (parseFloat(el.value) <= 0) {
                markError(el, 'จำนวนต้องมากกว่า 0 และห้ามติดลบ');
            }
        }
    });

    // 4. ตรวจสอบแผนที่
    var lat = document.getElementById('eventLat').value;
    if (!lat || lat === "") {
        markError(document.getElementById('locationMap'), 'กรุณาปักหมุดตำแหน่งที่จัดงานบนแผนที่');
    }

    // 5. ตรวจสอบรูปภาพ
    var imgCount = document.querySelectorAll('#base64Container input').length;
    if (imgCount === 0) {
        markError(document.getElementById('imagePreviewBox'), 'กรุณาอัปโหลดรูปภาพสถานที่จัดงานอย่างน้อย 1 รูป');
    }

    // หากไม่ผ่าน เลื่อนจอไปจุดแรกที่ Error
    if (!isValid) {
        if (firstErrorElement) {
            firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return false; // ระงับการส่งฟอร์ม
    }

    syncAllWatAnswersBeforeSubmit();
    cleanupAndRenumberDetailsBeforeSubmit();

    return true; // ยืนยันการส่งข้อมูล
}

/* FIX: ต้องข้าม radio ที่อยู่ในกิ่งที่ถูกซ่อน (เช่น การ์ดเลือกแพ็กเกจตอนอยู่ในโหมด
   "จองแบบระบุเอง") เหมือนกับฟอร์มทำบุญบ้าน/ขึ้นบ้านใหม่ ไม่งั้น radio แพ็กเกจที่ถูก
   checked ไว้เป็นค่าเริ่มต้นแต่ถูกซ่อนอยู่ จะยังยิง onchange ตอนโหลดหน้าอยู่ดี
   ทำให้ช่อง "จำนวนพระสงฆ์" ถูกเซ็ตค่าทั้งที่ควรว่างให้ผู้ใช้กรอกเอง */
function syncInitialToggleStates() {
    document.querySelectorAll('input[type="radio"]:checked').forEach(function(radio) {
        if (isInHiddenBranch(radio)) return;
        var code = radio.getAttribute('onchange');
        if (code) {
            try { new Function(code).call(radio); } catch (e) {}
        }
    });
}
document.addEventListener('DOMContentLoaded', syncInitialToggleStates);
window.addEventListener('pageshow', syncInitialToggleStates);

/* ===== ปฏิทินย่อสำหรับเลือกวันที่จัดงาน ===== */
window.bookedDates = [
    <c:forEach var="d" items="${bookedDates}" varStatus="st">
        "${d}"<c:if test="${!st.last}">,</c:if>
    </c:forEach>
];
window.teamCount = ${empty teamCount ? 2 : teamCount};
window.bookingsPerDate = {
    <c:forEach var="e" items="${bookingsPerDate}" varStatus="st">
        "${e.key}": ${e.value}<c:if test="${!st.last}">,</c:if>
    </c:forEach>
};
window.dayQuality = {
    <c:forEach var="e" items="${dayQuality}" varStatus="st">
        "${e.key}": [
            <c:forEach var="tag" items="${e.value}" varStatus="st2">
                {type:"${tag.type}",label:"${tag.label}"}<c:if test="${!st2.last}">,</c:if>
            </c:forEach>
        ]<c:if test="${!st.last}">,</c:if>
    </c:forEach>
};
</script>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
        crossorigin=""></script>
<script src="${pageContext.request.contextPath}/static/js/bookingForm.js?v=8"></script>
<script src="${pageContext.request.contextPath}/static/js/miniBookingCalendar.js?v=1"></script>

</body>
</html>
