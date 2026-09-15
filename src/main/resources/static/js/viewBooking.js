/**
 * viewBooking.js - Interactive Scripts for Member Booking Summary Page
 */

// Toggle Dropdown Menu (สำหรับโปรไฟล์ผู้ใช้)
function toggleDropdown(event) {
    if (event) {
        event.stopPropagation();
    }
    const menu = document.getElementById('dropdownMenu');
    if (menu) {
        menu.classList.toggle('show');
    }
}

// ซ่อน Dropdown เมื่อคลิกพื้นที่อื่นภายนอก
document.addEventListener('click', function (e) {
    const userPill = document.querySelector('.user-profile-pill');
    const menu = document.getElementById('dropdownMenu');
    if (menu && menu.classList.contains('show')) {
        if (userPill && !userPill.contains(e.target) && !menu.contains(e.target)) {
            menu.classList.remove('show');
        }
    }
});

// แสดง Modal ยืนยันการยกเลิกรายการจอง
function showCancelModal(bookingId) {
    if (document.getElementById('cancelBookingId')) {
        document.getElementById('cancelBookingId').textContent = bookingId;
    }

    const baseUrl = (typeof contextPath !== 'undefined') ? contextPath : '';
    const cancelUrl = baseUrl + '/booking/cancel/' + bookingId;

    const confirmBtn = document.getElementById('confirmCancelUrl');
    if (confirmBtn) {
        confirmBtn.setAttribute('href', cancelUrl);
        // เก็บ URL ไว้ใน dataset ด้วย เผื่อ href ถูกรีเซ็ตหรืออ่านยากกว่า attribute
        confirmBtn.dataset.cancelUrl = cancelUrl;
    }

    const cancelModalElement = document.getElementById('cancelModal');
    if (cancelModalElement) {
        const cancelModal = new bootstrap.Modal(cancelModalElement);
        cancelModal.show();
    }
}

// ปิด Modal ยกเลิกการจอง
function closeCancelModal() {
    const cancelModalElement = document.getElementById('cancelModal');
    if (cancelModalElement) {
        const instance = bootstrap.Modal.getInstance(cancelModalElement);
        if (instance) instance.hide();
    }
}

// ===== FIX: ยิงคำขอยกเลิกแบบ AJAX แทนการปล่อยให้ <a href> navigate ออกจากหน้า
// เพราะ /booking/cancel/{id} เดิมทำ redirect:/home อยู่แล้ว fetch() จะตาม
// redirect นี้ไปจบที่หน้า /home (status 200) ทำให้เช็ค res.ok ได้เลย
// โดยไม่ต้องแก้ Controller ฝั่ง backend เลย =====
document.addEventListener('DOMContentLoaded', function () {
    const confirmBtn = document.getElementById('confirmCancelUrl');
    if (!confirmBtn) return;

    confirmBtn.addEventListener('click', function (e) {
        e.preventDefault();

        const url = confirmBtn.dataset.cancelUrl || confirmBtn.getAttribute('href');
        if (!url || url === '#') return;

        const originalText = confirmBtn.textContent;
        confirmBtn.textContent = 'กำลังยกเลิก...';
        confirmBtn.style.pointerEvents = 'none';
        confirmBtn.style.opacity = '0.7';

        fetch(url, { method: 'GET' })
            .then(function (res) {
                if (res.ok) {
                    closeCancelModal();
                    lockBookingAsCancelled();
                } else {
                    alert('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง');
                    confirmBtn.textContent = originalText;
                    confirmBtn.style.pointerEvents = '';
                    confirmBtn.style.opacity = '';
                }
            })
            .catch(function () {
                alert('เชื่อมต่อไม่สำเร็จ กรุณาลองใหม่อีกครั้ง');
                confirmBtn.textContent = originalText;
                confirmBtn.style.pointerEvents = '';
                confirmBtn.style.opacity = '';
            });
    });
});

// ===== อัปเดตหน้า viewBooking ให้แสดงสถานะ "ยกเลิกแล้ว" ทันที
// โดยไม่ต้อง reload หน้า (เทียบเท่า lockQuotationAsConfirmed ของหน้าใบเสนอราคา) =====
function lockBookingAsCancelled() {
    // 1. อัปเดต status pill ที่หัวเอกสาร
    const statusPill = document.getElementById('bookingStatusPill');
    if (statusPill) {
        statusPill.className = 'status-pill status-cancelled';
        statusPill.textContent = 'ยกเลิกแล้ว';
    }

    // 2. ลบกล่องแจ้งเตือน "รอการติดต่อจากทีมงาน" (ถ้ามีอยู่)
    const pendingNotice = document.getElementById('pendingNotice');
    if (pendingNotice) {
        pendingNotice.remove();
    }

    // 3. แทรกกล่องแจ้งเตือน "ยกเลิกรายการจองแล้ว" ไว้เหนือเอกสารใบสรุป
    const pageWrapper = document.querySelector('.page-wrapper');
    const sheetDoc = document.querySelector('.booking-sheet-document');
    if (pageWrapper && sheetDoc && !document.getElementById('cancelledNotice')) {
        const notice = document.createElement('div');
        notice.className = 'booking-notice notice-cancelled';
        notice.id = 'cancelledNotice';
        notice.innerHTML =
            '<div class="notice-icon"><i class="bi bi-x-circle-fill"></i></div>' +
            '<div class="notice-content">' +
            '<strong>ยกเลิกรายการจองเรียบร้อยแล้ว</strong>' +
            '<p>ท่านได้ทำการยกเลิกรายการจองนี้ด้วยตนเอง หากต้องการจองใหม่ สามารถทำรายการได้ที่หน้าหลัก</p>' +
            '</div>';
        pageWrapper.insertBefore(notice, sheetDoc);
    }

    // 4. เอาปุ่ม "ยกเลิกรายการจอง" ออกจาก Action Bar (ยกเลิกไปแล้ว ไม่ต้องกดซ้ำ)
    const cancelBtn = document.querySelector('.action-bar .btn-cancel');
    if (cancelBtn) {
        cancelBtn.remove();
    }

    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// ยืนยันการยกเลิกแบบ Confirm Box สำรอง (เผื่อใช้กรณีไม่ผ่าน Modal)
function confirmCancel(bookingId) {
    if (confirm('ต้องการยกเลิกการจองนี้ใช่หรือไม่?')) {
        const baseUrl = (typeof contextPath !== 'undefined') ? contextPath : '';
        window.location.href = baseUrl + '/booking/cancel/' + bookingId;
    }
}