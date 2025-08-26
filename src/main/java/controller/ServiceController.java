package controller;

import entity.ServiceEntity;
import service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/services")
public class ServiceController {

    private final ServiceService serviceService;

    @Autowired
    public ServiceController(ServiceService serviceService) {
        this.serviceService = serviceService;
    }



    @GetMapping
    public String listServices(Model model) {
        java.util.List<ServiceEntity> allServices = serviceService.getAllServices();

        // Phân loại dịch vụ dựa trên trường category từ CSDL
        java.util.List<ServiceEntity> basicServices = allServices.stream()
                .filter(s -> "Dịch vụ cơ bản".equals(s.getCategory()))
                .collect(Collectors.toList());

        java.util.List<ServiceEntity> advancedServices = allServices.stream()
                .filter(s -> "Dịch vụ chuyên sâu".equals(s.getCategory()))
                .collect(Collectors.toList());

        java.util.List<ServiceEntity> careServices = allServices.stream()
                .filter(s -> "Dịch vụ chăm sóc và thư giãn".equals(s.getCategory()))
                .collect(Collectors.toList());

        model.addAttribute("basicServices", basicServices);
        model.addAttribute("advancedServices", advancedServices);
        model.addAttribute("careServices", careServices);
        model.addAttribute("services", allServices); // Giữ lại nếu cần hiển thị tất cả

        return "admin/service/list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("service", new ServiceEntity());
        return "admin/service/add"; // Trả về trang add.jsp
    }

    @PostMapping("/add")
    public String addService(@ModelAttribute("service") ServiceEntity service, RedirectAttributes redirectAttributes) {
        serviceService.saveService(service);
        redirectAttributes.addFlashAttribute("message", "Thêm dịch vụ thành công!");
        return "redirect:/admin/services";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model) {
        ServiceEntity service = serviceService.getServiceById(id);
        if (service == null) {
            return "redirect:/admin/services";
        }
        model.addAttribute("service", service);
        return "admin/service/edit"; // Trả về trang edit.jsp
    }

    @PostMapping("/edit")
    public String editService(@ModelAttribute("service") ServiceEntity service, RedirectAttributes redirectAttributes) {
        serviceService.saveService(service);
        redirectAttributes.addFlashAttribute("message", "Cập nhật dịch vụ thành công!");
        return "redirect:/admin/services";
    }

    @GetMapping("/delete/{id}")
    public String deleteService(@PathVariable("id") Long id,
                                RedirectAttributes redirectAttributes) {
        try {
            serviceService.deleteService(id);
            redirectAttributes.addFlashAttribute("message", "Xóa dịch vụ thành công!");
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            redirectAttributes.addFlashAttribute("error",
                "❌ Ko thể xóa dịch vụ này vì đang có lịch hẹn của dịch vụ này rồi!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                "❌ Đã xảy ra lỗi khi xóa dịch vụ!");
        }
        return "redirect:/admin/services";
    }
}
