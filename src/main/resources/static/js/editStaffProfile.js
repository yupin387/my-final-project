// ===== editStaffProfile.js =====
// สคริปต์ของหน้าแก้ไขข้อมูลส่วนตัวของหัวหน้างาน (เดิมฝังอยู่ใน editStaffProfile.jsp)

// ===== Dropdown เมนูผู้ใช้ (มุมขวาบน) =====
function toggleDropdown() {
    const menu = document.getElementById("dropdownMenu");
    if (menu) menu.classList.toggle("show");
}

// ปิด dropdown เมื่อคลิกพื้นที่อื่นนอก .user-info
document.addEventListener("click", function (e) {
    const userInfo = document.querySelector(".user-info");
    if (userInfo && !userInfo.contains(e.target)) {
        const menu = document.getElementById("dropdownMenu");
        if (menu) menu.classList.remove("show");
    }
});

// ===== ตรวจสอบฟอร์ม =====

// ---------- helper แสดง/ซ่อนข้อความ error ----------
function showFieldError(input, errorEl, message) {
    if (message) errorEl.innerText = message;
    errorEl.style.display = "block";
    input.classList.add("input-error");
}

function clearFieldError(input, errorEl) {
    errorEl.style.display = "none";
    input.classList.remove("input-error");
}

// ---------- ตรวจสอบชื่อ/นามสกุล (ใช้กติกาเดียวกัน) ----------
// label = "ชื่อ" หรือ "นามสกุล"
function validateNameField(input, errorEl, label) {
    const nameRegex = /^[a-zA-Zก-๙\s]+$/;
    const value = input.value.trim();

    if (value === "") {
        showFieldError(input, errorEl, "กรุณากรอก" + label);
        return false;
    }
    if (!nameRegex.test(value) || /\d/.test(value)) {
        showFieldError(input, errorEl, label + "ต้องเป็นตัวอักษรภาษาไทยหรือภาษาอังกฤษเท่านั้น");
        return false;
    }
    if (value.length < 2 || value.length > 100) {
        showFieldError(input, errorEl, label + "ต้องมีความยาวไม่น้อยกว่า 2 ตัวอักษร และไม่เกิน 100 ตัวอักษร");
        return false;
    }

    clearFieldError(input, errorEl);
    return true;
}

// ---------- ตรวจสอบทั้งฟอร์มตอนกดบันทึก ----------
function validateForm(event) {
    let isValid = true;

    // 1. ชื่อ
    const firstNameInput = document.getElementById("staffFirstName");
    const firstNameError = document.getElementById("firstNameError");
    if (!validateNameField(firstNameInput, firstNameError, "ชื่อ")) isValid = false;

    // 2. นามสกุล
    const lastNameInput = document.getElementById("staffLastName");
    const lastNameError = document.getElementById("lastNameError");
    if (!validateNameField(lastNameInput, lastNameError, "นามสกุล")) isValid = false;

    // 3. เบอร์โทรศัพท์ (ข้อความ error เขียนไว้ใน JSP แล้ว)
    const phoneInput = document.getElementById("staffPhone");
    const phoneError = document.getElementById("phoneError");
    const phoneRegex = /^0[0-9]{9}$/;
    if (!phoneRegex.test(phoneInput.value.trim())) {
        showFieldError(phoneInput, phoneError);
        isValid = false;
    } else {
        clearFieldError(phoneInput, phoneError);
    }

    // 4. รหัสผ่านใหม่ (ปล่อยว่างได้ = ไม่เปลี่ยน)
    const passwordInput = document.getElementById("staffPassword");
    const passwordError = document.getElementById("passwordError");
    const passwordRegex = /^[a-zA-Z0-9]{8,}$/;
    if (passwordInput.value !== "" && !passwordRegex.test(passwordInput.value)) {
        showFieldError(passwordInput, passwordError);
        isValid = false;
    } else {
        clearFieldError(passwordInput, passwordError);
    }

    if (!isValid) {
        event.preventDefault();
    }
    return isValid;
}

// ---------- ซ่อน error ทันทีที่พิมพ์แก้ไข ----------
document.addEventListener("DOMContentLoaded", function () {
    const bindings = [
        { inputId: "staffFirstName", errorId: "firstNameError" },
        { inputId: "staffLastName",  errorId: "lastNameError" },
        { inputId: "staffPhone",     errorId: "phoneError",    digitsOnly: true },
        { inputId: "staffPassword",  errorId: "passwordError" }
    ];

    bindings.forEach(function (b) {
        const input   = document.getElementById(b.inputId);
        const errorEl = document.getElementById(b.errorId);
        if (!input || !errorEl) return;

        input.addEventListener("input", function () {
            clearFieldError(input, errorEl);
            // เบอร์โทร: อนุญาตเฉพาะตัวเลข
            if (b.digitsOnly) {
                input.value = input.value.replace(/[^0-9]/g, "");
            }
        });
    });
});