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

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Service
public class AppointmentServiceImpl implements AppointmentService {

    private static final LocalTime OPEN  = LocalTime.of(8, 0);
    private static final LocalTime CLOSE = LocalTime.of(21, 0);

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
    public Appointment book(Long userId, Long serviceId, Long employeeId, LocalDate date, LocalTime startTime) {
        // Load entities
        User user = em.find(User.class, userId);
        Employee emp = em.find(Employee.class, employeeId);
        ServiceEntity svc = em.find(ServiceEntity.class, serviceId);
        if (user == null || emp == null || svc == null) {
            throw new IllegalArgumentException("User/Employee/Service không tồn tại");
        }

        // Duration theo DB
        Integer dur = svc.getDuration();
        if (dur == null || dur <= 0) throw new IllegalArgumentException("Thời lượng dịch vụ không hợp lệ");

        LocalTime endTime = startTime.plusMinutes(dur);
        if (!startTime.isBefore(endTime)) throw new IllegalArgumentException("Thời gian không hợp lệ");

        // Khung mở cửa
        if (startTime.isBefore(OPEN) || endTime.isAfter(CLOSE)) {
            throw new IllegalArgumentException("Ngoài giờ mở cửa (08:00–21:00)");
        }

        // Chồng lịch (BOOKED/COMPLETED)
        if (dao.existsOverlap(emp.getEmployeeId(), date, startTime, endTime)) {
            throw new IllegalStateException("Khung giờ đã được đặt. Vui lòng chọn giờ khác");
        }

        // Lưu (entity Appointment dùng LocalDate/LocalTime, status String)
        Appointment a = new Appointment();
        a.setUser(user);
        a.setEmployee(emp);
        a.setService(svc);
        a.setAppointmentDate(date);
        a.setStartTime(startTime);
        a.setEndTime(endTime);
        a.setStatus("BOOKED");

        try {
            dao.save(a);
        } catch (DataIntegrityViolationException e) {
            throw new IllegalStateException("Slot vừa hết. Vui lòng thử lại");
        }
        return a;
    }
}
