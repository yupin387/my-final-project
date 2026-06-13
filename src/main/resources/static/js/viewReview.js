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