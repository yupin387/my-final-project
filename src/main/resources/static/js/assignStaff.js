// ===== Dropdown =====
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        document.getElementById('dropdownMenu').classList.remove('show');
    }
});

// ===== Select2 + วันที่ =====
$(document).ready(function () {
    // ตั้งวันที่วันนี้อัตโนมัติ
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('assignDate').value = today;

    // Select2 ค้นหาหัวหน้างาน
    $('#staff-select').select2({
        placeholder: "-- พิมพ์ชื่อเพื่อค้นหา --",
        allowClear: true
    });
});