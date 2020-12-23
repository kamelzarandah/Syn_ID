$(document).ready(function(){
  // LUA listener
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      var type        = event.data.type;
      var userData    = event.data.array;
      var sex         = event.data.sex;

      if ( type == 'id') {
        $('img').show();
        $('#name').css('color', '#282828');

        if ( sex.toLowerCase() == 'm' ) {
          $('img').attr('src', 'assets/images/male.png');
          $('#sex').text('male');
        } else {
          $('img').attr('src', 'assets/images/female.png');
          $('#sex').text('female');
        }

        $('#name').text(userData.name);
        $('#dob').text(userData.job);
        $('#height').text(userData.jobgrade);
        $('#signature').text(userData.name);
        $('#id-card').css('background', 'url(assets/images/idcard.png)');
        
      }

      $('#id-card').show();
    } else if (event.data.action == 'close') {
      $('#name').text('');
      $('#dob').text('');
      $('#height').text('');
      $('#signature').text('');
      $('#sex').text('');
      $('#id-card').hide();
      $('#licenses').html('');
    }
  });
});
