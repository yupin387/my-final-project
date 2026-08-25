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
	href="${pageContext.request.contextPath}/static/css/addItem.css?v=5">
<style>
/* ===== เพิ่มเติมสำหรับ UI แบบใหม่ (dropdown ประเภท Item + progressive
   disclosure ของประเภทงาน + ช่องกรอกจำนวนต่อแพ็กเกจ) ===== */
.form-select {
    width: 100%;
    padding: 11px 14px;
    border: 1.5px solid var(--card-border, #F0E2D3);
    border-radius: 8px;
    font-family: 'Sarabun', sans-serif;
    font-size: 14px;
    background: var(--bg-light, #FCF6F0);
    color: var(--brown-text, #4A3728);
    cursor: pointer;
}
.form-select:focus {
    outline: none;
    border-color: var(--gold-primary, #D9A441);
    box-shadow: 0 0 0 3px rgba(201, 154, 61, 0.18);
    background: #FFFFFF;
}

.ceremony-adder-row {
    display: flex;
    gap: 10px;
    align-items: center;
    margin-bottom: 14px;
}
.ceremony-adder-row .form-select { flex: 1; }

#selectedCeremonyGroups .ceremony-type-group {
    border: 1.5px solid var(--card-border, #F0E2D3);
    border-radius: 10px;
    padding: 14px 16px;
    margin-bottom: 12px;
    background: var(--bg-light, #FCF6F0);
}

.ceremony-type-heading-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
    flex-wrap: wrap;
    gap: 8px;
}
.ceremony-quick-actions { display: flex; gap: 6px; }
.btn-quick-select,
.btn-remove-group {
    font-size: 12px;
    font-weight: 600;
    padding: 5px 12px;
    border-radius: 16px;
    cursor: pointer;
    font-family: 'Sarabun', sans-serif;
    border: 1.5px solid var(--peach-primary, #E8703A);
    background: #FFFFFF;
    color: var(--peach-primary, #E8703A);
}
.btn-quick-select:hover { background: var(--peach-primary, #E8703A); color: #FFF; }
.btn-remove-group {
    border-color: var(--red-primary, #D9534F);
    color: var(--red-primary, #D9534F);
}
.btn-remove-group:hover { background: var(--red-primary, #D9534F); color: #FFF; }

/* ===== FIX: เปลี่ยนจาก wrap แบบ 2 คอลัมน์เบียดกัน เป็น 1 แพ็กเกจต่อ 1 แถวเต็มความกว้าง
   เพื่อไม่ให้ "ใช้" กับ "หน่วย" ตกบรรทัดแยกจากช่องกรอกจำนวน ===== */
.ceremony-type-options {
    display: flex;
    flex-direction: column;
    gap: 10px;
}
.ceremony-item {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: nowrap;
    padding: 8px 10px;
    background: #FFFFFF;
    border: 1px solid var(--card-border, #F0E2D3);
    border-radius: 8px;
}
.ceremony-check-label {
    flex: 1;
    white-space: nowrap;
}
.qty-inline-wrap {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: var(--brown-muted, #8A7666);
    white-space: nowrap;
    flex-shrink: 0;
}
.qty-mini-input {
    width: 64px;
    padding: 4px 8px;
    border: 1.5px solid var(--card-border, #F0E2D3);
    border-radius: 6px;
    font-family: 'Sarabun', sans-serif;
    font-size: 13px;
    text-align: center;
    background: #FFFFFF;
}
.qty-mini-input:disabled {
    background: #F0EAE3;
    color: #B0AFA8;
    cursor: not-allowed;
}
.ceremony-empty-hint {
    font-size: 13px;
    color: var(--brown-muted, #8A7666);
    padding: 14px 4px;
    text-align: center;
    border: 1.5px dashed var(--card-border, #F0E2D3);
    border-radius: 10px;
}
</style>
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
				<a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">รายการงานที่ได้รับมอบหมาย</a>
				<a href="${pageContext.request.contextPath}/staff/items" class="nav-item active">จัดการ Item</a>
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
				<p>ระบุรายละเอียดไอเทมและประเภทพิธีที่สามารถใช้งานได้</p>
			</div>

			<div class="card-body">

				<c:if test="${not empty error}">
					<div class="alert error">${error}</div>
				</c:if>

				<form action="${pageContext.request.contextPath}/staff/items/save"
					method="post" class="form-section">

					<%-- ===== ประเภท Item: dropdown
					     FIX: ตัดตัวเลือก "แพ็กเกจ" ออกจากฟอร์มนี้ ห้ามเจ้าหน้าที่สร้าง item
					     ประเภทแพ็กเกจเอง — backend มี validation กันซ้ำไว้ที่ ItemService --%>
					<div class="form-group">
						<div class="section-label">ประเภท Item</div>
						<select name="typeId" id="itemTypeSelect" class="form-select" required>
							<option value="" disabled ${empty param.typeId ? 'selected' : ''}>-- เลือกประเภท Item --</option>
							<c:forEach var="t" items="${itemTypes}">
								<c:if test="${t.itemTypeName != 'แพ็กเกจ'}">
									<option value="${t.itemTypeId}"
										${param.typeId == t.itemTypeId ? 'selected' : ''}>${t.itemTypeName}</option>
								</c:if>
							</c:forEach>
						</select>
					</div>

					<hr class="divider">

					<%-- ===== ใช้กับพิธีไหนได้บ้าง: progressive disclosure
					     แต่ละ checkbox มีช่องกรอก "ใช้ ... หน่วย" คู่กัน เพราะ item ตัวเดียวกัน
					     ใช้จำนวนไม่เท่ากันได้ในแต่ละแพ็กเกจ ช่องนี้ disabled ไว้ก่อนถ้ายังไม่ติ๊ก
					     checkbox — input ที่ disabled จะไม่ถูกส่งไปกับฟอร์มตอน submit ทำให้
					     ceremonyIds[] กับ quantities[] ที่ backend รับมามีจำนวนสมาชิกและ
					     ลำดับตรงกันเสมอ --%>
					<div class="form-group">
						<div class="section-label">ใช้กับพิธีไหนได้บ้าง</div>
						<p style="font-size: 12px; color: var(--brown-muted); margin: -4px 0 10px;">
							เลือกได้หลายประเภทงาน แต่ละแพ็กเกจกำหนดจำนวนอุปกรณ์ที่ใช้ได้ไม่เท่ากัน<br>
							* ไม่เลือกเลย = เป็นรายการให้ลูกค้าเลือกเพิ่มเองภายหลัง
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
										<div class="ceremony-quick-actions">
											<button type="button" class="btn-quick-select"
												onclick="setGroupChecked('grp_${entry.key}', true)">เลือกทั้งหมด</button>
											<button type="button" class="btn-quick-select"
												onclick="setGroupChecked('grp_${entry.key}', false)">ล้างการเลือก</button>
											<button type="button" class="btn-remove-group"
												onclick="removeGroup('grp_${entry.key}')">✕ นำออก</button>
										</div>
									</div>
									<div class="ceremony-type-options" data-group="grp_${entry.key}">
										<c:forEach var="c" items="${entry.value}">
											<div class="ceremony-item">
												<input type="checkbox" name="ceremonyIds"
													value="${c.ceremonyId}" id="cer_${c.ceremonyId}"
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
							
						</div>
					</div>

					<hr class="divider">

					<%-- รายละเอียดอุปกรณ์ --%>
					<div class="form-group">
						<div class="section-label">รายละเอียดอุปกรณ์</div>
						<div style="display: flex; flex-direction: column; gap: 12px;">
							<div class="form-group">
								<label>ชื่อ Item</label> <input type="text" name="itemName"
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

					<hr class="divider">

					<%-- ราคา & หน่วย --%>
					<div class="form-group">
						<div class="section-label">ราคาและหน่วยนับ</div>
						<div class="form-row">
							<div class="form-group">
								<label>ราคาต่อหน่วย (บาท)</label> <input type="number"
									name="pricePerUnit" placeholder="0.00" step="0.01" required
									value="${param.pricePerUnit}">
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

					<hr class="divider">

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
		}

		function setGroupChecked(groupKey, checked) {
			var container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
			if (!container) return;
			var boxes = container.querySelectorAll('input[type="checkbox"]');
			boxes.forEach(function (cb) {
				cb.checked = checked;
				var qtyInput = document.getElementById('qty_' + cb.value);
				if (qtyInput) {
					qtyInput.disabled = !checked;
					if (checked && !qtyInput.value) qtyInput.value = 1;
				}
			});
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

		function removeGroup(groupKey) {
			var group = document.getElementById(groupKey);
			if (!group) return;
			setGroupChecked(groupKey, false);
			group.style.display = 'none';
			updateEmptyHint();
		}

		document.addEventListener('DOMContentLoaded', updateEmptyHint);
	</script>

	<script src="${pageContext.request.contextPath}/static/js/itemList.js"></script>
</body>
</html>