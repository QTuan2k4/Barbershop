//package controller;
//
//import entity.Service;
//import service.ServiceService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.servlet.mvc.support.RedirectAttributes;
//
//import java.util.stream.Collectors;
//
//@Controller
//@RequestMapping("/admin/services")
//public class ServiceController {
//
//    private final ServiceService serviceService;
//
//    @Autowired
//    public ServiceController(ServiceService serviceService) {
//        this.serviceService = serviceService;
//    }
//
////    @GetMapping
////    public String listServices(Model model) {
////        model.addAttribute("services", serviceService.getAllServices());
////        return "service/list"; // Trả về trang list.jsp
////    }
//
//    @GetMapping
//    public String listServices(Model model) {
//        java.util.List<Service> allServices = serviceService.getAllServices();
//
//        // Phân loại dịch vụ dựa trên trường category từ CSDL
//        java.util.List<Service> basicServices = allServices.stream()
//                .filter(s -> "Dịch vụ cơ bản".equals(s.getCategory()))
//                .collect(Collectors.toList());
//
//        java.util.List<Service> advancedServices = allServices.stream()
//                .filter(s -> "Dịch vụ chuyên sâu".equals(s.getCategory()))
//                .collect(Collectors.toList());
//
//        java.util.List<Service> careServices = allServices.stream()
//                .filter(s -> "Dịch vụ chăm sóc và thư giãn".equals(s.getCategory()))
//                .collect(Collectors.toList());
//
//        model.addAttribute("basicServices", basicServices);
//        model.addAttribute("advancedServices", advancedServices);
//        model.addAttribute("careServices", careServices);
//        model.addAttribute("services", allServices); // Giữ lại nếu cần hiển thị tất cả
//
//        return "service/list";
//    }
//
//    @GetMapping("/add")
//    public String showAddForm(Model model) {
//        model.addAttribute("service", new Service());
//        return "service/add"; // Trả về trang add.jsp
//    }
//
//    @PostMapping("/add")
//    public String addService(@ModelAttribute("service") Service service, RedirectAttributes redirectAttributes) {
//        serviceService.saveService(service);
//        redirectAttributes.addFlashAttribute("message", "Thêm dịch vụ thành công!");
//        return "redirect:/admin/services";
//    }
//
//    @GetMapping("/edit/{id}")
//    public String showEditForm(@PathVariable("id") Long id, Model model) {
//        Service service = serviceService.getServiceById(id);
//        if (service == null) {
//            return "redirect:/admin/services";
//        }
//        model.addAttribute("service", service);
//        return "service/edit"; // Trả về trang edit.jsp
//    }
//
//    @PostMapping("/edit")
//    public String editService(@ModelAttribute("service") Service service, RedirectAttributes redirectAttributes) {
//        serviceService.saveService(service);
//        redirectAttributes.addFlashAttribute("message", "Cập nhật dịch vụ thành công!");
//        return "redirect:/admin/services";
//    }
//
//    @GetMapping("/delete/{id}")
//    public String deleteService(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
//        serviceService.deleteService(id);
//        redirectAttributes.addFlashAttribute("message", "Xóa dịch vụ thành công!");
//        return "redirect:/admin/services";
//    }
//}

package controller;

import entity.Service;
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
        java.util.List<Service> allServices = serviceService.getAllServices();

        // Phân loại dịch vụ dựa trên trường category từ CSDL
        java.util.List<Service> basicServices = allServices.stream()
                .filter(s -> "Dịch vụ cơ bản".equals(s.getCategory()))
                .collect(Collectors.toList());

        java.util.List<Service> advancedServices = allServices.stream()
                .filter(s -> "Dịch vụ chuyên sâu".equals(s.getCategory()))
                .collect(Collectors.toList());

        java.util.List<Service> careServices = allServices.stream()
                .filter(s -> "Dịch vụ chăm sóc và thư giãn".equals(s.getCategory()))
                .collect(Collectors.toList());

        model.addAttribute("basicServices", basicServices);
        model.addAttribute("advancedServices", advancedServices);
        model.addAttribute("careServices", careServices);
        model.addAttribute("services", allServices);

        return "service/list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("service", new Service());
        return "service/add";
    }

    @PostMapping("/add")
    public String addService(@ModelAttribute("service") Service service, RedirectAttributes redirectAttributes) {
        serviceService.saveService(service);
        redirectAttributes.addFlashAttribute("message", "Thêm dịch vụ thành công!");
        return "redirect:/admin/services";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model) {
        Service service = serviceService.getServiceById(id);
        if (service == null) {
            return "redirect:/admin/services";
        }
        model.addAttribute("service", service);
        return "service/edit";
    }

    @PostMapping("/edit")
    public String editService(@ModelAttribute("service") Service service, RedirectAttributes redirectAttributes) {
        serviceService.saveService(service);
        redirectAttributes.addFlashAttribute("message", "Cập nhật dịch vụ thành công!");
        return "redirect:/admin/services";
    }

    @GetMapping("/delete/{id}")
    public String deleteService(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        serviceService.deleteService(id);
        redirectAttributes.addFlashAttribute("message", "Xóa dịch vụ thành công!");
        return "redirect:/admin/services";
    }
}