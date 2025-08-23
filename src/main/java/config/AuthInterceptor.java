package config;

import javax.servlet.http.*;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {
  @Override
  public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler)
      throws Exception {
    String ctx = req.getContextPath();
    String uri = req.getRequestURI();

    // Cho phép truy cập các trang công khai
    if (uri.startsWith(ctx + "/login") ||
        uri.startsWith(ctx + "/register") ||
        uri.startsWith(ctx + "/logout") ||
        uri.startsWith(ctx + "/resources/")) {
      return true;
    }
    
    HttpSession session = req.getSession(false);
    String role = session == null ? null : (String) session.getAttribute("role");
    // chặn admin area
    if (uri.startsWith(ctx + "/admin")) {
      if (!"ADMIN".equals(role)) {
        res.sendRedirect(ctx + "/login");
        return false;
      }
    }
   
    if (session != null && session.getAttribute("userId") != null) return true;
    res.sendRedirect(ctx + "/login");
    return false;
  }
}
