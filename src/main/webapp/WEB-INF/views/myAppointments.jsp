<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch hẹn của tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.8em;
            padding: 0.25em 0.6em;
        }
        .status-booked { background-color: #007bff; color: white; }
        .status-completed { background-color: #28a745; color: white; }
        .status-cancelled { background-color: #dc3545; color: white; }
        .appointment-card {
            border-left: 4px solid #007bff;
            margin-bottom: 1rem;
        }
        .appointment-card.completed {
            border-left-color: #28a745;
        }
        .appointment-card.cancelled {
            border-left-color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-calendar-check"></i> Lịch hẹn của tôi</h2>
                    <a href="<c:url value='/appointments/new'/>" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Đặt lịch mới
                    </a>
                </div>

                <!-- Flash messages -->
                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty err}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${err}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${empty appointments}">
                        <div class="text-center py-5">
                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">Bạn chưa có lịch hẹn nào</h4>
                            <p class="text-muted">Hãy đặt lịch để sử dụng dịch vụ của chúng tôi</p>
                            <a href="<c:url value='/appointments/new'/>" class="btn btn-primary">Đặt lịch ngay</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row">
                            <c:forEach var="appointment" items="${appointments}">
                                <div class="col-12">
                                    <div class="card appointment-card ${appointment.status.name().toLowerCase()}">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-8">
                                                    <h5 class="card-title">
                                                        <i class="fas fa-cut"></i> ${appointment.service.name}
                                                    </h5>
                                                    <p class="card-text">
                                                        <strong>Nhân viên:</strong> ${appointment.employee.name}<br>
                                                        <strong>Ngày:</strong> 
                                                        ${appointment.appointmentDate}<br>
                                                        <strong>Giờ:</strong> 
                                                        ${appointment.startTime} - ${appointment.endTime}<br>
                                                        <strong>Trạng thái:</strong>
                                                        <span class="badge status-badge status-${appointment.status.name().toLowerCase()}">
                                                            ${appointment.status.displayName}
                                                        </span>
                                                    </p>
                                                    <c:if test="${not empty appointment.note}">
                                                        <p class="card-text">
                                                            <strong>Ghi chú:</strong> ${appointment.note}
                                                        </p>
                                                    </c:if>
                                                </div>
                                                <div class="col-md-4 text-end">
                                                    <div class="btn-group-vertical">
                                                        <c:if test="${appointment.status.name() == 'BOOKED'}">
                                                            <button type="button" class="btn btn-outline-danger btn-sm mb-2" 
                                                                    onclick="showCancelModal(${appointment.appointmentId})">
                                                                <i class="fas fa-times"></i> Hủy lịch
                                                            </button>
                                                        </c:if>
                                                        
                                                        <c:if test="${appointment.status.name() == 'COMPLETED'}">
                                                            <c:choose>
                                                                <c:when test="${empty appointment.review}">
                                                                    <a href="<c:url value='/reviews/${appointment.appointmentId}/create'/>" 
                                                                       class="btn btn-success btn-sm mb-2">
                                                                        <i class="fas fa-star"></i> Đánh giá
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="<c:url value='/reviews/appointment/${appointment.appointmentId}'/>" 
                                                                       class="btn btn-info btn-sm mb-2">
                                                                        <i class="fas fa-eye"></i> Xem đánh giá
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>
                                                        
                                                        <a href="<c:url value='/reviews/employee/${appointment.employee.employeeId}'/>" 
                                                           class="btn btn-outline-info btn-sm">
                                                            <i class="fas fa-star"></i> Xem đánh giá nhân viên
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Cancel Appointment Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Hủy lịch hẹn</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="cancelForm" method="post">
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn hủy lịch hẹn này?</p>
                        <div class="mb-3">
                            <label for="reason" class="form-label">Lý do hủy:</label>
                            <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Không</button>
                        <button type="submit" class="btn btn-danger">Hủy lịch</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showCancelModal(appointmentId) {
            document.getElementById('cancelForm').action = '/appointments/' + appointmentId + '/cancel';
            new bootstrap.Modal(document.getElementById('cancelModal')).show();
        }
    </script>
</body>
</html>