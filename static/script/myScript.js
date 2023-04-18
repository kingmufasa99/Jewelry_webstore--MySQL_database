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

			window.location.href = "/"
			// location.reload()
			console.log("tu es connecté")
			// hide the login button
			document.getElementById("login-btn").remove();
			document.getElementById("login-btn").innerHTML = ""
		} else {
			displayError(data.status)
		}
	})
}
function validateLoginForm() {
    var email = document.getElementById("email").value;
    var password = document.getElementById("password").value;
    var errorMsg = document.getElementById("error-msg");

    if (!email) {
        errorMsg.innerHTML = "Veuillez entrer une adresse courriel";
        return;
    }

    if (!password) {
        errorMsg.innerHTML = "Veuillez entrer un mot de passe";
        return;
    }

    loginjs();
}

function validateSignupForm() {
    var new_email = document.getElementById("new_email").value;
    var new_password = document.getElementById("new_password").value;
    var firstname = document.getElementById("firstname").value;
    var lastname = document.getElementById("lastname").value;
    var address = document.getElementById("address").value;
    var serrorMsg = document.getElementById("serror-msg");

    if (!new_email) {
        serrorMsg.innerHTML = "Veuillez entrer une adresse courriel";
        return false;
    } else if (!isValidEmail(new_email)) {
        serrorMsg.innerHTML = "Veuillez entrer une adresse courriel valide";
        return false;
    }

    if (!new_password) {
        serrorMsg.innerHTML = "Veuillez entrer un mot de passe";
        return false;
    } else if (!isValidPassword(new_password)) {
        serrorMsg.innerHTML = "Veuillez entrer un mot de passe valide (au moins 8 caractères)";
        return false;
    }

    if (!firstname) {
        serrorMsg.innerHTML = "Veuillez entrer votre prénom";
        return false;
    }

    if (!lastname) {
        serrorMsg.innerHTML = "Veuillez entrer votre nom de famille";
        return false;
    }

    if (!address) {
        serrorMsg.innerHTML = "Veuillez entrer votre adresse";
        return false;
    }

    // If all fields are valid
    signupjs();
    return true;
}

// Function to validate email
function isValidEmail(email) {
    // Use a regular expression to validate email format
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Function to validate password
function isValidPassword(password) {
    return password.length >= 8;
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
			window.location.href = "/"
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


function displayItem(id, item, price) {
	var itemcontainer = document.getElementById('product-container')
	var newItem = document.createElement('div')
	newItem.innerText = "ID : " + id + ' **** Produit : ' + item + ' **** Prix: ' + price + '$'
	itemcontainer.appendChild(newItem)
	}


function onButton(itemId, itemName, itemPrice) {
   fetch('/add-to-panier/', {
	   method: "POST",
	   headers: {
		   "Content-Type": "application/json"
				},
	   body: JSON.stringify({
		   id : itemId,
		   item: itemName,
		   price : itemPrice
	})
})
  	displayItem(itemId, itemName, itemPrice)
}

function fetchPanier() {
	fetch('/panier').then(function (response) {
		return response.json()
	}).then(function (data) {
		let pids = data.pide
		let noms = data.nom
		let prix = data.prix

		for (let i = 0; i < pids.length; i++) {
			displayItem(pids[i], noms[i], prix[i])
		}
	});
}

function deleteItems() {
	fetch(`/delete_panier/`, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		}
	}).then(response => response.json()).then(data => {
		if (data.status === 200) {
			window.location.reload();
		}
	})
}

function acheterItems() {
	fetch(`/acheter-panier/`, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		}
	}).then(response => response.json()).then(data => {
		if (data.status === 200) {
			window.location.reload();
		}
	})
}

function search() {
	var input = document.getElementById("searchbar");
	var upper = input.value.toUpperCase();
	var collonne = document.getElementById("table").getElementsByTagName("tr");

	  for (var i = 0; i < collonne.length; i++) {
		var elements = collonne[i].getElementsByTagName("td");
		var valide = false;
		for (var j = 0; j < elements.length; j++) {
		  var element = elements[j];
		  if (element) {
			var text = element.textContent || element.innerText;
			if (text.toUpperCase().indexOf(upper) > -1) {
			  valide = true;
			  break;
			}
		  }
		}
		collonne[i].style.display = valide ? "" : "none";
	  }
	}
	document.querySelector("form").addEventListener("submit", function(e) {
	  e.preventDefault();
	  search();
});