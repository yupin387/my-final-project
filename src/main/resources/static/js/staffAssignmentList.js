// ===== ฟังก์ชันจัดการการเปิด-ปิดเมนู Dropdown และปิดอัตโนมัติเมื่อคลิกพื้นที่อื่นภายนอก =====
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }
});

// ซ่อน flash banner อัตโนมัติหลัง 3 วินาที
setTimeout(function() {
    const banners = document.querySelectorAll('.flash-banner');
    banners.forEach(function(el) {
        el.style.transition = 'opacity 0.5s ease';
        el.style.opacity = '0';
        setTimeout(() => el.remove(), 500);
    });
}, 3000);


// ===== ฟังก์ชันจัดการ Modal รายงานความเสียหาย =====
let selectedFiles = []; // เก็บไฟล์ที่เลือกสะสมไว้

function openDamageModal() {
    document.getElementById('damageModal').classList.add('show');
}

function closeDamageModal() {
    document.getElementById('damageModal').classList.remove('show');
    selectedFiles = [];
    renderPreview();
    document.getElementById('fileInput').value = '';
}

// เมื่อเลือกไฟล์ใหม่ ให้เพิ่มเข้า selectedFiles (ไม่ทับของเดิม)
function handleFileSelect(input) {
    for (const file of input.files) {
        selectedFiles.push(file);
    }
    renderPreview();
    syncFilesToInput();
}

// ลบไฟล์ออกจากรายการที่เลือก
function removeFile(index) {
    selectedFiles.splice(index, 1);
    renderPreview();
    syncFilesToInput();
}

// แสดง preview รูปที่เลือกทั้งหมด
function renderPreview() {
    const preview = document.getElementById('uploadPreview');
    const placeholder = document.getElementById('uploadPlaceholder');
    preview.innerHTML = '';

    if (selectedFiles.length === 0) {
        placeholder.style.display = 'block';
        return;
    }
    placeholder.style.display = 'none';

    selectedFiles.forEach((file, index) => {
        const url = URL.createObjectURL(file);
        const item = document.createElement('div');
        item.className = 'preview-item';
        item.innerHTML = `
            <img src="${url}" alt="${file.name}">
            <span class="remove-btn" onclick="event.stopPropagation(); removeFile(${index})">&times;</span>
        `;
        preview.appendChild(item);
    });
}

// sync selectedFiles กลับเข้า <input type="file"> เพื่อให้ตอน submit ส่งไปครบทุกไฟล์
function syncFilesToInput() {
    const dataTransfer = new DataTransfer();
    selectedFiles.forEach(file => dataTransfer.items.add(file));
    document.getElementById('fileInput').files = dataTransfer.files;
}