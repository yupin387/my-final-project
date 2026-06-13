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
// JSP เรียก openApproveModal() → ต้องมีฟังก์ชันนี้
function openApproveModal(bookingId, approveUrl) {
    document.getElementById('displayBookingId').textContent = 'รหัส: ' + bookingId;
    document.getElementById('confirmApproveLink').href = approveUrl;
    document.getElementById('approveModal').style.display = 'flex';
}

function closeApproveModal() {
    document.getElementById('approveModal').style.display = 'none';
}

function openRejectModal(bookingId, rejectUrl) {
    document.getElementById('displayRejectBookingId').textContent = 'รหัส: ' + bookingId;
    document.getElementById('confirmRejectLink').href = rejectUrl;
    document.getElementById('rejectModal').style.display = 'flex';
}

function closeRejectModal() {
    document.getElementById('rejectModal').style.display = 'none';
}

// ลบอันเดิมออก แล้วใช้อันนี้แทน (รวมทั้งสอง modal)
document.addEventListener('click', function(e) {
    const approveModal = document.getElementById('approveModal');
    if (e.target === approveModal) closeApproveModal();

    const rejectModal = document.getElementById('rejectModal');
    if (e.target === rejectModal) closeRejectModal();
});

