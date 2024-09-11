document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.select-ghost').forEach(function(select) {
    select.addEventListener('change', function() {
      this.form.submit();
    });
  });
});