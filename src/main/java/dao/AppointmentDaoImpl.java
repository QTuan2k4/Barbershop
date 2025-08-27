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
@Transactional
public class AppointmentDaoImpl implements AppointmentDao {

    @PersistenceContext
    private EntityManager em;

    /* ===================== CREATE / UPDATE ===================== */
    @Override
    public void save(Appointment appt) {
        if (appt.getAppointmentId() == null) {
            em.persist(appt);
        } else {
            em.merge(appt);
        }
    }

    /* ============== LIST (JOIN FETCH + optional filters) =============== */
    @Override
    public List<Appointment> findAllWithJoins(String status, Long employeeId, LocalDate date) {
        StringBuilder jpql = new StringBuilder(
            "select distinct a from Appointment a " +              // distinct tránh duplicate do join fetch
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

        if (status != null && !status.isBlank()) q.setParameter("st", status);
        if (employeeId != null)                  q.setParameter("eid", employeeId);
        if (date != null)                        q.setParameter("d", date);

        return q.getResultList();
    }

    /* ======= FIND by employee + date (BOOKED/COMPLETED) ======= */
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

    /* ============== CHECK overlap (BOOKED/COMPLETED) ============== */
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

    /* ===================== REPORTING/APIs bổ sung ===================== */

    @Override
    public List<Appointment> findByDateRange(LocalDate startDate, LocalDate endDate) {
        String jpql = "from Appointment a where a.appointmentDate between :start and :end order by a.appointmentDate, a.startTime";
        return em.createQuery(jpql, Appointment.class)
                 .setParameter("start", startDate)
                 .setParameter("end", endDate)
                 .getResultList();
    }

    @Override
    public List<Object[]> countAppointmentsByService() {
        // Trả về: [serviceName, count]
        String jpql = "select s.name, count(a.appointmentId) " +
                      "from Appointment a join a.service s " +
                      "group by s.name " +
                      "order by count(a.appointmentId) desc";
        return em.createQuery(jpql, Object[].class)
                 .getResultList();
    }

    @Override
    public Long countAllBookings() {
        String jpql = "select count(a.appointmentId) from Appointment a";
        return em.createQuery(jpql, Long.class).getSingleResult();
    }
}
