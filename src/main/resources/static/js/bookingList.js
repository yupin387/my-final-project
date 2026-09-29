// ===== bookingList.js =====
// ใช้ร่วมกันทั้งหน้า "จัดการรายการจอง" (มอบหมายงาน) และหน้า "รายการจองใหม่"

// เปิด/ปิดเมนูกรองสถานะการจอง
function toggleStatusFilter() {
    const dropdown = document.getElementById('statusFilterDropdown');
    const arrow = document.getElementById('statusFilterArrow');
    if (!dropdown) return;

    dropdown.classList.toggle('show');
    if (arrow) arrow.textContent = dropdown.classList.contains('show') ? '▴' : '▾';
}

// เปิด/ปิดเมนูผู้ใช้ (มุมขวาบน)
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) menu.classList.toggle('show');
}

// ปิด dropdown ทั้งสองอันเมื่อคลิกที่อื่น
document.addEventListener('click', function (e) {
    // เมนูกรองสถานะ
    if (!e.target.closest('.status-filter-wrapper')) {
        const dropdown = document.getElementById('statusFilterDropdown');
        const arrow = document.getElementById('statusFilterArrow');
        if (dropdown) dropdown.classList.remove('show');
        if (arrow) arrow.textContent = '▾';
    }

    // เมนูผู้ใช้
    if (!e.target.closest('.user-info')) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }
});