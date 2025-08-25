package entity;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.Check;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import entity.AppointmentStatus;

@Entity
@Table(name = "appointment")
@Check(constraints = "start_time < end_time")
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "appointment_id", updatable = false, nullable = false)
    private Long appointmentId;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false,
        foreignKey = @ForeignKey(name = "fk_appt_user"))
    private User user;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id", nullable = false,
        foreignKey = @ForeignKey(name = "fk_appt_employee"))
    private Employee employee;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "service_id", nullable = false,
        foreignKey = @ForeignKey(name = "fk_appt_service"))
    private ServiceEntity service;

    @Column(name = "appointment_date", nullable = false)
    private LocalDate appointmentDate;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private AppointmentStatus status = AppointmentStatus.BOOKED;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

    @Column(name = "cancelled_at")
    private LocalDateTime cancelledAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cancelled_by", 
        foreignKey = @ForeignKey(name = "fk_appt_cancelled_by"))
    private User cancelledBy;

    @Column(name = "cancellation_reason", length = 255)
    private String cancellationReason;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @OneToOne(mappedBy = "appointment", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Review review;

    // Constructors
    public Appointment() {}

    public Appointment(User user, Employee employee, ServiceEntity service, 
                      LocalDate appointmentDate, LocalTime startTime, LocalTime endTime) {
        this.user = user;
        this.employee = employee;
        this.service = service;
        this.appointmentDate = appointmentDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = AppointmentStatus.BOOKED;
    }

    // Getters and Setters
    public Long getAppointmentId() { 
        return appointmentId; 
    }
    
    public void setAppointmentId(Long appointmentId) { 
        this.appointmentId = appointmentId; 
    }
    
    public User getUser() { 
        return user; 
    }
    
    public void setUser(User user) { 
        this.user = user; 
    }
    
    public Employee getEmployee() { 
        return employee; 
    }
    
    public void setEmployee(Employee employee) { 
        this.employee = employee; 
    }
    
    public ServiceEntity getService() { 
        return service; 
    }
    
    public void setService(ServiceEntity service) { 
        this.service = service; 
    }
    
    public LocalDate getAppointmentDate() { 
        return appointmentDate; 
    }
    
    public void setAppointmentDate(LocalDate appointmentDate) { 
        this.appointmentDate = appointmentDate; 
    }
    
    public LocalTime getStartTime() { 
        return startTime; 
    }
    
    public void setStartTime(LocalTime startTime) { 
        this.startTime = startTime; 
    }
    
    public LocalTime getEndTime() { 
        return endTime; 
    }
    
    public void setEndTime(LocalTime endTime) { 
        this.endTime = endTime; 
    }
    
    public AppointmentStatus getStatus() { 
        return status; 
    }
    
    public void setStatus(AppointmentStatus status) { 
        this.status = status; 
    }
    
    public String getNote() { 
        return note; 
    }
    
    public void setNote(String note) { 
        this.note = note; 
    }
    
    public LocalDateTime getCancelledAt() { 
        return cancelledAt; 
    }
    
    public void setCancelledAt(LocalDateTime cancelledAt) { 
        this.cancelledAt = cancelledAt; 
    }
    
    public User getCancelledBy() { 
        return cancelledBy; 
    }
    
    public void setCancelledBy(User cancelledBy) { 
        this.cancelledBy = cancelledBy; 
    }
    
    public String getCancellationReason() { 
        return cancellationReason; 
    }
    
    public void setCancellationReason(String cancellationReason) { 
        this.cancellationReason = cancellationReason; 
    }
    
    public LocalDateTime getCompletedAt() { 
        return completedAt; 
    }
    
    public void setCompletedAt(LocalDateTime completedAt) { 
        this.completedAt = completedAt; 
    }
    
    public LocalDateTime getCreatedAt() { 
        return createdAt; 
    }
    
    public LocalDateTime getUpdatedAt() { 
        return updatedAt; 
    }
    
    public Review getReview() { 
        return review; 
    }
    
    public void setReview(Review review) { 
        this.review = review; 
    }

    // Business logic methods
    public boolean isCancelled() {
        return AppointmentStatus.CANCELLED.equals(this.status);
    }

    public boolean isCompleted() {
        return AppointmentStatus.COMPLETED.equals(this.status);
    }

    public boolean isBooked() {
        return AppointmentStatus.BOOKED.equals(this.status);
    }

    public boolean canBeCancelled() {
        return isBooked() && appointmentDate.isAfter(LocalDate.now());
    }

    public boolean canBeReviewed() {
        return isCompleted() && review == null;
    }

    public void cancel(User cancelledBy, String reason) {
        this.status = AppointmentStatus.CANCELLED;
        this.cancelledAt = LocalDateTime.now();
        this.cancelledBy = cancelledBy;
        this.cancellationReason = reason;
        this.note = "Đã hủy: " + reason;
    }

    public void complete() {
        this.status = AppointmentStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
    }

    // toString method for debugging
    @Override
    public String toString() {
        return "Appointment{" +
                "appointmentId=" + appointmentId +
                ", user=" + (user != null ? user.getUsername() : "null") +
                ", employee=" + (employee != null ? employee.getName() : "null") +
                ", service=" + (service != null ? service.getName() : "null") +
                ", appointmentDate=" + appointmentDate +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", status=" + status +
                '}';
    }

    // equals and hashCode methods
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Appointment that = (Appointment) o;
        return appointmentId != null ? appointmentId.equals(that.appointmentId) : that.appointmentId == null;
    }

    @Override
    public int hashCode() {
        return appointmentId != null ? appointmentId.hashCode() : 0;
    }
}
