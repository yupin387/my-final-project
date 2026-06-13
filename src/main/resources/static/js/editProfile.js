// ===== Dropdown =====
function toggleDropdown() {
    document.getElementById('dropdownMenu')?.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        document.getElementById('dropdownMenu')?.classList.remove('show');
    }
});

// ===== Password Match Validation =====
document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('form');
    if (!form) return;

    form.addEventListener('submit', function (e) {
        const newPass     = document.getElementById('newPassword');
        const confirmPass = document.getElementById('confirmPassword');

        if (!newPass || !confirmPass) return;

        if (newPass.value && newPass.value !== confirmPass.value) {
            e.preventDefault();
            confirmPass.style.borderColor = '#c62828';
            confirmPass.focus();
            showBanner('error', 'รหัสผ่านใหม่และการยืนยันไม่ตรงกัน กรุณาตรวจสอบอีกครั้ง');
        }
    });

    // Flash banner from server
    const successEl = document.getElementById('flash-success');
    const errorEl   = document.getElementById('flash-error');
    if (successEl?.dataset.msg) showBanner('success', successEl.dataset.msg);
    if (errorEl?.dataset.msg)   showBanner('error',   errorEl.dataset.msg);
});

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