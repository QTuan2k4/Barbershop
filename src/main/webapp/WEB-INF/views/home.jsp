<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Trang chủ – Barbershop</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="<c:url value='/resources/css/home.css'/>">
  <!-- trong <head> -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="<c:url value='/resources/css/base.css'/>">
  
</head>
<body>

  <!-- ======= TOP BAR ======= -->
	<header class="topbar">
	  <div class="topbar__inner">
	    <a class="brand" href="${pageContext.request.contextPath}/">
	      <img src="${pageContext.request.contextPath}/resources/images/logo3.jpeg" alt="TIM Barbershop">
	      <span class="name">BARBERSHOP</span>
	    </a>
	
	    <nav class="nav">
	      <a href="${pageContext.request.contextPath}/">Trang chủ</a>
	      <a href="${pageContext.request.contextPath}/appointments/new">Đặt lịch</a>
	      <a href="<c:url value='/price'/>">Bảng giá</a>
	      <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
	    </nav>
	
	    <div class="user-menu">
	      <c:choose>
	        <c:when test="${not empty username}">
	          <span class="hello">Xin chào, <b><c:out value='${username}'/></b></span>
	          <a class="btn btn--outline" href="${pageContext.request.contextPath}/account">Tài khoản</a>
	          <a class="btn btn--primary" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
	        </c:when>
	        <c:otherwise>
	          <a class="btn btn--primary" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
	        </c:otherwise>
	      </c:choose>
	    </div>
	  </div>
	</header>

	<!-- ======= TOP SLIDER (ngay sau top bar) ======= -->
	<section class="promo">
	  <div id="top-slider" class="tslider" data-interval="3000">
	    <button class="ts-btn prev" aria-label="Ảnh trước"></button>
	
	    <div class="ts-viewport">
	      <div class="ts-track">
	        <!-- Nếu có list từ controller: heroSlides -->
	        <c:forEach var="img" items="${heroSlides}">
	          <div class="ts-slide">
	            <img src="${pageContext.request.contextPath}/resources/images/${img}" alt="Banner">
	          </div>
	        </c:forEach>
	
	        <!-- Fallback khi chưa có dữ liệu -->
	        <c:if test="${empty heroSlides}">
	          <div class="ts-slide">
	            <img src="${pageContext.request.contextPath}/resources/images/slide2.avif" alt="Slide2">
	          </div>
	          <div class="ts-slide">
	            <img src="${pageContext.request.contextPath}/resources/images/slide3.jpg" alt="Slide3">
	          </div>
	        </c:if>
	      </div>
	    </div>
	
	    <button class="ts-btn next" aria-label="Ảnh sau"></button>
	    <div class="ts-dots" aria-label="Chỉ số ảnh"></div>
	  </div>
	</section>
	
	<!-- ======= ABOUT / GIỚI THIỆU ======= -->
	<section class="about">
	  <div class="about__card">
	    <div class="about__content">
	      <h2 class="about__title">
	        BARBERSHOP<br/>CHUYÊN NGHIỆP
	      </h2>
	
	      <p class="about__desc">
	        Tim Barbershop là 1 chuỗi những cửa hàng cắt tóc cho nam giới tại Hà Nội, Việt Nam.
	        Được thành lập từ năm 2019, với đội ngũ chuyên nghiệp và nhiệt tình, cam kết sẽ mang lại
	        những kiểu tóc hài lòng nhất cho các đấng mày râu.
	      </p>
	
	      <div class="about__stats">
	        <div class="stat">
	          <div class="stat__num">150.000+</div>
	          <div class="stat__label">Dịch vụ tuyệt vời!</div>
	        </div>
	        <div class="stat">
	          <div class="stat__num">5000+</div>
	          <div class="stat__label">Khách hàng đánh giá hài lòng</div>
	        </div>
	      </div>
	    </div>
	
	    <figure class="about__media">
	      <img src="${pageContext.request.contextPath}/resources/images/about.jpeg"
	           alt="Không gian TIM Barbershop">
	    </figure>
	  </div>
	</section>
		

  <!-- ======= DỊCH VỤ TÓC ======= -->
  <c:set var="ctx" value="${pageContext.request.contextPath}"/>

	<!-- ======= DỊCH VỤ - SẢN PHẨM ======= -->
	<section class="svc-block">
	  <div class="svc-head">
	    <h2 class="svc-title">DỊCH VỤ – SẢN PHẨM</h2>
	  </div>
	
	  <div class="svc-grid">
	    <!-- CẮT - LÀM HÓA CHẤT -->
	    <article class="svc-card">
	      <div class="svc-cover">
	        <img src="${ctx}/resources/images/cat.avif" alt="Cắt - làm hóa chất">
	      </div>
	      <div class="svc-body">
	        <h3 class="svc-name">CẮT – LÀM HÓA CHẤT</h3>
	        <p>Đa dạng dịch vụ: Cắt Xả, Senior/ Master cắt & làm hoá chất như Uốn, Ép, Nhuộm…</p>
	        <div class="svc-cta">
	          <a class="btn btn--outline" href="<c:url value='/appointments/new'/>">Đặt lịch</a>
	          <%-- nếu muốn chỉ định serviceId: /appointments/new?serviceId=1 --%>
	        </div>
	      </div>
	    </article>
	
	    <!-- GỘI ĐẦU - RELAX -->
	    <article class="svc-card">
	      <div class="svc-cover">
	        <img src="${ctx}/resources/images/goi.avif" alt="Gội đầu - Relax">
	      </div>
	      <div class="svc-body">
	        <h3 class="svc-name">GỘI ĐẦU – RELAX</h3>
	        <p>Không gian yên tĩnh, liệu trình nhẹ nhàng cho phút giây thư giãn & thoải mái.</p>
	        <div class="svc-cta">
	          <a class="btn btn--outline" href="<c:url value='/appointments/new'/>">Đặt lịch</a>
	        </div>
	      </div>
	    </article>
	
	    <!-- SẢN PHẨM -->
	    <article class="svc-card">
	      <div class="svc-cover">
	        <img src="${ctx}/resources/images/sanpham.avif" alt="Sản phẩm tạo kiểu & chăm sóc tóc">
	      </div>
	      <div class="svc-body">
	        <h3 class="svc-name">SẢN PHẨM</h3>
	        <p>Sản phẩm chính hãng cho nhiều kiểu tóc & chất tóc: pomade, sáp, dầu gội, dưỡng…</p>
	        <div class="svc-cta">
	          <a class="btn btn--outline" href="<c:url value='/products'/>">Mua</a>
	        </div>
	      </div>
	    </article>
	  </div>
	</section>
  

  <!-- ======= HÌNH ẢNH ======= -->
	<section class="section gallery-block" id="gallery">
	  <div class="section__head section__head--center">
	    <div class="g-head">
	      <h2 class="section__title g-title">HÌNH ẢNH</h2>
	      <p class="g-sub">Khám phá những mẫu tóc mới nhất & đang thịnh hành.</p>
	    </div>
	  </div>
	
	  <div class="grid grid--4 g-grid">
	    <!-- Nếu có dữ liệu từ controller -->
	    <c:forEach var="st" items="${popularStyles}">
	      <article class="card style-card g-item"
	               data-full="${pageContext.request.contextPath}/resources/images/${st.image}">
	        <img class="card__img"
	             src="${pageContext.request.contextPath}/resources/images/${st.image}"
	             alt="${st.name}">
	      </article>
	    </c:forEach>
	
	    <!-- Fallback khi chưa có model -->
	    <c:if test="${empty popularStyles}">
	      <c:set var="ctx" value="${pageContext.request.contextPath}"/>
	      <article class="card style-card g-item" data-full="${ctx}/resources/images/toc1.avif">
	        <img class="card__img" src="${ctx}/resources/images/toc1.avif" alt="Layer Hàn Quốc">
	      </article>
	      <article class="card style-card g-item" data-full="${ctx}/resources/images/toc2.avif">
	        <img class="card__img" src="${ctx}/resources/images/toc2.avif" alt="Low Fade">
	      </article>
	      <article class="card style-card g-item" data-full="${ctx}/resources/images/toc3.avif">
	        <img class="card__img" src="${ctx}/resources/images/toc3.avif" alt="Two-block">
	      </article>
	      <article class="card style-card g-item" data-full="${ctx}/resources/images/toc4.avif">
	        <img class="card__img" src="${ctx}/resources/images/toc4.avif" alt="Side-part">
	      </article>
	      <article class="card style-card g-item" data-full="${ctx}/resources/images/toc5.avif">
	        <img class="card__img" src="${ctx}/resources/images/toc5.avif" alt="Side-part">
	      </article>
	      <article class="card style-card g-item" data-full="${ctx}/resources/images/toc6.avif">
	        <img class="card__img" src="${ctx}/resources/images/toc6.avif" alt="Low Fade">
	      </article>
	       <article class="card style-card g-item" data-full="${ctx}/resources/images/toc7.avif">
	        <img class="card__img" src="${ctx}/resources/images/toc7.avif" alt="Side-part">
	      </article>
	      <article class="card style-card g-item" data-full="${ctx}/resources/images/toc8.avif">
	        <img class="card__img" src="${ctx}/resources/images/toc8.avif" alt="Side-part">
	      </article>
	    </c:if>
	  </div>
	</section>


  <!-- ======= FOOTER  ======= -->
<footer class="footer">
  <div class="footer__inner">

    <div class="footer__cols footer__cols--compact">
      <div>
        <h4>Về chúng tôi</h4>
        <p><a href="">Giờ phục vụ: Thứ 2 – CN, 8h30–20h30</a></p>
        <p><a href="">Hotline: 1900 27 27 03</a></p>
        <p><a href="">Địa chỉ: 138 Cần Vương, Quy Nhơn, Gia Lai</a></p>
      </div>

      <div>
        <h4>Dịch vụ & Hỗ trợ</h4>
        <p><a href="${pageContext.request.contextPath}/policies/privacy">Chính sách bảo mật</a></p>
        <p><a href="${pageContext.request.contextPath}/policies/terms">Điều kiện giao dịch</a></p>
      </div>

      <div>
        <h4>Kết nối</h4>
        <div class="payments">
		  <a href="https://facebook.com/yourpage" aria-label="Facebook">
		    <img src="https://cdn.simpleicons.org/facebook/FFFFFF" width="24" height="24" alt="Facebook">
		  </a>
		  <a href="https://www.tiktok.com/@yourpage" aria-label="TikTok">
		    <img src="https://cdn.simpleicons.org/tiktok/FFFFFF" width="24" height="24" alt="TikTok">
		  </a>
		  <a href="https://youtube.com/@yourchannel" aria-label="YouTube">
		    <img src="https://cdn.simpleicons.org/youtube/FFFFFF" width="24" height="24" alt="YouTube">
		  </a>
		  <a href="https://instagram.com/yourpage" aria-label="Instagram">
		    <img src="https://cdn.simpleicons.org/instagram/FFFFFF" width="24" height="24" alt="Instagram">
		  </a>
		</div>
      </div>
    </div>
  </div>
</footer>


  <!-- LIGHTBOX -->
  <div class="lightbox" id="lightbox">
    <button class="lightbox__close" id="lbClose">✕</button>
    <img class="lightbox__img" id="lbImg" src="" alt="Preview">
  </div>

  <!-- CHATBOX -->
  <div class="ai-chatbox" id="aiChat">
    <button class="ai-fab" id="aiFab">Chat</button>
    <div class="ai-panel" id="aiPanel" aria-live="polite">
      <div class="ai-head">
        <div>Trợ lý tóc</div>
        <small>08:00–21:00 hằng ngày</small>
      </div>

      <div class="ai-body" id="aiBody"></div>

      <div class="ai-sugs" id="aiSugs">
        <button class="ai-chip" data-q="Giờ mở cửa của shop là mấy giờ?">Giờ mở cửa</button>
        <button class="ai-chip" data-q="Mặt tròn hợp kiểu tóc nào?">Mặt tròn hợp kiểu gì?</button>
        <button class="ai-chip" data-q="Shop đang có kiểu tóc nào thịnh hành?">Kiểu tóc thịnh hành</button>
        <button class="ai-chip" data-q="Tôi nên chọn kiểu nào nếu tóc dày và hay đổ mồ hôi?">Tư vấn theo chất tóc</button>
      </div>

      <div class="ai-input">
        <input id="aiText" type="text" placeholder="Hỏi: mặt trái xoan/ tròn/ vuông… hợp kiểu gì?" />
        <button id="aiSend">Gửi</button>
      </div>
      <div class="ai-typing" id="aiTip" style="display:none">Đang soạn câu trả lời…</div>
    </div>
  </div>

  <script src="<c:url value='/resources/js/home.js'/>"></script>
</body>
</html>
