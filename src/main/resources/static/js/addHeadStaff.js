// ฟังก์ชันสำหรับเปิด-ปิดเมนู Dropdown (ใช้ Class สลับเพื่อแสดงผล)
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

// Event Listener สำหรับปิด Dropdown เมื่อคลิกพื้นที่อื่นที่ไม่ใช่ตัวเมนูเอง
document.addEventListener('click', function(e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (userInfo && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ฟังก์ชันสำหรับเปิด-ปิดการมองเห็นรหัสผ่าน (สลับ Type ระหว่าง password กับ text)
function togglePassword(inputId, btn) {
    const input = document.getElementById(inputId);
    if (!input) return;
    if (input.type === 'password') {
        input.type = 'text';
        btn.textContent = '🙈';
    } else {
        input.type = 'password';
        btn.textContent = '👁';
    }
}

// IIFE (Immediately Invoked Function Expression) เพื่อแยก Scope ของการจัดการฟอร์ม
(function () {
    'use strict';

    const form = document.querySelector('.form-section');
    if (!form) return;

    // ตรวจสอบความถูกต้องของข้อมูลเมื่อผู้ใช้กด Submit ฟอร์ม
    form.addEventListener('submit', function (e) {
        clearErrors();
        let valid = true;

        const firstName = document.getElementById('firstName');
        const lastName  = document.getElementById('lastName');
        const email     = document.getElementById('email');
        const password  = document.getElementById('password');
        const phone     = document.getElementById('phone');

        // ตรวจสอบชื่อ-นามสกุล (ต้องไม่เป็นค่าว่าง)
        if (!firstName.value.trim()) { showError(firstName, 'กรุณากรอกชื่อ'); valid = false; }
        if (!lastName.value.trim())  { showError(lastName,  'กรุณากรอกนามสกุล'); valid = false; }

        // ตรวจสอบรูปแบบอีเมลด้วย Regex
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.value.trim()) {
            showError(email, 'กรุณากรอกอีเมล'); valid = false;
        } else if (!emailPattern.test(email.value.trim())) {
            showError(email, 'รูปแบบอีเมลไม่ถูกต้อง'); valid = false;
        }

        // ตรวจสอบเงื่อนไขรหัสผ่าน (8-16 ตัวอักษร)
        if (!password.value) {
            showError(password, 'กรุณากรอกรหัสผ่าน'); valid = false;
        } else if (password.value.length < 8 || password.value.length > 16) {
            showError(password, 'รหัสผ่านต้องมี 8-16 ตัวอักษร'); valid = false;
        }

        // ตรวจสอบเบอร์โทรศัพท์ (ขึ้นต้นด้วย 0 และมี 10 หลัก)
        const phonePattern = /^0[0-9]{9}$/;
        if (!phone.value.trim()) {
            showError(phone, 'กรุณากรอกเบอร์โทรศัพท์'); valid = false;
        } else if (!phonePattern.test(phone.value.trim())) {
            showError(phone, 'เบอร์โทรต้องขึ้นต้นด้วย 0 และมี 10 หลัก'); valid = false;
        }

        // ถ้าข้อมูลไม่ถูกต้อง ให้หยุดการ Submit ฟอร์ม
        if (!valid) e.preventDefault();
    });

    // ฟังก์ชันแสดง Error ที่ช่อง input
    function showError(input, message) {
        input.style.borderColor = '#c62828'; // เปลี่ยนสีขอบเป็นสีแดง
        const span = document.createElement('span');
        span.className = 'field-error';
        span.textContent = message;
        const parent = input.closest('.input-wrapper') || input.parentElement;
        parent.insertAdjacentElement('afterend', span);
    }

    // ฟังก์ชันล้างข้อความ Error ทั้งหมดในฟอร์ม
    function clearErrors() {
        document.querySelectorAll('.field-error').forEach(el => el.remove());
        document.querySelectorAll('input').forEach(el => { el.style.borderColor = ''; });
    }

    // ล้าง Error ทันทีที่ผู้ใช้เริ่มพิมพ์ในช่องนั้นๆ (Real-time Validation feedback)
    form.querySelectorAll('input').forEach(function (input) {
        input.addEventListener('input', function () {
            this.style.borderColor = '';
            const wrapper = this.closest('.input-wrapper') || this.parentElement;
            const errSpan = wrapper.nextElementSibling;
            if (errSpan && errSpan.classList.contains('field-error')) errSpan.remove();
        });
    });
})();