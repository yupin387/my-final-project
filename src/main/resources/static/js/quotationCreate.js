// ===== ฟังก์ชันสร้าง HTML สำหรับปุ่ม +/- และ input จำนวน =====
function buildQtyCell(value, inputName) {
    return `
        <div class="qty-wrapper">
            <button type="button" class="btn-qty-minus" onclick="adjustQty(this, -1)">−</button>
            <input type="number" name="${inputName}" value="${value}" min="1"
                class="qty-input" onchange="calculateGrandTotal()">
            <button type="button" class="btn-qty-plus" onclick="adjustQty(this, 1)">+</button>
        </div>`;
}
// ===== ฟังก์ชันปรับค่าจำนวน (+/-) =====
function adjustQty(btn, delta) {
    const input = btn.parentElement.querySelector('.qty-input');
    let val = parseInt(input.value) || 1;
    val = Math.max(1, val + delta);
    input.value = val;
    calculateGrandTotal();
}

// ===== สร้าง Set ของ itemId ทั้งหมดที่อยู่ในตารางแล้ว =====
function getExistingItemIds() {
    const ids = new Set();
    document.querySelectorAll('tr[data-item-id]').forEach(tr => {
        ids.add(tr.getAttribute('data-item-id'));
    });
    document.querySelectorAll('tr.static-row[data-injected-id]').forEach(tr => {
        ids.add(tr.getAttribute('data-injected-id'));
    });
    return ids;
}

// ===== เปิด/ปิด Modal =====
function openItemModal() {
    renderItemPicker(); // render ก่อนแสดง
    document.getElementById('itemSelectionModal').style.display = 'flex';
}

function closeItemModal() {
    document.getElementById('itemSelectionModal').style.display = 'none';
}

// ===== สลับแท็บหมวดหมู่ =====
function switchCategoryTab(tabEl, category) {
    document.querySelectorAll('.category-tab').forEach(t => t.classList.remove('active'));
    tabEl.classList.add('active');
    renderItemPicker(category);
}

// ===== วาด grid การ์ดเลือกรายการ ตามหมวดหมู่ที่เลือก =====
function renderItemPicker(category) {
    if (!category) {
        const activeTab = document.querySelector('.category-tab.active');
        category = activeTab ? activeTab.getAttribute('data-category') : 'all';
    }

    const grid = document.getElementById('itemPickerGrid');
    const existingIds = getExistingItemIds();
    grid.innerHTML = '';

    // ดึงข้อมูลจาก #itemDataStore
    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) {
        grid.innerHTML = '<div class="popup-empty"><span style="font-size:2rem;display:block;margin-bottom:8px;">⚠️</span>ไม่พบข้อมูลรายการสินค้า</div>';
        return;
    }

    const items = dataStore.querySelectorAll('.item-data');
    let count = 0;

    items.forEach(dataEl => {
        const itemId   = dataEl.getAttribute('data-id');
        const itemName = dataEl.getAttribute('data-name');
        const itemDesc = dataEl.getAttribute('data-detail') || '';
        const unit     = dataEl.getAttribute('data-unit');
        const price    = parseFloat(dataEl.getAttribute('data-price')) || 0;
        const itemType = dataEl.getAttribute('data-type') || '';

        // กรองตามหมวดหมู่
        if (category !== 'all' && !itemType.includes(category)) return;

        count++;
        const isExist = existingIds.has(String(itemId));

        const card = document.createElement('label');
        card.className = 'item-pick-card' + (isExist ? ' disabled' : '');

        card.innerHTML = `
            <input type="checkbox" class="popup-item-checkbox"
                value="${itemId}"
                data-name="${itemName}"
                data-detail="${itemDesc}"
                data-unit="${unit}"
                data-price="${price}"
                data-type="${itemType}"
                ${isExist ? 'disabled' : ''}>
            <div class="item-pick-info">
                <div class="item-pick-header">
                
                    <span class="item-pick-name">${itemName}</span>
                </div>
                ${itemDesc ? `<span class="item-pick-desc">${itemDesc}</span>` : ''}
                <div class="item-pick-meta">
                    <span class="item-pick-unit">หน่วย: ${unit}</span>
                    <span class="item-pick-price">฿${price.toLocaleString('th-TH', {minimumFractionDigits: 2})}</span>
                </div>
                ${isExist ? '<span class="item-already-added"> เพิ่มแล้ว</span>' : ''}
            </div>`;

        // คลิกการ์ดแล้ว toggle checkbox
        card.addEventListener('click', function(e) {
            if (isExist) return;
            const cb = card.querySelector('input[type="checkbox"]');
            if (e.target !== cb) cb.checked = !cb.checked;
            updateCardSelected(card, cb.checked);
            updateSelectedCount();
        });

        grid.appendChild(card);
    });

    if (count === 0) {
        grid.innerHTML = '<div class="popup-empty"><span style="font-size:2.5rem;display:block;margin-bottom:10px;">🔍</span>ไม่มีรายการในหมวดหมู่นี้</div>';
    }

    updateSelectedCount();
}

function updateCardSelected(card, selected) {
    if (selected) {
        card.classList.add('selected');
    } else {
        card.classList.remove('selected');
    }
}

function updateSelectedCount() {
    const count = document.querySelectorAll('.popup-item-checkbox:checked').length;
    const el = document.getElementById('selectedCount');
    if (el) el.textContent = count;

    // highlight submit button ถ้ามีเลือก
    const submitBtn = document.querySelector('.btn-submit-modal');
    if (submitBtn) {
        submitBtn.style.opacity = count > 0 ? '1' : '0.65';
    }
}

// ===== ฟังก์ชันเพิ่มรายการสินค้าที่เลือกลงในตารางหลัก =====
function addSelectedItemsToTable() {
    const checkboxes = document.querySelectorAll('.popup-item-checkbox:checked');

    if (checkboxes.length === 0) {
        alert('กรุณาเลือกรายการอย่างน้อย 1 รายการ');
        return;
    }

    checkboxes.forEach(cb => {
        const itemId   = cb.value;
        const itemName = cb.getAttribute('data-name');
        const price    = parseFloat(cb.getAttribute('data-price')) || 0;
        const unit     = cb.getAttribute('data-unit');
        const itemType = cb.getAttribute('data-type') || '';

        let targetBody = document.getElementById('group-service');
        if (itemType.includes('อุปกรณ์'))  targetBody = document.getElementById('group-equipment');
        else if (itemType.includes('ภัตตาหาร')) targetBody = document.getElementById('group-food');
        else if (itemType.includes('สังฆทาน'))  targetBody = document.getElementById('group-sangkathan');

        const tr = document.createElement('tr');
        tr.className = 'dynamic-row';
        tr.setAttribute('data-item-id', itemId);

        tr.innerHTML = `
            <td class="row-number" style="text-align:center;"></td>
            <td>
                <span class="item-name">${itemName}</span>
                <input type="hidden" name="extraItemIds" value="${itemId}">
            </td>
            <td>${buildQtyCell(1, 'extraQtys')}</td>
            <td style="text-align:center;">${unit}</td>
            <td style="text-align:right;">
                <input type="number" name="extraPrices" value="${price.toFixed(2)}"
                    step="0.01" min="0" class="price-input" onchange="calculateGrandTotal()">
            </td>
            <td style="text-align:right;" class="amount-cell"><span class="subtotal">0.00</span></td>
            <td><input type="text" name="detailNotes" class="note-input" placeholder="หมายเหตุ"></td>
            <td style="text-align:center;">
                <button type="button" class="btn-remove" onclick="removeRow(this)">✕</button>
            </td>`;

        targetBody.appendChild(tr);
    });

    closeItemModal();
    reIndexRows();
    calculateGrandTotal();
}

// ===== จัดการแถว =====
function removeRow(button) {
    button.closest('tr').remove();
    reIndexRows();
    calculateGrandTotal();
}

function reIndexRows() {
    const rowNumbers = document.querySelectorAll('.row-number');
    rowNumbers.forEach((td, index) => {
        td.innerText = index + 1;
    });
}

// ===== คำนวณยอดรวม =====
function calculateGrandTotal() {
    let totalAmount = 0.0;

    document.querySelectorAll('.static-row, .dynamic-row').forEach(row => {
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
            totalAmount += subtotal;
        }
    });

    const grandTotalSpan = document.getElementById('grandTotal');
    if (grandTotalSpan) {
        grandTotalSpan.innerText = totalAmount.toLocaleString('th-TH', {minimumFractionDigits: 2});
    }
}

// ===== Validate ก่อนส่ง =====
function validateForm() {
    const totalRows = document.querySelectorAll('.static-row, .dynamic-row').length;
    if (totalRows === 0) {
        alert('กรุณาระบุจำนวนนิมนต์พระ หรือเพิ่มรายการวัสดุเสริมอย่างน้อย 1 รายการ');
        return false;
    }
    return true;
}

// ===== Dropdown =====
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

// ===== Click outside modal/dropdown =====
window.addEventListener('click', (e) => {
    // ปิด modal ถ้าคลิก overlay
    const modal = document.getElementById('itemSelectionModal');
    if (e.target === modal) closeItemModal();

    // ปิด dropdown ถ้าคลิกข้างนอก
    if (!e.target.closest('.user-info')) {
        const dd = document.getElementById('dropdownMenu');
        if (dd) dd.classList.remove('show');
    }
});

// ===== เมื่อโหลดหน้า =====
window.addEventListener('load', () => {
    // แปลง qty cell ของ static-row ให้มีปุ่ม +/-
    document.querySelectorAll('.static-row, .dynamic-row').forEach(row => {
        const qInput = row.querySelector('input[name="bookingQtys"], input[name="extraQtys"]');
        if (qInput) {
            const inputName = qInput.name;
            const val       = qInput.value || 1;
            const td        = qInput.closest('td');
            td.innerHTML    = buildQtyCell(val, inputName);
        }
    });

    // Inject data-injected-id ให้ static-row ที่ไม่มี data-item-id
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