<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>จองงานสืบชะตา - ระบบรับจัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bookingForm.css?v=6"></head>
<body>

<%-- ========== NAVBAR (เหมือนหน้า Home) ========== --%>
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

<%-- ========== HERO BANNER (รูปปกเหมือนหน้า Home) ========== --%>
<div class="hero-banner">
    <div class="hero-content">
        <span class="hero-tag">ระบบจองงานบุญ</span>
        <h1>จองงานสืบชะตา</h1>
        <p>ระบุรายละเอียดให้ครบถ้วนเพื่อความถูกต้องของงานพิธี</p>
    </div>
</div>

<%-- ========== FORM ========== --%>
<div class="page-wrapper">
    <div class="form-container">
    <form action="${pageContext.request.contextPath}/saveBooking" method="post">
        <input type="hidden" name="ceremony.ceremonyId" value="2">
        <c:set var="detailIndex" value="0"/>
        
        <%-- DEBUG ชั่วคราว --%>
        <div class="form-grid">

            <%-- ===== LEFT COLUMN ===== --%>
            <div>

                <%-- วันที่กรอกแบบฟอร์ม --%>
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

                <%-- วันและเวลาจัดงาน --%>
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

                <%-- สถานที่จัดพิธี --%>
                <div class="form-card">
                    <div class="card-header">สถานที่จัดพิธี</div>
                    <div class="card-body">
                        <c:forEach items="${questions}" var="q">
                            <c:if test="${fn:contains(q.questionsText, 'จัดพิธีที่')}">
                                <div class="form-group">
                                    <label class="form-label">${q.questionsText}</label>
                                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
                                    <select name="details[${detailIndex}].answer" class="form-select" placeholder="--เลือกสถานที่--">
                                        <option value="จัดที่บ้าน">จัดที่บ้าน</option>
                                        <option value="จัดที่วัด">จัดที่วัด</option>
                                    </select>
                                </div>
                                <c:set var="detailIndex" value="${detailIndex + 1}"/>
                            </c:if>
                        </c:forEach>
                        <div class="form-group">
                            <label class="form-label">ที่อยู่ <span class="required">*</span></label>
                            <textarea name="eventAddress" class="form-control" rows="3" required
                                      placeholder="เช่น 123/45 หมู่บ้านบุญรักษา ตำบลสุทธิ อำเภอเมือง จังหวัดเชียงใหม่ 50000"></textarea>
                        </div>
                    </div>
                </div>

                <%-- รายละเอียดการจัดพิธี --%>
				<div class="form-card">
				    <div class="card-header">รายละเอียดการจัดพิธี</div>
				    <div class="card-body">
				
				        <%-- คำถาม: จำนวนผู้เข้าร่วมพิธี เท่านั้น --%>
				        <c:forEach items="${questions}" var="q">
				            <c:if test="${fn:contains(q.questionsText, 'จำนวนผู้')}">
				                <div class="form-group">
				                    <label class="form-label">${q.questionsText}</label>
				                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
				                    <input type="text" name="details[${detailIndex}].answer"
				                           class="form-control" placeholder="เช่น 20 คน" required>
				                </div>
				                <c:set var="detailIndex" value="${detailIndex + 1}"/>
				            </c:if>
				        </c:forEach>
				
				        <%-- คำถาม: ต้องการผูกข้อมือรับพรหรือไม่ --%>
				        <c:forEach items="${questions}" var="q">
				            <c:if test="${fn:contains(q.questionsText, 'ผูกข้อมือ')}">
				                <div class="form-group">
				                    <label class="form-label">${q.questionsText}</label>
				                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
				                    <select name="details[${detailIndex}].answer" class="form-select">
				                        <option value="ไม่ต้องการ">ไม่ต้องการ</option>
				                        <option value="ต้องการ">ต้องการ</option>
				                    </select>
				                </div>
				                <c:set var="detailIndex" value="${detailIndex + 1}"/>
				            </c:if>
				        </c:forEach>
				
				    </div>
				</div>
			</div>

            <%-- ===== RIGHT COLUMN ===== --%>
            <div>

                <%-- การนิมนต์พระสงฆ์ --%>
				<div class="form-card">
				    <div class="card-header">การนิมนต์พระสงฆ์</div>
				    <div class="card-body">
				
				        <%-- รอบที่ 1: รูปแบบการนิมนต์ --%>
				        <c:forEach items="${questions}" var="q">
				            <c:if test="${(fn:contains(q.questionsText, 'นิมนต์') || fn:contains(q.questionsText, 'พระ')) && fn:contains(q.questionsText, 'รูปแบบ')}">
				                <div class="form-group">
				                    <label class="form-label">${q.questionsText}</label>
				                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
				                    <select name="details[${detailIndex}].answer" class="form-select">
				                        <option value="นิมนต์เอง">นิมนต์เอง</option>
				                        <option value="ให้ทางระบบจัดการ">ให้ทางระบบจัดการ</option>
				                    </select>
				                </div>
				                <c:set var="detailIndex" value="${detailIndex + 1}"/>
				            </c:if>
				        </c:forEach>
				
				        <%-- รอบที่ 2: รายละเอียดการนิมนต์ (ขึ้นก่อนจำนวน) --%>
				        <c:forEach items="${questions}" var="q">
				            <c:if test="${(fn:contains(q.questionsText, 'นิมนต์') || fn:contains(q.questionsText, 'พระ')) && !fn:contains(q.questionsText, 'รูปแบบ') && !fn:contains(q.questionsText, 'จำนวน')}">
				                <div class="form-group">
				                    <label class="form-label">${q.questionsText}</label>
				                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
				                    <input type="text" name="details[${detailIndex}].answer"
				                           class="form-control" placeholder="ระบุรายละเอียดเพิ่มเติม...">
				                </div>
				                <c:set var="detailIndex" value="${detailIndex + 1}"/>
				            </c:if>
				        </c:forEach>
				
				        <%-- รอบที่ 3: จำนวนพระสงฆ์ (ลงท้าย) --%>
				        <c:forEach items="${questions}" var="q">
				            <c:if test="${(fn:contains(q.questionsText, 'นิมนต์') || fn:contains(q.questionsText, 'พระ')) && fn:contains(q.questionsText, 'จำนวน')}">
				                <div class="form-group">
				                    <label class="form-label">${q.questionsText}</label>
				                    <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
				                    <input type="number" name="details[${detailIndex}].answer"
				                           class="form-control" placeholder="ระบุจำนวนพระสงฆ์">
				                </div>
				                <c:set var="detailIndex" value="${detailIndex + 1}"/>
				            </c:if>
				        </c:forEach>
				
				    </div>
				</div>

                <%-- ชุดภัตตาหารปิ่นโต (เฉพาะคำถามปิ่นโตเท่านั้น) --%>
			    <div class="form-card">
			        <div class="card-header">ชุดภัตตาหารปิ่นโต</div>
			        <div class="card-body">
			
			            <%-- รอบที่ 1: ต้องการปิ่นโตหรือไม่ --%>
			            <c:forEach items="${questions}" var="q">
			                <c:if test="${fn:contains(q.questionsText, 'ปิ่นโต') && !fn:contains(q.questionsText, 'เลือก') && !fn:contains(q.questionsText, 'จำนวน')}">
			                    <div class="form-group">
			                        <label class="form-label">${q.questionsText}</label>
			                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
			                        <select name="details[${detailIndex}].answer" class="form-select">
			                            <option value="ไม่ต้องการ">ไม่ต้องการ</option>
			                            <option value="ต้องการ">ต้องการ</option>
			                        </select>
			                    </div>
			                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
			                </c:if>
			            </c:forEach>
			
			            <%-- รอบที่ 2: เลือกชุดปิ่นโต --%>
			            <c:forEach items="${questions}" var="q">
			                <c:if test="${fn:contains(q.questionsText, 'เลือก') && fn:contains(q.questionsText, 'ปิ่นโต')}">
			                    <div class="form-group">
			                        <label class="form-label">${q.questionsText}</label>
			                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
			                        <select name="details[${detailIndex}].answer" class="form-select">
			                            <option value="ไม่ต้องการ">-- เลือกชุดปิ่นโต --</option>
			                            <c:forEach items="${pintoItems}" var="item">
			                                <c:if test="${fn:contains(item.itemName, 'ชุด')}">
			                                    <option value="${item.itemName}">${item.itemName}</option>
			                                </c:if>
			                            </c:forEach>
			                        </select>
			                    </div>
			                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
			                </c:if>
			            </c:forEach>
			
			            <%-- รอบที่ 3: จำนวนชุดปิ่นโต --%>
			            <c:forEach items="${questions}" var="q">
			                <c:if test="${fn:contains(q.questionsText, 'จำนวนชุด') && fn:contains(q.questionsText, 'ปิ่นโต')}">
			                    <div class="form-group">
			                        <label class="form-label">${q.questionsText}</label>
			                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
			                        <input type="number" name="details[${detailIndex}].answer" class="form-control"
			                               placeholder="ระบุจำนวนชุด..." min="0">
			                    </div>
			                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
			                </c:if>
			            </c:forEach>
			
			        </div>
			    </div>
			
			    <%-- รายละเอียดสังฆทาน --%>
			    <div class="form-card">
			        <div class="card-header">รายละเอียดสังฆทาน</div>
			        <div class="card-body">
			
			            <%-- ต้องการสังฆทานหรือไม่ --%>
			            <c:forEach items="${questions}" var="q">
			                <c:if test="${fn:contains(q.questionsText, 'สังฆทาน') && !fn:contains(q.questionsText, 'เลือก') && !fn:contains(q.questionsText, 'จำนวน')}">
			                    <div class="form-group">
			                        <label class="form-label">${q.questionsText}</label>
			                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
			                        <select name="details[${detailIndex}].answer" class="form-select">
			                            <option value="ไม่ต้องการ">ไม่ต้องการ</option>
			                            <option value="ต้องการ">ต้องการ</option>
			                        </select>
			                    </div>
			                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
			                </c:if>
			            </c:forEach>
			
			            <%-- เลือกชุดสังฆทาน --%>
			            <c:forEach items="${questions}" var="q">
						    <c:if test="${fn:contains(q.questionsText, 'เลือก') && fn:contains(q.questionsText, 'สังฆทาน')}">
						        <div class="form-group">
						            <label class="form-label">${q.questionsText}</label>
						            <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
						            
						            <select name="details[${detailIndex}].answer" class="form-select" required>
						                <option value="">-- เลือกชุดสังฆทาน --</option>
						                
						                <%-- ตรวจสอบชื่อตัวแปรให้ตรงกับใน Controller --%>
						                <c:forEach items="${sanghatharnItems}" var="item">
						                    <option value="${item.itemName}">${item.itemName}</option>
						                </c:forEach>
						            </select>
						        </div>
						        <c:set var="detailIndex" value="${detailIndex + 1}"/>
						    </c:if>
						</c:forEach>
			
			            <%-- จำนวนชุดสังฆทาน --%>
			            <c:forEach items="${questions}" var="q">
			                <c:if test="${fn:contains(q.questionsText, 'จำนวน') && fn:contains(q.questionsText, 'สังฆทาน')}">
			                    <div class="form-group">
			                        <label class="form-label">${q.questionsText}</label>
			                        <input type="hidden" name="details[${detailIndex}].question.questionsId" value="${q.questionsId}">
			                        <input type="number" name="details[${detailIndex}].answer" class="form-control"
			                               placeholder="ระบุจำนวนชุด..." min="0">
			                    </div>
			                    <c:set var="detailIndex" value="${detailIndex + 1}"/>
			                </c:if>
			            </c:forEach>
			
			        </div>
			    </div>
			
			</div>

        <div class="submit-row">
            <button type="submit" class="btn-submit">บันทึกข้อมูลการจอง</button>
        </div>
    </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bookingForm.js"></script>
</body>
</html>
