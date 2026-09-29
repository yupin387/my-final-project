// ===== bookingForm.js =====
// สคริปต์ของหน้าจองงานบุญ (รวมโค้ดที่เคยฝังใน bookingForm.jsp ไว้ที่นี่แล้ว)
// ต้องโหลดไฟล์นี้ "ก่อน" miniBookingCalendar.js

// ===== ข้อมูลจาก server (JSP ส่งมาทาง #bookingPageData) =====
// ตั้งค่า window.* ชุดเดิมที่ miniBookingCalendar.js ใช้อ่าน
var isCustomMode = false;

(function readBookingPageData() {
    var root = document.getElementById('bookingPageData');
    if (!root) return;

    isCustomMode = root.dataset.customMode === 'true';

    var teamCount = parseInt(root.dataset.teamCount, 10);
    window.teamCount = isNaN(teamCount) ? 2 : teamCount;

    // วันที่มีงานแล้ว: ["2026-01-05", ...]
    window.bookedDates = Array.prototype.map.call(
        root.querySelectorAll('[data-booked]'),
        function (el) { return el.dataset.booked; }
    );

    // จำนวนงานต่อวัน: { "2026-01-05": 2, ... }
    window.bookingsPerDate = {};
    root.querySelectorAll('[data-bookings-date]').forEach(function (el) {
        window.bookingsPerDate[el.dataset.bookingsDate] = Number(el.dataset.count) || 0;
    });

    // แท็กคุณภาพวัน: { "2026-01-05": [{ type, label }, ...], ... }
    window.dayQuality = {};
    root.querySelectorAll('[data-quality-date]').forEach(function (dayEl) {
        window.dayQuality[dayEl.dataset.qualityDate] = Array.prototype.map.call(
            dayEl.querySelectorAll('[data-label]'),
            function (tagEl) {
                return { type: tagEl.dataset.type, label: tagEl.dataset.label };
            }
        );
    });
})();

// ===== Dropdown Toggle =====
function toggleDropdown() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) menu.classList.toggle('show');
}

document.addEventListener('click', function(e) {
    const wrap = document.querySelector('.dropdown-wrap');
    const menu = document.getElementById('dropdownMenu');
    if (menu && wrap && !wrap.contains(e.target)) {
        menu.classList.remove('show');
    }
});

// ===== Auto-fill วันที่กรอกแบบฟอร์ม =====
document.addEventListener('DOMContentLoaded', function() {
    const display = document.getElementById('bookingDateDisplay');
    const hidden  = document.getElementById('bookingDateHidden');
    if (!display || !hidden) return;

    const now = new Date();
    const yyyy = now.getFullYear();
    const mm   = String(now.getMonth() + 1).padStart(2, '0');
    const dd   = String(now.getDate()).padStart(2, '0');
    hidden.value = yyyy + '-' + mm + '-' + dd;
    display.value = dd + '/' + mm + '/' + yyyy;
});

// ===== Toggle Lock Groups =====
document.addEventListener('DOMContentLoaded', function() {
    const masters = document.querySelectorAll('.toggle-master');
    masters.forEach(function(master) {
        const group = master.dataset.group;
        if (!group) return;
        const lockValuesAttr = master.dataset.lockValues || 'ไม่ต้องการ|นิมนต์เอง';
        const lockValues = lockValuesAttr.split('|');
        const slaves = document.querySelectorAll('.toggle-slave[data-group="' + group + '"]');

        function applyState() {
            const shouldLock = lockValues.indexOf(master.value) !== -1;
            slaves.forEach(function(slave) {
                slave.disabled = shouldLock;
                if (shouldLock) {
                    slave.classList.add('field-locked');
                    if (slave.tagName === 'SELECT') slave.selectedIndex = 0;
                    else slave.value = '';
                } else {
                    slave.classList.remove('field-locked');
                }
            });
        }
        master.addEventListener('change', applyState);
        applyState();
    });

    // ตั้งค่าเริ่มต้น watSameInput = 'ให้ร้านเลือกให้' (default)
    const watSameInput = document.getElementById('watSameInput');
    const watDiffInput = document.getElementById('watDiffInput');
    if (watSameInput) { watSameInput.disabled = false; watSameInput.value = 'ให้ร้านเลือกให้'; }
    if (watDiffInput) { watDiffInput.disabled = true; watDiffInput.value = ''; }
});

// ===== Toggle Monk Detail =====
function toggleMonkDetail(radio) {
    const monkDetail = document.getElementById('monkDetail');
    if (monkDetail) {
        monkDetail.style.display = (radio.value === 'ให้ทางร้านนิมนต์') ? 'block' : 'none';
    }
}

// ===== Toggle Wat Detail =====
function toggleWatDetail(radio) {
    const watSame = document.getElementById('watSameDetail');
    const watDiff = document.getElementById('watDiffDetail');
    const watSameInput = document.getElementById('watSameInput');
    const watDiffInput = document.getElementById('watDiffInput');

    if (watSame) watSame.style.display = (radio.value === 'วัดเดียวกัน') ? 'block' : 'none';
    if (watDiff) watDiff.style.display = (radio.value === 'ต่างวัด') ? 'block' : 'none';

    if (radio.value === 'วัดเดียวกัน') {
        if (watSameInput) { watSameInput.disabled = false; watSameInput.value = ''; }
        if (watDiffInput) { watDiffInput.disabled = true; watDiffInput.value = ''; }
    } else if (radio.value === 'ต่างวัด') {
        if (watSameInput) { watSameInput.disabled = true; watSameInput.value = ''; }
        if (watDiffInput) { watDiffInput.disabled = false; watDiffInput.value = ''; }
    } else {
        // ให้ร้านเลือกให้
        if (watSameInput) { watSameInput.disabled = false; watSameInput.value = 'ให้ร้านเลือกให้'; }
        if (watDiffInput) { watDiffInput.disabled = true; watDiffInput.value = ''; }
    }
}

// ===== Toggle Section (ปิ่นโต / สังฆทาน) =====
// ซ่อนส่วนที่ปิด พร้อมล้างข้อความ error ของช่องในส่วนนั้น
function toggleSection(id, show) {
    var el = document.getElementById(id);
    if (el) {
        el.style.display = show ? 'block' : 'none';
        el.querySelectorAll('input, select, textarea').forEach(function(input) {
            if(!show) {
                input.classList.remove('validation-failed');
                var err = input.nextElementSibling;
                if(err && err.classList.contains('custom-error-msg')) err.remove();
            }
        });
    }
}

// ===== Sync hidden answer กับ radio (ใช้ใน form2) =====
function syncAnswer(hiddenId, value) {
    const el = document.getElementById(hiddenId);
    if (el) el.value = value;
}

// ===== อัปโหลดรูปสถานที่จัดงาน (สูงสุด 5 รูป, เก็บเป็น base64) =====
(function() {
    var imgPicker = document.getElementById('imgPicker');
    if (!imgPicker) return;
    var imageList = [];
    imgPicker.addEventListener('change', function() {
        var file = this.files[0];
        if (!file) return;
        if (imageList.length >= 5) {
            alert('อัปโหลดรูปภาพได้สูงสุด 5 รูป');
            this.value = '';
            return;
        }
        var reader = new FileReader();
        reader.onload = function(e) {
            imageList.push(e.target.result);
            var box = document.getElementById('imagePreviewBox');
            var wrapper = document.createElement('div');
            wrapper.style.cssText = 'position:relative;width:80px;height:80px;';
            var img = document.createElement('img');
            img.src = e.target.result;
            img.style.cssText = 'width:80px;height:80px;object-fit:cover;border-radius:6px;border:1px solid #E0577F;';
            var del = document.createElement('button');
            del.type = 'button'; del.innerText = 'x';
            del.style.cssText = 'position:absolute;top:2px;right:2px;background:rgba(0,0,0,0.5);color:white;border:none;border-radius:50%;width:20px;height:20px;cursor:pointer;';
            var idx = imageList.length - 1;
            del.onclick = function() {
                imageList.splice(idx, 1);
                box.removeChild(wrapper);
                updateInputs();
            };
            wrapper.appendChild(img);
            wrapper.appendChild(del);
            box.appendChild(wrapper);
            updateInputs();
        };
        reader.readAsDataURL(file);
        this.value = '';
    });
    function updateInputs() {
        var container = document.getElementById('base64Container');
        container.innerHTML = '';
        for (var i = 0; i < imageList.length; i++) {
            var inp = document.createElement('input');
            inp.type = 'hidden';
            inp.name = 'imageBase64[' + i + ']';
            inp.value = imageList[i];
            container.appendChild(inp);
        }
        var addBtn = document.getElementById('addImgBtn');
        if (addBtn) {
            var atLimit = imageList.length >= 5;
            addBtn.disabled = atLimit;
            addBtn.style.opacity = atLimit ? '0.5' : '1';
            addBtn.style.cursor = atLimit ? 'not-allowed' : 'pointer';
        }
    }
})();

// ===== การนิมนต์พระสงฆ์ =====
function toggleWatOwnField(id, show) {
    var el = document.getElementById(id);
    if (el) el.style.display = show ? 'block' : 'none';
}

// ===== Lightbox ขยายรูป =====
function openLightbox(imgEl) {
    var lb = document.getElementById('imageLightbox');
    var lbImg = document.getElementById('lightboxImg');
    if (!lb || !lbImg) return;
    lbImg.src = imgEl.src;
    lbImg.alt = imgEl.alt || '';
    lb.style.display = 'flex';
}

function closeLightbox() {
    var lb = document.getElementById('imageLightbox');
    if (lb) lb.style.display = 'none';
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeLightbox();
});

function toggleWatDetailBlock(id, show) {
    var el = document.getElementById(id);
    if (el) el.style.display = show ? 'block' : 'none';
    
    var monkCountGroup = document.getElementById('monkCountGroup');
    if (monkCountGroup) {
        if (isCustomMode) {
            monkCountGroup.style.display = 'block';
        } else {
            monkCountGroup.style.display = show ? 'none' : 'block';
            if (show) {
                var checkedPkg = document.querySelector('input[name="packageEntity.packageId"]:checked');
                if (checkedPkg && checkedPkg.dataset.monkcount) {
                    onMonkCountInputChange(checkedPkg.dataset.monkcount);
                }
            }
        }
    }

    var shopWarning = document.getElementById('shopInviteWarning');
    var pkgSelfWarning = document.getElementById('pkgSelfInviteWarning');

    if (show) {
        if (shopWarning) shopWarning.style.display = 'block';
        if (pkgSelfWarning) pkgSelfWarning.style.display = 'none';
    } else {
        if (shopWarning) shopWarning.style.display = 'none';
        if (!isCustomMode && pkgSelfWarning) {
            pkgSelfWarning.style.display = 'block';
        }
    }
}

function syncAllWatAnswersBeforeSubmit() {
    return true;
}

// ===== จำนวนพระ -> จำนวนชุดสังฆทาน / ปิ่นโต =====
function applyPackageMonkCount(radio) {
    var input = document.getElementById('monkCountField');
    if (input && radio.dataset.monkcount) {
        input.value = radio.dataset.monkcount;
    }
    var monkVal = input ? parseInt(input.value, 10) : 5;
    if (isNaN(monkVal)) monkVal = 5;

    var qtyInput = document.getElementById('sanghatanQtyInput');
    if (qtyInput && qtyInput.dataset.userEdited !== 'true') {
        qtyInput.value = monkVal;
    }
    var pintoInput = document.getElementById('pintoQtyInput');
    if (pintoInput && pintoInput.dataset.userEdited !== 'true') {
        pintoInput.value = monkVal + 2;
    }
}

function onMonkCountInputChange(value) {
    var sQty = document.getElementById('sanghatanQtyInput');
    if (sQty && sQty.dataset.userEdited !== 'true') {
        sQty.value = value;
    }
    var pintoInput = document.getElementById('pintoQtyInput');
    if (pintoInput && pintoInput.dataset.userEdited !== 'true') {
        var v = parseInt(value, 10);
        pintoInput.value = isNaN(v) ? '' : (v + 2);
    }
}

// ===== เตรียมข้อมูลก่อนส่งฟอร์ม =====
function isInHiddenBranch(el) {
    var node = el.parentElement;
    while (node && node !== document.body) {
        if (node.style && node.style.display === 'none') return true;
        node = node.parentElement;
    }
    return false;
}

function cleanupAndRenumberDetailsBeforeSubmit() {
    var form = document.querySelector('form');

    form.querySelectorAll('input, select, textarea').forEach(function(el) {
        if (isInHiddenBranch(el)) el.disabled = true;
    });

    var monkCountField = document.getElementById('monkCountField');
    var monkCountQId = document.getElementById('monkCountQuestionIdField');
    if (monkCountField) monkCountField.disabled = false;
    if (monkCountQId) monkCountQId.disabled = false;

    var pattern = /^details\[(\d+)\]\.(answer|question\.questionsId)$/;
    var order = [];
    var seen = {};
    form.querySelectorAll('input:not([disabled]), select:not([disabled]), textarea:not([disabled])').forEach(function(el) {
        var m = el.name && el.name.match(pattern);
        if (m && !seen[m[1]]) { seen[m[1]] = true; order.push(m[1]); }
    });
    var remap = {};
    order.forEach(function(oldIdx, i) { remap[oldIdx] = i; });
    form.querySelectorAll('input:not([disabled]), select:not([disabled]), textarea:not([disabled])').forEach(function(el) {
        var m = el.name && el.name.match(pattern);
        if (m) el.name = 'details[' + remap[m[1]] + '].' + m[2];
    });

    return true;
}

// ===== ตรวจสอบฟอร์มตอนกดบันทึก =====
function showError(element, message) {
    if (element.nextElementSibling && element.nextElementSibling.classList.contains('custom-error-msg')) {
        element.nextElementSibling.remove();
    }
    
    var err = document.createElement('div');
    err.className = 'custom-error-msg';
    err.style.color = 'red';
    err.style.fontSize = '11px';
    err.style.marginTop = '4px';
    err.innerText = message;
    
    if(element.nextSibling) {
        element.parentNode.insertBefore(err, element.nextSibling);
    } else {
        element.parentNode.appendChild(err);
    }
    
    if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA' || element.tagName === 'SELECT') {
        element.style.borderColor = 'red';
        element.classList.add('validation-failed');
        
        var removeError = function() {
            element.style.borderColor = '';
            element.classList.remove('validation-failed');
            if (err.parentNode) err.parentNode.removeChild(err);
        };
        element.addEventListener('input', removeError, {once: true});
        element.addEventListener('change', removeError, {once: true});
    }
}

function handleFormSubmit(form) {
    document.querySelectorAll('.custom-error-msg').forEach(function(e) { e.remove(); });
    form.querySelectorAll('.validation-failed').forEach(function(el) { el.style.borderColor = ''; el.classList.remove('validation-failed'); });

    let isValid = true;
    let firstErrorElement = null;

    function markError(el, msg) {
        showError(el, msg);
        isValid = false;
        if (!firstErrorElement) firstErrorElement = el;
    }

    var eventDateVal = document.getElementById('eventDateInput').value;
    if (!eventDateVal) {
        markError(document.getElementById('datePickerWrap'), 'กรุณาเลือกวันที่จัดงานจากปฏิทิน');
    }

    form.querySelectorAll('input[required], textarea[required], select[required]').forEach(function(el) {
        if (!isInHiddenBranch(el)) {
            if (!el.value.trim()) {
                markError(el, 'กรุณากรอกข้อมูลในช่องนี้ให้ครบถ้วน');
            }
        }
    });

    form.querySelectorAll('input[type="number"]').forEach(function(el) {
        if (!isInHiddenBranch(el) && el.value !== '') {
            if (parseFloat(el.value) <= 0) {
                markError(el, 'จำนวนต้องมากกว่า 0 และห้ามติดลบ');
            }
        }
    });

    var lat = document.getElementById('eventLat').value;
    if (!lat || lat === "") {
        markError(document.getElementById('locationMap'), 'กรุณาปักหมุดตำแหน่งที่จัดงานบนแผนที่');
    }

    var imgCount = document.querySelectorAll('#base64Container input').length;
    if (imgCount === 0) {
        markError(document.getElementById('imagePreviewBox'), 'กรุณาอัปโหลดรูปภาพสถานที่จัดงานอย่างน้อย 1 รูป');
    }

    if (!isValid) {
        if (firstErrorElement) {
            firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return false;
    }

    syncAllWatAnswersBeforeSubmit();
    cleanupAndRenumberDetailsBeforeSubmit();

    return true;
}

// ===== ตอนโหลดหน้า / กลับมาที่หน้านี้ (back-forward cache) =====
// รัน onchange ของ radio ที่ติ๊กอยู่แล้ว เพื่อให้การแสดง/ซ่อนส่วนต่างๆ ตรงกับค่าที่เลือกไว้
function syncInitialToggleStates() {
    document.querySelectorAll('input[type="radio"]:checked').forEach(function(radio) {
        if (isInHiddenBranch(radio)) return;
        var code = radio.getAttribute('onchange');
        if (code) {
            try { new Function(code).call(radio); } catch (e) {}
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    syncInitialToggleStates();
    
    document.querySelectorAll('input[type="number"]').forEach(function(inp) {
        inp.addEventListener('input', function() {
            if (this.value !== '') {
                var val = parseFloat(this.value);
                if (val <= 0) {
                    this.value = '';
                }
            }
        });
    });
});
window.addEventListener('pageshow', syncInitialToggleStates);

/* ===== ปักหมุดตำแหน่งที่จัดงาน (Leaflet + OpenStreetMap) ===== */
var locationMap, locationMarker;
var DEFAULT_MAP_CENTER = [18.7883, 98.9853]; // เชียงใหม่ (ค่าเริ่มต้น)

function initLocationMap() {
    var mapEl = document.getElementById('locationMap');
    if (!mapEl || typeof L === 'undefined') return;

    locationMap = L.map('locationMap').setView(DEFAULT_MAP_CENTER, 12);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(locationMap);

    locationMap.on('click', function(e) {
        setMapPin(e.latlng.lat, e.latlng.lng);
    });
}

function setMapPin(lat, lng) {
    if (!locationMap) return;

    if (!locationMarker) {
        locationMarker = L.marker([lat, lng], { draggable: true }).addTo(locationMap);
        locationMarker.on('dragend', function() {
            var pos = locationMarker.getLatLng();
            updatePinInfo(pos.lat, pos.lng);
        });
    } else {
        locationMarker.setLatLng([lat, lng]);
    }

    locationMap.setView([lat, lng], locationMap.getZoom() < 14 ? 15 : locationMap.getZoom());
    updatePinInfo(lat, lng);
}

// placeName เป็น optional — ถ้ามีอยู่แล้ว (เช่นตอนคลิกผลลัพธ์ค้นหาที่รู้ชื่อแล้ว)
// จะไม่ต้อง reverse-geocode ซ้ำให้เปลืองโควต้า Nominatim
function updatePinInfo(lat, lng, placeName) {
    document.getElementById('eventLat').value = lat.toFixed(6);
    document.getElementById('eventLng').value = lng.toFixed(6);

    var text = document.getElementById('mapSelectedText');
    var searchInput = document.getElementById('mapSearchInput');

    var link = document.getElementById('mapNavLink');
    if (link) {
        link.href = 'https://www.google.com/maps?q=' + lat + ',' + lng;
        link.style.display = 'inline-block';
    }

    if (placeName) {
        // รู้ชื่อสถานที่อยู่แล้ว (มาจากการคลิกเลือกผลค้นหา) ไม่ต้องยิง reverse ซ้ำ
        if (text) text.innerText = '📍 ตำแหน่งที่เลือก: ' + placeName;
        if (searchInput) searchInput.value = placeName;
        return;
    }

    // ระหว่างรอผล reverse geocode ให้โชว์พิกัดไปพลางๆ กันหน้าจอว่าง
    if (text) text.innerText = '📍 ตำแหน่งที่เลือก: ' + lat.toFixed(6) + ', ' + lng.toFixed(6);
    if (searchInput) searchInput.value = 'กำลังค้นหาชื่อสถานที่...';

    nominatimFetch('https://nominatim.openstreetmap.org/reverse?format=json&lat=' + lat + '&lon=' + lng + '&zoom=18&addressdetails=1')
        .then(function(result) {
            if (result && result.display_name) {
                if (searchInput) searchInput.value = result.display_name;
                if (text) text.innerText = '📍 ตำแหน่งที่เลือก: ' + result.display_name;
            } else {
                if (searchInput) searchInput.value = '';
                // ไม่พบชื่อ ให้ text คงพิกัดไว้ตามเดิม
            }
        })
        .catch(function() {
            if (searchInput) searchInput.value = '';
        });
}

// ===== ค้นหาที่อยู่แบบไล่ระดับ (Nominatim ไม่รู้จักฟอร์แมตที่อยู่ไทยแบบ "เลขที่/หมู่" =====
// ดังนั้นถ้าค้นแบบเต็มไม่เจอ จะค่อยๆ ตัดรายละเอียดออกจนกว่าจะเจอจุดอ้างอิงที่ใกล้เคียงที่สุด

// รายชื่อ 77 จังหวัด ใช้เทียบหาชื่อจังหวัดในข้อความ กรณีผู้ใช้พิมพ์ไม่มีคำนำหน้า "จังหวัด"/"จ."
// เช่น "...อำเภอสันทราย เชียงใหม่ 50290" (ไม่มีคำว่า "จังหวัด" นำหน้า "เชียงใหม่")
// เรียงชื่อยาว -> สั้น เพื่อกันเคสจับชื่อย่อยผิด (ไม่มีในลิสต์นี้แต่กันไว้เป็นแนวทางที่ปลอดภัย)
var PROVINCE_LIST = [
    "กรุงเทพมหานคร","กระบี่","กาญจนบุรี","กาฬสินธุ์","กำแพงเพชร","ขอนแก่น","จันทบุรี","ฉะเชิงเทรา",
    "ชลบุรี","ชัยนาท","ชัยภูมิ","ชุมพร","เชียงราย","เชียงใหม่","ตรัง","ตราด","ตาก","นครนายก",
    "นครปฐม","นครพนม","นครราชสีมา","นครศรีธรรมราช","นครสวรรค์","นนทบุรี","นราธิวาส","น่าน",
    "บึงกาฬ","บุรีรัมย์","ปทุมธานี","ประจวบคีรีขันธ์","ปราจีนบุรี","ปัตตานี","พระนครศรีอยุธยา",
    "พังงา","พัทลุง","พิจิตร","พิษณุโลก","เพชรบุรี","เพชรบูรณ์","แพร่","พะเยา","ภูเก็ต",
    "มหาสารคาม","มุกดาหาร","แม่ฮ่องสอน","ยโสธร","ยะลา","ร้อยเอ็ด","ระนอง","ระยอง","ราชบุรี",
    "ลพบุรี","ลำปาง","ลำพูน","เลย","ศรีสะเกษ","สกลนคร","สงขลา","สตูล","สมุทรปราการ",
    "สมุทรสงคราม","สมุทรสาคร","สระแก้ว","สระบุรี","สิงห์บุรี","สุโขทัย","สุพรรณบุรี",
    "สุราษฎร์ธานี","สุรินทร์","หนองคาย","หนองบัวลำภู","อ่างทอง","อำนาจเจริญ","อุดรธานี",
    "อุตรดิตถ์","อุทัยธานี","อุบลราชธานี"
];

function extractAddressLevels(raw) {
    var tambon   = raw.match(/(?:ตำบล|ต\.)\s*([^\s]+)/);
    var amphoe   = raw.match(/(?:อำเภอ|อ\.)\s*([^\s]+)/);
    var changwat = raw.match(/(?:จังหวัด|จ\.)\s*([^\s]+)/);

    var changwatName = changwat ? changwat[1] : null;

    if (!changwatName) {
        // ไม่มีคำนำหน้า "จังหวัด"/"จ." เลย เช่น "...เชียงใหม่ 50290"
        // ลองไล่หาชื่อจังหวัดตรงๆ ในข้อความแทน
        for (var i = 0; i < PROVINCE_LIST.length; i++) {
            if (raw.indexOf(PROVINCE_LIST[i]) !== -1) {
                changwatName = PROVINCE_LIST[i];
                break;
            }
        }
    }

    return {
        tambon: tambon ? tambon[1] : null,
        amphoe: amphoe ? amphoe[1] : null,
        changwat: changwatName
    };
}

// Nominatim จะแยกลำดับชั้นที่อยู่ (ตำบล -> อำเภอ -> จังหวัด -> รหัสไปรษณีย์) ได้แม่นยำกว่ามาก
// ถ้ามี comma คั่นแต่ละระดับแบบที่คนไทยเขียนที่อยู่ทั่วไป เช่น
// "207 หมู่ 10, ตำบลหนองหาร, อำเภอสันทราย, จังหวัดเชียงใหม่, 50290"
// ฟังก์ชันนี้แปลงข้อความดิบที่ผู้ใช้พิมพ์ต่อกันไม่มี comma ให้กลายเป็นฟอร์แมตนี้อัตโนมัติ
function insertCommasIntoThaiAddress(raw) {
    var s = raw.trim();

    // เติม comma หน้าคำเชื่อมระดับที่อยู่ (ถ้าหน้าคำนั้นไม่ใช่จุดเริ่มต้นข้อความ และยังไม่มี comma อยู่แล้ว)
    s = s.replace(/\s*,?\s*(ตำบล|ต\.)/g, ', $1');
    s = s.replace(/\s*,?\s*(อำเภอ|อ\.)/g, ', $1');
    s = s.replace(/\s*,?\s*(จังหวัด|จ\.)/g, ', $1');

    // เติม comma หน้ารหัสไปรษณีย์ไทย (เลข 5 หลักท้ายข้อความ)
    s = s.replace(/\s*,?\s*(\d{5})\s*$/, ', $1');

    // ลบ comma ซ้อนกัน / comma ที่หลุดไปอยู่ต้นข้อความ แล้ว trim ให้เรียบร้อย
    s = s.replace(/^\s*,\s*/, '')
         .replace(/,\s*,/g, ',')
         .replace(/\s+/g, ' ')
         .replace(/\s*,\s*/g, ', ')
         .trim();

    return s;
}

// คืนค่าเป็น array ของ { query, label, rank } แทนการคืน string ดิบๆ
// เพื่อไม่ให้ label ("ระดับตำบล", "ระดับอำเภอ" ฯลฯ) หลุด sync จากตำแหน่ง index ของ candidate
// เวลามีการเพิ่ม/ลด candidate ในอนาคต (เคยเป็นบั๊กมาก่อน — เพิ่ม candidate ใหม่เข้าไปแล้วลืมขยับ levelLabels ตาม)
// rank ใช้บอกระดับความจำเพาะเจาะจงของ candidate นั้น (0 = เจาะจงสุด/มีเลขที่บ้าน, 4 = กว้างสุด/แค่จังหวัด)
function buildSearchCandidates(raw) {
    var candidates = [];

    function addCandidate(query, label, rank) {
        if (!query) return;
        var exists = candidates.some(function(c) { return c.query === query; });
        if (!exists) candidates.push({ query: query, label: label, rank: rank });
    }

    var commaVersion = insertCommasIntoThaiAddress(raw);
    addCandidate(commaVersion, 'ที่อยู่แบบเต็ม', 0); // 1. เติม comma คั่นระดับที่อยู่ (ลองก่อนเป็นอันดับแรก แม่นยำสุด)
    addCandidate(raw, 'ที่อยู่แบบเต็ม', 0);           // 2. ข้อความเต็มตามที่พิมพ์ (ไม่แก้ไข)

    var cleaned = raw
        .replace(/เลขที่\s*[\d\/\-]+/g, '')
        .replace(/หมู่ที่?\s*\d+/g, '')
        .replace(/^\s*[\d\/\-]+\s+/, '')
        .trim();
    addCandidate(cleaned, 'ตัดเลขที่บ้าน/หมู่', 1); // 3. ตัดเลขที่บ้าน/หมู่ออก

    var levels = extractAddressLevels(raw);
    if (levels.tambon && levels.amphoe && levels.changwat) {
        addCandidate('ตำบล' + levels.tambon + ', อำเภอ' + levels.amphoe + ', จังหวัด' + levels.changwat, 'ระดับตำบล', 2); // 4.
    }
    if (levels.amphoe && levels.changwat) {
        addCandidate('อำเภอ' + levels.amphoe + ', จังหวัด' + levels.changwat, 'ระดับอำเภอ', 3); // 5.
    }
    if (levels.changwat) {
        addCandidate('จังหวัด' + levels.changwat, 'ระดับจังหวัด', 4); // 6.
    }

    return candidates;
}

// ===== คิวควบคุมความถี่การยิง Nominatim =====
// Nominatim (ฟรี) มีนโยบายจำกัด ~1 request/วินาที ถ้ายิงถี่กว่านี้ (เช่นตอนเทสติดๆ กันหลายครั้ง)
// อาจโดนบล็อกชั่วคราวหรือได้ผลลัพธ์ผิดเพี้ยน ฟังก์ชันนี้จะคั่นเวลาให้อัตโนมัติทุก request
// ไม่ว่าจะมาจาก reverse geocode หรือ search ก็ตาม
var lastNominatimCallAt = 0;
function nominatimFetch(url) {
    var now = Date.now();
    var wait = Math.max(0, 1100 - (now - lastNominatimCallAt));
    return new Promise(function(resolve, reject) {
        setTimeout(function() {
            lastNominatimCallAt = Date.now();
            fetch(url)
                .then(function(res) {
                    if (!res.ok) {
                        console.warn('[Nominatim] HTTP ' + res.status + ' - ' + url);
                    }
                    return res.json();
                })
                .then(resolve)
                .catch(function(err) {
                    console.error('[Nominatim] fetch error:', err);
                    reject(err);
                });
        }, wait);
    });
}

function nominatimSearch(q, center) {
    var delta = 0.5; // ~50 กม. รอบจุดกึ่งกลางแผนที่ปัจจุบัน (bias ไม่ใช่ hard filter)
    var viewbox = (center.lng - delta) + ',' + (center.lat + delta) + ',' + (center.lng + delta) + ',' + (center.lat - delta);
    var url = 'https://nominatim.openstreetmap.org/search'
        + '?format=jsonv2&addressdetails=1&limit=6'
        + '&countrycodes=th&accept-language=th'
        + '&viewbox=' + viewbox + '&bounded=0'
        + '&q=' + encodeURIComponent(q);
    return nominatimFetch(url);
}

// กันผลลัพธ์หลุดไปคนละอำเภอ/จังหวัด เช่นค้นหา "ตำบลหนองหาร อำเภอสันทราย" แล้วดันได้
// สถานที่ในอำเภอเมืองแทน — ถ้ารู้ชื่ออำเภอ/จังหวัดจากข้อความที่พิมพ์ ให้กรองเอาเฉพาะผลลัพธ์ที่
// display_name มีชื่ออำเภอ/จังหวัดนั้นจริงๆ ก่อน ถ้ากรองแล้วไม่เหลือเลยค่อย fallback ไปผลลัพธ์ดิบ
function filterResultsByLevel(results, levels, rank) {
    if (!results || !results.length) return results;

    if (rank <= 2 && levels.amphoe && levels.changwat) {
        var strict = results.filter(function(r) {
            return r.display_name.indexOf(levels.amphoe) !== -1 && r.display_name.indexOf(levels.changwat) !== -1;
        });
        if (strict.length) return strict;
    }
    if (rank <= 3 && levels.changwat) {
        var provinceOnly = results.filter(function(r) {
            return r.display_name.indexOf(levels.changwat) !== -1;
        });
        if (provinceOnly.length) return provinceOnly;
    }
    return results;
}

function renderSearchResults(resultsBox, results, attemptIndex, candidate) {
    resultsBox.innerHTML = '';

    var pinnedNote = document.createElement('div');
    pinnedNote.className = 'map-search-note';
    pinnedNote.innerText = '📍 ปักหมุดให้ตามผลลัพธ์แรกแล้ว — คลิกรายการอื่นด้านล่างถ้าต้องการเปลี่ยนจุด';
    resultsBox.appendChild(pinnedNote);

    if (attemptIndex > 0) {
        var note = document.createElement('div');
        note.className = 'map-search-note';
        note.innerText = 'ไม่พบที่อยู่แบบเต็ม แสดงผลลัพธ์ระดับ "' + candidate.label + '" แทน — เลือกจุดที่ใกล้เคียงแล้วลากหมุดปรับต่อ';
        resultsBox.appendChild(note);
    }
    results.forEach(function(r, idx) {
        var item = document.createElement('div');
        item.className = 'map-search-item';
        if (idx === 0) {
            item.style.background = '#FBD0DE';
            item.style.fontWeight = '600';
        }
        item.textContent = (idx === 0 ? '✓ ' : '') + r.display_name;
        item.addEventListener('click', function() {
            setMapPinWithName(parseFloat(r.lat), parseFloat(r.lon), r.display_name);
            resultsBox.style.display = 'none';
        });
        resultsBox.appendChild(item);
    });
    resultsBox.style.display = 'block';
}

// เหมือน setMapPin แต่รู้ชื่อสถานที่อยู่แล้ว (จากรายการผลค้นหา) เลยไม่ต้อง reverse-geocode ซ้ำ
function setMapPinWithName(lat, lng, placeName) {
    if (!locationMap) return;

    if (!locationMarker) {
        locationMarker = L.marker([lat, lng], { draggable: true }).addTo(locationMap);
        locationMarker.on('dragend', function() {
            var pos = locationMarker.getLatLng();
            updatePinInfo(pos.lat, pos.lng);
        });
    } else {
        locationMarker.setLatLng([lat, lng]);
    }

    locationMap.setView([lat, lng], locationMap.getZoom() < 14 ? 15 : locationMap.getZoom());
    updatePinInfo(lat, lng, placeName);
}

function searchLocationOnMap() {
    var rawQ = document.getElementById('mapSearchInput').value.trim();
    if (!rawQ) return;

    var resultsBox = document.getElementById('mapSearchResults');
    if (resultsBox) {
        resultsBox.innerHTML = '<div class="map-search-loading">กำลังค้นหา...</div>';
        resultsBox.style.display = 'block';
    }

    var center = locationMap ? locationMap.getCenter() : { lat: DEFAULT_MAP_CENTER[0], lng: DEFAULT_MAP_CENTER[1] };
    var candidates = buildSearchCandidates(rawQ);
    var levels = extractAddressLevels(rawQ);

    // ถ้าข้อความที่พิมพ์ไม่มีคำว่า ตำบล/อำเภอ/จังหวัดเลย (เช่นชื่อสถานที่ล้วนๆ อย่าง "มหาวิทยาลัยแม่โจ้")
    // buildSearchCandidates จะสร้าง candidate ให้แค่ตัวเดียว ถ้าตัวนั้นพลาด (เช่นโดน rate-limit ชั่วคราว)
    // จะไม่มี fallback ให้ลองต่อ ที่นี่เลยเติมตัวสำรองเข้าไปเพิ่ม เผื่อไว้
    if (candidates.length === 1) {
        candidates.push({ query: candidates[0].query + ' ประเทศไทย', label: candidates[0].label, rank: candidates[0].rank });
    }

    function tryNext(index) {
        if (index >= candidates.length) {
            var msg = 'ไม่พบตำแหน่งนี้ กรุณาลองพิมพ์ใหม่แบบอื่น (เช่นชื่อสถานที่ใกล้เคียง)<br>หรือปักหมุดเองบนแผนที่ / กด "ใช้ตำแหน่งปัจจุบัน"';
            if (resultsBox) {
                resultsBox.innerHTML = '<div class="map-search-empty">' + msg + '</div>';
            } else {
                alert('ไม่พบตำแหน่งนี้ กรุณาปักหมุดเองบนแผนที่');
            }
            return;
        }

        var candidate = candidates[index];

        nominatimSearch(candidate.query, center)
            .then(function(results) {
                results = filterResultsByLevel(results, levels, candidate.rank);
                if (results && results.length > 0) {
                    // ปักหมุดให้ที่ผลลัพธ์อันดับ 1 ทันที ไม่ต้องรอผู้ใช้คลิกก่อน
                    setMapPinWithName(parseFloat(results[0].lat), parseFloat(results[0].lon), results[0].display_name);
                    if (resultsBox) {
                        renderSearchResults(resultsBox, results, index, candidate);
                    }
                } else {
                    tryNext(index + 1); // nominatimFetch คั่นเวลาให้เองอยู่แล้ว ไม่ต้อง setTimeout ซ้ำ
                }
            })
            .catch(function() {
                tryNext(index + 1);
            });
    }

    tryNext(0);
}

document.addEventListener('click', function(e) {
    var resultsBox = document.getElementById('mapSearchResults');
    var searchInput = document.getElementById('mapSearchInput');
    if (resultsBox && !resultsBox.contains(e.target) && e.target !== searchInput) {
        resultsBox.style.display = 'none';
    }
});

function useCurrentLocationOnMap() {
    if (!navigator.geolocation) {
        alert('เบราว์เซอร์นี้ไม่รองรับการระบุตำแหน่งปัจจุบัน');
        return;
    }
    navigator.geolocation.getCurrentPosition(function(pos) {
        setMapPin(pos.coords.latitude, pos.coords.longitude);
    }, function() {
        alert('ไม่สามารถเข้าถึงตำแหน่งปัจจุบันได้ กรุณาปักหมุดเองบนแผนที่');
    });
}

document.addEventListener('DOMContentLoaded', initLocationMap);