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