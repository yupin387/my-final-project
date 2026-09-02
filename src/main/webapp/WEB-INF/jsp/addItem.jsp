<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>เพิ่มรายการอุปกรณ์ - บุญมีนำพา จัดงานบุญ</title>
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/addItem.css?v=8">
</head>
<body>

	<%-- ========== NAVBAR (เหมือนหน้า list) ========== --%>
	<nav class="navbar">
		<a class="navbar-brand" href="${pageContext.request.contextPath}/staff/assignments">
			<img src="${pageContext.request.contextPath}/static/images/logoo.png"
				 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon">
			<span class="navbar-title">บุญมีนำพา รับจัดงานบุญ</span>
		</a>
		<div class="navbar-right">
			<nav class="navbar-menu">
				<a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">งานที่ได้รับมอบหมาย</a>
				<a href="${pageContext.request.contextPath}/staff/items" class="nav-item active">จัดการรายการอุปกรณ์</a>
			</nav>
			<div class="user-info" onclick="toggleDropdown()">
				<div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
				<span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
				<span class="arrow">▾</span>
				<div class="dropdown-menu" id="dropdownMenu">
					<a href="${pageContext.request.contextPath}/staff/profile" class="dropdown-item">โปรไฟล์</a>
					<a href="${pageContext.request.contextPath}/headstaff/logout" class="dropdown-item danger">ออกจากระบบ</a>
				</div>
			</div>
		</div>
	</nav>

	<%-- PAGE --%>
	<div class="page-wrapper">
		<div class="content-card">

			<div class="card-header-bar">
				<div class="header-ornament">
					<div class="orn-line"></div>
					<div class="orn-diamond"></div>
					<div class="orn-line right"></div>
				</div>
				<h1>เพิ่มรายการอุปกรณ์ใหม่</h1>
				<p>ระบุรายละเอียดอุปกรณ์และประเภทพิธีที่สามารถใช้งานได้</p>
			</div>

			<div class="card-body">

				<c:if test="${not empty error}">
					<div class="alert error">${error}</div>
				</c:if>

				<form action="${pageContext.request.contextPath}/staff/items/save"
					method="post" class="form-section">

					<%-- ===== ประเภทอุปกรณ์: dropdown
					     ตัดตัวเลือก "แพ็กเกจ" ออกจากฟอร์มนี้ ห้ามเจ้าหน้าที่สร้างรายการ
					     ประเภทแพ็กเกจเอง — backend มี validation กันซ้ำไว้ที่ ItemService --%>
					<div class="form-group">
						<div class="section-label">ประเภทอุปกรณ์</div>
						<select name="typeId" id="itemTypeSelect" class="form-select" required>
							<option value="" disabled ${empty param.typeId ? 'selected' : ''}>-- เลือกประเภทอุปกรณ์ --</option>
							<c:forEach var="t" items="${itemTypes}">
								<c:if test="${t.itemTypeName != 'แพ็กเกจ'}">
									<option value="${t.itemTypeId}"
										${param.typeId == t.itemTypeId ? 'selected' : ''}>${t.itemTypeName}</option>
								</c:if>
							</c:forEach>
						</select>
					</div>

					<%-- ===== ใช้กับพิธีไหนได้บ้าง: progressive disclosure
					     แต่ละ checkbox มีช่องกรอก "ใช้ ... หน่วย" คู่กัน เพราะอุปกรณ์ตัวเดียวกัน
					     ใช้จำนวนไม่เท่ากันได้ในแต่ละแพ็กเกจ ช่องนี้ disabled ไว้ก่อนถ้ายังไม่ติ๊ก
					     checkbox — input ที่ disabled จะไม่ถูกส่งไปกับฟอร์มตอน submit ทำให้
					     ceremonyIds[] กับ quantities[] ที่ backend รับมามีจำนวนสมาชิกและ
					     ลำดับตรงกันเสมอ

					     FIX: หัวแต่ละกลุ่มใช้ checkbox "เลือกทั้งหมด" แบบ select-all มาตรฐาน
					     แทนปุ่ม เลือกทั้งหมด/ล้างการเลือก/นำออก — ไม่ติ๊กเลือกทั้งหมด = ล้างการติ๊ก
					     ในกลุ่มนั้นทั้งหมด, ติ๊กครึ่งเดียว = แสดงสถานะ indeterminate --%>
					<div class="form-group">
						<div class="section-label">ใช้กับพิธีไหนได้บ้าง</div>
						<p class="field-hint">
							เลือกได้หลายประเภทงาน แต่ละแพ็กเกจกำหนดจำนวนอุปกรณ์ที่ใช้ได้ไม่เท่ากัน<br>
							* ไม่เลือกเลย = เป็นรายการให้สมาชิกเลือกเพิ่มเองภายหลัง
						</p>

						<div class="ceremony-adder-row">
							<select id="ceremonyTypeAdder" class="form-select">
								<option value="">-- เลือกประเภทงานเพื่อเพิ่ม --</option>
								<c:forEach var="entry" items="${groupedCeremonies}">
									<option value="grp_${entry.key}">${entry.key}</option>
								</c:forEach>
							</select>
						</div>

						<div id="selectedCeremonyGroups">
							<c:forEach var="entry" items="${groupedCeremonies}">
								<div class="ceremony-type-group" id="grp_${entry.key}" style="display:none;">
									<div class="ceremony-type-heading-row">
										<div class="ceremony-type-heading">${entry.key}</div>
										<div class="ceremony-heading-right">
											<label class="ceremony-select-all-label">
												<input type="checkbox" class="select-all-checkbox"
													data-group="grp_${entry.key}"
													onchange="onSelectAllChange(this)">
												เลือกทั้งหมด
											</label>
											<button type="button" class="btn-close-group"
												title="ปิดกลุ่มนี้ (ยกเลิกการเลือกทั้งหมด)"
												onclick="closeGroup('grp_${entry.key}')">✕</button>
										</div>
									</div>
									<div class="ceremony-type-options" data-group="grp_${entry.key}">
										<c:forEach var="c" items="${entry.value}">
											<div class="ceremony-item">
												<input type="checkbox" name="ceremonyIds"
													value="${c.ceremonyId}" id="cer_${c.ceremonyId}"
													data-group="grp_${entry.key}"
													onchange="toggleQtyInput(this, 'qty_${c.ceremonyId}')">
												<label for="cer_${c.ceremonyId}"
													class="ceremony-check-label">${c.ceremonyName}</label>
												<span class="qty-inline-wrap">
													ใช้
													<input type="number" name="quantities" id="qty_${c.ceremonyId}"
														class="qty-mini-input" min="1" value="1" disabled>
													หน่วย
												</span>
											</div>
										</c:forEach>
									</div>
								</div>
							</c:forEach>
							<div id="ceremonyEmptyHint" class="ceremony-empty-hint">
								ยังไม่ได้เพิ่มประเภทงานไหนเลย — เลือกจากช่องด้านบนเพื่อเริ่มผูกแพ็กเกจ
							</div>
						</div>
					</div>

					<%-- รายละเอียดอุปกรณ์ --%>
					<div class="form-group">
						<div class="section-label">รายละเอียดอุปกรณ์</div>
						<div style="display: flex; flex-direction: column; gap: 12px;">
							<div class="form-group">
								<label>ชื่ออุปกรณ์</label> <input type="text" name="itemName"
									placeholder="เช่น ชุดสายสิญจน์มงคล" required
									value="${param.itemName}">
							</div>
							<div class="form-group">
								<label>คำอธิบายเพิ่มเติม</label>
								<textarea name="itemDetail"
									placeholder="คำอธิบายเพิ่มเติมเกี่ยวกับอุปกรณ์...">${param.itemDetail}</textarea>
							</div>
						</div>
					</div>

					<%-- ราคา & หน่วย --%>
					<div class="form-group">
						<div class="section-label">ราคาและหน่วยนับ</div>
						<div class="form-row">
							<div class="form-group">
								<label>ราคาต่อหน่วย (บาท)</label> <input type="number"
									name="pricePerUnit" placeholder="0.00" step="0.01" min="0" required
									value="${param.pricePerUnit}">
								<p class="field-hint">กรอกเป็นตัวเลข ทศนิยมได้ไม่เกิน 2 ตำแหน่ง เช่น 250.00</p>
							</div>
							<div class="form-group">
								<label>หน่วยนับ</label> <select name="unit" required class="form-select">
									<option value="">-- เลือกหน่วย --</option>
									<option value="ชุด"
										${param.unit == 'ชุด'     ? 'selected' : ''}>ชุด</option>
									<option value="ชิ้น"
										${param.unit == 'ชิ้น'    ? 'selected' : ''}>ชิ้น</option>
									<option value="โหล"
										${param.unit == 'โหล'     ? 'selected' : ''}>โหล</option>
									<option value="เครื่อง"
										${param.unit == 'เครื่อง' ? 'selected' : ''}>เครื่อง</option>
									<option value="รูป"
										${param.unit == 'รูป'     ? 'selected' : ''}>รูป</option>
									<option value="ตัว"
										${param.unit == 'ตัว'     ? 'selected' : ''}>ตัว</option>
									<option value="ใบ" ${param.unit == 'ใบ'      ? 'selected' : ''}>ใบ</option>
									<option value="เถา"
										${param.unit == 'เถา'     ? 'selected' : ''}>เถา</option>
									<option value="อัน"
										${param.unit == 'อัน'     ? 'selected' : ''}>อัน</option>
									<option value="คู่"
										${param.unit == 'คู่'     ? 'selected' : ''}>คู่</option>
									<option value="องค์"
										${param.unit == 'องค์'    ? 'selected' : ''}>องค์</option>
									<option value="ผืน"
										${param.unit == 'ผืน'     ? 'selected' : ''}>ผืน</option>
									<option value="ต้น"
										${param.unit == 'ต้น'     ? 'selected' : ''}>ต้น</option>
								</select>
							</div>
						</div>
					</div>

					<div class="form-actions">
						<button type="submit" class="btn-submit">บันทึกอุปกรณ์</button>
						<button type="button" class="btn-cancel"
							onclick="window.location.href='${pageContext.request.contextPath}/staff/items'">ยกเลิก</button>
					</div>

				</form>
			</div>
		</div>
	</div>
	
<%-- ===== Footer (สำหรับหัวหน้างาน) ===== --%>
<footer class="site-footer">

    <%-- ===== ลายดอกบัวมุมล่างขวา (เกาะติด footer) ===== --%>
    <img src="${pageContext.request.contextPath}/static/images/lotus-corner.png"
         alt="" class="lotus-decoration" aria-hidden="true">

    <div class="footer-content">
        <div class="footer-brand">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
            <span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
        </div>
        <p class="footer-tagline">ระบบจัดการงานบุญสำหรับหัวหน้างาน</p>
    </div>

</footer>

	<script>
		function toggleQtyInput(checkbox, qtyInputId) {
			var qtyInput = document.getElementById(qtyInputId);
			if (!qtyInput) return;
			qtyInput.disabled = !checkbox.checked;
			if (checkbox.checked && !qtyInput.value) {
				qtyInput.value = 1;
			}
			syncSelectAllState(checkbox.getAttribute('data-group'));
		}

		/* ===== select-all checkbox ต่อกลุ่ม ===== */
		function onSelectAllChange(selectAllBox) {
			var groupKey = selectAllBox.getAttribute('data-group');
			var container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
			if (!container) return;
			var checked = selectAllBox.checked;
			var boxes = container.querySelectorAll('input[type="checkbox"]');
			boxes.forEach(function (cb) {
				cb.checked = checked;
				var qtyInput = document.getElementById('qty_' + cb.value);
				if (qtyInput) {
					qtyInput.disabled = !checked;
					if (checked && !qtyInput.value) qtyInput.value = 1;
				}
			});
			selectAllBox.indeterminate = false;
		}

		function syncSelectAllState(groupKey) {
			var container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
			var selectAllBox = document.querySelector('.select-all-checkbox[data-group="' + groupKey + '"]');
			if (!container || !selectAllBox) return;
			var boxes = container.querySelectorAll('input[type="checkbox"]');
			var total = boxes.length;
			var checkedCount = 0;
			boxes.forEach(function (cb) { if (cb.checked) checkedCount++; });
			if (checkedCount === 0) {
				selectAllBox.checked = false;
				selectAllBox.indeterminate = false;
			} else if (checkedCount === total) {
				selectAllBox.checked = true;
				selectAllBox.indeterminate = false;
			} else {
				selectAllBox.checked = false;
				selectAllBox.indeterminate = true;
			}
		}

		/* ===== ปิดกลุ่ม: ยกเลิกการติ๊กทั้งหมดในกลุ่ม แล้วซ่อนกลุ่มนั้นกลับไป
		   นี่คือวิธีเดียวที่ "เอาแพ็กเกจที่เลือกผิดออก" — เลือกชื่อเดิมซ้ำใน dropdown ด้านบน
		   จะไม่มีผล เพราะกลุ่มถูกเปิดค้างอยู่แล้ว ต้องกดปุ่ม ✕ นี้แทน ===== */
		function closeGroup(groupKey) {
			var group = document.getElementById(groupKey);
			if (!group) return;
			var container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
			if (container) {
				var boxes = container.querySelectorAll('input[type="checkbox"]');
				boxes.forEach(function (cb) {
					cb.checked = false;
					var qtyInput = document.getElementById('qty_' + cb.value);
					if (qtyInput) {
						qtyInput.disabled = true;
					}
				});
			}
			var selectAllBox = document.querySelector('.select-all-checkbox[data-group="' + groupKey + '"]');
			if (selectAllBox) {
				selectAllBox.checked = false;
				selectAllBox.indeterminate = false;
			}
			group.style.display = 'none';
			updateEmptyHint();
		}

		function updateEmptyHint() {
			var hint = document.getElementById('ceremonyEmptyHint');
			var groups = document.querySelectorAll('#selectedCeremonyGroups .ceremony-type-group');
			var hasVisible = false;
			groups.forEach(function (g) {
				if (g.style.display !== 'none') hasVisible = true;
			});
			if (hint) hint.style.display = hasVisible ? 'none' : 'block';
		}

		document.getElementById('ceremonyTypeAdder').addEventListener('change', function () {
			var groupKey = this.value;
			if (!groupKey) return;
			var group = document.getElementById(groupKey);
			if (group) group.style.display = 'block';
			this.value = '';
			updateEmptyHint();
		});

		document.addEventListener('DOMContentLoaded', updateEmptyHint);

		/* ===== แจ้งเตือนเลขติดลบแบบเรียลไทม์ (ไม่บล็อกการพิมพ์ - ทั้งคู่)

		   หมายเหตุสำคัญ: input type="number" ของเบราว์เซอร์ ถ้าพิมพ์ "-" เดี่ยวๆ
		   (ยังไม่ตามด้วยตัวเลข) ค่า .value จะเป็นค่าว่างเสมอ (เพราะยังไม่ใช่ตัวเลขที่สมบูรณ์)
		   ต้องเช็ค this.validity.badInput ร่วมด้วยถึงจะจับได้ว่าเขาพิมพ์ - อยู่จริง

		   1) ช่อง "ใช้...หน่วย" (qty-mini-input) -> ข้อความขึ้นท้ายกรอบใหญ่ของกลุ่มพิธีนั้น
		   2) ช่อง "ราคาต่อหน่วย" (pricePerUnit)   -> ข้อความขึ้นใต้ช่องนั้นเลย

		   ทั้งคู่: โชว์ทันทีตอนพิมพ์ - (keydown) และคงอยู่ตราบใดที่ค่ายังติดลบ/พิมพ์ค้าง (input)
		   หายไปทันทีเมื่อแก้ไขจนถูกต้อง หรือออกจากช่อง (blur) ===== */

		function isMinusKey(e) {
			return e.key === '-' || e.key === 'Subtract' || e.keyCode === 189 || e.keyCode === 109;
		}

		function hasNegativeInput(inp) {
			return inp.value.indexOf('-') !== -1 || inp.validity.badInput;
		}

		/* ---- (1) กลุ่ม qty: ข้อความอยู่ท้ายกรอบใหญ่ของกลุ่มพิธีนั้น ---- */
		function getGroupErrorEl(groupEl) {
			var id = 'negerr_' + groupEl.id;
			var el = document.getElementById(id);
			if (!el) {
				el = document.createElement('div');
				el.id = id;
				el.className = 'no-negative-error-group';
				el.style.color = '#d32f2f';
				el.style.fontSize = '12px';
				el.style.margin = '4px 0 8px';
				el.style.display = 'none';
				groupEl.insertAdjacentElement('afterend', el);
			}
			return el;
		}

		function showGroupError(qtyInput) {
			var groupEl = qtyInput.closest('.ceremony-type-group');
			if (!groupEl) return;
			var el = getGroupErrorEl(groupEl);
			el.textContent = 'ห้ามใส่เลขติดลบ';
			el.style.display = 'block';
		}

		function hideGroupError(qtyInput) {
			var groupEl = qtyInput.closest('.ceremony-type-group');
			if (!groupEl) return;
			var el = document.getElementById('negerr_' + groupEl.id);
			if (el) el.style.display = 'none';
		}

		/* ---- (2) ช่องราคาต่อหน่วย: ข้อความอยู่ใต้ช่องนั้นเลย ---- */
		function getFieldErrorEl(inp) {
			var id = 'negerr_' + (inp.id || inp.name);
			var el = document.getElementById(id);
			if (!el) {
				el = document.createElement('div');
				el.id = id;
				el.className = 'no-negative-error';
				el.style.color = '#d32f2f';
				el.style.fontSize = '12px';
				el.style.marginTop = '2px';
				el.style.display = 'none';
				inp.insertAdjacentElement('afterend', el);
			}
			return el;
		}

		function showFieldError(inp) {
			var el = getFieldErrorEl(inp);
			el.textContent = 'ห้ามใส่เลขติดลบ';
			el.style.display = 'block';
		}

		function hideFieldError(inp) {
			var el = document.getElementById('negerr_' + (inp.id || inp.name));
			if (el) el.style.display = 'none';
		}

		function applyNoNegative() {
			document.querySelectorAll('input[type="number"]').forEach(function (inp) {
				if (inp.dataset.noNegativeBound) return; // กันผูก event ซ้ำ
				inp.dataset.noNegativeBound = '1';

				var isQty = inp.classList.contains('qty-mini-input');
				var showFn = isQty ? showGroupError : showFieldError;
				var hideFn = isQty ? hideGroupError : hideFieldError;

				/* พิมพ์ - ปุ๊บ โชว์ทันที (ไม่ preventDefault แล้ว ปล่อยให้พิมพ์ได้) */
				inp.addEventListener('keydown', function (e) {
					if (isMinusKey(e)) {
						showFn(this);
					}
				});

				/* หลังค่าเปลี่ยน (พิมพ์เพิ่ม/ลบ/วาง) เช็คซ้ำว่ายังติดลบอยู่ไหม
				   ถ้าแก้จนถูกต้องแล้ว -> ซ่อนทันที
				   ถ้ายังไม่ถูก -> ค้างไว้ที่เดิม ไม่ซ่อนแม้ออกจากช่องไปแล้ว (ไม่มี blur-hide อีกต่อไป) */
				inp.addEventListener('input', function () {
					if (hasNegativeInput(this)) {
						showFn(this);
					} else {
						hideFn(this);
					}
				});

				/* ปิดกล่องแจ้งเตือนสีส้ม/เหลืองของเบราว์เซอร์เอง (เช่น "Value must be
				   greater than or equal to 1.") ไม่ต้องการให้ขึ้นซ้อนกับข้อความแดงของเรา
				   ตัวช่องจะยัง invalid ตามปกติ (กันส่ง submit ได้เหมือนเดิม) แค่ไม่โชว์ popup */
				inp.addEventListener('invalid', function (e) {
					e.preventDefault();
				});
			});
		}

		/* ===== กันกดบันทึกทั้งที่ยังมีค่าติดลบ/พิมพ์ค้างอยู่ในฟอร์ม
		   ถ้าเจอ -> ไม่ให้ submit ไปไหน อยู่หน้าเดิม พร้อมโชว์ข้อความแจ้งเตือนทุกช่องที่ยังผิดค้างไว้ ===== */
		function guardFormSubmit() {
			var formEl = document.querySelector('form.form-section');
			if (!formEl) return;
			formEl.addEventListener('submit', function (e) {
				var hasInvalid = false;
				var firstInvalid = null;
				document.querySelectorAll('input[type="number"]').forEach(function (inp) {
					if (hasNegativeInput(inp)) {
						hasInvalid = true;
						if (!firstInvalid) firstInvalid = inp;
						var isQty = inp.classList.contains('qty-mini-input');
						(isQty ? showGroupError : showFieldError)(inp);
					}
				});
				if (hasInvalid) {
					e.preventDefault();
					if (firstInvalid) firstInvalid.focus();
				}
			});
		}

		document.addEventListener('DOMContentLoaded', applyNoNegative);
		document.addEventListener('DOMContentLoaded', guardFormSubmit);
	</script>

	<script src="${pageContext.request.contextPath}/static/js/itemList.js"></script>
</body>
</html>
