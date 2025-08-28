// JS nhẹ: kiểm tra sđt/email cơ bản + confirm password + toggle show/hide
document.addEventListener('DOMContentLoaded', function () {
  // ----- PROFILE VALIDATION -----
  var phone = document.getElementById('phone');
  var profileForm = document.getElementById('profileForm');

  if (phone && profileForm) {
    phone.addEventListener('input', function () {
      // chỉ cho số và dấu +
      phone.value = phone.value.replace(/[^\d+]/g, '');
    });

    profileForm.addEventListener('submit', function (e) {
      var v = phone.value.replace(/\D/g, '');
      if (v.length < 9) {
        e.preventDefault();
        alert('Số điện thoại chưa hợp lệ (tối thiểu 9 số).');
        phone.focus();
      }
    });
  }

  // ----- PASSWORD VALIDATION -----
  var pwForm    = document.getElementById('passwordForm');
  var newPw     = document.getElementById('newPassword');
  var cfPw      = document.getElementById('confirmPassword');
  var hint      = document.getElementById('pwHint');
  var toggle    = document.getElementById('togglePw');
  var btnChange = document.getElementById('btnChangePw');

  function checkMatch() {
    if (!newPw.value || !cfPw.value) {
      hint.textContent = '';
      newPw.classList.remove('error');
      cfPw.classList.remove('error');
      btnChange.disabled = false;
      return;
    }
    if (newPw.value !== cfPw.value) {
      hint.textContent = 'Mật khẩu nhập lại không khớp.';
      newPw.classList.add('error');
      cfPw.classList.add('error');
      btnChange.disabled = true;
    } else if (newPw.value.length < 8) {
      hint.textContent = 'Mật khẩu mới tối thiểu 8 ký tự.';
      newPw.classList.add('error');
      cfPw.classList.remove('error');
      btnChange.disabled = true;
    } else {
      hint.textContent = '';
      newPw.classList.remove('error');
      cfPw.classList.remove('error');
      btnChange.disabled = false;
    }
  }

  if (pwForm) {
    newPw.addEventListener('input', checkMatch);
    cfPw.addEventListener('input', checkMatch);

    // KHÔNG dùng optional chaining
    if (toggle) {
      toggle.addEventListener('click', function () {
        var type = newPw.type === 'password' ? 'text' : 'password';
        newPw.type = type;
        cfPw.type = type;
        toggle.textContent = (type === 'text') ? 'Ẩn mật khẩu' : 'Hiện mật khẩu';
      });
    }

    pwForm.addEventListener('submit', function (e) {
      checkMatch();
      if (btnChange.disabled) e.preventDefault();
    });
  }
});
