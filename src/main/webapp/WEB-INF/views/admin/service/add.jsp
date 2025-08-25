<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Dịch vụ</title>
</head>
<body>
<h1>Thêm Dịch vụ mới</h1>
<form:form action="${pageContext.request.contextPath}/admin/services/add" method="post" modelAttribute="service">
    <p>Tên dịch vụ: <form:input path="name" /></p>
    <p>Mô tả: <form:textarea path="description" /></p>
    <p>Giá: <form:input path="price" /></p>
    <p>Thời lượng (phút): <form:input path="duration" /></p>

    <p>Danh mục:
        <form:select path="category">
            <form:option value="Dịch vụ cơ bản" label="Dịch vụ cơ bản" />
            <form:option value="Dịch vụ chuyên sâu" label="Dịch vụ chuyên sâu" />
            <form:option value="Dịch vụ chăm sóc và thư giãn" label="Dịch vụ chăm sóc và thư giãn" />
        </form:select>
    </p>

    <p><input type="submit" value="Lưu" /></p>
</form:form>
<a href="<c:url value='/admin/services' />">Quay lại danh sách</a>
</body>
</html>