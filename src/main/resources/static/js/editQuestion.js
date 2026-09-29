// เปิด/ปิด dropdown เมนูผู้ใช้
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) menu.classList.toggle('show');
}

// คลิกนอกเมนูแล้วปิด
document.addEventListener('click', function (e) {
    if (!e.target.closest('.user-info')) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }
});

// ปุ่มยกเลิก: กลับหน้ารายการคำถาม
document.addEventListener('DOMContentLoaded', function () {
    const cancelBtn = document.querySelector('.btn-cancel');
    if (cancelBtn) {
        cancelBtn.addEventListener('click', function () {
            window.location.href = cancelBtn.dataset.href;
        });
    }
});