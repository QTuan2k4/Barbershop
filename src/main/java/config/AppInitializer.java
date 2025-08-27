package config;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;
import javax.servlet.Filter;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
public class AppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        // Hibernate/DataSource/Transaction ở Root Context
        return new Class<?>[]{HibernateConfig.class, MailConfig.class};
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        // Spring MVC (ViewResolver, resource handling) ở Servlet Context
        return new Class<?>[]{WebMvcConfig.class};
    }
    
    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        super.onStartup(servletContext);
        servletContext.addListener(listener.MySQLCleanupListener.class);
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }
    
        // Thêm filter UTF-8 cho toàn bộ request
    @Override
    protected Filter[] getServletFilters() {
        CharacterEncodingFilter encodingFilter = new CharacterEncodingFilter();
        encodingFilter.setEncoding("UTF-8");
        encodingFilter.setForceEncoding(true);
        return new Filter[] { encodingFilter };
    }
}
