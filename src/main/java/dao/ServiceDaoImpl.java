package dao;

import entity.ServiceEntity;
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
    public ServiceEntity findById(Long id) {
        return s().get(ServiceEntity.class, id);
    }

    @Override
    public ServiceEntity findByName(String name) {
        try {
            Query<ServiceEntity> query = s().createQuery("from ServiceEntity where name = :name", ServiceEntity.class);
            query.setParameter("name", name);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public List<ServiceEntity> findAll() {
        return s().createQuery("from ServiceEntity", ServiceEntity.class).getResultList();
    }

    @Override
    public void save(ServiceEntity ServiceEntity) {
        if (ServiceEntity.getServiceId() == null) {
            s().persist(ServiceEntity);
        } else {
            s().merge(ServiceEntity);
        }
    }

    @Override
    public void delete(Long id) {
        ServiceEntity ServiceEntity = findById(id);
        if (ServiceEntity != null) {
            s().remove(ServiceEntity);
        }
    }
}
