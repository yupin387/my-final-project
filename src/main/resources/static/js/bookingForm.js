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

function updatePinInfo(lat, lng) {
    document.getElementById('eventLat').value = lat.toFixed(6);
    document.getElementById('eventLng').value = lng.toFixed(6);

    var text = document.getElementById('mapSelectedText');
    if (text) text.innerText = 'ตำแหน่งที่เลือก: ' + lat.toFixed(6) + ', ' + lng.toFixed(6);

    var link = document.getElementById('mapNavLink');
    if (link) {
        link.href = 'https://www.google.com/maps?q=' + lat + ',' + lng;
        link.style.display = 'inline-block';
    }

    // ===== เพิ่มใหม่: Reverse geocode เพื่อเติมชื่อสถานที่กลับเข้าช่องค้นหา =====
    var searchInput = document.getElementById('mapSearchInput');
    if (searchInput) {
        searchInput.value = 'กำลังค้นหาชื่อสถานที่...';
        fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat=' + lat + '&lon=' + lng + '&zoom=18&addressdetails=1')
            .then(function(res) { return res.json(); })
            .then(function(result) {
                if (result && result.display_name) {
                    searchInput.value = result.display_name;
                } else {
                    searchInput.value = '';
                }
            })
            .catch(function() {
                searchInput.value = '';
            });
    }
}

// ===== ค้นหาที่อยู่แบบไล่ระดับ (Nominatim ไม่รู้จักฟอร์แมตที่อยู่ไทยแบบ "เลขที่/หมู่" =====
// ดังนั้นถ้าค้นแบบเต็มไม่เจอ จะค่อยๆ ตัดรายละเอียดออกจนกว่าจะเจอจุดอ้างอิงที่ใกล้เคียงที่สุด

function extractAddressLevels(raw) {
    var tambon   = raw.match(/(?:ตำบล|ต\.)\s*([^\s]+)/);
    var amphoe   = raw.match(/(?:อำเภอ|อ\.)\s*([^\s]+)/);
    var changwat = raw.match(/(?:จังหวัด|จ\.)\s*([^\s]+)/);
    return {
        tambon: tambon ? tambon[1] : null,
        amphoe: amphoe ? amphoe[1] : null,
        changwat: changwat ? changwat[1] : null
    };
}

function buildSearchCandidates(raw) {
    var candidates = [raw]; // 1. ข้อความเต็มตามที่พิมพ์

    var cleaned = raw
        .replace(/เลขที่\s*[\d\/\-]+/g, '')
        .replace(/หมู่ที่?\s*\d+/g, '')
        .replace(/^\s*[\d\/\-]+\s+/, '')
        .trim();
    if (cleaned && cleaned !== raw) candidates.push(cleaned); // 2. ตัดเลขที่บ้าน/หมู่ออก

    var levels = extractAddressLevels(raw);
    if (levels.tambon && levels.amphoe && levels.changwat) {
        candidates.push('ตำบล' + levels.tambon + ' อำเภอ' + levels.amphoe + ' จังหวัด' + levels.changwat); // 3.
    }
    if (levels.amphoe && levels.changwat) {
        candidates.push('อำเภอ' + levels.amphoe + ' จังหวัด' + levels.changwat); // 4.
    }
    if (levels.changwat) {
        candidates.push('จังหวัด' + levels.changwat); // 5.
    }

    return candidates.filter(function(v, i) { return v && candidates.indexOf(v) === i; });
}

function nominatimSearch(q, center) {
    var delta = 0.5; // ~50 กม. รอบจุดกึ่งกลางแผนที่ปัจจุบัน (bias ไม่ใช่ hard filter)
    var viewbox = (center.lng - delta) + ',' + (center.lat + delta) + ',' + (center.lng + delta) + ',' + (center.lat - delta);
    var url = 'https://nominatim.openstreetmap.org/search'
        + '?format=jsonv2&addressdetails=1&limit=6'
        + '&countrycodes=th&accept-language=th'
        + '&viewbox=' + viewbox + '&bounded=0'
        + '&q=' + encodeURIComponent(q);
    return fetch(url).then(function(res) { return res.json(); });
}

function renderSearchResults(resultsBox, results, levelIndex, levelLabels) {
    resultsBox.innerHTML = '';
    if (levelIndex > 0) {
        var note = document.createElement('div');
        note.className = 'map-search-note';
        note.innerText = 'ไม่พบที่อยู่แบบเต็ม แสดงผลลัพธ์ระดับ "' + levelLabels[levelIndex] + '" แทน — เลือกจุดที่ใกล้เคียงแล้วลากหมุดปรับต่อ';
        resultsBox.appendChild(note);
    }
    results.forEach(function(r) {
        var item = document.createElement('div');
        item.className = 'map-search-item';
        item.textContent = r.display_name;
        item.addEventListener('click', function() {
            setMapPin(parseFloat(r.lat), parseFloat(r.lon));
            resultsBox.style.display = 'none';
        });
        resultsBox.appendChild(item);
    });
    resultsBox.style.display = 'block';
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
    var levelLabels = ['ที่อยู่แบบเต็ม', 'ตัดเลขที่บ้าน/หมู่', 'ระดับตำบล', 'ระดับอำเภอ', 'ระดับจังหวัด'];

    function tryNext(index) {
        if (index >= candidates.length) {
            var msg = 'ไม่พบตำแหน่งนี้ในทุกระดับที่ลองแล้ว<br>กรุณาปักหมุดเองบนแผนที่ หรือกด "ใช้ตำแหน่งปัจจุบัน"';
            if (resultsBox) {
                resultsBox.innerHTML = '<div class="map-search-empty">' + msg + '</div>';
            } else {
                alert('ไม่พบตำแหน่งนี้ กรุณาปักหมุดเองบนแผนที่');
            }
            return;
        }

        nominatimSearch(candidates[index], center)
            .then(function(results) {
                if (results && results.length > 0) {
                    if (!resultsBox) {
                        setMapPin(parseFloat(results[0].lat), parseFloat(results[0].lon));
                        return;
                    }
                    renderSearchResults(resultsBox, results, index, levelLabels);
                } else {
                    setTimeout(function() { tryNext(index + 1); }, 1000); // เว้น 1 วิ กัน rate limit ของ Nominatim
                }
            })
            .catch(function() {
                setTimeout(function() { tryNext(index + 1); }, 1000);
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