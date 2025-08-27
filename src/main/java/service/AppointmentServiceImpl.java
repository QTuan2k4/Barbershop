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

        // 2) Tính endTime: cố định 30 phút (dùng java.time)
        LocalTime startLt = startTime.toLocalTime();
        LocalTime endLt   = startLt.plusMinutes(DURATION_MIN);
        if (!startLt.isBefore(endLt)) {
            throw new IllegalArgumentException("Thời gian không hợp lệ");
        }

        // 3) Kiểm tra trong giờ mở cửa
        if (startLt.isBefore(OPEN) || endLt.isAfter(CLOSE)) {
            throw new IllegalArgumentException("Ngoài giờ mở cửa (08:00–21:00)");
        }

        // 4) Chống chồng lịch (BOOKED/COMPLETED) -> dùng chữ ký mới của DAO (java.time)
        LocalDate apptDate = date.toLocalDate();
        boolean overlap = dao.existsOverlap(emp.getEmployeeId(), apptDate, startLt, endLt);
        if (overlap) {
            throw new IllegalStateException("Khung giờ đã được đặt. Vui lòng chọn giờ khác");
        }

        // 5) Lưu — entity Appointment dùng LocalDate/LocalTime
        Appointment a = new Appointment();
        a.setUser(user);
        a.setEmployee(emp);
        a.setService(svc);
        a.setAppointmentDate(apptDate);
        a.setStartTime(startLt);
        a.setEndTime(endLt);
        a.setStatus("BOOKED"); // hoặc enum nếu bạn dùng enum

        try {
            dao.save(a);
        } catch (DataIntegrityViolationException e) {
            // Phòng race-condition (unique/constraint nổ khi vừa bị người khác đặt)
            throw new IllegalStateException("Slot vừa hết. Vui lòng thử lại");
        }
        return a;
    }
}
