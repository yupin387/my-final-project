// ===== Dropdown =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) menu.classList.toggle('show');
}

// Global Click Listener (Handles both Dropdown and Modal Overlay)
document.addEventListener('click', function (e) {
    // Close dropdown if clicking outside user-info
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }

    // Close modal when clicking on the background overlay
    const overlay = document.getElementById('damageModal');
    if (e.target === overlay) {
        closeDamageModal();
    }
});

// ===== Modal =====
function openDamageModal() {
    document.getElementById('damageModal').classList.add('show');
}

function closeDamageModal() {
    document.getElementById('damageModal').classList.remove('show');
}

// ===== Flash Banner (Toast) =====
function showToast(type, msg) {
    const container = document.getElementById('flash-banner-container');
    if (!container) return;

    container.innerHTML = ''; // Clear existing toasts

    const banner = document.createElement('div');
    banner.className = `flash-banner flash-banner-${type}`;
    banner.textContent = msg; 

    container.appendChild(banner);
    
    // Optional: Auto-remove the toast after 3 seconds
    setTimeout(() => {
        banner.remove();
    }, 3000);
}

// ===== Submit Report via AJAX =====
document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('damageForm');
    if (!form) return;

    form.addEventListener('submit', function (e) {
        e.preventDefault();

        const btn = form.querySelector('.btn-send');
        btn.disabled = true;
        btn.textContent = 'กำลังส่ง...';

        const formData = new FormData(form);

        fetch(form.action, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            // Fetch only rejects on network failure. We must check response.ok for HTTP errors.
            if (!response.ok) {
                throw new Error('Server error');
            }
            closeDamageModal();
            form.reset();
            document.getElementById('uploadPreview').innerHTML = '';
            document.getElementById('uploadPlaceholder').style.display = 'flex';
            showToast('success', 'ส่งรายงานความเสียหายเรียบร้อยแล้ว');
        })
        .catch((error) => {
            console.error('Submission error:', error);
            showToast('error', 'ไม่สามารถส่งรายงานได้ กรุณาลองใหม่');
        })
        .finally(() => {
            btn.disabled = false;
            btn.textContent = 'ส่งรายงาน';
        });
    });
});

// ===== File Upload Preview =====
function handleFileSelect(input) {
    const preview = document.getElementById('uploadPreview');
    const placeholder = document.getElementById('uploadPlaceholder');
    preview.innerHTML = '';

    if (input.files && input.files.length > 0) {
        placeholder.style.display = 'none';
        Array.from(input.files).forEach(file => {
            const reader = new FileReader();
            reader.onload = function (e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'preview-img';
                preview.appendChild(img);
            };
            reader.readAsDataURL(file);
        });
    } else {
        placeholder.style.display = 'flex';
    }
}