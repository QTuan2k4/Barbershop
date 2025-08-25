package dao;
import entity.Appointment;
import java.time.LocalDate;
import java.util.List;
import java.sql.Date;
import java.sql.Time;

public interface AppointmentDao {
  List<Appointment> findAllWithJoins(String status, Long employeeId, LocalDate date);
  void save(Appointment appt);
  List<Appointment> findByEmployeeAndDate(Long employeeId, Date date);
  boolean existsOverlap(Long employeeId, Date date, Time start, Time end);

//Chức năng mới
 Appointment findById(Long appointmentId);
 List<Appointment> findByUserId(Long userId);
 void update(Appointment appointment);
}

