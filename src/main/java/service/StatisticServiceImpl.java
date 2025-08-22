package service;

import dao.AppointmentDao;
import entity.Appointment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@org.springframework.stereotype.Service
@Transactional
public class StatisticServiceImpl implements StatisticService {

    private final AppointmentDao appointmentDao;

    @Autowired
    public StatisticServiceImpl(AppointmentDao appointmentDao) {
        this.appointmentDao = appointmentDao;
    }

    @Override
    public Long getTotalBookings() {
        return appointmentDao.countAllBookings();
    }

    @Override
    public List<Appointment> getBookingsByDateRange(LocalDate startDate, LocalDate endDate) {
        return appointmentDao.findByDateRange(startDate, endDate);
    }

    @Override
    public Map<String, Long> getBookingCountByService() {
        List<Object[]> results = appointmentDao.countAppointmentsByService();
        Map<String, Long> bookingCounts = new HashMap<>();
        for (Object[] result : results) {
            String serviceName = (String) result[0];
            Long count = (Long) result[1];
            bookingCounts.put(serviceName, count);
        }
        return bookingCounts;
    }
}
