// ===== Dropdown =====
function toggleDropdown() {
    document.getElementById('dropdownMenu')?.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        document.getElementById('dropdownMenu')?.classList.remove('show');
    }
});

// ===== Dropdown ตัวกรองประเภทงาน (หน้ารีวิว) =====
function toggleCeremonyDropdown(event) {
    if (event) event.stopPropagation();
    document.getElementById('ceremonyDropdownMenu')?.classList.toggle('show');
    event.currentTarget.classList.toggle('menu-open');
}

document.addEventListener('click', function (e) {
    const wrap = document.querySelector('.ceremony-dropdown');
    const menu = document.getElementById('ceremonyDropdownMenu');
    const toggleBtn = document.querySelector('.ceremony-dropdown-toggle');
    if (menu && wrap && !wrap.contains(e.target)) {
        menu.classList.remove('show');
        toggleBtn?.classList.remove('menu-open');
    }
});