package entity;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(
    name = "employee",
    uniqueConstraints = {
        @UniqueConstraint(name = "uq_employee_phone", columnNames = "phone"),
        @UniqueConstraint(name = "uq_employee_email", columnNames = "email")
    }
)
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "employee_id", updatable = false, nullable = false)
    private Long employeeId;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(nullable = false, length = 15)
    private String phone;

    @Column(nullable = false, length = 100)
    private String email;

    @Column(name = "work_start_time", nullable = false)
    private LocalTime workStartTime;

    @Column(name = "work_end_time", nullable = false)
    private LocalTime workEndTime;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // getters/setters
    public Long getEmployeeId() { return employeeId; }
    public void setEmployeeId(Long employeeId) { this.employeeId = employeeId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public LocalTime getWorkStartTime() { return workStartTime; }
    public void setWorkStartTime(LocalTime workStartTime) { this.workStartTime = workStartTime; }
    public LocalTime getWorkEndTime() { return workEndTime; }
    public void setWorkEndTime(LocalTime workEndTime) { this.workEndTime = workEndTime; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
}