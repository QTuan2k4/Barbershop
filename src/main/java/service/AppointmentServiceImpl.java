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
    private final MailService mailService;
    private final AppointmentDao dao;

    @PersistenceContext
    private EntityManager em;

    public AppointmentServiceImpl(AppointmentDao dao, MailService mailService) {
        this.dao = dao;
        this.mailService = mailService;
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
    // ======= APPEND ONLY: Confirm =======
    @Override
    @org.springframework.transaction.annotation.Transactional
    public boolean confirm(Long id) {
        Appointment appt = dao.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy lịch hẹn #" + id));

        String st = appt.getStatus();
        if ("CONFIRMED".equals(st)) return true;
        if ("COMPLETED".equals(st) || "CANCELLED".equals(st)) return false;

        boolean ok = dao.updateStatus(id, "CONFIRMED") > 0;

        // ======= ĐÃ THÊM: gửi mail khi xác nhận =======
        if (ok) {
            mailService.send(
                appt.getUser().getEmail(),
                "Xác nhận lịch hẹn #" + id,
                "Xin chào " + appt.getUser().getFullName()
                + ",\nLịch hẹn của bạn ngày " + appt.getAppointmentDate()
                + " lúc " + appt.getStartTime()
                + " đã được xác nhận.\nHẹn gặp bạn tại Tuấn Barbershop!"
            );
        }

        return ok;
    }

    // ======= APPEND ONLY: Cancel =======
    @Override
    @org.springframework.transaction.annotation.Transactional
    public boolean cancel(Long id, String reason, Long canceledBy) {
        Appointment appt = dao.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy lịch hẹn #" + id));

        String st = appt.getStatus();
        if ("CANCELLED".equals(st)) return true;
        if ("COMPLETED".equals(st)) return false;

        boolean ok = dao.cancel(id, canceledBy, reason, java.time.LocalDateTime.now()) > 0;

        // ======= ĐÃ THÊM: gửi mail khi hủy =======
        if (ok) {
            mailService.send(
                appt.getUser().getEmail(),
                "Hủy lịch hẹn #" + id,
                "Xin chào " + appt.getUser().getFullName()
                + ",\nRất tiếc, lịch hẹn ngày " + appt.getAppointmentDate()
                + " lúc " + appt.getStartTime()
                + " đã bị hủy."
                + (reason != null && !reason.isBlank() ? "\nLý do: " + reason : "")
            );
        }

        return ok;
    }
    @Override
    @Transactional
    public boolean complete(Long id) {
        Appointment appt = dao.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy lịch hẹn #" + id));

        if ("CANCELLED".equals(appt.getStatus()) || "COMPLETED".equals(appt.getStatus())) {
            return false;
        }
        // Chỉ cho complete khi đã CONFIRMED
        if (!"CONFIRMED".equals(appt.getStatus())) {
            return false;
        }
        return dao.complete(id) > 0;
    }
    
}
