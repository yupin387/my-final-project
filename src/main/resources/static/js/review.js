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

// ===== File Upload Label Update =====
document.addEventListener('DOMContentLoaded', function () {
    const fileInput = document.getElementById('imageFile');
    if (!fileInput) return;

    fileInput.addEventListener('change', function () {
        const uploadText = document.querySelector('.upload-text');
        if (this.files && this.files.length > 0) {
            uploadText.textContent = this.files[0].name;
        } else {
            uploadText.textContent = 'คลิกเพื่อเลือกรูปภาพ';
        }
    });
});