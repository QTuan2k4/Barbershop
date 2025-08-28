<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Quản lý tài khoản</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/account.css'/>">
  <link rel="stylesheet" href="<c:url value='/resources/css/home.css'/>">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/resources/css/base.css'/>">
</head>
<body>
<!-- ======= TOP BAR ======= -->
	<header class="topbar">
	  <div class="topbar__inner">
	    <a class="brand" href="${pageContext.request.contextPath}/">
	      <img src="${pageContext.request.contextPath}/resources/images/logo3.jpeg" alt="TIM Barbershop">
	      <span class="name">BARBERSHOP</span>
	    </a>
	
	    <nav class="nav">
	      <a href="${pageContext.request.contextPath}/">Trang chủ</a>
	      <a href="${pageContext.request.contextPath}/appointments/new">Đặt lịch</a>
	      <a href="${pageContext.request.contextPath}/price">Bảng giá</a>
	      <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
	    </nav>
	
	    <div class="user-menu">
	      <c:choose>
	        <c:when test="${not empty username}">
	          <span class="hello">Xin chào, <b><c:out value='${username}'/></b></span>
	          <a class="btn btn--outline" href="${pageContext.request.contextPath}/account">Tài khoản</a>
	          <a class="btn btn--primary" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
	        </c:when>
	        <c:otherwise>
	          <a class="btn btn--primary" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
	        </c:otherwise>
	      </c:choose>
	    </div>
	  </div>
	</header>

<div class="container">
  <div class="card">
    <h2 class="page-title">Quản lý tài khoản</h2>
    <c:if test="${not empty err}"><div class="alert alert--err">${err}</div></c:if>
    <c:if test="${not empty msg}"><div class="alert alert--ok">${msg}</div></c:if>
  </div>

  <!-- Quick Actions -->
  <div class="card">
    <h3 class="section-title">Thao tác nhanh</h3>
    <div class="quick-actions">
      <a href="${pageContext.request.contextPath}/customer/appointments" class="quick-action-btn">
        <i class="fas fa-calendar-alt"></i>
        <span>Quản lý lịch hẹn</span>
        <small>Xem, hủy lịch và đánh giá dịch vụ</small>
      </a>
      <a href="${pageContext.request.contextPath}/appointments/new" class="quick-action-btn">
        <i class="fas fa-plus"></i>
        <span>Đặt lịch mới</span>
        <small>Đặt lịch hẹn mới</small>
      </a>
    </div>
  </div>

  <!-- Cập nhật thông tin -->
  <div class="card">
    <h3 class="section-title">Cập nhật thông tin</h3>
    <form id="profileForm" method="post" action="${pageContext.request.contextPath}/account/profile" novalidate>
      <div class="row">
        <label for="fullName">Họ tên</label>
        <input id="fullName" name="fullName" value="${user.fullName}" required />
      </div>
      <div class="row">
        <label for="phone">Điện thoại</label>
        <input id="phone" name="phone" value="${user.phone}" required />
        <small class="hint">Chỉ nhập số, tối thiểu 9 ký tự.</small>
      </div>
      <div class="row">
        <label for="email">Email</label>
        <input id="email" type="email" name="email" value="${user.email}" required />
      </div>
      <button class="btn btn--primary" type="submit">Lưu thay đổi</button>
    </form>
  </div>

  <!-- Đổi mật khẩu -->
  <div class="card">
    <h3 class="section-title">Đổi mật khẩu</h3>
    <form id="passwordForm" method="post" action="${pageContext.request.contextPath}/account/password" novalidate>
      <div class="row">
        <label for="currentPassword">Mật khẩu hiện tại</label>
        <input id="currentPassword" type="password" name="currentPassword" required />
      </div>
      <div class="row">
        <label for="newPassword">Mật khẩu mới</label>
        <input id="newPassword" type="password" name="newPassword" required />
        <small class="hint">Tối thiểu 8 ký tự, nên có chữ & số.</small>
      </div>
      <div class="row">
        <label for="confirmPassword">Nhập lại mật khẩu mới</label>
        <input id="confirmPassword" type="password" name="confirmPassword" required />
        <small id="pwHint" class="hint"></small>
      </div>

      <div class="actions">
        <button class="btn btn--primary" id="btnChangePw" type="submit">Đổi mật khẩu</button>
        <button class="btn btn--ghost" type="button" id="togglePw">Hiện mật khẩu</button>
      </div>
    </form>
  </div>
</div>

 <!-- ======= FOOTER  ======= -->
<footer class="footer">
  <div class="footer__inner">

    <div class="footer__cols footer__cols--compact">
      <div>
        <h4>Về chúng tôi</h4>
        <p><a href="">Giờ phục vụ: Thứ 2 – CN, 8h30–20h30</a></p>
        <p><a href="">Hotline: 1900 27 27 03</a></p>
        <p><a href="">Địa chỉ: 138 Cần Vương, Quy Nhơn, Gia Lai</a></p>
      </div>

      <div>
        <h4>Dịch vụ & Hỗ trợ</h4>
        <p><a href="${pageContext.request.contextPath}/policies/privacy">Chính sách bảo mật</a></p>
        <p><a href="${pageContext.request.contextPath}/policies/terms">Điều kiện giao dịch</a></p>
      </div>

      <div>
        <h4>Kết nối</h4>
        <div class="payments">
		  <a href="https://facebook.com/yourpage" aria-label="Facebook">
		    <img src="https://cdn.simpleicons.org/facebook/FFFFFF" width="24" height="24" alt="Facebook">
		  </a>
		  <a href="https://www.tiktok.com/@yourpage" aria-label="TikTok">
		    <img src="https://cdn.simpleicons.org/tiktok/FFFFFF" width="24" height="24" alt="TikTok">
		  </a>
		  <a href="https://youtube.com/@yourchannel" aria-label="YouTube">
		    <img src="https://cdn.simpleicons.org/youtube/FFFFFF" width="24" height="24" alt="YouTube">
		  </a>
		  <a href="https://instagram.com/yourpage" aria-label="Instagram">
		    <img src="https://cdn.simpleicons.org/instagram/FFFFFF" width="24" height="24" alt="Instagram">
		  </a>
		</div>
      </div>
    </div>
  </div>
</footer>

<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<script src="<c:url value='/resources/js/account.js'/>"></script>
</body>
</html>
