package dao;

import entity.Review;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.List;

@Repository
@Transactional
public class ReviewDaoImpl implements ReviewDao {

    private final SessionFactory sessionFactory;

    public ReviewDaoImpl(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void save(Review review) {
        getCurrentSession().save(review);
    }

    @Override
    public Review findById(Long reviewId) {
        return getCurrentSession().get(Review.class, reviewId);
    }

    @Override
    public Review findByAppointmentId(Long appointmentId) {
        CriteriaBuilder cb = getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<Review> cq = cb.createQuery(Review.class);
        Root<Review> root = cq.from(Review.class);
        
        cq.select(root).where(cb.equal(root.get("appointment").get("appointmentId"), appointmentId));
        
        List<Review> results = getCurrentSession().createQuery(cq).getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public List<Review> findByAppointmentIdList(Long appointmentId) {
        CriteriaBuilder cb = getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<Review> cq = cb.createQuery(Review.class);
        Root<Review> root = cq.from(Review.class);
        
        cq.select(root).where(cb.equal(root.get("appointment").get("appointmentId"), appointmentId));
        
        return getCurrentSession().createQuery(cq).getResultList();
    }

    @Override
    public List<Review> findByEmployeeId(Long employeeId) {
        CriteriaBuilder cb = getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<Review> cq = cb.createQuery(Review.class);
        Root<Review> root = cq.from(Review.class);
        
        cq.select(root).where(cb.equal(root.get("appointment").get("employee").get("employeeId"), employeeId));
        
        return getCurrentSession().createQuery(cq).getResultList();
    }

    @Override
    public List<Review> findAll() {
        CriteriaBuilder cb = getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<Review> cq = cb.createQuery(Review.class);
        Root<Review> root = cq.from(Review.class);
        
        cq.select(root);
        
        return getCurrentSession().createQuery(cq).getResultList();
    }

    @Override
    public void update(Review review) {
        getCurrentSession().update(review);
    }

    @Override
    public void delete(Review review) {
        getCurrentSession().delete(review);
    }
}