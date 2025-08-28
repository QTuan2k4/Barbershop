package controller;

import entity.Appointment;
import entity.Review;
import service.AppointmentService;
import service.UserService;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.sql.Timestamp;

@Controller
@RequestMapping("/customer/appointments")
public class CustomerAppointmentController {

    private final AppointmentService appointmentService;
    private final UserService userService;

    @PersistenceContext
    private EntityManager em;

    public CustomerAppointmentController(AppointmentService appointmentService, UserService userService) {
        this.appointmentService = appointmentService;
        this.userService = userService;
    }

    /* ------------------------ Helpers ------------------------ */

    private Long currentUserId(HttpSession session) {
        return (Long) session.getAttribute("userId");
    }

    /** Load appointment cùng các quan hệ cần thiết; trả về null nếu không thấy. */
    private Appointment loadAppointment(Long appointmentId) {
        try {
            return em.createQuery(
                "from Appointment a " +
                "join fetch a.user u " +
                "join fetch a.service s " +
                "join fetch a.employee e " +
                "where a.appointmentId = :appointmentId",
                Appointment.class
            ).setParameter("appointmentId", appointmentId)
             .getSingleResult();
        } catch (NoResultException ex) {
            return null;
        }
    }

    /** Chuyển đổi nhiều kiểu ngày sang java.util.Date để JSP <fmt:formatDate> dùng an toàn. */
    private Date toUtilDate(Object value) {
        if (value == null) return null;
        if (value instanceof Date) return (Date) value; // đã là java.util.Date or java.sql.Date
        if (value instanceof Timestamp) return new Date(((Timestamp) value).getTime());
        if (value instanceof LocalDateTime)
            return Date.from(((LocalDateTime) value).atZone(ZoneId.systemDefault()).toInstant());
        if (value instanceof LocalDate)
            return Date.from(((LocalDate) value).atStartOfDay(ZoneId.systemDefault()).toInstant());
        return null; // không biết kiểu -> để JSP xử lý null
    }

    /* ------------------------ Endpoints ------------------------ */

    /** Xem danh sách lịch hẹn của khách hàng */
    @GetMapping
    public String listAppointments(HttpSession session, Model model, RedirectAttributes ra) {
        Long userId = currentUserId(session);
        if (userId == null) {
            ra.addFlashAttribute("err", "Vui lòng đăng nhập để xem lịch hẹn.");
            return "redirect:/login";
        }

        List<Appointment> appointments = em.createQuery(
            "from Appointment a " +
            "join fetch a.user u " +
            "join fetch a.service s " +
            "join fetch a.employee e " +
            "where u.userId = :userId " +
            "order by a.appointmentDate desc, a.startTime desc",
            Appointment.class
        ).setParameter("userId", userId)
         .getResultList();

        // Map hỗ trợ format ngày trong JSP nếu entity không dùng java.util.Date
        Map<Long, Date> appointmentDates = new HashMap<>();
        for (Appointment a : appointments) {
            try {
                Object raw = a.getAppointmentDate(); // giả định có getter này
                appointmentDates.put(a.getAppointmentId(), toUtilDate(raw));
            } catch (Exception ignore) {
                appointmentDates.put(a.getAppointmentId(), null);
            }
        }

        model.addAttribute("appointments", appointments);
        model.addAttribute("appointmentDates", appointmentDates);
        return "customer/appointments";
    }

    /** Hủy lịch hẹn */
    @PostMapping("/{appointmentId}/cancel")
    @Transactional
    public String cancelAppointment(@PathVariable Long appointmentId,
                                    @RequestParam String cancelReason,
                                    HttpSession session,
                                    RedirectAttributes ra) {
        Long userId = currentUserId(session);
        if (userId == null) {
            ra.addFlashAttribute("err", "Vui lòng đăng nhập.");
            return "redirect:/login";
        }

        Appointment appointment = loadAppointment(appointmentId);
        if (appointment == null) {
            ra.addFlashAttribute("err", "Không tìm thấy lịch hẹn.");
            return "redirect:/customer/appointments";
        }

        if (!appointment.getUser().getUserId().equals(userId)) {
            ra.addFlashAttribute("err", "Bạn không có quyền hủy lịch hẹn này.");
            return "redirect:/customer/appointments";
        }

        if (!"BOOKED".equals(appointment.getStatus())) {
            ra.addFlashAttribute("err", "Chỉ có thể hủy lịch hẹn đã đặt.");
            return "redirect:/customer/appointments";
        }

        appointment.setStatus("CANCELLED");
        appointment.setCancelReason(cancelReason);
        appointment.setCanceledBy(userId);
        appointment.setCanceledAt(LocalDateTime.now());
        em.merge(appointment);

        ra.addFlashAttribute("msg", "Hủy lịch hẹn thành công.");
        return "redirect:/customer/appointments";
    }

    /** Hiển thị form đánh giá */
    @GetMapping("/{appointmentId}/review")
    public String showReviewForm(@PathVariable Long appointmentId,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes ra) {
        Long userId = currentUserId(session);
        if (userId == null) {
            ra.addFlashAttribute("err", "Vui lòng đăng nhập.");
            return "redirect:/login";
        }

        Appointment appointment = loadAppointment(appointmentId);
        if (appointment == null) {
            ra.addFlashAttribute("err", "Không tìm thấy lịch hẹn.");
            return "redirect:/customer/appointments";
        }

        if (!appointment.getUser().getUserId().equals(userId)) {
            ra.addFlashAttribute("err", "Bạn không có quyền đánh giá lịch hẹn này.");
            return "redirect:/customer/appointments";
        }

        if (!"COMPLETED".equals(appointment.getStatus())) {
            ra.addFlashAttribute("err", "Chỉ có thể đánh giá lịch hẹn đã hoàn thành.");
            return "redirect:/customer/appointments";
        }

        if (appointment.getReview() != null) {
            ra.addFlashAttribute("err", "Lịch hẹn này đã được đánh giá.");
            return "redirect:/customer/appointments";
        }

        model.addAttribute("appointment", appointment);
        return "customer/review";
    }

    /** Gửi đánh giá */
    @PostMapping("/{appointmentId}/review")
    @Transactional
    public String submitReview(@PathVariable Long appointmentId,
                               @RequestParam Integer rating,
                               @RequestParam String comment,
                               HttpSession session,
                               RedirectAttributes ra) {
        Long userId = currentUserId(session);
        if (userId == null) {
            ra.addFlashAttribute("err", "Vui lòng đăng nhập.");
            return "redirect:/login";
        }

        Appointment appointment = loadAppointment(appointmentId);
        if (appointment == null) {
            ra.addFlashAttribute("err", "Không tìm thấy lịch hẹn.");
            return "redirect:/customer/appointments";
        }

        if (!appointment.getUser().getUserId().equals(userId)) {
            ra.addFlashAttribute("err", "Bạn không có quyền đánh giá lịch hẹn này.");
            return "redirect:/customer/appointments";
        }

        if (!"COMPLETED".equals(appointment.getStatus())) {
            ra.addFlashAttribute("err", "Chỉ có thể đánh giá lịch hẹn đã hoàn thành.");
            return "redirect:/customer/appointments";
        }

        if (rating == null || rating < 1 || rating > 5) {
            ra.addFlashAttribute("err", "Đánh giá phải từ 1-5 sao.");
            return "redirect:/customer/appointments/" + appointmentId + "/review";
        }

        Review review = new Review();
        review.setAppointment(appointment);
        review.setRating(rating);
        review.setComment(comment);

        em.persist(review);
        // nếu quan hệ là bidirectional và Appointment có setReview(...)
        try { appointment.setReview(review); em.merge(appointment); } catch (Exception ignore) {}

        ra.addFlashAttribute("msg", "Đánh giá thành công. Cảm ơn bạn!");
        return "redirect:/customer/appointments";
    }

    /** Xem chi tiết lịch hẹn */
    @GetMapping("/{appointmentId}")
    public String viewAppointment(@PathVariable Long appointmentId,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes ra) {
        Long userId = currentUserId(session);
        if (userId == null) {
            ra.addFlashAttribute("err", "Vui lòng đăng nhập.");
            return "redirect:/login";
        }

        Appointment appointment = loadAppointment(appointmentId);
        if (appointment == null) {
            ra.addFlashAttribute("err", "Không tìm thấy lịch hẹn.");
            return "redirect:/customer/appointments";
        }

        if (!appointment.getUser().getUserId().equals(userId)) {
            ra.addFlashAttribute("err", "Bạn không có quyền xem lịch hẹn này.");
            return "redirect:/customer/appointments";
        }

        // Chuẩn bị util.Date cho JSP nếu cần
        model.addAttribute("appointment", appointment);
        model.addAttribute("appointmentDate", toUtilDate(appointment.getAppointmentDate()));
        return "customer/appointment-detail";
    }
}

