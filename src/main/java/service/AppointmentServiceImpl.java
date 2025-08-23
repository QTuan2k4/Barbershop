package service;

import dao.AppointmentDao;
import entity.Appointment;
import entity.Employee;
import entity.ServiceEntity;
import entity.User;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Service
public class AppointmentServiceImpl implements AppointmentService {

    private static final int DURATION_MIN = 30;                 // mọi dịch vụ 30 phút
    private static final LocalTime OPEN  = LocalTime.of(8, 0);  // 08:00
    private static final LocalTime CLOSE = LocalTime.of(21, 0); // 21:00

    private final AppointmentDao dao;

    @PersistenceContext
    private EntityManager em;

    public AppointmentServiceImpl(AppointmentDao dao) {
        this.dao = dao;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> search(String status, Long employeeId, LocalDate date) {
        return dao.findAllWithJoins(status, employeeId, date);
    }

    @Override
    @Transactional
    public Appointment book(Long userId, Long serviceId, Long employeeId, Date date, Time startTime) {
        // 1) Load entities
        User user = em.find(User.class, userId);
        Employee emp = em.find(Employee.class, employeeId);
        ServiceEntity svc = em.find(ServiceEntity.class, serviceId);
        if (user == null || emp == null || svc == null) {
            throw new IllegalArgumentException("User/Employee/Service không tồn tại");
        }

        // 2) Tính endTime: cố định 30 phút
        LocalTime startLt = startTime.toLocalTime();
        LocalTime endLt   = startLt.plusMinutes(DURATION_MIN);
        if (!startLt.isBefore(endLt)) {
            throw new IllegalArgumentException("Thời gian không hợp lệ");
        }

        // 3) Kiểm tra trong giờ mở cửa
        if (startLt.isBefore(OPEN) || endLt.isAfter(CLOSE)) {
            throw new IllegalArgumentException("Ngoài giờ mở cửa (08:00–21:00)");
        }

        Time endTime = Time.valueOf(endLt);

        // 4) Chống chồng lịch (BOOKED/COMPLETED)
        if (dao.existsOverlap(emp.getEmployeeId(), date, startTime, endTime)) {
            throw new IllegalStateException("Khung giờ đã được đặt. Vui lòng chọn giờ khác");
        }

        // 5) Lưu — CHÚ Ý: chuyển sang LocalDate/LocalTime nếu entity dùng kiểu này
        Appointment a = new Appointment();
        a.setUser(user);
        a.setEmployee(emp);
        a.setService(svc);

        // Nếu Appointment dùng LocalDate/LocalTime:
        a.setAppointmentDate(date.toLocalDate());
        a.setStartTime(startLt);
        a.setEndTime(endLt);

        // Nếu Appointment dùng java.sql.Date/Time, đổi 3 dòng trên thành:
        // a.setAppointmentDate(date);
        // a.setStartTime(startTime);
        // a.setEndTime(endTime);

        // Nếu status là String:
        a.setStatus("BOOKED");

        // Nếu status là enum top-level: entity.AppointmentStatus
        // a.setStatus(entity.AppointmentStatus.BOOKED);

        try {
            dao.save(a);
        } catch (DataIntegrityViolationException e) {
            // phòng race-condition: unique index bắn khi vừa bị người khác đặt
            throw new IllegalStateException("Slot vừa hết. Vui lòng thử lại");
        }
        return a;
    }
}
