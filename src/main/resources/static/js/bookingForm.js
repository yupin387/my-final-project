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
}

function searchLocationOnMap() {
    var q = document.getElementById('mapSearchInput').value.trim();
    if (!q) return;

    fetch('https://nominatim.openstreetmap.org/search?format=json&limit=1&q=' + encodeURIComponent(q))
        .then(function(res) { return res.json(); })
        .then(function(results) {
            if (results && results.length > 0) {
                var lat = parseFloat(results[0].lat);
                var lng = parseFloat(results[0].lon);
                setMapPin(lat, lng);
            } else {
                alert('ไม่พบตำแหน่งที่ค้นหา ลองระบุที่อยู่ให้ละเอียดขึ้น');
            }
        })
        .catch(function() {
            alert('ค้นหาตำแหน่งไม่สำเร็จ กรุณาลองใหม่');
        });
}

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