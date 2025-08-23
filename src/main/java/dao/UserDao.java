package dao;

import entity.User;
import java.util.List;

public interface UserDao {
  User findById(Long id);
  User findByUsername(String username);
  boolean existsByUsername(String username);
  void save(User user);   // insert or update
  List<User> findAll();
//=== thêm mới ===
 User findByEmail(String email);
 User findByPhone(String phone);
}
