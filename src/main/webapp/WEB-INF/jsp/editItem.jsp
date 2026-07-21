<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>แก้ไขรายการอุปกรณ์ - ระบบรับจัดงานบุญ</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700;800&family=Noto+Serif+Thai:wght@400;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/editItem.css">
</head>
<body>

    <c:if test="${not empty success}">
        <span id="flash-success" data-msg="${success}" style="display:none;"></span>
    </c:if>
    <c:if test="${not empty error}">
        <span id="flash-error" data-msg="${error}" style="display:none;"></span>
    </c:if>

    <%-- NAVBAR --%>
    <nav class="navbar">
        <a class="navbar-brand-wrap" href="${pageContext.request.contextPath}/staff/assignments" style="text-decoration:none;">
            <div class="lotus-icon">🪷</div>
            <span class="nav-brand-text">ระบบรับจัดงานบุญ</span>
        </a>
        <div class="navbar-right">
            <nav class="navbar-menu">
                <a href="${pageContext.request.contextPath}/staff/assignments" class="nav-item">รายการงาน</a>
                <a href="${pageContext.request.contextPath}/staff/items"       class="nav-item active">จัดการ Item</a>
            </nav>
            <div class="dropdown-wrap">
                <div class="user-info" onclick="toggleDropdown()">
                    <div class="user-avatar">${sessionScope.currentStaff.staffFirstName.charAt(0)}</div>
                    <div class="user-detail">
                        <span class="user-name">${sessionScope.currentStaff.staffFirstName} ${sessionScope.currentStaff.staffLastName}</span>
                        
                    </div>
                    <span class="arrow">▾</span>
                </div>
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
                            <p style="font-size:12px; color:#a0785a; margin-top:6px;">
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
                                 ตามประเภทงานไว้แล้ว แสดงเป็นกลุ่มมีหัวข้อคั่นแทน (ยังเช็ค checked
                                 จาก item.ceremonies เหมือนเดิม) --%>
                            <div class="ceremony-box">
                                <c:forEach var="entry" items="${groupedCeremonies}">
                                    <div class="ceremony-type-group">
                                        <div class="ceremony-type-heading">${entry.key}</div>
                                        <div class="ceremony-type-options">
                                            <c:forEach var="c" items="${entry.value}">
                                                <div class="ceremony-item">
                                                    <input type="checkbox" name="ceremonyIds"
                                                        value="${c.ceremonyId}" id="cer_${c.ceremonyId}"
                                                        <c:forEach var="ic" items="${item.ceremonies}">
                                                            <c:if test="${ic.ceremonyId == c.ceremonyId}">checked</c:if>
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

    <script src="${pageContext.request.contextPath}/static/js/editItem.js"></script>
</body>
</html>
