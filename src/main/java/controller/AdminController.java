package controller;

import entity.Employee;
import entity.Appointment;
import service.AppointmentService;
import service.EmployeeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

  private final EmployeeService employeeService;
  private final AppointmentService appointmentService;

  public AdminController(EmployeeService employeeService, AppointmentService appointmentService) {
    this.employeeService = employeeService;
    this.appointmentService = appointmentService;
  }

  // ===== Dashboard (tuỳ chọn) =====
  @GetMapping
  public String adminHome() { return "admin/index"; }

  // ===== Quản lý nhân viên =====
  @GetMapping("/employees")
  public String employees(Model model) {
    model.addAttribute("employees", employeeService.list());
    return "admin/employee/list";
  }

  @GetMapping("/employees/create")
  public String createEmployeeForm(Model model) {
    model.addAttribute("emp", new Employee());
    return "admin/employee/form";
  }

  @GetMapping("/employees/edit/{id}")
  public String editEmployeeForm(@PathVariable Long id, Model model) {
    model.addAttribute("emp", employeeService.get(id));
    return "admin/employee/form";
  }

  @PostMapping("/employees/save")
  public String saveEmployee(@RequestParam(required=false) Long employeeId,
                             @RequestParam String name,
                             @RequestParam String phone,
                             @RequestParam String email,
                             @RequestParam String workStartTime, // HH:mm
                             @RequestParam String workEndTime,   // HH:mm
                             Model model) {
    try {
      Employee e = employeeId == null ? new Employee() : employeeService.get(employeeId);
      e.setEmployeeId(employeeId);
      e.setName(name);
      e.setPhone(phone);
      e.setEmail(email);
      e.setWorkStartTime(LocalTime.parse(workStartTime));
      e.setWorkEndTime(LocalTime.parse(workEndTime));
      employeeService.createOrUpdate(e);
      return "redirect:/admin/employees";
    } catch (Exception ex) {
      model.addAttribute("emp", new Employee());
      model.addAttribute("error", ex.getMessage());
      return "admin/employee/form";
    }
  }

  @GetMapping("/employees/delete/{id}")
  public String deleteEmployee(@PathVariable Long id) {
    employeeService.delete(id);
    return "redirect:/admin/employees";
  }

  // ===== Quản lý lịch hẹn (danh sách + lọc) =====
  @GetMapping("/appointments")
  public String appointments(@RequestParam(required=false) String status,
                             @RequestParam(required=false) Long employeeId,
                             @RequestParam(required=false) String date, // yyyy-MM-dd
                             Model model) {
    LocalDate d = (date == null || date.isBlank()) ? null : LocalDate.parse(date);
    List<Appointment> list = appointmentService.search(status, employeeId, d);

    model.addAttribute("appointments", list);
    model.addAttribute("employees", employeeService.list()); // cho dropdown lọc
    model.addAttribute("status", status);
    model.addAttribute("employeeId", employeeId);
    model.addAttribute("date", date);
    return "admin/appointment/list";
  }
}