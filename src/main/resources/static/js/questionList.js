// ===== ฟังก์ชันแสดง SweetAlert2 ยืนยันการลบคำถาม =====
function confirmDelete(id, text) {
    Swal.fire({
        title: 'ยืนยันการลบข้อมูล',
        html: `
            <div style="font-size: 13.5px; color: #8C7480; margin-bottom: 12px;">คุณแน่ใจหรือไม่ว่าต้องการลบคำถามนี้ออกจากระบบ?</div>
            <div class="swal-name-box">
                ${text}
            </div>
            <div style="font-size: 12px; color: #A08C95; margin-top: 10px;">การลบนี้ไม่สามารถย้อนกลับได้</div>
        `,
        icon: false,
        showCancelButton: true,
        confirmButtonText: 'ลบข้อมูล',
        cancelButtonText: 'ยกเลิก',
        reverseButtons: true, // สลับเอาปุ่มยกเลิกไว้ฝั่งซ้าย
        width: '420px',
        customClass: {
            popup: 'my-rounded-popup',
            confirmButton: 'swal-btn-confirm-delete',
            cancelButton: 'swal-btn-cancel-custom'
        },
        buttonsStyling: false
    }).then((result) => {
        if (result.isConfirmed) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = contextPath + '/organizer/questions/delete/' + id;
            document.body.appendChild(form);
            form.submit();
        }
    });
}

// ===== Dropdown User Info =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) {
        menu.classList.toggle('show');
    }
}

document.addEventListener('click', function(e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (menu && userInfo && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});