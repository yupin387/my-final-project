<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>แก้ไขรายการอุปกรณ์ - บุญมีนำพา จัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/editItem.css?v=6">
<style>
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

.field-hint {
    font-size: 12px;
    color: var(--brown-muted, #8A7666);
    margin: 4px 0 0;
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

/* ===== หัวกลุ่มใช้ checkbox "เลือกทั้งหมด" แทนปุ่ม 3 ปุ่มเดิม
   (เลือกทั้งหมด / ล้างการเลือก / นำออก) + ปุ่ม ✕ แยกไว้ปิดกลุ่มที่เผลอเปิด ===== */
.ceremony-type-heading-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
    flex-wrap: wrap;
    gap: 8px;
    padding-bottom: 10px;
    border-bottom: 1px dashed var(--card-border, #F0E2D3);
}
.ceremony-type-heading {
    font-weight: 700;
    color: var(--brown-text, #4A3728);
}
.ceremony-heading-right {
    display: flex;
    align-items: center;
    gap: 14px;
}
.ceremony-select-all-label {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: var(--brown-muted, #8A7666);
    cursor: pointer;
    user-select: none;
}
.ceremony-select-all-label input[type="checkbox"] {
    width: 16px;
    height: 16px;
    cursor: pointer;
}
.btn-close-group {
    width: 22px;
    height: 22px;
    border: none;
    background: transparent;
    color: var(--brown-muted, #8A7666);
    font-size: 15px;
    line-height: 1;
    cursor: pointer;
    border-radius: 50%;
}
.btn-close-group:hover {
    background: var(--card-border, #F0E2D3);
    color: var(--red-primary, #D9534F);
}

/* ===== 1 แพ็กเกจต่อ 1 แถวเต็มความกว้าง ชื่อยาวให้ตัดขึ้นบรรทัดใหม่ "ในกรอบของตัวเอง"
   แทนที่จะดันช่อง "ใช้...หน่วย" ให้หลุดไปอยู่คนละบรรทัด ===== */
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
    min-width: 0;
    white-space: normal;
    word-break: break-word;
    line-height: 1.35;
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

    <c:if test="${not empty success}">
        <span id="flash-success" data-msg="${success}" style="display:none;"></span>
    </c:if>
    <c:if test="${not empty error}">
        <span id="flash-error" data-msg="${error}" style="display:none;"></span>
    </c:if>

    <%-- ========== NAVBAR ========== --%>
    <nav class="navbar">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/assignments">
            <img src="${pageContext.request.contextPath}/static/images/logoo.png"
                 alt="บุญมีนำพา รับจัดงานบุญ" class="lotus-icon">
            <span class="navbar-title">บุญมีนำพา รับจัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">งานที่ได้รับมอบหมาย</a>
                <a href="${pageContext.request.contextPath}/staff/items"       class="nav-item active">จัดการรายการอุปกรณ์</a>
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

                        <%-- ===== ประเภทอุปกรณ์: dropdown
                             ตัดตัวเลือก "แพ็กเกจ" ออก เหมือนหน้าเพิ่มอุปกรณ์
                             backend มี validation กันไว้ที่ ItemService.saveItem() อยู่แล้ว --%>
                        <div class="form-group">
                            <div class="section-label">ประเภทอุปกรณ์</div>
                            <select name="typeId" id="itemTypeSelect" class="form-select" required>
                                <option value="" disabled>-- เลือกประเภทอุปกรณ์ --</option>
                                <c:forEach var="t" items="${itemTypes}">
                                    <c:if test="${t.itemTypeName != 'แพ็กเกจ'}">
                                        <option value="${t.itemTypeId}"
                                            ${item.itemType.itemTypeId == t.itemTypeId ? 'selected' : ''}>${t.itemTypeName}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <%-- ===== ใช้กับพิธีไหนได้บ้าง: progressive disclosure
                             กลุ่มที่มีพิธีถูกติ๊กไว้อยู่แล้ว (ของเดิม) โชว์ค้างไว้ตั้งแต่เปิดหน้า
                             แต่ละ checkbox มีช่องกรอก "ใช้ ... หน่วย" คู่กัน pre-fill ด้วยค่าจาก
                             selectedCeremonyQuantities (Map<ceremonyId, quantity>) จาก controller

                             หัวแต่ละกลุ่มใช้ checkbox "เลือกทั้งหมด" แบบ select-all มาตรฐาน
                             + ปุ่ม ✕ แยกไว้สำหรับปิดกลุ่มที่เผลอเปิด/ไม่ต้องการแล้ว --%>
                        <div class="form-group">
                            <div class="section-label">ใช้กับพิธีไหนได้บ้าง</div>
                            <p class="field-hint">
                                กลุ่มที่ผูกไว้แล้วแสดงอยู่ด้านล่าง พร้อมจำนวนเดิมที่เคยบันทึกไว้<br>
                                * ไม่ติ๊กเลย = เป็นรายการให้สมาชิกเลือกเพิ่มเองภายหลัง
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
                                    <c:set var="groupHasSelected" value="false" />
                                    <c:forEach var="c" items="${entry.value}">
                                        <c:forEach var="selectedId" items="${selectedCeremonyIds}">
                                            <c:if test="${selectedId == c.ceremonyId}">
                                                <c:set var="groupHasSelected" value="true" />
                                            </c:if>
                                        </c:forEach>
                                    </c:forEach>

                                    <div class="ceremony-type-group" id="grp_${entry.key}"
                                        style="${groupHasSelected ? 'display:block;' : 'display:none;'}">
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
                                                <c:set var="isChecked" value="false" />
                                                <c:set var="existingQty" value="1" />
                                                <c:forEach var="selectedId" items="${selectedCeremonyIds}">
                                                    <c:if test="${selectedId == c.ceremonyId}">
                                                        <c:set var="isChecked" value="true" />
                                                        <c:set var="existingQty" value="${selectedCeremonyQuantities[c.ceremonyId]}" />
                                                    </c:if>
                                                </c:forEach>
                                                <div class="ceremony-item">
                                                    <input type="checkbox" name="ceremonyIds"
                                                        value="${c.ceremonyId}" id="cer_${c.ceremonyId}"
                                                        data-group="grp_${entry.key}"
                                                        ${isChecked ? 'checked' : ''}
                                                        onchange="toggleQtyInput(this, 'qty_${c.ceremonyId}')">
                                                    <label for="cer_${c.ceremonyId}" class="ceremony-check-label">${c.ceremonyName}</label>
                                                    <span class="qty-inline-wrap">
                                                        ใช้
                                                        <input type="number" name="quantities" id="qty_${c.ceremonyId}"
                                                            class="qty-mini-input" min="1"
                                                            value="${not empty existingQty ? existingQty : 1}"
                                                            ${isChecked ? '' : 'disabled'}>
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

                        <%-- ชื่อ & รายละเอียด --%>
                        <div class="form-group">
                            <div class="section-label">ข้อมูลอุปกรณ์</div>
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

                        <%-- ราคา & หน่วย --%>
                        <div class="form-group">
                            <div class="section-label">ราคาและหน่วยนับ</div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label>ราคาต่อหน่วย (บาท)</label>
                                    <input type="number" name="pricePerUnit" value="${item.pricePerUnit}" step="0.01" min="0" required placeholder="0.00">
                                    <p class="field-hint">กรอกเป็นตัวเลข ทศนิยมได้ไม่เกิน 2 ตำแหน่ง เช่น 250.00</p>
                                </div>
                                <div class="form-group">
                                    <label>หน่วยนับ</label>
                                  <select name="unit" required class="form-select">
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
           ใช้กับกลุ่มที่เผลอเปิด หรือกลุ่มเดิมที่ผูกไว้แต่ไม่ต้องการแล้ว
           (ถ้าเป็นกลุ่มเดิมที่มีข้อมูลอยู่ก่อน การกดปิดจะล้างการติ๊กทั้งหมด — ต้องกดบันทึก
           การแก้ไขอีกครั้งเพื่อให้มีผลจริงกับฐานข้อมูล) ===== */
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

        /* ===== ตอนโหลดหน้า: sync สถานะ select-all ของทุกกลุ่มที่มีข้อมูลเดิมติ๊กไว้อยู่แล้ว ===== */
        document.addEventListener('DOMContentLoaded', function () {
            updateEmptyHint();
            document.querySelectorAll('.select-all-checkbox').forEach(function (box) {
                syncSelectAllState(box.getAttribute('data-group'));
            });
        });
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
