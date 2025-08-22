package service;

import dao.ServiceDao;
import entity.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@org.springframework.stereotype.Service
@Transactional
public class ServiceServiceImpl implements ServiceService {

    private final ServiceDao serviceDao;

    @Autowired
    public ServiceServiceImpl(ServiceDao serviceDao) {
        this.serviceDao = serviceDao;
    }

    @Override
    public List<Service> getAllServices() {
        return serviceDao.findAll();
    }

    @Override
    public Service getServiceById(Long id) {
        return serviceDao.findById(id);
    }

    @Override
    public void saveService(Service service) {
        serviceDao.save(service);
    }

    @Override
    public void deleteService(Long id) {
        serviceDao.delete(id);
    }
}
