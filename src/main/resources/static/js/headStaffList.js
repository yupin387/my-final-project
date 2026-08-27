// ===== ฟังก์ชันควบคุมการเปิด-ปิดเมนู Dropdown =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

// ===== ฟังก์ชันปิด Dropdown อัตโนมัติเมื่อคลิกพื้นที่อื่นภายนอก =====
document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (menu && userInfo && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ===== ฟังก์ชันแสดง SweetAlert2 ยืนยันการลบข้อมูลพนักงาน =====
function confirmDelete(staffId, staffName) {
    Swal.fire({
        title: 'ยืนยันการลบข้อมูล',
        html: `
            <div style="font-size: 13.5px; color: #8C7480; margin-bottom: 12px;">คุณต้องการลบข้อมูลนี้ใช่หรือไม่?</div>
            <div class="swal-name-box">
                ${staffName}
            </div>
            <div style="font-size: 12px; color: #A08C95; margin-top: 10px;">การลบนี้ไม่สามารถย้อนกลับได้</div>
        `,
        icon: false,
        showCancelButton: true,
        confirmButtonText: 'ลบข้อมูล',
        cancelButtonText: 'ยกเลิก',
        reverseButtons: true, // <--- สลับเอาปุ่ม Cancel (ยกเลิก) มาไว้ฝั่งซ้าย
        width: '420px',
        customClass: {
            popup: 'my-rounded-popup',
            confirmButton: 'swal-btn-confirm-delete',
            cancelButton: 'swal-btn-cancel-custom'
        },
        buttonsStyling: false
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('deleteForm-' + staffId).submit();
        }
    });
}

// ===== ฟังก์ชันสำรองสำหรับจัดการเมนู Dropdown (ซ้ำกับตัวบน) =====
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}