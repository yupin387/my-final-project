// ฟังก์ชันสำหรับเปิด-ปิดเมนู Dropdown
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

// Event Listener สำหรับปิด Dropdown เมื่อคลิกพื้นที่อื่น
document.addEventListener('click', function(e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (userInfo && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ฟังก์ชันสำหรับเปิด-ปิดการมองเห็นรหัสผ่าน
function togglePassword(inputId, iconId) {
    const input = document.getElementById(inputId);
    const eyeIcon = document.getElementById(iconId);
    if (!input || !eyeIcon) return;

    if (input.type === 'password') {
        input.type = 'text';
        eyeIcon.classList.remove('bi-eye-slash');
        eyeIcon.classList.add('bi-eye');
    } else {
        input.type = 'password';
        eyeIcon.classList.remove('bi-eye');
        eyeIcon.classList.add('bi-eye-slash');
    }
}

// IIFE สำหรับจัดการฟอร์ม
(function () {
    'use strict';

    const form = document.querySelector('.form-section');
    if (!form) return;

    form.addEventListener('submit', function (e) {
        clearErrors();
        let valid = true;

        const firstName = document.getElementById('firstName');
        const lastName  = document.getElementById('lastName');
        const email     = document.getElementById('email');
        const password  = document.getElementById('password');
        const phone     = document.getElementById('phone');

        // --- ชื่อ ---
        const nameRegex = /^[a-zA-Zก-๏]+$/;
        if (!firstName.value.trim()) {
            showError(firstName, 'กรุณากรอกชื่อ'); valid = false;
        } else if (!nameRegex.test(firstName.value.trim())) {
            showError(firstName, 'ชื่อต้องเป็นภาษาไทยหรือภาษาอังกฤษเท่านั้น'); valid = false;
        }

        // --- นามสกุล ---
        if (!lastName.value.trim()) {
            showError(lastName, 'กรุณากรอกนามสกุล'); valid = false;
        } else if (!nameRegex.test(lastName.value.trim())) {
            showError(lastName, 'นามสกุลต้องเป็นภาษาไทยหรือภาษาอังกฤษเท่านั้น'); valid = false;
        }

        // --- อีเมล ---
        const emailVal = email.value.trim();
        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        const hasNumberInEmail = /\d/.test(emailVal);

        if (!emailVal) {
            showError(email, 'กรุณากรอกอีเมล'); valid = false;
        } else if (/\s/.test(emailVal)) {
            showError(email, 'อีเมลต้องไม่มีช่องว่าง'); valid = false;
        } else if (!emailPattern.test(emailVal) || !hasNumberInEmail) {
            showError(email, 'อีเมลต้องประกอบด้วยตัวอักษรภาษาอังกฤษ ตัวเลข และอักขระพิเศษที่ถูกต้อง(@, .)'); valid = false;
        }

        // --- รหัสผ่าน ---
        const passwordVal = password.value;
        const passwordPattern = /^[a-zA-Z0-9]+$/;

        if (!passwordVal) {
            showError(password, 'กรุณากรอกรหัสผ่าน'); valid = false;
        } else if (passwordVal.length < 8 || !passwordPattern.test(passwordVal)) {
            showError(password, 'รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร และประกอบด้วยตัวอักษรภาษาอังกฤษหรือตัวเลขเท่านั้น'); valid = false;
        }

        // --- เบอร์โทรศัพท์ ---
        const phonePattern = /^0[0-9]{9}$/;
        if (!phone.value.trim()) {
            showError(phone, 'กรุณากรอกเบอร์โทรศัพท์'); valid = false;
        } else if (!phonePattern.test(phone.value.trim())) {
            showError(phone, 'เบอร์โทรต้องขึ้นต้นด้วย 0 และมี 10 หลัก'); valid = false;
        }

        if (!valid) e.preventDefault();
    });

    // ปรับปรุงฟังก์ชันแสดง Error ให้เช็คจาก element แม่ที่เป็น .form-group หรือ .input-wrapper ได้แม่นยำ
    function showError(input, message) {
        input.style.borderColor = '#c62828';
        const span = document.createElement('span');
        span.className = 'field-error';
        span.textContent = message;
        
        // ค้นหาฟอร์มกรุ๊ปหลักเพื่อเอาข้อความมาไว้ข้างล่างสุดของช่องนั้นๆ โดยเฉพาะ
        const formGroup = input.closest('.form-group');
        formGroup.appendChild(span);
    }

    function clearErrors() {
        document.querySelectorAll('.field-error').forEach(el => el.remove());
        document.querySelectorAll('input').forEach(el => { el.style.borderColor = ''; });
    }

    form.querySelectorAll('input').forEach(function (input) {
        input.addEventListener('input', function () {
            this.style.borderColor = '';
            const formGroup = this.closest('.form-group');
            const errSpan = formGroup.querySelector('.field-error');
            if (errSpan) errSpan.remove();
        });
    });
})();