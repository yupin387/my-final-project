function toggleDropdown() {
    document.getElementById('dropdownMenu').classList.toggle('show');
}
function toggleServiceDropdown(e) {
    e.stopPropagation();
    document.getElementById('serviceDropdownMenu').classList.toggle('show');
}
document.addEventListener('click', function(e) {
    if (!e.target.closest('.user-profile-pill')) {
        var m = document.getElementById('dropdownMenu');
        if (m) m.classList.remove('show');
    }
    if (!e.target.closest('.nav-dropdown')) {
        var s = document.getElementById('serviceDropdownMenu');
        if (s) s.classList.remove('show');
    }
});

// สลับแท็บ "กำลังดำเนินการ" / "ประวัติการจอง"
function switchBookingTab(panelId, btn) {
    document.querySelectorAll('.mybooking-tab-panel').forEach(function(p) {
        p.classList.remove('active');
    });
    document.querySelectorAll('.mybooking-tab').forEach(function(t) {
        t.classList.remove('active');
    });
    var panel = document.getElementById(panelId);
    if (panel) panel.classList.add('active');
    if (btn) btn.classList.add('active');
    try { sessionStorage.setItem('myBookingTab', panelId); } catch (err) {}
}

// จำแท็บล่าสุดที่เปิดไว้ เวลากลับมาจากหน้ารายละเอียดจะได้อยู่แท็บเดิม
document.addEventListener('DOMContentLoaded', function() {
    var saved = null;
    try { saved = sessionStorage.getItem('myBookingTab'); } catch (err) {}
    if (saved) {
        var btn = document.querySelector('.mybooking-tab[data-tab="' + saved + '"]');
        if (btn) switchBookingTab(saved, btn);
    }
});