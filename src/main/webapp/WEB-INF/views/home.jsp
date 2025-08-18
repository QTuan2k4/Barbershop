<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Trang chủ</title>
</head>
<body>
<h2>Xin chào <c:out value="${username}" />!</h2>
<p>Vai trò của bạn: <c:out value="${role}" /></p>

<ul>
    <li><a href="${pageContext.request.contextPath}/users">Quản lý người dùng</a></li>
    <li><a href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
</ul>
</body>
</html>
