<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <title>${ceremony.ceremonyName} - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/ceremonyDetail.css">
</head>
<body>

    <%-- Navbar --%>
    <div class="cd-navbar">
        <span class="cd-nav-title">ระบบรับจัดงานบุญ</span>
        <div class="cd-nav-links">
            <a href="${pageContext.request.contextPath}/home" class="cd-nav-link">กลับหน้าหลัก</a>
        </div>
    </div>

    <%-- Hero Banner — เปลี่ยนรูปตาม ceremonyId --%>
   <%-- แก้ไขในไฟล์ ceremonyDetail.jsp --%>
<c:choose>
    <c:when test="${ceremony.ceremonyId == 1}">
        <%-- เปลี่ยนจาก ceremony-hero-1.webp เป็น ceremony1.webp --%>
        <div class="cd-hero" style="background-image: url('${pageContext.request.contextPath}/static/images/ceremony1.webp');">
    </c:when>
    <c:otherwise>
        <%-- เปลี่ยนจาก ceremony-hero-2.jpg เป็น ceremony2.jpg --%>
        <div class="cd-hero" style="background-image: url('${pageContext.request.contextPath}/static/images/ceremony2.jpg');">
    </c:otherwise>
</c:choose>
        <div class="cd-hero-overlay"></div>
        <div class="cd-hero-content">
            <div class="cd-hero-tag">พิธีกรรมไทย</div>
            <h1 class="cd-hero-title">${ceremony.ceremonyName}</h1>
            <p class="cd-hero-desc">${ceremony.ceremonyDetail}</p>
            <div class="cd-price-tag">
                เริ่มต้น <fmt:formatNumber value="${ceremony.basePrice}" pattern="#,###"/> บาท
            </div>
        </div>
    </div>

    <%-- Main Content --%>
    <div class="cd-container">
        <div class="cd-grid">

            <%-- คอลัมน์ซ้าย --%>
            <div>
                <div class="cd-card">
                    <div class="cd-card-title">รายการอุปกรณ์ที่ใช้ในงาน</div>
                    <ul class="cd-item-list">
                        <c:forEach items="${equipments}" var="item">
                            <li>
                                <span class="cd-dot"></span>
                                <span>${item.itemName}
                                    <c:if test="${not empty item.itemDetail}">
                                        <span class="cd-item-detail">(${item.itemDetail})</span>
                                    </c:if>
                                </span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty equipments}">
                            <li><span class="cd-dot"></span><span>กำลังอัปเดตข้อมูลอุปกรณ์...</span></li>
                        </c:if>
                    </ul>
                </div>
                
                <%-- ส่วนชุดสังฆทาน --%>
			    <div class="cd-card">
					<div class="cd-card-title">ชุดสังฆทาน</div>
					    <p class="cd-pinto-sub">คัดสรรของใช้คุณภาพ เพื่อถวายแด่พระสงฆ์</p>
					    
					    <c:forEach items="${sanghatanSets}" var="set">
					        <div class="cd-pinto-box" style="margin-bottom: 15px;">
					            <div class="cd-pinto-head">
					                <span class="cd-pinto-name">${set.itemName}</span>
					                <span class="cd-pinto-price">฿${set.pricePerUnit} / ${set.unit}</span>
					            </div>
					            <div class="cd-pinto-body">
					                <div class="cd-menu-label">รายละเอียด</div>
					                <ul class="cd-menu-list">
					                    <li>${not empty set.itemDetail ? set.itemDetail : 'ยังไม่มีรายการรายละเอียด'}</li>
					                </ul>
					            </div>
					        </div>
					    </c:forEach>
					</div> 
                </div>
            

            <%-- คอลัมน์ขวา --%>
            <div>
                <div class="cd-card">
                    <div class="cd-card-title">ชุดภัตตาหารปิ่นโตถวายพระ</div>
                    <p class="cd-pinto-sub">ปรุงสดใหม่ทุกวัน เลือกได้ตามงบประมาณ</p>

                    <c:forEach items="${pintoSets}" var="set">
                        <div class="cd-pinto-box">
                            <div class="cd-pinto-head">
                                <span class="cd-pinto-name">${set.itemName}</span>
                                <span class="cd-pinto-price">฿${set.pricePerUnit} / ${set.unit}</span>
                            </div>
                            <div class="cd-pinto-body">

                                <div class="cd-menu-label">ข้าว</div>
                                <ul class="cd-menu-list">
                                    <c:set var="riceCount" value="0"/>
                                    <c:forEach items="${pintoMenus}" var="menu">
                                        <c:if test="${fn:contains(menu.itemName, 'ข้าว') && riceCount < 3}">
                                            <li>${menu.itemName}</li>
                                            <c:set var="riceCount" value="${riceCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                </ul>

                                <div class="cd-menu-label">กับข้าว</div>
                                <ul class="cd-menu-list">
                                    <c:set var="dishCount" value="0"/>
                                    <c:forEach items="${pintoMenus}" var="menu">
                                        <c:if test="${(fn:contains(menu.itemName, 'แกง') || fn:contains(menu.itemName, 'ผัด') || fn:contains(menu.itemName, 'ต้ม') || fn:contains(menu.itemName, 'ทอด')) && dishCount < 3}">
                                            <li>${menu.itemName}</li>
                                            <c:set var="dishCount" value="${dishCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                </ul>

                                <div class="cd-menu-label">ของหวาน / เครื่องดื่ม</div>
                                <ul class="cd-menu-list">
                                    <c:set var="sweetCount" value="0"/>
                                    <c:forEach items="${pintoMenus}" var="menu">
                                        <c:if test="${(fn:contains(menu.itemName, 'ขนม') || fn:contains(menu.itemName, 'น้ำ') || fn:contains(menu.itemName, 'ลูกชุบ') || fn:contains(menu.itemName, 'ทับทิม')) && sweetCount < 3}">
                                            <li>${menu.itemName}</li>
                                            <c:set var="sweetCount" value="${sweetCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                </ul>

                            </div>
                        </div>
                    </c:forEach>
                </div> 
                   
                <div class="cd-card">
                    <div class="cd-card-title">ค่าดำเนินการและบริการ</div>
	                    <c:forEach items="${services}" var="s">
	                        <div class="cd-service-row">
	                            <span class="cd-service-name">${s.itemName}</span>
	                            <span class="cd-service-badge">${s.itemDetail}</span>
	                        </div>
	                    </c:forEach>
	                </div>
	            </div>
            </div>

        </div>
    </div>

    <%-- Footer Bar --%>
    <div class="cd-footer">
        <div class="cd-footer-inner">
            <div class="cd-footer-price">
                ราคาเริ่มต้น <fmt:formatNumber value="${ceremony.basePrice}" pattern="#,###"/> บาท
            </div>
            <c:choose>
                <c:when test="${ceremony.ceremonyId == 1}">
                    <a href="${pageContext.request.contextPath}/booking" class="cd-btn-book">จองงานขึ้นบ้านใหม่</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/booking2" class="cd-btn-book">จองงานสืบชะตา</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/ceremonyDetail.js"></script>
</body>
</html>
