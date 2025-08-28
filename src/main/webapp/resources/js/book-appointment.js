// JS nhẹ: Chọn tất cả dịch vụ + validate tối thiểu 1 dịch vụ
document.addEventListener('DOMContentLoaded', function () {
  const grid = document.querySelector('.svc-grid');
  const btnAll = document.getElementById('btnSelectAll');
  const form = document.getElementById('bookForm');

  if (btnAll && grid) {
    btnAll.addEventListener('click', function () {
      const boxes = grid.querySelectorAll('input[type="checkbox"][name="serviceIds"]');
      let allChecked = true;
      boxes.forEach(b => { if (!b.checked) allChecked = false; });
      boxes.forEach(b => { b.checked = !allChecked; });
      this.textContent = allChecked ? 'Chọn tất cả' : 'Bỏ chọn tất cả';
    });
  }

  if (form && grid) {
    form.addEventListener('submit', function (e) {
      const any = !!grid.querySelector('input[type="checkbox"][name="serviceIds"]:checked');
      if (!any) {
        e.preventDefault();
        alert('Vui lòng chọn ít nhất 1 dịch vụ.');
      }
    });
  }
});
