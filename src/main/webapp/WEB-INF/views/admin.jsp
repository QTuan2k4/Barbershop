<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị</title>
</head>
<body>
<h1>Trang Quản Trị</h1>
<hr/>

<h2>Chào mừng đến với Bảng điều khiển Quản trị!</h2>
<p>Hãy chọn một chức năng dưới đây:</p>

<ul>
    <li><a href="<c:url value='/admin/services' />">Quản lý Dịch vụ</a></li>
    <li><a href="<c:url value='/admin/statistics' />">Thống kê Lượt đặt lịch</a></li>
    <li><a href="<c:url value='/' />">Quay lại Trang chủ</a></li>
</ul>

</body>
</html>