<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ข้อมูลงาน - ${a.assignId}</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/assignmentDetail.css">
    <style>
        /* CSS สำหรับ Progress Tracker */
        .progress-container { display: flex; justify-content: space-between; margin: 30px 0; padding: 0 40px; position: relative; }
        .progress-step { display: flex; flex-direction: column; align-items: center; gap: 8px; }
        .step-circle { width: 40px; height: 40px; border-radius: 50%; background: #e0e0e0; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 18px; }
        .step-circle.done { background: #28a745; box-shadow: 0 0 10px rgba(40,167,69,0.3); }
        .step-label { font-size: 13px; font-weight: 600; color: #5a1010; }
        .btn-update-status { background: #D4A017; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 700; display: inline-flex; align-items: center; gap: 6px; border: none; cursor: pointer; }
        .btn-update-status:hover { background: #b88a10; }
    </style>
</head>
<body>

    <c:if test="${not empty success}"><span id="flash-success" data-msg="${success}" style="display:none;"></span></c:if>
    <c:if test="${not empty error}"><span id="flash-error" data-msg="${error}" style="display:none;"></span></c:if>

    <div class="navbar">
        <span class="navbar-title">ระบบรับจัดงานบุญ</span>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item active">รายการงาน</a>
                <a href="${pageContext.request.contextPath}/staff/items" class="nav-item">จัดการ Item</a>
            </nav>
          <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName}
                    ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                    <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile" class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </div>
    <div id="flash-banner-container"></div>

    <div class="container">
        <div class="top-actions">
            <a href="${pageContext.request.contextPath}/staff/assignments" class="btn-back">← กลับหน้ารายการ</a>

            <button type="button" class="btn-damage" onclick="openDamageModal()">⚠️ รายงานความเสียหาย</button>
        </div>

        <div class="card">
            <div class="card-header-bar">
                <span>รายละเอียดข้อมูลงาน</span>
                
                <a href="${pageContext.request.contextPath}/staff/assignments/update-status/${a.bookingForm.bookingId}" class="btn-update-status">🔄 อัปเดตสถานะงาน</a>
            </div>
            
            <div class="card-body">
                <div class="progress-container">
                    <c:set var="status" value="${a.jobStatus}" />
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

                <div class="info-grid">
                    <div class="info-group"><span class="label">รหัสมอบหมาย</span><span class="value value-id">${a.assignId}</span></div>
                    <div class="info-group"><span class="label">วันที่ได้รับมอบหมาย</span><span class="value"><fmt:formatDate value="${a.assignDate}" pattern="dd MMMM yyyy"/></span></div>
                </div>

                <hr class="divider">

                <div class="info-grid">
                    <div class="info-group"><span class="label">รหัสการจอง</span><span class="value">#${a.bookingForm.bookingId}</span></div>
                    <div class="info-group"><span class="label">ประเภทงาน</span><span class="value">${a.bookingForm.ceremony.ceremonyName}</span></div>
                    <div class="info-group"><span class="label">ลูกค้า</span><span class="value">${a.bookingForm.member.memberFirstName} ${a.bookingForm.member.memberLastName}</span></div>
                    <div class="info-group"><span class="label">เบอร์โทรศัพท์</span><span class="value">${a.bookingForm.member.phoneNumber}</span></div>
                    <div class="info-group"><span class="label">วันที่จัดงาน</span><span class="value value-date-warn"><fmt:formatDate value="${a.bookingForm.eventDate}" pattern="dd/MM/yyyy"/></span></div>
                    <div class="info-group"><span class="label">เวลาเริ่มงาน</span><span class="value">${a.bookingForm.eventTime} น.</span></div>
                </div>

                <hr class="divider">

                <div class="info-group">
                    <span class="label">สถานที่จัดงาน</span>
                    <div class="address-box">${a.bookingForm.eventAddress}</div>
                </div>
            </div>
        </div>
    </div>

    <%-- Modal รายงานความเสียหาย --%>
    <div class="modal-overlay" id="damageModal">
        <div class="modal-box">
            <div class="modal-header"><span class="modal-title">⚠️ รายงานความเสียหาย</span><span class="modal-close" onclick="closeDamageModal()">&times;</span></div>
            <form id="damageForm" action="${pageContext.request.contextPath}/staff/assignments/report-damage/save" method="post" enctype="multipart/form-data">
                <input type="hidden" name="assignId" value="${a.assignId}">
                <div class="form-group">
                    <label class="form-label">รายละเอียด <span class="required">*</span></label>
                    <textarea name="reportNote" rows="4" required placeholder="อธิบายความเสียหายที่พบ..."></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">แนบรูปภาพ</label>
                    <div class="upload-area" id="uploadArea" onclick="document.getElementById('fileInput').click()">
                        <input type="file" id="fileInput" name="damageImages" multiple accept=".jpg,.jpeg,.png" style="display:none;" onchange="handleFileSelect(this)">
                        <div class="upload-placeholder" id="uploadPlaceholder"><div class="upload-text">คลิกเลือกรูปภาพ</div></div>
                        <div class="upload-preview" id="uploadPreview"></div>
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel-modal" onclick="closeDamageModal()">ยกเลิก</button>
                    <button type="submit" class="btn-send">ส่งรายงาน</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/assignmentDetail.js"></script>
</body>
</html>