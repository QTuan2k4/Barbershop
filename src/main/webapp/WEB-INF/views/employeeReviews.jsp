<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đánh giá nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .rating-stars {
            color: #ffc107;
            font-size: 1.2rem;
        }
        .review-card {
            border-left: 4px solid #007bff;
            margin-bottom: 1rem;
        }
        .average-rating {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
            margin-bottom: 2rem;
        }
        .star-rating {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-star"></i> Đánh giá nhân viên</h2>
                    <a href="/appointments/my-appointments" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>

                <!-- Thông tin nhân viên và đánh giá trung bình -->
                <div class="average-rating">
                    <div class="row">
                        <div class="col-md-6">
                            <h3><i class="fas fa-user"></i> ${employee.name}</h3>
                            <p><i class="fas fa-phone"></i> ${employee.phone}</p>
                            <p><i class="fas fa-envelope"></i> ${employee.email}</p>
                        </div>
                        <div class="col-md-6">
                            <div class="star-rating">
                                <c:choose>
                                    <c:when test="${empty reviews}">
                                        <i class="fas fa-star text-muted"></i>
                                        <p>Chưa có đánh giá</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="totalRating" value="0" />
                                        <c:forEach var="review" items="${reviews}">
                                            <c:set var="totalRating" value="${totalRating + review.rating}" />
                                        </c:forEach>
                                        <c:set var="averageRating" value="${totalRating / reviews.size()}" />
                                        
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= averageRating}">
                                                    <i class="fas fa-star"></i>
                                                </c:when>
                                                <c:when test="${i - averageRating < 1 && i - averageRating > 0}">
                                                    <i class="fas fa-star-half-alt"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <h4 class="mt-2">${String.format("%.1f", averageRating)} / 5.0</h4>
                                        <p>${reviews.size()} đánh giá</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Danh sách đánh giá -->
                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="text-center py-5">
                            <i class="fas fa-star fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">Chưa có đánh giá nào</h4>
                            <p class="text-muted">Hãy là người đầu tiên đánh giá nhân viên này</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <h4 class="mb-3"><i class="fas fa-list"></i> Tất cả đánh giá</h4>
                        <c:forEach var="review" items="${reviews}">
                            <div class="card review-card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="rating-stars mb-2">
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
                                                <span class="ms-2 text-muted">${review.rating}/5</span>
                                            </div>
                                            
                                            <c:if test="${not empty review.comment}">
                                                <p class="card-text">${review.comment}</p>
                                            </c:if>
                                            
                                            <small class="text-muted">
                                                <i class="fas fa-calendar"></i> 
                                                <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy"/>
                                            </small>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div class="text-muted">
                                                <small>
                                                    <strong>Dịch vụ:</strong> ${review.appointment.service.name}<br>
                                                    <strong>Ngày:</strong> 
                                                    <fmt:formatDate value="${review.appointment.appointmentDate}" pattern="dd/MM/yyyy"/>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>