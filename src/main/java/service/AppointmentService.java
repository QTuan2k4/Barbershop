package service;
import entity.Appointment;
import entity.AppointmentStatus;
import java.time.LocalDate;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

public interface AppointmentService {
  List<Appointment> search(String status, Long employeeId, LocalDate date);
  Appointment book(Long userId, Long serviceId, Long employeeId, Date date, Time startTime);
  
  // Chức năng mới: xem lịch đã đặt và hủy lịch
  List<Appointment> getUserAppointments(Long userId);
  Appointment cancelAppointment(Long appointmentId, Long userId, String reason);
  Appointment completeAppointment(Long appointmentId);
}
