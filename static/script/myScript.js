

  function loginjs() {
    console.log("on rentre dans le login")

    var email = document.getElementById("email").value
    var password = document.getElementById("password").value


      console.log(email,password,"JOJOJS")


    fetch("/Connexion", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            email: email,
            password: password
        })
    }).then(function(response) {
        return response.json()
    }).then(function(data) {
        if (data.status == 200) {
            showSuccessMessage();
            window.location.href = "insite.html"
            console.log("tu es connecté")
            // hide the login button
            document.getElementById("login-btn").remove();
        }
        else {
            displayError(data.message)
        }
    })
}

function signupjs(){
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
            lastname : lastname,
            firstname : firstname,
            address : address
        })
    }).then(function(response) {
        return response.json()
    }).then(function(data) {
        if (data.status == 200) {
            window.location.href = "accueil.html"
            console.log("tu es enregistré")
            // hide the login button
            document.getElementById("signup-btn").remove();
        }
        else {
            displayError(data.message)
        }
    })
}

function logoutjs() {
  fetch('/Deconnexion', {
    method: 'POST'
  }).then(response => {
    if (response.ok) {
      window.location.href = '/';
    }
  }).catch(error => console.error(error));
}

const logoutBtn = document.querySelector('#logout-btn');
if (logoutBtn) {
  logoutBtn.addEventListener('click', (e) => {
    e.preventDefault();
    logoutjs();
  });
}

