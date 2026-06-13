// 1. ดึงข้อมูลวันที่จาก Global
const bookedDates = window.bookedDates || [];
const contextPath = window.contextPath || ""; 

document.addEventListener('DOMContentLoaded', function () {
    // A. จัดการ Dropdown Profile
    const dropdownMenu = document.getElementById('dropdownMenu');
    document.addEventListener('click', function (e) {
        const isPillClick = e.target.closest('.user-profile-pill');
        const isDropdownMenu = e.target.closest('#dropdownMenu');

        if (isPillClick) {
            e.preventDefault();
            e.stopPropagation(); 
            if (dropdownMenu) dropdownMenu.classList.toggle('show');
        } else if (!isDropdownMenu) {
            if (dropdownMenu && dropdownMenu.classList.contains('show')) {
                dropdownMenu.classList.remove('show');
            }
        }
    });

    // B. จัดการ Login Alert
    const loginAlert = document.getElementById('loginAlert');
    if (loginAlert) {
        setTimeout(() => loginAlert.classList.add('show'), 200);
        setTimeout(() => {
            loginAlert.classList.remove('show');
            setTimeout(() => loginAlert.remove(), 500);
        }, 3700);
    }

    // C. [สำคัญ] เรียกฟังก์ชันต่างๆ ที่นี่
    renderCalendar();
    loadGalleryImages();

    // D. จัดการรูปรีวิว
    document.querySelectorAll('.review-img-thumb').forEach(img => {
        img.addEventListener('error', () => img.style.display = 'none');
    });
});

// ===== ฟังก์ชันวาดปฏิทิน =====
const thaiMonths = ["มกราคม","กุมภาพันธ์","มีนาคม","เมษายน","พฤษภาคม","มิถุนายน","กรกฎาคม","สิงหาคม","กันยายน","ตุลาคม","พฤศจิกายน","ธันวาคม"];
const BE_OFFSET = 543;
let currentDate = new Date();
let viewYear = currentDate.getFullYear();
let viewMonth = currentDate.getMonth();

function pad(n) { return String(n).padStart(2, '0'); }

function renderCalendar() {
    const grid = document.getElementById('calGrid');
    if (!grid) return;
    const labels = Array.from(grid.children).slice(0, 7);
    grid.innerHTML = '';
    labels.forEach(l => grid.appendChild(l));
    const monthTitle = document.getElementById('calMonthTitle');
    if (monthTitle) monthTitle.textContent = thaiMonths[viewMonth] + ' ' + (viewYear + BE_OFFSET);

    const firstDay = new Date(viewYear, viewMonth, 1).getDay();
    const daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
    const todayStr = currentDate.getFullYear() + '-' + pad(currentDate.getMonth() + 1) + '-' + pad(currentDate.getDate());

    for (let i = 0; i < firstDay; i++) {
        const empty = document.createElement('div');
        empty.className = 'cal-cell empty';
        grid.appendChild(empty);
    }

    for (let d = 1; d <= daysInMonth; d++) {
        const dateStr = viewYear + '-' + pad(viewMonth + 1) + '-' + pad(d);
        const cell = document.createElement('div');
        cell.className = 'cal-cell' + (dateStr === todayStr ? ' today' : (bookedDates.includes(dateStr) ? ' booked' : ''));
        cell.textContent = d;
        if (bookedDates.includes(dateStr) || dateStr === todayStr) {
            const dot = document.createElement('div');
            dot.className = 'cal-dot';
            cell.appendChild(dot);
        }
        grid.appendChild(cell);
    }
}

// ===== ฟังก์ชันโหลดรูปแกลเลอรี =====
function loadGalleryImages() {
    const grid = document.getElementById('galleryGrid');
    if (!grid) return;
    const images = ["img1.jpg", "img2.jpg", "img3.jpg", "img4.jpg", "img5.jpg", "img6.jpg", "img7.jpg", "img8.jpg", "img9.jpg", "img10.jpg"];
    grid.innerHTML = '';
    images.forEach(imgName => {
        const item = document.createElement('div');
        item.className = 'gallery-item';
        item.innerHTML = `<img src="${contextPath}/static/images/${imgName}" alt="ผลงานจริง" onerror="this.parentElement.style.display='none'">`;
        grid.appendChild(item);
    });
}

function prevMonth() { viewMonth--; if(viewMonth < 0){viewMonth=11; viewYear--;} renderCalendar(); }
function nextMonth() { viewMonth++; if(viewMonth > 11){viewMonth=0; viewYear++;} renderCalendar(); }

function openCalendarModal() {
    document.getElementById('calendarOverlay').classList.add('open');
    renderCalendar();
}

function closeCalendarModal(e) {
    if (e === null || e.target === document.getElementById('calendarOverlay')) {
        document.getElementById('calendarOverlay').classList.remove('open');
    }
}