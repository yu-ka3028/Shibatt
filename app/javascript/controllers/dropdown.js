$(document).ready(function() {
  $('.dropdown-item').click(function(e) {
    e.preventDefault();
    var selectedValue = $(this).data('value');
    var selectId = $(this).closest('.dropdown').find('input[type=hidden]').attr('id');
    $('#' + selectId).val(selectedValue);
  });
});
