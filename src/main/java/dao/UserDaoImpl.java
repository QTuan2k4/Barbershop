
package dao;

import entity.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
public class UserDaoImpl implements UserDao {

  private final SessionFactory sessionFactory;
  public UserDaoImpl(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

  private Session s() { return sessionFactory.getCurrentSession(); }

  @Override
  public User findById(Long id) { return s().get(User.class, id); }

  @Override
  public User findByUsername(String username) {
    try {
      Query<User> q = s().createQuery("from User where username=:u", User.class);
      q.setParameter("u", username);
      return q.getSingleResult();
    } catch (NoResultException e) {
      return null;
    }
  }

  @Override
  public boolean existsByUsername(String username) {
    Long count = s().createQuery("select count(u.userId) from User u where username=:u", Long.class)
                    .setParameter("u", username).uniqueResult();
    return count != null && count > 0;
  }

  @Override
  public void save(User user) {
    if (user.getUserId() == null) s().persist(user);
    else s().merge(user);
  }

  @Override
  public List<User> findAll() {
    return s().createQuery("from User order by userId desc", User.class).getResultList();
  }

  // === thêm mới ===
  @Override
  public User findByEmail(String email) {
    try {
      return s().createQuery("from User where email=:e", User.class)
               .setParameter("e", email).getSingleResult();
    } catch (NoResultException e) { return null; }
  }

  @Override
  public User findByPhone(String phone) {
    try {
      return s().createQuery("from User where phone=:p", User.class)
               .setParameter("p", phone).getSingleResult();
    } catch (NoResultException e) { return null; }
  }
}
