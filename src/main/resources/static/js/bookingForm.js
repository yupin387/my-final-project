// ===== Dropdown Toggle =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const wrap = document.querySelector('.dropdown-wrap');
    const menu = document.getElementById('dropdownMenu');
    if (menu && wrap && !wrap.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ===== Auto-fill วันที่กรอกแบบฟอร์ม =====
document.addEventListener('DOMContentLoaded', function () {
    const display = document.getElementById('bookingDateDisplay');
    const hidden  = document.getElementById('bookingDateHidden');
    if (!display || !hidden) return;

    const now = new Date();

    // สำหรับ hidden (ส่ง backend แบบ yyyy-MM-dd)
    const yyyy = now.getFullYear();
    const mm   = String(now.getMonth() + 1).padStart(2, '0');
    const dd   = String(now.getDate()).padStart(2, '0');
    hidden.value = `${yyyy}-${mm}-${dd}`;

    // สำหรับแสดงผลแบบไทย dd/MM/yyyy
    display.value = `${dd}/${mm}/${yyyy}`;
});