package dao;

import entity.ServiceEntity;
import java.util.List;

public interface ServiceDao {
    ServiceEntity findById(Long id);
    ServiceEntity findByName(String name);
    List<ServiceEntity> findAll();
    void save(ServiceEntity service); // Thêm mới hoặc cập nhật
    void delete(Long id);
}
