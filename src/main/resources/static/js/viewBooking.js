/**
 * viewBooking.js - Interactive Scripts for Member Booking Summary Page
 *
 * หมายเหตุ: ค่าที่ต้องมาจากฝั่งเซิร์ฟเวอร์ (EL) ถูกประกาศไว้ใน viewBooking.jsp ก่อนโหลดไฟล์นี้ ได้แก่
 *   - contextPath
 *   - window.VIEW_BOOKING_CONFIG { priceOverrides, includedSangha, isCustomRequest, basePrice, optionType }
 */

// Toggle Dropdown Menu (สำหรับโปรไฟล์ผู้ใช้)
function toggleDropdown(event) {
    if (event) {
        event.stopPropagation();
    }
    const menu = document.getElementById('dropdownMenu');
    if (menu) {
        menu.classList.toggle('show');
    }
}

// ซ่อน Dropdown เมื่อคลิกพื้นที่อื่นภายนอก
document.addEventListener('click', function (e) {
    const userPill = document.querySelector('.user-profile-pill');
    const menu = document.getElementById('dropdownMenu');
    if (menu && menu.classList.contains('show')) {
        if (userPill && !userPill.contains(e.target) && !menu.contains(e.target)) {
            menu.classList.remove('show');
        }
    }
});

// แสดง Modal ยืนยันการยกเลิกรายการจอง
function showCancelModal(bookingId) {
    if (document.getElementById('cancelBookingId')) {
        document.getElementById('cancelBookingId').textContent = bookingId;
    }

    const baseUrl = (typeof contextPath !== 'undefined') ? contextPath : '';
    const cancelUrl = baseUrl + '/booking/cancel/' + bookingId;

    const confirmBtn = document.getElementById('confirmCancelUrl');
    if (confirmBtn) {
        confirmBtn.setAttribute('href', cancelUrl);
        // เก็บ URL ไว้ใน dataset ด้วย เผื่อ href ถูกรีเซ็ตหรืออ่านยากกว่า attribute
        confirmBtn.dataset.cancelUrl = cancelUrl;
    }

    const cancelModalElement = document.getElementById('cancelModal');
    if (cancelModalElement) {
        const cancelModal = new bootstrap.Modal(cancelModalElement);
        cancelModal.show();
    }
}

// ปิด Modal ยกเลิกการจอง
function closeCancelModal() {
    const cancelModalElement = document.getElementById('cancelModal');
    if (cancelModalElement) {
        const instance = bootstrap.Modal.getInstance(cancelModalElement);
        if (instance) instance.hide();
    }
}

// ===== FIX: ยิงคำขอยกเลิกแบบ AJAX แทนการปล่อยให้ <a href> navigate ออกจากหน้า
// เพราะ /booking/cancel/{id} เดิมทำ redirect:/home อยู่แล้ว fetch() จะตาม
// redirect นี้ไปจบที่หน้า /home (status 200) ทำให้เช็ค res.ok ได้เลย
// โดยไม่ต้องแก้ Controller ฝั่ง backend เลย =====
document.addEventListener('DOMContentLoaded', function () {
    const confirmBtn = document.getElementById('confirmCancelUrl');
    if (!confirmBtn) return;

    confirmBtn.addEventListener('click', function (e) {
        e.preventDefault();

        const url = confirmBtn.dataset.cancelUrl || confirmBtn.getAttribute('href');
        if (!url || url === '#') return;

        const originalText = confirmBtn.textContent;
        confirmBtn.textContent = 'กำลังยกเลิก...';
        confirmBtn.style.pointerEvents = 'none';
        confirmBtn.style.opacity = '0.7';

        fetch(url, { method: 'GET' })
            .then(function (res) {
                if (res.ok) {
                    closeCancelModal();
                    lockBookingAsCancelled();
                } else {
                    alert('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง');
                    confirmBtn.textContent = originalText;
                    confirmBtn.style.pointerEvents = '';
                    confirmBtn.style.opacity = '';
                }
            })
            .catch(function () {
                alert('เชื่อมต่อไม่สำเร็จ กรุณาลองใหม่อีกครั้ง');
                confirmBtn.textContent = originalText;
                confirmBtn.style.pointerEvents = '';
                confirmBtn.style.opacity = '';
            });
    });
});

// ===== อัปเดตหน้า viewBooking ให้แสดงสถานะ "ยกเลิกแล้ว" ทันที
// โดยไม่ต้อง reload หน้า (เทียบเท่า lockQuotationAsConfirmed ของหน้าใบเสนอราคา) =====
function lockBookingAsCancelled() {
    // 1. อัปเดต status pill ที่หัวเอกสาร
    const statusPill = document.getElementById('bookingStatusPill');
    if (statusPill) {
        statusPill.className = 'status-pill status-cancelled';
        statusPill.textContent = 'ยกเลิกแล้ว';
    }

    // 2. ลบกล่องแจ้งเตือน "รอการติดต่อจากทีมงาน" (ถ้ามีอยู่)
    const pendingNotice = document.getElementById('pendingNotice');
    if (pendingNotice) {
        pendingNotice.remove();
    }

    // 3. แทรกกล่องแจ้งเตือน "ยกเลิกรายการจองแล้ว" ไว้เหนือเอกสารใบสรุป
    const pageWrapper = document.querySelector('.page-wrapper');
    const sheetDoc = document.querySelector('.booking-sheet-document');
    if (pageWrapper && sheetDoc && !document.getElementById('cancelledNotice')) {
        const notice = document.createElement('div');
        notice.className = 'booking-notice notice-cancelled';
        notice.id = 'cancelledNotice';
        notice.innerHTML =
            '<div class="notice-icon"><i class="bi bi-x-circle-fill"></i></div>' +
            '<div class="notice-content">' +
            '<strong>ยกเลิกรายการจองเรียบร้อยแล้ว</strong>' +
            '<p>ท่านได้ทำการยกเลิกรายการจองนี้ด้วยตนเอง หากต้องการจองใหม่ สามารถทำรายการได้ที่หน้าหลัก</p>' +
            '</div>';
        pageWrapper.insertBefore(notice, sheetDoc);
    }

    // 4. เอาปุ่ม "ยกเลิกรายการจอง" ออกจาก Action Bar (ยกเลิกไปแล้ว ไม่ต้องกดซ้ำ)
    const cancelBtn = document.querySelector('.action-bar .btn-cancel');
    if (cancelBtn) {
        cancelBtn.remove();
    }

    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// ยืนยันการยกเลิกแบบ Confirm Box สำรอง (เผื่อใช้กรณีไม่ผ่าน Modal)
function confirmCancel(bookingId) {
    if (confirm('ต้องการยกเลิกการจองนี้ใช่หรือไม่?')) {
        const baseUrl = (typeof contextPath !== 'undefined') ? contextPath : '';
        window.location.href = baseUrl + '/booking/cancel/' + bookingId;
    }
}

// =====================================================================
// สรุปค่าใช้จ่ายโดยประมาณ + หมายเหตุราคาสังฆทาน/ปิ่นโต + แยกบรรทัดวัด
// (ย้ายมาจาก <script> inline ใน viewBooking.jsp)
// =====================================================================
(function () {
    var CFG = window.VIEW_BOOKING_CONFIG || {};

    // ราคาต่อชุด: ค่าตั้งต้น (สำรอง) แล้วถูกเขียนทับด้วยราคาจริงจากฐานข้อมูล (priceOverrides)
    var PRICE_MAP = {
        "ปิ่นโตชุดประหยัด": 299,
        "ปิ่นโตชุดมาตรฐาน": 399,
        "ปิ่นโตชุดพรีเมียม": 499,
        "ปิ่นโตชุดพิเศษ": 599,
        "ชุดสังฆทานมาตรฐาน": 299,
        "ชุดสังฆทานพรีเมียม": 399,
        "ชุดสังฆทานพร้อมผ้าไตรมาตรฐาน": 499
    };
    var overrides = CFG.priceOverrides || {};
    Object.keys(overrides).forEach(function (name) {
        PRICE_MAP[name] = overrides[name];
    });

    // ชุดสังฆทานที่รวมอยู่ในแพ็กเกจ (qty = 0 หมายถึงไม่มี เช่นโหมดกรอกเอง)
    var INCLUDED_SANGHA = CFG.includedSangha || { price: 0, qty: 0 };
    var IS_CUSTOM_REQUEST = !!CFG.isCustomRequest;

    var SELF_INVITE_DISCOUNT = 1500;

    function fmtMoney(n) {
        n = Math.round((n || 0) * 100) / 100;
        return '฿' + n.toLocaleString('th-TH', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    function collectAnswers() {
        var answers = {};
        document.querySelectorAll('#bookingDetailsSection .info-row[data-qtext]')
            .forEach(function (row) {
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
            parts.push('+' + diff.toLocaleString('th-TH')
                + ' บาท/ชุด จากชุดที่รวมในแพ็กเกจ');
        }
        if (qty > INCLUDED_SANGHA.qty) {
            parts.push('ส่วนที่เกิน ' + (qty - INCLUDED_SANGHA.qty)
                + ' ชุด คิดชุดละ ' + unit.toLocaleString('th-TH') + ' บาท');
        }
        return ' (' + parts.join(', ') + ')';
    }

    function appendPricesToAnswers() {
        var answers = collectAnswers();
        document.querySelectorAll('#bookingDetailsSection .info-row[data-qtext]')
            .forEach(function (row) {
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
                    valueSpan.textContent = choiceName + ' ('
                        + PRICE_MAP[choiceName].toLocaleString('th-TH') + ' บาท)';
                }
            });
    }

    function calcCostSummary() {
        var box = document.getElementById('costSummaryBox');
        if (!box) return;

        appendPricesToAnswers();

        var basePrice = parseFloat(CFG.basePrice) || 0;
        var optionType = CFG.optionType || '';
        var isCustomRequest = (basePrice === 0)
            || (optionType.indexOf('กรอกความต้องการ') !== -1);

        var answers = collectAnswers();

        var pintoTotal = 0;
        var wantPinto = answers['ต้องการชุดภัตตาหารปิ่นโตหรือไม่'];
        var pintoName = answers['เลือกชุดภัตตาหารปิ่นโต'];
        var pintoQty = parseInt(answers['จำนวนชุดภัตตาหารปิ่นโต'], 10) || 0;
        if (pintoName && pintoQty > 0
            && (!wantPinto || wantPinto.indexOf('ไม่') === -1)) {
            pintoTotal = (PRICE_MAP[pintoName] || 0) * pintoQty;
        }

        // สังฆทาน: ถ้าอยู่ในแพ็กเกจทั้งหมด แถวจะถูกซ่อน (ไม่มีใน answers) จึงได้ 0
        var sanghaTotal = 0;
        var wantSangha = answers['ต้องการสังฆทานหรือไม่'];
        var sanghaName = answers['เลือกชุดสังฆทานที่ต้องการ'];
        var sanghaQty = parseInt(answers['จำนวนชุดสังฆทาน'], 10) || 0;
        if (sanghaName && sanghaQty > 0
            && (!wantSangha || wantSangha.indexOf('ไม่') === -1)) {
            sanghaTotal = calcSanghaTotal(sanghaName, sanghaQty);
        }

        var additionalTotal = pintoTotal + sanghaTotal;

        var inviteAnswer = answers['รูปแบบการนิมนต์พระสงฆ์'] || '';
        var isSelfInvite = inviteAnswer.indexOf('นิมนต์เอง') !== -1;

        var packageLabel, packageValue, discount = 0;

        if (isCustomRequest) {
            var fixedItemsTotal = 0;
            document.querySelectorAll('#packageItemsGrid .package-item-chip[data-price]')
                .forEach(function (chip) {
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

    function splitTempleLines() {
        document.querySelectorAll('#bookingDetailsSection .info-row .info-value')
            .forEach(function (el) {
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