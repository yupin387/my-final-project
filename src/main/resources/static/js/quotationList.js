// ===== ฟังก์ชันจัดการการเปิด-ปิดเมนู Dropdown และปิดอัตโนมัติเมื่อคลิกพื้นที่อื่นภายนอก =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (menu && userInfo && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});

function toggleStatusFilter() {
    const dropdown = document.getElementById('statusFilterDropdown');
    const wrapper = document.getElementById('statusFilterWrapper');
    dropdown.classList.toggle('show');
    wrapper.classList.toggle('open');
}

document.addEventListener('click', function (e) {
    const wrapper = document.getElementById('statusFilterWrapper');
    if (wrapper && !wrapper.contains(e.target)) {
        document.getElementById('statusFilterDropdown').classList.remove('show');
        wrapper.classList.remove('open');
    }
});