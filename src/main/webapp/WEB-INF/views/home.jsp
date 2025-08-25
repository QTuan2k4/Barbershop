<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="vi">
<head>
  <title>Trang chủ – Barbershop</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    :root{
      --primary:#0d3b66;        /* Xanh đậm header/footer */
      --accent:#133e87;          /* Xanh nhạt hơn */
      --brand:#1a3c34;           /* Xanh rêu (footer cũ) */
      --bg:#f6f8fb;
      --card:#ffffff;
      --muted:#6b7280;
      --warn:#ffb703;
      --round:18px;
      --shadow:0 10px 25px rgba(0,0,0,.08);
    }
    *{box-sizing:border-box}
    body{margin:0;font-family:Inter,Arial,Helvetica,sans-serif;background:var(--bg);color:#111}
    a{color:inherit;text-decoration:none}
    img{max-width:100%;display:block}

    /* ======= HEADER / BANNER ======= */
    .topbar{
      background:#fff; box-shadow:var(--shadow); position:sticky; top:0; z-index:50;
    }
    .topbar__inner{
      max-width:1200px; margin:auto; display:flex; align-items:center; gap:24px; padding:12px 16px;
    }
    .brand{display:flex; align-items:center; gap:10px}
    .brand img{height:44px}
    .brand .name{font-weight:800; letter-spacing:.5px}
    .nav{margin-left:auto; display:flex; gap:18px}
    .nav a{padding:10px 8px; color:#222; font-weight:600}
    .nav a:hover{color:var(--accent)}
    .user-menu{display:flex; gap:12px; margin-left:8px}
    .btn{
      display:inline-flex; align-items:center; justify-content:center; gap:8px;
      padding:10px 16px; border-radius:999px; font-weight:700; border:1px solid #e5e7eb; background:#fff;
    }
    .btn--primary{background:var(--accent); color:#fff; border-color:var(--accent)}
    .btn--outline{background:#fff; color:#111}
    .btn:hover{filter:brightness(.96)}

    /* ======= HERO ======= */
    .hero{
      background: url('${pageContext.request.contextPath}/resources/images/hero-bg.jpg') center/cover no-repeat;
      min-height:420px; display:grid; place-items:center; position:relative; overflow:hidden;
    }
    .hero::after{content:""; position:absolute; inset:0; background:linear-gradient(180deg, rgba(0,0,0,.25), rgba(0,0,0,.55))}
    .hero__content{
      position:relative; z-index:1; text-align:center; color:#fff; padding:40px 16px; max-width:1100px; width:100%;
    }
    .hero__title{font-size:56px; font-weight:900; text-transform:uppercase; margin:0 0 6px}
    .hero__subtitle{font-size:18px; opacity:.95; margin-bottom:18px}
    .hero__row{
      display:grid; grid-template-columns: 1.2fr .8fr .8fr; gap:18px; align-items:stretch; margin-top:18px;
    }
    .hero-card{
      background:rgba(255,255,255,.1); border:1px solid rgba(255,255,255,.25);
      backdrop-filter: blur(6px); border-radius:var(--round); padding:18px; display:flex; align-items:center; gap:16px;
    }
    .hero-card__big{grid-column:1/2; min-height:140px; justify-content:center}
    .hero-price{margin-left:auto; text-align:right}
    .hero-price .num{font-size:40px; font-weight:900}
    .badge{display:inline-block; background:#fff; color:#111; padding:6px 10px; border-radius:12px; font-weight:800; font-size:12px}

    /* ======= QUICK BOOK BAR ======= */
    .bookbar{
      max-width:1100px; background:#0f2a52; color:#fff; margin:-28px auto 32px; border-radius:20px; box-shadow:var(--shadow);
      display:flex; flex-wrap:wrap; align-items:center; gap:12px; padding:16px;
    }
    .bookbar__title{font-weight:800; padding:8px 12px 8px 14px}
    .bookbar input{
      flex:1; min-width:240px; height:44px; border:0; border-radius:999px; padding:0 16px;
    }
    .bookbar button{height:44px}

    /* ======= SECTIONS ======= */
    .section{max-width:1200px; margin:0 auto 48px; padding:0 16px}
    .section__head{display:flex; align-items:center; justify-content:space-between; margin:22px 0}
    .section__title{font-size:28px; font-weight:900; letter-spacing:.3px}
    .grid{display:grid; gap:18px}
    .grid--3{grid-template-columns:repeat(3,1fr)}
    .grid--4{grid-template-columns:repeat(4,1fr)}
    @media (max-width:1024px){ .hero__row{grid-template-columns:1fr;}.grid--3{grid-template-columns:repeat(2,1fr)}.grid--4{grid-template-columns:repeat(2,1fr)} }
    @media (max-width:640px){ .grid--3,.grid--4{grid-template-columns:1fr} .hero__title{font-size:40px} .hero-card__big{min-height:120px} }

    .card{
      background:var(--card); border-radius:var(--round); overflow:hidden; box-shadow:var(--shadow); border:1px solid #eef1f6;
      display:flex; flex-direction:column;
    }
    .card__img{aspect-ratio:16/10; object-fit:cover}
    .card__body{padding:14px 16px}
    .card__title{font-weight:800; font-size:18px; margin:2px 0 6px}
    .card__sub{color:var(--muted); font-size:14px}
    .card__row{display:flex; align-items:center; justify-content:space-between; margin-top:10px}
    .link{font-weight:700; color:var(--accent)}

    /* ======= FOOTER ======= */
    .footer{background:var(--primary); color:#e9eef7; margin-top:48px}
    .footer__inner{max-width:1200px; margin:auto; padding:32px 16px}
    .footer__logos{display:grid; grid-template-columns:1fr 1fr; gap:18px; margin-bottom:18px}
    .logo-box{
      border:1px dashed rgba(255,255,255,.25); border-radius:16px; padding:16px; display:flex; align-items:center; gap:16px; background:rgba(255,255,255,.04)
    }
    .logo-box img{height:56px}
    .logo-note{font-style:italic; opacity:.9}
    .footer__cols{display:grid; grid-template-columns:2fr 2fr 1.2fr 1.8fr; gap:18px; margin-top:10px}
    .footer h4{margin:0 0 10px; font-size:14px; letter-spacing:.4px; text-transform:uppercase}
    .footer a{color:#e9eef7; opacity:.9}
    .footer a:hover{opacity:1}
    .pills{display:flex; gap:8px; flex-wrap:wrap}
    .pill{background:rgba(255,255,255,.1); border-radius:999px; padding:8px 12px; font-weight:700; font-size:13px}
    .payments{display:flex; gap:8px; align-items:center; flex-wrap:wrap}
    .payments img{height:28px}
    @media (max-width:900px){ .footer__cols{grid-template-columns:1fr 1fr} .footer__logos{grid-template-columns:1fr} }
    @media (max-width:560px){ .footer__cols{grid-template-columns:1fr} }
  </style>
</head>
<body>

  <!-- ======= TOP BAR ======= -->
  <header class="topbar">
    <div class="topbar__inner">
      <a class="brand" href="${pageContext.request.contextPath}/">
        <img src="${pageContext.request.contextPath}/resources/images/tim-barber-shop-logo.png" alt="TIM Barbershop">
        <span class="name">TIM BARBERSHOP</span>
      </a>

      <nav class="nav">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a>
        <a href="${pageContext.request.contextPath}/appointments/new">Đặt lịch</a>
        <a href="${pageContext.request.contextPath}/appointments/my-appointments">Lịch hẹn của tôi</a>
        <a href="${pageContext.request.contextPath}/price">Bảng giá</a>
        <a href="${pageContext.request.contextPath}/products">Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/salons">Tìm chi nhánh</a>
      </nav>

      <div class="user-menu">
        <a class="btn btn--outline" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        <a class="btn btn--primary" href="${pageContext.request.contextPath}/account">Quản lý tài khoản</a>
        <li><a href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
      </div>
    </div>
  </header>

  <!-- ======= HERO ======= -->
  <section class="hero">
    <div class="hero__content">
      <div class="badge">Dịch vụ HOT</div>
      <h1 class="hero__title">Dịch vụ Hot Trend</h1>
      <p class="hero__subtitle">Tóc đẹp chuẩn salon – đặt lịch online trong 30 giây</p>

      <div class="hero__row">
        <div class="hero-card hero-card__big">
          <div>
            <div style="font-size:20px; font-weight:800; margin-bottom:6px">TikTok Style</div>
            <div>Xu hướng tạo kiểu, uốn – nhuộm được yêu thích</div>
          </div>
          <img src="${pageContext.request.contextPath}/resources/images/tiktok-badge.png" alt="TikTok" style="height:54px; margin-left:auto">
        </div>

        <div class="hero-card">
          <img src="${pageContext.request.contextPath}/resources/images/service-cut.jpg" alt="Cắt tóc" style="width:72px; border-radius:12px">
          <div style="text-align:left">
            <div style="font-weight:800">Cắt tóc</div>
            <div class="hero-price"><span class="num">90.000</span><span> VNĐ</span></div>
          </div>
        </div>

        <div class="hero-card">
          <img src="${pageContext.request.contextPath}/resources/images/service-wash.jpg" alt="Gội dưỡng sinh" style="width:72px; border-radius:12px">
          <div style="text-align:left">
            <div style="font-weight:800">Gội dưỡng sinh</div>
            <div class="hero-price"><span class="num">50.000</span><span> VNĐ</span></div>
          </div>
        </div>
      </div>
    </div>
  </section>


  <!-- ======= DỊCH VỤ TÓC ======= -->
  <section class="section">
    <div class="section__head">
      <h2 class="section__title">Dịch vụ tóc</h2>
      <a class="link" href="${pageContext.request.contextPath}/services">Xem tất cả →</a>
    </div>

    <div class="grid grid--3">
      <!-- Nếu có dữ liệu từ controller -->
      <c:forEach var="s" items="${services}">
        <article class="card">
          <img class="card__img" src="${pageContext.request.contextPath}/resources/images/${s.image}" alt="${s.name}">
          <div class="card__body">
            <div class="card__title">${s.name}</div>
            <div class="card__sub">Giá từ <b><c:out value='${s.basePrice}'/></b> VNĐ</div>
            <div class="card__row">
              <a class="link" href="${pageContext.request.contextPath}/services/${s.id}">Tìm hiểu thêm</a>
              <a class="btn btn--outline" href="${pageContext.request.contextPath}/appointments/new?serviceId=${s.id}">Đặt lịch</a>
            </div>
          </div>
        </article>
      </c:forEach>

      <!-- Dữ liệu mẫu khi chưa inject model -->
      <c:if test="${empty services}">
        <article class="card">
          <img class="card__img" src="${pageContext.request.contextPath}/resources/images/service-cut.jpg" alt="Cắt tóc">
          <div class="card__body">
            <div class="card__title">Cắt tóc</div>
            <div class="card__sub">Giá từ 90.000 VNĐ</div>
            <div class="card__row">
              <a class="link" href="${pageContext.request.contextPath}/services/1">Tìm hiểu thêm</a>
              <a class="btn btn--outline" href="${pageContext.request.contextPath}/appointments/new?serviceId=1">Đặt lịch</a>
            </div>
          </div>
        </article>
        <article class="card">
          <img class="card__img" src="${pageContext.request.contextPath}/resources/images/service-perm.jpg" alt="Uốn định hình">
          <div class="card__body">
            <div class="card__title">Uốn định hình</div>
            <div class="card__sub">Giá từ 379.000 VNĐ</div>
            <div class="card__row">
              <a class="link" href="${pageContext.request.contextPath}/services/2">Tìm hiểu thêm</a>
              <a class="btn btn--outline" href="${pageContext.request.contextPath}/appointments/new?serviceId=2">Đặt lịch</a>
            </div>
          </div>
        </article>
        <article class="card">
          <img class="card__img" src="${pageContext.request.contextPath}/resources/images/service-color.jpg" alt="Thay đổi màu tóc">
          <div class="card__body">
            <div class="card__title">Thay đổi màu tóc</div>
            <div class="card__sub">Giá từ 199.000 VNĐ</div>
            <div class="card__row">
              <a class="link" href="${pageContext.request.contextPath}/services/3">Tìm hiểu thêm</a>
              <a class="btn btn--outline" href="${pageContext.request.contextPath}/appointments/new?serviceId=3">Đặt lịch</a>
            </div>
          </div>
        </article>
      </c:if>
    </div>
  </section>

  <!-- ======= KIỂU TÓC THỊNH HÀNH ======= -->
  <section class="section">
    <div class="section__head">
      <h2 class="section__title">Kiểu tóc thịnh hành</h2>
      <div class="pills">
        <span class="pill">Trend 2025</span>
        <span class="pill">Layer</span>
        <span class="pill">Fade</span>
        <span class="pill">Curtain</span>
      </div>
    </div>

    <div class="grid grid--4">
      <c:forEach var="st" items="${popularStyles}">
        <article class="card">
          <img class="card__img" src="${pageContext.request.contextPath}/resources/images/${st.image}" alt="${st.name}">
          <div class="card__body">
            <div class="card__title">${st.name}</div>
            <div class="card__sub">${st.shortDesc}</div>
          </div>
        </article>
      </c:forEach>

      <c:if test="${empty popularStyles}">
        <article class="card"><img class="card__img" src="${pageContext.request.contextPath}/resources/images/style-1.jpg" alt=""><div class="card__body"><div class="card__title">Layer Hàn Quốc</div><div class="card__sub">Tự nhiên – gọn gàng</div></div></article>
        <article class="card"><img class="card__img" src="${pageContext.request.contextPath}/resources/images/style-2.jpg" alt=""><div class="card__body"><div class="card__title">Low Fade</div><div class="card__sub">Sạch gọn – nam tính</div></div></article>
        <article class="card"><img class="card__img" src="${pageContext.request.contextPath}/resources/images/style-3.jpg" alt=""><div class="card__body"><div class="card__title">Two-block</div><div class="card__sub">Trẻ trung – dễ phối</div></div></article>
        <article class="card"><img class="card__img" src="${pageContext.request.contextPath}/resources/images/style-4.jpg" alt=""><div class="card__body"><div class="card__title">Side-part</div><div class="card__sub">Lịch lãm – đi làm</div></div></article>
      </c:if>
    </div>
  </section>

  <!-- ======= FOOTER ======= -->
  <footer class="footer">
    <div class="footer__inner">
      <div class="footer__logos">
        <div class="logo-box">
          <img src="${pageContext.request.contextPath}/resources/images/logo-old.png" alt="Logo hiện tại">
          <div>
            <div style="font-weight:800">TIM BARBERSHOP</div>
            <div class="logo-note">Logo hiện tại ở một số salon</div>
          </div>
        </div>
        <div class="logo-box">
          <img src="${pageContext.request.contextPath}/resources/images/logo-new.png" alt="Logo mới">
          <div>
            <div style="font-weight:800">TIM BARBERSHOP</div>
            <div class="logo-note">Logo mới từ 2025</div>
          </div>
        </div>
      </div>

      <div class="footer__cols">
        <div>
          <h4>Về chúng tôi</h4>
          <p>Giờ phục vụ: Thứ 2 – CN, 8h30–20h30</p>
          <p>Hotline: 1900 27 27 03</p>
          <div class="pills">
            <a class="pill" href="${pageContext.request.contextPath}/about">Giới thiệu</a>
            <a class="pill" href="${pageContext.request.contextPath}/franchise">Nhượng quyền</a>
            <a class="pill" href="${pageContext.request.contextPath}/careers">Tuyển dụng</a>
          </div>
        </div>

        <div>
          <h4>Dịch vụ & Hỗ trợ</h4>
          <p><a href="${pageContext.request.contextPath}/policies/privacy">Chính sách bảo mật</a></p>
          <p><a href="${pageContext.request.contextPath}/policies/terms">Điều kiện giao dịch</a></p>
          <p><a href="${pageContext.request.contextPath}/salons">Tìm salon gần nhất</a></p>
        </div>

        <div>
          <h4>Tải ứng dụng</h4>
          <div class="payments">
            <img src="${pageContext.request.contextPath}/resources/images/appstore.png" alt="App Store">
            <img src="${pageContext.request.contextPath}/resources/images/googleplay.png" alt="Google Play">
            <img src="${pageContext.request.contextPath}/resources/images/qrcode.png" alt="QR">
          </div>
          <h4 style="margin-top:16px">Kết nối</h4>
          <div class="payments">
            <img src="${pageContext.request.contextPath}/resources/images/facebook-icon.png" alt="Facebook">
            <img src="${pageContext.request.contextPath}/resources/images/tiktok-icon.png" alt="TikTok">
            <img src="${pageContext.request.contextPath}/resources/images/youtube-icon.png" alt="YouTube">
            <img src="${pageContext.request.contextPath}/resources/images/instagram-icon.png" alt="Instagram">
          </div>
        </div>

        <div>
          <h4>Thanh toán</h4>
          <div class="payments">
            <img src="${pageContext.request.contextPath}/resources/images/cash.png" alt="Tiền mặt">
            <img src="${pageContext.request.contextPath}/resources/images/momo.png" alt="Momo">
            <img src="${pageContext.request.contextPath}/resources/images/visa.png" alt="VISA">
            <img src="${pageContext.request.contextPath}/resources/images/mastercard.png" alt="Mastercard">
            <img src="${pageContext.request.contextPath}/resources/images/jcb.png" alt="JCB">
          </div>
        </div>
      </div>
    </div>
  </footer>

</body>
</html>
