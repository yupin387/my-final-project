
// เปิด/ปิดเมนู dropdown ของผู้ใช้ที่ navbar
function toggleDropdown() {
    var dd = document.getElementById('dropdownMenu');
    if (dd) dd.classList.toggle('show');
}

// คลิกนอกกล่องผู้ใช้ -> ปิด dropdown
document.addEventListener('click', function (e) {
    if (!e.target.closest('.user-info')) {
        var dd = document.getElementById('dropdownMenu');
        if (dd) dd.classList.remove('show');
    }
});