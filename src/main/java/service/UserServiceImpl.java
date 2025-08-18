package service;

import dao.UserDao;
import entity.User;
import service.UserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {

  private final UserDao userDao;
  private final PasswordEncoder encoder;

  public UserServiceImpl(UserDao userDao, PasswordEncoder encoder) {
    this.userDao = userDao;
    this.encoder = encoder;
  }

  @Override
  @Transactional
  public User register(String username, String rawPassword, String fullName, String phone, String email) {
    if (username == null || username.isBlank())
      throw new IllegalArgumentException("Username không được rỗng");
    if (rawPassword == null || rawPassword.length() < 4)
      throw new IllegalArgumentException("Mật khẩu tối thiểu 4 ký tự");
    if (userDao.existsByUsername(username))
      throw new IllegalStateException("Username đã tồn tại");

    User u = new User();
    u.setUsername(username.trim());
    u.setPassword(encoder.encode(rawPassword)); // lưu hash
    u.setFullName(fullName);
    u.setPhone(phone);
    u.setEmail(email);
    u.setRole("CUSTOMER");
    userDao.save(u);
    return u;
  }

  @Override
  @Transactional(readOnly = true)
  public User login(String username, String rawPassword) {
    User u = userDao.findByUsername(username);
    if (u == null) return null;
    return encoder.matches(rawPassword, u.getPassword()) ? u : null;
  }

  @Override
  @Transactional(readOnly = true)
  public boolean usernameTaken(String username) {
    return userDao.existsByUsername(username);
  }
}
