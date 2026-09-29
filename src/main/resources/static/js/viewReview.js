// หมายเหตุ: ไฟล์นี้ต้องโหลดท้าย <body> (หลัง HTML) เพราะมีการผูก event กับ element ตอนโหลดไฟล์

// ===== Dropdown เมนูใน Navbar (บริการ/แพ็กเกจ, ปฏิทิน) =====
document.querySelectorAll('.nav-dropdown-toggle').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
        e.stopPropagation();
        var dropdown = btn.closest('.nav-dropdown');
        document.querySelectorAll('.nav-dropdown.show').forEach(function (d) {
            if (d !== dropdown) d.classList.remove('show');
        });
        dropdown.classList.toggle('show');
    });
});
document.addEventListener('click', function () {
    document.querySelectorAll('.nav-dropdown.show').forEach(function (d) {
        d.classList.remove('show');
    });
});

// ===== Lightbox คลิกขยายภาพรีวิว =====
function openReviewImageLightbox(src) {
    const overlay = document.getElementById('reviewImageLightbox');
    const img = document.getElementById('reviewImageLightboxImg');
    if (!overlay || !img) return;
    img.src = src;
    overlay.classList.add('show');
}

function closeReviewImageLightbox() {
    const overlay = document.getElementById('reviewImageLightbox');
    if (overlay) overlay.classList.remove('show');
}

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeReviewImageLightbox();
});

// กันไม่ให้คลิกบนรูปในกล่อง lightbox แล้วปิดตัวเอง (ต้องคลิกพื้นหลังหรือปุ่ม × เท่านั้น)
document.getElementById('reviewImageLightboxImg')?.addEventListener('click', function (e) {
    e.stopPropagation();
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