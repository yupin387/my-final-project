/* ============================================================
   miniBookingCalendar.js
   ปฏิทินย่อในหน้าฟอร์มจอง (booking / booking2 / booking3)
   Logic เกณฑ์สี (ว่าง/เหลือคิวสุดท้าย/เต็มคิว/ผ่านมาแล้ว) อ้างอิงจาก
   renderCalendar() ใน home.js ให้ตรงกับปฏิทินหน้า /calendar ทุกประการ
   แตกต่างจาก home.js ตรงที่:
   - เลือกวันเดียวแล้วจบ ไม่มี popup เลือกประเภทงานบุญ (เพราะอยู่ในฟอร์มอยู่แล้ว)
   - ค่าที่เลือกจะถูกเซ็ตลง hidden input #eventDateInput โดยตรง
   ============================================================ */

const MINI_MONTH_NAMES_TH = [
    "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
    "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
];
const MINI_BE_OFFSET = 543;

let miniCalDate = new Date();

function miniPad2(n) { return n < 10 ? "0" + n : "" + n; }

function miniToDateStr(y, m, d) {
    return y + "-" + miniPad2(m + 1) + "-" + miniPad2(d);
}

function miniGetBookingCount(dateStr) {
    if (window.bookingsPerDate && window.bookingsPerDate[dateStr] != null) {
        return window.bookingsPerDate[dateStr];
    }
    if (window.bookedDates && window.bookedDates.indexOf(dateStr) !== -1) {
        return 1;
    }
    return 0;
}

function renderMiniCal() {
    const year = miniCalDate.getFullYear();
    const month = miniCalDate.getMonth();

    const title = document.getElementById("miniCalMonthTitle");
    if (title) {
        title.textContent = MINI_MONTH_NAMES_TH[month] + " " + (year + MINI_BE_OFFSET);
    }

    const grid = document.getElementById("miniCalGrid");
    if (!grid) return;

    while (grid.children.length > 7) {
        grid.removeChild(grid.lastChild);
    }

    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const todayStr = miniToDateStr(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());
    const teamCount = window.teamCount || 1;

    const eventDateInput = document.getElementById("eventDateInput");
    const currentVal = eventDateInput ? eventDateInput.value : "";

    for (let i = 0; i < firstDay; i++) {
        const empty = document.createElement("div");
        empty.className = "mini-cal-cell mini-cal-cell-empty";
        grid.appendChild(empty);
    }

    for (let d = 1; d <= daysInMonth; d++) {
        const dateStr = miniToDateStr(year, month, d);
        const bookedCount = miniGetBookingCount(dateStr);
        const isFull = bookedCount >= teamCount;
        const isToday = dateStr === todayStr;
        const isPast = dateStr < todayStr;
        const quality = (window.dayQuality && window.dayQuality[dateStr]) || null;

        const cell = document.createElement("div");
        cell.className = "mini-cal-cell";

        if (isPast) {
            cell.classList.add("mini-cal-cell-past");
        } else if (isFull) {
            cell.classList.add("mini-cal-cell-booked");
        } else if ((teamCount - bookedCount) === 1) {
            cell.classList.add("mini-cal-cell-almost");
        } else {
            cell.classList.add("mini-cal-cell-free");
        }

        if (isToday) cell.classList.add("mini-cal-cell-today");
        if (currentVal === dateStr) cell.classList.add("mini-cal-cell-selected");

        cell.textContent = d;

        if (isFull && !isPast) {
            const mark = document.createElement("span");
            mark.className = "mini-cal-full-mark";
            mark.textContent = "✕";
            cell.appendChild(mark);
        }

        if (Array.isArray(quality) && quality.length > 0) {
            cell.setAttribute("title", quality.map(function(q) { return q.label; }).join(", "));
        }

        if (!isFull && !isPast) {
            cell.addEventListener("click", function () {
                selectMiniCalDate(dateStr, cell);
            });
        }

        grid.appendChild(cell);
    }
}

function selectMiniCalDate(dateStr, cellEl) {
    const eventDateInput = document.getElementById("eventDateInput");
    if (eventDateInput) eventDateInput.value = dateStr;

    document.querySelectorAll(".mini-cal-cell-selected").forEach(function (el) {
        el.classList.remove("mini-cal-cell-selected");
    });
    cellEl.classList.add("mini-cal-cell-selected");

    const parts = dateStr.split("-").map(Number);
    const selectedText = document.getElementById("miniCalSelectedText");
    if (selectedText) {
        selectedText.textContent = "เลือกวันที่: " + parts[2] + " " +
            MINI_MONTH_NAMES_TH[parts[1] - 1] + " " + (parts[0] + MINI_BE_OFFSET);
    }
}

function miniCalPrevMonth() {
    miniCalDate.setMonth(miniCalDate.getMonth() - 1);
    renderMiniCal();
}

function miniCalNextMonth() {
    miniCalDate.setMonth(miniCalDate.getMonth() + 1);
    renderMiniCal();
}

document.addEventListener("DOMContentLoaded", function () {
    const eventDateInput = document.getElementById("eventDateInput");
    const pre = eventDateInput ? eventDateInput.value : "";
    if (pre) {
        const parts = pre.split("-").map(Number);
        if (parts.length === 3 && !isNaN(parts[0])) {
            miniCalDate = new Date(parts[0], parts[1] - 1, 1);
        }
    }
    renderMiniCal();
    if (pre) {
        const selectedText = document.getElementById("miniCalSelectedText");
        if (selectedText) {
            const parts = pre.split("-").map(Number);
            selectedText.textContent = "เลือกวันที่: " + parts[2] + " " +
                MINI_MONTH_NAMES_TH[parts[1] - 1] + " " + (parts[0] + MINI_BE_OFFSET);
        }
    }
});