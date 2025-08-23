package dao;

import dao.EmployeeDao;
import entity.Employee;
import org.hibernate.SessionFactory;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class EmployeeDaoImpl implements EmployeeDao {

  private final SessionFactory sf;
  public EmployeeDaoImpl(SessionFactory sf){ this.sf = sf; }
  private Session s(){ return sf.getCurrentSession(); }

  @Override public List<Employee> findAll() {
    return s().createQuery("from Employee e order by e.employeeId desc", Employee.class).list();
  }
  @Override public Employee findById(Long id) { return s().get(Employee.class, id); }

  @Override public void save(Employee e) {
    if (e.getEmployeeId()==null) s().persist(e); else s().merge(e);
  }
  @Override public void delete(Long id) {
    Employee e = findById(id); if (e!=null) s().remove(e);
  }

  @Override public boolean phoneExists(String phone, Long ignoreId) {
    String hql="select count(e.employeeId) from Employee e where e.phone=:p"
             + (ignoreId!=null? " and e.employeeId<>:id": "");
    Query<Long> q=s().createQuery(hql, Long.class).setParameter("p", phone);
    if (ignoreId!=null) q.setParameter("id", ignoreId);
    Long c=q.uniqueResult(); return c!=null && c>0;
  }
  @Override public boolean emailExists(String email, Long ignoreId) {
    String hql="select count(e.employeeId) from Employee e where e.email=:e"
             + (ignoreId!=null? " and e.employeeId<>:id": "");
    Query<Long> q=s().createQuery(hql, Long.class).setParameter("e", email);
    if (ignoreId!=null) q.setParameter("id", ignoreId);
    Long c=q.uniqueResult(); return c!=null && c>0;
  }
}
