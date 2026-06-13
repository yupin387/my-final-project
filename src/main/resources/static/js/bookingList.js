function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

// ปิด dropdown เมื่อคลิกที่อื่น
document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (userInfo && menu && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});