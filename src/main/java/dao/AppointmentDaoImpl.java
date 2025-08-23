package dao;

import entity.Appointment;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public class AppointmentDaoImpl implements AppointmentDao {

    @PersistenceContext
    private EntityManager em;

    @Override
    @Transactional
    public void save(Appointment appt) {
        if (appt.getAppointmentId() == null) em.persist(appt);
        else em.merge(appt);
    }

    @Override
    public List<Appointment> findAllWithJoins(String status, Long employeeId, LocalDate date) {
        StringBuilder jpql = new StringBuilder(
            "select a from Appointment a " +
            "join fetch a.user u " +
            "join fetch a.employee e " +
            "join fetch a.service s " +
            "where 1=1 "
        );
        if (status != null && !status.isBlank()) jpql.append("and a.status = :st ");
        if (employeeId != null) jpql.append("and e.employeeId = :empId ");
        if (date != null) jpql.append("and a.appointmentDate = :d ");
        jpql.append("order by a.appointmentDate, a.startTime");

        var q = em.createQuery(jpql.toString(), Appointment.class);
        if (status != null && !status.isBlank()) q.setParameter("st", status);
        if (employeeId != null) q.setParameter("empId", employeeId);
        if (date != null) q.setParameter("d", date);
        return q.getResultList();
    }

    @Override
    public List<Appointment> findByEmployeeAndDate(Long employeeId, LocalDate date) {
        String jpql =
            "select a from Appointment a " +
            "where a.employee.employeeId = :empId " +
            "and a.appointmentDate = :d " +
            "and a.status in ('BOOKED','COMPLETED') " +
            "order by a.startTime";
        return em.createQuery(jpql, Appointment.class)
                 .setParameter("empId", employeeId)
                 .setParameter("d", date)
                 .getResultList();
    }

    @Override
    public boolean existsOverlap(Long employeeId, LocalDate date, LocalTime start, LocalTime end) {
        String jpql =
            "select count(a) from Appointment a " +
            "where a.employee.employeeId = :empId " +
            "and a.appointmentDate = :d " +
            "and a.status in ('BOOKED','COMPLETED') " +
            "and (:start < a.endTime and :end > a.startTime)";
        Long cnt = em.createQuery(jpql, Long.class)
                .setParameter("empId", employeeId)
                .setParameter("d", date)
                .setParameter("start", start)
                .setParameter("end", end)
                .getSingleResult();
        return cnt != null && cnt > 0;
    }
}
