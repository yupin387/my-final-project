
/* =========================================
   1) ผูกประเภทงาน (แพ็กเกจ) กับอุปกรณ์
   ========================================= */

// เปิด/ปิดช่องกรอกจำนวนตามการติ๊กเลือกแพ็กเกจ
function toggleQtyInput(checkbox, qtyInputId) {
    var qtyInput = document.getElementById(qtyInputId);
    if (!qtyInput) return;
    qtyInput.disabled = !checkbox.checked;
    if (checkbox.checked && !qtyInput.value) {
        qtyInput.value = 1;
    }
    syncSelectAllState(checkbox.getAttribute('data-group'));
}

// ติ๊ก/ยกเลิก "เลือกทั้งหมด" ของกลุ่ม
function onSelectAllChange(selectAllBox) {
    var groupKey  = selectAllBox.getAttribute('data-group');
    var container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
    if (!container) return;

    var checked = selectAllBox.checked;
    container.querySelectorAll('input[type="checkbox"]').forEach(function (cb) {
        cb.checked = checked;
        var qtyInput = document.getElementById('qty_' + cb.value);
        if (qtyInput) {
            qtyInput.disabled = !checked;
            if (checked && !qtyInput.value) qtyInput.value = 1;
        }
    });
    selectAllBox.indeterminate = false;
}

// อัปเดตสถานะช่อง "เลือกทั้งหมด" ให้ตรงกับที่ติ๊กอยู่จริง (ทั้งหมด / บางส่วน / ไม่มี)
function syncSelectAllState(groupKey) {
    var container    = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
    var selectAllBox = document.querySelector('.select-all-checkbox[data-group="' + groupKey + '"]');
    if (!container || !selectAllBox) return;

    var boxes = container.querySelectorAll('input[type="checkbox"]');
    var total = boxes.length;
    var checkedCount = 0;
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

/* ปิดกลุ่ม: ยกเลิกการติ๊กทั้งหมดในกลุ่ม แล้วซ่อนกลุ่มนั้นกลับไป
   นี่คือวิธีเดียวที่ "เอาแพ็กเกจที่เลือกผิดออก" — เลือกชื่อเดิมซ้ำใน dropdown ด้านบน
   จะไม่มีผล เพราะกลุ่มถูกเปิดค้างอยู่แล้ว ต้องกดปุ่ม ✕ นี้แทน */
function closeGroup(groupKey) {
    var group = document.getElementById(groupKey);
    if (!group) return;

    var container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
    if (container) {
        container.querySelectorAll('input[type="checkbox"]').forEach(function (cb) {
            cb.checked = false;
            var qtyInput = document.getElementById('qty_' + cb.value);
            if (qtyInput) qtyInput.disabled = true;
        });
    }

    var selectAllBox = document.querySelector('.select-all-checkbox[data-group="' + groupKey + '"]');
    if (selectAllBox) {
        selectAllBox.checked = false;
        selectAllBox.indeterminate = false;
    }

    group.style.display = 'none';
    updateEmptyHint();
}

// แสดง/ซ่อนข้อความ "ยังไม่ได้เพิ่มประเภทงานไหนเลย"
function updateEmptyHint() {
    var hint   = document.getElementById('ceremonyEmptyHint');
    var groups = document.querySelectorAll('#selectedCeremonyGroups .ceremony-type-group');
    var hasVisible = false;
    groups.forEach(function (g) {
        if (g.style.display !== 'none') hasVisible = true;
    });
    if (hint) hint.style.display = hasVisible ? 'none' : 'block';
}

// เลือกประเภทงานจาก dropdown -> เปิดกลุ่มนั้นขึ้นมา
document.getElementById('ceremonyTypeAdder').addEventListener('change', function () {
    var groupKey = this.value;
    if (!groupKey) return;

    var group = document.getElementById(groupKey);
    if (group) group.style.display = 'block';

    this.value = '';
    updateEmptyHint();
});

document.addEventListener('DOMContentLoaded', updateEmptyHint);

/* =========================================
   2) แจ้งเตือนเลขติดลบแบบเรียลไทม์ (ไม่บล็อกการพิมพ์)

   หมายเหตุสำคัญ: input type="number" ของเบราว์เซอร์ ถ้าพิมพ์ "-" เดี่ยวๆ
   (ยังไม่ตามด้วยตัวเลข) ค่า .value จะเป็นค่าว่างเสมอ
   ต้องเช็ค validity.badInput ร่วมด้วยถึงจะจับได้ว่าพิมพ์ - อยู่จริง

   - ช่อง "ใช้...หน่วย" (qty-mini-input) -> ข้อความขึ้นท้ายกรอบของกลุ่มพิธีนั้น
   - ช่อง "ราคาต่อหน่วย"                 -> ข้อความขึ้นใต้ช่องนั้น
   ========================================= */

function isMinusKey(e) {
    return e.key === '-' || e.key === 'Subtract' || e.keyCode === 189 || e.keyCode === 109;
}

function hasNegativeInput(inp) {
    return inp.value.indexOf('-') !== -1 || inp.validity.badInput;
}

/* ---- (1) กลุ่ม qty ---- */
function getGroupErrorEl(groupEl) {
    var id = 'negerr_' + groupEl.id;
    var el = document.getElementById(id);
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
    var groupEl = qtyInput.closest('.ceremony-type-group');
    if (!groupEl) return;
    var el = getGroupErrorEl(groupEl);
    el.textContent = 'ห้ามใส่เลขติดลบ';
    el.style.display = 'block';
}

function hideGroupError(qtyInput) {
    var groupEl = qtyInput.closest('.ceremony-type-group');
    if (!groupEl) return;
    var el = document.getElementById('negerr_' + groupEl.id);
    if (el) el.style.display = 'none';
}

/* ---- (2) ช่องราคาต่อหน่วย ---- */
function getFieldErrorEl(inp) {
    var id = 'negerr_' + (inp.id || inp.name);
    var el = document.getElementById(id);
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
    var el = getFieldErrorEl(inp);
    el.textContent = 'ห้ามใส่เลขติดลบ';
    el.style.display = 'block';
}

function hideFieldError(inp) {
    var el = document.getElementById('negerr_' + (inp.id || inp.name));
    if (el) el.style.display = 'none';
}

function applyNoNegative() {
    document.querySelectorAll('input[type="number"]').forEach(function (inp) {
        if (inp.dataset.noNegativeBound) return; // กันผูก event ซ้ำ
        inp.dataset.noNegativeBound = '1';

        var isQty  = inp.classList.contains('qty-mini-input');
        var showFn = isQty ? showGroupError : showFieldError;
        var hideFn = isQty ? hideGroupError : hideFieldError;

        // พิมพ์ - ปุ๊บ โชว์ทันที (ไม่ preventDefault ปล่อยให้พิมพ์ได้)
        inp.addEventListener('keydown', function (e) {
            if (isMinusKey(e)) showFn(this);
        });

        // หลังค่าเปลี่ยน เช็คซ้ำว่ายังติดลบอยู่ไหม: แก้ถูกแล้วซ่อน, ยังผิดก็ค้างไว้
        inp.addEventListener('input', function () {
            if (hasNegativeInput(this)) showFn(this);
            else hideFn(this);
        });

        // ปิด popup แจ้งเตือนของเบราว์เซอร์เอง ไม่ให้ซ้อนกับข้อความแดงของเรา
        // (ช่องยัง invalid ตามปกติ จึงยังกัน submit ได้เหมือนเดิม)
        inp.addEventListener('invalid', function (e) {
            e.preventDefault();
        });
    });
}

// กันกดบันทึกทั้งที่ยังมีค่าติดลบ/พิมพ์ค้างอยู่ในฟอร์ม
function guardFormSubmit() {
    var formEl = document.querySelector('form.form-section');
    if (!formEl) return;

    formEl.addEventListener('submit', function (e) {
        var hasInvalid = false;
        var firstInvalid = null;

        document.querySelectorAll('input[type="number"]').forEach(function (inp) {
            if (hasNegativeInput(inp)) {
                hasInvalid = true;
                if (!firstInvalid) firstInvalid = inp;
                var isQty = inp.classList.contains('qty-mini-input');
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