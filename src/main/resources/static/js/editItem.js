// ===== Dropdown =====

// ฟังก์ชันสำหรับเปิด-ปิดเมนู Dropdown โดยการสลับ Class 'show'
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

// Event Listener สำหรับปิด Dropdown อัตโนมัติเมื่อคลิกพื้นที่อื่นนอกเหนือจาก .user-info
document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }
});

// ===== Flash Banner =====

// ฟังก์ชันสร้างและแสดงแถบ Banner แจ้งเตือน (Flash Message)
// type: 'success' หรือ 'error', title: ข้อความที่ต้องการแสดง
function showBanner(type, title) {
    // ลบ Banner อันเก่าออกก่อน (ถ้ามี) เพื่อไม่ให้ซ้อนกัน
    const old = document.getElementById('flash-banner');
    if (old) old.remove();

    // สร้าง Element ของ Banner ใหม่
    const banner = document.createElement('div');
    banner.id = 'flash-banner';
    banner.className = `flash-banner ${type}`;
    banner.innerHTML = `<span>${title}</span>`;

    // แทรก Banner ไว้ที่ส่วนบนสุดของเนื้อหาในหน้าเพจ
    const pageWrapper = document.querySelector('.page-wrapper');
    if (pageWrapper) {
        document.body.insertBefore(banner, pageWrapper);
    } else {
        document.body.prepend(banner);
    }
}

// ตรวจสอบข้อความแจ้งเตือนจาก Attribute เมื่อโหลดหน้าเว็บเสร็จสมบูรณ์ (DOMContentLoaded)
document.addEventListener('DOMContentLoaded', function () {
    const successEl = document.getElementById('flash-success');
    const errorEl   = document.getElementById('flash-error');

    // ตรวจสอบและแสดงข้อความแจ้งเตือนความสำเร็จ (Success)
    if (successEl && successEl.dataset.msg) {
        const msg = successEl.dataset.msg;
        let title = 'ดำเนินการสำเร็จ'; // ข้อความตั้งต้น

        // ปรับเปลี่ยนข้อความ Title ตามเนื้อหาของข้อความที่ส่งมา
        if (msg.includes('แก้ไข'))       title = 'แก้ไขข้อมูลเรียบร้อยแล้ว';
        else if (msg.includes('บันทึก')) title = 'บันทึกข้อมูลเรียบร้อยแล้ว';

        showBanner('success', title);
    }

    // ตรวจสอบและแสดงข้อความแจ้งเตือนข้อผิดพลาด (Error)
    if (errorEl && errorEl.dataset.msg) {
        showBanner('error', errorEl.dataset.msg);
    }
});