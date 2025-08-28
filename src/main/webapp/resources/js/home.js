// /resources/js/home.js  (ES5 safe)
document.addEventListener('DOMContentLoaded', function () {
  // ===== Top Slider =====
  var slider = document.querySelector('.tslider');
  if (slider) {
    var track = slider.querySelector('.ts-track');
    var slides = track ? track.children : [];
    var prevBtn = slider.querySelector('.ts-btn.prev');
    var nextBtn = slider.querySelector('.ts-btn.next');
    var dotsWrap = slider.querySelector('.ts-dots');
    var index = 0;
    var timer = null;

    function go(i) {
      if (!track || !slides.length) return;
      index = (i + slides.length) % slides.length;
      var x = -index * 100;
      track.style.transform = 'translateX(' + x + '%)';
      if (dotsWrap) {
        var dots = dotsWrap.querySelectorAll('.ts-dot');
        for (var d = 0; d < dots.length; d++) {
          dots[d].classList.remove('active');
        }
        if (dots[index]) dots[index].classList.add('active');
      }
    }

    function next() { go(index + 1); }
    function prev() { go(index - 1); }

    // build dots
    if (dotsWrap && slides.length) {
      dotsWrap.innerHTML = '';
      for (var k = 0; k < slides.length; k++) {
        var b = document.createElement('button');
        b.className = 'ts-dot' + (k === 0 ? ' active' : '');
        (function (n) {
          b.addEventListener('click', function () { go(n); });
        })(k);
        dotsWrap.appendChild(b);
      }
    }

    if (nextBtn) nextBtn.addEventListener('click', next);
    if (prevBtn) prevBtn.addEventListener('click', prev);

    function autoplay() {
      clearInterval(timer);
      timer = setInterval(next, 3000);
    }
    autoplay();

    slider.addEventListener('mouseenter', function () { clearInterval(timer); });
    slider.addEventListener('mouseleave', autoplay);
  }

  // ===== Lightbox (style-card + g-item) =====
  var lb = document.getElementById('lightbox');
  var lbImg = document.getElementById('lbImg');
  var lbClose = document.getElementById('lbClose');

  function openLb(src) {
    if (!lb || !lbImg) return;
    lbImg.src = src;
    lb.classList.add('show');
  }
  function closeLb() {
    if (!lb || !lbImg) return;
    lb.classList.remove('show');
    lbImg.src = '';
  }

  if (lb && lbClose) {
    lbClose.addEventListener('click', closeLb);
    lb.addEventListener('click', function (e) { if (e.target === lb) closeLb(); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeLb(); });
  }

  function bindLightbox(selector) {
    var items = document.querySelectorAll(selector);
    for (var i = 0; i < items.length; i++) {
      (function (el) {
        el.addEventListener('click', function () {
          var full = el.getAttribute('data-full');
          if (!full) {
            var im = el.querySelector('img');
            if (im) full = im.getAttribute('src');
          }
          if (full) openLb(full);
        });
      })(items[i]);
    }
  }

  bindLightbox('.style-card');
bindLightbox('.g-item');
});