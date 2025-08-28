package controller;

import entity.Appointment;
import service.AppointmentService;
import service.UserService;
import service.ReviewService;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.time.*;
import java.util.*;

@Controller
@RequestMapping("/customer/appointments")
public class CustomerAppointmentController {

    private final AppointmentService appointmentService;
    private final UserService userService;

    @Autowired
    private SessionFactory sessionFactory;

    @Autowired
    private ReviewService reviewService;

    public CustomerAppointmentController(AppointmentService appointmentService,
                                         UserService userService) {
        this.appointmentService = appointmentService;
        this.userService = userService;
    }

    /* ------------------------ Helpers ------------------------ */

    private Long currentUserId(HttpSession session) {
        return (Long) session.getAttribute("userId");
    }

    /** Đọc 1 appointment (dùng openSession, không cần transaction) */
    private Appointment loadAppointment(Long appointmentId) {
        try (Session s = sessionFactory.openSession()) {
            return s.createQuery(
                    "from Appointment a " +
                    "join fetch a.user u " +
                    "join fetch a.service s " +
                    "join fetch a.employee e " +
                    "left join fetch a.review r " +
                    "where a.appointmentId = :id",
                    Appointment.class
            ).setParameter("id", appointmentId).uniqueResult();
        }
    }

    /** Convert LocalDate/LocalTime/LocalDateTime -> java.util.Date cho fmt:formatDate */
    private Date toUtilDate(Object value) {
        if (value == null) return null;
        if (value instanceof java.util.Date) return (java.util.Date) value;
        if (value instanceof LocalDateTime)
            return Date.from(((LocalDateTime) value).atZone(ZoneId.systemDefault()).toInstant());
        if (value instanceof LocalDate)
            return Date.from(((LocalDate) value).atStartOfDay(ZoneId.systemDefault()).toInstant());
        if (value instanceof LocalTime) {
            LocalDate today = LocalDate.now();
            return Date.from(((LocalTime) value).atDate(today).atZone(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }

    /* ------------------------ Endpoints ------------------------ */

    /** Xem danh sách lịch hẹn (đọc bằng openSession) */
    @GetMapping
    public String listAppointments(HttpSession session, Model model, RedirectAttributes ra) {
        Long userId = currentUserId(session);
        if (userId == null) {
            ra.addFlashAttribute("err", "Vui lòng đăng nhập để xem lịch hẹn.");
            return "redirect:/login";
        }

        List<Appointment> appointments;
        try (Session s = sessionFactory.openSession()) {
            appointments = s.createQuery(
                    "from Appointment a " +
                    "join fetch a.user u " +
                    "join fetch a.service s " +
                    "join fetch a.employee e " +
                    "where u.userId = :uid " +
                    "order by a.appointmentDate desc, a.startTime desc",
                    Appointment.class
            ).setParameter("uid", userId).getResultList();
        }

        Map<Long, Date> appointmentDates = new HashMap<>();
        Map<Long, Date> startTimes = new HashMap<>();
        Map<Long, Date> endTimes = new HashMap<>();
        for (Appointment a : appointments) {
            appointmentDates.put(a.getAppointmentId(), toUtilDate(a.getAppointmentDate()));
            startTimes.put(a.getAppointmentId(), toUtilDate(a.getStartTime()));
            endTimes.put(a.getAppointmentId(), toUtilDate(a.getEndTime()));
        }

        model.addAttribute("appointments", appointments);
        model.addAttribute("appointmentDates", appointmentDates);
        model.addAttribute("startTimes", startTimes);
        model.addAttribute("endTimes", endTimes);
        return "customer/appointments";
    }

    /** Xem chi tiết lịch hẹn (đọc bằng openSession) */
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

        model.addAttribute("appointment", appointment);
        model.addAttribute("appointmentDateFmt", toUtilDate(appointment.getAppointmentDate()));
        model.addAttribute("startTimeFmt", toUtilDate(appointment.getStartTime()));
        model.addAttribute("endTimeFmt", toUtilDate(appointment.getEndTime()));
        model.addAttribute("createdAtFmt", toUtilDate(appointment.getCreatedAt()));
        model.addAttribute("canceledAtFmt", toUtilDate(appointment.getCanceledAt()));
        if (appointment.getReview() != null) {
            model.addAttribute("reviewCreatedAtFmt", toUtilDate(appointment.getReview().getCreatedAt()));
        }

        return "customer/appointment-detail";
    }

    /** Hủy lịch hẹn — Controller chỉ kiểm tra quyền, gọi Service để ghi DB */
    @PostMapping("/{appointmentId}/cancel")
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
        if (appointment == null || !appointment.getUser().getUserId().equals(userId)) {
            ra.addFlashAttribute("err", "Không tìm thấy hoặc không có quyền hủy lịch hẹn này.");
            return "redirect:/customer/appointments";
        }

        try {
            boolean ok = appointmentService.cancel(appointmentId, cancelReason, userId);
            if (ok) ra.addFlashAttribute("msg", "Hủy lịch hẹn thành công.");
            else    ra.addFlashAttribute("err", "Không thể hủy lịch hẹn này.");
        } catch (Exception e) {
            ra.addFlashAttribute("err", e.getMessage());
        }
        return "redirect:/customer/appointments";
    }

    /** Hiển thị form đánh giá (đọc bằng openSession) */
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

    /** Gửi đánh giá — Controller kiểm tra, Service ghi DB (có @Transactional) */
    @PostMapping("/{appointmentId}/review")
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
        if (appointment == null || !appointment.getUser().getUserId().equals(userId)) {
            ra.addFlashAttribute("err", "Không tìm thấy hoặc không có quyền.");
            return "redirect:/customer/appointments";
        }
        if (!"COMPLETED".equals(appointment.getStatus())) {
            ra.addFlashAttribute("err", "Chỉ có thể đánh giá lịch hẹn đã hoàn thành.");
            return "redirect:/customer/appointments";
        }
        if (appointment.getReview() != null) {
            ra.addFlashAttribute("err", "Bạn đã đánh giá lịch hẹn này rồi.");
            return "redirect:/customer/appointments";
        }
        if (rating == null || rating < 1 || rating > 5) {
            ra.addFlashAttribute("err", "Đánh giá phải từ 1-5 sao.");
            return "redirect:/customer/appointments/" + appointmentId + "/review";
        }

        // Ghi DB trong Service (có @Transactional)
        reviewService.addReview(appointment, rating, comment);

        ra.addFlashAttribute("msg", "Đánh giá thành công. Cảm ơn bạn!");
        return "redirect:/customer/appointments";
    }
}
