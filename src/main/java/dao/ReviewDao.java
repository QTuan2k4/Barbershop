package dao;

import entity.Review;
import java.util.List;

public interface ReviewDao {
    void save(Review review);
    Review findById(Long reviewId);
    Review findByAppointmentId(Long appointmentId);
    List<Review> findByAppointmentIdList(Long appointmentId);
    List<Review> findByEmployeeId(Long employeeId);
    List<Review> findAll();
    void update(Review review);
    void delete(Review review);
}
