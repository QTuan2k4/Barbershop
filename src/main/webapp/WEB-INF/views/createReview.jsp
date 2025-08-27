<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đánh giá dịch vụ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .rating-stars {
            font-size: 2rem;
            color: #ffc107;
            cursor: pointer;
        }
        .rating-stars:hover {
            color: #ffdb4d;
        }
        .rating-stars.selected {
            color: #ffc107;
        }
        .appointment-info {
            background-color: #f8f9fa;
            border-radius: 0.375rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="mb-0">
                            <i class="fas fa-star"></i> Đánh giá dịch vụ
                        </h3>
                    </div>
                    <div class="card-body">
                        <!-- Thông tin lịch hẹn -->
                        <div class="appointment-info">
                            <h5><i class="fas fa-calendar-check"></i> Thông tin lịch hẹn</h5>
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

                        <!-- Form đánh giá -->
                        <form action="/reviews/${appointment.appointmentId}/create" method="post">
                            <div class="mb-4">
                                <label class="form-label">
                                    <strong>Đánh giá của bạn:</strong>
                                </label>
                                <div class="rating-stars" id="ratingStars">
                                    <i class="fas fa-star" data-rating="1"></i>
                                    <i class="fas fa-star" data-rating="2"></i>
                                    <i class="fas fa-star" data-rating="3"></i>
                                    <i class="fas fa-star" data-rating="4"></i>
                                    <i class="fas fa-star" data-rating="5"></i>
                                </div>
                                <input type="hidden" name="rating" id="ratingInput" required>
                                <div class="form-text">Chọn số sao để đánh giá (1-5 sao)</div>
                            </div>

                            <div class="mb-4">
                                <label for="comment" class="form-label">
                                    <strong>Nhận xét (không bắt buộc):</strong>
                                </label>
                                <textarea class="form-control" id="comment" name="comment" rows="4" 
                                          placeholder="Chia sẻ trải nghiệm của bạn về dịch vụ..."></textarea>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="/appointments/my-appointments" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                                <button type="submit" class="btn btn-success" id="submitBtn" disabled>
                                    <i class="fas fa-paper-plane"></i> Gửi đánh giá
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let selectedRating = 0;
        const stars = document.querySelectorAll('.rating-stars i');
        const ratingInput = document.getElementById('ratingInput');
        const submitBtn = document.getElementById('submitBtn');

        // Xử lý click vào sao
        stars.forEach(star => {
            star.addEventListener('click', function() {
                const rating = parseInt(this.getAttribute('data-rating'));
                selectRating(rating);
            });

            star.addEventListener('mouseenter', function() {
                const rating = parseInt(this.getAttribute('data-rating'));
                highlightStars(rating);
            });
        });

        // Xử lý hover
        document.getElementById('ratingStars').addEventListener('mouseleave', function() {
            highlightStars(selectedRating);
        });

        function selectRating(rating) {
            selectedRating = rating;
            ratingInput.value = rating;
            highlightStars(rating);
            submitBtn.disabled = false;
        }

        function highlightStars(rating) {
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('selected');
                } else {
                    star.classList.remove('selected');
                }
            });
        }

        // Validation
        document.querySelector('form').addEventListener('submit', function(e) {
            if (selectedRating === 0) {
                e.preventDefault();
                alert('Vui lòng chọn số sao đánh giá!');
                return false;
            }
        });
    </script>
</body>
</html>