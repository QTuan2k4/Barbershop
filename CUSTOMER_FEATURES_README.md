# Chức Năng Quản Lý Lịch Hẹn Cho Khách Hàng

## Tổng Quan
Dự án Barbershop đã được bổ sung các chức năng mới cho khách hàng để quản lý lịch hẹn của họ, bao gồm:
- Xem danh sách lịch hẹn
- Hủy lịch hẹn
- Đánh giá dịch vụ sau khi hoàn thành
- Xem chi tiết lịch hẹn

## Các File Đã Thêm Mới

### 1. Controller
- `src/main/java/controller/CustomerAppointmentController.java` - Xử lý các request từ khách hàng

### 2. Views (JSP)
- `src/main/webapp/WEB-INF/views/customer/appointments.jsp` - Trang danh sách lịch hẹn
- `src/main/webapp/WEB-INF/views/customer/appointment-detail.jsp` - Trang chi tiết lịch hẹn
- `src/main/webapp/WEB-INF/views/customer/review.jsp` - Trang đánh giá dịch vụ

### 3. CSS & JavaScript
- `src/main/webapp/resources/css/customer-appointments.css` - Styling cho giao diện khách hàng
- `src/main/webapp/resources/js/customer-appointments.js` - JavaScript cho tương tác

### 4. Cập Nhật
- `src/main/webapp/WEB-INF/views/account.jsp` - Thêm quick actions
- `src/main/webapp/WEB-INF/views/home.jsp` - Thêm link navigation
- `src/main/webapp/resources/css/account.css` - CSS cho quick actions

## Cách Sử Dụng

### 1. Truy Cập Trang Quản Lý Lịch Hẹn
- Đăng nhập vào hệ thống
- Click vào "Lịch hẹn" trên navigation bar
- Hoặc vào "Tài khoản" → "Quản lý lịch hẹn"

### 2. Xem Danh Sách Lịch Hẹn
- Hiển thị tất cả lịch hẹn của khách hàng
- Phân loại theo trạng thái: Đã đặt, Đã xác nhận, Hoàn thành, Đã hủy
- Hiển thị thông tin: dịch vụ, nhân viên, ngày giờ, trạng thái

### 3. Hủy Lịch Hẹn
- Chỉ có thể hủy lịch hẹn có trạng thái "Đã đặt"
- Click nút "Hủy lịch" trên card lịch hẹn
- Nhập lý do hủy (bắt buộc, ít nhất 5 ký tự)
- Xác nhận hủy lịch

### 4. Đánh Giá Dịch Vụ
- Chỉ có thể đánh giá lịch hẹn có trạng thái "Hoàn thành"
- Click nút "Đánh giá" trên card lịch hẹn
- Chọn số sao (1-5) và nhập nhận xét (không bắt buộc)
- Gửi đánh giá

### 5. Xem Chi Tiết Lịch Hẹn
- Click nút "Chi tiết" trên card lịch hẹn
- Hiển thị đầy đủ thông tin lịch hẹn
- Hiển thị đánh giá nếu đã có

## Tính Năng Kỹ Thuật

### 1. Bảo Mật
- Kiểm tra quyền truy cập (chỉ khách hàng có thể xem lịch hẹn của mình)
- Validation dữ liệu đầu vào
- CSRF protection

### 2. Giao Diện
- Responsive design cho mobile và desktop
- Modal dialog cho hủy lịch
- Rating system với sao tương tác
- Status badges với màu sắc phân biệt

### 3. JavaScript
- Xử lý modal
- Validation form
- Rating system
- Keyboard navigation (ESC để đóng modal)

## URL Endpoints

### Khách Hàng
- `GET /customer/appointments` - Danh sách lịch hẹn
- `GET /customer/appointments/{id}` - Chi tiết lịch hẹn
- `POST /customer/appointments/{id}/cancel` - Hủy lịch hẹn
- `GET /customer/appointments/{id}/review` - Form đánh giá
- `POST /customer/appointments/{id}/review` - Gửi đánh giá

## Cấu Trúc Database

### Bảng `appointment`
- Thêm các trường mới:
  - `cancel_reason`: Lý do hủy lịch
  - `canceled_by`: ID người hủy
  - `canceled_at`: Thời gian hủy

### Bảng `review`
- Liên kết 1-1 với appointment
- Lưu trữ rating (1-5 sao) và comment

## Lưu Ý

1. **Trạng thái lịch hẹn**: BOOKED → CONFIRMED → COMPLETED
2. **Hủy lịch**: Chỉ áp dụng cho trạng thái BOOKED
3. **Đánh giá**: Chỉ áp dụng cho trạng thái COMPLETED và chưa có review
4. **Quyền truy cập**: Khách hàng chỉ có thể thao tác với lịch hẹn của mình

## Hướng Dẫn Phát Triển

### Thêm Trạng Thái Mới
1. Cập nhật enum trong entity Appointment
2. Thêm CSS cho status badge mới
3. Cập nhật logic trong controller

### Thêm Trường Mới
1. Cập nhật entity
2. Cập nhật database schema
3. Cập nhật form và view

### Tùy Chỉnh Giao Diện
1. Chỉnh sửa CSS trong `customer-appointments.css`
2. Cập nhật JavaScript trong `customer-appointments.js`
3. Test responsive trên các thiết bị khác nhau
