<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch hẹn của tôi - Barbershop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/customer-appointments.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <header class="header">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/resources/images/logo.jpeg" alt="Barbershop Logo">
            </div>
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/" class="nav-link">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/account" class="nav-link">Tài khoản</a>
                <a href="${pageContext.request.contextPath}/customer/appointments" class="nav-link active">Lịch hẹn</a>
                <a href="${pageContext.request.contextPath}/logout" class="nav-link">Đăng xuất</a>
            </nav>
        </header>

        <main class="main">
            <div class="page-header">
                <h1>Lịch hẹn của tôi</h1>
                <a href="${pageContext.request.contextPath}/appointments/new" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Đặt lịch mới
                </a>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${msg}
                </div>
            </c:if>

            <c:if test="${not empty err}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${err}
                </div>
            </c:if>

            <div class="appointments-container">
                <c:choose>
                    <c:when test="${empty appointments}">
                        <div class="empty-state">
                            <i class="fas fa-calendar-times"></i>
                            <h3>Bạn chưa có lịch hẹn nào</h3>
                            <p>Hãy đặt lịch để trải nghiệm dịch vụ của chúng tôi!</p>
                            <a href="${pageContext.request.contextPath}/appointments/new" class="btn btn-primary">
                                Đặt lịch ngay
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="appointments-grid">
                            <c:forEach var="appointment" items="${appointments}">
                                <div class="appointment-card ${appointment.status.toLowerCase()}">
                                    <div class="appointment-header">
                                        <div class="status-badge ${appointment.status.toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${appointment.status == 'BOOKED'}">
                                                    <i class="fas fa-clock"></i> Đã đặt
                                                </c:when>
                                                <c:when test="${appointment.status == 'CONFIRMED'}">
                                                    <i class="fas fa-check"></i> Đã xác nhận
                                                </c:when>
                                                <c:when test="${appointment.status == 'COMPLETED'}">
                                                    <i class="fas fa-check-double"></i> Hoàn thành
                                                </c:when>
                                                <c:when test="${appointment.status == 'CANCELLED'}">
                                                    <i class="fas fa-times"></i> Đã hủy
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div class="appointment-id">#${appointment.appointmentId}</div>
                                    </div>

                                    <div class="appointment-body">
                                        <div class="service-info">
                                            <h4>${appointment.service.name}</h4>
                                            <p><i class="fas fa-user-tie"></i> ${appointment.employee.name}</p>
                                        </div>

                                        <div class="datetime-info">
                                            <div class="date">
                                                <i class="fas fa-calendar"></i>
                                                <!-- Dùng map appointmentDates -->
                                                <fmt:formatDate value="${appointmentDates[appointment.appointmentId]}" pattern="dd/MM/yyyy"/>
                                            </div>
                                            <div class="time">
                                                <i class="fas fa-clock"></i>
                                                <!-- startTime và endTime cũng nên chuyển sang Date ở Controller -->
                                                <fmt:formatDate value="${startTimes[appointment.appointmentId]}" pattern="HH:mm"/> - 
                                                <fmt:formatDate value="${endTimes[appointment.appointmentId]}" pattern="HH:mm"/>
                                            </div>
                                        </div>

                                        <c:if test="${appointment.status == 'CANCELLED' && not empty appointment.cancelReason}">
                                            <div class="cancel-reason">
                                                <strong>Lý do hủy:</strong> ${appointment.cancelReason}
                                            </div>
                                        </c:if>

                                        <c:if test="${appointment.review != null}">
                                            <div class="review-info">
                                                <div class="rating">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= appointment.review.rating ? 'filled' : ''}"></i>
                                                    </c:forEach>
                                                </div>
                                                <c:if test="${not empty appointment.review.comment}">
                                                    <p class="comment">"${appointment.review.comment}"</p>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="appointment-actions">
                                        <a href="${pageContext.request.contextPath}/customer/appointments/${appointment.appointmentId}" 
                                           class="btn btn-secondary">
                                            <i class="fas fa-eye"></i> Chi tiết
                                        </a>

                                        <c:if test="${appointment.status == 'BOOKED'}">
                                            <button class="btn btn-danger" 
                                                    onclick="showCancelModal(${appointment.appointmentId})">
                                                <i class="fas fa-times"></i> Hủy lịch
                                            </button>
                                        </c:if>

                                        <c:if test="${appointment.status == 'COMPLETED' && appointment.review == null}">
                                            <a href="${pageContext.request.contextPath}/customer/appointments/${appointment.appointmentId}/review" 
                                               class="btn btn-primary">
                                                <i class="fas fa-star"></i> Đánh giá
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <!-- Modal hủy lịch -->
    <div id="cancelModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Hủy lịch hẹn</h3>
                <span class="close">&times;</span>
            </div>
            <form id="cancelForm" method="post">
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn hủy lịch hẹn này?</p>
                    <div class="form-group">
                        <label for="cancelReason">Lý do hủy:</label>
                        <textarea id="cancelReason" name="cancelReason" required 
                                  placeholder="Vui lòng nhập lý do hủy lịch..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeCancelModal()">Không</button>
                    <button type="submit" class="btn btn-danger">Hủy lịch</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/customer-appointments.js"></script>
</body>
</html>

