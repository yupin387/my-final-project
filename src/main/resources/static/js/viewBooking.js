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
    // 1. เพิ่มบรรทัดนี้ เพื่อเปลี่ยนตัวเลขรหัสการจองใน Modal
    if (document.getElementById('cancelBookingId')) {
        document.getElementById('cancelBookingId').textContent = bookingId;
    }

    // โค้ดเดิมของคุณ (ไม่ต้องแก้)
    const baseUrl = (typeof contextPath !== 'undefined') ? contextPath : '';
    const cancelUrl = baseUrl + '/booking/cancel/' + bookingId;

    const confirmBtn = document.getElementById('confirmCancelUrl');
    if (confirmBtn) {
        confirmBtn.setAttribute('href', cancelUrl);
    }

    const cancelModalElement = document.getElementById('cancelModal');
    if (cancelModalElement) {
        const cancelModal = new bootstrap.Modal(cancelModalElement);
        cancelModal.show();
    }
}

// ยืนยันการยกเลิกแบบ Confirm Box สำรอง (เผื่อใช้กรณีไม่ผ่าน Modal)
function confirmCancel(bookingId) {
    if (confirm('ต้องการยกเลิกการจองนี้ใช่หรือไม่?')) {
        const baseUrl = (typeof contextPath !== 'undefined') ? contextPath : '';
        window.location.href = baseUrl + '/booking/cancel/' + bookingId;
    }
}