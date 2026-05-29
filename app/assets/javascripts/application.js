// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
//= require rails-ujs
//= require jquery_nested_form

 
function trim(el) {
    el.value = el.value.
    replace(/(^\s*)|(\s*$)/gi, ""). // removes leading and trailing spaces
    replace(/[ ]{2,}/gi, " "). // replaces multiple spaces with one space 
    replace(/\n +/, "\n"); // Removes spaces after newlines
    return;
}

function numbersOnly(oToCheckField, oKeyEvent) {        
    var s = String.fromCharCode(oKeyEvent.charCode);
    var containsDecimalPoint = /\./.test(oToCheckField.value);
    return oKeyEvent.charCode === 0 || /\d/.test(s) || 
            /\./.test(s) && !containsDecimalPoint;
}


function clone_email(){
   var total2 = $("#user_name").val();
    $("#cloned_email").val(total2);
}



function clone_password(){
    var total2 = $("#user_password").val();
    $("#cloned_password").val(total2);
}

 

function open_close_div(str_form) {
    jQuery('#'+str_form).slideToggle("slow");
    return false;
} 
 
 

function collapse_panel_div() {
  var p3 = document.getElementById("panel-3");
  var p4 = document.getElementById("panel-4");
  if (p3.style.display === "none") {
    p3.style.display = "block";
    p4.style.display = "none";
  } else {
    p3.style.display = "none";
     p4.style.display = "block";
  }
}
 