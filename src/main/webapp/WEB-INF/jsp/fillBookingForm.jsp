<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>จองงานขึ้นบ้านใหม่ - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bookingForm.css?v=5">
</head>
<body>

<%-- ========== NAVBAR ========== --%>
<nav class="navbar-custom">
    <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
        <div class="lotus-icon">🪷</div>
        <span class="nav-brand-text">ระบบรับจัดงานบุญ</span>
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
        <h1>จองงานขึ้นบ้านใหม่</h1>
        <p>ระบุรายละเอียดให้ครบถ้วนเพื่อความถูกต้องของงานพิธี</p>
    </div>
</div>

<%-- ========== FORM ========== --%>
<div class="page-wrapper">
    <div class="form-container">
   <form action="${pageContext.request.contextPath}/saveBooking" method="post">
        <input type="hidden" name="ceremony.ceremonyId" value="1">
        <c:set var="detailIndex" value="0"/>

        <div class="form-grid">

            <%-- ===== LEFT COLUMN ===== --%>
            <div>

                <%-- 1. วันที่กรอกแบบฟอร์ม --%>
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

                <%-- 2. วันและเวลาจัดงาน --%>
                <div class="form-card">
                    <div class="card-header">วันและเวลาจัดงาน</div>
                    <div class="card-body">
                        <div class="row-grid">
                            <div class="form-group">
                                <label class="form-label">วันที่จัดงาน <span class="required">*</span></label>
                                <input type="date" name="eventDate" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">เวลาเริ่มพิธี <span class="required">*</span></label>
                                <input type="time" name="eventTime" class="form-control" required>
                            </div>
                        </div>
                    </div>
                </div>

           <%-- 3. สถานที่จัดพิธี + รูปภาพสถานที่ --%>
<div class="form-card">
    <div class="card-header">สถานที่จัดพิธี</div>
    <div class="card-body">
        <div class="form-group">
            <label class="form-label">ที่อยู่ <span class="required">*</span></label>
            <textarea name="eventAddress" class="form-control" rows="3" required
                      placeholder="เช่น 123/45 หมู่บ้านบุญรักษา ตำบลสุทธิ อำเภอเมือง จังหวัดเชียงใหม่ 50000"></textarea>
        </div>
        <div class="form-group" style="margin-top:16px;">
            <label class="form-label">📸 รูปภาพสถานที่จัดงาน</label>
            <p style="font-size:12px;color:#A08840;margin-bottom:10px;">
                อัปโหลดได้หลายรูป เพื่อให้ทีมงานเตรียมการได้ถูกต้อง
            </p>

            <%-- Preview รูปที่เลือกแล้ว --%>
            <div id="imagePreviewBox" style="display:flex;flex-wrap:wrap;gap:8px;margin-bottom:10px;"></div>

<button type="button" onclick="document.getElementById('imgPicker').click()"
        style="cursor:pointer;background:#f5e6c0;border:1px dashed #D4A017;
               padding:8px 16px;border-radius:8px;color:#8B6914;font-size:13px;">
    + เพิ่มรูป
</button>
<input type="file" id="imgPicker" accept="image/*" style="display:none">

<div id="base64Container"></div>
        </div>
    </div>
</div>


                <%-- 4. จำนวนแขก --%>
                <div class="form-card">
                    <div class="card-header">รายละเอียดการจัดพิธี</div>
                    <div class="card-body">
                        <c:forEach items="${questions}" var="q">
                            <c:if test="${fn:contains(q.questionsText, 'แขก')}">
                                <div class="form-group">
                                    <label class="form-label">${q.questionsText}</label>
                                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                    <input type="number" name="details[${detailIndex}].answer"
                                           class="form-control" placeholder="ระบุจำนวนแขก..." min="1" required>
                                </div>
                                <c:set var="detailIndex" value="${detailIndex + 1}"/>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

            </div>

            <%-- ===== RIGHT COLUMN ===== --%>
            <div>

<%-- 5. การนิมนต์พระสงฆ์ --%>
<div class="form-card">
    <div class="card-header">การนิมนต์พระสงฆ์</div>
    <div class="card-body">

        <%-- จำนวนพระสงฆ์ --%>
        <c:forEach items="${questions}" var="q">
            <c:if test="${fn:contains(q.questionsText, 'จำนวนพระ')}">
                <div class="form-group">
                    <label class="form-label">${q.questionsText}</label>
                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                    <input type="number" name="details[${detailIndex}].answer"
                           class="form-control" placeholder="ระบุจำนวนพระสงฆ์..." min="1">
                </div>
                <c:set var="detailIndex" value="${detailIndex + 1}"/>
            </c:if>
        </c:forEach>

        <%-- รูปแบบการนิมนต์ --%>
        <c:forEach items="${questions}" var="q">
            <c:if test="${fn:contains(q.questionsText, 'รูปแบบการนิมนต์')}">
                <div class="form-group">
                    <label class="form-label">${q.questionsText}</label>
                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input type="radio" name="details[${detailIndex}].answer" value="นิมนต์เอง"
                                   onchange="toggleMonkDetail(this)" checked>
                            <span>นิมนต์เอง</span>
                        </label>
                        <label class="checkbox-label">
                            <input type="radio" name="details[${detailIndex}].answer" value="ให้ทางร้านนิมนต์"
                                   onchange="toggleMonkDetail(this)">
                            <span>ให้ทางร้านนิมนต์ให้</span>
                        </label>
                    </div>
                </div>
                <c:set var="detailIndex" value="${detailIndex + 1}"/>
            </c:if>
        </c:forEach>

        <%-- รายละเอียดวัด (แสดงเมื่อเลือกให้ร้านนิมนต์) --%>
        <div id="monkDetail" style="display:none;">
            <c:forEach items="${questions}" var="q">
                <c:if test="${fn:contains(q.questionsText, 'รายละเอียดการนิมนต์')}">
                    <div class="form-group">
                        <label class="form-label">ต้องการวัดเฉพาะเจาะจงหรือไม่?</label>
                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                        <div class="checkbox-group">
                            <label class="checkbox-label">
                                <input type="radio" name="monkWatType" value="วัดเดียวกัน"
                                       onchange="toggleWatDetail(this)">
                                <span>วัดเดียวกันทั้งหมด (ระบุชื่อวัด)</span>
                            </label>
                            <label class="checkbox-label">
                                <input type="radio" name="monkWatType" value="ต่างวัด"
                                       onchange="toggleWatDetail(this)">
                                <span>ต่างวัด (ระบุชื่อวัดแต่ละรูป)</span>
                            </label>
                            <label class="checkbox-label">
                                <input type="radio" name="monkWatType" value="ให้ร้านเลือกให้"
                                       onchange="toggleWatDetail(this)" checked>
                                <span>ให้ทางร้านเลือกให้</span>
                            </label>
                        </div>

                        <%-- วัดเดียวกัน: กรอกชื่อวัด 1 ช่อง --%>
                        <div id="watSameDetail" style="display:none; margin-top:10px;">
                            <textarea name="details[${detailIndex}].answer" id="watSameInput"
                                      class="form-control" rows="2"
                                      placeholder="ระบุชื่อวัด เช่น วัดพระสิงห์"></textarea>
                        </div>

                        <%-- ต่างวัด: กรอกแยกรายรูป --%>
                        <div id="watDiffDetail" style="display:none; margin-top:10px;">
                            <textarea name="details[${detailIndex}].answer" id="watDiffInput"
                                      class="form-control" rows="4"
                                      placeholder="ระบุชื่อวัดแต่ละรูป เช่น&#10;รูปที่ 1 วัดเชียงมั่น&#10;รูปที่ 2 วัดพระสิงห์&#10;รูปที่ 3 วัดสวนดอก"></textarea>
                        </div>

                    </div>
                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
                </c:if>
            </c:forEach>
        </div>

    </div>
</div>

<%-- 6. ชุดปิ่นโต --%>
<div class="form-card">
    <div class="card-header">ชุดภัตตาหารปิ่นโต</div>
    <div class="card-body">

        <c:forEach items="${questions}" var="q">
            <c:if test="${fn:contains(q.questionsText, 'ต้องการชุดภัตตาหาร')}">
                <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                <c:set var="detailIndex" value="${detailIndex + 1}"/>
            </c:if>
        </c:forEach>

        <div class="form-group">
            <label class="form-label">ต้องการชุดภัตตาหารปิ่นโตหรือไม่?</label>
            <div class="checkbox-group">
                <label class="checkbox-label">
                    <input type="radio" name="wantPinto" value="ต้องการ"
                           onchange="toggleSection('pintoDetail', true)">
                    <span>ต้องการ</span>
                </label>
                <label class="checkbox-label">
                    <input type="radio" name="wantPinto" value="ไม่ต้องการ"
                           onchange="toggleSection('pintoDetail', false)" checked>
                    <span>ไม่ต้องการ</span>
                </label>
            </div>
        </div>
        

        <div id="pintoDetail" style="display:none; margin-top:14px;">
            <c:forEach items="${questions}" var="q">
                <c:if test="${fn:contains(q.questionsText, 'เลือกชุดภัตตาหาร')}">
                    <div class="form-group">
                        <label class="form-label">เลือกชุดปิ่นโต</label>
                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                        <select name="details[${detailIndex}].answer" class="form-select">
                            <option value="">-- เลือกชุดปิ่นโต --</option>
                            <c:forEach items="${pintoItems}" var="item">
                                <c:if test="${fn:contains(item.itemName, 'ชุด')}">
                                    <option value="${item.itemName}">
                                        ${item.itemName} — ฿<fmt:formatNumber value="${item.pricePerUnit}" pattern="#,###"/> / ${item.unit}
                                    </option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
                </c:if>
            </c:forEach>

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
        </div>

    </div>
</div>

<%-- 7. สังฆทาน --%>
<div class="form-card">
    <div class="card-header">ชุดสังฆทาน</div>
    <div class="card-body">

        <c:forEach items="${questions}" var="q">
            <c:if test="${fn:contains(q.questionsText, 'ต้องการสังฆทาน')}">
                <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                <c:set var="detailIndex" value="${detailIndex + 1}"/>
            </c:if>
        </c:forEach>

        <div class="form-group">
            <label class="form-label">ต้องการชุดสังฆทานหรือไม่?</label>
            <div class="checkbox-group">
                <label class="checkbox-label">
                    <input type="radio" name="wantSanghatan" value="ต้องการ"
                           onchange="toggleSection('sanghatanDetail', true)">
                    <span>ต้องการ</span>
                </label>
                <label class="checkbox-label">
                    <input type="radio" name="wantSanghatan" value="ไม่ต้องการ"
                           onchange="toggleSection('sanghatanDetail', false)" checked>
                    <span>ไม่ต้องการ</span>
                </label>
            </div>
        </div>

        <div id="sanghatanDetail" style="display:none; margin-top:14px;">
            <c:forEach items="${questions}" var="q">
                <c:if test="${fn:contains(q.questionsText, 'เลือกชุดสังฆทาน')}">
                    <div class="form-group">
                        <label class="form-label">เลือกชุดสังฆทาน</label>
                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                        <select name="details[${detailIndex}].answer" class="form-select">
                            <option value="">-- เลือกชุดสังฆทาน --</option>
                            <c:forEach items="${sanghatharnItems}" var="item">
                                <option value="${item.itemName}">
                                    ${item.itemName} — ฿<fmt:formatNumber value="${item.pricePerUnit}" pattern="#,###"/> / ${item.unit}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
                </c:if>
            </c:forEach>

            <c:forEach items="${questions}" var="q">
                <c:if test="${fn:contains(q.questionsText, 'จำนวนชุดสังฆทาน')}">
                    <div class="form-group">
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
        </div>

        <div class="submit-row">
            <button type="submit" class="btn-submit">บันทึกข้อมูลการจอง</button>
        </div>
    </form>
    </div>
</div>



<script>
(function() {
    var imgPicker = document.getElementById('imgPicker');
    if (!imgPicker) {
        console.log('imgPicker not found!');
        return;
    }
    console.log('imgPicker found OK');

    var imageList = [];

    imgPicker.addEventListener('change', function() {
        console.log('file selected');
        var file = this.files[0];
        if (!file) return;

        var reader = new FileReader();
        reader.onload = function(e) {
            imageList.push(e.target.result);
            console.log('imageList length: ' + imageList.length);

            var box = document.getElementById('imagePreviewBox');
            var wrapper = document.createElement('div');
            wrapper.style.cssText = 'position:relative;width:80px;height:80px;';

            var img = document.createElement('img');
            img.src = e.target.result;
            img.style.cssText = 'width:80px;height:80px;object-fit:cover;border-radius:6px;border:1px solid #D4A017;';

            var del = document.createElement('button');
            del.type = 'button';
            del.innerText = 'x';
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
            console.log('hidden input added: imageBase64[' + i + ']');
        }
    }
})();
</script>

<script src="${pageContext.request.contextPath}/static/js/bookingForm.js?v=4"></script>
</body>
</html>

