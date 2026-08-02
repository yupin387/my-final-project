// ===== ชื่อหัวข้อของแต่ละหมวด =====
const GROUP_LABELS = {
    'group-equipment':  'หมวดอุปกรณ์พิธีกรรม',
    'group-food':       'หมวดภัตตาหารปิ่นโต',
    'group-sangkathan': 'หมวดสังฆทาน',
    'group-service':    'หมวดบริการและการดำเนินการ'
};

// ===== เก็บ itemId ที่ถูกเลือกไว้ใน popup ให้คงอยู่แม้สลับแท็บหมวดหมู่ =====
const selectedItemIds = new Set();

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

// ===== สร้าง Set ของ itemId ทั้งหมดที่อยู่ในตารางหลักแล้ว (ทั้ง static และ dynamic) =====
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

// ===== เพิ่มหัวข้อหมวดให้ tbody อัตโนมัติ ถ้ายังไม่มีหัวข้ออยู่ =====
// ใช้ตอนเพิ่ม item เข้าไปในหมวดที่ยังไม่มีรายการใด ๆ มาก่อน (ตอน render ตอนแรกฝั่ง JSP
// ไม่ได้ใส่ group-row ไว้ให้เสมอ เพราะบางหมวดขึ้นกับเงื่อนไขข้อมูลลูกค้า)
function ensureGroupHeader(tbody) {
    if (!tbody) return;
    if (tbody.querySelector('.group-row')) return; // มีหัวข้ออยู่แล้ว ไม่ต้องเพิ่มซ้ำ
    const label = GROUP_LABELS[tbody.id] || '';
    const headerRow = document.createElement('tr');
    headerRow.className = 'group-row';
    headerRow.innerHTML = `<td colspan="8">${label}</td>`;
    tbody.prepend(headerRow);
}

// ===== ลบหัวข้อหมวดทิ้ง ถ้าหมวดนั้นไม่มีรายการเหลืออยู่แล้ว =====
function removeGroupHeaderIfEmpty(tbody) {
    if (!tbody || !tbody.id || !tbody.id.startsWith('group-')) return;
    const remaining = tbody.querySelectorAll('tr.static-row, tr.dynamic-row');
    if (remaining.length === 0) {
        const header = tbody.querySelector('.group-row');
        if (header) header.remove();
    }
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
// หมายเหตุ: checkbox ที่ถูกเลือกไว้ (เก็บใน selectedItemIds) จะยังติ๊กอยู่เสมอ
// แม้จะสลับแท็บไปมา เพราะ selectedItemIds ไม่ผูกกับ DOM ของแท็บใดแท็บหนึ่ง
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
        const itemId   = String(dataEl.getAttribute('data-id'));
        const itemName = dataEl.getAttribute('data-name');
        const itemDesc = dataEl.getAttribute('data-detail') || '';
        const unit     = dataEl.getAttribute('data-unit');
        const price    = parseFloat(dataEl.getAttribute('data-price')) || 0;
        const itemType = dataEl.getAttribute('data-type') || '';

        // กรองตามหมวดหมู่
        if (category !== 'all' && !itemType.includes(category)) return;

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
                ${isExist ? '<span class="item-already-added"> เพิ่มแล้ว</span>' : ''}
            </div>`;

        // คลิกการ์ดแล้ว toggle checkbox
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
    if (selected) {
        card.classList.add('selected');
    } else {
        card.classList.remove('selected');
    }
}

// ===== นับจำนวนที่เลือกไว้ทั้งหมด (ทุกหมวด ไม่ใช่แค่แท็บที่กำลังเปิดอยู่) =====
function updateSelectedCount() {
    const count = selectedItemIds.size;
    const el = document.getElementById('selectedCount');
    if (el) el.textContent = count;

    // highlight submit button ถ้ามีเลือก
    const submitBtn = document.querySelector('.btn-submit-modal');
    if (submitBtn) {
        submitBtn.style.opacity = count > 0 ? '1' : '0.65';
    }
}

// ===== เลือก/ยกเลิกเลือก "ทุกรายการทุกหมวด" ในคลิกเดียว ไม่ใช่แค่แท็บที่เห็นอยู่ =====
function toggleSelectAllVisible(checkbox) {
    const checked = checkbox.checked;
    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) return;

    const existingIds = getExistingItemIds();

    dataStore.querySelectorAll('.item-data').forEach(dataEl => {
        const itemId = String(dataEl.getAttribute('data-id'));
        if (existingIds.has(itemId)) return; // ข้ามของที่เพิ่มเข้าตารางไปแล้ว

        if (checked) selectedItemIds.add(itemId);
        else selectedItemIds.delete(itemId);
    });

    // วาดใหม่ตามแท็บปัจจุบัน ให้ checkbox ที่มองเห็นอยู่ sync ตาม state ล่าสุด
    renderItemPicker();
}

// ===== เช็คว่าควรติ๊ก "เลือกทั้งหมด" ไหม โดยพิจารณาจากรายการทั้งหมดในทุกหมวด =====
function updateSelectAllState() {
    const selectAllCb = document.getElementById('selectAllVisible');
    if (!selectAllCb) return;

    const dataStore = document.getElementById('itemDataStore');
    if (!dataStore) return;

    const existingIds = getExistingItemIds();
    const allSelectableIds = [...dataStore.querySelectorAll('.item-data')]
        .map(el => String(el.getAttribute('data-id')))
        .filter(id => !existingIds.has(id));

    selectAllCb.checked = allSelectableIds.length > 0 &&
        allSelectableIds.every(id => selectedItemIds.has(id));
}

// ===== ฟังก์ชันเพิ่มรายการสินค้าที่เลือกลงในตารางหลัก =====
// ดึงจาก selectedItemIds (ครบทุกหมวดที่เลือกไว้) แทนการอ่านจาก checkbox ที่มองเห็นในแท็บปัจจุบัน
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

        let targetBody = document.getElementById('group-service');
        if (itemType.includes('อุปกรณ์'))       targetBody = document.getElementById('group-equipment');
        else if (itemType.includes('ภัตตาหาร')) targetBody = document.getElementById('group-food');
        else if (itemType.includes('สังฆทาน'))  targetBody = document.getElementById('group-sangkathan');

        ensureGroupHeader(targetBody);

        const tr = document.createElement('tr');
        tr.className = 'dynamic-row';
        tr.setAttribute('data-item-id', itemId);

        tr.innerHTML = `
            <td class="row-number" style="text-align:center;"></td>
            <td>
                <span class="item-name">${itemName}</span>
                ${itemDesc ? `<span class="item-desc">${itemDesc}</span>` : ''}
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

    selectedItemIds.clear(); // เคลียร์สถานะที่เลือกไว้ หลังจากเพิ่มเข้าตารางแล้ว
    closeItemModal();
    reIndexRows();
    calculateGrandTotal();
}

// ===== จัดการแถว =====
function removeRow(button) {
    const row = button.closest('tr');
    const tbody = row.parentElement;

    row.remove();
    removeGroupHeaderIfEmpty(tbody);

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

// ตัวอย่างแนวทาง JavaScript
function onCeremonySelect(ceremonyId) {
    // 1. เรียก API ที่เราเพิ่งสร้าง
    fetch('/api/get-items-by-ceremony/' + ceremonyId)
        .then(response => response.json())
        .then(items => {
            // 2. เคลียร์ตารางรายการเก่า (ถ้ามี)
            clearQuotationTable();

            // 3. วนลูปเอา Item ใส่ลงในตาราง
            items.forEach(item => {
                addRowToQuotationTable(item.itemName, item.pricePerUnit, 1); // ให้จำนวนเป็น 1 ไว้ก่อน
            });

            // 4. สั่งคำนวณราคารวมใหม่
            calculateTotal();
        });
}