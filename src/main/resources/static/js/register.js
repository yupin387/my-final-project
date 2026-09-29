// ===== สลับการแสดง/ซ่อนรหัสผ่าน =====
function togglePassword(fieldId, iconId) {
    const inputField = document.getElementById(fieldId);
    const eyeIcon = document.getElementById(iconId);
    if (inputField.type === 'password') {
        inputField.type = 'text';
        eyeIcon.classList.remove('bi-eye-slash');
        eyeIcon.classList.add('bi-eye');
    } else {
        inputField.type = 'password';
        eyeIcon.classList.remove('bi-eye');
        eyeIcon.classList.add('bi-eye-slash');
    }
}

// ===== ตรวจสอบเงื่อนไขทั้งหมดของฟอร์มสมัครสมาชิก =====
function validateRegisterForm() {
    const firstName = document.getElementById('memberFirstName').value.trim();
    const lastName = document.getElementById('memberLastName').value.trim();
    const phone = document.getElementById('phoneNumber').value.trim();
    const email = document.getElementById('memberEmail').value.trim();
    const password = document.getElementById('memberPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    const firstNameError = document.getElementById('firstNameError');
    const lastNameError = document.getElementById('lastNameError');
    const phoneError = document.getElementById('phoneError');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    const confirmError = document.getElementById('confirmError');

    // เคลียร์ค่า error ทั้งหมดก่อน
    [firstNameError, lastNameError, phoneError, emailError, passwordError, confirmError].forEach(el => {
        el.style.display = 'none';
        el.innerHTML = '';
    });

    let isValid = true;

    // 1. ตรวจสอบชื่อ (memberfirstname)
    const nameRegex = /^[a-zA-Zก-๙\s]+$/;
    if (firstName === "") {
        firstNameError.innerHTML = "กรุณากรอกชื่อ";
        firstNameError.style.display = 'block';
        isValid = false;
    } else if (!nameRegex.test(firstName) || /\d/.test(firstName)) {
        firstNameError.innerHTML = "ชื่อต้องเป็นตัวอักษรภาษาไทยหรือภาษาอังกฤษเท่านั้น";
        firstNameError.style.display = 'block';
        isValid = false;
    } else if (firstName.length < 2 || firstName.length > 100) {
        firstNameError.innerHTML = "ชื่อต้องมีความยาวไม่น้อยกว่า 2 ตัวอักษร และไม่เกิน 100 ตัวอักษร";
        firstNameError.style.display = 'block';
        isValid = false;
    }

    // 2. ตรวจสอบนามสกุล (memberlastname)
    if (lastName === "") {
        lastNameError.innerHTML = "กรุณากรอกนามสกุล";
        lastNameError.style.display = 'block';
        isValid = false;
    } else if (!nameRegex.test(lastName) || /\d/.test(lastName)) {
        lastNameError.innerHTML = "นามสกุลต้องเป็นตัวอักษรภาษาไทยหรือภาษาอังกฤษเท่านั้น";
        lastNameError.style.display = 'block';
        isValid = false;
    }

    // 3. ตรวจสอบเบอร์โทรศัพท์ (phonenumber)
    const phoneRegex = /^0\d{9}$/;
    if (phone === "") {
        phoneError.innerHTML = "กรุณากรอกเบอร์โทรศัพท์";
        phoneError.style.display = 'block';
        isValid = false;
    } else if (/\s/.test(phone)) {
        phoneError.innerHTML = "เบอร์โทรศัพท์ต้องไม่มีช่องว่าง";
        phoneError.style.display = 'block';
        isValid = false;
    } else if (!phoneRegex.test(phone)) {
        phoneError.innerHTML = "เบอร์โทรศัพท์ต้องเป็นตัวเลข 10 หลัก และขึ้นต้นด้วยเลข 0 เท่านั้น";
        phoneError.style.display = 'block';
        isValid = false;
    }

    // 4. ตรวจสอบอีเมล (memberemail)
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const hasNumberInEmail = /\d/.test(email);
    if (email === "") {
        emailError.innerHTML = "กรุณากรอกอีเมล";
        emailError.style.display = 'block';
        isValid = false;
    } else if (/\s/.test(email)) {
        emailError.innerHTML = "อีเมลต้องไม่มีช่องว่าง";
        emailError.style.display = 'block';
        isValid = false;
    } else if (!emailRegex.test(email) || !hasNumberInEmail) {
        emailError.innerHTML = "อีเมลต้องมีรูปแบบที่ถูกต้อง และต้องประกอบด้วยตัวอักษรภาษาอังกฤษ ตัวเลข และอักขระพิเศษ (@, .)";
        emailError.style.display = 'block';
        isValid = false;
    }

    // 5. ตรวจสอบรหัสผ่าน (memberpassword)
    const passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$/;
    if (password === "") {
        passwordError.innerHTML = "กรุณากรอกรหัสผ่าน";
        passwordError.style.display = 'block';
        isValid = false;
    } else if (/\s/.test(password)) {
        passwordError.innerHTML = "รหัสผ่านต้องไม่มีเว้นวรรค หรือช่องว่าง";
        passwordError.style.display = 'block';
        isValid = false;
    } else if (password.length < 8 || password.length > 16) {
        passwordError.innerHTML = "รหัสผ่านต้องมีความยาวตั้งแต่ 8 ตัวอักษร และไม่เกิน 16 ตัวอักษร";
        passwordError.style.display = 'block';
        isValid = false;
    } else if (!passwordRegex.test(password)) {
        passwordError.innerHTML = "รหัสผ่านต้องเป็นตัวอักษรภาษาอังกฤษหรือตัวเลข รวมอักขระพิเศษได้เท่านั้น";
        passwordError.style.display = 'block';
        isValid = false;
    }

    // 6. ตรวจสอบยืนยันรหัสผ่าน
    if (confirmPassword === "") {
        confirmError.innerHTML = "กรุณายืนยันรหัสผ่าน";
        confirmError.style.display = 'block';
        isValid = false;
    } else if (password !== confirmPassword) {
        confirmError.innerHTML = "รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน";
        confirmError.style.display = 'block';
        isValid = false;
    }

    return isValid;
}