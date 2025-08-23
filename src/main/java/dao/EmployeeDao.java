package dao;
import entity.Employee;
import java.util.List;

public interface EmployeeDao {
  List<Employee> findAll();
  Employee findById(Long id);
  void save(Employee e);
  void delete(Long id);
  boolean phoneExists(String phone, Long ignoreId);
  boolean emailExists(String email, Long ignoreId);
}
