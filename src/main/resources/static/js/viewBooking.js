// ===== Dropdown Toggle =====
function toggleDropdown() {
    event.stopPropagation(); // สำคัญมาก เพื่อป้องกันไม่ให้คลิกซ้ำซ้อนกับโค้ดด้านล่าง
    const menu = document.getElementById('dropdownMenu');
    if (menu) {
        menu.classList.toggle('show');
    }
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (menu && menu.classList.contains('show')) {
        if (userInfo && !userInfo.contains(e.target) && !menu.contains(e.target)) {
            menu.classList.remove('show');
        }
    }
});

function confirmCancel(bookingId) {
    if (confirm('ต้องการยกเลิกการจองนี้ใช่หรือไม่?')) {
        window.location.href = contextPath + '/booking/cancel/' + bookingId;
    }
}

// ===== Cancel Modal =====
function showCancelModal(bookingId) {
    // ใช้ contextPath ที่ส่งมาจาก JSP แทน EL syntax
    const cancelUrl = contextPath + '/booking/cancel/' + bookingId;
    document.getElementById('confirmCancelUrl').setAttribute('href', cancelUrl);
    var myModal = new bootstrap.Modal(document.getElementById('cancelModal'));
    myModal.show();
}