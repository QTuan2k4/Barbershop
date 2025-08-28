package service;

import entity.Appointment;
import entity.Review;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class ReviewService {

    @Autowired
    private SessionFactory sessionFactory;

    @Transactional
    public void addReview(Appointment appointment, Integer rating, String comment) {
        Session session = sessionFactory.getCurrentSession();

        Review review = new Review();
        review.setAppointment(appointment);
        review.setRating(rating);
        review.setComment(comment);
        review.setCreatedAt(LocalDateTime.now());

        session.persist(review);
        appointment.setReview(review);
        session.merge(appointment);
    }
}
