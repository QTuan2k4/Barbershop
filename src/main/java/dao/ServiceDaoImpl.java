package dao;

import entity.Service;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
public class ServiceDaoImpl implements ServiceDao {

    private final SessionFactory sessionFactory;

    public ServiceDaoImpl(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    private Session s() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Service findById(Long id) {
        return s().get(Service.class, id);
    }

    @Override
    public Service findByName(String name) {
        try {
            Query<Service> query = s().createQuery("from Service where name = :name", Service.class);
            query.setParameter("name", name);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public List<Service> findAll() {
        return s().createQuery("from Service", Service.class).getResultList();
    }

    @Override
    public void save(Service service) {
        if (service.getServiceId() == null) {
            s().persist(service);
        } else {
            s().merge(service);
        }
    }

    @Override
    public void delete(Long id) {
        Service service = findById(id);
        if (service != null) {
            s().remove(service);
        }
    }
}
