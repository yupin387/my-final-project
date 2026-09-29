// ===== ฟังก์ชันสร้างและแสดงแถบแจ้งเตือน (Flash Banner) =====
function showBanner(type, title) {
    const old = document.getElementById('flash-banner');
    if (old) old.remove();

    const banner = document.createElement('div');
    banner.id = 'flash-banner';
    // class ต้องตรงกับ CSS: .flash-banner-success / .flash-banner-error
    banner.className = `flash-banner flash-banner-${type}`;

    const span = document.createElement('span');
    span.textContent = title;   // ใช้ textContent กัน HTML injection
    banner.appendChild(span);

    const pageWrapper = document.querySelector('.page-wrapper');
    if (pageWrapper) {
        document.body.insertBefore(banner, pageWrapper);
    } else {
        document.body.prepend(banner);
    }
}

// ===== Modal ยืนยันการลบข้อมูล =====
let _pendingForm = null;

function showDeleteModal(formEl) {
    _pendingForm = formEl;

    const nameEl = document.getElementById('modalItemName');
    if (nameEl) nameEl.textContent = formEl.dataset.itemName || '';

    const modal = document.getElementById('confirmModal');
    if (modal) modal.classList.add('show');
}

function closeModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) modal.classList.remove('show');
    _pendingForm = null;
}

function confirmDelete() {
    if (_pendingForm) _pendingForm.submit();
    closeModal();
}

// ===== Dropdown เมนูผู้ใช้ =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) menu.classList.toggle('show');
}

// ===== ตัวกรอง: เปิด/ปิด dropdown แบบเดียวกับหน้ารายการจอง =====
function closeAllFilters() {
    document.querySelectorAll('.status-filter-dropdown.show').forEach(function (el) {
        el.classList.remove('show');
    });
    document.querySelectorAll('.status-filter-arrow').forEach(function (el) {
        el.textContent = '▾';
    });
}

function toggleFilter(dropdownId, arrowId) {
    const dropdown = document.getElementById(dropdownId);
    const arrow = document.getElementById(arrowId);
    if (!dropdown) return;

    const isOpen = dropdown.classList.contains('show');

    // ปิดตัวกรองอื่นก่อนเสมอ กันเปิดซ้อนกัน
    closeAllFilters();

    if (!isOpen) {
        dropdown.classList.add('show');
        if (arrow) arrow.textContent = '▴';
    }
}

// ===== listener เดียวรวมทุกอย่าง: คลิกนอกพื้นที่แล้วปิด dropdown / filter / modal =====
document.addEventListener('click', function (e) {
    // เมนูผู้ใช้
    if (!e.target.closest('.user-info')) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }

    // ตัวกรอง
    if (!e.target.closest('.status-filter-group')) {
        closeAllFilters();
    }

    // คลิกพื้นหลัง modal
    if (e.target === document.getElementById('confirmModal')) {
        closeModal();
    }
});

// ===== แสดง Banner อัตโนมัติเมื่อโหลดหน้า (จาก Flash Attribute) =====
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