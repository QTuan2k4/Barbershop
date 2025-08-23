package service;
import entity.Appointment;
import java.time.LocalDate;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

public interface AppointmentService {
  List<Appointment> search(String status, Long employeeId, LocalDate date);
  Appointment book(Long userId, Long serviceId, Long employeeId, Date date, Time startTime);
}
