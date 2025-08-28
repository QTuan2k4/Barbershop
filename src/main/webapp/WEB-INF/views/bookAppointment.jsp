<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Đặt lịch cắt tóc</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/book-appointment.css'/>">
  <link rel="stylesheet" href="<c:url value='/resources/css/home.css'/>">
  <!-- trong <head> -->
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
  <h2>Đặt lịch cắt tóc</h2>

  <c:if test="${not empty err}"><div class="error">${err}</div></c:if>
  <c:if test="${not empty msg}"><div class="msg">${msg}</div></c:if>

  <!-- Xem giờ đã đặt (GET) -->
  <form class="form-inline" method="get" action="<c:url value='/appointments/new'/>">
    <label for="viewDate" class="label-inline">Xem giờ đã đặt theo ngày</label>
    <input type="date" id="viewDate" name="date" value="${selectedDate}" required>
    <button type="submit" class="btn btn--primary">Xem giờ đã đặt</button>
    <div class="muted">Đang xem ngày: <strong>${selectedDate}</strong></div>
  </form>

  <!-- Danh sách giờ đã đặt -->
  <div class="panel">
    <strong>Giờ đã đặt trong ngày:</strong>
    <c:choose>
      <c:when test="${empty booked}">
        <div class="muted">Chưa có lịch đặt nào trong ngày.</div>
      </c:when>
      <c:otherwise>
        <ul class="booked-list">
          <c:forEach var="a" items="${booked}">
            <li>
              ${a.startTime.toString().substring(0,5)}&nbsp;-&nbsp;${a.endTime.toString().substring(0,5)}
              <%-- Nếu a.startTime là java.util.Date có thể dùng:
              <fmt:formatDate value="${a.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${a.endTime}" pattern="HH:mm"/>
              --%>
            </li>
          </c:forEach>
        </ul>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- Form đặt lịch -->
  <form id="bookForm" method="post" action="${pageContext.request.contextPath}/appointments">
    <table class="form-table">
      <tr>
        <td><label for="serviceIds">Dịch vụ</label></td>
        <td>
          <button type="button" id="btnSelectAll" class="btn btn--ghost">Chọn tất cả</button>

          <div class="svc-grid">
            <c:forEach var="s" items="${services}">
              <label class="svc-item">
                <input type="checkbox" name="serviceIds" value="${s.serviceId}">
                <span class="svc-name">${s.name}</span>
                <span class="svc-time muted">(${s.duration} phút)</span>
              </label>
            </c:forEach>
          </div>

          <div class="muted note">Bạn có thể chọn nhiều dịch vụ. Các dịch vụ sẽ được xếp liên tiếp theo giờ bắt đầu.</div>
        </td>
      </tr>

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

    <button type="submit" class="btn btn--primary btn--submit">Đặt lịch</button>
  </form>
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
<script src="<c:url value='/resources/js/book-appointment.js'/>"></script>
</body>
</html>
