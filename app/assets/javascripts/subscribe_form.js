$(function(){
  $('#new_user').on('ajax:send', function(xhr) {
    console.log("SENDING REQUEST");
    console.log($('#user_email').attr('value'));
    $('#user_email').val('Sending...');
    console.log($('#user_email').attr('value'));
  });
  $('#new_user').on('ajax:complete', function(xhr) {
    console.log("REQUEST COMPLETE");
    $('#user_email').val('');
  });
});
