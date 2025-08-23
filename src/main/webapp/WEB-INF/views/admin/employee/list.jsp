<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../_nav.jsp"/>
<h2>Nhân viên</h2>

<p><a href="${pageContext.request.contextPath}/admin/employees/create">+ Thêm nhân viên</a></p>

<table border="1" cellpadding="6" cellspacing="0">
  <tr>
    <th>ID</th><th>Tên</th><th>Điện thoại</th><th>Email</th>
    <th>Giờ bắt đầu</th><th>Giờ kết thúc</th><th>Hành động</th>
  </tr>
  <c:forEach var="e" items="${employees}">
    <tr>
      <td>${e.employeeId}</td>
      <td>${e.name}</td>
      <td>${e.phone}</td>
      <td>${e.email}</td>
      <td>${e.workStartTime}</td>
      <td>${e.workEndTime}</td>
      <td>
        <a href="${pageContext.request.contextPath}/admin/employees/edit/${e.employeeId}">Sửa</a> |
        <a href="${pageContext.request.contextPath}/admin/employees/delete/${e.employeeId}"
           onclick="return confirm('Xóa nhân viên #${e.employeeId}?')">Xóa</a>
      </td>
    </tr>
  </c:forEach>
</table>
