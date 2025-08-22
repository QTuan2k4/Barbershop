package dao;

import entity.Appointment;
import java.time.LocalDate;
import java.util.List;

public interface AppointmentDao {
    List<Appointment> findByDateRange(LocalDate startDate, LocalDate endDate);
    List<Object[]> countAppointmentsByService();
    Long countAllBookings();
}
