package service;

import entity.Appointment;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface AppointmentService {
    Appointment book(Long userId, Long serviceId, Long employeeId, LocalDate date, LocalTime startTime);
    List<Appointment> search(String status, Long employeeId, LocalDate date);
}
