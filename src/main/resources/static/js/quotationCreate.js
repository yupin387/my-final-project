// ===== quotationCreate.js =====

const GROUP_LABELS = {
    'group-equipment':  'หมวดอุปกรณ์พิธีกรรม',
    'group-food':       'หมวดภัตตาหารปิ่นโต',
    'group-sangkathan': 'หมวดสังฆทาน',
    'group-service':    'หมวดบริการและการดำเนินการ',
    'group-extra':      'หมวดอุปกรณ์เสริม' 
};

const selectedItemIds = new Set();

// แสดงจำนวน + ไอคอนปากกา (กดแล้วค่อยเปลี่ยนเป็นปุ่ม -/+)
function buildQtyCell(value, inputName, isEditable) {
    if (isEditable) {
        return `
            <div class="qty-wrapper" data-mode="view">
                <span class="qty-display">${value}</span>
                <input type="number" name="${inputName}" value="${value}" min="1" class="qty-input" readonly style="display:none;">
                <button type="button" class="btn-qty-minus" onclick="adjustQty(this, -1)" style="display:none;">-</button>
                <button type="button" class="btn-qty-plus" onclick="adjustQty(this, 1)" style="display:none;">+</button>
                <button type="button" class="btn-qty-edit" onclick="toggleQtyEdit(this)" title="แก้ไขจำนวน">✏️</button>
            </div>`;
    }
    return `
        <div class="qty-wrapper">
            <input type="number" name="${inputName}" value="${value}" min="1" class="qty-input" readonly>
        </div>`;
}

// สลับโหมด: กดปากกา -> โชว์ปุ่ม -/+ , กดซ้ำ -> กลับเป็นตัวเลขเฉยๆ
function toggleQtyEdit(btn) {
    const wrapper = btn.closest('.qty-wrapper');
    const display = wrapper.querySelector('.qty-display');
    const input   = wrapper.querySelector('.qty-input');
    const minus   = wrapper.querySelector('.btn-qty-minus');
    const plus    = wrapper.querySelector('.btn-qty-plus');

    const isEditing = wrapper.getAttribute('data-mode') === 'edit';

    if (isEditing) {
        wrapper.setAttribute('data-mode', 'view');
        display.style.display = '';
        input.style.display = 'none';
        minus.style.display = 'none';
        plus.style.display = 'none';
        btn.textContent = '✏️';
    } else {
        wrapper.setAttribute('data-mode', 'edit');
        display.style.display = 'none';
        input.style.display = '';
        minus.style.display = '';
        plus.style.display = '';
        btn.textContent = '✕';
    }
}

// ฟังก์ชันกดปรับเพิ่ม/ลดจำนวน
function adjustQty(btn, delta) {
    const wrapper = btn.parentElement;
    const input   = wrapper.querySelector('.qty-input');
    const display = wrapper.querySelector('.qty-display');
    let val = parseInt(input.value) || 1;
    val = val + delta;

    // ถ้าน้อยกว่าหรือเท่ากับ 0 จะถามเพื่อลบรายการทิ้ง
    if (val <= 0) {
        if (confirm('คุณต้องการลบรายการนี้ออกจากใบเสนอราคาใช่หรือไม่?')) {
            const row = btn.closest('tr');
            const tbody = row.parentElement;
            row.remove();
            removeGroupHeaderIfEmpty(tbody);
            reIndexRows();
            calculateGrandTotal();
        }
        return;
    }

    input.value = val;
    if (display) display.textContent = val;
    calculateGrandTotal();
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

function getCurrentCategory() {
    const activeTab = document.querySelector('.category-tab.active');
    return activeTab ? activeTab.getAttribute('data-category') : 'อุปกรณ์พิธีกรรม';
}

// สร้างหัวข้อหมวดหมู่ โดยข้อความจะอยู่แค่คอลัมน์ 2 เท่านั้น และมีเซลล์ว่างสำหรับคอลัมน์อื่นเพื่อให้ตีเส้นได้ตามภาพ
function ensureGroupHeader(tbody) {
    if (!tbody) return;
    if (tbody.querySelector('.group-row')) return;
    const label = GROUP_LABELS[tbody.id] || '';
    const headerRow = document.createElement('tr');
    headerRow.className = 'group-row';
    headerRow.innerHTML =
        `<td class="no-index"></td>` +
        `<td class="category-header-text">${label}</td>` +
        `<td></td><td></td><td></td><td></td>`;
    tbody.prepend(headerRow);
}

function removeGroupHeaderIfEmpty(tbody) {
    if (!tbody || !tbody.id || !tbody.id.startsWith('group-')) return;
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

function toggleSelectAllVisible(checkbox) {
    const checked = checkbox.checked;
    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) return;

    const category    = getCurrentCategory();
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

        const isEquipment = itemType.includes('อุปกรณ์พิธีกรรม'); 
        const isExtra     = itemType.includes('อุปกรณ์เสริม');    

        const scalesByMonk = itemName.includes('ต่อรูป') || itemDesc.includes('ต่อรูป');
        const monkCount    = parseInt(window.CEREMONY_MONK_COUNT, 10) || 1;
        const initialQty   = scalesByMonk ? monkCount : 1;

        let targetBody = document.getElementById('group-service');
        if (isEquipment) targetBody = document.getElementById('group-equipment');
        else if (isExtra) targetBody = document.getElementById('group-extra');
        else if (itemType.includes('ภัตตาหาร')) targetBody = document.getElementById('group-food');
        else if (itemType.includes('สังฆทาน'))  targetBody = document.getElementById('group-sangkathan');

        ensureGroupHeader(targetBody);

        const tr = document.createElement('tr');
        tr.className = 'dynamic-row';
        tr.setAttribute('data-item-id', itemId);

        const showDesc = !!itemDesc && !isEquipment;

        tr.innerHTML = `
                <td class="row-number text-center"></td>
                <td>
                    ${itemName}
                    ${showDesc ? `<br><span class="text-muted" style="font-size:12px;">${itemDesc}</span>` : ''}
                    <input type="hidden" name="extraItemIds" value="${itemId}">
                </td>
                <td>
                    ${buildQtyCell(initialQty, 'extraQtys', isExtra)}
                </td>
                <td class="text-center">${unit}</td>
                <td>
                    <input type="number" name="extraPrices" value="${price.toFixed(2)}" step="0.01" min="0" class="clean-input text-right price-input" readonly>
                </td>
                <td class="text-right"><span class="subtotal">0.00</span></td>`;

        targetBody.appendChild(tr);
    });

    selectedItemIds.clear();
    closeItemModal();
    reIndexRows();
    calculateGrandTotal();
}

function reIndexRows() {
    const rowNumbers = document.querySelectorAll('.row-number:not(.no-index)');
    rowNumbers.forEach((td, index) => {
        td.innerText = index + 1;
    });
}

function calculateGrandTotal() {
    let packageTotal = 0.0;
    let extraTotal = 0.0;
    
    const discountEl = document.getElementById('discountValue');
    const discount = discountEl ? (parseFloat(discountEl.value) || 0) : 0;
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
            
            const parentTbody = row.closest('tbody');
            const isManuallyAddedExtra = parentTbody && parentTbody.id === 'group-extra';

            if (row.classList.contains('package-main-row')) {
                packageTotal += subtotal;
            } else if (isCustomRequest && !isManuallyAddedExtra) {
                packageTotal += subtotal;
            } else {
                extraTotal += subtotal;
            }
        }
    });

    const summaryPackage = document.getElementById('summaryPackage');
    if (summaryPackage) summaryPackage.innerText = packageTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});

    const summaryExtra = document.getElementById('summaryExtra');
    if (summaryExtra) summaryExtra.innerText = extraTotal.toLocaleString('th-TH', {minimumFractionDigits: 2});

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
    const dd = document.getElementById('dropdownMenu');
    if (dd) dd.classList.toggle('show');
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