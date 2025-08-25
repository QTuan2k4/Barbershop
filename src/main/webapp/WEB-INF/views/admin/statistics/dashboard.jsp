<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển Thống kê</title>
</head>
<body>
<h1>Thống kê Lượt đặt lịch</h1>
<hr/>

<h2>Tổng số lượt đặt</h2>
<p>Tổng số lượt đặt lịch đã ghi nhận: <strong>${totalBookings}</strong></p>

<h2>Số lượt đặt theo dịch vụ</h2>
<table border="1">
    <thead>
    <tr>
        <th>Dịch vụ</th>
        <th>Số lượt đặt</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="entry" items="${bookingCountByService}">
        <tr>
            <td>${entry.key}</td>
            <td>${entry.value}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<p><a href="<c:url value='/admin' />">Quay lại trang Admin</a></p>
</body>
</html>