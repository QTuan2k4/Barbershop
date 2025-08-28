<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Đăng nhập</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css" />
</head>
<body>
  <main class="wrap">
    <section class="card">
      <header class="head">
        <h1>Đăng nhập</h1>
        <p class="sub">Vui lòng nhập thông tin để tiếp tục</p>
      </header>

      <c:if test="${not empty error}">
        <div class="notice notice-error">${error}</div>
      </c:if>
      <c:if test="${not empty msg}">
        <div class="notice notice-ok">${msg}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/login" class="form" autocomplete="on">
        <%-- Nếu dùng Spring Security CSRF, mở dòng dưới --%>
        <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> --%>

        <div class="field">
          <label for="username">Tên đăng nhập</label>
          <input id="username" name="username" type="text" required autofocus />
        </div>

        <div class="field">
          <label for="password">Mật khẩu</label>
          <input id="password" name="password" type="password" required />
        </div>

        <div class="row">
          <label class="check">
            <input type="checkbox" name="rememberMe" />
            <span>Ghi nhớ đăng nhập</span>
          </label>
          <a class="link" href="${pageContext.request.contextPath}/forgot">Quên mật khẩu?</a>
        </div>

        <button type="submit" class="btn">Đăng nhập</button>
      </form>

      <footer class="foot">
        <span>Chưa có tài khoản?</span>
        <a class="link" href="${pageContext.request.contextPath}/register">Đăng ký</a>
      </footer>
    </section>
  </main>
</body>
</html>
