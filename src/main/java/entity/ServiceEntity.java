package entity;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.io.Serializable;

@Entity
@Table(
    name = "service",
    uniqueConstraints = {
        @UniqueConstraint(name = "uq_service_name", columnNames = "name")
    }
)
public class ServiceEntity implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "service_id", updatable = false, nullable = false)
    private Long serviceId;

    @Column(name = "name", nullable = false, unique = true, length = 100)
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "price", nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(name = "duration", nullable = false)
    private Integer duration; // phút

    @Column(name = "category")
    private String category; // Thêm trường category

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Timestamp createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private Timestamp updatedAt;

    // Constructors
    public ServiceEntity() {
    }

    public ServiceEntity(String name, String description, BigDecimal price, Integer duration) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.duration = duration;
    }

    // ===== getters/setters =====
    public Long getServiceId() { return serviceId; }
    public void setServiceId(Long serviceId) { this.serviceId = serviceId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Service{" +
                "serviceId=" + serviceId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", duration=" + duration +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", category='" + category + '\'' +'}';
    }
}