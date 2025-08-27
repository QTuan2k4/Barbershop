<%@ page contentType="text/html;charset=UTF-8" %>
<!-- Nút mở Google Maps -->
<a href="https://www.google.com/maps?q=${storeAddress}"
   target="_blank"
   style="display:inline-block;margin:10px 0;padding:8px 16px;
          background:#4285F4;color:white;text-decoration:none;
          border-radius:6px;font-weight:bold;">
   📍 Mở trong Google Maps
</a>
<!-- Thêm thẻ div hiển thị bản đồ -->
<div id="map" style="height:85%; width:100%; margin-top:15px; border-radius:8px; overflow:hidden;"></div>

<!-- Leaflet CSS & JS -->
<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

<script>
  // Lấy tọa độ cửa hàng (có thể set cứng hoặc lấy từ model backend)
  var lat = 13.75792847014036;   // vĩ độ Quy Nhơn
  var lng = 109.21289873770804;  // kinh độ Quy Nhơn

  // Khởi tạo map
  var map = L.map('map').setView([lat, lng], 16);

  // Load nền bản đồ từ OpenStreetMap
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '© OpenStreetMap'
  }).addTo(map);

  // Thêm marker + popup
  L.marker([lat, lng])
    .addTo(map)
    .bindPopup("<b>" + "${storeName}" + "</b><br/>" + "${storeAddress}" + "<br/>📞 ${storePhone}")
    .openPopup();
</script>
