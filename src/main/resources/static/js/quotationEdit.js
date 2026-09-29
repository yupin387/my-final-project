// ===== quotationEdit.js =====
// หน้าแก้ไขใบเสนอราคา: มีปุ่ม +/- ปรับจำนวน
// รวมโค้ดที่เคยเขียนไว้ใน <script> ท้ายไฟล์ JSP เข้ามาไว้ที่นี่ทั้งหมดแล้ว
//
// ค่าที่ต้องกำหนดจาก JSP ก่อนโหลดไฟล์นี้:
//   window.CEREMONY_MONK_COUNT  (จำนวนพระ)
//   window.IS_CUSTOM_REQUEST    (true/false)

// ---------- ค่าคงที่ ----------
const GROUP_LABELS = {
    'group-equipment':  'หมวดอุปกรณ์พิธีกรรม',
    'group-food':       'หมวดภัตตาหารปิ่นโต',
    'group-sangkathan': 'หมวดสังฆทาน',
    'group-service':    'หมวดบริการและการดำเนินการ',
    'group-extra':      'หมวดอุปกรณ์เสริม'
};

// tbody id -> ชื่อหมวด (ใช้ส่งให้ openItemModal ตอนกดปุ่ม +)
const GROUP_CATEGORY = {
    'group-equipment':  'อุปกรณ์พิธีกรรม',
    'group-food':       'ภัตตาหาร',
    'group-sangkathan': 'สังฆทาน',
    'group-service':    'บริการ',
    'group-extra':      'อุปกรณ์เสริม'
};

// ป้ายหมวดหมู่ สำหรับตั้งชื่อหัวข้อป๊อปอัพ
const CATEGORY_LABELS_EDIT = {
    'อุปกรณ์พิธีกรรม': 'อุปกรณ์พิธีกรรม',
    'ภัตตาหาร':        'ภัตตาหารปิ่นโต',
    'สังฆทาน':         'สังฆทาน',
    'บริการ':          'บริการและดำเนินการ',
    'อุปกรณ์เสริม':     'อุปกรณ์เสริม'
};

// หมวดที่อนุญาตให้โชว์รายละเอียด (itemDetail) ตอนเพิ่มรายการเข้าตาราง
const CATEGORIES_WITH_DESC = ['สังฆทาน', 'ภัตตาหาร'];

const selectedItemIds = new Set();

// หมวดหมู่ที่กำลังเปิดป๊อปอัพอยู่ ณ ขณะนี้
let currentEditCategory = null;

// ---------- ช่องจำนวน พร้อมปุ่ม +/- ----------
function buildQtyCell(value, inputName) {
    return `
        <div class="qty-wrapper">
            <button type="button" class="btn-qty-minus" onclick="adjustQty(this, -1)">−</button>
            <input type="number" name="${inputName}" value="${value}" min="1"
                class="qty-input clean-input text-center" onchange="calculateGrandTotal()">
            <button type="button" class="btn-qty-plus" onclick="adjustQty(this, 1)">+</button>
        </div>`;
}

function adjustQty(btn, delta) {
    const input = btn.parentElement.querySelector('.qty-input');
    let val = parseInt(input.value) || 1;
    val = Math.max(1, val + delta);
    input.value = val;
    calculateGrandTotal();
}

// ---------- ตรวจรายการที่อยู่ในตารางแล้ว ----------
function getExistingItemIds() {
    const ids = new Set();
    document.querySelectorAll('tr[data-item-id]').forEach(tr => {
        ids.add(String(tr.getAttribute('data-item-id')));
    });
    document.querySelectorAll('tr.static-row[data-injected-id]').forEach(tr => {
        ids.add(String(tr.getAttribute('data-injected-id')));
    });
    return ids;
}

// ---------- หัวข้อหมวดหมู่ในตาราง ----------
function ensureGroupHeader(tbody) {
    if (!tbody) return;
    if (tbody.querySelector('.group-row')) return;

    const label    = GROUP_LABELS[tbody.id] || '';
    const category = GROUP_CATEGORY[tbody.id] || '';

    const headerRow = document.createElement('tr');
    headerRow.className = 'group-row';
    headerRow.innerHTML =
        '<td class="no-index"></td>' +
        '<td class="category-header-text">' + label +
        (category
            ? ' <button type="button" class="btn-add-group-inline" onclick="openItemModal(\'' + category + '\')" title="เพิ่มรายการหมวดนี้">+</button>'
            : '') +
        '</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>';
    tbody.prepend(headerRow);
}

function removeGroupHeaderIfEmpty(tbody) {
    if (!tbody || !tbody.id || !tbody.id.startsWith('group-')) return;
    // แถวที่ "รวมในแพ็กเกจ" (.package-included-row) ไม่นับ เพราะไม่ใช่ .static-row/.dynamic-row ที่ลบได้
    const remaining = tbody.querySelectorAll('tr.static-row, tr.dynamic-row');
    if (remaining.length === 0) {
        const header = tbody.querySelector('.group-row');
        if (header) header.remove();
    }
}

// ---------- ป๊อปอัพเลือกรายการ ----------
function getCurrentCategory() {
    return currentEditCategory;
}

// เปิดป๊อปอัพเพิ่มรายการ โดยระบุหมวดจากปุ่ม + ของแต่ละหมวด
function openItemModal(category) {
    currentEditCategory = category || null;

    const title = document.getElementById('itemModalTitle');
    if (title) {
        title.textContent = currentEditCategory
            ? 'เพิ่มรายการหมวด: ' + (CATEGORY_LABELS_EDIT[currentEditCategory] || currentEditCategory)
            : 'เลือกรายการเพิ่มเติม';
    }

    renderItemPicker(currentEditCategory);
    document.getElementById('itemSelectionModal').style.display = 'flex';
}

function closeItemModal() {
    document.getElementById('itemSelectionModal').style.display = 'none';
    selectedItemIds.clear();
    currentEditCategory = null;
}

function renderItemPicker(category) {
    if (!category) {
        category = getCurrentCategory() || '';
    }

    const grid = document.getElementById('itemPickerGrid');
    const existingIds = getExistingItemIds();
    grid.innerHTML = '';

    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) {
        grid.innerHTML = '<div class="popup-empty"><span style="font-size:2rem;display:block;margin-bottom:8px;">⚠️</span>ไม่พบข้อมูลรายการสินค้า</div>';
        return;
    }

    const items = dataStore.querySelectorAll('.item-data');
    let count = 0;

    items.forEach(dataEl => {
        const itemId   = String(dataEl.getAttribute('data-id'));
        const itemName = dataEl.getAttribute('data-name');
        const itemDesc = dataEl.getAttribute('data-detail') || '';
        const unit     = dataEl.getAttribute('data-unit');
        const price    = parseFloat(dataEl.getAttribute('data-price')) || 0;
        const itemType = dataEl.getAttribute('data-type') || '';

        // แสดงเฉพาะรายการที่ตรงกับหมวดปัจจุบันเท่านั้น
        if (!itemType.includes(category)) return;

        count++;
        const isExist   = existingIds.has(itemId);
        const isChecked = selectedItemIds.has(itemId);

        const card = document.createElement('label');
        card.className = 'item-pick-card' + (isExist ? ' disabled' : '') + (isChecked ? ' selected' : '');

        card.innerHTML = `
            <input type="checkbox" class="popup-item-checkbox"
                value="${itemId}"
                data-name="${itemName}"
                data-detail="${itemDesc}"
                data-unit="${unit}"
                data-price="${price}"
                data-type="${itemType}"
                ${isExist ? 'disabled' : ''}
                ${isChecked ? 'checked' : ''}>
            <div class="item-pick-info">
                <div class="item-pick-header">
                    <span class="item-pick-name">${itemName}</span>
                </div>
                ${itemDesc ? `<span class="item-pick-desc">${itemDesc}</span>` : ''}
                <div class="item-pick-meta">
                    <span class="item-pick-unit">หน่วย: ${unit}</span>
                    <span class="item-pick-price">฿${price.toLocaleString('th-TH', {minimumFractionDigits: 2})}</span>
                </div>
                ${isExist ? '<span class="item-already-added">✓ เพิ่มแล้ว</span>' : ''}
            </div>`;

        card.addEventListener('click', function (e) {
            if (isExist) return;
            const cb = card.querySelector('input[type="checkbox"]');
            if (e.target !== cb) cb.checked = !cb.checked;

            if (cb.checked) selectedItemIds.add(itemId);
            else selectedItemIds.delete(itemId);

            updateCardSelected(card, cb.checked);
            updateSelectAllState();
            updateSelectedCount();
        });

        grid.appendChild(card);
    });

    if (count === 0) {
        grid.innerHTML = '<div class="popup-empty"><span style="font-size:2.5rem;display:block;margin-bottom:10px;">🔍</span>ไม่มีรายการในหมวดหมู่นี้</div>';
    }

    updateSelectAllState();
    updateSelectedCount();
}

function updateCardSelected(card, selected) {
    if (selected) card.classList.add('selected');
    else card.classList.remove('selected');
}

function updateSelectedCount() {
    const count = selectedItemIds.size;
    const el = document.getElementById('selectedCount');
    if (el) el.textContent = count;

    const submitBtn = document.querySelector('.btn-submit-modal');
    if (submitBtn) submitBtn.style.opacity = count > 0 ? '1' : '0.65';
}

// "เลือกทั้งหมดในหมวดนี้"
function toggleSelectAllVisible(checkbox) {
    const checked = checkbox.checked;
    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) return;

    const category    = getCurrentCategory() || '';
    const existingIds = getExistingItemIds();

    dataStore.querySelectorAll('.item-data').forEach(dataEl => {
        const itemType = dataEl.getAttribute('data-type') || '';
        if (!itemType.includes(category)) return;

        const itemId = String(dataEl.getAttribute('data-id'));
        if (existingIds.has(itemId)) return;

        if (checked) selectedItemIds.add(itemId);
        else selectedItemIds.delete(itemId);
    });

    renderItemPicker();
}

// อัปเดตสถานะติ๊กถูกของ "เลือกทั้งหมดในหมวดนี้"
function updateSelectAllState() {
    const selectAllCb = document.getElementById('selectAllVisible');
    if (!selectAllCb) return;

    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) return;

    const category    = getCurrentCategory() || '';
    const existingIds = getExistingItemIds();
    const allSelectableIds = [...dataStore.querySelectorAll('.item-data')]
        .filter(el => (el.getAttribute('data-type') || '').includes(category))
        .map(el => String(el.getAttribute('data-id')))
        .filter(id => !existingIds.has(id));

    selectAllCb.checked = allSelectableIds.length > 0 &&
        allSelectableIds.every(id => selectedItemIds.has(id));
}

// ---------- เพิ่มรายการที่เลือกลงตาราง ----------
function addSelectedItemsToTable() {
    if (selectedItemIds.size === 0) {
        alert('กรุณาเลือกรายการอย่างน้อย 1 รายการ');
        return;
    }

    const dataStore = document.getElementById('itemDataStore');

    selectedItemIds.forEach(itemId => {
        const dataEl = dataStore.querySelector(`.item-data[data-id="${itemId}"]`);
        if (!dataEl) return;

        const itemName = dataEl.getAttribute('data-name');
        const itemDesc = dataEl.getAttribute('data-detail') || '';
        const price    = parseFloat(dataEl.getAttribute('data-price')) || 0;
        const unit     = dataEl.getAttribute('data-unit');
        const itemType = dataEl.getAttribute('data-type') || '';

        // รายการที่คิดตามจำนวนพระ ("ต่อรูป") ให้ตั้งจำนวนเริ่มต้นเท่ากับจำนวนพระ
        const scalesByMonk = itemName.includes('ต่อรูป') || itemDesc.includes('ต่อรูป');
        const monkCount    = parseInt(window.CEREMONY_MONK_COUNT, 10) || 1;
        const initialQty   = scalesByMonk ? monkCount : 1;

        // แยกปลายทางตารางตามประเภท
        let targetBody = document.getElementById('group-service');
        if (itemType.includes('อุปกรณ์พิธีกรรม')) targetBody = document.getElementById('group-equipment');
        else if (itemType.includes('อุปกรณ์เสริม')) targetBody = document.getElementById('group-extra');
        else if (itemType.includes('ภัตตาหาร'))    targetBody = document.getElementById('group-food');
        else if (itemType.includes('สังฆทาน'))     targetBody = document.getElementById('group-sangkathan');

        // หมวดนี้ไม่มีในโหมดปัจจุบัน (เช่น แพ็กเกจไม่มีหมวดอุปกรณ์พิธีกรรม/บริการ)
        if (!targetBody) return;

        ensureGroupHeader(targetBody);

        // โชว์รายละเอียด (itemDetail) เฉพาะหมวดสังฆทานกับภัตตาหารเท่านั้น
        const allowDescForCategory = CATEGORIES_WITH_DESC.some(cat => itemType.includes(cat));
        const showDesc = !!itemDesc && allowDescForCategory;

        const tr = document.createElement('tr');
        tr.className = 'dynamic-row';
        tr.setAttribute('data-item-id', itemId);

        tr.innerHTML = `
                <td class="row-number text-center"></td>
                <td>${itemName}${showDesc ? `<br><span class="text-muted" style="font-size:12px;">${itemDesc}</span>` : ''}<input type="hidden" name="extraItemIds" value="${itemId}"></td>
                <td>${buildQtyCell(initialQty, 'extraQtys')}</td>
                <td class="text-center">${unit}</td>
                <td>
                    <input type="number" name="extraPrices" value="${price.toFixed(2)}"
                        step="0.01" min="0" class="clean-input text-right price-input" onchange="calculateGrandTotal()" readonly>
                </td>
                <td class="text-right"><span class="subtotal">0.00</span></td>
                <td class="text-center delete-col">
                    <button type="button" class="btn-remove" onclick="removeRow(this)">🗑️</button>
                </td>`;

        targetBody.appendChild(tr);
    });

    selectedItemIds.clear();
    closeItemModal();
    reIndexRows();
    calculateGrandTotal();
}

// ---------- ลบแถว / เรียงลำดับใหม่ ----------
function removeRow(button) {
    const row = button.closest('tr');
    const tbody = row.parentElement;

    row.remove();
    removeGroupHeaderIfEmpty(tbody);

    reIndexRows();
    calculateGrandTotal();
}

function reIndexRows() {
    // ไม่นับเลขลำดับให้แถว "รวมในแพ็กเกจ" (.no-index)
    const rowNumbers = document.querySelectorAll('.row-number:not(.no-index)');
    rowNumbers.forEach((td, index) => {
        td.innerText = index + 1;
    });
}

// ---------- คำนวณยอดรวม ----------
function calculateGrandTotal() {
    let packageTotal = 0.0;
    let extraTotal = 0.0;
    const discountElement = document.getElementById('discountValue');
    const discount = discountElement ? parseFloat(discountElement.value) || 0 : 0;
    const isCustomRequest = window.IS_CUSTOM_REQUEST === true;
    const extraItemNames = [];

    document.querySelectorAll('.static-row, .dynamic-row').forEach(row => {
        if (row.classList.contains('package-included-row')) return;

        const qInput = row.querySelector('input[name="extraQtys"], input[name="bookingQtys"]');
        const pInput = row.querySelector('input[name="extraPrices"], input[name="bookingPrices"]');

        if (qInput && pInput) {
            const qty      = parseFloat(qInput.value) || 0;
            const price    = parseFloat(pInput.value) || 0;
            const subtotal = qty * price;

            const subtotalSpan = row.querySelector('.subtotal');
            if (subtotalSpan) {
                subtotalSpan.innerText = subtotal.toLocaleString('th-TH', {minimumFractionDigits: 2});
            }

            const parentTbody = row.closest('tbody');
            const isManuallyAddedExtra = parentTbody && parentTbody.id === 'group-extra';

            if (row.classList.contains('package-main-row')) {
                packageTotal += subtotal;
            } else if (isCustomRequest && !isManuallyAddedExtra) {
                // กรอกความต้องการเอง: รายการอุปกรณ์/สังฆทาน/อาหาร/บริการ ถือเป็น "รายการหลัก" ไม่ใช่ของเพิ่มเติม
                packageTotal += subtotal;
            } else {
                extraTotal += subtotal;

                // เก็บชื่อรายการไว้แสดงใต้ label "รายการเพิ่มเติม" (ข้ามรายการที่ฟรี/รวมในแพ็กเกจ)
                const isFreeItem = !!row.querySelector('.text-danger');
                if (!isFreeItem) {
                    const nameCell = row.children[1];
                    const nameText = (nameCell && nameCell.childNodes[0])
                        ? nameCell.childNodes[0].textContent.trim() : '';
                    if (nameText) extraItemNames.push(nameText);
                }
            }
        }
    });

    const summaryPackage = document.getElementById('summaryPackage');
    if (summaryPackage) {
        summaryPackage.innerText = packageTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});
    }

    const summaryExtra = document.getElementById('summaryExtra');
    if (summaryExtra) {
        summaryExtra.innerText = extraTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});
    }

    const extraDetailDiv = document.getElementById('extraItemsDetail');
    if (extraDetailDiv) {
        extraDetailDiv.innerText = extraItemNames.length ? ('(' + extraItemNames.join(', ') + ')') : '';
    }

    let grandTotal = packageTotal + extraTotal - discount;
    if (grandTotal < 0) grandTotal = 0;

    const grandTotalSpan = document.getElementById('grandTotal');
    if (grandTotalSpan) {
        grandTotalSpan.innerText = grandTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});
    }
}

// ---------- ตรวจฟอร์มก่อนส่ง ----------
function validateForm() {
    const totalRows = document.querySelectorAll('.static-row, .dynamic-row').length;
    if (totalRows === 0) {
        alert('กรุณาระบุจำนวนนิมนต์พระ หรือเพิ่มรายการวัสดุเสริมอย่างน้อย 1 รายการ');
        return false;
    }
    return true;
}

// ---------- Navbar dropdown ----------
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

window.addEventListener('click', (e) => {
    const modal = document.getElementById('itemSelectionModal');
    if (e.target === modal) closeItemModal();

    if (!e.target.closest('.user-info')) {
        const dd = document.getElementById('dropdownMenu');
        if (dd) dd.classList.remove('show');
    }
});

// ---------- เริ่มต้นหน้า ----------
window.addEventListener('load', () => {
    // แปลง qty cell ของแถวปกติให้มีปุ่ม +/- (ข้ามแถวที่มี .no-qty-convert)
    document.querySelectorAll('.static-row:not(.no-qty-convert), .dynamic-row:not(.no-qty-convert)').forEach(row => {
        const qInput = row.querySelector('input[name="bookingQtys"], input[name="extraQtys"]');
        if (qInput) {
            const inputName = qInput.name;
            const val       = qInput.value || 1;
            const td        = qInput.closest('td');
            td.innerHTML    = buildQtyCell(val, inputName);
        }
    });

    // ผูก data-injected-id ให้แถวที่ไม่มี data-item-id เพื่อกันเพิ่มรายการซ้ำ
    const nameToId = {};
    document.querySelectorAll('#itemDataStore .item-data').forEach(dataEl => {
        nameToId[dataEl.getAttribute('data-name')] = dataEl.getAttribute('data-id');
    });

    document.querySelectorAll('tr.static-row:not([data-item-id])').forEach(row => {
        const nameInput = row.querySelector('input[name="bookingItemNames"]');
        if (nameInput) {
            const id = nameToId[nameInput.value];
            if (id) row.setAttribute('data-injected-id', id);
        }
    });

    reIndexRows();
    calculateGrandTotal();
});