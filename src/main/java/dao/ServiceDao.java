package dao;

import entity.Service;
import java.util.List;

public interface ServiceDao {
    Service findById(Long id);
    Service findByName(String name);
    List<Service> findAll();
    void save(Service service); // Thêm mới hoặc cập nhật
    void delete(Long id);
}
