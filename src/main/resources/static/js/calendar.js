/* ============================================================
   calendar.js
   ไฟล์เดียวรวมปฏิทินล้านนาทั้งหมด (เดิมแยกเป็น LannaCalendar.js
   กับ lannaCalendarRender.js สองไฟล์ ตอนนี้รวมเป็นไฟล์เดียว):

     ส่วนที่ 1: LannaCalendar        - data layer โหลด/ค้นข้อมูล JSON
     ส่วนที่ 2: initLannaCalendar    - ตัวแสดงผลตาราง grid รายเดือน

   ใช้ในหน้า JSP:
     <script src=".../calendar.js"></script>
     <script>
       document.addEventListener('DOMContentLoaded', function () {
         initLannaCalendar('${pageContext.request.contextPath}/static/data');
       });
     </script>

   UPDATE: เดิมส่วนหัวปฏิทินล้านนาโชว์กล่อง #lc-year-card (ข้อมูลปีมะเมีย/
   นักษัตร/ที่มา ฯลฯ) แบบเต็ม ตอนนี้ย้าย "ที่มา" ไปแสดงที่ท้ายปฏิทินแทน
   ผ่าน element #lc-year-source ส่วนหัวปฏิทินเปลี่ยนไปใช้กล่องคำอธิบาย
   ".lc-explain-box" แบบ static ที่เขียนไว้ใน JSP โดยตรง จึงตัดฟังก์ชัน
   renderYearCard() ที่ไม่ใช้แล้วออก และเพิ่ม renderYearSource() แทน
   ============================================================ */

/* ============================================================
   ส่วนที่ 1: LannaCalendar (data layer)
   -----------------------------------------------------------------------
   Query layer over the extracted Lanna (Lan Na) calendar data for
   พ.ศ. 2569 (ค.ศ. 2026), sourced from the CMU / Creative Lanna / ACCL
   printed calendar (คำนวณโดย สนั่น ธรรมธิ).

   Data files expected in the base path passed to LannaCalendar.load():
     - year_2569.json            (year-level metadata)
     - monthly_notes_2026.json   (reliable per-month day-number lists)
     - daily_2026_01.json ... daily_2026_12.json
                                  (fully populated daily records for every
                                   month — lunar date, ฟ้าตีแส่งเศษ, วันไท
                                   name, tags)
     - day_tag_glossary.json     (static meaning of each day tag)

   NOTE ON COVERAGE: all 12 months now have full day-by-day records
   (daily_2026_01.json through daily_2026_12.json). If a new year's data
   is added later, follow the same schema and register the new files by
   updating the year/number range this loader iterates over.
   -----------------------------------------------------------------------
   ============================================================ */

class LannaCalendar {
  constructor({ year, monthlyNotes, dailyByMonth, glossary }) {
    this.year = year;
    this.monthlyNotes = monthlyNotes;       // { "1": {...}, "2": {...}, ... }
    this.dailyByMonth = dailyByMonth;       // { 1: {...}, 2: {...}, ..., 12: {...} }
    this.glossary = glossary;
  }

  static async load(basePath = '/data') {
    const fetchJson = async (name) => {
      const res = await fetch(`${basePath}/${name}`);
      if (!res.ok) throw new Error(`Failed to load ${name}`);
      return res.json();
    };

    // FIX: เดิม hardcode โหลดแค่ daily_2026_04.json (เมษายน) เดือนเดียว
    // ตอนนี้มีไฟล์รายวันครบทั้ง 12 เดือนแล้ว (daily_2026_01.json ... daily_2026_12.json)
    // จึงสร้างรายชื่อไฟล์ทั้ง 12 เดือนแล้วโหลดพร้อมกันทั้งหมดแทน
    const monthNumbers = Array.from({ length: 12 }, (_, i) => i + 1);
    const dailyFileNames = monthNumbers.map(
      (m) => `daily_2026_${String(m).padStart(2, '0')}.json`
    );

    const [year, monthlyNotes, glossary, ...dailyResults] = await Promise.all([
      fetchJson('year_2569.json'),
      fetchJson('monthly_notes_2026.json'),
      fetchJson('day_tag_glossary.json'),
      ...dailyFileNames.map((name) => fetchJson(name)),
    ]);

    const dailyByMonth = {};
    monthNumbers.forEach((m, idx) => {
      dailyByMonth[m] = dailyResults[idx];
    });

    return new LannaCalendar({ year, monthlyNotes, dailyByMonth, glossary });
  }

  /** Year-level metadata: zodiac animal, year pagoda, year flower, etc. */
  getYearInfo() {
    return this.year;
  }

  /** Full day record if available (now all 12 months), else null. */
  getDay(month, date) {
    const monthData = this.dailyByMonth[month];
    if (!monthData) return null;
    return monthData.days.find((d) => d.date === date) || null;
  }

  /** Monthly summary: lists of วันดี, วันเสีย, วันเก้ากอง etc. for a given month (1-12). */
  getMonthNotes(month) {
    return this.monthlyNotes[String(month)] || null;
  }

  /**
   * Best-effort auspiciousness check for a given date, using whichever
   * data is available: full daily tags if present, otherwise falls back
   * to the monthly summary lists.
   */
  isGoodDay(month, date) {
    const day = this.getDay(month, date);
    if (day) {
      const bad = ['วันเสีย', 'วันมัจจุ', 'วันวอดวาย', 'วันไหม้'];
      return !day.tags.some((t) => bad.includes(t));
    }
    const notes = this.getMonthNotes(month);
    if (!notes) return null; // unknown
    const isBad =
      notes.sickDays?.includes(date) ||
      notes.ruinDays?.includes(date) ||
      notes.deathDays?.includes(date) ||
      notes.fireDays?.includes(date);
    return isBad === undefined ? null : !isBad;
  }

  /** Is this date flagged as good for weddings (วันหัวเรียงหมอน / goodDays list)? */
  isWeddingDay(month, date) {
    const day = this.getDay(month, date);
    if (day) return day.tags.includes('วันหัวเรียงหมอน');
    const notes = this.getMonthNotes(month);
    return notes ? notes.weddingDays?.includes(date) ?? null : null;
  }

  /** Is cremation discouraged on this date (วันเก้ากอง)? */
  isCremationDiscouraged(month, date) {
    const notes = this.getMonthNotes(month);
    if (!notes) return null;
    const onNineHeap = notes.nineHeapDays?.includes(date);
    if (!onNineHeap) return false;
    return notes.cremationOk ? false : true;
  }

  /** Look up the plain-language meaning of a day tag (e.g. "วันเสีย"). */
  explainTag(tag) {
    const g = this.glossary;
    return (
      g.dithiDays[tag] ||
      g.chokDays[tag] ||
      g.otherTags[tag] ||
      null
    );
  }

  /** All dates in a month carrying a specific tag category, from monthly notes. */
  listDatesByCategory(month, category) {
    // category: 'goodDays' | 'weddingDays' | 'sickDays' | 'ruinDays' |
    //           'deathDays' | 'fireDays' | 'nineHeapDays'
    const notes = this.getMonthNotes(month);
    return notes ? notes[category] || [] : [];
  }
}

// Node/CommonJS + browser-friendly export
if (typeof module !== 'undefined' && module.exports) {
  module.exports = LannaCalendar;
}


/* ============================================================
   ส่วนที่ 2: initLannaCalendar (ตัวแสดงผลตาราง grid รายเดือน)
   ============================================================

   ต้องมี element เหล่านี้อยู่ใน DOM (ดูตัวอย่าง markup ใน calendar.jsp):
     #lc-month-title        - หัวข้อเดือน/ปี ปัจจุบัน
     #lc-prev-month / #lc-next-month - ปุ่มเลื่อนเดือน
     #lc-grid                - grid ของวันในเดือน (7 คอลัมน์)
     #lc-day-detail           - กล่องรายละเอียดวันที่ถูกเลือก
     #lc-year-source          - กล่อง "ที่มา" ท้ายปฏิทิน (แทน #lc-year-card เดิม)
   ============================================================ */

(function (window, document) {
	"use strict";

	var GREGORIAN_YEAR = 2026; // ปี ค.ศ. ที่ตรงกับข้อมูลปี พ.ศ. 2569
	var BE_OFFSET = 543;

	var MONTH_NAMES_TH = [
		"มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
		"กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
	];

	var WEEKDAY_NAMES_TH = [
		"วันอาทิตย์", "วันจันทร์", "วันอังคาร", "วันพุธ",
		"วันพฤหัสบดี", "วันศุกร์", "วันเสาร์"
	];

	// ป้ายที่ถือว่าเป็น "วันไม่ดี" ตามที่ใช้ใน LannaCalendar.isGoodDay()
	var BAD_LABELS = ["วันเสีย", "วันมัจจุ", "วันวอดวาย", "วันไหม้"];

	var lannaService = null;
	var currentMonth = 4; // เริ่มที่เมษายน (เดือนที่มีข้อมูลรายวันครบ) เหมือนเดิม
	var selectedDate = null;

	/** เตรียมรายการแท็กของวันที่กำหนด โดยรวมทั้งจากข้อมูลรายวัน (ถ้ามี) และข้อมูลสรุปรายเดือน */
	function getDayTags(month, date) {
		var tags = [];
		var day = lannaService.getDay(month, date);

		if (day && Array.isArray(day.tags)) {
			day.tags.forEach(function (label) {
				tags.push({ label: label, type: BAD_LABELS.indexOf(label) !== -1 ? "bad" : "good" });
			});
		} else {
			var notes = lannaService.getMonthNotes(month);
			if (notes) {
				if (notes.goodDays && notes.goodDays.indexOf(date) !== -1) tags.push({ label: "วันดี", type: "good" });
				if (notes.weddingDays && notes.weddingDays.indexOf(date) !== -1) tags.push({ label: "วันหัวเรียงหมอน", type: "good" });
				if (notes.sickDays && notes.sickDays.indexOf(date) !== -1) tags.push({ label: "วันเสีย", type: "bad" });
				if (notes.ruinDays && notes.ruinDays.indexOf(date) !== -1) tags.push({ label: "วันวอดวาย", type: "bad" });
				if (notes.deathDays && notes.deathDays.indexOf(date) !== -1) tags.push({ label: "วันมัจจุ", type: "bad" });
				if (notes.fireDays && notes.fireDays.indexOf(date) !== -1) tags.push({ label: "วันไหม้", type: "bad" });
			}
		}

		// วันเก้ากอง ไม่ได้อยู่ใน day.tags ของไฟล์รายวัน (อยู่แค่ในสรุปรายเดือน) เลยเช็กแยกเสมอ
		var notesForNineHeap = lannaService.getMonthNotes(month);
		if (notesForNineHeap && notesForNineHeap.nineHeapDays && notesForNineHeap.nineHeapDays.indexOf(date) !== -1) {
			var alreadyHas = tags.some(function (t) { return t.label === "วันเก้ากอง"; });
			if (!alreadyHas) {
				tags.push({ label: "วันเก้ากอง", type: notesForNineHeap.cremationOk ? "good" : "bad" });
			}
		}

		return tags;
	}

	function pad2(n) { return n < 10 ? "0" + n : "" + n; }

	function todayDateStr() {
		var t = new Date();
		return t.getFullYear() + "-" + pad2(t.getMonth() + 1) + "-" + pad2(t.getDate());
	}

	/* ===== ที่มา (ท้ายปฏิทิน) =====
	   แทนที่กล่อง #lc-year-card เดิมที่เคยโชว์ข้อมูลปีมะเมีย/นักษัตร/ที่มา
	   รวมกันไว้ด้านบน ตอนนี้เหลือแค่ข้อความ "ที่มา" อย่างเดียว แสดงท้ายปฏิทิน */
	function renderYearSource() {
		var el = document.getElementById("lc-year-source");
		if (!el) return;
		var y = lannaService.getYearInfo();
		el.innerHTML = '<p class="lc-source">ที่มา: ' + y.source + '</p>';
	}

	/* ===== ตารางเดือน ===== */
	function renderMonthTitle() {
		var titleEl = document.getElementById("lc-month-title");
		if (titleEl) {
			titleEl.textContent = MONTH_NAMES_TH[currentMonth - 1] + " " + (GREGORIAN_YEAR + BE_OFFSET);
		}
	}

	function renderGrid() {
		var grid = document.getElementById("lc-grid");
		if (!grid) return;

		// เก็บ label หัวตาราง (7 ช่องแรก) แล้วล้างที่เหลือ
		while (grid.children.length > 7) grid.removeChild(grid.lastChild);

		var firstDay = new Date(GREGORIAN_YEAR, currentMonth - 1, 1).getDay();
		var daysInMonth = new Date(GREGORIAN_YEAR, currentMonth, 0).getDate();
		var todayStr = todayDateStr();

		for (var i = 0; i < firstDay; i++) {
			var empty = document.createElement("div");
			empty.className = "lc-cell lc-cell-empty";
			grid.appendChild(empty);
		}

		for (var d = 1; d <= daysInMonth; d++) {
			var dateStr = GREGORIAN_YEAR + "-" + pad2(currentMonth) + "-" + pad2(d);
			var isToday = dateStr === todayStr;
			var day = lannaService.getDay(currentMonth, d);
			var tags = getDayTags(currentMonth, d);

			var cell = document.createElement("div");
			cell.className = "lc-cell" + (isToday ? " lc-cell-today" : "") + (selectedDate === dateStr ? " lc-cell-selected" : "");

			var dayNum = document.createElement("div");
			dayNum.className = "lc-daynum";
			dayNum.textContent = d;
			cell.appendChild(dayNum);

			if (day) {
				var lunar = document.createElement("div");
				lunar.className = "lc-lunar";
				lunar.textContent = day.lunar;
				cell.appendChild(lunar);
			}

			if (tags.length > 0) {
				var tagsWrap = document.createElement("div");
				tagsWrap.className = "lc-tags";
				var shown = tags.slice(0, 2);
				shown.forEach(function (t) {
					var tagEl = document.createElement("div");
					tagEl.className = "lc-tag " + (t.type === "good" ? "lc-tag-good" : "lc-tag-bad");
					tagEl.textContent = t.label;
					tagsWrap.appendChild(tagEl);
				});
				if (tags.length > shown.length) {
					var more = document.createElement("div");
					more.className = "lc-tag-more";
					more.textContent = "+" + (tags.length - shown.length);
					tagsWrap.appendChild(more);
				}
				cell.appendChild(tagsWrap);
			}

			(function (capturedDate, capturedCell) {
				cell.addEventListener("click", function () {
					selectDate(capturedDate, capturedCell);
				});
			})(dateStr, cell);

			grid.appendChild(cell);
		}
	}

	function selectDate(dateStr, cellEl) {
		var prevSelected = document.querySelector(".lc-cell-selected");
		if (prevSelected) prevSelected.classList.remove("lc-cell-selected");

		if (selectedDate === dateStr) {
			selectedDate = null;
			renderDayDetail(null);
			return;
		}

		selectedDate = dateStr;
		if (cellEl) cellEl.classList.add("lc-cell-selected");

		var parts = dateStr.split("-").map(Number);
		renderDayDetail(parts[2]);
	}

	/* ===== รายละเอียดวันที่เลือก ===== */
	function renderDayDetail(date) {
		var el = document.getElementById("lc-day-detail");
		if (!el) return;

		if (!date) {
			el.innerHTML = '<p class="lc-day-detail-empty">คลิกวันที่ในตารางเพื่อดูรายละเอียดฤกษ์ของวันนั้น</p>';
			return;
		}

		var weekdayName = WEEKDAY_NAMES_TH[new Date(GREGORIAN_YEAR, currentMonth - 1, date).getDay()];
		var day = lannaService.getDay(currentMonth, date);
		var tags = getDayTags(currentMonth, date);

		var html = "";
		html += '<h4>วันที่ ' + date + ' ' + MONTH_NAMES_TH[currentMonth - 1] + ' ' + (GREGORIAN_YEAR + BE_OFFSET) + ' (' + weekdayName + ')</h4>';

		if (day) {
			html += '<p>จันทรคติ: ' + day.lunar + ' &middot; ฟ้าตีแส่งเศษ: ' + day.faTiSaengSet + '</p>';
			html += '<p>ชื่อวันไท: ' + day.lannaDayName + ' / ' + day.lannaDaySubName + '</p>';
			if (day.note) html += '<p><strong>หมายเหตุ:</strong> ' + day.note + '</p>';
		}

		if (tags.length > 0) {
			html += '<div class="lc-day-detail-tags">';
			tags.forEach(function (t) {
				var meaning = lannaService.explainTag(t.label) || "";
				html += '<div class="lc-day-detail-tag ' + t.type + '">';
				html += '<span class="lc-tag-name">' + t.label + '</span>';
				html += '<span>' + (meaning || "") + '</span>';
				html += '</div>';
			});
			html += '</div>';
		} else {
			html += '<p class="lc-day-detail-empty">ไม่มีแท็กพิเศษสำหรับวันนี้</p>';
		}

		el.innerHTML = html;
	}

	/* ===== เปลี่ยนเดือน ===== */
	function prevMonth() {
		currentMonth = currentMonth <= 1 ? 12 : currentMonth - 1;
		selectedDate = null;
		renderMonthTitle();
		renderGrid();
		renderDayDetail(null);
	}

	function nextMonth() {
		currentMonth = currentMonth >= 12 ? 1 : currentMonth + 1;
		selectedDate = null;
		renderMonthTitle();
		renderGrid();
		renderDayDetail(null);
	}

	/* ===== Init ===== */
	function initLannaCalendar(basePath) {
		LannaCalendar.load(basePath).then(function (service) {
			lannaService = service;
			renderYearSource();
			renderMonthTitle();
			renderGrid();
			renderDayDetail(null);

			var prevBtn = document.getElementById("lc-prev-month");
			var nextBtn = document.getElementById("lc-next-month");
			if (prevBtn) prevBtn.addEventListener("click", prevMonth);
			if (nextBtn) nextBtn.addEventListener("click", nextMonth);
		}).catch(function (err) {
			console.error("โหลดปฏิทินล้านนาไม่สำเร็จ:", err);
			var sourceEl = document.getElementById("lc-year-source");
			if (sourceEl) sourceEl.innerHTML = "";
			var gridWrap = document.getElementById("lc-grid");
			if (gridWrap) gridWrap.innerHTML = "";
		});
	}

	window.initLannaCalendar = initLannaCalendar;
})(window, document);