<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Quản lý tài khoản</title>
  <style>
    body { font-family: Arial, sans-serif; background:#f8fafc; margin:0; color:#0f172a; }
    .container { max-width: 720px; margin: 32px auto; padding: 0 16px; }
    .card { background:#fff; border:1px solid #e2e8f0; border-radius:12px; padding:16px 20px; margin-bottom:16px; }
    h2 { margin:0 0 12px; color:#0ea5e9; }
    h3 { margin:0 0 10px; }
    .row { display:grid; grid-template-columns: 160px 1fr; gap:10px; margin:8px 0; }
    input { width:100%; padding:10px 12px; border:1px solid #cbd5e1; border-radius:8px; }
    input:focus { outline:none; border-color:#0ea5e9; box-shadow:0 0 0 2px rgba(14,165,233,.2); }
    .btn { padding:10px 16px; background:#0ea5e9; color:#fff; border:none; border-radius:10px; cursor:pointer; font-weight:600; }
    .btn:hover { background:#0284c7; }
    .msg { color:#16a34a; margin:10px 0; }
    .err { color:#dc2626; margin:10px 0; }
  </style>
</head>
<body>
<div class="container">
  <div class="card">
    <h2>Quản lý tài khoản</h2>
    <c:if test="${not empty err}"><div class="err">${err}</div></c:if>
    <c:if test="${not empty msg}"><div class="msg">${msg}</div></c:if>
  </div>

  <!-- Cập nhật thông tin -->
  <div class="card">
    <h3>Cập nhật thông tin</h3>
    <form method="post" action="${pageContext.request.contextPath}/account/profile">
      <div class="row">
        <label>Họ tên</label>
        <input name="fullName" value="${user.fullName}" required />
      </div>
      <div class="row">
        <label>Điện thoại</label>
        <input name="phone" value="${user.phone}" required />
      </div>
      <div class="row">
        <label>Email</label>
        <input type="email" name="email" value="${user.email}" required />
      </div>
      <button class="btn" type="submit">Lưu thay đổi</button>
    </form>
  </div>

  <!-- Đổi mật khẩu -->
  <div class="card">
    <h3>Đổi mật khẩu</h3>
    <form method="post" action="${pageContext.request.contextPath}/account/password">
      <div class="row">
        <label>Mật khẩu hiện tại</label>
        <input type="password" name="currentPassword" required />
      </div>
      <div class="row">
        <label>Mật khẩu mới</label>
        <input type="password" name="newPassword" required />
      </div>
      <div class="row">
        <label>Nhập lại mật khẩu mới</label>
        <input type="password" name="confirmPassword" required />
      </div>
      <button class="btn" type="submit">Đổi mật khẩu</button>
    </form>
  </div>

  <!-- Quản lý lịch hẹn -->
  <div class="card">
    <h3>Quản lý lịch hẹn</h3>
    <p>Xem và quản lý tất cả lịch hẹn của bạn</p>
    <a href="${pageContext.request.contextPath}/appointments/my-appointments" class="btn" style="text-decoration: none; display: inline-block;">
      <i class="fas fa-calendar-check"></i> Xem lịch hẹn
    </a>
  </div>
</div>
</body>
</html>