function prepareDelete(id) {
    // 1. กำหนด URL สำหรับลบ
    const actionUrl = "${pageContext.request.contextPath}/organizer/questions/delete/" + id;
    document.getElementById('confirmDeleteForm').action = actionUrl;
    
    // 2. สั่งเปิด Modal ด้วยคำสั่ง Bootstrap
    var myModal = new bootstrap.Modal(document.getElementById('deleteModal'));
    myModal.show();
}

function toggleDropdown() {
    var menu = document.getElementById("dropdownMenu");
    menu.style.display = (menu.style.display === "block") ? "none" : "block";
}

// ปิด Dropdown เมื่อคลิกที่อื่น
window.onclick = function(event) {
    if (!event.target.closest('.user-info')) {
        var dropdowns = document.getElementsByClassName("dropdown-menu");
        for (var i = 0; i < dropdowns.length; i++) {
            dropdowns[i].style.display = "none";
        }
    }
}

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