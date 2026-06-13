// ===== ฟังก์ชันสร้างและแสดงแถบแจ้งเตือน (Flash Banner) =====
function showBanner(type, title) {
    const old = document.getElementById('flash-banner');
    if (old) old.remove();

    const banner = document.createElement('div');
    banner.id = 'flash-banner';
    banner.className = `flash-banner ${type}`;
    banner.innerHTML = `<span>${title}</span>`;

    const pageWrapper = document.querySelector('.page-wrapper');
    if (pageWrapper) {
        document.body.insertBefore(banner, pageWrapper);
    } else {
        document.body.prepend(banner);
    }
}

// ===== ฟังก์ชันจัดการ Modal ยืนยันการลบข้อมูล =====
let _pendingForm = null;

function showDeleteModal(formEl) {
    _pendingForm = formEl;
    document.getElementById('confirmModal').classList.add('show');
}

function closeModal() {
    document.getElementById('confirmModal').classList.remove('show');
    _pendingForm = null;
}

function confirmDelete() {
    if (_pendingForm) {
        _pendingForm.submit();
    }
    closeModal();
}

// ===== ฟังก์ชันจัดการเมนู Dropdown =====
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

// ===== Event Listener สำหรับปิด Dropdown และ Modal เมื่อคลิกพื้นที่อื่นภายนอก =====
document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }

    const overlay = document.getElementById('confirmModal');
    if (e.target === overlay) closeModal();
});

// ===== ฟังก์ชันแสดง Banner แจ้งเตือนอัตโนมัติเมื่อโหลดหน้าเว็บ (จาก Flash Attribute) =====
document.addEventListener('DOMContentLoaded', function () {
    const successEl = document.getElementById('flash-success');
    const errorEl   = document.getElementById('flash-error');

    if (successEl && successEl.dataset.msg) {
        const msg = successEl.dataset.msg;
        let title = 'ดำเนินการสำเร็จ';

        if (msg.includes('ลบ'))          title = 'ลบข้อมูลเรียบร้อยแล้ว';
        else if (msg.includes('แก้ไข'))  title = 'แก้ไขข้อมูลเรียบร้อยแล้ว';
        else if (msg.includes('เพิ่ม'))  title = 'เพิ่มข้อมูลเรียบร้อยแล้ว';
        else if (msg.includes('บันทึก')) title = 'บันทึกข้อมูลเรียบร้อยแล้ว';

        showBanner('success', title);
    }

    if (errorEl && errorEl.dataset.msg) {
        showBanner('error', errorEl.dataset.msg);
    }
});