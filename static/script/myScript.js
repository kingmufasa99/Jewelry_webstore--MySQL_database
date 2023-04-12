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
        $('#loginModal').modal('hide');
        $('#login').hide();
        $('#logout').show();
      },
      error: function(data) {
        alert("Adresse email ou mot de passe incorrect !");
      }
    });
  });

  $('#signupForm').submit(function(e) {
    e.preventDefault();
    var email = $('#email').val();
    var password = $('#password').val();
    $.ajax({
      type: 'POST',
      url: '/api/Connexion',
      data: {email: email, password: password},
      success: function(data) {
        alert("Connexion réussie !");
        $('#signupModal').modal('hide');
        $('#signup').hide();
        $('#logout').show();
      },
      error: function(data) {
        alert("Champs d'inscription manquant !");
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


