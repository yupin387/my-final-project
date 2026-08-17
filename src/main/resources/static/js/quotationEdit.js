// ===== quotationEdit.js =====
// หน้าแก้ไขใบเสนอราคา: "มี" ปุ่ม +/- ปรับจำนวน 

const GROUP_LABELS = {
    'group-equipment':  'หมวดอุปกรณ์พิธีกรรม',
    'group-food':       'หมวดภัตตาหารปิ่นโต',
    'group-sangkathan': 'หมวดสังฆทาน',
    'group-service':    'หมวดบริการและการดำเนินการ',
    'group-extra':      'หมวดอุปกรณ์เสริม' 
};

const selectedItemIds = new Set();

// ===== ช่องจำนวน พร้อมปุ่ม +/- (เฉพาะหน้าแก้ไขเท่านั้น) =====
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
    calculateGrandTotal(); // ฟังก์ชันนี้จะถูก override โดย script ท้ายไฟล์ JSP ซึ่งคำนวณแพ็กเกจด้วย
}

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

// ===== หมวดที่กำลังเปิดดูอยู่ในป๊อปอัพตอนนี้ =====
function getCurrentCategory() {
    const activeTab = document.querySelector('.category-tab.active');
    return activeTab ? activeTab.getAttribute('data-category') : 'อุปกรณ์พิธีกรรม';
}

function ensureGroupHeader(tbody) {
    if (!tbody) return;
    if (tbody.querySelector('.group-row')) return;
    const label = GROUP_LABELS[tbody.id] || '';
    const headerRow = document.createElement('tr');
    headerRow.className = 'group-row';
    // สร้างให้ตรงกับรูปแบบ JSP ที่มี 7 คอลัมน์
    headerRow.innerHTML = `<td></td><td class="category-header-text">${label}</td><td></td><td></td><td></td><td></td><td class="delete-col"></td>`;
    tbody.prepend(headerRow);
}

function removeGroupHeaderIfEmpty(tbody) {
    if (!tbody || !tbody.id || !tbody.id.startsWith('group-')) return;
    // แถวที่ "รวมในแพ็กเกจ" (.package-included-row) นับเป็นเนื้อหาของหมวดด้วย ห้ามเอาหัวข้อออกถ้ายังเหลือแถวนี้อยู่
    const remaining = tbody.querySelectorAll('tr.static-row, tr.dynamic-row');
    if (remaining.length === 0) {
        const header = tbody.querySelector('.group-row');
        if (header) header.remove();
    }
}

function openItemModal() {
    renderItemPicker();
    document.getElementById('itemSelectionModal').style.display = 'flex';
}

function closeItemModal() {
    document.getElementById('itemSelectionModal').style.display = 'none';
}

function switchCategoryTab(tabEl, category) {
    document.querySelectorAll('.category-tab').forEach(t => t.classList.remove('active'));
    tabEl.classList.add('active');
    renderItemPicker(category);
}

function renderItemPicker(category) {
    if (!category) {
        category = getCurrentCategory();
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

// ===== "เลือกทั้งหมดในหมวดนี้" =====
function toggleSelectAllVisible(checkbox) {
    const checked = checkbox.checked;
    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) return;

    const category    = getCurrentCategory();
    const existingIds = getExistingItemIds();

    dataStore.querySelectorAll('.item-data').forEach(dataEl => {
        const itemType = dataEl.getAttribute('data-type') || '';
        if (!itemType.includes(category)) return; // เอาเฉพาะหมวดปัจจุบัน

        const itemId = String(dataEl.getAttribute('data-id'));
        if (existingIds.has(itemId)) return;

        if (checked) selectedItemIds.add(itemId);
        else selectedItemIds.delete(itemId);
    });

    renderItemPicker();
}

// ===== อัปเดตสถานะติ๊กถูกของ "เลือกทั้งหมดในหมวดนี้" =====
function updateSelectAllState() {
    const selectAllCb = document.getElementById('selectAllVisible');
    if (!selectAllCb) return;

    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) return;

    const category     = getCurrentCategory();
    const existingIds  = getExistingItemIds();
    const allSelectableIds = [...dataStore.querySelectorAll('.item-data')]
        .filter(el => (el.getAttribute('data-type') || '').includes(category))
        .map(el => String(el.getAttribute('data-id')))
        .filter(id => !existingIds.has(id));

    selectAllCb.checked = allSelectableIds.length > 0 &&
        allSelectableIds.every(id => selectedItemIds.has(id));
}

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

        // แยกปลายทางตารางตามประเภท
        let targetBody = document.getElementById('group-service');
        if (itemType.includes('อุปกรณ์พิธีกรรม')) targetBody = document.getElementById('group-equipment');
        else if (itemType.includes('อุปกรณ์เสริม')) targetBody = document.getElementById('group-extra');
        else if (itemType.includes('ภัตตาหาร')) targetBody = document.getElementById('group-food');
        else if (itemType.includes('สังฆทาน'))  targetBody = document.getElementById('group-sangkathan');

        ensureGroupHeader(targetBody);

        const tr = document.createElement('tr');
        tr.className = 'dynamic-row';
        tr.setAttribute('data-item-id', itemId);

        // ตัดช่อง DetailNotes ที่เกินมาออกให้เหลือ 7 คอลัมน์พอดี พร้อมใส่ readonly
        tr.innerHTML = `
                <td class="row-number text-center"></td>
                <td>
                    ${itemName}
                    ${itemDesc ? `<br><span class="text-muted" style="font-size:12px;">${itemDesc}</span>` : ''}
                    <input type="hidden" name="extraItemIds" value="${itemId}">
                </td>
                <td>${buildQtyCell(1, 'extraQtys')}</td>
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

function removeRow(button) {
    const row = button.closest('tr');
    const tbody = row.parentElement;

    row.remove();
    removeGroupHeaderIfEmpty(tbody);

    reIndexRows();
    calculateGrandTotal();
}

function reIndexRows() {
    // ไม่นับเลขลำดับให้แถว "รวมในแพ็กเกจ" (.package-included-row)
    const rowNumbers = document.querySelectorAll('.row-number:not(.no-index)');
    rowNumbers.forEach((td, index) => {
        td.innerText = index + 1;
    });
}

function calculateGrandTotal() {
    let packageTotal = 0.0;
    let extraTotal = 0.0;
    const discountElement = document.getElementById('discountValue');
    const discount = discountElement ? parseFloat(discountElement.value) || 0 : 0;
    const isCustomRequest = window.IS_CUSTOM_REQUEST === true;

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

            if (row.classList.contains('package-main-row')) {
                packageTotal += subtotal;
            } else if (isCustomRequest) {
                // ถ้าเป็นโหมดกรอกเอง: ทุกรายการในตาราง (รวมถึงอุปกรณ์เสริม) ให้ถือเป็น "ราคาตามรายการ" ทั้งหมด
                packageTotal += subtotal;
            } else {
                // ถ้าเป็นโหมดแพ็กเกจปกติ: รายการที่อยู่นอกแพ็กเกจถึงจะนัดเป็น extraTotal (รายการเพิ่มเติม)
                extraTotal += subtotal;
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

    let grandTotal = packageTotal + extraTotal - discount;
    if (grandTotal < 0) grandTotal = 0;

    const grandTotalSpan = document.getElementById('grandTotal');
    if (grandTotalSpan) {
        grandTotalSpan.innerText = grandTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});
    }
}
function validateForm() {
    const totalRows = document.querySelectorAll('.static-row, .dynamic-row').length;
    if (totalRows === 0) {
        alert('กรุณาระบุจำนวนนิมนต์พระ หรือเพิ่มรายการวัสดุเสริมอย่างน้อย 1 รายการ');
        return false;
    }
    return true;
}

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

window.addEventListener('load', () => {
    // แปลง qty cell ของแถวปกติให้มีปุ่ม +/-
    // ข้ามแถวที่ทำเครื่องหมาย .no-qty-convert ไว้ 
    document.querySelectorAll('.static-row:not(.no-qty-convert), .dynamic-row:not(.no-qty-convert)').forEach(row => {
        const qInput = row.querySelector('input[name="bookingQtys"], input[name="extraQtys"]');
        if (qInput) {
            const inputName = qInput.name;
            const val       = qInput.value || 1;
            const td        = qInput.closest('td');
            td.innerHTML    = buildQtyCell(val, inputName);
        }
    });

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