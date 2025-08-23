package service;

import dao.EmployeeDao;
import entity.Employee;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.List;

@Service
public class EmployeeServiceImpl implements service.EmployeeService {

  private final EmployeeDao dao;
  public EmployeeServiceImpl(EmployeeDao dao){ this.dao = dao; }

  @Override @Transactional(readOnly = true)
  public List<Employee> list(){ return dao.findAll(); }

  @Override @Transactional(readOnly = true)
  public Employee get(Long id){ return dao.findById(id); }

  @Override @Transactional
  public void createOrUpdate(Employee e){
    // validate tối thiểu
    if (e.getWorkStartTime().compareTo(e.getWorkEndTime()) >= 0)
      throw new IllegalArgumentException("Giờ bắt đầu phải nhỏ hơn giờ kết thúc");
    if (dao.phoneExists(e.getPhone(), e.getEmployeeId()))
      throw new IllegalStateException("Số điện thoại đã tồn tại");
    if (dao.emailExists(e.getEmail(), e.getEmployeeId()))
      throw new IllegalStateException("Email đã tồn tại");
    dao.save(e);
  }

  @Override @Transactional
  public void delete(Long id){ dao.delete(id); }
}
