package service;

import entity.User;

public interface UserService {
  User register(String username, String rawPassword, String fullName, String phone, String email);
  User login(String username, String rawPassword); // trả về user nếu đúng, null nếu sai
  boolean usernameTaken(String username);
  
//=== thêm mới ===
 User getById(Long userId);
 void updateProfile(Long userId, String fullName, String phone, String email);
 void changePassword(Long userId, String currentPassword, String newPassword);
}
