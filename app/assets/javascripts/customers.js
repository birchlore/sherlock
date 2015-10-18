$(function(){

  disableButton()

  $('#quantity').on('change', function(){
    var scans_remaining = parseInt($('#scans-remaining').text(), 10)
    var quantity = parseInt($('#quantity').val(), 10)
    if (quantity > scans_remaining) {
      $('#quantity').val(scans_remaining)
    }

  });

  $('#bulk_scan_form').on('submit', function(e){
    var num = $('#quantity').val()
    removeAlerts();
    var new_scans_available = ($('#scans-remaining').text() - $('#quantity').val())
    $('#scans-remaining').text(new_scans_available)
  });

 $('.scan').on('click', function(e){

  console.log('scanning >>>>>>>>>')
  e.preventDefault();
  
  removeAlerts();

   function isEmail(email){
        return /^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$/.test( email );
  }

   var scans_remaining = $('#scans-remaining').text()
   var first_name_missing = $('#customer_first_name').val() == "" || $('#customer_first_name').val() == null
   var last_name_missing = $('#customer_last_name').val() == ""
   var email_incorrectly_formatted = $('#customer_email').val() != "" && !isEmail($('#customer_email').val())
   
    

   if (first_name_missing) {
      $('#customer_first_name').closest('.form-group').addClass('has-error');
   }  else if (last_name_missing) {
      $('#customer_last_name').closest('.form-group').addClass('has-error');
    } else if (email_incorrectly_formatted) {
      $('#customer_email').closest('.form-group').addClass('has-error');
    } else {
      $('#scans-remaining').text(scans_remaining - 1)
      disableButton()
      $('.container').addClass('blur');
      $('.load-ajax').show()
      $("#new_customer").submit();
    }
   


    });

     $('.customers-container').on('click', '.glyphicon-remove', function(){
        $(this).closest('tr').hide();
     });  

     disableButton()

})

 
  function disableButton() {
    var scansRemaining = $('#scans-remaining').text();
    if (scansRemaining < 1) {
        $('.btn.scan').prop('disabled', true)
    }   
  } 
 
 function removeBlur(){
  $('.container').removeClass('blur');
  $('.load-ajax').hide()
  $('.form-control').val("")
 }

 function removeAlerts(){
  $('.alert').hide();
  $('.form-group').removeClass('has-error');
 }
 

