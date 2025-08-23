package service;
import entity.Employee;
import java.util.List;

public interface EmployeeService {
  List<Employee> list();
  Employee get(Long id);
  void createOrUpdate(Employee e);
  void delete(Long id);
}
