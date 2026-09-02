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
function toggleSection(sectionId, show) {
    const el = document.getElementById(sectionId);
    if (el) el.style.display = show ? 'block' : 'none';
}

// ===== Sync hidden answer กับ radio (ใช้ใน form2) =====
function syncAnswer(hiddenId, value) {
    const el = document.getElementById(hiddenId);
    if (el) el.value = value;
}

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
        alert('ไม่สามารถเข้าถึงตำแหน่งปัจจุบันได้ กรุณาปักหมุดบนแผนที่เอง');
    });
}

document.addEventListener('DOMContentLoaded', initLocationMap);