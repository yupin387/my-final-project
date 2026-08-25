// ===== Dropdown =====
function toggleDropdown() {
    document.getElementById('dropdownMenu')?.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-profile-pill');
    if (userInfo && !userInfo.contains(e.target)) {
        document.getElementById('dropdownMenu')?.classList.remove('show');
    }
});

// ===== Multiple File Preview (แนบได้หลายรูป, เลือกเพิ่มทีละครั้งได้, ลบทีละรูปได้) =====
const MAX_REVIEW_IMAGES = 5;
let selectedReviewFiles = [];

function triggerFileSelect() {
    document.getElementById('imageFile')?.click();
}

// input[type=file] ปกติ set ค่าใหม่ทับของเก่าทุกครั้งที่เลือก
// เลยต้องเก็บไฟล์เองใน selectedReviewFiles แล้วค่อย sync กลับเข้า input ด้วย DataTransfer
// เพื่อให้เลือกเพิ่มได้เรื่อย ๆ (ไม่ใช่แทนที่ของเดิม) และลบทีละรูปได้
function handleFileSelect(event) {
    const newFiles = Array.from(event.target.files || []);
    if (newFiles.length === 0) return;

    for (const file of newFiles) {
        if (selectedReviewFiles.length >= MAX_REVIEW_IMAGES) {
            alert('แนบรูปภาพได้สูงสุด ' + MAX_REVIEW_IMAGES + ' รูป');
            break;
        }
        selectedReviewFiles.push(file);
    }

    syncFileInput();
    renderImagePreviews();
}

function syncFileInput() {
    const input = document.getElementById('imageFile');
    if (!input) return;
    const dt = new DataTransfer();
    selectedReviewFiles.forEach(f => dt.items.add(f));
    input.files = dt.files;
}

function removeReviewImage(index) {
    selectedReviewFiles.splice(index, 1);
    syncFileInput();
    renderImagePreviews();
}

function renderImagePreviews() {
    const placeholder = document.getElementById('uploadPlaceholder');
    const container = document.getElementById('imagePreviewContainer');
    const counter = document.getElementById('imageCountLabel');
    if (!container) return;

    container.innerHTML = '';

    if (counter) {
        counter.textContent = selectedReviewFiles.length + '/' + MAX_REVIEW_IMAGES + ' รูป';
        counter.style.display = selectedReviewFiles.length > 0 ? 'block' : 'none';
    }

    if (selectedReviewFiles.length === 0) {
        if (placeholder) placeholder.style.display = 'block';
        container.style.display = 'none';
        return;
    }

    if (placeholder) placeholder.style.display = 'none';
    container.style.display = 'flex';

    // สร้าง wrapper ของแต่ละรูปตามลำดับก่อน แล้วค่อยเติมรูปเข้าไปทีหลัง (async)
    // เพื่อกันไม่ให้ลำดับรูปสลับกันตอนโหลดเสร็จไม่พร้อมกัน
    selectedReviewFiles.forEach((file, index) => {
        const wrap = document.createElement('div');
        wrap.className = 'preview-thumb-wrap';

        const img = document.createElement('img');
        img.className = 'preview-thumb';
        wrap.appendChild(img);

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'preview-remove-btn';
        removeBtn.innerHTML = '&times;';
        removeBtn.setAttribute('aria-label', 'ลบรูปภาพนี้');
        removeBtn.onclick = function (ev) {
            ev.stopPropagation();
            removeReviewImage(index);
        };
        wrap.appendChild(removeBtn);

        container.appendChild(wrap);

        const reader = new FileReader();
        reader.onload = function (e) {
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    });

    if (selectedReviewFiles.length < MAX_REVIEW_IMAGES) {
        const addMoreTile = document.createElement('div');
        addMoreTile.className = 'add-more-tile';
        addMoreTile.innerHTML = '<span>+</span>';
        addMoreTile.onclick = function (ev) {
            ev.stopPropagation();
            triggerFileSelect();
        };
        container.appendChild(addMoreTile);
    }
}

// ===== เช็คสคริปก่อนปลดล็อกปุ่ม "ส่งรีวิว" =====
// ต้องกรอกครบ 2 อย่างคือ "ดาว" กับ "คอมเมนต์" ปุ่มถึงจะเปลี่ยนเป็นสีเข้ม (กดได้)
// ถ้ายังไม่ครบ ปุ่มจะเป็นสีทึบจาง ๆ (disabled) กดไม่ได้ ไม่ต้องแนบรูปก็ส่งได้
document.addEventListener('DOMContentLoaded', function () {
    const reviewForm = document.getElementById('reviewForm');
    const submitBtn = document.getElementById('submitReviewBtn');
    const commentInput = document.getElementById('commentInput');
    if (!reviewForm || !submitBtn || !commentInput) return;

    function updateSubmitButtonState() {
        const hasRating = !!reviewForm.querySelector('input[name="rating"]:checked');
        const hasComment = commentInput.value.trim().length > 0;
        submitBtn.disabled = !(hasRating && hasComment);
    }

    reviewForm.querySelectorAll('input[name="rating"]').forEach(function (input) {
        input.addEventListener('change', updateSubmitButtonState);
    });
    commentInput.addEventListener('input', updateSubmitButtonState);

    // เผื่อกรอกไว้แล้วโดน browser autofill/ย้อนกลับมาหน้านี้
    updateSubmitButtonState();

    // เผื่อไว้กันเหนียว: ถ้ามีการปลดล็อกปุ่มด้วยวิธีอื่น (เช่นแก้ผ่าน devtools)
    // ให้เช็คซ้ำตอน submit อีกครั้ง ไม่ให้ส่งรีวิวที่ยังไม่ครบข้อมูลหลุดไปได้
    reviewForm.addEventListener('submit', function (e) {
        const hasRating = !!reviewForm.querySelector('input[name="rating"]:checked');
        const hasComment = commentInput.value.trim().length > 0;
        if (!hasRating || !hasComment) {
            e.preventDefault();
        }
    });
});