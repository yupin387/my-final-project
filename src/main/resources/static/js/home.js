/* ============================================================
   home.js (v14)
   ปฏิทินแบบ inline (ไม่มี modal สำหรับตัวปฏิทิน) — เลือกได้ทีละ 1 วัน
   แสดงวันดี/วันควรเลี่ยงในตารางเลย
   คลิกวันที่ว่างปุ๊บ -> เด้ง popup เลือกประเภทงานบุญทันที (ไม่ต้องกดปุ่มยืนยันแล้ว)

   v14 changes:
   - เพิ่มกากบาท (✕) มุมขวาบนของช่องวันที่ "เต็มคิว" (isFull && !isPast)
     ผ่าน class cal-full-mark เพื่อให้เห็นชัดเจนว่าวันนั้นจองไม่ได้แล้ว
   - หมายเหตุ: ปัญหา ★/▲ ไม่ขึ้นในปฏิทิน แก้ที่ฝั่ง backend แล้ว
     (UserController.normalizeYearKeys ทำให้ key วันที่เป็น ค.ศ. เสมอ
     ตรงกับ key ที่ home.js สร้างจาก Date จริงฝั่ง JS)

   v13 changes:
   - เปลี่ยนจากเลือกได้หลายวัน (Set) เป็นเลือกได้ทีละ 1 วัน (ตัวแปรเดี่ยว selectedDate)
   - ตัดปุ่ม/แถบ "เลือกประเภทงานบุญ" ที่ต้องกดยืนยันออก คลิกวันที่แล้วเปิด popup ทันที
   - คลิกวันที่เลือกอยู่ซ้ำ = ยกเลิกการเลือกและปิด popup

   v12 changes:
   - วันที่ผ่านมาแล้ว (ก่อนวันนี้) ล็อกไม่ให้คลิกเลือก และให้พื้นหลังทึบสีเทา
     (ไม่ใช่แค่กรอบ) ผ่าน class cal-cell-past
   - ลำดับความสำคัญของสีสถานะ: ผ่านมาแล้ว(เทา) > เต็มคิว(แดง) > วันนี้(เหลือง)
     > เหลือคิวสุดท้าย(ส้ม) > ว่าง(เขียว)
   ============================================================ */

const MONTH_NAMES_TH = [
	"มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
	"กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
];
const BE_OFFSET = 543;

let calCurrentDate = new Date();
let selectedDate = null; // เลือกได้ทีละ 1 วัน

function pad2(n) { return n < 10 ? "0" + n : "" + n; }

function toDateStr(y, m, d) {
	// m is 0-indexed
	return y + "-" + pad2(m + 1) + "-" + pad2(d);
}

function formatThaiDate(dateStr) {
	const parts = dateStr.split("-").map(Number);
	const y = parts[0], m = parts[1], d = parts[2];
	return d + " " + MONTH_NAMES_TH[m - 1] + " " + (y + BE_OFFSET);
}

/**
 * คืนค่าจำนวนคิวที่ถูกจองไปแล้วของวันที่กำหนด
 */
function getBookingCount(dateStr) {
	if (window.bookingsPerDate && window.bookingsPerDate[dateStr] != null) {
		return window.bookingsPerDate[dateStr];
	}
	if (window.bookedDates && window.bookedDates.indexOf(dateStr) !== -1) {
		return 1;
	}
	return 0;
}

function renderCalendar() {
    const year = calCurrentDate.getFullYear();
    const month = calCurrentDate.getMonth();

    const monthTitle = document.getElementById("calMonthTitle");
    if (monthTitle) {
        monthTitle.textContent = MONTH_NAMES_TH[month] + " " + (year + BE_OFFSET);
    }

    const grid = document.getElementById("calGrid");
    if (!grid) return;

    // ล้าง Grid เดิม (เก็บเฉพาะ header 7 ช่องแรก: อา, จ, อ, พ, พฤ, ศ, ส)
    while (grid.children.length > 7) {
        grid.removeChild(grid.lastChild);
    }

    // แก้ไข: ใช้ Date(year, month, 1) เสมอเพื่อหาจุดเริ่มต้นวันในเดือนที่ถูกต้อง
    const firstDay = new Date(year, month, 1).getDay(); 
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const todayStr = toDateStr(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());

    const teamCount = window.teamCount || 1;

    // เพิ่มช่องว่างสำหรับวันก่อนวันที่ 1
    for (let i = 0; i < firstDay; i++) {
        const empty = document.createElement("div");
        empty.className = "cal-cell cal-cell-empty";
        grid.appendChild(empty);
    }

    // วนลูปสร้างช่องวันในเดือน
    for (let d = 1; d <= daysInMonth; d++) {
        const dateStr = toDateStr(year, month, d);
        const bookedCount = getBookingCount(dateStr);
        const isFull = bookedCount >= teamCount;
        const isToday = dateStr === todayStr;
        const isPast = dateStr < todayStr;
        const quality = (window.dayQuality && window.dayQuality[dateStr]) || null;

        const cell = document.createElement("div");
        cell.className = "cal-cell";

        // กำหนดสีสถานะ (ลำดับความสำคัญตามเงื่อนไขธุรกิจ)
        if (isPast) {
            cell.classList.add("cal-cell-past");
        } else if (isFull) {
            cell.classList.add("cal-cell-booked");
        } else if (isToday) {
            cell.classList.add("cal-cell-today");
        } else if ((teamCount - bookedCount) === 1) {
            cell.classList.add("cal-cell-almost-full");
        } else {
            cell.classList.add("cal-cell-free");
        }

        if (selectedDate === dateStr) cell.classList.add("cal-cell-selected");

        // เลขวันที่
        const dayNum = document.createElement("div");
        dayNum.className = "cal-day-num";
        dayNum.textContent = d;
        cell.appendChild(dayNum);

        // เครื่องหมายเต็มคิว
        if (isFull && !isPast) {
            const fullMark = document.createElement("div");
            fullMark.className = "cal-full-mark";
            fullMark.textContent = "✕";
            cell.appendChild(fullMark);
        }

        // Tag ฤกษ์ดี (★/▲)
        if (Array.isArray(quality) && quality.length > 0) {
            // เพิ่ม Tooltip แสดงชื่อฤกษ์ทั้งหมดเมื่อเอาเมาส์ไปชี้
            const allLabels = quality.map(q => q.label).join(", ");
            cell.setAttribute("title", allLabels);
            
            // แสดงทุก Tag ที่มีใน Array โดยไม่ตัดทิ้ง
            quality.forEach(function (q) {
                const tag = document.createElement("div");
                tag.className = q.type === "good" ? "cal-day-tag cal-day-tag-good" : "cal-day-tag cal-day-tag-bad";
                tag.textContent = (q.type === "good" ? "★ " : "▲ ") + q.label;
                cell.appendChild(tag);
            });
        }

        // Event การคลิก
        if (!isFull && !isPast) {
            cell.addEventListener("click", function () {
                toggleDateSelection(dateStr, cell);
            });
        }

        grid.appendChild(cell);
    }
}

function prevMonth() {
	calCurrentDate.setMonth(calCurrentDate.getMonth() - 1);
	renderCalendar();
}

function nextMonth() {
	calCurrentDate.setMonth(calCurrentDate.getMonth() + 1);
	renderCalendar();
}

/* ===== เลือกวันที่ได้ทีละ 1 วัน ===== */

/**
 * คลิกวันที่ในปฏิทิน:
 * - ถ้าคลิกวันเดิมที่เลือกอยู่ซ้ำ -> ยกเลิกการเลือกและปิด popup
 * - ถ้าคลิกวันใหม่ -> ล้างวันเดิม (ถ้ามี) แล้วเลือกวันนี้แทน จากนั้นเด้ง popup
 *   เลือกประเภทงานบุญให้ทันที (ไม่ต้องกดปุ่มยืนยันแล้ว)
 */
function toggleDateSelection(dateStr, cellEl) {
	if (selectedDate === dateStr) {
		selectedDate = null;
		if (cellEl) cellEl.classList.remove("cal-cell-selected");
		closeCeremonyModal();
		return;
	}

	const prevSelectedCell = document.querySelector(".cal-cell-selected");
	if (prevSelectedCell) prevSelectedCell.classList.remove("cal-cell-selected");

	selectedDate = dateStr;
	if (cellEl) cellEl.classList.add("cal-cell-selected");

	openCeremonyTypeSelection();
}

/* ===== ประเภทงานบุญ (เด้งเป็น popup ทันทีหลังเลือกวันที่) ===== */

/**
 * เปิด popup เลือกประเภทงานบุญ พร้อมอัปเดตวันที่ที่เลือกไว้ในหัว popup
 */
function openCeremonyTypeSelection() {
	if (!selectedDate) return;

	const modalDates = document.getElementById("ceremonyModalDates");
	if (modalDates) {
		modalDates.textContent = "วันที่เลือก: " + formatThaiDate(selectedDate);
	}
	renderCeremonyTypeCards();
	openCeremonyModal();
}

function renderCeremonyTypeCards() {
	const wrap = document.getElementById("ceremonyTypesGrid");
	if (!wrap) return;
	wrap.innerHTML = "";

	(window.ceremonyTypes || []).forEach(function (t) {
		const card = document.createElement("div");
		card.className = "ceremony-type-card";
		card.innerHTML =
		    '<div class="ceremony-type-img"><img src="' + t.image + '" alt="' + t.name + '"></div>' +
		    '<div class="ceremony-type-body">' +
		    '<div class="ceremony-type-name">งาน' + t.name + '</div>' +
		    '<span class="ceremony-type-cta">ดูรายละเอียด &rarr;</span>' +
		    '</div>';
		card.addEventListener("click", function () {
			goToCeremonyDetail(t.id);
		});
		wrap.appendChild(card);
	});
}

function goToCeremonyDetail(ceremonyId) {
	const url = window.contextPath + "/ceremony/detail/" + ceremonyId +
		(selectedDate ? ("?dates=" + encodeURIComponent(selectedDate)) : "");
	window.location.href = url;
}

function openCeremonyModal() {
	const overlay = document.getElementById("ceremonyModalOverlay");
	if (overlay) overlay.classList.add("show");
}

function closeCeremonyModal() {
	const overlay = document.getElementById("ceremonyModalOverlay");
	if (overlay) overlay.classList.remove("show");
}

/* ===== แกลเลอรี ===== */

function loadGalleryImages() {
	const grid = document.getElementById("galleryGrid");
	if (!grid) return;
	const images = ["img1.jpg", "img2.jpg", "img3.jpg", "img4.jpg", "img5.jpg", "img6.jpg", "img7.jpg", "img8.jpg", "img9.jpg", "img10.jpg"];
	grid.innerHTML = "";
	images.forEach(function (imgName) {
		const item = document.createElement("div");
		item.className = "gallery-item";
		item.innerHTML = '<img src="' + window.contextPath + '/static/images/' + imgName + '" alt="ผลงานจริง" onerror="this.parentElement.style.display=\'none\'">';
		grid.appendChild(item);
	});
}

/* ===== Init ===== */

document.addEventListener("DOMContentLoaded", function () {
	// Dropdown โปรไฟล์ผู้ใช้
	const dropdownMenu = document.getElementById("dropdownMenu");
	document.addEventListener("click", function (e) {
		const isPillClick = e.target.closest(".user-profile-pill");
		const isDropdownMenu = e.target.closest("#dropdownMenu");
		if (isPillClick) {
			e.preventDefault();
			e.stopPropagation();
			if (dropdownMenu) dropdownMenu.classList.toggle("show");
		} else if (!isDropdownMenu) {
			if (dropdownMenu && dropdownMenu.classList.contains("show")) {
				dropdownMenu.classList.remove("show");
			}
		}
	});

	// Login alert toast
	const loginAlert = document.getElementById("loginAlert");
	if (loginAlert) {
		setTimeout(function () { loginAlert.classList.add("show"); }, 200);
		setTimeout(function () {
			loginAlert.classList.remove("show");
			setTimeout(function () { loginAlert.remove(); }, 500);
		}, 3700);
	}

	// Popup ประเภทงานบุญ: คลิกพื้นหลังนอกกล่องเพื่อปิด
	const ceremonyOverlay = document.getElementById("ceremonyModalOverlay");
	if (ceremonyOverlay) {
		ceremonyOverlay.addEventListener("click", function (e) {
			if (e.target === ceremonyOverlay) closeCeremonyModal();
		});
	}

	// ปฏิทิน + แกลเลอรี
	renderCalendar();
	loadGalleryImages();

	// รูปรีวิวเสีย -> ซ่อน
	document.querySelectorAll(".review-img-thumb").forEach(function (img) {
		img.addEventListener("error", function () { img.style.display = "none"; });
	});
});