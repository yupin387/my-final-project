
// ===== Dropdown Toggle =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    menu.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userInfo = document.querySelector('.user-info');
    const menu = document.getElementById('dropdownMenu');
    if (menu && userInfo && !userInfo.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ===== Modal Functions =====
function openApproveModal(bookingId, approveUrl) {
    document.getElementById('displayBookingId').textContent = 'รหัสการจอง: ' + bookingId;
    document.getElementById('confirmApproveLink').href = approveUrl;
    document.getElementById('approveModal').style.display = 'flex';
}

function closeApproveModal() {
    document.getElementById('approveModal').style.display = 'none';
}

function openRejectModal(bookingId, actionUrl) {
    // แสดงรหัสการจอง
    document.getElementById('displayRejectBookingId').innerText = bookingId;

    // เซ็ต URL ให้กับ Form (id ของฟอร์มต้องตรงกับใน JSP)
    document.getElementById('rejectForm').action = actionUrl;

    // เคลียร์ข้อความเก่า (ถ้ามี)
    document.getElementById('rejectDetail').value = '';

    // แสดง Modal
    document.getElementById('rejectModal').style.display = 'flex';
}

function closeRejectModal() {
    document.getElementById('rejectModal').style.display = 'none';
}

// กดพื้นที่ว่างเพื่อปิด Modal
document.addEventListener('click', function (e) {
    const approveModal = document.getElementById('approveModal');
    if (e.target === approveModal) closeApproveModal();

    const rejectModal = document.getElementById('rejectModal');
    if (e.target === rejectModal) closeRejectModal();
});

// ===== สรุปค่าใช้จ่ายโดยประมาณ =====
// ตรรกะสังฆทานเทียบเท่าฝั่ง Member: คิดส่วนต่างตามโควตาแพ็กเกจ
(function () {
    var CFG = window.BOOKING_DETAIL_CONFIG || {};

    // ราคาต่อชุด: ค่าตั้งต้น (สำรอง) แล้วถูกเขียนทับด้วยราคาจริงจากฐานข้อมูล (CFG.priceMap)
    var PRICE_MAP = {
        "ปิ่นโตชุดประหยัด": 299,
        "ปิ่นโตชุดมาตรฐาน": 399,
        "ปิ่นโตชุดพรีเมียม": 499,
        "ปิ่นโตชุดพิเศษ": 599,
        "ชุดสังฆทานมาตรฐาน": 299,
        "ชุดสังฆทานพรีเมียม": 399,
        "ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน": 499
    };
    var dbPrices = CFG.priceMap || {};
    Object.keys(dbPrices).forEach(function (name) {
        PRICE_MAP[name] = dbPrices[name];
    });

    // ชุดสังฆทานที่รวมอยู่ในแพ็กเกจ (qty = 0 หมายถึงไม่มี เช่นโหมดกรอกเอง)
    var INCLUDED_SANGHA = CFG.includedSangha || { price: 0, qty: 0 };
    var IS_CUSTOM_REQUEST = CFG.isCustomRequest === true;

    var SELF_INVITE_DISCOUNT = 1500;

    function fmtMoney(n) {
        n = Math.round((n || 0) * 100) / 100;
        return '฿' + n.toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function collectAnswers() {
        var answers = {};
        document.querySelectorAll('#bookingDetailsSection .info-row[data-qtext]').forEach(function (row) {
            var q = row.getAttribute('data-qtext');
            var a = row.getAttribute('data-answer');
            if (q && !(q in answers)) {
                answers[q] = a;
            }
        });
        return answers;
    }

    // คำนวณค่าสังฆทานตามกฎ:
    //  - โหมดกรอกเอง / ไม่มีชุดที่รวมในแพ็กเกจ : ราคาเต็ม x จำนวนชุด
    //  - โหมดแพ็กเกจ : ชุดในโควตา คิดเฉพาะส่วนต่างจากชุดที่รวมในแพ็กเกจ (ไม่ติดลบ)
    //                  ชุดที่เกินโควตา คิดราคาเต็ม
    function calcSanghaTotal(name, qty) {
        var unit = PRICE_MAP[name] || 0;
        if (IS_CUSTOM_REQUEST || INCLUDED_SANGHA.qty <= 0) {
            return unit * qty;
        }
        var covered = Math.min(qty, INCLUDED_SANGHA.qty);
        var extra = qty - covered;
        var diff = Math.max(0, unit - INCLUDED_SANGHA.price);
        return covered * diff + extra * unit;
    }

    // ข้อความหมายเหตุราคาต่อท้ายชื่อชุดสังฆทาน
    function sanghaPriceNote(name, qty) {
        var unit = PRICE_MAP[name];
        if (unit === undefined) return '';
        if (IS_CUSTOM_REQUEST || INCLUDED_SANGHA.qty <= 0) {
            return ' (' + unit.toLocaleString('th-TH') + ' บาท)';
        }
        var diff = Math.max(0, unit - INCLUDED_SANGHA.price);
        var parts = [];
        if (diff === 0) {
            parts.push('รวมในแพ็กเกจ ' + INCLUDED_SANGHA.qty + ' ชุด');
        } else {
            parts.push('+' + diff.toLocaleString('th-TH') + ' บาท/ชุด จากชุดที่รวมในแพ็กเกจ');
        }
        if (qty > INCLUDED_SANGHA.qty) {
            parts.push('ส่วนที่เกิน ' + (qty - INCLUDED_SANGHA.qty) + ' ชุด คิดชุดละ ' + unit.toLocaleString('th-TH') + ' บาท');
        }
        return ' (' + parts.join(', ') + ')';
    }

    function appendPricesToAnswers() {
        var answers = collectAnswers();
        document.querySelectorAll('#bookingDetailsSection .info-row[data-qtext]').forEach(function (row) {
            var qText = row.getAttribute('data-qtext');
            var isPinto = (qText === 'เลือกชุดภัตตาหารปิ่นโต');
            var isSangha = (qText === 'เลือกชุดสังฆทานที่ต้องการ');
            if (!isPinto && !isSangha) return;

            var valueSpan = row.querySelector('.info-value');
            if (!valueSpan) return;

            var choiceName = valueSpan.textContent.trim();
            if (PRICE_MAP[choiceName] === undefined || choiceName.indexOf('(') !== -1) return;

            if (isSangha) {
                var qty = parseInt(answers['จำนวนชุดสังฆทาน'], 10) || 0;
                valueSpan.textContent = choiceName + sanghaPriceNote(choiceName, qty);
            } else {
                valueSpan.textContent = choiceName + ' (' + PRICE_MAP[choiceName].toLocaleString('th-TH') + ' บาท)';
            }
        });
    }

    function calcCostSummary() {
        var box = document.getElementById('costSummaryBox');
        if (!box) return;

        appendPricesToAnswers();

        var basePrice = parseFloat(CFG.basePrice) || 0;
        var optionType = CFG.optionType || '';
        var isCustomRequest = (basePrice === 0) || (optionType.indexOf('กรอกความต้องการ') !== -1);

        var answers = collectAnswers();

        var pintoTotal = 0;
        var wantPinto = answers['ต้องการชุดภัตตาหารปิ่นโตหรือไม่'];
        var pintoName = answers['เลือกชุดภัตตาหารปิ่นโต'];
        var pintoQty = parseInt(answers['จำนวนชุดภัตตาหารปิ่นโต'], 10) || 0;
        if (pintoName && pintoQty > 0 && (!wantPinto || wantPinto.indexOf('ไม่') === -1)) {
            pintoTotal = (PRICE_MAP[pintoName] || 0) * pintoQty;
        }

        // สังฆทาน: ถ้าอยู่ในแพ็กเกจทั้งหมด แถวจะถูกซ่อน (ไม่มีใน answers) จึงได้ 0
        var sanghaTotal = 0;
        var wantSangha = answers['ต้องการสังฆทานหรือไม่'];
        var sanghaName = answers['เลือกชุดสังฆทานที่ต้องการ'];
        var sanghaQty = parseInt(answers['จำนวนชุดสังฆทาน'], 10) || 0;
        if (sanghaName && sanghaQty > 0 && (!wantSangha || wantSangha.indexOf('ไม่') === -1)) {
            sanghaTotal = calcSanghaTotal(sanghaName, sanghaQty);
        }

        var additionalTotal = pintoTotal + sanghaTotal;

        var inviteAnswer = answers['รูปแบบการนิมนต์พระสงฆ์'] || '';
        var isSelfInvite = inviteAnswer.indexOf('นิมนต์เอง') !== -1;

        var packageLabel, packageValue, discount = 0;

        if (isCustomRequest) {
            var fixedItemsTotal = 0;
            document.querySelectorAll('#packageItemsGrid .package-item-chip[data-price]').forEach(function (chip) {
                if (chip.getAttribute('data-name') === 'ชุดสังฆทานมาตรฐาน') return;
                var price = parseFloat(chip.getAttribute('data-price')) || 0;
                var qty = parseFloat(chip.getAttribute('data-qty')) || 0;
                fixedItemsTotal += price * qty;
            });

            packageLabel = 'ค่าบริการพื้นฐาน (ตามรายการที่จัดให้):';
            packageValue = fixedItemsTotal;
            discount = 0;
        } else {
            packageLabel = 'ราคาแพ็กเกจ:';
            packageValue = basePrice;
            discount = isSelfInvite ? SELF_INVITE_DISCOUNT : 0;
        }

        var grandTotal = packageValue + additionalTotal - discount;
        if (grandTotal < 0) grandTotal = 0;

        document.getElementById('costPackageLabel').textContent = packageLabel;
        document.getElementById('costPackageValue').textContent = fmtMoney(packageValue);

        var addRow = document.getElementById('costAdditionalRow');
        if (additionalTotal > 0) {
            addRow.style.display = '';
            document.getElementById('costAdditionalValue').textContent = fmtMoney(additionalTotal);
        } else {
            addRow.style.display = 'none';
        }

        var discRow = document.getElementById('costDiscountRow');
        if (discount > 0) {
            discRow.style.display = '';
            document.getElementById('costDiscountValue').textContent = '- ' + fmtMoney(discount);
        } else {
            discRow.style.display = 'none';
        }

        document.getElementById('costTotalValue').textContent = fmtMoney(grandTotal);
    }

    // ตัดบรรทัดรายชื่อวัด/พระสงฆ์ ให้ "รูปที่ 1", "รูปที่ 2" ขึ้นบรรทัดใหม่
    function splitTempleLines() {
        document.querySelectorAll('#bookingDetailsSection .info-row .info-value').forEach(function (el) {
            var text = el.textContent.trim();

            // ทำเฉพาะข้อความที่มี "รูปที่ <ตัวเลข>" ตั้งแต่ 2 ชุดขึ้นไป
            var matches = text.match(/รูปที่\s*\d+/g);
            if (!matches || matches.length < 2) return;

            var replaced = text.replace(/\s*(รูปที่\s*\d+)/g, '\n$1').trim();
            el.textContent = replaced;
            el.classList.add('multiline-value');
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        calcCostSummary();
        splitTempleLines();
    });
})();