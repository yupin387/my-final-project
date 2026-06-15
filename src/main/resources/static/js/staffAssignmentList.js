// ===== ฟังก์ชันจัดการการเปิด-ปิดเมนู Dropdown และปิดอัตโนมัติเมื่อคลิกพื้นที่อื่นภายนอก =====
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }
});

// ซ่อน flash banner อัตโนมัติหลัง 3 วินาที
setTimeout(function() {
    const banners = document.querySelectorAll('.flash-banner');
    banners.forEach(function(el) {
        el.style.transition = 'opacity 0.5s ease';
        el.style.opacity = '0';
        setTimeout(() => el.remove(), 500);
    });
}, 3000);