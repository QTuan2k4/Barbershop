package dao;

import entity.Appointment;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;


public interface AppointmentDao {
    void save(Appointment appt);

    List<Appointment> findAllWithJoins(String status, Long employeeId, LocalDate date);

    // Dùng java.time thay vì java.sql
    List<Appointment> findByEmployeeAndDate(Long employeeId, LocalDate date);

    boolean existsOverlap(Long employeeId, LocalDate date, LocalTime start, LocalTime end);

    // Các method báo cáo từ nhánh Test
    List<Appointment> findByDateRange(LocalDate startDate, LocalDate endDate);
  //====== Confirm & Cancel & Complete =======

    Optional<Appointment> findById(Long id);

    int updateStatus(Long id, String newStatus);

    int complete(Long id);

    
    int cancel(Long id, Long canceledBy, String reason, LocalDateTime canceledAt);

    List<Object[]> countAppointmentsByService();

    Long countAllBookings();
}

