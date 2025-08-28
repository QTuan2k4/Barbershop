<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá dịch vụ - Barbershop</title>
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
                <h1>Đánh giá dịch vụ</h1>
            </div>

            <div class="review-container">
                <div class="appointment-summary">
                    <h3>Thông tin lịch hẹn #${appointment.appointmentId}</h3>
                    <div class="summary-grid">
                        <div class="summary-item">
                            <label>Dịch vụ:</label>
                            <span>${appointment.service.name}</span>
                        </div>
                        <div class="summary-item">
                            <label>Nhân viên:</label>
                            <span>${appointment.employee.name}</span>
                        </div>
                        <div class="summary-item">
                            <label>Ngày:</label>
                            <span><fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy"/></span>
                        </div>
                        <div class="summary-item">
                            <label>Giờ:</label>
                            <span><fmt:formatDate value="${appointment.startTime}" pattern="HH:mm"/> - 
                                  <fmt:formatDate value="${appointment.endTime}" pattern="HH:mm"/></span>
                        </div>
                    </div>
                </div>

                <div class="review-form-container">
                    <div class="review-form-card">
                        <h3><i class="fas fa-star"></i> Đánh giá của bạn</h3>
                        <p class="form-description">
                            Hãy chia sẻ trải nghiệm của bạn về dịch vụ này để chúng tôi có thể cải thiện chất lượng phục vụ.
                        </p>

                        <form class="review-form" method="post">
                            <div class="form-group">
                                <label for="rating">Đánh giá:</label>
                                <div class="rating-input">
                                    <div class="stars">
                                        <input type="radio" id="star5" name="rating" value="5" required>
                                        <label for="star5" class="star"><i class="fas fa-star"></i></label>
                                        
                                        <input type="radio" id="star4" name="rating" value="4">
                                        <label for="star4" class="star"><i class="fas fa-star"></i></label>
                                        
                                        <input type="radio" id="star3" name="rating" value="3">
                                        <label for="star3" class="star"><i class="fas fa-star"></i></label>
                                        
                                        <input type="radio" id="star2" name="rating" value="2">
                                        <label for="star2" class="star"><i class="fas fa-star"></i></label>
                                        
                                        <input type="radio" id="star1" name="rating" value="1">
                                        <label for="star1" class="star"><i class="fas fa-star"></i></label>
                                    </div>
                                    <div class="rating-text">
                                        <span id="ratingText">Chọn số sao</span>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="comment">Nhận xét (không bắt buộc):</label>
                                <textarea id="comment" name="comment" rows="4" 
                                          placeholder="Hãy chia sẻ cảm nhận của bạn về dịch vụ, nhân viên, hoặc bất kỳ điều gì khác..."></textarea>
                                <small>Bạn có thể để trống phần này nếu chỉ muốn đánh giá bằng số sao.</small>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/customer/appointments" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane"></i> Gửi đánh giá
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/customer-appointments.js"></script>
</body>
</html>
