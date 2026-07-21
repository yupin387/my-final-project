<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>จองงานทำบุญออฟฟิศ - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bookingForm.css?v=9">
</head>
<body>

<%-- ========== NAVBAR (ให้ตรงกับหน้า ceremonyDetail: 92px / โลโก้ 58px / รูปจริง) ========== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png" alt="บุญมี รับจัดงานบุญ">
        </div>
        <span class="nav-brand-text">บุญมี รับจัดงานบุญ</span>
    </a>
    <div class="navbar-center">
        <a href="${pageContext.request.contextPath}/home" class="nav-link-item">หน้าหลัก</a>
        <a href="${pageContext.request.contextPath}/latestBooking" class="nav-link-item active">การจอง</a>
        <a href="${pageContext.request.contextPath}/member/quotation/list" class="nav-link-item">ใบเสนอราคา</a>
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
<div class="hero-banner">
    <div class="hero-content">
        <span class="hero-tag">ระบบจองงานบุญ</span>
        <h1>จองงานทำบุญออฟฟิศ</h1>
        <p>ระบุรายละเอียดให้ครบถ้วนเพื่อความถูกต้องของงานพิธี</p>
    </div>
</div>

<%-- ========== FORM ========== --%>
<div class="page-wrapper">
    <div class="form-container">
    <form action="${pageContext.request.contextPath}/saveBooking" method="post" onsubmit="return syncAllWatAnswersBeforeSubmit();">
        <c:set var="detailIndex" value="0"/>

        <%-- =========================================================
             0. เลือกวิธีจอง — แพ็กเกจแนะนำ / ความต้องการเบื้องต้น
             ========================================================= --%>
        <div class="form-card">
            <div class="card-header">เลือกวิธีจอง</div>
            <div class="card-body">
                <div class="checkbox-group">
                    <label class="checkbox-label">
                        <input type="radio" name="bookingMode" value="package"
                               onchange="toggleBookingMode('package')" checked>
                        <span>แพ็กเกจแนะนำ <small style="color:#B0345A;">(ราคาเหมา จำนวนพระถูกกำหนดตามแพ็กเกจ)</small></span>
                    </label>
                    <label class="checkbox-label">
                        <input type="radio" name="bookingMode" value="custom"
                               onchange="toggleBookingMode('custom')">
                        <span>ความต้องการเบื้องต้น <small style="color:#B0345A;">(กรอกรายละเอียดทุกอย่างเองตามที่ท่านต้องการ)</small></span>
                    </label>
                </div>
            </div>
        </div>

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
                                <label class="form-label">วันที่จัดงาน</label>
                                <input type="text" class="form-control"
                                       value="${not empty param.dates ? param.dates : (not empty selectedDates ? selectedDates : 'ไม่พบวันที่ที่เลือกไว้')}"
                                       readonly>
                                <input type="hidden" name="eventDate"
                                       value="${not empty param.dates ? param.dates : selectedDates}">
                                <p style="font-size:12px;color:#B0345A;margin-top:6px;">
                                    ดึงวันที่จากที่คุณเลือกไว้ในหน้าก่อนหน้าแล้ว หากต้องการเปลี่ยนวันที่ กรุณากลับไปเลือกใหม่ที่หน้ารายละเอียดงาน
                                </p>
                            </div>
                            <div class="form-group">
                                <label class="form-label">เวลาเริ่มพิธี <span class="required">*</span></label>
                                <input type="time" name="eventTime" class="form-control" required>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <div class="form-card">
                    <div class="card-header">สถานที่จัดพิธี</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label class="form-label">ที่อยู่สำนักงาน / บริษัท <span class="required">*</span></label>
                            <textarea name="eventAddress" class="form-control" rows="3" required
                                      placeholder="เช่น อาคารเอบีซี ชั้น 12 เลขที่ 99 ถนนสุขุมวิท แขวงคลองเตย เขตคลองเตย กรุงเทพฯ 10110"></textarea>
                        </div>
                        <div class="form-group" style="margin-top:16px;">
                            <label class="form-label">📸 รูปภาพสถานที่จัดงาน</label>
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
        </div>

        <%-- =========================================================
             1. โหมดแพ็กเกจแนะนำ
             ========================================================= --%>
        <div id="packageSection" style="display:block;">

            <%-- 1.1 เลือกแพ็กเกจ (3 ระดับ) --%>
            <div class="form-card">
                <div class="card-header">เลือกแพ็กเกจ</div>
                <div class="card-body">
                    <div class="item-card-grid">
                        <c:forEach items="${ceremonies}" var="pkg" varStatus="loop">
                            <%-- Ceremony ไม่มีฟิลด์เก็บจำนวนพระ จึงกำหนดตามชื่อแพ็กเกจตามธรรมเนียมของโปรเจกต์ (มาตรฐาน=5, อิ่มบุญ=7, พรีเมียม=9) --%>
                            <c:choose>
                                <c:when test="${fn:contains(pkg.ceremonyName, 'พรีเมียม')}">
                                    <c:set var="pkgMonkCount" value="9"/>
                                </c:when>
                                <c:when test="${fn:contains(pkg.ceremonyName, 'อิ่มบุญ')}">
                                    <c:set var="pkgMonkCount" value="7"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="pkgMonkCount" value="5"/>
                                </c:otherwise>
                            </c:choose>
                            <label class="item-card">
                                <input type="radio" name="ceremony.ceremonyId" value="${pkg.ceremonyId}"
                                       data-monkcount="${pkgMonkCount}"
                                       onchange="applyPackageMonkCount(this)"
                                       ${loop.first ? 'checked' : ''}>
                                <div class="item-card-thumb">
    <img src="${pageContext.request.contextPath}/static/images/p${loop.index + 1}.png" alt="${pkg.ceremonyName}">
</div>
                                <div class="item-card-body">
                                    <div class="item-card-name">${pkg.ceremonyName}</div>
                                    <div class="item-card-desc">${pkg.ceremonyDetail}</div>
                                    <div class="item-card-price">
                                        ฿<fmt:formatNumber value="${pkg.basePrice}" pattern="#,###"/>
                                    </div>
                                </div>
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <%-- 1.2 การนิมนต์พระสงฆ์ + จำนวนพระ (ฟิกตามแพ็กเกจ) --%>
            <div class="form-card">
                <div class="card-header">การนิมนต์พระสงฆ์</div>
                <div class="card-body">

                    <c:forEach items="${questions}" var="q">
                        <c:if test="${fn:contains(q.questionsText, 'รูปแบบการนิมนต์')}">
                            <div class="form-group">
                                <label class="form-label">${q.questionsText}</label>
                                <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                <div class="checkbox-group">
                                    <label class="checkbox-label">
                                        <input type="radio" name="details[${detailIndex}].answer" value="ให้ทางร้านนิมนต์"
                                               onchange="toggleWatDetail('pkgWatDetail', true)" checked>
                                        <span>ให้ทางร้านนิมนต์</span>
                                    </label>
                                    <label class="checkbox-label">
                                        <input type="radio" name="details[${detailIndex}].answer" value="นิมนต์เอง (ลด ฿1,500)"
                                               onchange="toggleWatDetail('pkgWatDetail', false)">
                                        <span>นิมนต์เอง <small style="color:#2e7d32;">(รับส่วนลด ฿1,500)</small></span>
                                    </label>
                                </div>
                            </div>
                            <c:set var="detailIndex" value="${detailIndex + 1}"/>
                        </c:if>
                    </c:forEach>

                    <%-- แสดงเมื่อเลือก "ให้ทางร้านนิมนต์" — เลือกว่าจะให้นิมนต์ต่างวัด หรือให้ร้านเลือกวัดให้เอง --%>
                    <div id="pkgWatDetail" style="display:block; margin-bottom:14px;">
                        <c:forEach items="${questions}" var="q">
                            <c:if test="${fn:contains(q.questionsText, 'รายละเอียดการนิมนต์')}">
                                <div class="form-group">
                                    <label class="form-label">รายละเอียดการนิมนต์พระสงฆ์</label>
                                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                    <div class="checkbox-group">
                                        <label class="checkbox-label">
                                            <input type="radio" name="pkgWatType" value="ต่างวัด"
                                                   onchange="toggleWatOwnField('pkgWatDiff', true);
                                                             renderWatDropdowns('pkgWatDropdowns','pkgWatDiffAnswer', document.getElementById('monkCountPackage').value);">
                                            <span>ต่างวัด <small style="color:#B0345A;">(เลือกวัดของพระแต่ละรูป)</small></span>
                                        </label>
                                        <label class="checkbox-label">
                                            <input type="radio" name="pkgWatType" value="ให้ร้านเลือกให้"
                                                   onchange="toggleWatOwnField('pkgWatDiff', false)" checked>
                                            <span>ให้ทางร้านเลือกให้ <small style="color:#B0345A;">(เลือกวัดใกล้พื้นที่จัดงาน)</small></span>
                                        </label>
                                    </div>
                                    <div id="pkgWatDiff" style="display:none; margin-top:12px;">
                                        <p style="font-size:12px;color:var(--text-muted);margin-bottom:8px;">
                                            เลือกวัดที่ต้องการสำหรับพระแต่ละรูป (จำนวนช่องจะเท่ากับจำนวนพระที่กำหนดไว้ในแพ็กเกจ)
                                        </p>
                                        <div id="pkgWatDropdowns"></div>
                                        <textarea name="details[${detailIndex}].answer" id="pkgWatDiffAnswer"
                                                  class="form-control" style="display:none;"></textarea>
                                    </div>
                                </div>
                                <c:set var="detailIndex" value="${detailIndex + 1}"/>
                            </c:if>
                        </c:forEach>
                    </div>

                    <c:forEach items="${questions}" var="q">
                        <c:if test="${fn:contains(q.questionsText, 'จำนวนพระ')}">
                            <div class="form-group">
                                <label class="form-label">${q.questionsText}</label>
                                <p style="font-size:12px;color:#B0345A;margin-top:2px;">
                                    กำหนดตามแพ็กเกจที่เลือกไว้ด้านบน
                                </p>
                                <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                <input type="number" name="details[${detailIndex}].answer" id="monkCountPackage"
                                       class="form-control" value="5" readonly style="background:#F5F5F5;">
                            </div>
                            <c:set var="detailIndex" value="${detailIndex + 1}"/>
                        </c:if>
                    </c:forEach>

                </div>
            </div>

            <%-- 1.3 เลือกชุดสังฆทาน (การ์ด) — จำนวนชุดผูกกับจำนวนพระ --%>
            <div class="form-card">
                <div class="card-header">เลือกชุดสังฆทาน</div>
                <div class="card-body">
                    <c:forEach items="${questions}" var="q">
                        <c:if test="${fn:contains(q.questionsText, 'เลือกชุดสังฆทาน')}">
                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                            <div class="item-card-grid">
                                <c:forEach items="${sanghatharnItems}" var="item" varStatus="loop">
                                    <label class="item-card">
                                        <input type="radio" name="details[${detailIndex}].answer"
                                               value="${item.itemName}" ${loop.first ? 'checked' : ''}>
                                        <div class="item-card-thumb">
                                            <img src="${pageContext.request.contextPath}/static/images/offeringsetimg/offeringset${(loop.index % 5) + 1}.jpg" alt="${item.itemName}">
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

                    <%-- จำนวนชุดสังฆทาน = จำนวนพระ โดยค่าเริ่มต้น แต่แก้ไขเองได้ --%>
                    <c:forEach items="${questions}" var="q">
                        <c:if test="${fn:contains(q.questionsText, 'จำนวนชุดสังฆทาน')}">
                            <div class="form-group" style="margin-top:14px;">
                                <label class="form-label">${q.questionsText}</label>
                                <p style="font-size:12px;color:#B0345A;margin-top:2px;">
                                    ค่าเริ่มต้น = จำนวนพระสงฆ์ที่นิมนต์ไว้ด้านบน แก้ไขจำนวนเองได้หากต้องการ
                                </p>
                                <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                <input type="number" name="details[${detailIndex}].answer" id="pkgSanghatanQtyInput"
                                       class="form-control" value="5" min="1"
                                       oninput="this.dataset.userEdited = 'true';">
                            </div>
                            <c:set var="detailIndex" value="${detailIndex + 1}"/>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

            <%-- 1.4 เลือกชุดปิ่นโต (การ์ด) — พร้อมตัวเลือกต้องการ/ไม่ต้องการ (จำนวนชุดเลือกเองอิสระ ไม่ผูกกับจำนวนพระ) --%>
            <div class="form-card">
                <div class="card-header">ชุดภัตตาหารปิ่นโต</div>
                <div class="card-body">

                    <c:forEach items="${questions}" var="q">
                        <c:if test="${fn:contains(q.questionsText, 'ต้องการชุดภัตตาหาร')}">
                            <c:set var="pkgPintoWantIndex" value="${detailIndex}"/>
                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                            <c:set var="detailIndex" value="${detailIndex + 1}"/>
                        </c:if>
                    </c:forEach>

                    <div class="form-group">
                        <label class="form-label">ต้องการชุดภัตตาหารปิ่นโตหรือไม่?</label>
                        <div class="checkbox-group">
                            <label class="checkbox-label">
                                <input type="radio" name="details[${pkgPintoWantIndex}].answer" value="ต้องการ"
                                       onchange="toggleSection('pkgPintoDetail', true)" checked>
                                <span>ต้องการ</span>
                            </label>
                            <label class="checkbox-label">
                                <input type="radio" name="details[${pkgPintoWantIndex}].answer" value="ไม่ต้องการ"
                                       onchange="toggleSection('pkgPintoDetail', false)">
                                <span>ไม่ต้องการ</span>
                            </label>
                        </div>
                    </div>

                    <div id="pkgPintoDetail" style="display:block; margin-top:14px;">
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
                                                    <img src="${pageContext.request.contextPath}/static/images/foodimg/food${(loop.index % 5) + 1}.jpg" alt="${item.itemName}">
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

                        <%-- จำนวนชุดปิ่นโต — กรอกเองอิสระ ไม่ผูกกับจำนวนพระ --%>
                        <c:forEach items="${questions}" var="q">
                            <c:if test="${fn:contains(q.questionsText, 'จำนวนชุดภัตตาหาร')}">
                                <div class="form-group" style="margin-top:14px;">
                                    <label class="form-label">${q.questionsText}</label>
                                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                    <input type="number" name="details[${detailIndex}].answer"
                                           class="form-control" placeholder="ระบุจำนวนชุด..." min="1">
                                </div>
                                <c:set var="detailIndex" value="${detailIndex + 1}"/>
                            </c:if>
                        </c:forEach>
                    </div>

                </div>
            </div>

        </div>

        <%-- =========================================================
             2. ความต้องการเบื้องต้น (โหมดกรอกเอง — ไม่มีอะไรถูกฟิกไว้)
             ========================================================= --%>
        <div id="customSection" style="display:none;">

            <input type="hidden" name="ceremony.ceremonyId" id="customCeremonyId" value="${defaultCeremonyId}">

            <div class="form-grid">
                <div>

                    <%-- การนิมนต์พระสงฆ์ --%>
                    <div class="form-card">
                        <div class="card-header">การนิมนต์พระสงฆ์</div>
                        <div class="card-body">

                            <c:forEach items="${questions}" var="q">
                                <c:if test="${fn:contains(q.questionsText, 'รูปแบบการนิมนต์')}">
                                    <div class="form-group">
                                        <label class="form-label">${q.questionsText}</label>
                                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                        <div class="checkbox-group">
                                            <label class="checkbox-label">
                                                <input type="radio" name="details[${detailIndex}].answer" value="ให้ทางร้านนิมนต์"
                                                       onchange="toggleWatDetail('customWatDetail', true)" checked>
                                                <span>ให้ทางร้านนิมนต์</span>
                                            </label>
                                            <label class="checkbox-label">
                                                <input type="radio" name="details[${detailIndex}].answer" value="นิมนต์เอง"
                                                       onchange="toggleWatDetail('customWatDetail', false)">
                                                <span>นิมนต์เอง</span>
                                            </label>
                                        </div>
                                    </div>
                                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
                                </c:if>
                            </c:forEach>

                            <%-- แสดงเมื่อเลือก "ให้ทางร้านนิมนต์" --%>
                            <div id="customWatDetail" style="display:block; margin-bottom:14px;">
                                <c:forEach items="${questions}" var="q">
                                    <c:if test="${fn:contains(q.questionsText, 'รายละเอียดการนิมนต์')}">
                                        <div class="form-group">
                                            <label class="form-label">รายละเอียดการนิมนต์พระสงฆ์</label>
                                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                            <div class="checkbox-group">
                                                <label class="checkbox-label">
                                                    <input type="radio" name="customWatType" value="ต่างวัด"
                                                           onchange="toggleWatOwnField('customWatDiff', true);
                                                                     renderWatDropdowns('customWatDropdowns','customWatDiffAnswer', document.getElementById('monkCountInput').value || 0);">
                                                    <span>ต่างวัด <small style="color:#B0345A;">(เลือกวัดของพระแต่ละรูป)</small></span>
                                                </label>
                                                <label class="checkbox-label">
                                                    <input type="radio" name="customWatType" value="ให้ร้านเลือกให้"
                                                           onchange="toggleWatOwnField('customWatDiff', false)" checked>
                                                    <span>ให้ทางร้านเลือกให้ <small style="color:#B0345A;">(เลือกวัดใกล้พื้นที่จัดงาน)</small></span>
                                                </label>
                                            </div>
                                            <div id="customWatDiff" style="display:none; margin-top:12px;">
                                                <p style="font-size:12px;color:var(--text-muted);margin-bottom:8px;">
                                                    เลือกวัดที่ต้องการสำหรับพระแต่ละรูป (จำนวนช่องจะเท่ากับจำนวนพระที่ระบุด้านล่าง)
                                                </p>
                                                <div id="customWatDropdowns">
                                                    <p class="wat-picker-empty">กรุณาระบุจำนวนพระสงฆ์ก่อน จึงจะแสดงช่องเลือกวัด</p>
                                                </div>
                                                <textarea name="details[${detailIndex}].answer" id="customWatDiffAnswer"
                                                          class="form-control" style="display:none;"></textarea>
                                            </div>
                                        </div>
                                        <c:set var="detailIndex" value="${detailIndex + 1}"/>
                                    </c:if>
                                </c:forEach>
                            </div>

                            <c:forEach items="${questions}" var="q">
                                <c:if test="${fn:contains(q.questionsText, 'จำนวนพระ')}">
                                    <div class="form-group" style="margin-top:14px;">
                                        <label class="form-label">${q.questionsText} <span class="required">*</span></label>
                                        <p style="font-size:12px;color:#B0345A;">ระบุจำนวนพระสงฆ์ที่ต้องการเองได้เลย</p>
                                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                        <input type="number" name="details[${detailIndex}].answer" id="monkCountInput"
                                               class="form-control" placeholder="ระบุจำนวนพระสงฆ์..." min="1"
                                               oninput="onMonkCountInputChange(this.value)">
                                    </div>
                                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
                                </c:if>
                            </c:forEach>

                        </div>
                    </div>

                </div>

                <div>

                    <%-- ชุดปิ่นโต --%>
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
                                <label class="form-label">ต้องการชุดภัตตาหารปิ่นโตหรือไม่?</label>
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
                                    <c:if test="${fn:contains(q.questionsText, 'เลือกชุดภัตตาหาร')}">
                                        <div class="form-group">
                                            <label class="form-label">เลือกชุดปิ่นโต</label>
                                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                            <div class="item-card-grid">
                                                <c:forEach items="${pintoItems}" var="item" varStatus="loop">
                                                    <c:if test="${fn:contains(item.itemName, 'ชุด')}">
                                                        <label class="item-card">
                                                            <input type="radio" name="details[${detailIndex}].answer"
                                                                   value="${item.itemName}" ${loop.first ? 'checked' : ''}>
                                                            <div class="item-card-thumb">
                                                                <img src="${pageContext.request.contextPath}/static/images/foodimg/food${(loop.index % 5) + 1}.jpg" alt="${item.itemName}">
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
                                        </div>
                                        <c:set var="detailIndex" value="${detailIndex + 1}"/>
                                    </c:if>
                                </c:forEach>

                                <%-- จำนวนชุดปิ่นโต — เลือกเองอิสระ ไม่ผูกกับจำนวนพระ --%>
                                <c:forEach items="${questions}" var="q">
                                    <c:if test="${fn:contains(q.questionsText, 'จำนวนชุดภัตตาหาร')}">
                                        <div class="form-group">
                                            <label class="form-label">${q.questionsText}</label>
                                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                            <input type="number" name="details[${detailIndex}].answer"
                                                   class="form-control" placeholder="ระบุจำนวนชุด..." min="1">
                                        </div>
                                        <c:set var="detailIndex" value="${detailIndex + 1}"/>
                                    </c:if>
                                </c:forEach>

                                <div class="form-group" style="margin-top:10px;">
                                    <label class="form-label">อุปกรณ์/เมนูอื่นๆ เพิ่มเติม</label>
                                    <textarea name="pintoExtraNote" class="form-control" rows="2"
                                              placeholder="ระบุรายการที่ต้องการเพิ่มเติมนอกเหนือจากชุดที่เลือก เช่น เชิงเทียนไฟฟ้า"></textarea>
                                </div>
                            </div>

                        </div>
                    </div>

                    <%-- สังฆทาน — จำนวนชุดผูกกับจำนวนพระ --%>
                    <div class="form-card">
                        <div class="card-header">ชุดสังฆทาน</div>
                        <div class="card-body">

                            <c:forEach items="${questions}" var="q">
                                <c:if test="${fn:contains(q.questionsText, 'ต้องการสังฆทาน')}">
                                    <c:set var="sanghatanWantIndex" value="${detailIndex}"/>
                                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
                                </c:if>
                            </c:forEach>

                            <div class="form-group">
                                <label class="form-label">ต้องการชุดสังฆทานหรือไม่?</label>
                                <div class="checkbox-group">
                                    <label class="checkbox-label">
                                        <input type="radio" name="details[${sanghatanWantIndex}].answer" value="ต้องการ"
                                               onchange="toggleSection('sanghatanDetail', true)" checked>
                                        <span>ต้องการ</span>
                                    </label>
                                    <label class="checkbox-label">
                                        <input type="radio" name="details[${sanghatanWantIndex}].answer" value="ไม่ต้องการ"
                                               onchange="toggleSection('sanghatanDetail', false)">
                                        <span>ไม่ต้องการ</span>
                                    </label>
                                </div>
                            </div>

                            <div id="sanghatanDetail" style="display:block; margin-top:14px;">
                                <div class="sanghatan-qty-note">
                                    🙏 จำนวนชุดสังฆทานจะเท่ากับจำนวนพระสงฆ์ที่ระบุไว้ด้านซ้าย — ระบบจะกรอกให้อัตโนมัติ
                                    (แก้ไขเองได้หากต้องการจำนวนต่างจากนี้)
                                </div>
                                <c:forEach items="${questions}" var="q">
                                    <c:if test="${fn:contains(q.questionsText, 'เลือกชุดสังฆทาน')}">
                                        <div class="form-group">
                                            <label class="form-label">เลือกชุดสังฆทาน</label>
                                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                            <div class="item-card-grid">
                                                <c:forEach items="${sanghatharnItems}" var="item" varStatus="loop">
                                                    <label class="item-card">
                                                        <input type="radio" name="details[${detailIndex}].answer"
                                                               value="${item.itemName}" ${loop.first ? 'checked' : ''}>
                                                        <div class="item-card-thumb">
                                                            <img src="${pageContext.request.contextPath}/static/images/offeringsetimg/offeringset${(loop.index % 5) + 1}.jpg" alt="${item.itemName}">
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
                                        </div>
                                        <c:set var="detailIndex" value="${detailIndex + 1}"/>
                                    </c:if>
                                </c:forEach>

                                <c:forEach items="${questions}" var="q">
                                    <c:if test="${fn:contains(q.questionsText, 'จำนวนชุดสังฆทาน')}">
                                        <div class="form-group">
                                            <label class="form-label">${q.questionsText}</label>
                                            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                            <input type="number" name="details[${detailIndex}].answer" id="sanghatanQtyInput"
                                                   class="form-control" placeholder="ระบุจำนวนชุด..." min="1"
                                                   oninput="this.dataset.userEdited = 'true';">
                                        </div>
                                        <c:set var="detailIndex" value="${detailIndex + 1}"/>
                                    </c:if>
                                </c:forEach>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="submit-row">
            <button type="submit" class="btn-submit">บันทึกข้อมูลการจอง</button>
        </div>
    </form>
    </div>
</div>

<%-- ========== FOOTER (ธีมเดียวกับหน้า home) ========== --%>
<footer class="site-footer">
    <div class="footer-top">
        <svg viewBox="0 0 1200 8" xmlns="http://www.w3.org/2000/svg" style="display:block;width:100%;height:8px;">
            <rect width="1200" height="8" fill="url(#footerGrad)" />
            <defs>
                <linearGradient id="footerGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                    <stop offset="0%" stop-color="#6E1930" />
                    <stop offset="50%" stop-color="#EC6E96" />
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
            <p class="footer-tagline">รับจัดงานบุญ ดูแลพิธีสงฆ์ให้คุณ ถูกหลักพิธีการตามประเพณีภาคเหนือ</p>
        </div>
			<div class="footer-col footer-contact-col">
				<h4 class="footer-heading">ติดต่อเรา</h4>
				<%-- TODO: ใส่เบอร์โทร / LINE OA / อีเมลจริงของร้านแทนที่ตรงนี้ --%>
				<p>📞 โทร. 08X-XXX-XXXX</p>
				<p>💬 LINE OA: @boonmee</p>
				<p>✉️ boonmee.booking@gmail.com</p>
				<p>📍 บริการในพื้นที่และจังหวัดใกล้เคียง</p>
			</div>
		</div>
	</footer>

<style>
.item-card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    gap: 12px;
}
.item-card {
    position: relative;
    display: flex;
    flex-direction: column;
    border: 1.5px solid var(--cream-border-soft);
    border-radius: 10px;
    padding: 12px;
    cursor: pointer;
    background: #FFFFFF;
    transition: border-color .15s, box-shadow .15s;
}
.item-card:hover { border-color: var(--gold-mid); }
.item-card input[type="radio"] { position: absolute; top: 10px; right: 10px; }
.item-card:has(input:checked) {
    border-color: var(--gold-mid);
    box-shadow: 0 0 0 2px rgba(224,87,127,0.22);
}
.item-card-thumb {
    width: 100%; height: 110px;
    overflow: hidden;
    border-radius: 8px; margin-bottom: 8px;
    background: var(--cream-mid);
}
.item-card-thumb img {
    width: 100%; height: 100%;
    object-fit: cover; display: block;
}
.item-card-name { font-weight: 700; font-size: 14px; color: var(--brown-dark); margin-bottom: 4px; }
.item-card-desc { font-size: 12px; color: var(--text-muted); line-height: 1.5; margin-bottom: 6px; }
.item-card-price { font-size: 13px; font-weight: 700; color: var(--gold); }
</style>

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

// แสดง/ซ่อนบล็อก "รายละเอียดการนิมนต์" (ต่างวัด / ให้ร้านเลือกให้)
// โชว์เฉพาะตอนเลือก "ให้ทางร้านนิมนต์" เท่านั้น
function toggleWatDetail(id, show) {
    var el = document.getElementById(id);
    if (el) el.style.display = show ? 'block' : 'none';
}

function toggleSection(id, show) {
    var el = document.getElementById(id);
    if (el) el.style.display = show ? 'block' : 'none';
}

/* ==========================================================================
   TEMPLE (WAT) DROPDOWN PICKER — สร้าง dropdown เลือกวัดตามจำนวนพระ
   หมายเหตุ: รายชื่อวัดด้านล่างเป็นตัวอย่าง สามารถแก้ให้ดึงจากฐานข้อมูลจริงได้ภายหลัง
   ========================================================================== */
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
    "วัดเจ็ดยอด (วัดโพธารามมหาวิหาร)"
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
    for (var i = 1; i <= count; i++) {
        var row = document.createElement('div');
        row.className = 'wat-picker-row';

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
        select.addEventListener('change', function() { syncWatAnswer(containerId, textareaId); });

        row.appendChild(label);
        row.appendChild(select);
        container.appendChild(row);
    }
    syncWatAnswer(containerId, textareaId);
}

function syncWatAnswer(containerId, textareaId) {
    var container = document.getElementById(containerId);
    var textarea = document.getElementById(textareaId);
    if (!container || !textarea) return;
    var selects = container.querySelectorAll('select');
    var lines = [];
    selects.forEach(function(s, idx) {
        lines.push('รูปที่ ' + (idx + 1) + ' ' + s.value);
    });
    textarea.value = lines.join('\n');
}

// กันเหนียว: sync ค่า dropdown ลง textarea อีกครั้งก่อน submit ฟอร์ม
function syncAllWatAnswersBeforeSubmit() {
    syncWatAnswer('pkgWatDropdowns', 'pkgWatDiffAnswer');
    syncWatAnswer('customWatDropdowns', 'customWatDiffAnswer');
    return true;
}

// เมื่อเลือกการ์ดแพ็กเกจ → เซตจำนวนพระสงฆ์ตาม data-monkcount, จำนวนชุดสังฆทาน,
// และรีเฟรช dropdown เลือกวัด (ถ้ากำลังแสดงอยู่)
function applyPackageMonkCount(radio) {
    var input = document.getElementById('monkCountPackage');
    if (input && radio.dataset.monkcount) {
        input.value = radio.dataset.monkcount;
    }

    var qtyInput = document.getElementById('pkgSanghatanQtyInput');
    if (qtyInput && qtyInput.dataset.userEdited !== 'true') {
        qtyInput.value = input.value;
    }

    var watDiff = document.getElementById('pkgWatDiff');
    if (watDiff && watDiff.style.display !== 'none') {
        renderWatDropdowns('pkgWatDropdowns', 'pkgWatDiffAnswer', input.value);
    }
}

// เมื่อผู้ใช้พิมพ์จำนวนพระเองในโหมด "ความต้องการเบื้องต้น"
// → sync จำนวนชุดสังฆทาน (ถ้ายังไม่ถูกแก้ไขเอง) และรีเฟรช dropdown เลือกวัด
function onMonkCountInputChange(value) {
    var watDiff = document.getElementById('customWatDiff');
    if (watDiff && watDiff.style.display !== 'none') {
        renderWatDropdowns('customWatDropdowns', 'customWatDiffAnswer', value || 0);
    }

    var sQty = document.getElementById('sanghatanQtyInput');
    if (sQty && sQty.dataset.userEdited !== 'true') {
        sQty.value = value;
    }
}

function toggleBookingMode(mode) {
    var packageSection = document.getElementById('packageSection');
    var customSection = document.getElementById('customSection');
    if (mode === 'package') {
        packageSection.style.display = 'block';
        customSection.style.display = 'none';
    } else {
        packageSection.style.display = 'none';
        customSection.style.display = 'block';
    }
}
</script>

<script src="${pageContext.request.contextPath}/static/js/bookingForm.js?v=8"></script>

</body>
</html>
