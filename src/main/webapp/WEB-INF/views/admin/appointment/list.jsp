<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../_nav.jsp"/>
<h2>Lịch hẹn</h2>

<form method="get" action="${pageContext.request.contextPath}/admin/appointments" style="margin-bottom:12px">
  Trạng thái:
  <select name="status">
    <option value="">-- Tất cả --</option>
    <option value="BOOKED"     ${status=='BOOKED'?'selected':''}>BOOKED</option>
    <option value="CANCELLED"  ${status=='CANCELLED'?'selected':''}>CANCELLED</option>
    <option value="COMPLETED"  ${status=='COMPLETED'?'selected':''}>COMPLETED</option>
  </select>
  &nbsp;Nhân viên:
  <select name="employeeId">
    <option value="">-- Tất cả --</option>
    <c:forEach var="e" items="${employees}">
      <option value="${e.employeeId}" ${employeeId==e.employeeId?'selected':''}>
        ${e.name}
      </option>
    </c:forEach>
  </select>
  &nbsp;Ngày:
  <input type="date" name="date" value="${date}"/>
  <button type="submit">Lọc</button>
</form>

<table border="1" cellpadding="6" cellspacing="0">
  <tr>
    <th>ID</th><th>Khách hàng</th><th>Nhân viên</th><th>Dịch vụ</th>
    <th>Ngày</th><th>Bắt đầu</th><th>Kết thúc</th><th>Trạng thái</th>
  </tr>
  <c:forEach var="a" items="${appointments}">
    <tr>
      <td>${a.appointmentId}</td>
      <td>${a.user.fullName} (${a.user.phone})</td>
      <td>${a.employee.name}</td>
      <td>${a.service.name}</td>
      <td>${a.appointmentDate}</td>
      <td>${a.startTime}</td>
      <td>${a.endTime}</td>
      <td>${a.status}</td>
    </tr>
  </c:forEach>
</table>
