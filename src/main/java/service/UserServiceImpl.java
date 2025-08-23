
package service;

import dao.UserDao;
import entity.User;
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

  // ====== thêm mới ======

  @Override
  @Transactional(readOnly = true)
  public User getById(Long userId) {
    return userDao.findById(userId);
  }

  @Override
  @Transactional
  public void updateProfile(Long userId, String fullName, String phone, String email) {
    User me = userDao.findById(userId);
    if (me == null) throw new IllegalArgumentException("User không tồn tại");

    // Kiểm tra trùng email/phone (để báo lỗi đẹp; DB cũng có unique)
    User byEmail = userDao.findByEmail(email);
    if (byEmail != null && !byEmail.getUserId().equals(userId))
      throw new IllegalArgumentException("Email đã được dùng bởi tài khoản khác");

    User byPhone = userDao.findByPhone(phone);
    if (byPhone != null && !byPhone.getUserId().equals(userId))
      throw new IllegalArgumentException("Số điện thoại đã được dùng bởi tài khoản khác");

    me.setFullName(fullName);
    me.setPhone(phone);
    me.setEmail(email);
    userDao.save(me);
  }

  @Override
  @Transactional
  public void changePassword(Long userId, String currentPassword, String newPassword) {
    User me = userDao.findById(userId);
    if (me == null) throw new IllegalArgumentException("User không tồn tại");

    if (!encoder.matches(currentPassword, me.getPassword()))
      throw new IllegalArgumentException("Mật khẩu hiện tại không đúng");

    // (tuỳ chọn) kiểm tra độ mạnh newPassword
    if (newPassword == null || newPassword.length() < 4)
      throw new IllegalArgumentException("Mật khẩu mới tối thiểu 4 ký tự");

    me.setPassword(encoder.encode(newPassword));
    userDao.save(me);
  }
}
