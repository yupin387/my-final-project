/* calendarPage.js
   อ่านข้อมูลจาก #calendarData (ที่ JSP เตรียมไว้) แล้วตั้งค่า window.* ให้ home.js ใช้
   ต้องโหลดก่อน home.js */
(function () {
	var el = document.getElementById("calendarData");
	if (!el) return;

	window.contextPath = el.dataset.contextPath || "";
	window.teamCount = Number(el.dataset.teamCount) || 2;

	// วันที่เต็ม/มีงานแล้ว
	window.bookedDates = Array.prototype.map.call(
		el.querySelectorAll("[data-booked]"),
		function (s) { return s.dataset.booked; }
	);

	// จำนวนคิวต่อวัน
	window.bookingsPerDate = {};
	Array.prototype.forEach.call(el.querySelectorAll("[data-bookings-date]"), function (s) {
		window.bookingsPerDate[s.dataset.bookingsDate] = Number(s.dataset.count);
	});

	// แท็กฤกษ์ดี/วันควรเลี่ยง ต่อวัน
	window.dayQuality = {};
	Array.prototype.forEach.call(el.querySelectorAll("[data-quality-date]"), function (d) {
		window.dayQuality[d.dataset.qualityDate] = Array.prototype.map.call(
			d.querySelectorAll("span[data-type]"),
			function (t) { return { type: t.dataset.type, label: t.dataset.label }; }
		);
	});

	// ประเภทงานบุญสำหรับ popup
	window.ceremonyTypes = Array.prototype.map.call(
		el.querySelectorAll("[data-ceremony-id]"),
		function (s) {
			return {
				id: Number(s.dataset.ceremonyId),
				name: s.dataset.name,
				image: window.contextPath + "/static/images/" + s.dataset.image,
				packageCount: Number(s.dataset.packageCount)
			};
		}
	);
})();