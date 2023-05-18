Spree.ready(function() {
  var profilePictureButton = document.getElementById('profile-picture-btn');

  if (profilePictureButton) {
    profilePictureButton.addEventListener('click', function() {
      document.getElementById('user_profile_picture').click();
    });
  }
});