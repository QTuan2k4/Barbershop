<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đánh giá lịch hẹn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .rating-stars {
            color: #ffc107;
            font-size: 2rem;
        }
        .review-detail {
            background-color: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin: 1rem 0;
        }
        .appointment-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-star"></i> Đánh giá lịch hẹn</h2>
                    <a href="/appointments/my-appointments" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>

                <!-- Thông tin lịch hẹn -->
                <div class="appointment-info">
                    <h3><i class="fas fa-calendar-check"></i> Thông tin lịch hẹn</h3>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Dịch vụ:</strong> ${appointment.service.name}</p>
                            <p><strong>Nhân viên:</strong> ${appointment.employee.name}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Ngày:</strong> 
                                <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy"/>
                            </p>
                            <p><strong>Giờ:</strong> 
                                <fmt:formatDate value="${appointment.startTime}" pattern="HH:mm"/> - 
                                <fmt:formatDate value="${appointment.endTime}" pattern="HH:mm"/>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Chi tiết đánh giá -->
                <c:choose>
                    <c:when test="${empty review}">
                        <div class="text-center py-5">
                            <i class="fas fa-exclamation-circle fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">Không tìm thấy đánh giá</h4>
                            <p class="text-muted">Lịch hẹn này chưa có đánh giá</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card">
                            <div class="card-header">
                                <h4 class="mb-0"><i class="fas fa-star"></i> Đánh giá của bạn</h4>
                            </div>
                            <div class="card-body">
                                <div class="review-detail">
                                    <div class="text-center mb-3">
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= review.rating}">
                                                        <i class="fas fa-star"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <h5 class="mt-2">${review.rating}/5 sao</h5>
                                    </div>
                                    
                                    <c:if test="${not empty review.comment}">
                                        <div class="text-center">
                                            <h6><strong>Nhận xét:</strong></h6>
                                            <p class="lead">"${review.comment}"</p>
                                        </div>
                                    </c:if>
                                    
                                    <div class="text-center text-muted">
                                        <small>
                                            <i class="fas fa-calendar"></i> 
                                            Đánh giá vào ngày: 
                                            <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy"/>
                                        </small>
                                    </div>
                                </div>
                                
                                <div class="text-center mt-3">
                                    <a href="/reviews/employee/${appointment.employee.employeeId}" 
                                       class="btn btn-outline-info">
                                        <i class="fas fa-star"></i> Xem tất cả đánh giá của nhân viên
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>