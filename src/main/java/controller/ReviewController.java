package controller;

import entity.Appointment;
import entity.AppointmentStatus;
import service.AppointmentService;
import service.ReviewService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/reviews")
public class ReviewController {

    private final ReviewService reviewService;
    private final AppointmentService appointmentService;

    @PersistenceContext
    private EntityManager em;

    public ReviewController(ReviewService reviewService, AppointmentService appointmentService) {
        this.reviewService = reviewService;
        this.appointmentService = appointmentService;
    }

    // Form đánh giá
    @GetMapping("/{appointmentId}/create")
    public String createReviewForm(@PathVariable Long appointmentId,
                                  HttpSession session,
                                  Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        // Kiểm tra xem có thể đánh giá không
        if (!reviewService.canReview(appointmentId, userId)) {
            return "redirect:/appointments/my-appointments";
        }

        // Lấy thông tin appointment
        List<Appointment> userAppointments = appointmentService.getUserAppointments(userId);
        Appointment appointment = userAppointments.stream()
                .filter(a -> a.getAppointmentId().equals(appointmentId))
                .findFirst()
                .orElse(null);

        if (appointment == null) {
            return "redirect:/appointments/my-appointments";
        }

        model.addAttribute("appointment", appointment);
        return "createReview";
    }

    // Tạo đánh giá
    @PostMapping("/{appointmentId}/create")
    public String createReview(@PathVariable Long appointmentId,
                              @RequestParam Integer rating,
                              @RequestParam String comment,
                              HttpSession session,
                              RedirectAttributes ra) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                ra.addFlashAttribute("err", "Bạn cần đăng nhập");
                return "redirect:/login";
            }

            // Kiểm tra xem có thể đánh giá không
            if (!reviewService.canReview(appointmentId, userId)) {
                ra.addFlashAttribute("err", "Không thể đánh giá lịch hẹn này");
                return "redirect:/appointments/my-appointments";
            }

            reviewService.createReview(appointmentId, rating, comment);
            ra.addFlashAttribute("msg", "Đánh giá đã được gửi thành công!");
            
        } catch (Exception ex) {
            ra.addFlashAttribute("err", ex.getMessage());
        }

        return "redirect:/appointments/my-appointments";
    }

    // Xem đánh giá của nhân viên
    @GetMapping("/employee/{employeeId}")
    public String viewEmployeeReviews(@PathVariable Long employeeId, Model model) {
        List<entity.Review> reviews = reviewService.getReviewsByEmployee(employeeId);
        model.addAttribute("reviews", reviews);
        
        // Lấy thông tin nhân viên
        entity.Employee employee = em.find(entity.Employee.class, employeeId);
        model.addAttribute("employee", employee);
        
        return "employeeReviews";
    }

    // Xem đánh giá của appointment
    @GetMapping("/appointment/{appointmentId}")
    public String viewAppointmentReview(@PathVariable Long appointmentId, Model model) {
        entity.Review review = reviewService.getReviewByAppointment(appointmentId);
        model.addAttribute("review", review);
        
        // Lấy thông tin appointment
        Appointment appointment = em.find(Appointment.class, appointmentId);
        model.addAttribute("appointment", appointment);
        
        return "appointmentReview";
    }
}