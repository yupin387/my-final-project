// ===== editItem.js =====
// สคริปต์ทั้งหมดของหน้าแก้ไขรายการอุปกรณ์ (เดิมบางส่วนฝังอยู่ใน editItem.jsp)

// ===== Dropdown =====

// ฟังก์ชันสำหรับเปิด-ปิดเมนู Dropdown โดยการสลับ Class 'show'
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) menu.classList.toggle('show');
}

// Event Listener สำหรับปิด Dropdown อัตโนมัติเมื่อคลิกพื้นที่อื่นนอกเหนือจาก .user-info
document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    if (userInfo && !userInfo.contains(e.target)) {
        const menu = document.getElementById('dropdownMenu');
        if (menu) menu.classList.remove('show');
    }
});

// ===== Flash Banner =====

// ฟังก์ชันสร้างและแสดงแถบ Banner แจ้งเตือน (Flash Message)
// type: 'success' หรือ 'error', title: ข้อความที่ต้องการแสดง
function showBanner(type, title) {
    // ลบ Banner อันเก่าออกก่อน (ถ้ามี) เพื่อไม่ให้ซ้อนกัน
    const old = document.getElementById('flash-banner');
    if (old) old.remove();

    // สร้าง Element ของ Banner ใหม่
    const banner = document.createElement('div');
    banner.id = 'flash-banner';
    banner.className = `flash-banner ${type}`;
    banner.innerHTML = `<span>${title}</span>`;

    // แทรก Banner ไว้ที่ส่วนบนสุดของเนื้อหาในหน้าเพจ
    const pageWrapper = document.querySelector('.page-wrapper');
    if (pageWrapper) {
        document.body.insertBefore(banner, pageWrapper);
    } else {
        document.body.prepend(banner);
    }
}

// ตรวจสอบข้อความแจ้งเตือนจาก Attribute เมื่อโหลดหน้าเว็บเสร็จสมบูรณ์ (DOMContentLoaded)
document.addEventListener('DOMContentLoaded', function () {
    const successEl = document.getElementById('flash-success');
    const errorEl   = document.getElementById('flash-error');

    // ตรวจสอบและแสดงข้อความแจ้งเตือนความสำเร็จ (Success)
    if (successEl && successEl.dataset.msg) {
        const msg = successEl.dataset.msg;
        let title = 'ดำเนินการสำเร็จ'; // ข้อความตั้งต้น

        // ปรับเปลี่ยนข้อความ Title ตามเนื้อหาของข้อความที่ส่งมา
        if (msg.includes('แก้ไข'))       title = 'แก้ไขข้อมูลเรียบร้อยแล้ว';
        else if (msg.includes('บันทึก')) title = 'บันทึกข้อมูลเรียบร้อยแล้ว';

        showBanner('success', title);
    }

    // ตรวจสอบและแสดงข้อความแจ้งเตือนข้อผิดพลาด (Error)
    if (errorEl && errorEl.dataset.msg) {
        showBanner('error', errorEl.dataset.msg);
    }
});

// ===== กลุ่มพิธี: ติ๊กเลือก + ช่องจำนวน =====

function toggleQtyInput(checkbox, qtyInputId) {
    const qtyInput = document.getElementById(qtyInputId);
    if (!qtyInput) return;

    qtyInput.disabled = !checkbox.checked;
    if (checkbox.checked && !qtyInput.value) {
        qtyInput.value = 1;
    }
    syncSelectAllState(checkbox.getAttribute('data-group'));
}

/* ===== select-all checkbox ต่อกลุ่ม ===== */
function onSelectAllChange(selectAllBox) {
    const groupKey  = selectAllBox.getAttribute('data-group');
    const container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
    if (!container) return;

    const checked = selectAllBox.checked;
    container.querySelectorAll('input[type="checkbox"]').forEach(function (cb) {
        cb.checked = checked;
        const qtyInput = document.getElementById('qty_' + cb.value);
        if (qtyInput) {
            qtyInput.disabled = !checked;
            if (checked && !qtyInput.value) qtyInput.value = 1;
        }
    });
    selectAllBox.indeterminate = false;
}

function syncSelectAllState(groupKey) {
    const container    = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
    const selectAllBox = document.querySelector('.select-all-checkbox[data-group="' + groupKey + '"]');
    if (!container || !selectAllBox) return;

    const boxes = container.querySelectorAll('input[type="checkbox"]');
    const total = boxes.length;
    let checkedCount = 0;
    boxes.forEach(function (cb) {
        if (cb.checked) checkedCount++;
    });

    if (checkedCount === 0) {
        selectAllBox.checked = false;
        selectAllBox.indeterminate = false;
    } else if (checkedCount === total) {
        selectAllBox.checked = true;
        selectAllBox.indeterminate = false;
    } else {
        selectAllBox.checked = false;
        selectAllBox.indeterminate = true;
    }
}

/* ===== ปิดกลุ่ม: ยกเลิกการติ๊กทั้งหมดในกลุ่ม แล้วซ่อนกลุ่มนั้นกลับไป
   ใช้กับกลุ่มที่เผลอเปิด หรือกลุ่มเดิมที่ผูกไว้แต่ไม่ต้องการแล้ว
   (ถ้าเป็นกลุ่มเดิมที่มีข้อมูลอยู่ก่อน การกดปิดจะล้างการติ๊กทั้งหมด — ต้องกดบันทึก
   การแก้ไขอีกครั้งเพื่อให้มีผลจริงกับฐานข้อมูล) ===== */
function closeGroup(groupKey) {
    const group = document.getElementById(groupKey);
    if (!group) return;

    const container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
    if (container) {
        container.querySelectorAll('input[type="checkbox"]').forEach(function (cb) {
            cb.checked = false;
            const qtyInput = document.getElementById('qty_' + cb.value);
            if (qtyInput) qtyInput.disabled = true;
        });
    }

    const selectAllBox = document.querySelector('.select-all-checkbox[data-group="' + groupKey + '"]');
    if (selectAllBox) {
        selectAllBox.checked = false;
        selectAllBox.indeterminate = false;
    }

    group.style.display = 'none';
    updateEmptyHint();
}

function updateEmptyHint() {
    const hint   = document.getElementById('ceremonyEmptyHint');
    const groups = document.querySelectorAll('#selectedCeremonyGroups .ceremony-type-group');
    let hasVisible = false;
    groups.forEach(function (g) {
        if (g.style.display !== 'none') hasVisible = true;
    });
    if (hint) hint.style.display = hasVisible ? 'none' : 'block';
}

/* ===== เลือกประเภทงานจาก dropdown เพื่อเปิดกลุ่ม ===== */
function bindCeremonyAdder() {
    const adder = document.getElementById('ceremonyTypeAdder');
    if (!adder) return;

    adder.addEventListener('change', function () {
        const groupKey = this.value;
        if (!groupKey) return;

        const group = document.getElementById(groupKey);
        if (group) group.style.display = 'block';

        this.value = '';
        updateEmptyHint();
    });
}

/* ===== ตอนโหลดหน้า: sync สถานะ select-all ของทุกกลุ่มที่มีข้อมูลเดิมติ๊กไว้อยู่แล้ว ===== */
document.addEventListener('DOMContentLoaded', function () {
    bindCeremonyAdder();
    updateEmptyHint();
    document.querySelectorAll('.select-all-checkbox').forEach(function (box) {
        syncSelectAllState(box.getAttribute('data-group'));
    });
});

/* ===== แจ้งเตือนเลขติดลบแบบเรียลไทม์ (เหมือนหน้า addItem ทุกจุด)

   หมายเหตุสำคัญ: input type="number" ของเบราว์เซอร์ ถ้าพิมพ์ "-" เดี่ยวๆ
   (ยังไม่ตามด้วยตัวเลข) ค่า .value จะเป็นค่าว่างเสมอ (เพราะยังไม่ใช่ตัวเลขที่สมบูรณ์)
   ต้องเช็ค this.validity.badInput ร่วมด้วยถึงจะจับได้ว่าเขาพิมพ์ - อยู่จริง

   1) ช่อง "ใช้...หน่วย" (qty-mini-input) -> ข้อความขึ้นท้ายกรอบใหญ่ของกลุ่มพิธีนั้น
   2) ช่อง "ราคาต่อหน่วย" (pricePerUnit)   -> ข้อความขึ้นใต้ช่องนั้นเลย

   ทั้งคู่: ไม่บล็อกการพิมพ์ - โชว์ทันทีตอนพิมพ์ (keydown) และค้างอยู่ที่เดิม
   จนกว่าจะแก้ไขจนถูกต้อง (ไม่มี blur-hide) และกันกดบันทึกทั้งที่ยังผิดค้างอยู่ ===== */

function isMinusKey(e) {
    return e.key === '-' || e.key === 'Subtract' || e.keyCode === 189 || e.keyCode === 109;
}

function hasNegativeInput(inp) {
    return inp.value.indexOf('-') !== -1 || inp.validity.badInput;
}

/* ---- (1) กลุ่ม qty: ข้อความอยู่ท้ายกรอบใหญ่ของกลุ่มพิธีนั้น ---- */
function getGroupErrorEl(groupEl) {
    const id = 'negerr_' + groupEl.id;
    let el = document.getElementById(id);
    if (!el) {
        el = document.createElement('div');
        el.id = id;
        el.className = 'no-negative-error-group';
        el.style.color = '#d32f2f';
        el.style.fontSize = '12px';
        el.style.margin = '4px 0 8px';
        el.style.display = 'none';
        groupEl.insertAdjacentElement('afterend', el);
    }
    return el;
}

function showGroupError(qtyInput) {
    const groupEl = qtyInput.closest('.ceremony-type-group');
    if (!groupEl) return;
    const el = getGroupErrorEl(groupEl);
    el.textContent = 'ห้ามใส่เลขติดลบ';
    el.style.display = 'block';
}

function hideGroupError(qtyInput) {
    const groupEl = qtyInput.closest('.ceremony-type-group');
    if (!groupEl) return;
    const el = document.getElementById('negerr_' + groupEl.id);
    if (el) el.style.display = 'none';
}

/* ---- (2) ช่องราคาต่อหน่วย: ข้อความอยู่ใต้ช่องนั้นเลย ---- */
function getFieldErrorEl(inp) {
    const id = 'negerr_' + (inp.id || inp.name);
    let el = document.getElementById(id);
    if (!el) {
        el = document.createElement('div');
        el.id = id;
        el.className = 'no-negative-error';
        el.style.color = '#d32f2f';
        el.style.fontSize = '12px';
        el.style.marginTop = '2px';
        el.style.display = 'none';
        inp.insertAdjacentElement('afterend', el);
    }
    return el;
}

function showFieldError(inp) {
    const el = getFieldErrorEl(inp);
    el.textContent = 'ห้ามใส่เลขติดลบ';
    el.style.display = 'block';
}

function hideFieldError(inp) {
    const el = document.getElementById('negerr_' + (inp.id || inp.name));
    if (el) el.style.display = 'none';
}

function applyNoNegative() {
    document.querySelectorAll('input[type="number"]').forEach(function (inp) {
        if (inp.dataset.noNegativeBound) return; // กันผูก event ซ้ำ
        inp.dataset.noNegativeBound = '1';

        const isQty  = inp.classList.contains('qty-mini-input');
        const showFn = isQty ? showGroupError : showFieldError;
        const hideFn = isQty ? hideGroupError : hideFieldError;

        /* พิมพ์ - ปุ๊บ โชว์ทันที (ไม่ preventDefault ปล่อยให้พิมพ์ได้) */
        inp.addEventListener('keydown', function (e) {
            if (isMinusKey(e)) showFn(this);
        });

        /* หลังค่าเปลี่ยน (พิมพ์เพิ่ม/ลบ/วาง) เช็คซ้ำว่ายังติดลบอยู่ไหม
           ถ้าแก้จนถูกต้องแล้ว -> ซ่อนทันที
           ถ้ายังไม่ถูก -> ค้างไว้ที่เดิม ไม่ซ่อนแม้ออกจากช่องไปแล้ว (ไม่มี blur-hide) */
        inp.addEventListener('input', function () {
            if (hasNegativeInput(this)) showFn(this);
            else hideFn(this);
        });

        /* ปิดกล่องแจ้งเตือนของเบราว์เซอร์เอง (เช่น "Value must be greater than or equal to 1.")
           ไม่ต้องการให้ขึ้นซ้อนกับข้อความแดงของเรา
           ตัวช่องจะยัง invalid ตามปกติ (กันส่ง submit ได้เหมือนเดิม) แค่ไม่โชว์ popup */
        inp.addEventListener('invalid', function (e) {
            e.preventDefault();
        });
    });
}

/* ===== กันกดบันทึกทั้งที่ยังมีค่าติดลบ/พิมพ์ค้างอยู่ในฟอร์ม
   ถ้าเจอ -> ไม่ให้ submit ไปไหน อยู่หน้าเดิม พร้อมโชว์ข้อความแจ้งเตือนทุกช่องที่ยังผิดค้างไว้ ===== */
function guardFormSubmit() {
    const formEl = document.querySelector('form');
    if (!formEl) return;

    formEl.addEventListener('submit', function (e) {
        let hasInvalid = false;
        let firstInvalid = null;

        document.querySelectorAll('input[type="number"]').forEach(function (inp) {
            if (hasNegativeInput(inp)) {
                hasInvalid = true;
                if (!firstInvalid) firstInvalid = inp;
                const isQty = inp.classList.contains('qty-mini-input');
                (isQty ? showGroupError : showFieldError)(inp);
            }
        });

        if (hasInvalid) {
            e.preventDefault();
            if (firstInvalid) firstInvalid.focus();
        }
    });
}

document.addEventListener('DOMContentLoaded', applyNoNegative);
document.addEventListener('DOMContentLoaded', guardFormSubmit);