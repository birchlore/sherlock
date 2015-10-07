$(function(){
 $('.scan').on('click', function(e){

  console.log('scanning >>>>>>>>>')
  e.preventDefault();
  $('.alert').hide();
  $('.form-group').removeClass('has-error');

   function isEmail(email){
        return /^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$/.test( email );
  }


   var first_name_missing = $('#celebrity_first_name').val() == "" || $('#celebrity_first_name').val() == null
   var last_name_missing = $('#celebrity_last_name').val() == ""
   var email_incorrectly_formatted = $('#celebrity_email').val() != "" && !isEmail($('#celebrity_email').val())
    

   if (first_name_missing) {
      $('#celebrity_first_name').closest('.form-group').addClass('has-error');
   }  else if (last_name_missing) {
      $('#celebrity_last_name').closest('.form-group').addClass('has-error');
    } else if (email_incorrectly_formatted) {
      $('#celebrity_email').closest('.form-group').addClass('has-error');
    } else {
      $('.container').addClass('blur');
      $('.load-ajax').show()
      $("#new_celebrity").submit();
    }
   


    });

     $('.customers-container').on('click', '.glyphicon-remove', function(){
        $(this).closest('tr').hide();
     });

     var scansRemaining = $('#scans-remaining').text();
     var scansRemainingInt = parseInt(scansRemaining);

     if (scansRemainingInt < 1) {
        $('.btn.scan').prop('disabled', true)
    }      


})
 

