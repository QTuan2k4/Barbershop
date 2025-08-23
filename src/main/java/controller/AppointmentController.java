package controller;

import entity.Appointment;
import entity.Employee;
import entity.ServiceEntity;
import service.AppointmentService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpSession;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/appointments")
public class AppointmentController {

    private final AppointmentService appointmentService;

    @PersistenceContext
    private EntityManager em;

    public AppointmentController(AppointmentService appointmentService) {
        this.appointmentService = appointmentService;
    }
    
    /** Helper: nạp danh sách dịch vụ & nhân viên cho form */
    private void loadLists(Model model) {
        model.addAttribute("services",
            em.createQuery("from ServiceEntity", ServiceEntity.class).getResultList());
        model.addAttribute("employees",
            em.createQuery("from Employee", Employee.class).getResultList());
    }

    /** Trang đặt lịch + hiển thị giờ đã đặt theo NGÀY (toàn shop) */
    @GetMapping("/new")
    public String form(@RequestParam(value = "date", required = false) String dateStr, Model model) {
        // 1) Load list cho form
        loadLists(model);

        // 2) Ngày cần xem giờ đã đặt -> LocalDate
        LocalDate ld = (dateStr == null || dateStr.isBlank())
                ? LocalDate.now()
                : LocalDate.parse(dateStr);
        model.addAttribute("selectedDate", ld.toString());

        // 3) Lấy các khoảng giờ đã đặt (BOOKED/COMPLETED) trong ngày (toàn shop)
        //    LƯU Ý: setParameter bằng LocalDate để khớp với entity dùng LocalDate
        List<Appointment> booked = em.createQuery(
                "from Appointment a " +
                "where a.appointmentDate = :d " +
                "and a.status in ('BOOKED','COMPLETED') " +
                "order by a.startTime", Appointment.class)
            .setParameter("d", ld)
            .getResultList();

        model.addAttribute("booked", booked);
        return "bookAppointment";
    }

    @PostMapping
    public String create(@RequestParam("serviceIds") List<Long> serviceIds,  // nhận nhiều dịch vụ
                         @RequestParam("employeeId") Long employeeId,
                         @RequestParam("date") String dateStr,               // yyyy-MM-dd
                         @RequestParam("startTime") String timeStr,          // HH:mm hoặc HH:mm:ss
                         HttpSession session, RedirectAttributes ra, Model model) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                ra.addFlashAttribute("err", "Bạn cần đăng nhập");
                return "redirect:/login";
            }

            if (serviceIds == null || serviceIds.isEmpty()) {
                model.addAttribute("err", "Vui lòng chọn ít nhất 1 dịch vụ");
                loadLists(model);
                return "bookAppointment";
            }

            // Controller vẫn dùng sql.Date/Time để gọi xuống service (service sẽ tự convert sang LocalDate/LocalTime)
            Date date = Date.valueOf(dateStr);
            Time currentStart = Time.valueOf(timeStr.length() == 5 ? timeStr + ":00" : timeStr);

            // Đặt lần lượt: dịch vụ sau bắt đầu ngay khi dịch vụ trước kết thúc
            for (Long serviceId : serviceIds) {
                appointmentService.book(userId, serviceId, employeeId, date, currentStart);

                // Tăng 30 phút cho slot kế tiếp (khớp với logic trong service)
                LocalTime next = currentStart.toLocalTime().plusMinutes(30);
                currentStart = Time.valueOf(next);
            }

            ra.addFlashAttribute("msg", "Đặt lịch thành công " + serviceIds.size() + " dịch vụ liên tiếp!");
            return "redirect:/appointments/success";
        } catch (Exception ex) {
            model.addAttribute("err", ex.getMessage());
            loadLists(model);
            return "bookAppointment";
        }
    }

    @GetMapping("/success")
    public String success() {
        return "appointmentSuccess";
    }
}
