package listener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import javax.servlet.*;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

public class MySQLCleanupListener implements ServletContextListener {

  @Override
  public void contextInitialized(ServletContextEvent sce) { /* no-op */ }

  @Override
  public void contextDestroyed(ServletContextEvent sce) {
      try {
          AbandonedConnectionCleanupThread.checkedShutdown();
      } catch (Exception ex) {
          ex.printStackTrace();
      }

    // 2) Gỡ đăng ký các JDBC Driver được load bởi classloader của webapp
    ClassLoader cl = Thread.currentThread().getContextClassLoader();
    Enumeration<Driver> drivers = DriverManager.getDrivers();
    while (drivers.hasMoreElements()) {
      Driver d = drivers.nextElement();
      if (d.getClass().getClassLoader() == cl) {
        try {
          DriverManager.deregisterDriver(d);
        } catch (SQLException ignored) {}
      }
    }
  }
}
