// ===== Dropdown Toggle =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const wrap = document.querySelector('.dropdown-wrap');
    const menu = document.getElementById('dropdownMenu');
    if (menu && wrap && !wrap.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ===== Auto-fill วันที่กรอกแบบฟอร์ม =====
document.addEventListener('DOMContentLoaded', function () {
    const display = document.getElementById('bookingDateDisplay');
    const hidden  = document.getElementById('bookingDateHidden');
    if (!display || !hidden) return;

    const now = new Date();

    // สำหรับ hidden (ส่ง backend แบบ yyyy-MM-dd)
    const yyyy = now.getFullYear();
    const mm   = String(now.getMonth() + 1).padStart(2, '0');
    const dd   = String(now.getDate()).padStart(2, '0');
    hidden.value = `${yyyy}-${mm}-${dd}`;

    // สำหรับแสดงผลแบบไทย dd/MM/yyyy
    display.value = `${dd}/${mm}/${yyyy}`;
});

// ===== Toggle Lock Groups =====
// ล็อกฟิลด์ลูก (toggle-slave) ในหมวดเดียวกัน เมื่อฟิลด์หลัก (toggle-master)
// ถูกเลือกเป็นค่าที่อยู่ใน data-lock-values (เช่น "ไม่ต้องการ" หรือ "นิมนต์เอง")
document.addEventListener('DOMContentLoaded', function () {
    const masters = document.querySelectorAll('.toggle-master');

    masters.forEach(function (master) {
        const group = master.dataset.group;
        if (!group) return;

        // ค่าที่ถือว่า "ไม่ต้องการ" -> ให้ล็อกฟิลด์อื่นในกลุ่ม
        // อ่านจาก data-lock-values (คั่นด้วย |) หรือใช้ค่า default
        const lockValuesAttr = master.dataset.lockValues || 'ไม่ต้องการ|นิมนต์เอง';
        const lockValues = lockValuesAttr.split('|');

        const slaves = document.querySelectorAll(
            '.toggle-slave[data-group="' + group + '"]'
        );

        function applyState() {
            const shouldLock = lockValues.indexOf(master.value) !== -1;

            slaves.forEach(function (slave) {
                slave.disabled = shouldLock;

                if (shouldLock) {
                    slave.classList.add('field-locked');
                    if (slave.tagName === 'SELECT') {
                        slave.selectedIndex = 0;
                    } else {
                        slave.value = '';
                    }
                } else {
                    slave.classList.remove('field-locked');
                }
            });
        }

        master.addEventListener('change', applyState);
        applyState(); // เรียกตอนโหลดหน้า ให้ state ตรงกับค่า default ของ master
    });
});