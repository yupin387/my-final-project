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

// ===== แต่งสี option ใน select2: เขียวเข้ม = ว่าง, แดงเข้ม = มีงานค้าง =====
function formatStaffOption(opt) {
    if (!opt.id) return opt.text;
    var workload = $(opt.element).data('workload');
    var $el = $('<span></span>').text(opt.text);
    if (workload > 0) {
        $el.css('color', '#8B0000'); // แดงเข้ม (dark red)
    } else {
        $el.css('color', '#1B5E20'); // เขียวเข้ม (dark green)
    }
    return $el;
}

// ===== Select2 + วันที่ =====
$(document).ready(function () {
    // ตั้งวันที่วันนี้อัตโนมัติ
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('assignDate').value = today;

    // Select2 ค้นหาหัวหน้างาน (พร้อมแต่งสีตามสถานะว่าง/มีงานค้าง)
    $('#staff-select').select2({
        placeholder: "-- พิมพ์ชื่อเพื่อค้นหา --",
        allowClear: true,
        templateResult: formatStaffOption,
        templateSelection: formatStaffOption
    });
});