<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Đặt lịch thành công</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <style>
    /* ===== THEME (Navy) ===== */
    :root{
      --primary:#0B2A4A;
      --accent:#2563EB;
      --bg:#F6F8FC;
      --card:#FFFFFF;
      --text:#0F172A;
      --muted:#667085;
      --success:#16a34a;
      --shadow:0 8px 28px rgba(0,0,0,.10);
      --radius:16px;
    }

    *{box-sizing:border-box}
    body{
      margin:0; background:var(--bg); color:var(--text);
      font-family:Inter, Arial, Helvetica, sans-serif;
      -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
    }
    a{ text-decoration:none; color:inherit }

    .wrap{
      min-height:100vh; display:grid; place-items:center; padding:24px;
      background:
        radial-gradient(ellipse at 20% -10%, rgba(37,99,235,.08), transparent 55%),
        radial-gradient(ellipse at 120% 10%, rgba(11,42,74,.06), transparent 45%);
    }

    .card{
      width:min(720px, 94vw);
      background:var(--card); border:1px solid #eef2f7; border-radius:var(--radius);
      box-shadow:var(--shadow); padding:28px 24px 22px; text-align:center; position:relative;
    }
    .card::before{
      /* viền màu chuyển nhẹ phía trên */
      content:""; position:absolute; inset:0 0 auto 0; height:4px; border-radius:16px 16px 0 0;
      background:linear-gradient(90deg, var(--accent), var(--primary));
    }

    .icon{
      width:86px; height:86px; border-radius:50%; margin:6px auto 10px;
      background:linear-gradient(135deg, #22c55e, #16a34a);
      display:grid; place-items:center; color:#fff;
      box-shadow:0 10px 24px rgba(22,163,74,.35);
      animation:pop .35s ease-out both;
    }
    .icon svg{ width:44px; height:44px; stroke:#fff; stroke-width:2.4; fill:none;
               stroke-linecap:round; stroke-linejoin:round; }

    h1{
      margin:10px 0 6px; font-size:clamp(22px, 3.6vw, 30px);
      font-weight:900; letter-spacing:.2px; color:#122335;
    }
    .lead{
      margin:0 auto 14px; color:var(--muted); line-height:1.7;
      max-width:56ch; font-size:15px;
    }

    .info{
      margin:12px auto 4px; text-align:left; max-width:560px;
      background:#f8fafc; border:1px solid #e8eef5; border-radius:12px; padding:12px 14px;
    }
    .info ul{ list-style:none; padding:0; margin:0; display:grid; gap:6px; }
    .info li{ display:flex; align-items:center; gap:8px; font-size:14px; color:#1f2937 }
    .info li span{ color:var(--muted); min-width:96px; }

    .actions{ display:flex; gap:10px; justify-content:center; margin-top:16px; flex-wrap:wrap }
    .btn{
      display:inline-flex; align-items:center; justify-content:center; gap:8px;
      height:44px; padding:0 18px; border-radius:12px; border:1px solid #e5e7eb;
      background:#fff; font-weight:800; cursor:pointer;
    }
    .btn:hover{ filter:brightness(.98) }
    .btn--primary{ background:var(--accent); color:#fff; border-color:var(--accent) }
    .btn--ghost{ background:#eef2ff; color:#0f172a; border-color:#c7d2fe }

    @keyframes pop{ from{ transform:scale(.8); opacity:.6 } to{ transform:scale(1); opacity:1 } }
  </style>
</head>
<body>

  <div class="wrap">
    <div class="card">
      <div class="icon" aria-hidden="true">
        <!-- checkmark icon -->
        <svg viewBox="0 0 24 24">
          <path d="M20 6L9 17l-5-5"/>
        </svg>
      </div>

      <h1>Đặt lịch thành công!</h1>
      <p class="lead">
        Cảm ơn bạn đã tin tưởng TIM Barbershop. Chúng tôi sẽ gửi xác nhận qua SMS/Email.
        Nếu cần hỗ trợ, vui lòng liên hệ hotline.
      </p>


      <div class="actions">
        <a class="btn btn--primary" href="${pageContext.request.contextPath}/appointments/new">Đặt lịch khác</a>
      </div>
    </div>
  </div>

</body>
</html>
