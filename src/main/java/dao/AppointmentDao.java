package dao;

import entity.Appointment;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface AppointmentDao {
    void save(Appointment appt);

    List<Appointment> findAllWithJoins(String status, Long employeeId, LocalDate date);

    // Dùng java.time thay vì java.sql
    List<Appointment> findByEmployeeAndDate(Long employeeId, LocalDate date);

    boolean existsOverlap(Long employeeId, LocalDate date, LocalTime start, LocalTime end);

    // Các method báo cáo từ nhánh Test
    List<Appointment> findByDateRange(LocalDate startDate, LocalDate endDate);

    List<Object[]> countAppointmentsByService();

    Long countAllBookings();
}
