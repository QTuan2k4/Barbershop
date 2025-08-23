<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
  <title>Đặt lịch cắt tóc</title>
  <style>
    /* ===== THEME đồng bộ home ===== */
    :root{
      --primary:#0d3b66;   /* header/footer */
      --accent:#133e87;    /* nhấn (button, link, focus) */
      --bg:#f6f8fb;        /* nền trang */
      --card:#ffffff;      /* nền thẻ */
      --muted:#64748b;     /* chữ phụ */
      --shadow:0 6px 16px rgba(0,0,0,.08);
      --radius:12px;
    }

    /* ===== Base ===== */
    *{box-sizing:border-box}
    body{
      font-family: Inter, 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: var(--bg);
      color: #0f172a;
      margin: 0;
      padding: 0;
    }
    a{color:inherit;text-decoration:none}

    /* ===== Card chính ===== */
    .container{
      max-width: 720px;
      margin: 40px auto;
      padding: 20px;
      background: var(--card);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      border: 1px solid #eef2f7;
      position: relative;
    }
    /* viền nhấn phía trên giống brand bar */
    .container::before{
      content:""; position:absolute; top:0; left:0; right:0; height:4px; border-radius:12px 12px 0 0;
      background: linear-gradient(90deg, var(--accent), var(--primary));
    }

    h2{
      margin: 8px 0 18px;
      text-align: center;
      color: var(--accent);
      font-weight: 800;
      letter-spacing:.2px;
    }

    .error{ color:#dc2626; margin:10px 0; text-align:center; font-weight:700 }
    .msg  { color:#16a34a; margin:10px 0; text-align:center; font-weight:700 }

    table{ width:100%; border-collapse:collapse }
    table td{ padding:10px; vertical-align:middle }

    label{ font-weight:700; color:#1f2937 }

    select, input[type="date"], input[type="time"]{
      width:100%; padding:10px 12px; border:1px solid #cbd5e1; border-radius:10px; font-size:14px;
      transition: border-color .2s, box-shadow .2s, background-color .2s;
      background:#fff;
    }
    select:focus, input:focus{
      border-color: var(--accent);
      outline: none;
      box-shadow: 0 0 0 3px rgba(19,62,135,.18);
    }

    /* ===== Buttons ===== */
    button{
      width:100%; padding:12px; margin-top:16px; border:none; border-radius:12px;
      background: var(--accent); color:#fff; font-size:16px; font-weight:800; cursor:pointer;
      transition: filter .2s, transform .02s;
    }
    button:hover{ filter:brightness(.96) }
    button:active{ transform:translateY(1px) }

    /* override nút “Chọn tất cả” để lên theme, dù có inline cũ */
    #btnSelectAll{
      background:#eef2ff !important; color:#0f172a !important;
      border-color:#c7d2fe !important; border-radius:10px !important;
    }
    #btnSelectAll:hover{ filter:brightness(.98) }

    /* ===== Panel giờ đã đặt ===== */
    .panel{
      margin-top:16px; padding:12px; border-radius:10px;
      background: rgba(19,62,135,.06);              /* accent mờ */
      border:1px dashed rgba(19,62,135,.28);
    }
    .panel strong{ color:#0f172a }
    .muted{ color:var(--muted); font-size:13px }

    /* Svc grid card feel */
    .svc-item{
      border:1px solid #e2e8f0; border-radius:10px; background:#fff;
      transition: border-color .2s, box-shadow .2s;
    }
    .svc-item:hover{ border-color:var(--accent); box-shadow:0 4px 12px rgba(0,0,0,.06) }
    .svc-item input[type="checkbox"]{ accent-color: var(--accent); }
  </style>
</head>
<body>
<div class="container">
  <h2>Đặt lịch cắt tóc</h2>

  <c:if test="${not empty err}"><div class="error">${err}</div></c:if>
  <c:if test="${not empty msg}"><div class="msg">${msg}</div></c:if>

  <!-- Bộ lọc ngày để XEM giờ đã đặt (GET) -->
  <form method="get" action="<c:url value='/appointments/new'/>" style="margin-bottom:16px;">
    <label for="viewDate" style="display:block; font-weight:700; color:#1f2937;">Xem giờ đã đặt theo ngày</label>
    <input type="date" id="viewDate" name="date" value="${selectedDate}" required />
    <!-- dùng style nút chung -->
    <button type="submit" style="margin-top:10px">Xem giờ đã đặt</button>
    <div class="muted">Đang xem ngày: <strong>${selectedDate}</strong></div>
  </form>

  <!-- Panel liệt kê giờ đã đặt (toàn shop) -->
  <div class="panel">
    <strong>Giờ đã đặt trong ngày:</strong>
    <c:choose>
      <c:when test="${empty booked}">
        <div class="muted">Chưa có lịch đặt nào trong ngày.</div>
      </c:when>
      <c:otherwise>
        <ul style="margin:6px 0 0; padding-left:18px; color:#334155; font-size:14px;">
          <c:forEach var="a" items="${booked}">
            <li>
				${a.startTime.toString().substring(0,5)} - ${a.endTime.toString().substring(0,5)}
            </li>
          </c:forEach>
        </ul>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- Form đặt lịch -->
  <form method="post" action="${pageContext.request.contextPath}/appointments" style="margin-top:20px;">
    <table>
      <tr>
        <td><label for="serviceIds">Dịch vụ</label></td>
        <td>
          <button type="button" id="btnSelectAll">Chọn tất cả</button>

          <!-- Lưới checkbox dịch vụ -->
          <div class="svc-grid"
               style="display:grid; grid-template-columns:repeat(2,minmax(160px,1fr)); gap:8px; margin-top:8px;">
            <c:forEach var="s" items="${services}">
              <label class="svc-item" style="display:flex; align-items:center; gap:8px; padding:8px 10px;">
                <input type="checkbox" name="serviceIds" value="${s.serviceId}">
                <span style="font-weight:700; color:#0f172a;">${s.name}</span>
                <span class="muted">30 phút)</span>
              </label>
            </c:forEach>
          </div>

          <div class="muted" style="margin-top:6px;">
            Bạn có thể chọn nhiều dịch vụ. Các dịch vụ sẽ được xếp liên tiếp theo giờ bắt đầu.
          </div>
        </td>
      </tr>

      <!-- Script chọn dịch vụ -->
      <script>
      (function(){
        var grid = document.querySelector('.svc-grid');
        var btnAll = document.getElementById('btnSelectAll');
        var form = document.querySelector('form[action$="/appointments"]');

        if (btnAll && grid) {
          btnAll.addEventListener('click', function(){
            var boxes = grid.querySelectorAll('input[type="checkbox"][name="serviceIds"]');
            var allChecked = true;
            boxes.forEach(function(b){ if(!b.checked) allChecked = false; });
            boxes.forEach(function(b){ b.checked = !allChecked; });
            this.textContent = allChecked ? 'Chọn tất cả' : 'Bỏ chọn tất cả';
          });
        }

        if (form && grid) {
          form.addEventListener('submit', function(e){
            var boxes = grid.querySelectorAll('input[type="checkbox"][name="serviceIds"]');
            var any = false;
            boxes.forEach(function(b){ if(b.checked) any = true; });
            if (!any) {
              e.preventDefault();
              alert('Vui lòng chọn ít nhất 1 dịch vụ.');
            }
          });
        }
      })();
      </script>

      <tr>
        <td><label for="employeeId">Nhân viên</label></td>
        <td>
          <select id="employeeId" name="employeeId" required>
            <c:forEach var="e" items="${employees}">
              <option value="${e.employeeId}">${e.name}</option>
            </c:forEach>
          </select>
        </td>
      </tr>
      <tr>
        <td><label for="date">Ngày</label></td>
        <td><input type="date" id="date" name="date" required value="${selectedDate}"></td>
      </tr>
      <tr>
        <td><label for="startTime">Giờ bắt đầu</label></td>
        <td><input type="time" id="startTime" name="startTime" required></td>
      </tr>
    </table>

    <button type="submit">Đặt lịch</button>
  </form>
</div>
</body>
</html>