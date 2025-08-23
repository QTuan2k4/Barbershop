package controller;

import entity.User;
import service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

  private final UserService userService;
  public AuthController(UserService userService) { this.userService = userService; }

  // ===== Login =====
  @GetMapping("/login")
  public String loginForm() { return "login"; }

  @PostMapping("/login")
  public String doLogin(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {
    User u = userService.login(username, password);
    if (u == null) {
      model.addAttribute("error", "Sai username hoặc mật khẩu!");
      return "login";
    }
    session.setAttribute("userId", u.getUserId());
    session.setAttribute("username", u.getUsername());
    session.setAttribute("role", u.getRole());
    if ("ADMIN".equals(u.getRole())) return "redirect:/admin";
    return "redirect:/"; // hoặc /users
  }

  // ===== Register =====
  @GetMapping("/register")
  public String registerForm(Model model) {
    return "register";
  }

  @PostMapping("/register")
  public String doRegister(@RequestParam String username,
                           @RequestParam String password,
                           @RequestParam String fullName,
                           @RequestParam String phone,
                           @RequestParam String email,
                           Model model) {
    try {
      userService.register(username, password, fullName, phone, email);
      model.addAttribute("msg", "Đăng ký thành công! Mời đăng nhập.");
      return "login";
    } catch (IllegalArgumentException | IllegalStateException ex) {
      model.addAttribute("error", ex.getMessage());
      return "register";
    }
  }

  // ===== Logout =====
  @GetMapping("/logout")
  public String logout(HttpSession session) {
    session.invalidate();
    return "redirect:/login";
  }
}
