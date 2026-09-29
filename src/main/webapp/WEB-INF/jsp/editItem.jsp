<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>แก้ไขรายการอุปกรณ์ - บุญมีนำพา จัดงานบุญ</title>
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/editItem.css?v=7">
</head>
<body>

	<c:if test="${not empty success}">
		<span id="flash-success" data-msg="${success}" style="display: none;"></span>
	</c:if>
	<c:if test="${not empty error}">
		<span id="flash-error" data-msg="${error}" style="display: none;"></span>
	</c:if>

	<%-- ========== NAVBAR ========== --%>
	<nav class="navbar">
		<a class="navbar-brand"
			href="${pageContext.request.contextPath}/staff/assignments"> <img
			src="${pageContext.request.contextPath}/static/images/logoo.png"
			alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon"> <span
			class="navbar-title">บุญมีนำพา รับจัดงานบุญ</span>
		</a>
		<div class="navbar-right">
			<nav class="navbar-menu">
				<a href="${pageContext.request.contextPath}/staff/assignments"
					class="nav-item">งานที่ได้รับมอบหมาย</a>
				<a href="${pageContext.request.contextPath}/staff/items"
					class="nav-item active">จัดการรายการอุปกรณ์</a>
			</nav>
			<div class="user-info" onclick="toggleDropdown()">
				<div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
				<span class="user-name">${sessionScope.currentStaff.staffFirstName}
					${sessionScope.currentStaff.staffLastName}</span> <span class="arrow">▾</span>
				<div class="dropdown-menu" id="dropdownMenu">
					<a href="${pageContext.request.contextPath}/staff/profile"
						class="dropdown-item">โปรไฟล์</a>
					<a href="${pageContext.request.contextPath}/headstaff/logout"
						class="dropdown-item danger">ออกจากระบบ</a>
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
				<h1>แก้ไขข้อมูลอุปกรณ์</h1>
				<p>แก้ไขรายละเอียดอุปกรณ์และบริการในระบบ</p>
			</div>

			<div class="card-body">

				<c:if test="${not empty error}">
					<div class="alert error">${error}</div>
				</c:if>

				<form action="${pageContext.request.contextPath}/staff/items/save"
					method="post">
					<input type="hidden" name="itemId" value="${item.itemId}">

					<div class="form-section">


						<div class="form-group">
							<div class="section-label">ประเภทอุปกรณ์</div>
							<select name="typeId" id="itemTypeSelect" class="form-select"
								required>
								<option value="" disabled>-- เลือกประเภทอุปกรณ์ --</option>
								<c:forEach var="t" items="${itemTypes}">
									<c:if test="${t.itemTypeName != 'แพ็กเกจ'}">
										<option value="${t.itemTypeId}"
											${item.itemType.itemTypeId == t.itemTypeId ? 'selected' : ''}>${t.itemTypeName}</option>
									</c:if>
								</c:forEach>
							</select>
						</div>


						<div class="form-group">
							<div class="section-label">ใช้กับพิธีไหนได้บ้าง</div>
							<p class="field-hint">
								กลุ่มที่ผูกไว้แล้วแสดงอยู่ด้านล่าง พร้อมจำนวนเดิมที่เคยบันทึกไว้<br>
								* ไม่ติ๊กเลย = เป็นรายการให้สมาชิกเลือกเพิ่มเองภายหลัง
							</p>

							<div class="ceremony-adder-row">
								<select id="ceremonyTypeAdder" class="form-select">
									<option value="">-- เลือกประเภทงานเพื่อเพิ่ม --</option>
                                    <%-- แก้ไขชื่อตัวแปรเป็น groupedPackages --%>
									<c:forEach var="entry" items="${groupedPackages}">
										<option value="grp_${entry.key}">${entry.key}</option>
									</c:forEach>
								</select>
							</div>

							<div id="selectedCeremonyGroups">
                                <%-- แก้ไขชื่อตัวแปรเป็น groupedPackages --%>
								<c:forEach var="entry" items="${groupedPackages}">
									<c:set var="groupHasSelected" value="false" />
									<c:forEach var="c" items="${entry.value}">
                                        <%-- แก้ไขชื่อตัวแปรเป็น selectedPackageIds --%>
										<c:forEach var="selectedId" items="${selectedPackageIds}">
											<c:if test="${selectedId == c.packageId}">
												<c:set var="groupHasSelected" value="true" />
											</c:if>
										</c:forEach>
									</c:forEach>

									<div class="ceremony-type-group" id="grp_${entry.key}"
										style="${groupHasSelected ? 'display:block;' : 'display:none;'}">
										<div class="ceremony-type-heading-row">
											<div class="ceremony-type-heading">${entry.key}</div>
											<div class="ceremony-heading-right">
												<label class="ceremony-select-all-label"> <input
													type="checkbox" class="select-all-checkbox"
													data-group="grp_${entry.key}"
													onchange="onSelectAllChange(this)"> เลือกทั้งหมด
												</label>
												<button type="button" class="btn-close-group"
													title="ปิดกลุ่มนี้ (ยกเลิกการเลือกทั้งหมด)"
													onclick="closeGroup('grp_${entry.key}')">✕</button>
											</div>
										</div>
										<div class="ceremony-type-options"
											data-group="grp_${entry.key}">
											<c:forEach var="c" items="${entry.value}">
												<c:set var="isChecked" value="false" />
												<c:set var="existingQty" value="1" />
                                                <%-- แก้ไขชื่อตัวแปรเป็น selectedPackageIds --%>
												<c:forEach var="selectedId" items="${selectedPackageIds}">
													<c:if test="${selectedId == c.packageId}">
														<c:set var="isChecked" value="true" />
                                                        <%-- แก้ไขชื่อตัวแปรเป็น selectedPackageQuantities --%>
														<c:set var="existingQty"
															value="${selectedPackageQuantities[c.packageId]}" />
													</c:if>
												</c:forEach>
												<div class="ceremony-item">
													<input type="checkbox" name="packageIds"
														value="${c.packageId}" id="cer_${c.packageId}"
														data-group="grp_${entry.key}"
														${isChecked ? 'checked' : ''}
														onchange="toggleQtyInput(this, 'qty_${c.packageId}')">
													<label for="cer_${c.packageId}"
														class="ceremony-check-label">${c.optionType}</label> <span
														class="qty-inline-wrap"> ใช้ <input type="number"
														name="quantities" id="qty_${c.packageId}"
														class="qty-mini-input" min="1"
														value="${not empty existingQty ? existingQty : 1}"
														${isChecked ? '' : 'disabled'}> หน่วย
													</span>
												</div>
											</c:forEach>
										</div>
									</div>
								</c:forEach>
								<div id="ceremonyEmptyHint" class="ceremony-empty-hint">
									ยังไม่ได้เพิ่มประเภทงานไหนเลย —
									เลือกจากช่องด้านบนเพื่อเริ่มผูกแพ็กเกจ</div>
							</div>
						</div>

						<%-- ชื่อ & รายละเอียด --%>
						<div class="form-group">
							<div class="section-label">ข้อมูลอุปกรณ์</div>
							<div style="display: flex; flex-direction: column; gap: 12px;">
								<div class="form-group">
									<label>ชื่ออุปกรณ์ / บริการ</label> <input type="text"
										name="itemName" value="${item.itemName}" required
										placeholder="ระบุชื่ออุปกรณ์หรือบริการ">
								</div>
								<div class="form-group">
									<label>รายละเอียด</label>
									<textarea name="itemDetail"
										placeholder="รายละเอียดเพิ่มเติม (ถ้ามี)">${item.itemDetail}</textarea>
								</div>
							</div>
						</div>

						<%-- ราคา & หน่วย --%>
						<div class="form-group">
							<div class="section-label">ราคาและหน่วยนับ</div>
							<div class="form-row">
								<div class="form-group">
									<label>ราคาต่อหน่วย (บาท)</label> <input type="number"
										name="pricePerUnit" value="${item.pricePerUnit}" step="0.01"
										min="0" required placeholder="0.00">
									<p class="field-hint">กรอกเป็นตัวเลข ทศนิยมได้ไม่เกิน 2
										ตำแหน่ง เช่น 250.00</p>
								</div>
								<div class="form-group">
									<label>หน่วยนับ</label> <select name="unit" required
										class="form-select">
										<option value="">-- เลือกหน่วย --</option>
										<option value="ชุด"
											${item.unit == 'ชุด'     ? 'selected' : ''}>ชุด</option>
										<option value="ชิ้น"
											${item.unit == 'ชิ้น'    ? 'selected' : ''}>ชิ้น</option>
										<option value="โหล"
											${item.unit == 'โหล'     ? 'selected' : ''}>โหล</option>
										<option value="เครื่อง"
											${item.unit == 'เครื่อง' ? 'selected' : ''}>เครื่อง</option>
										<option value="รูป"
											${item.unit == 'รูป'     ? 'selected' : ''}>รูป</option>
										<option value="ตัว"
											${item.unit == 'ตัว'     ? 'selected' : ''}>ตัว</option>
										<option value="ใบ"
											${item.unit == 'ใบ'      ? 'selected' : ''}>ใบ</option>
										<option value="เถา"
											${item.unit == 'เถา'     ? 'selected' : ''}>เถา</option>
										<option value="อัน"
											${item.unit == 'อัน'     ? 'selected' : ''}>อัน</option>
										<option value="คู่"
											${item.unit == 'คู่'     ? 'selected' : ''}>คู่</option>
										<option value="องค์"
											${item.unit == 'องค์'    ? 'selected' : ''}>องค์</option>
										<option value="ผืน"
											${item.unit == 'ผืน'     ? 'selected' : ''}>ผืน</option>
										<option value="ต้น"
											${item.unit == 'ต้น'     ? 'selected' : ''}>ต้น</option>
										<option value="ม้วน"
											${item.unit == 'ม้วน'    ? 'selected' : ''}>ม้วน</option>
										<option value="เส้น"
											${item.unit == 'เส้น'    ? 'selected' : ''}>เส้น</option>
										<option value="พวง"
											${item.unit == 'พวง'     ? 'selected' : ''}>พวง</option>
										<option value="กรวย"
											${item.unit == 'กรวย'    ? 'selected' : ''}>กรวย</option>
										<option value="พุ่ม"
											${item.unit == 'พุ่ม'    ? 'selected' : ''}>พุ่ม</option>
										<option value="หลัง"
											${item.unit == 'หลัง'    ? 'selected' : ''}>หลัง</option>
										<option value="ป้าย"
											${item.unit == 'ป้าย'    ? 'selected' : ''}>ป้าย</option>
										<option value="ครั้ง"
											${item.unit == 'ครั้ง'   ? 'selected' : ''}>ครั้ง</option>
										<option value="คน"
											${item.unit == 'คน'      ? 'selected' : ''}>คน</option>
									</select>
								</div>
							</div>
						</div>

						<div class="form-actions">
							<button type="submit" class="btn-submit">บันทึกการแก้ไข</button>
							<a href="${pageContext.request.contextPath}/staff/items"
								class="btn-cancel">ยกเลิก</a>
						</div>

					</div>
				</form>
			</div>
		</div>
	</div>

	<%-- ===== Footer (สำหรับหัวหน้างาน) ===== --%>
	<footer class="site-footer">

		<%-- ===== ลายดอกบัวมุมล่างขวา (เกาะติด footer) ===== --%>
		<img
			src="${pageContext.request.contextPath}/static/images/lotus-corner.png"
			alt="" class="lotus-decoration" aria-hidden="true">

		<div class="footer-content">
			<div class="footer-brand">
				<img
					src="${pageContext.request.contextPath}/static/images/logoo.png"
					alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon footer-lotus-icon">
				<span class="footer-brand-text">บุญมีนำพา จัดงานบุญ</span>
			</div>
			<p class="footer-tagline">ระบบจัดการงานบุญสำหรับหัวหน้างาน</p>
		</div>

	</footer>

	<script src="${pageContext.request.contextPath}/static/js/editItem.js?v=8"></script>
</body>
</html>