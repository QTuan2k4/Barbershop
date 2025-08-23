<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../_nav.jsp"/>
<h2><c:choose>
  <c:when test="${emp.employeeId != null}">Sửa nhân viên</c:when>
  <c:otherwise>Thêm nhân viên</c:otherwise>
</c:choose></h2>

<c:if test="${not empty error}">
  <p style="color:red">${error}</p>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/admin/employees/save">
  <input type="hidden" name="employeeId" value="${emp.employeeId}"/>
  <table>
    <tr><td>Tên:</td><td><input name="name" value="${emp.name}" required/></td></tr>
    <tr><td>Điện thoại:</td><td><input name="phone" value="${emp.phone}" required/></td></tr>
    <tr><td>Email:</td><td><input type="email" name="email" value="${emp.email}" required/></td></tr>
    <tr><td>Giờ bắt đầu:</td><td><input type="time" name="workStartTime" value="${emp.workStartTime}" required/></td></tr>
    <tr><td>Giờ kết thúc:</td><td><input type="time" name="workEndTime" value="${emp.workEndTime}" required/></td></tr>
    <tr><td colspan="2"><button type="submit">Lưu</button></td></tr>
  </table>
</form>
