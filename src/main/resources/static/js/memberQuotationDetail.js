// ===== Modal ยืนยันการจอง =====
function showConfirmModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) modal.style.display = 'flex';
}

function closeConfirmModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) modal.style.display = 'none';
}

// ===== ส่งข้อความแจ้งขอแก้ไขทั้งใบเสนอราคา =====
function packAndSubmitReviseForm() {
    const noteInput = document.getElementById('memberNoteInput');
    const note = noteInput ? noteInput.value.trim() : '';
    if (note === '') {
        alert('กรุณากรอกข้อความแจ้งขอแก้ไข');
        return;
    }
    document.getElementById('memberNoteHidden').value = note;
    document.getElementById('cleanSubmitForm').submit();
}

// ===== Banner แจ้งเตือนหลังยืนยันผ่าน AJAX =====
function showAjaxConfirmBanner() {
    const banner = document.getElementById('ajaxConfirmBanner');
    if (!banner) return;
    banner.style.display = 'block';
    window.scrollTo({ top: 0, behavior: 'smooth' });
    setTimeout(function () { banner.style.display = 'none'; }, 5000);
}

// ===== ล็อกหน้าใบเสนอราคาเป็นสถานะ "ยืนยันแล้ว" โดยไม่ต้องรีโหลด =====
function lockQuotationAsConfirmed() {
    const statusPill = document.querySelector('.status-pill');
    if (statusPill) {
        statusPill.className = 'status-pill status-Confirmed';
        statusPill.innerText = '✓ ยืนยันรายการแล้ว';
    }

    const actionSection = document.querySelector('.action-section');
    if (actionSection) {
        actionSection.innerHTML = '';
        const lockMsg = document.createElement('div');
        lockMsg.className = 'lock-message';
        const title = document.createElement('div');
        title.className = 'lock-title';
        title.innerText = 'ขอบคุณสำหรับการยืนยันการจอง';
        const desc = document.createElement('p');
        desc.className = 'lock-desc';
        desc.innerText = 'ทางเราได้รับข้อมูลของท่านแล้ว และกำลังจัดเตรียมอุปกรณ์พร้อมเจ้าหน้าที่เพื่อให้บริการท่านอย่างดีที่สุด';
        lockMsg.appendChild(title);
        lockMsg.appendChild(desc);
        actionSection.appendChild(lockMsg);
    }

    const noteSection = document.querySelector('.member-note-section.no-print');
    if (noteSection) {
        const textarea = document.getElementById('memberNoteInput');
        const noteVal = textarea ? textarea.value.trim() : '';
        noteSection.classList.remove('no-print');
        noteSection.innerHTML = '';
        if (noteVal !== '') {
            const label = document.createElement('label');
            label.innerText = 'หมายเหตุ';
            const p = document.createElement('p');
            p.style.margin = '0';
            p.innerText = noteVal;
            noteSection.appendChild(label);
            noteSection.appendChild(p);
        } else {
            noteSection.remove();
        }
    }
}

// ===== (โค้ดเดิม) แจ้งแก้ไขทีละรายการ — ปัจจุบันหน้านี้ไม่มี .revise-inline-input =====
function toggleReviseForm(button) {
    const td = button.closest('td');
    if (!td) return;
    const input = td.querySelector('.revise-inline-input');
    if (!input) return;

    if (input.style.display === 'block') {
        input.style.display = 'none';
        button.innerText = '✍️ แจ้งแก้รายการนี้';
    } else {
        input.style.display = 'block';
        input.focus();
        button.innerText = '✕ ยกเลิก';
    }
}

// กด Enter ในช่องแจ้งแก้รายรายการ -> ยืนยันแล้วส่งฟอร์ม
document.addEventListener('keydown', function (e) {
    if (e.target.classList && e.target.classList.contains('revise-inline-input') && e.key === 'Enter') {
        e.preventDefault();
        const form = e.target.closest('form');
        if (form && e.target.value.trim() !== '') {
            if (confirm('ยืนยันส่งข้อความร้องขอแก้ไขสำหรับรายการนี้?')) {
                form.submit();
            }
        }
    }
});

// ===== Init =====
document.addEventListener('DOMContentLoaded', function () {

    // ซ่อน flash banner (success/error จากเซิร์ฟเวอร์) หลัง 5 วินาที
    setTimeout(function () {
        const banner = document.getElementById('flashBanner');
        if (banner) banner.style.display = 'none';
    }, 5000);

    // Dropdown โปรไฟล์
    const toggle = document.getElementById('userProfileToggle');
    const menu = document.getElementById('dropdownMenu');
    if (toggle && menu) {
        toggle.addEventListener('click', function (e) {
            e.stopPropagation();
            menu.classList.toggle('show');
        });
    }

    // คลิกที่อื่น: ปิด dropdown และปิด modal ถ้าคลิกที่พื้นหลังของ modal
    document.addEventListener('click', function (e) {
        if (menu) menu.classList.remove('show');
        if (e.target === document.getElementById('confirmModal')) {
            closeConfirmModal();
        }
    });

    // ยืนยันใบเสนอราคาผ่าน fetch (ไม่รีโหลดหน้า)
    const confirmForm = document.getElementById('confirmQuotationForm');
    if (confirmForm) {
        confirmForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const submitBtn = confirmForm.querySelector('.btn-confirm-final');
            const originalLabel = submitBtn ? submitBtn.innerText : '';

            function resetButton() {
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.innerText = originalLabel;
                }
            }

            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerText = 'กำลังยืนยัน...';
            }

            fetch(confirmForm.action, {
                method: 'POST',
                body: new FormData(confirmForm)
            }).then(function (res) {
                if (res.ok) {
                    closeConfirmModal();
                    lockQuotationAsConfirmed();
                    showAjaxConfirmBanner();
                } else {
                    alert('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง');
                    resetButton();
                }
            }).catch(function () {
                alert('เชื่อมต่อไม่สำเร็จ กรุณาลองใหม่อีกครั้ง');
                resetButton();
            });
        });
    }
});