<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Đăng ký</title></head>
<body>
<h2>Đăng ký tài khoản</h2>

<c:if test="${not empty error}">
  <p style="color:red">${error}</p>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/register">
  <table>
    <tr><td>Username:</td><td><input type="text" name="username" required></td></tr>
    <tr><td>Password:</td><td><input type="password" name="password" required minlength="4"></td></tr>
    <tr><td>Họ tên:</td><td><input type="text" name="fullName" required></td></tr>
    <tr><td>Điện thoại:</td><td><input type="text" name="phone" required></td></tr>
    <tr><td>Email:</td><td><input type="email" name="email" required></td></tr>
    <tr><td colspan="2"><button type="submit">Tạo tài khoản</button></td></tr>
  </table>
</form>

<p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
</body>
</html>
