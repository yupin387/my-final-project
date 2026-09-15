<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>รายละเอียดงานที่มอบหมาย - บุญมีนำพา จัดงานบุญ</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bookingList.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/managerAssignmentDetail.css">
</head>
<body>

    <!-- ===== NAVBAR  ===== -->
    <nav class="navbar">
      
        <a class="navbar-brand" href="${pageContext.request.contextPath}/manager/bookings">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา จัดงานบุญ" class="lotus-icon">
            <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
               
                <a href="${pageContext.request.contextPath}/manager/bookings"   class="nav-item active">รายการจอง</a>
                <a href="${pageContext.request.contextPath}/manager/head-staff" class="nav-item">หัวหน้างาน</a>
                <a href="${pageContext.request.contextPath}/manager/questions"  class="nav-item">จัดการพิธี</a>
                <a href="${pageContext.request.contextPath}/manager/quotation"  class="nav-item">จัดการใบเสนอราคา</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">M</div>
                <div class="user-detail">
                    <span class="user-name">Manager</span>
                    <span class="user-role">ผู้จัดการ</span>
                </div>
                <div class="dropdown-menu" id="dropdownMenu">
                   
                    <a href="${pageContext.request.contextPath}/manager/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- ===== PAGE WRAPPER ===== -->
    <div class="page-wrapper">

        <!-- ===== Flash Message ===== -->
        <c:if test="${not empty success}">
            <div class="flash-banner flash-banner-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash-banner flash-banner-error">${error}</div>
        </c:if>

        <!-- Page header with ornament -->
        <div class="list-header">
            <div class="section-ornament">
                <div class="ornament-line"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-diamond"></div>
                <div class="ornament-diamond-sm"></div>
                <div class="ornament-line right"></div>
            </div>
            <h1>รายละเอียดงานที่มอบหมาย</h1>
            <div class="gold-line"></div>
        </div>

        <!-- ===== Top actions ===== -->
        <div class="top-actions">
            <%-- ✅ แก้ไข: เปลี่ยนเป็น manager/bookings --%>
            <a href="${pageContext.request.contextPath}/manager/bookings?status=Confirmed" class="btn-back">← กลับหน้ารายการจอง</a>
            <span class="view-only-badge">👁 โหมดดูอย่างเดียว</span>
        </div>

        <!-- ===== DETAIL CARD ===== -->
        <div class="detail-card">
            <div class="card-header-bar">
                <span>ข้อมูลงานที่มอบหมาย</span>
                <span class="assign-id">รหัสมอบหมาย: ${a.assignId}</span>
            </div>

            <div class="card-body">

               
                <c:set var="status" value="${a.jobStatus}"/>
                <div class="progress-container">
                    <div class="progress-step">
                        <div class="step-circle ${status == 'Assigned' || status == 'Preparing' || status == 'In_Progress' || status == 'Completed' ? 'done' : ''}">✓</div>
                        <span class="step-label">มอบหมาย</span>
                    </div>
                    <div class="progress-step">
                        <div class="step-circle ${status == 'Preparing' || status == 'In_Progress' || status == 'Completed' ? 'done' : ''}">✓</div>
                        <span class="step-label">เตรียมงาน</span>
                    </div>
                    <div class="progress-step">
                        <div class="step-circle ${status == 'In_Progress' || status == 'Completed' ? 'done' : ''}">✓</div>
                        <span class="step-label">ดำเนินการ</span>
                    </div>
                    <div class="progress-step">
                        <div class="step-circle ${status == 'Completed' ? 'done' : ''}">✓</div>
                        <span class="step-label">เสร็จสิ้น</span>
                    </div>
                </div>

                <!-- สถานะปัจจุบัน (read-only) -->
                <div class="section-heading">สถานะปัจจุบัน</div>
                <c:choose>
                    <c:when test="${status == 'Assigned'}">
                        <span class="status-readonly-badge badge-Assigned">มอบหมายงานแล้ว</span>
                    </c:when>
                    <c:when test="${status == 'Preparing'}">
                        <span class="status-readonly-badge badge-Preparing">กำลังเตรียมงาน</span>
                    </c:when>
                    <c:when test="${status == 'In_Progress'}">
                        <span class="status-readonly-badge badge-In_Progress">กำลังดำเนินการ</span>
                    </c:when>
                    <c:when test="${status == 'Completed'}">
                        <span class="status-readonly-badge badge-Completed">เสร็จสิ้นงานบุญ</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-readonly-badge badge-Pending">${status}</span>
                    </c:otherwise>
                </c:choose>

                <hr class="divider">

                <!-- Assignment Info -->
                <div class="section-heading">ข้อมูลการมอบหมาย</div>
                <div class="info-grid">
                    <div class="info-group">
                        <span class="label">รหัสมอบหมาย</span>
                        <span class="value">${a.assignId}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">วันที่ได้รับมอบหมาย</span>
                        <span class="value"><fmt:formatDate value="${a.assignDate}" pattern="dd/MM/yyyy"/></span>
                    </div>
                    <div class="info-group">
                        <span class="label">หัวหน้างานผู้รับผิดชอบ</span>
                        <span class="value">${a.headStaff.staffFirstName} ${a.headStaff.staffLastName}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">เบอร์โทรหัวหน้างาน</span>
                        <span class="value">${a.headStaff.staffPhone}</span>
                    </div>
                </div>

                <hr class="divider">

                <!-- Booking Info -->
                <div class="section-heading">ข้อมูลการจองและลูกค้า</div>
                <div class="info-grid">
                    <div class="info-group">
                        <span class="label">รหัสการจอง</span>
                        <span class="value">${a.bookingForm.bookingId}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">ประเภทงาน</span>
                        <span class="value">${a.bookingForm.ceremony.ceremonyType}</span>
                    </div>
            
                    <div class="info-group">
                        <span class="label">รูปแบบการจอง</span>
                        <span class="value" >${a.bookingForm.ceremony.optionType}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">ลูกค้า</span>
                        <span class="value">${a.bookingForm.member.memberFirstName} ${a.bookingForm.member.memberLastName}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">เบอร์โทรศัพท์ลูกค้า</span>
                        <span class="value">${a.bookingForm.member.phoneNumber}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">วันที่จัดงาน</span>
                        <span class="value"><fmt:formatDate value="${a.bookingForm.eventDate}" pattern="dd/MM/yyyy"/></span>
                    </div>
                    <div class="info-group">
                        <span class="label">เวลาเริ่มงาน</span>
                        <span class="value">${a.bookingForm.eventTime} น.</span>
                    </div>
                </div>

                <hr class="divider">

                <div class="section-heading">สถานที่จัดงาน</div>
                <div class="address-box">${a.bookingForm.eventAddress}</div>

                <!-- รายงานความเสียหาย (ถ้ามี) -->
                <c:if test="${not empty a.reportNote}">
                    <hr class="divider">
                    <div class="section-heading">รายงานความเสียหายจากหัวหน้างาน</div>
                    <div class="damage-report-box">
                        ${a.reportNote}

                        <c:if test="${not empty a.reportImage}">
                            <div class="damage-images">
                                <c:forEach items="${fn:split(a.reportImage, ',')}" var="img">
                                    <img src="${pageContext.request.contextPath}/uploads/${img}"
                                         alt="รูปความเสียหาย" class="damage-image-item">
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:if>
                <c:if test="${empty a.reportNote}">
                    <hr class="divider">
                    <div class="section-heading">รายงานความเสียหายจากหัวหน้างาน</div>
                    <span class="empty-note">ยังไม่มีการรายงานความเสียหายสำหรับงานนี้</span>
                </c:if>

            </div>
        </div>
    </div>


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

    <script>
        function toggleDropdown() {
            document.getElementById('dropdownMenu').classList.toggle('show');
        }
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.user-info')) {
                document.getElementById('dropdownMenu').classList.remove('show');
            }
        });
    </script>
</body>
</html>
