function showConfirmModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) modal.style.display = 'flex';
}

function closeConfirmModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) modal.style.display = 'none';
}

// ===== ฟังก์ชันควบคุมกล่องพิมพ์ข้อความขอแก้ไขรายรายการ =====
function toggleReviseForm(button) {
    const td = button.closest('td');
    const input = td.querySelector('.revise-inline-input');
    
    if (input.style.display === 'block') {
        input.style.display = 'none';
        button.innerText = '✍️ แจ้งแก้รายการนี้';
    } else {
        input.style.display = 'block';
        input.focus();
        button.innerText = '✕ ยกเลิก';
    }
}

// ดักจับการกด Enter ภายในอินพุตย่อยเพื่อสั่ง Submit ฟอร์มรายรายการส่งไปหลังบ้าน
document.addEventListener('keypress', function(e) {
    if (e.target.classList.contains('revise-inline-input') && e.key === 'Enter') {
        e.preventDefault();
        const form = e.target.closest('form');
        if (e.target.value.trim() !== "") {
            if(confirm('ยืนยันส่งข้อความร้องขอแก้ไขสำหรับรายการนี้?')) {
                form.submit();
            }
        }
    }
});

document.addEventListener('click', function (e) {
    const modal = document.getElementById('confirmModal');
    if (e.target === modal) {
        closeConfirmModal();
    }
});