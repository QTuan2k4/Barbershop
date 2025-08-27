package entity;

public enum AppointmentStatus {
    BOOKED("Đã đặt"),
    CANCELLED("Đã hủy"),
    COMPLETED("Đã hoàn thành");

    private final String displayName;

    AppointmentStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static AppointmentStatus fromString(String status) {
        for (AppointmentStatus s : values()) {
            if (s.name().equalsIgnoreCase(status)) {
                return s;
            }
        }
        throw new IllegalArgumentException("Invalid status: " + status);
    }
}