package service;

import dao.ReviewDao;
import entity.Appointment;
import entity.AppointmentStatus;
import entity.Review;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.time.LocalDate;
import java.util.List;

@Service
public class ReviewServiceImpl implements ReviewService {

    private final ReviewDao reviewDao;

    @PersistenceContext
    private EntityManager em;

    public ReviewServiceImpl(ReviewDao reviewDao) {
        this.reviewDao = reviewDao;
    }

    @Override
    @Transactional
    public Review createReview(Long appointmentId, Integer rating, String comment) {
        Appointment appointment = em.find(Appointment.class, appointmentId);
        if (appointment == null) {
            throw new IllegalArgumentException("Lịch hẹn không tồn tại");
        }
        
        if (appointment.getStatus() != AppointmentStatus.COMPLETED) {
            throw new IllegalStateException("Chỉ có thể đánh giá lịch hẹn đã hoàn thành");
        }
        
        // Kiểm tra xem đã có review chưa
        Review existingReview = reviewDao.findByAppointmentId(appointmentId);
        if (existingReview != null) {
            throw new IllegalStateException("Lịch hẹn này đã được đánh giá");
        }
        
        Review review = new Review();
        review.setAppointment(appointment);
        review.setRating(rating);
        review.setComment(comment);
        review.setReviewDate(LocalDate.now());
        
        reviewDao.save(review);
        return review;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Review> getReviewsByAppointment(Long appointmentId) {
        return reviewDao.findByAppointmentIdList(appointmentId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Review> getReviewsByEmployee(Long employeeId) {
        return reviewDao.findByEmployeeId(employeeId);
    }

    @Override
    @Transactional(readOnly = true)
    public Review getReviewByAppointment(Long appointmentId) {
        return reviewDao.findByAppointmentId(appointmentId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean canReview(Long appointmentId, Long userId) {
        Appointment appointment = em.find(Appointment.class, appointmentId);
        if (appointment == null) {
            return false;
        }
        
        // Kiểm tra xem user có phải là người đặt lịch không
        if (!appointment.getUser().getUserId().equals(userId)) {
            return false;
        }
        
        // Kiểm tra xem lịch hẹn đã hoàn thành chưa
        if (appointment.getStatus() != AppointmentStatus.COMPLETED) {
            return false;
        }
        
        // Kiểm tra xem đã có review chưa
        Review existingReview = reviewDao.findByAppointmentId(appointmentId);
        return existingReview == null;
    }
}
