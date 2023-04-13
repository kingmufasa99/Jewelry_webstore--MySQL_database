  $('#loginForm').submit(function(e) {
    e.preventDefault();
    var email = $('#email').val();
    var password = $('#password').val();
    $.ajax({
      type: 'POST',
      url: '/api/Connexion',
      data: {email: email, password: password},
      success: function(data) {
        alert("Connexion réussie !");
        window.location.href = "/"; // Redirect to homepage
        $('#loginModal').modal('hide');
        $('#login').hide();
        $('#logout').show();
      },
      error: function(data) {
        alert("Adresse email ou mot de passe incorrect !");
      }
    });
  });

  $('#signupForm').submit(function(event) {
    event.preventDefault();
    $.ajax({
        type: 'POST',
        url: '/api/Inscription',
        data: $('#signupForm').serialize(),
        success: function(response) {
            // Handle success response
            window.location.href = "/"; // Redirect to homepage
        },
        error: function(response) {
            // Handle error response
            alert('Erreur lors de l\'inscription');
        }
    });
});

  $('#logout').click(function() {
    $.ajax({
      type: 'POST',
      url: '/api/Deconnexion',
      success: function(data) {
        alert("Vous êtes déconnecté !");
        $('#logout').hide();
        $('#login').show();
      },
      error: function(data) {
        alert("Erreur lors de la déconnexion !");
      }
    });
  });

