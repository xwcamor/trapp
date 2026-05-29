$(document).on('change', '.parentCheckBox', function() {
   var that = $(this);
   that.closest('div').find('.childCheckBox').prop('checked', that.is(':checked'));
});

$(document).on('change', '.childCheckBox', function() {
    var that = $(this);
    var par = that.closest('ul');
    var c = par.find('.childCheckBox').filter(':checked').length;
    var parChk = par.closest('div').parent().find('.parentCheckBox');
    var checked = c > 0;

    parChk.prop('checked', checked);
    console.log(checked);
});