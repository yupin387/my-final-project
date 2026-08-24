<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>แก้ไขรายการอุปกรณ์ - บุญมีนำพา จัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&family=Charmonman:wght@400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/editItem.css?v=5">
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

.qty-inline-wrap {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: var(--brown-muted, #8A7666);
    margin-left: 8px;
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
.ceremony-type-options {
    display: flex;
    flex-direction: column;   /* เปลี่ยนจาก wrap เป็นคอลัมน์เดียว 1 แพ็กเกจต่อแถว */
    gap: 10px;
}
.ceremony-item {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: nowrap;         /* ห้ามตกบรรทัดอีก เพราะมีพื้นที่เต็มความกว้างแล้ว */
    padding: 8px 10px;
    background: #FFFFFF;
    border: 1px solid var(--card-border, #F0E2D3);
    border-radius: 8px;
}
.ceremony-check-label {
    flex: 1;                   /* ดันช่องจำนวนไปชิดขวา */
    white-space: nowrap;
}
.qty-inline-wrap {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: var(--brown-muted, #8A7666);
    white-space: nowrap;       /* กัน "ใช้"/"หน่วย" ตกบรรทัด */
    flex-shrink: 0;
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

                        <%-- ===== ประเภท Item: dropdown
                             FIX: ตัดตัวเลือก "แพ็กเกจ" ออก เหมือนหน้า addItem.jsp
                             backend มี validation กันไว้ที่ ItemService.saveItem() อยู่แล้ว --%>
                        <div class="form-group">
                            <div class="section-label">ประเภท Item</div>
                            <select name="typeId" id="itemTypeSelect" class="form-select" required>
                                <option value="" disabled>-- เลือกประเภท Item --</option>
                                <c:forEach var="t" items="${itemTypes}">
                                    <c:if test="${t.itemTypeName != 'แพ็กเกจ'}">
                                        <option value="${t.itemTypeId}"
                                            ${item.itemType.itemTypeId == t.itemTypeId ? 'selected' : ''}>${t.itemTypeName}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <hr class="divider">

                        <%-- ===== ใช้กับพิธีไหนได้บ้าง: progressive disclosure
                             กลุ่มที่มีพิธีถูกติ๊กไว้อยู่แล้ว (ของเดิม) โชว์ค้างไว้ตั้งแต่เปิดหน้า
                             แต่ละ checkbox มีช่องกรอก "ใช้ ... หน่วย" คู่กัน pre-fill ด้วยค่าจาก
                             selectedCeremonyQuantities (Map<ceremonyId, quantity>) จาก controller --%>
                        <div class="form-group">
                            <div class="section-label">ใช้กับพิธีไหนได้บ้าง</div>
                            <p style="font-size: 12px; color: var(--brown-muted); margin: -4px 0 10px;">
                                กลุ่มที่ผูกไว้แล้วแสดงอยู่ด้านล่าง พร้อมจำนวนเดิมที่เคยบันทึกไว้<br>
                                * ไม่ติ๊กเลย = เป็นรายการให้ลูกค้าเลือกเพิ่มเองภายหลัง
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