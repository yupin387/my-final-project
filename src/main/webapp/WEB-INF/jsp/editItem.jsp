<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>แก้ไขรายการอุปกรณ์ - บุญมีนำพา จัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/editItem.css?v=2">
</head>
<body>

    <c:if test="${not empty success}">
        <span id="flash-success" data-msg="${success}" style="display:none;"></span>
    </c:if>
    <c:if test="${not empty error}">
        <span id="flash-error" data-msg="${error}" style="display:none;"></span>
    </c:if>

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
                <a href="${pageContext.request.contextPath}/staff/items"       class="nav-item active">จัดการ Item</a>
            </nav>
            <div class="user-info" onclick="toggleDropdown()">
                <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                <span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
                <span class="arrow">▾</span>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="${pageContext.request.contextPath}/staff/profile" class="dropdown-item">โปรไฟล์</a>
                    <a href="${pageContext.request.contextPath}/staff/logout"  class="dropdown-item danger">ออกจากระบบ</a>
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

                <form action="${pageContext.request.contextPath}/staff/items/save" method="post">
                    <input type="hidden" name="itemId" value="${item.itemId}">

                    <div class="form-section">

                        <%-- ประเภท Item
                             FIX: ตัดตัวเลือก "แพ็กเกจ" ออกจากฟอร์มนี้เหมือนหน้า addItem.jsp
                             ห้ามเจ้าหน้าที่แก้ไข item ประเภทแพ็กเกจผ่านฟอร์มทั่วไปนี้ เพราะมีกฎพิเศษ
                             (itemName ต้องตรงกับ ceremony.ceremonyName เป๊ะๆ, ผูกกับ ceremony ตายตัว
                             ตามระดับราคา, ราคาจริงที่ระบบใช้อยู่ที่ ceremony.basePrice ไม่ใช่
                             item.pricePerUnit) — backend มี validation กันไว้ที่ ItemService.saveItem()
                             อยู่แล้ว แต่ซ่อนตัวเลือกที่ UI ด้วยเพื่อไม่ให้เจ้าหน้าที่งงว่าทำไมกดบันทึก
                             ไม่ได้ ถ้า item ที่กำลังแก้ไขบังเอิญเป็นประเภทแพ็กเกจอยู่แล้ว (ไม่ควรเกิดขึ้น
                             เพราะรายการแพ็กเกจไม่ได้ถูกลิงก์มาจากหน้า itemList ให้กดแก้ไขอยู่แล้ว)
                             จะไม่มี radio ให้เลือกตรงกับ type เดิม ต้องเปลี่ยนประเภทใหม่ก่อนบันทึก --%>
                        <div class="form-group">
                            <div class="section-label">ประเภท Item</div>
                            <div class="type-options">
                                <c:forEach var="t" items="${itemTypes}">
                                    <c:if test="${t.itemTypeName != 'แพ็กเกจ'}">
                                        <input type="radio" name="typeId" value="${t.itemTypeId}"
                                            id="type_${t.itemTypeId}"
                                            ${item.itemType.itemTypeId == t.itemTypeId ? 'checked' : ''}
                                            required>
                                        <label for="type_${t.itemTypeId}" class="type-label">${t.itemTypeName}</label>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <p style="font-size:12px; color:var(--text-muted); margin-top:6px;">
                                * แพ็กเกจ (มาตรฐาน/อิ่มบุญ/พรีเมียม) เป็นรายการที่กำหนดไว้จากส่วนกลาง
                                ไม่สามารถสร้างหรือแก้ไขผ่านหน้านี้ได้
                            </p>
                        </div>

                        <hr class="divider">

                        <%-- ใช้กับพิธี
                             ปรับปรุง: เพิ่มคำอธิบายและปุ่ม "เลือกทั้งหมด / ล้างการเลือก" ต่อประเภทงาน
                             ให้ตรงกับหน้า addItem.jsp เพื่อความสอดคล้องกันของ UX — item หนึ่งตัว
                             เลือกได้มากกว่า 1 รายการ ข้ามประเภทงาน/ข้ามแพ็กเกจได้อิสระเหมือนกัน --%>
                        <div class="form-group">
                            <div class="section-label">ใช้กับพิธีไหนได้บ้าง</div>
                            <p style="font-size: 12px; color: var(--text-muted); margin: -4px 0 10px;">
                                เลือกได้มากกว่า 1 รายการ และเลือกข้ามประเภทงาน/ข้ามแพ็กเกจได้อิสระ
                                เช่น จะให้อุปกรณ์ชิ้นนี้อยู่ทั้งในแพ็กเกจมาตรฐานของทุกงาน
                                และอยู่ใน "กรอกความต้องการเบื้องต้น" ด้วยพร้อมกันก็ได้<br>
                                * ถ้าไม่เลือกเลย = ไม่ผูกกับแพ็กเกจใด ระบบจะถือว่าเป็นรายการ
                                ที่ให้ลูกค้าเลือกเพิ่มเองภายหลัง
                            </p>
                            <div class="ceremony-box">
                                <c:forEach var="entry" items="${groupedCeremonies}">
                                    <div class="ceremony-type-group">
                                        <div class="ceremony-type-heading-row">
                                            <div class="ceremony-type-heading">${entry.key}</div>
                                            <div class="ceremony-quick-actions">
                                                <button type="button" class="btn-quick-select"
                                                    onclick="setGroupChecked('grp_${entry.key}', true)">เลือกทั้งหมด</button>
                                                <button type="button" class="btn-quick-select"
                                                    onclick="setGroupChecked('grp_${entry.key}', false)">ล้างการเลือก</button>
                                            </div>
                                        </div>
                                        <div class="ceremony-type-options" data-group="grp_${entry.key}">
                                            <c:forEach var="c" items="${entry.value}">
                                                <div class="ceremony-item">
                                                    <!-- ใช้ selectedCeremonyIds จาก controller ในการเช็ค checked -->
                                                    <input type="checkbox" name="ceremonyIds"
                                                        value="${c.ceremonyId}" id="cer_${c.ceremonyId}"
                                                        <c:forEach var="selectedId" items="${selectedCeremonyIds}">
                                                            <c:if test="${selectedId == c.ceremonyId}">checked</c:if>
                                                        </c:forEach>>
                                                    <label for="cer_${c.ceremonyId}" class="ceremony-check-label">${c.ceremonyName}</label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <hr class="divider">

                        <%-- ชื่อ & รายละเอียด --%>
                        <div class="form-group">
                            <div class="section-label">ข้อมูล Item</div>
                            <div style="display:flex; flex-direction:column; gap:12px;">
                                <div class="form-group">
                                    <label>ชื่ออุปกรณ์ / บริการ</label>
                                    <input type="text" name="itemName" value="${item.itemName}" required placeholder="ระบุชื่ออุปกรณ์หรือบริการ">
                                </div>
                                <div class="form-group">
                                    <label>รายละเอียด</label>
                                    <textarea name="itemDetail" placeholder="รายละเอียดเพิ่มเติม (ถ้ามี)">${item.itemDetail}</textarea>
                                </div>
                            </div>
                        </div>

                        <hr class="divider">

                        <%-- ราคา & หน่วย --%>
                        <div class="form-group">
                            <div class="section-label">ราคาและหน่วยนับ</div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label>ราคาต่อหน่วย (บาท)</label>
                                    <input type="number" name="pricePerUnit" value="${item.pricePerUnit}" step="0.01" required placeholder="0.00">
                                </div>
                                <div class="form-group">
                                    <label>หน่วยนับ</label>
                                    <%-- FIX: เดิมเช็ค ${param.unit == ...} ซึ่งจะว่างเปล่าเสมอตอนเปิดหน้า
                                         แก้ไขครั้งแรก (ยังไม่เคย submit ฟอร์ม) ทำให้ dropdown ไม่เคย
                                         pre-select หน่วยเดิมของ item ให้เลย ต้องเช็คจาก ${item.unit}
                                         (ค่าที่มีอยู่จริงในฐานข้อมูล) แทน --%>
                                  <select name="unit" required>
                                    <option value="">-- เลือกหน่วย --</option>
                                    <option value="ชุด"     ${item.unit == 'ชุด'     ? 'selected' : ''}>ชุด</option>
                                    <option value="ชิ้น"    ${item.unit == 'ชิ้น'    ? 'selected' : ''}>ชิ้น</option>
                                    <option value="โหล"     ${item.unit == 'โหล'     ? 'selected' : ''}>โหล</option>
                                    <option value="เครื่อง" ${item.unit == 'เครื่อง' ? 'selected' : ''}>เครื่อง</option>
                                    <option value="รูป"     ${item.unit == 'รูป'     ? 'selected' : ''}>รูป</option>
                                    <option value="ตัว"     ${item.unit == 'ตัว'     ? 'selected' : ''}>ตัว</option>
                                    <option value="ใบ"      ${item.unit == 'ใบ'      ? 'selected' : ''}>ใบ</option>
                                    <option value="เถา"     ${item.unit == 'เถา'     ? 'selected' : ''}>เถา</option>
                                    <option value="อัน"     ${item.unit == 'อัน'     ? 'selected' : ''}>อัน</option>
                                    <option value="คู่"     ${item.unit == 'คู่'     ? 'selected' : ''}>คู่</option>
                                    <option value="องค์"    ${item.unit == 'องค์'    ? 'selected' : ''}>องค์</option>
                                    <option value="ผืน"     ${item.unit == 'ผืน'     ? 'selected' : ''}>ผืน</option>
                                    <option value="ต้น"     ${item.unit == 'ต้น'     ? 'selected' : ''}>ต้น</option>
                                  </select>
                                </div>
                            </div>
                        </div>

                        <hr class="divider">

                        <div class="form-actions">
                            <button type="submit" class="btn-submit">บันทึกการแก้ไข</button>
                            <a href="${pageContext.request.contextPath}/staff/items" class="btn-cancel">ยกเลิก</a>
                        </div>

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

    <%-- ปุ่ม "เลือกทั้งหมด / ล้างการเลือก" ต่อกลุ่มประเภทงาน (เพิ่มให้ตรงกับ addItem.jsp) --%>
    <script>
        function setGroupChecked(groupKey, checked) {
            var container = document.querySelector('.ceremony-type-options[data-group="' + groupKey + '"]');
            if (!container) return;
            var boxes = container.querySelectorAll('input[type="checkbox"]');
            boxes.forEach(function (cb) { cb.checked = checked; });
        }
    </script>

    <script src="${pageContext.request.contextPath}/static/js/editItem.js"></script>
    <script>
    function toggleDropdown() {
        document.getElementById('dropdownMenu').classList.toggle('show');
    }
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.user-info')) {
            document.getElementById('dropdownMenu').classList.remove('show');
        }
    });
    </script>
</body>
</html>
