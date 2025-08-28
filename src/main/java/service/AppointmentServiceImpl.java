package service;

import dao.AppointmentDao;
import entity.Appointment;
import entity.AppointmentStatus;
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
    public Appointment book(Long userId, Long serviceId, Long employeeId, LocalDate date, LocalTime startTime) {
        // 1) Load entities
        User user = em.find(User.class, userId);
        Employee emp = em.find(Employee.class, employeeId);
        ServiceEntity svc = em.find(ServiceEntity.class, serviceId);
        if (user == null || emp == null || svc == null) {
            throw new IllegalArgumentException("User/Employee/Service không tồn tại");
        }

        // 2) Tính endTime theo duration của service (phút)
        LocalTime startLt = startTime;
        int durationMinutes = (svc.getDuration() != null && svc.getDuration() > 0) ? svc.getDuration() : DURATION_MIN;
        LocalTime endLt   = startLt.plusMinutes(durationMinutes);
        if (!startLt.isBefore(endLt)) {
            throw new IllegalArgumentException("Thời gian không hợp lệ");
        }

        // 3) Kiểm tra trong giờ mở cửa
        if (startLt.isBefore(OPEN) || endLt.isAfter(CLOSE)) {
            throw new IllegalArgumentException("Ngoài giờ mở cửa (08:00–21:00)");
        }

        // 4) Chống chồng lịch (BOOKED/COMPLETED)
        if (dao.existsOverlap(emp.getEmployeeId(), date, startLt, endLt)) {
            throw new IllegalStateException("Khung giờ đã được đặt. Vui lòng chọn giờ khác");
        }

        // 5) Lưu — CHÚ Ý: chuyển sang LocalDate/LocalTime nếu entity dùng kiểu này
        Appointment a = new Appointment();
        a.setUser(user);
        a.setEmployee(emp);
        a.setService(svc);

        a.setAppointmentDate(date);
        a.setStartTime(startLt);
        a.setEndTime(endLt);

        // Set status
        a.setStatus(AppointmentStatus.BOOKED);

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

    @Override
    @Transactional(readOnly = true)
    public List<Appointment> getUserAppointments(Long userId) {
        return dao.findByUserId(userId);
    }

    @Override
    @Transactional
    public Appointment cancelAppointment(Long appointmentId, Long userId, String reason) {
        Appointment appointment = dao.findById(appointmentId);
        if (appointment == null) {
            throw new IllegalArgumentException("Lịch hẹn không tồn tại");
        }
        
        if (!appointment.getUser().getUserId().equals(userId)) {
            throw new IllegalStateException("Bạn không có quyền hủy lịch hẹn này");
        }
        
        if (appointment.getStatus() != AppointmentStatus.BOOKED) {
            throw new IllegalStateException("Chỉ có thể hủy lịch hẹn đã đặt");
        }
        
        appointment.setStatus(AppointmentStatus.CANCELLED);
        appointment.setNote(reason);
        
        dao.update(appointment);
        return appointment;
    }

    @Override
    @Transactional
    public Appointment completeAppointment(Long appointmentId) {
        Appointment appointment = dao.findById(appointmentId);
        if (appointment == null) {
            throw new IllegalArgumentException("Lịch hẹn không tồn tại");
        }
        
        if (appointment.getStatus() != AppointmentStatus.BOOKED) {
            throw new IllegalStateException("Chỉ có thể hoàn thành lịch hẹn đã đặt");
        }
        
        appointment.setStatus(AppointmentStatus.COMPLETED);
        dao.update(appointment);
        return appointment;
    }
}


