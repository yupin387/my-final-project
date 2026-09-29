// ฟังก์ชันสลับการแสดง/ซ่อนรหัสผ่าน
function togglePasswordVisibility() {
    const passwordInput = document.getElementById('password');
    const eyeIcon = document.getElementById('eyeIcon');
    if (!passwordInput || !eyeIcon) return;

    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        eyeIcon.classList.remove('bi-eye-slash');
        eyeIcon.classList.add('bi-eye');        // ตาเปิด
    } else {
        passwordInput.type = 'password';
        eyeIcon.classList.remove('bi-eye');
        eyeIcon.classList.add('bi-eye-slash');  // ตาปิด
    }
}

// แสดง/ล้างข้อความ error ใต้ช่องกรอก
function setFieldError(el, message) {
    el.textContent = message;
    el.style.display = message ? 'block' : 'none';
}

function validateLoginForm() {
    const emailInput = document.getElementById('email').value.trim();
    const passwordInput = document.getElementById('password').value;

    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');

    // เคลียร์ข้อความแจ้งเตือนเดิมก่อนตรวจสอบ
    setFieldError(emailError, '');
    setFieldError(passwordError, '');

    let isValid = true;

    // --- 1. ตรวจสอบอีเมล ---
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const hasNumberInEmail = /\d/.test(emailInput);

    if (emailInput === '') {
        setFieldError(emailError, 'กรุณากรอกอีเมล');
        isValid = false;
    } else if (/\s/.test(emailInput)) {
        setFieldError(emailError, 'อีเมลต้องไม่มีช่องว่าง');
        isValid = false;
    } else if (!emailRegex.test(emailInput) || !hasNumberInEmail) {
        setFieldError(emailError, 'อีเมลต้องประกอบด้วยตัวอักษรภาษาอังกฤษ ตัวเลข และอักขระพิเศษที่ถูกต้อง(@, .)');
        isValid = false;
    }

    // --- 2. ตรวจสอบรหัสผ่าน ---
    const passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$/;

    if (passwordInput === '') {
        setFieldError(passwordError, 'กรุณากรอกรหัสผ่าน');
        isValid = false;
    } else if (/\s/.test(passwordInput)) {
        setFieldError(passwordError, 'รหัสผ่านต้องไม่มีเว้นวรรค หรือช่องว่าง');
        isValid = false;
    } else if (passwordInput.length < 8 || passwordInput.length > 16) {
        setFieldError(passwordError, 'รหัสผ่านต้องมีความยาวตั้งแต่ 8 ตัวอักษร และไม่เกิน 16 ตัวอักษร');
        isValid = false;
    } else if (!passwordRegex.test(passwordInput)) {
        setFieldError(passwordError, 'ต้องเป็นตัวอักษรภาษาอังกฤษหรือตัวเลข รวมอักขระพิเศษได้เท่านั้น');
        isValid = false;
    }

    return isValid;
}

// ผูก event (แทน onsubmit / onclick inline ใน JSP)
document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('form-login');
    if (form) {
        form.addEventListener('submit', function (e) {
            if (!validateLoginForm()) e.preventDefault();
        });
    }

    const toggleBtn = document.getElementById('togglePasswordBtn');
    if (toggleBtn) {
        toggleBtn.addEventListener('click', togglePasswordVisibility);
    }
});