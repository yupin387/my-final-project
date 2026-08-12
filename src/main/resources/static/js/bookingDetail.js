// ===== Dropdown Toggle =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (menu && userInfo && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ===== Modal Functions =====
function openApproveModal(bookingId, approveUrl) {
    document.getElementById('displayBookingId').textContent = 'รหัส: ' + bookingId;
    document.getElementById('confirmApproveLink').href = approveUrl;
    document.getElementById('approveModal').style.display = 'flex';
}

function closeApproveModal() {
    document.getElementById('approveModal').style.display = 'none';
}

// ลบ openRejectModal อันเก่าทิ้งทั้งหมด แล้วใช้อันนี้แทน
function openRejectModal(bookingId, actionUrl) {
    // แสดงรหัสการจอง
    document.getElementById('displayRejectBookingId').innerText = bookingId;
    
    // เซ็ต URL ให้กับ Form (สำคัญ: id ของฟอร์มต้องตรงกับใน jsp)
    document.getElementById('rejectForm').action = actionUrl;
    
    // เคลียร์ข้อความเก่า (ถ้ามี)
    document.getElementById('rejectDetail').value = '';
    
    // แสดง Modal
    document.getElementById('rejectModal').style.display = 'flex';
}

function closeRejectModal() {
    document.getElementById('rejectModal').style.display = 'none';
}

// กดพื้นที่ว่างเพื่อปิด Modal
document.addEventListener('click', function(e) {
    const approveModal = document.getElementById('approveModal');
    if (e.target === approveModal) closeApproveModal();

    const rejectModal = document.getElementById('rejectModal');
    if (e.target === rejectModal) closeRejectModal();
});