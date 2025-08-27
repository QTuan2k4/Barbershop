package service;

import entity.Appointment;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface StatisticService {
    Long getTotalBookings();
    List<Appointment> getBookingsByDateRange(LocalDate startDate, LocalDate endDate);
    Map<String, Long> getBookingCountByService();
}
