package controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(HttpSession session, Model model) {
        // Lấy thông tin từ session
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        model.addAttribute("username", username);
        model.addAttribute("role", role);

        return "home"; 
    }
    
    // ✅ Trang hiển thị cửa hàng
    @GetMapping("/store")
    public String store(Model model) {
        model.addAttribute("storeName", "Tuna Barbershop");
        model.addAttribute("storeAddress", "138 Cần Vương, Nguyễn Văn Cừ, TP.Quy Nhơn");
        model.addAttribute("storePhone", "09999999");
        return "store/detail";  
    }
}
