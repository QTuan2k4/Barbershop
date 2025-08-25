package dao;

import entity.Appointment;

import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;

import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public class AppointmentDaoImpl implements AppointmentDao {

    @PersistenceContext
    private EntityManager em;

    // CREATE / UPDATE
    @Override
    @Transactional
    public void save(Appointment appt) {
        if (appt.getAppointmentId() == null) {
            em.persist(appt);
        } else {
            em.merge(appt);
        }
    }

    // LIST + optional filters
    @Override
    public List<Appointment> findAllWithJoins(String status, Long employeeId, LocalDate date) {
        StringBuilder jpql = new StringBuilder(
            "select a from Appointment a " +
            "join fetch a.user u " +
            "join fetch a.employee e " +
            "join fetch a.service sv " +
            "where 1=1 "
        );
        if (status != null && !status.isBlank()) jpql.append("and a.status = :st ");
        if (employeeId != null)                  jpql.append("and e.employeeId = :eid ");
        if (date != null)                        jpql.append("and a.appointmentDate = :d ");
        jpql.append("order by a.appointmentDate desc, a.startTime desc");

        var q = em.createQuery(jpql.toString(), Appointment.class);

        if (status != null && !status.isBlank()) {
            q.setParameter("st", status); // status là String
        }
        if (employeeId != null) {
            q.setParameter("eid", employeeId);
        }
        if (date != null) {
            q.setParameter("d", date); // LocalDate
        }
        return q.getResultList();
    }

    // FIND by employee + date (BOOKED/COMPLETED)
    @Override
    public List<Appointment> findByEmployeeAndDate(Long employeeId, Date date) {
        String jpql =
            "select a from Appointment a " +
            "where a.employee.employeeId = :empId " +
            "and a.appointmentDate = :d " +
            "and a.status in ('BOOKED','COMPLETED') " +
            "order by a.startTime";

        LocalDate ld = date.toLocalDate(); // convert sql.Date -> LocalDate

        return em.createQuery(jpql, Appointment.class)
                 .setParameter("empId", employeeId)
                 .setParameter("d", ld)  // LocalDate
                 .getResultList();
    }

    // CHECK overlap (BOOKED/COMPLETED)
    @Override
    public boolean existsOverlap(Long employeeId, Date date, Time start, Time end) {
        String jpql =
            "select count(a) from Appointment a " +
            "where a.employee.employeeId = :empId " +
            "and a.appointmentDate = :d " +
            "and a.status in ('BOOKED','COMPLETED') " +
            "and (:start < a.endTime and :end > a.startTime)";

        LocalDate ld = date.toLocalDate();

        Long cnt = em.createQuery(jpql, Long.class)
                     .setParameter("empId", employeeId)
                     .setParameter("d", ld) // LocalDate
                     .setParameter("start", start.toLocalTime()) // convert Time -> LocalTime
                     .setParameter("end", end.toLocalTime())     // convert Time -> LocalTime
                     .getSingleResult();

        return cnt != null && cnt > 0;
    }

    @Override
    public Appointment findById(Long appointmentId) {
        return em.find(Appointment.class, appointmentId);
    }

    @Override
    public List<Appointment> findByUserId(Long userId) {
        String jpql = "select a from Appointment a " +
                     "join fetch a.employee e " +
                     "join fetch a.service sv " +
                     "where a.user.userId = :userId " +
                     "order by a.appointmentDate desc, a.startTime desc";
        
        return em.createQuery(jpql, Appointment.class)
                 .setParameter("userId", userId)
                 .getResultList();
    }

    @Override
    @Transactional
    public void update(Appointment appointment) {
        em.merge(appointment);
    }
}

