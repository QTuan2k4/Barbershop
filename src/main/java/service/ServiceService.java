package service;

import entity.ServiceEntity;
import java.util.List;

public interface ServiceService {
    List<ServiceEntity> getAllServices();
    ServiceEntity getServiceById(Long id);
    void saveService(ServiceEntity service);
    void deleteService(Long id);
}
