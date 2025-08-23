package controller;

import entity.User;
import service.UserService;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/account")
public class AccountController {

    private final UserService userService;
    public AccountController(UserService userService) { this.userService = userService; }

    // regex đơn giản; có thể thay đổi theo nhu cầu thực tế
    private static final Pattern EMAIL_RE = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_RE = Pattern.compile("^[0-9]{9,11}$");

    // Trang quản lý tài khoản (hiển thị form cập nhật + form đổi mật khẩu)
    @GetMapping
    public String page(HttpSession session, Model model, RedirectAttributes ra) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            ra.addFlashAttribute("err", "Vui lòng đăng nhập để quản lý tài khoản.");
            return "redirect:/login";
        }
        User u = userService.getById(userId);
        model.addAttribute("user", u);
        return "account";
    }

    // Cập nhật thông tin
    @PostMapping("/profile")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam String phone,
                                @RequestParam String email,
                                HttpSession session, RedirectAttributes ra) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        // Trim
        fullName = fullName == null ? "" : fullName.trim();
        phone    = phone    == null ? "" : phone.trim();
        email    = email    == null ? "" : email.trim().toLowerCase();

        // Validate cơ bản
        if (fullName.isEmpty()) {
            ra.addFlashAttribute("err", "Họ tên không được để trống.");
            return "redirect:/account";
        }
        if (!email.isEmpty() && !EMAIL_RE.matcher(email).matches()) {
            ra.addFlashAttribute("err", "Email không hợp lệ.");
            return "redirect:/account";
        }
        if (!phone.isEmpty() && !PHONE_RE.matcher(phone).matches()) {
            ra.addFlashAttribute("err", "Số điện thoại chỉ gồm 9–11 chữ số.");
            return "redirect:/account";
        }

        try {
            userService.updateProfile(userId, fullName, phone, email);
            ra.addFlashAttribute("msg", "Cập nhật thông tin thành công.");
        } catch (DataIntegrityViolationException dup) {
            // trường hợp email unique key trùng
            ra.addFlashAttribute("err", "Email đã tồn tại. Vui lòng dùng email khác.");
        } catch (IllegalArgumentException iae) {
            ra.addFlashAttribute("err", iae.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("err", "Có lỗi xảy ra khi cập nhật thông tin.");
        }
        return "redirect:/account";
    }

    // Đổi mật khẩu
    @PostMapping("/password")
    public String changePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpSession session, RedirectAttributes ra) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        currentPassword = currentPassword == null ? "" : currentPassword.trim();
        newPassword     = newPassword == null ? "" : newPassword.trim();
        confirmPassword = confirmPassword == null ? "" : confirmPassword.trim();

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            ra.addFlashAttribute("err", "Vui lòng nhập đầy đủ mật khẩu hiện tại và mật khẩu mới.");
            return "redirect:/account";
        }
        if (newPassword.length() < 6) {
            ra.addFlashAttribute("err", "Mật khẩu mới phải từ 6 ký tự trở lên.");
            return "redirect:/account";
        }
        if (newPassword.equals(currentPassword)) {
            ra.addFlashAttribute("err", "Mật khẩu mới không được trùng mật khẩu hiện tại.");
            return "redirect:/account";
        }
        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("err", "Xác nhận mật khẩu mới không khớp.");
            return "redirect:/account";
        }

        try {
            userService.changePassword(userId, currentPassword, newPassword);
            ra.addFlashAttribute("msg", "Đổi mật khẩu thành công.");
        } catch (IllegalArgumentException iae) {
            // ví dụ: mật khẩu hiện tại sai, hoặc chính sách không đạt
            ra.addFlashAttribute("err", iae.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("err", "Có lỗi xảy ra khi đổi mật khẩu.");
        }
        return "redirect:/account";
    }
}
