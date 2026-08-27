// ===== Dropdown =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) {
        menu.classList.toggle('show');
    }
}

document.addEventListener('click', function (e) {
    const profileDropdown = document.getElementById('profileDropdown');
    const dropdownMenu = document.getElementById('dropdownMenu');

    if (profileDropdown && !profileDropdown.contains(e.target)) {
        if (dropdownMenu) {
            dropdownMenu.classList.remove('show');
        }
    }
});

// ===== Event Listener ผูกการตรวจสอบฟอร์มแบบตรง =====
document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('editProfileForm');

    if (form) {
        form.addEventListener('submit', function (e) {
            // เรียกฟังก์ชันตรวจถ้าไม่ผ่าน ให้หยุดการ submit ทันที
            if (!validateEditProfileForm()) {
                e.preventDefault(); // บล็อกไม่ให้ส่งฟอร์มไป Backend
                return false;
            }
        });
    }

    // Flash Banner
    const successEl = document.getElementById('flash-success');
    const errorEl   = document.getElementById('flash-error');
    if (successEl?.dataset.msg) showBanner('success', successEl.dataset.msg);
    if (errorEl?.dataset.msg)   showBanner('error',   errorEl.dataset.msg);
});

// ===== Form Validation Function =====
function validateEditProfileForm() {
    const firstNameEl = document.getElementById('memberFirstName');
    const lastNameEl  = document.getElementById('memberLastName');
    const phoneEl     = document.getElementById('phoneNumber');
    const newPassEl   = document.getElementById('newPassword');
    const confirmPassEl = document.getElementById('confirmPassword');

    const firstName   = firstNameEl ? firstNameEl.value.trim() : '';
    const lastName    = lastNameEl ? lastNameEl.value.trim() : '';
    const phone       = phoneEl ? phoneEl.value.trim() : '';
    const newPass     = newPassEl ? newPassEl.value : '';
    const confirmPass = confirmPassEl ? confirmPassEl.value : '';

    const firstNameError = document.getElementById('firstNameError');
    const lastNameError  = document.getElementById('lastNameError');
    const phoneError     = document.getElementById('phoneError');
    const passwordError  = document.getElementById('passwordError');
    const confirmError   = document.getElementById('confirmError');

    // เคลียร์ข้อความแจ้งเตือนทั้งหมด
    [firstNameError, lastNameError, phoneError, passwordError, confirmError].forEach(el => {
        if (el) {
            el.innerHTML = '';
        }
    });

    let isValid = true;
    const nameRegex = /^[a-zA-Zก-๙\s]+$/;

    // 1. ตรวจสอบชื่อ
    if (firstName === "") {
        if (firstNameError) firstNameError.innerHTML = "กรุณากรอกชื่อ";
        isValid = false;
    } else if (!nameRegex.test(firstName) || /\d/.test(firstName)) {
        if (firstNameError) firstNameError.innerHTML = "ชื่อต้องเป็นตัวอักษรภาษาไทยหรือภาษาอังกฤษเท่านั้น";
        isValid = false;
    } else if (firstName.length < 2 || firstName.length > 100) {
        if (firstNameError) firstNameError.innerHTML = "ชื่อต้องมีความยาวไม่น้อยกว่า 2 ตัวอักษร และไม่เกิน 100 ตัวอักษร";
        isValid = false;
    }

    // 2. ตรวจสอบนามสกุล
    if (lastName === "") {
        if (lastNameError) lastNameError.innerHTML = "กรุณากรอกนามสกุล";
        isValid = false;
    } else if (!nameRegex.test(lastName) || /\d/.test(lastName)) {
        if (lastNameError) lastNameError.innerHTML = "นามสกุลต้องเป็นตัวอักษรภาษาไทยหรือภาษาอังกฤษเท่านั้น";
        isValid = false;
    }

    // 3. ตรวจสอบเบอร์โทรศัพท์
    const phoneRegex = /^0\d{9}$/;
    if (phone === "") {
        if (phoneError) phoneError.innerHTML = "กรุณากรอกเบอร์โทรศัพท์";
        isValid = false;
    } else if (/\s/.test(phone)) {
        if (phoneError) phoneError.innerHTML = "เบอร์โทรศัพท์ต้องไม่มีช่องว่าง";
        isValid = false;
    } else if (!phoneRegex.test(phone)) {
        if (phoneError) phoneError.innerHTML = "เบอร์โทรศัพท์ต้องเป็นตัวเลข 10 หลัก และขึ้นต้นด้วยเลข 0 เท่านั้น";
        isValid = false;
    }

    // 4. ตรวจสอบรหัสผ่านใหม่
    if (newPass !== "") {
        const passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$/;
        if (/\s/.test(newPass)) {
            if (passwordError) passwordError.innerHTML = "รหัสผ่านต้องไม่มีเว้นวรรค หรือช่องว่าง";
            isValid = false;
        } else if (newPass.length < 8 || newPass.length > 16) {
            if (passwordError) passwordError.innerHTML = "รหัสผ่านต้องมีความยาวตั้งแต่ 8 ตัวอักษร และไม่เกิน 16 ตัวอักษร";
            isValid = false;
        } else if (!passwordRegex.test(newPass)) {
            if (passwordError) passwordError.innerHTML = "รหัสผ่านต้องเป็นตัวอักษรภาษาอังกฤษหรือตัวเลข รวมอักขระพิเศษได้เท่านั้น";
            isValid = false;
        }

        // 5. ตรวจสอบยืนยันรหัสผ่านใหม่
        if (confirmPass === "") {
            if (confirmError) confirmError.innerHTML = "กรุณายืนยันรหัสผ่านใหม่";
            isValid = false;
        } else if (newPass !== confirmPass) {
            if (confirmError) confirmError.innerHTML = "รหัสผ่านใหม่และการยืนยันรหัสผ่านไม่ตรงกัน";
            isValid = false;
        }
    }

    return isValid;
}

// ===== Flash Banner =====
function showBanner(type, msg) {
    const container = document.getElementById('flash-banner-container');
    if (!container) return;
    container.innerHTML = '';

    const icon   = type === 'success' ? '✅' : '❌';
    const banner = document.createElement('div');
    banner.className = 'flash-banner flash-banner-' + type;
    banner.innerHTML = icon + ' ' + msg;
    container.appendChild(banner);

    setTimeout(() => {
        banner.classList.add('flash-banner-hide');
        banner.addEventListener('transitionend', () => { container.innerHTML = ''; });
    }, 3500);
}
