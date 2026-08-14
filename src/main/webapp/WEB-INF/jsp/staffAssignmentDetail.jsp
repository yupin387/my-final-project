<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ข้อมูลงาน - ${a.assignId}</title>
    <link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/assignmentDetail.css?v=4">
</head>
<body>

    <c:if test="${not empty success}"><span id="flash-success" data-msg="${success}" style="display:none;"></span></c:if>
    <c:if test="${not empty error}"><span id="flash-error" data-msg="${error}" style="display:none;"></span></c:if>

    <%-- ===== NAVBAR ===== --%>
    <nav class="navbar">
        <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/staff/assignments">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon">
            <span class="navbar-title">บุญมีนำพา จัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item active">รายการงาน</a>
                <a href="${pageContext.request.contextPath}/staff/items"       class="nav-item">จัดการ Item</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile"    class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </nav>

    <div id="flash-banner-container"></div>

    <div class="container">

        <%-- Top Actions --%>
        <div class="top-actions">
            <a href="${pageContext.request.contextPath}/staff/assignments" class="btn-back">← กลับหน้ารายการ</a>
            <button type="button" class="btn-damage" onclick="openDamageModal()">⚠️ รายงานความเสียหาย</button>
        </div>

        <div class="card">
            <div class="card-header-bar">
                <span>รายละเอียดข้อมูลงาน</span>
                <%-- FIX: เดิมเป็น <a> ลิงก์ไปหน้า updateStatus.jsp แยกต่างหาก
                     ตอนนี้เปลี่ยนเป็นปุ่มเปิด modal dropdown ในหน้าเดียวกันแทน
                     ไม่ต้องเปลี่ยนหน้าเลย --%>
                <button type="button" class="btn-update-status" onclick="openStatusModal()">🔄 อัปเดตสถานะงาน</button>
            </div>

            <div class="card-body">

                <%-- Progress Tracker --%>
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

                <%-- Assignment Info --%>
                <div class="section-heading">ข้อมูลการมอบหมาย</div>
                <div class="info-grid">
                    <div class="info-group">
                        <span class="label">รหัสมอบหมาย</span>
                        <span class="value">${a.assignId}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">วันที่ได้รับมอบหมาย</span>
                        <span class="value"><fmt:formatDate value="${a.assignDate}" pattern="dd MMMM yyyy"/></span>
                    </div>
                </div>

                <hr class="divider">

                <%-- Booking Info --%>
                <div class="section-heading">ข้อมูลการจองและลูกค้า</div>
                <div class="info-grid">
                    <div class="info-group">
                        <span class="label">รหัสการจอง</span>
                        <span class="value">#${a.bookingForm.bookingId}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">ประเภทงาน</span>
                        <span class="value">${a.bookingForm.ceremony.ceremonyType}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">ลูกค้า</span>
                        <span class="value">${a.bookingForm.member.memberFirstName} ${a.bookingForm.member.memberLastName}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">เบอร์โทรศัพท์</span>
                        <span class="value">${a.bookingForm.member.phoneNumber}</span>
                    </div>
                    <div class="info-group">
                        <span class="label">วันที่จัดงาน</span>
                        <span class="value">
                            <fmt:formatDate value="${a.bookingForm.eventDate}" pattern="dd/MM/yyyy"/>
                        </span>
                    </div>
                    <div class="info-group">
                        <span class="label">เวลาเริ่มงาน</span>
                        <span class="value">${a.bookingForm.eventTime} น.</span>
                    </div>
                </div>

                <hr class="divider">


                <div class="section-heading">สถานที่จัดงาน</div>
                <div class="address-box">${a.bookingForm.eventAddress}</div>

            </div>
        </div>
    </div>

    <%-- ===== FOOTER ===== --%>
    <footer class="site-footer">
        <div class="footer-content">
            <div class="footer-brand">
                <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                     alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
                <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
            </div>
            <p class="footer-tagline">ระบบจัดการงานบุญสำหรับหัวหน้างาน</p>
        </div>
     
    </footer>

    <%-- Modal รายงานความเสียหาย --%>
    <div class="modal-overlay" id="damageModal">
        <div class="modal-box">
            <div class="modal-header">
                <span class="modal-title">⚠️ รายงานความเสียหาย</span>
                <span class="modal-close" onclick="closeDamageModal()">&times;</span>
            </div>
            <form id="damageForm"
                  action="${pageContext.request.contextPath}/staff/assignments/report-damage/save"
                  method="post" enctype="multipart/form-data">
                <input type="hidden" name="assignId" value="${a.assignId}">
                <div class="form-group">
                    <label class="form-label">รายละเอียด <span class="required">*</span></label>
                    <textarea name="reportNote" rows="4" required placeholder="อธิบายความเสียหายที่พบ..."></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">แนบรูปภาพ</label>
                    <div class="upload-area" id="uploadArea" onclick="document.getElementById('fileInput').click()">
                        <input type="file" id="fileInput" name="damageImages" multiple accept=".jpg,.jpeg,.png"
                               style="display:none;" onchange="handleFileSelect(this)">
                        <div class="upload-placeholder" id="uploadPlaceholder">
                            <div class="upload-icon">📷</div>
                            <div class="upload-text">คลิกเลือกรูปภาพ</div>
                            <div class="upload-hint">รองรับ JPG, PNG</div>
                        </div>
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

    <%-- ========================================================
         Modal อัปเดตสถานะงาน (FIX: ใหม่ — แทนที่การลิงก์ไปหน้า
         updateStatus.jsp แยก ด้วย modal dropdown ในหน้านี้เลย
         ฟอร์ม submit ปกติไปที่ endpoint เดิม (/update-status/save)
         พร้อม field เดิมทุกตัว (bookingId, jobStatus) เพื่อไม่ต้อง
         แก้ controller ========================================== --%>
    <div class="modal-overlay" id="statusModal">
        <div class="modal-box status-modal-box">
            <div class="modal-header status-modal-header">
                <span class="modal-title">🔄 อัปเดตสถานะงาน</span>
                <span class="modal-close" onclick="closeStatusModal()">&times;</span>
            </div>
            <form id="statusForm"
                  action="${pageContext.request.contextPath}/staff/assignments/update-status/save"
                  method="post">
                <input type="hidden" name="bookingId" value="${a.bookingForm.bookingId}">

                <div class="form-group">
                    <label class="form-label">เลือกสถานะปัจจุบันของงานพิธีกรรม</label>

                    <div class="status-select-wrapper">
                        <span class="status-select-dot" id="statusSelectDot"></span>
                        <select name="jobStatus" id="statusSelect" class="status-select" onchange="updateStatusPreview()">
                            <option value="Assigned"    data-color="#94a3b8" ${status == 'Assigned'    ? 'selected' : ''}>มอบหมายงานแล้ว (Assigned)</option>
                            <option value="Preparing"   data-color="#f59e0b" ${status == 'Preparing'   ? 'selected' : ''}>กำลังเตรียมงาน (Preparing)</option>
                            <option value="In_Progress" data-color="#3b82f6" ${status == 'In_Progress' ? 'selected' : ''}>กำลังดำเนินการ (In Progress)</option>
                            <option value="Completed"   data-color="#22c55e" ${status == 'Completed'   ? 'selected' : ''}>เสร็จสิ้นงานบุญ (Completed)</option>
                        </select>
                        <span class="status-select-arrow">▾</span>
                    </div>

                    <p class="status-select-hint" id="statusSelectHint"></p>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn-cancel-modal" onclick="closeStatusModal()">ยกเลิก</button>
                    <button type="submit" class="btn-save-status">บันทึกสถานะ</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/assignmentDetail.js"></script>

    <%-- FIX: สคริปต์เฉพาะของ modal อัปเดตสถานะ ตั้งชื่อฟังก์ชันแยกจาก
         assignmentDetail.js (openDamageModal/closeDamageModal) เพื่อไม่ชนกัน --%>
    <script>
        var statusHints = {
            'Assigned':    'พนักงานรับทราบงานแล้ว รอเริ่มดำเนินการ',
            'Preparing':   'จัดหาอุปกรณ์และของใช้สำหรับพิธีกรรม',
            'In_Progress': 'พนักงานกำลังปฏิบัติงานที่สถานที่จัดงาน',
            'Completed':   'งานเสร็จสมบูรณ์ เคลียร์หน้างานเรียบร้อย'
        };

        function openStatusModal() {
            document.getElementById('statusModal').classList.add('show');
            updateStatusPreview();
        }

        function closeStatusModal() {
            document.getElementById('statusModal').classList.remove('show');
        }

        function updateStatusPreview() {
            var select = document.getElementById('statusSelect');
            var opt = select.options[select.selectedIndex];
            var color = opt.getAttribute('data-color');

            document.getElementById('statusSelectDot').style.background = color;
            document.getElementById('statusSelect').style.borderColor = color;
            document.getElementById('statusSelectHint').textContent = statusHints[opt.value] || '';
        }

        // ปิด modal เมื่อคลิกพื้นหลังนอกกล่อง (เหมือน damageModal)
        document.getElementById('statusModal').addEventListener('click', function (e) {
            if (e.target === this) closeStatusModal();
        });

        document.addEventListener('DOMContentLoaded', updateStatusPreview);
    </script>
</body>
</html>
