function setCookie(name, value, days) {
  var expires = "";
  if (days) {
    var date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    expires = "; expires=" + date.toUTCString();
  }
  document.cookie = name + "=" + (value || "")  + expires + "; path=/";
}

function loginjs() {
	console.log("on rentre dans le login")

	var email = document.getElementById("email").value
	var password = document.getElementById("password").value

	console.log(email, password, "JOJOJS")

	fetch("/Connexion", {
		method: "POST",
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({
			email: email,
			password: password
		})
	}).then(function (response) {
		return response.json()
	}).then(function (data) {
		if (data.status == 200) {
			// Connexion réussie, stocker les informations d'authentification dans un cookie
			setCookie('email', email, 7);
			setCookie('password', password, 7);

			window.location.href = "127.0.0.1:5000"
			location.reload()
			console.log("tu es connecté")
			// hide the login button
			document.getElementById("login-btn").remove();
		} else {
			displayError(data.status)
		}
	})
}

function signupjs() {
	console.log("on s'enregistre")

	var new_email = document.getElementById("new_email").value
	var new_password = document.getElementById("new_password").value
	var lastname = document.getElementById("lastname").value
	var firstname = document.getElementById("firstname").value
	var address = document.getElementById('address').value

	fetch("/Inscription", {
		method: "POST",
		headers: {
			"Content-Type": "application/json"
		},
		body: JSON.stringify({
			new_email: new_email,
			new_password: new_password,
			lastname: lastname,
			firstname: firstname,
			address: address
		})
	}).then(function (response) {
		return response.json()
	}).then(function (data) {
		if (data.status == 200) {
			window.location.href = "accueil.html"
			console.log("tu es enregistré")
			// hide the login button
			window.location.reload();
			document.getElementById("signup-btn").remove();
		} else {
			displayError(data.status)
		}
	})
}

function logoutjs() {
  fetch('/Deconnexion')
    .then(response => {
      if (response.ok) {
	    // delete the cookie
		document.cookie = "username=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
        // Reload the page after successful logout
        window.location.reload();
      } else {
        console.error('Logout failed');
      }
    })
    .catch(error => console.error(error));
}


