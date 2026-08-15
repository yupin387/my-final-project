function prepareDelete(id) {
    // ลบบรรทัด document.getElementById('contextPath').value ออก
    // แล้วใช้ตัวแปร contextPath แบบ Global ที่ประกาศไว้ใน jsp ได้เลย
    const actionUrl = contextPath + "/organizer/questions/delete/" + id;
    document.getElementById('confirmDeleteForm').action = actionUrl;
    
    var myModal = new bootstrap.Modal(document.getElementById('deleteModal'));
    myModal.show();
}

// ลบโค้ด toggleDropdown ที่ซ้ำซ้อนออก ให้เหลือแค่อันเดียวพอครับ
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

document.addEventListener('click', function(e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (userInfo && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});