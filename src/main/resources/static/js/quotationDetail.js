// ===== Dropdown User Info =====
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

document.addEventListener('click', function(e) {
    if (!e.target.closest('.user-info')) {
        var menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }
});

document.addEventListener('DOMContentLoaded', function() {
    // ===== ใส่เลขลำดับในตาราง (ข้ามแถวหัวหมวดและแถวรายการในแพ็กเกจ) =====
    var rows = document.querySelectorAll(
        '.standard-table tbody tr:not(.group-row):not(.package-included-row)'
    );
    var count = 1;
    rows.forEach(function(row) {
        var numCell = row.querySelector('.row-number');
        if (numCell) numCell.innerText = count++;
    });

    // ===== ซ่อนแบนเนอร์แจ้งเตือนอัตโนมัติหลัง 5 วินาที =====
    setTimeout(function() {
        var banner = document.getElementById('flashBanner');
        if (banner) banner.style.display = 'none';
    }, 5000);
});