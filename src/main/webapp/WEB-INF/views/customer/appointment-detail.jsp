<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết lịch hẹn - Barbershop</title>
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
                <a href="${pageContext.request.contextPath}/customer/appointments" class="nav-link">Lịch hẹn</a>
                <a href="${pageContext.request.contextPath}/logout" class="nav-link">Đăng xuất</a>
                
            </nav>
        </header>

        <main class="main">
            <div class="page-header">
                <a href="${pageContext.request.contextPath}/customer/appointments" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
                <h1>Chi tiết lịch hẹn #${appointment.appointmentId}</h1>
            </div>

            <div class="appointment-detail-container">
                <div class="detail-card">
                    <div class="detail-header">
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

                    <div class="detail-body">
                        <div class="detail-section">
                            <h3><i class="fas fa-info-circle"></i> Thông tin dịch vụ</h3>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <label>Dịch vụ:</label>
                                    <span>${appointment.service.name}</span>
                                </div>
                                <div class="detail-item">
                                    <label>Nhân viên:</label>
                                    <span>${appointment.employee.name}</span>
                                </div>
                                <div class="detail-item">
                                    <label>Giá:</label>
                                    <span><fmt:formatNumber value="${appointment.service.price}" type="currency" currencySymbol="₫"/></span>
                                </div>
                                <div class="detail-item">
                                    <label>Thời lượng:</label>
                                    <span>${appointment.service.duration} phút</span>
                                </div>
                            </div>
                        </div>

                        <!-- Thời gian -->
                        <div class="detail-section">
                            <h3><i class="fas fa-calendar-alt"></i> Thời gian</h3>
                            <div class="detail-grid">
                                <div class="detail-item">
                                    <label>Ngày:</label>
                                    <span>${appointmentDateFmt}</span>
                                </div>
                                <div class="detail-item">
                                    <label>Giờ:</label>
                                    <span>${startTimeFmt} - ${endTimeFmt}</span>
                                </div>
                                <div class="detail-item">
                                    <label>Đặt lịch lúc:</label>
                                    <span>${createdAtFmt}</span>
                                </div>
                                <c:if test="${appointment.status == 'CANCELLED' && not empty canceledAtFmt}">
                                    <div class="detail-item">
                                        <label>Hủy lúc:</label>
                                        <span>${canceledAtFmt}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <c:if test="${appointment.status == 'CANCELLED' && not empty appointment.cancelReason}">
                            <div class="detail-section">
                                <h3><i class="fas fa-times-circle"></i> Lý do hủy</h3>
                                <div class="cancel-reason-detail">
                                    <p>${appointment.cancelReason}</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${appointment.review != null}">
                            <div class="detail-section">
                                <h3><i class="fas fa-star"></i> Đánh giá của bạn</h3>
                                <div class="review-detail">
                                    <div class="rating-display">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= appointment.review.rating ? 'filled' : ''}"></i>
                                        </c:forEach>
                                        <span class="rating-text">${appointment.review.rating}/5 sao</span>
                                    </div>
                                    <c:if test="${not empty appointment.review.comment}">
                                        <div class="comment-display">
                                            <p>"${appointment.review.comment}"</p>
                                        </div>
                                    </c:if>
									<div class="review-date">
									    Đánh giá lúc:
									    <c:if test="${not empty reviewCreatedAtFmt}">
									        <fmt:formatDate value="${reviewCreatedAtFmt}" pattern="HH:mm dd/MM/yyyy"/>
									    </c:if>
									</div>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <div class="detail-actions">
                        <c:if test="${appointment.status == 'BOOKED'}">
                            <button class="btn btn-danger" onclick="showCancelModal(${appointment.appointmentId})">
                                <i class="fas fa-times"></i> Hủy lịch
                            </button>
                        </c:if>

                        <c:if test="${appointment.status == 'COMPLETED' && appointment.review == null}">
                            <a href="${pageContext.request.contextPath}/customer/appointments/${appointment.appointmentId}/review" 
                               class="btn btn-primary">
                                <i class="fas fa-star"></i> Đánh giá
                            </a>
                        </c:if>

                        <a href="${pageContext.request.contextPath}/appointments/new" class="btn btn-secondary">
                            <i class="fas fa-plus"></i> Đặt lịch mới
                        </a>
                    </div>
                </div>
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
