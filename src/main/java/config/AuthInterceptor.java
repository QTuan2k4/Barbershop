package config;

import javax.servlet.http.*;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

  @Override
  public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler)
      throws Exception {

    String ctx  = req.getContextPath();
    String uri  = req.getRequestURI();
    String mtd  = req.getMethod(); // GET/POST
    HttpSession session = req.getSession(false);
    String role = (session == null) ? null : (String) session.getAttribute("role");
    boolean loggedIn = (session != null && session.getAttribute("userId") != null);

    // 1) Luôn cho qua các trang công khai / static / auth
    if (uri.startsWith(ctx + "/login")
        || uri.startsWith(ctx + "/register")
        || uri.startsWith(ctx + "/logout")
        || uri.startsWith(ctx + "/resources/")) {
      return true;
    }

    // 2) Khu vực admin: bắt buộc ADMIN
    if (uri.startsWith(ctx + "/admin")) {
      if (!"ADMIN".equals(role)) {
        res.sendRedirect(ctx + "/login");
        return false;
      }
      return true;
    }

    // 3) Chỉ yêu cầu đăng nhập ở các hành động cần thiết
    //    (điều chỉnh đúng route thực tế của bạn)
    boolean needLogin =
        // submit đặt lịch (POST)
        (uri.equals(ctx + "/appointments/book") && "POST".equalsIgnoreCase(mtd))
        // trang "lịch của tôi" hoặc API cá nhân
        || uri.startsWith(ctx + "/me/")
        || uri.startsWith(ctx + "/account/")
        // nếu bạn có endpoint khác cần login, thêm vào đây:
        // || uri.startsWith(ctx + "/appointments/cancel") ...
        ;

    if (needLogin && !loggedIn) {
      res.sendRedirect(ctx + "/login");
      return false;
    }

    // 4) Mặc định: web công khai → cho qua
    return true;
  }
}
