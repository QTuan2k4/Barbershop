package service;

import entity.User;

public interface UserService {
  User register(String username, String rawPassword, String fullName, String phone, String email);
  User login(String username, String rawPassword); // trả về user nếu đúng, null nếu sai
  boolean usernameTaken(String username);
}
