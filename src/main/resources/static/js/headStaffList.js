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
        html: `ต้องการลบ <strong>${staffName}</strong> ออกจากระบบ?<br><span style="font-size:13px;color:#999;">การลบนี้ไม่สามารถย้อนกลับได้</span>`,
        icon: false,
        showCancelButton: true,
        confirmButtonText: 'ลบข้อมูล',
        cancelButtonText: 'ยกเลิก',
        width: '520px',
        customClass: {
            popup: 'my-rounded-popup',
            confirmButton: 'swal-btn-confirm',
            cancelButton: 'swal-btn-cancel'
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