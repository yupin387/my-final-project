// ตรวจสอบรหัสผ่านตรงกันก่อน submit
document.querySelector('form').addEventListener('submit', function (e) {
    const pw  = document.getElementById('memberPassword').value;
    const cpw = document.getElementById('confirmPassword').value;

    if (pw !== cpw) {
        e.preventDefault();
        alert('รหัสผ่านไม่ตรงกัน กรุณาตรวจสอบอีกครั้ง');
        document.getElementById('confirmPassword').focus();
    }
});