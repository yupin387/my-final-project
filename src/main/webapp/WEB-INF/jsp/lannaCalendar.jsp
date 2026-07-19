<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ปฏิทินล้านนา ปี 2569</title>
<style>
    .lanna-wrap { max-width: 900px; margin: 0 auto; padding: 24px; font-family: 'Sarabun', sans-serif; }
    .lanna-year-card { background: #f4ede3; border-radius: 12px; padding: 20px; margin-bottom: 24px; }
    .lanna-year-card h2 { margin-top: 0; color: #7a4a1e; }
    .lanna-month-select { margin-bottom: 16px; }
    .lanna-month-select select { padding: 8px 12px; font-size: 16px; border-radius: 8px; }
    .lanna-tag-list { display: flex; flex-wrap: wrap; gap: 8px; margin: 8px 0; }
    .lanna-tag { background: #eee; border-radius: 20px; padding: 4px 12px; font-size: 14px; }
    .lanna-tag.good { background: #d7f0d0; }
    .lanna-tag.bad { background: #f5d5d5; }
    .lanna-day-detail { border: 1px solid #ddd; border-radius: 10px; padding: 16px; margin-top: 16px; }
    .loading { color: #888; }
</style>
</head>
<body>

<div class="lanna-wrap">
    <h1>ปฏิทินล้านนา ปี พ.ศ. 2569</h1>

    <div id="lanna-year-card" class="lanna-year-card loading">กำลังโหลดข้อมูลปี...</div>

    <div class="lanna-month-select">
      <label for="month-picker">เลือกเดือน: </label>
      <select id="month-picker">
        <option value="1">มกราคม</option>
        <option value="2">กุมภาพันธ์</option>
        <option value="3">มีนาคม</option>
        <option value="4" selected>เมษายน</option>
        <option value="5">พฤษภาคม</option>
        <option value="6">มิถุนายน</option>
        <option value="7">กรกฎาคม</option>
        <option value="8">สิงหาคม</option>
        <option value="9">กันยายน</option>
        <option value="10">ตุลาคม</option>
        <option value="11">พฤศจิกายน</option>
        <option value="12">ธันวาคม</option>
      </select>
    </div>

    <div id="lanna-month-summary" class="loading">กำลังโหลดข้อมูลเดือน...</div>

    <div id="lanna-day-picker-wrap" style="display:none;">
      <label for="day-picker">ดูรายละเอียดวันที่ (มีเฉพาะเดือนเมษายน): </label>
      <select id="day-picker"></select>
    </div>

    <div id="lanna-day-detail"></div>
</div>

<%-- ไฟล์นี้ต้อง include ไว้ (เอาจาก /js/LannaCalendar.js ที่วางไว้ใน static/js/) --%>
<script src="${pageContext.request.contextPath}/js/LannaCalendar.js"></script>
<script>
    let lannaService = null;

    async function initLannaPage() {
      lannaService = await LannaCalendar.load('${pageContext.request.contextPath}/data');
      renderYearCard();
      renderMonth(document.getElementById('month-picker').value);
    }

    function renderYearCard() {
      const y = lannaService.getYearInfo();
      const card = document.getElementById('lanna-year-card');
      card.classList.remove('loading');
      card.innerHTML = `
        <h2>${y.yearNameLanna} (${y.yearNameThaiZodiac})</h2>
        <p>จุลศักราช ${y.chulasakarat} · พ.ศ. ${y.buddhistEra}</p>
        <p>ดอกไม้ประจำปี: <strong>${y.yearFlower}</strong></p>
        <p>พระธาตุประจำปี: <strong>${y.yearPagoda.name}</strong> (${y.yearPagoda.location})</p>
        <p>วันสังขานต์ล่อง: ${y.songkran2026.sangkhanLuang}</p>
        <p>วันเน่า: ${y.songkran2026.wanNao}</p>
        <p>วันพญาวัน: ${y.songkran2026.wanPhayaWan}</p>
        <p style="font-size:12px;color:#888;">ที่มา: ${y.source}</p>
      `;
    }

    function renderMonth(month) {
      const notes = lannaService.getMonthNotes(Number(month));
      const summaryEl = document.getElementById('lanna-month-summary');
      summaryEl.classList.remove('loading');

      const tagRow = (label, arr, cls) =>
        arr && arr.length
          ? `<p>${label}: <span class="lanna-tag-list">${arr.map(d => `<span class="lanna-tag ${cls}">${d}</span>`).join('')}</span></p>`
          : '';

      summaryEl.innerHTML = `
        <h3>${notes.monthName} 2569</h3>
        ${tagRow('วันดี', notes.goodDays, 'good')}
        ${tagRow('วันหัวเรียงหมอน (แต่งงาน)', notes.weddingDays, 'good')}
        ${tagRow('วันเสีย', notes.sickDays, 'bad')}
        ${tagRow('วันวอดวาย', notes.ruinDays, 'bad')}
        ${tagRow('วันมัจจุ', notes.deathDays, 'bad')}
        ${tagRow('วันไหม้', notes.fireDays, 'bad')}
        ${tagRow('วันเก้ากอง' + (notes.cremationOk ? ' (เผาศพได้)' : ' (ไม่ควรเผาศพ)'), notes.nineHeapDays, 'bad')}
      `;

      // เดือนเมษายนมีข้อมูลรายวันครบ — โชว์ dropdown เลือกวัน
      const dayPickerWrap = document.getElementById('lanna-day-picker-wrap');
      const dayPicker = document.getElementById('day-picker');
      const dayDetailEl = document.getElementById('lanna-day-detail');
      dayDetailEl.innerHTML = '';

      if (Number(month) === 4) {
        dayPickerWrap.style.display = 'block';
        dayPicker.innerHTML = '';
        for (let d = 1; d <= 30; d++) {
          const opt = document.createElement('option');
          opt.value = d;
          opt.textContent = `${d} เมษายน`;
          dayPicker.appendChild(opt);
        }
        renderDay(4, 1);
        dayPicker.onchange = () => renderDay(4, Number(dayPicker.value));
      } else {
        dayPickerWrap.style.display = 'none';
      }
    }

    function renderDay(month, date) {
      const day = lannaService.getDay(month, date);
      const el = document.getElementById('lanna-day-detail');
      if (!day) { el.innerHTML = '<p>ไม่มีข้อมูลรายวันสำหรับวันนี้</p>'; return; }

      const tagsHtml = day.tags.length
        ? day.tags.map(t => {
            const meaning = lannaService.explainTag(t) || '';
            return `<span class="lanna-tag">${t}</span>${meaning ? `<br><small>${meaning}</small>` : ''}`;
          }).join('<br>')
        : '<em>ไม่มีแท็กพิเศษ</em>';

      el.innerHTML = `
        <div class="lanna-day-detail">
          <h4>วันที่ ${day.date} เมษายน (${day.weekday})</h4>
          <p>จันทรคติ: ${day.lunar} · ฟ้าตีแส่งเศษ: ${day.faTiSaengSet}</p>
          <p>ชื่อวันไท: ${day.lannaDayName} / ${day.lannaDaySubName}</p>
          <div>${tagsHtml}</div>
          ${day.note ? `<p><strong>หมายเหตุ:</strong> ${day.note}</p>` : ''}
        </div>
      `;
    }

    document.getElementById('month-picker').addEventListener('change', (e) => renderMonth(e.target.value));
    initLannaPage();
</script>

</body>
</html>
