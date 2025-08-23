<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<title>Đăng nhập</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css">
</head>
<body>
<h2>Đăng nhập</h2>

<c:if test="${not empty error}">
  <p style="color:red">${error}</p>
</c:if>
<c:if test="${not empty msg}">
  <p style="color:green">${msg}</p>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/login">
  <table>
    <tr><td>Username:</td><td><input type="text" name="username" required></td></tr>
    <tr><td>Password:</td><td><input type="password" name="password" required></td></tr>
    <tr><td colspan="2"><button type="submit">Đăng nhập</button></td></tr>
  </table>
</form>

<p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a></p>
</body>
</html>
