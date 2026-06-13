// ===== ฟังก์ชันสร้าง HTML สำหรับปุ่ม +/- และ input จำนวน =====
function buildQtyCell(value, inputName) {
    return `
        <div class="qty-wrapper">
            <button type="button" class="btn-qty" onclick="adjustQty(this, -1)">−</button>
            <input type="number" name="${inputName}" value="${value}" min="1"
                class="qty-input" onchange="calculateGrandTotal()">
            <button type="button" class="btn-qty" onclick="adjustQty(this, 1)">+</button>
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

    // แถวที่มี data-item-id (dynamic-row และ static-row ที่ใส่ไว้)
    document.querySelectorAll('tr[data-item-id]').forEach(tr => {
        ids.add(tr.getAttribute('data-item-id'));
    });

    // static-row ที่ไม่มี data-item-id (ภัตตาหาร/สังฆทาน จาก JSP)
    // ดึง itemId จาก hidden input ที่ JS inject ไว้ใน data-injected-id
    document.querySelectorAll('tr.static-row[data-injected-id]').forEach(tr => {
        ids.add(tr.getAttribute('data-injected-id'));
    });

    return ids;
}

// ===== ฟังก์ชันจัดการการเปิด-ปิด Popup และตรวจสอบรายการสินค้าซ้ำ =====
function openItemModal() {
    const modal = document.getElementById('itemSelectionModal');
    const existingIds = getExistingItemIds();

    document.querySelectorAll('.popup-item-checkbox').forEach(cb => {
        cb.checked = false;

        const isExist = existingIds.has(cb.value);
        if (isExist) {
            cb.disabled = true;
            cb.closest('tr').style.opacity = '0.4';
        } else {
            cb.disabled = false;
            cb.closest('tr').style.opacity = '1';
        }
    });

    modal.style.display = 'flex';
}

function closeItemModal() {
    document.getElementById('itemSelectionModal').style.display = 'none';
}

// ===== ฟังก์ชันเพิ่มรายการสินค้าที่เลือกจาก Popup ลงในตารางหลัก =====
function addSelectedItemsToTable() {
    const checkboxes = document.querySelectorAll('.popup-item-checkbox:checked');

    checkboxes.forEach(cb => {
        const itemId   = cb.value;
        const itemName = cb.getAttribute('data-name');
        const price    = parseFloat(cb.getAttribute('data-price')) || 0;
        const unit     = cb.getAttribute('data-unit');
        const itemType = cb.getAttribute('data-type') || '';

        let targetBody = document.getElementById('group-service');

        if (itemType.includes('อุปกรณ์')) {
            targetBody = document.getElementById('group-equipment');
        } else if (itemType.includes('ภัตตาหาร')) {
            targetBody = document.getElementById('group-food');
        } else if (itemType.includes('สังฆทาน')) {
            targetBody = document.getElementById('group-sangkathan');
        }

        const tr = document.createElement('tr');
        tr.className = 'dynamic-row';
        tr.setAttribute('data-item-id', itemId);

        tr.innerHTML = `
            <td class="row-number" style="text-align:center;"></td>
            <td>
                ${itemName}
                <input type="hidden" name="extraItemIds" value="${itemId}">
            </td>
            <td>${buildQtyCell(1, 'extraQtys')}</td>
            <td style="text-align:center;">${unit}</td>
            <td style="text-align:right;">
                <input type="number" name="extraPrices" value="${price.toFixed(2)}"
                    step="0.01" min="0" class="price-input"
                    onchange="calculateGrandTotal()">
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

// ===== ฟังก์ชันจัดการแถวข้อมูล =====
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

// ===== ฟังก์ชันคำนวณยอดรวมสุทธิ =====
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
                subtotalSpan.innerText = subtotal.toLocaleString('th-TH', { minimumFractionDigits: 2 });
            }
            totalAmount += subtotal;
        }
    });

    const grandTotalSpan = document.getElementById('grandTotal');
    if (grandTotalSpan) {
        grandTotalSpan.innerText = totalAmount.toLocaleString('th-TH', { minimumFractionDigits: 2 });
    }
}

// ===== ฟังก์ชันตรวจสอบความถูกต้องก่อนส่งฟอร์ม =====
function validateForm() {
    const totalRows = document.querySelectorAll('.static-row, .dynamic-row').length;
    if (totalRows === 0) {
        alert('กรุณาระบุจำนวนนิมนต์พระ หรือเพิ่มรายการวัสดุเสริมอย่างน้อย 1 รายการก่อนทำการส่งข้อมูล');
        return false;
    }
    return true;
}

// ===== ฟังก์ชันควบคุม Dropdown =====
function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}

// ===== Event Listeners =====
window.addEventListener('click', (e) => {
    const modal = document.getElementById('itemSelectionModal');
    if (e.target === modal) {
        closeItemModal();
    }
});

window.addEventListener('load', () => {
    // แปลง qty cell ของ static-row ที่ render จาก JSP ให้มีปุ่ม +/- ด้วย
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
    // (กรณีภัตตาหาร/สังฆทาน ที่ใช้ bookingItemNames แทน itemId)
    // สร้าง map: itemName → itemId จาก checkbox ใน popup
    const nameToId = {};
    document.querySelectorAll('.popup-item-checkbox').forEach(cb => {
        nameToId[cb.getAttribute('data-name')] = cb.value;
    });

    document.querySelectorAll('tr.static-row:not([data-item-id])').forEach(row => {
        const nameInput = row.querySelector('input[name="bookingItemNames"]');
        if (nameInput) {
            const id = nameToId[nameInput.value];
            if (id) {
                row.setAttribute('data-injected-id', id);
            }
        }
    });

    reIndexRows();
    calculateGrandTotal();
});