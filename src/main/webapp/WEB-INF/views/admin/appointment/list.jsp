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
    <option value="CONFIRMED"  ${status=='CONFIRMED'?'selected':''}>CONFIRMED</option>
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
      <td>
      <!-- Nút Xác nhận: chỉ hiện khi status đang BOOKED -->
      <c:if test="${a.status == 'BOOKED'}">
        <form method="post"
              action="${pageContext.request.contextPath}/admin/appointments/${a.appointmentId}/confirm"
              style="display:inline">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <button type="submit">Xác nhận</button>
        </form>
      </c:if>
	  
		   <!-- Nút Hoàn thành: chỉ khi CONFIRMED -->
	  <c:if test="${a.status == 'CONFIRMED'}">
	    <form method="post"
	          action="${pageContext.request.contextPath}/admin/appointments/${a.appointmentId}/complete"
	          style="display:inline">
	      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	      <button type="submit">Hoàn thành</button>
	    </form>
	  </c:if>
		  
      <!-- Nút Hủy: chỉ hiện khi chưa COMPLETED hoặc CANCELLED -->
      <c:if test="${a.status != 'COMPLETED' && a.status != 'CANCELLED'}">
		<form method="post"
		      action="${pageContext.request.contextPath}/admin/appointments/${a.appointmentId}/cancel"
		      style="display:inline"
		      onsubmit="return enterReason(this, ${a.appointmentId});">
		  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		  <input type="hidden" name="reason" value=""/>
		  <button type="submit" style="color:red">Hủy</button>
		</form>
		
		<script>
		function enterReason(form, id) {
		  var r = prompt("Nhập lý do hủy cho lịch hẹn #" + id + ":");
		  if (r == null || r.trim() === "") {
		    alert("Bạn phải nhập lý do!");
		    return false; // chặn submit
		  }
		  form.reason.value = r;
		  return true;
		}
		</script>
      </c:if>
    </td>
    </tr>
  </c:forEach>

</table>
