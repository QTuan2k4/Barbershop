package dao;

import entity.Appointment;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public class AppointmentDaoImpl implements AppointmentDao {

    private final SessionFactory sessionFactory;

    public AppointmentDaoImpl(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    private Session s() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public List<Appointment> findByDateRange(LocalDate startDate, LocalDate endDate) {
        Query<Appointment> query = s().createQuery("from Appointment where appointmentDate between :start and :end", Appointment.class);
        query.setParameter("start", startDate);
        query.setParameter("end", endDate);
        return query.getResultList();
    }

    @Override
    public List<Object[]> countAppointmentsByService() {
        // Sử dụng HQL để JOIN và GROUP BY
        Query<Object[]> query = s().createQuery(
                "select s.name, count(a.appointmentId) from Appointment a join a.service s group by s.name", Object[].class);
        return query.getResultList();
    }

    @Override
    public Long countAllBookings() {
        return s().createQuery("select count(a.appointmentId) from Appointment a", Long.class)
                .uniqueResult();
    }
}
