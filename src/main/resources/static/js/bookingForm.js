// ===== Dropdown Toggle =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) menu.classList.toggle('show');
}

document.addEventListener('click', function(e) {
    const wrap = document.querySelector('.dropdown-wrap');
    const menu = document.getElementById('dropdownMenu');
    if (menu && wrap && !wrap.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ===== Auto-fill วันที่กรอกแบบฟอร์ม =====
document.addEventListener('DOMContentLoaded', function() {
    const display = document.getElementById('bookingDateDisplay');
    const hidden  = document.getElementById('bookingDateHidden');
    if (!display || !hidden) return;

    const now = new Date();
    const yyyy = now.getFullYear();
    const mm   = String(now.getMonth() + 1).padStart(2, '0');
    const dd   = String(now.getDate()).padStart(2, '0');
    hidden.value = yyyy + '-' + mm + '-' + dd;
    display.value = dd + '/' + mm + '/' + yyyy;
});

// ===== Toggle Lock Groups =====
document.addEventListener('DOMContentLoaded', function() {
    const masters = document.querySelectorAll('.toggle-master');
    masters.forEach(function(master) {
        const group = master.dataset.group;
        if (!group) return;
        const lockValuesAttr = master.dataset.lockValues || 'ไม่ต้องการ|นิมนต์เอง';
        const lockValues = lockValuesAttr.split('|');
        const slaves = document.querySelectorAll('.toggle-slave[data-group="' + group + '"]');

        function applyState() {
            const shouldLock = lockValues.indexOf(master.value) !== -1;
            slaves.forEach(function(slave) {
                slave.disabled = shouldLock;
                if (shouldLock) {
                    slave.classList.add('field-locked');
                    if (slave.tagName === 'SELECT') slave.selectedIndex = 0;
                    else slave.value = '';
                } else {
                    slave.classList.remove('field-locked');
                }
            });
        }
        master.addEventListener('change', applyState);
        applyState();
    });
});

// ===== Toggle Monk Detail =====
function toggleMonkDetail(radio) {
    const monkDetail = document.getElementById('monkDetail');
    if (monkDetail) {
        monkDetail.style.display = (radio.value === 'ให้ทางร้านนิมนต์') ? 'block' : 'none';
    }
}

// ===== Toggle Wat Detail =====
function toggleWatDetail(radio) {
    const watSame = document.getElementById('watSameDetail');
    const watDiff = document.getElementById('watDiffDetail');
    const watSameInput = document.getElementById('watSameInput');
    const watDiffInput = document.getElementById('watDiffInput');

    if (watSame) watSame.style.display = (radio.value === 'วัดเดียวกัน') ? 'block' : 'none';
    if (watDiff) watDiff.style.display = (radio.value === 'ต่างวัด') ? 'block' : 'none';

    if (radio.value === 'วัดเดียวกัน' && watDiffInput) watDiffInput.value = '';
    if (radio.value === 'ต่างวัด' && watSameInput) watSameInput.value = '';
    if (radio.value === 'ให้ร้านเลือกให้') {
        if (watSameInput) watSameInput.value = '';
        if (watDiffInput) watDiffInput.value = '';
    }
}

// ===== Toggle Section (ปิ่นโต / สังฆทาน) =====
function toggleSection(sectionId, show) {
    const el = document.getElementById(sectionId);
    if (el) el.style.display = show ? 'block' : 'none';
}