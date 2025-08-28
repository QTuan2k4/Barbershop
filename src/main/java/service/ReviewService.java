package service;

import entity.Review;
import java.util.List;

public interface ReviewService {
    Review createReview(Long appointmentId, Integer rating, String comment);
    List<Review> getReviewsByAppointment(Long appointmentId);
    List<Review> getReviewsByEmployee(Long employeeId);
    Review getReviewByAppointment(Long appointmentId);
    boolean canReview(Long appointmentId, Long userId);
}