// ===== ฟังก์ชันสลับหน้าฟอร์มล็อกอินระหว่าง Organizer และ Head Staff =====
function selectRole(role) {
    const formOrganizer = document.getElementById('form-organizer');
    const formHeadstaff = document.getElementById('form-headstaff');
    const btnOrganizer  = document.getElementById('btn-organizer');
    const btnHeadstaff  = document.getElementById('btn-headstaff');

    if (role === 'organizer') {
        formOrganizer.style.display = 'flex';
        formHeadstaff.style.display = 'none';
        btnOrganizer.classList.add('active');
        btnHeadstaff.classList.remove('active');
    } else {
        formOrganizer.style.display = 'none';
        formHeadstaff.style.display = 'flex';
        btnHeadstaff.classList.add('active');
        btnOrganizer.classList.remove('active');
    }
}

// ===== ฟังก์ชันสลับการแสดงผลรหัสผ่าน (Show/Hide Password) =====
function togglePassword(fieldId, btn) {
    const input = document.getElementById(fieldId);
    if (input.type === 'password') {
        input.type = 'text';
        btn.textContent = '🙈';
    } else {
        input.type = 'password';
        btn.textContent = '👁';
    }
}