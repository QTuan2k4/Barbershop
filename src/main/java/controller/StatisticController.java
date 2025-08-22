package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import service.StatisticService;

import java.util.Map;

@Controller
@RequestMapping("/admin/statistics")
public class StatisticController {

    private final StatisticService statisticService;

    @Autowired
    public StatisticController(StatisticService statisticService) {
        this.statisticService = statisticService;
    }

    @GetMapping
    public String showStatistics(Model model) {
        // Thống kê tổng số lượt đặt
        Long totalBookings = statisticService.getTotalBookings();
        model.addAttribute("totalBookings", totalBookings);

        // Thống kê số lượt đặt theo dịch vụ
        Map<String, Long> bookingCountByService = statisticService.getBookingCountByService();
        model.addAttribute("bookingCountByService", bookingCountByService);

        // Các thống kê khác (có thể mở rộng)
        // Ví dụ: thống kê theo ngày, tháng,...

        return "statistics/dashboard"; // Trả về trang dashboard.jsp
    }
}
