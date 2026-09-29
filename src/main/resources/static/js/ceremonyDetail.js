// ===== Navbar scroll shadow =====
window.addEventListener('scroll', function () {
    const navbar = document.querySelector('.navbar-custom, .cd-navbar');
    if (!navbar) return;
    navbar.style.boxShadow = window.scrollY > 10
        ? '0 4px 20px rgba(0,0,0,0.25)'
        : 'none';
});

// ===== เปิด/ปิดรายละเอียดแพ็กเกจ =====
function toggleDetail(id, btn) {
    const el = document.getElementById('detail-' + id);
    if (!el) return;
    el.classList.toggle('cd-detail-collapsed');
    btn.textContent = el.classList.contains('cd-detail-collapsed')
        ? 'ดูรายละเอียดแพ็กเกจนี้ ▾'
        : 'ซ่อนรายละเอียด ▴';
}

document.addEventListener('DOMContentLoaded', function () {

    // ปุ่มดูรายละเอียดแพ็กเกจ (event delegation)
    document.addEventListener('click', function (e) {
        const btn = e.target.closest('.cd-btn-view-detail');
        if (btn) {
            toggleDetail(btn.dataset.packageId, btn);
        }
    });

    // เปิด/ปิด dropdown เมนูโปรไฟล์
    const pill = document.querySelector('.user-profile-pill');
    const menu = document.getElementById('dropdownMenu');
    if (pill && menu) {
        pill.addEventListener('click', function (e) {
            e.stopPropagation();
            menu.classList.toggle('show');
        });
        document.addEventListener('click', function () {
            menu.classList.remove('show');
        });
    }
});