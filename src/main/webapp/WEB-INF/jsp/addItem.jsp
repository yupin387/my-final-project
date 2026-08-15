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
	href="${pageContext.request.contextPath}/static/css/addItem.css?v=2">
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
				<a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">รายการงาน</a>
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

					<%-- ประเภท Item
					     FIX: ตัดตัวเลือก "แพ็กเกจ" ออกจากฟอร์มนี้ ห้ามเจ้าหน้าที่สร้าง item
					     ประเภทแพ็กเกจเอง เพราะ item แพ็กเกจมีกฎพิเศษที่ฟอร์มทั่วไปนี้ไม่รองรับ:
					       1) itemName ต้องตรงกับ ceremony.ceremonyName เป๊ะๆ (ดู QuotationService
					          ที่ match ด้วย itemName == ceremonyName) ถ้าพิมพ์ผิด/เว้นวรรคต่าง
					          จะทำให้แพ็กเกจไม่แสดงผลในหน้าใบเสนอราคา (บั๊กที่เจอมาก่อนหน้านี้)
					       2) แพ็กเกจแต่ละตัวต้องผูกกับ ceremony ตายตัวตามระดับราคา (เช่น
					          "แพ็กเกจอิ่มบุญ" ผูกกับทำบุญบ้าน/ขึ้นบ้านใหม่/ทำบุญออฟฟิศ ระดับอิ่มบุญ
					          เท่านั้น) ไม่ใช่เลือกพิธีได้อิสระแบบ checkbox เหมือน item ทั่วไป
					       3) ราคาที่ระบบใช้แสดงผลจริงคือ ceremony.basePrice ไม่ใช่ item.pricePerUnit
					          ถ้าสร้าง item แพ็กเกจใหม่ผ่านฟอร์มนี้แล้วตั้งราคาเอง จะกลายเป็นราคา
					          ไม่ตรงกับที่แสดงในหน้าจอง/ใบเสนอราคา
					     แพ็กเกจทั้งหมดถูกกำหนดไว้แล้วจาก seed data (Run.java) การเพิ่ม/แก้ไขแพ็กเกจ
					     ควรทำผ่านช่องทางที่ผูกกับ Ceremony โดยตรงแทน ไม่ใช่ผ่านฟอร์มสร้าง Item ทั่วไป --%>
					<div class="form-group">
						<div class="section-label">ประเภท Item</div>
						<div class="type-options">
							<c:forEach var="t" items="${itemTypes}">
								<c:if test="${t.itemTypeName != 'แพ็กเกจ'}">
									<input type="radio" name="typeId" value="${t.itemTypeId}"
										id="type_${t.itemTypeId}" required>
									<label for="type_${t.itemTypeId}" class="type-label">${t.itemTypeName}</label>
								</c:if>
							</c:forEach>
						</div>
						<p style="font-size: 12px; color: var(--text-muted); margin-top: 6px;">
							* แพ็กเกจ (มาตรฐาน/อิ่มบุญ/พรีเมียม) เป็นรายการที่กำหนดไว้จากส่วนกลาง
							ไม่สามารถสร้างหรือแก้ไขผ่านหน้านี้ได้
						</p>
					</div>

					<hr class="divider">

					<%-- ใช้กับพิธี --%>
					<div class="form-group">
						<div class="section-label">ใช้กับพิธีไหนได้บ้าง</div>
						<%-- แก้ไข: เดิมวน ${ceremonies} แบบแบน ๆ ทั้ง 12 แถว โชว์แค่ชื่อแพ็กเกจ
						     (มาตรฐาน/อิ่มบุญ/พรีเมียม/กำหนดเอง) ซ้ำกัน 3 รอบ แยกไม่ออกว่าเป็นของ
						     ประเภทงานไหน เปลี่ยนมาวน ${groupedCeremonies} ที่ Controller จัดกลุ่ม
						     ตามประเภทงานไว้แล้ว แสดงเป็นกลุ่มมีหัวข้อคั่นแทน --%>
						<div class="ceremony-box">
							<c:forEach var="entry" items="${groupedCeremonies}">
								<div class="ceremony-type-group">
									<div class="ceremony-type-heading">${entry.key}</div>
									<div class="ceremony-type-options">
										<c:forEach var="c" items="${entry.value}">
											<div class="ceremony-item">
												<input type="checkbox" name="ceremonyIds"
													value="${c.ceremonyId}" id="cer_${c.ceremonyId}">
												<label for="cer_${c.ceremonyId}"
													class="ceremony-check-label">${c.ceremonyName}</label>
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
								<label>หน่วยนับ</label> <select name="unit" required>
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

	<script src="${pageContext.request.contextPath}/static/js/itemList.js"></script>
</body>
</html>
