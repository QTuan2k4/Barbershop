<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Dịch vụ</title>
    <style>
        .alert { padding:10px 12px; border-radius:8px; margin:10px 0; }
        .alert-success { background:#e8f5e9; color:#1b5e20; border:1px solid #c8e6c9; }
        .alert-danger  { background:#ffebee; color:#b71c1c; border:1px solid #ffcdd2; }
    </style>
</head>
<body>
<h1>Danh sách Dịch vụ</h1>
<a href="<c:url value='/admin/services/add' />">Thêm dịch vụ mới</a>
<hr/>

<!-- Thông báo -->
<c:if test="${not empty error}">
    <div class="alert alert-danger">
        ${error}
    </div>
</c:if>
<c:if test="${not empty message}">
    <div class="alert alert-success">
        ${message}
    </div>
</c:if>

<h2>Dịch vụ cơ bản</h2>
<table border="1">
    <thead>
    <tr>
        <th>ID</th>
        <th>Tên dịch vụ</th>
        <th>Mô tả</th>
        <th>Giá</th>
        <th>Thời lượng (phút)</th>
        <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="service" items="${basicServices}">
        <tr>
            <td>${service.serviceId}</td>
            <td>${service.name}</td>
            <td>${service.description}</td>
            <td>${service.price} VNĐ</td>
            <td>${service.duration}</td>
            <td>
                <a href="<c:url value='/admin/services/edit/${service.serviceId}' />">Sửa</a> |
                <a href="<c:url value='/admin/services/delete/${service.serviceId}' />"
                   onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này?')">Xóa</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<h2>Dịch vụ chuyên sâu</h2>
<table border="1">
    <thead>
    <tr>
        <th>ID</th>
        <th>Tên dịch vụ</th>
        <th>Mô tả</th>
        <th>Giá</th>
        <th>Thời lượng (phút)</th>
        <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="service" items="${advancedServices}">
        <tr>
            <td>${service.serviceId}</td>
            <td>${service.name}</td>
            <td>${service.description}</td>
            <td>${service.price} VNĐ</td>
            <td>${service.duration}</td>
            <td>
                <a href="<c:url value='/admin/services/edit/${service.serviceId}' />">Sửa</a> |
                <a href="<c:url value='/admin/services/delete/${service.serviceId}' />"
                   onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này?')">Xóa</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<h2>Dịch vụ chăm sóc và thư giãn</h2>
<table border="1">
    <thead>
    <tr>
        <th>ID</th>
        <th>Tên dịch vụ</th>
        <th>Mô tả</th>
        <th>Giá</th>
        <th>Thời lượng (phút)</th>
        <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="service" items="${careServices}">
        <tr>
            <td>${service.serviceId}</td>
            <td>${service.name}</td>
            <td>${service.description}</td>
            <td>${service.price} VNĐ</td>
            <td>${service.duration}</td>
            <td>
                <a href="<c:url value='/admin/services/edit/${service.serviceId}' />">Sửa</a> |
                <a href="<c:url value='/admin/services/delete/${service.serviceId}' />"
                   onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này?')">Xóa</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<br/>
<a href="<c:url value='/admin' />">Quay lại trang Admin</a>
</body>
</html>
