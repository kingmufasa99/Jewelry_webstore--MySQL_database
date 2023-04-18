import datetime
import json
import os
import random
import pymysql
from passlib.hash import sha256_crypt
from dotenv import load_dotenv
from flask import Flask, jsonify, make_response, request, render_template, session

load_dotenv()
app = Flask(__name__)
app.secret_key = 'mysecretkey'
mydb = pymysql.connect(
	host="localhost",
	user=os.getenv('DBPUSER'),
	password=os.getenv('DBPASSWORD'),
	database="bijoux",
)
mycursor = mydb.cursor()


def select_Id():
    req = "SELECT ID_Produit FROM Panier;"
    mycursor.execute(req)
    id = [entry for entry in mycursor.fetchall()]
    return id


def select_NomProduit():
    req = "SELECT NomProduit FROM Produits P, Panier N WHERE P.ID_Produit = N.ID_Produit;"
    mycursor.execute(req)
    nom = [entry for entry in mycursor.fetchall()]
    return nom


def select_Prix():
    req = "SELECT Prix FROM Produits P, Panier N WHERE P.ID_Produit = N.ID_Produit;"
    mycursor.execute(req)
    prix = [entry for entry in mycursor.fetchall()]
    return prix


def get_cid():
    email = session.get('email')
    query = f"""SELECT ID_Client FROM Clients WHERE AdresseEmail = '{email}';"""
    mycursor.execute(query)
    res = mycursor.fetchone()
    cid = res[0]
    return cid


def select_quantite(itemId):
    cid = get_cid()
    req = f"SELECT Quantite FROM Panier WHERE ID_Produit = {itemId} AND ID_Client = '{cid}';"
    mycursor.execute(req)
    quantite = mycursor.fetchone()
    return quantite


def hash_password(password):
	return sha256_crypt.hash(password)


def verify_password(password, actual):
	return sha256_crypt.verify(password, actual)


def insert_user(cid: int, firstname: str, lastname: str, new_email: str, address: str, new_password: str):
	try:
		procedure_email = f"call check_email_format('{new_email}');"
		mycursor.execute(procedure_email)
		hashed_password = hash_password(new_password)

		procedure_pwd = f"call check_password_format('{new_password}');"
		mycursor.execute(procedure_pwd)

		sql_insert = "INSERT INTO clients (ID_Client, Nom, Prenom, AdresseEmail, AdressePostale, MotDePasse) VALUES (%s, %s, %s, %s, %s, %s);"
		values = (cid, firstname, lastname, new_email, address, hashed_password)

		mycursor.execute(sql_insert, values)
		mydb.commit()

	except pymysql.err.OperationalError as e:
		error_msg = str(e)
		return render_template('accueil.html', error_msg=error_msg)


def check_user_password(email, password):
	request = f"SELECT MotDePasse FROM clients WHERE AdresseEmail = '{email}';"
	v = email
	mycursor.execute(request)
	hashed_password = mycursor.fetchone()[0]

	return verify_password(password, hashed_password)


@app.route("/", methods=['GET', 'POST'])
def Accueil():
	sql = "SELECT * FROM Produits"
	mycursor.execute(sql)
	products = mycursor.fetchmany(size=9)
	return render_template('accueil.html', products=products)


@app.route("/Connexion", methods=['GET', 'POST'])
def Connexion():
	if request.method == "GET":
		return render_template("accueil.html")
	else:
		data = request.json
		username = data["email"]
		password = data["password"]

		if check_user_password(username, password):
			response = {
				"status": 200
			}
			print('Tu es connecté bravo!')
			expires = datetime.datetime.now() + datetime.timedelta(minutes=100)
			session['email'] = username
			session.permanent = True
			app.permanent_session_lifetime = expires - datetime.datetime.now()
		else:
			print('erreur')
			response = {
				"status": 500,
				"message": "Mauvaise information de connexion",
			}
			return jsonify(response)

		return jsonify(response)


@app.route("/Inscription", methods=['GET', 'POST'])
def Inscription():
	if request.method == "GET":
		return render_template("accueil.html")
	else:
		data = request.json

		lastname = data["lastname"]
		firstname = data["firstname"]
		new_email = data["new_email"]
		address = data["address"]
		new_password = data["new_password"]
		cid = random.randint(1, 10000)

		insert_user(cid, firstname, lastname, new_email, address, new_password)

		return make_response(render_template("accueil.html"), 200)


@app.route('/Deconnexion', methods=['GET', 'POST'])
def Deconnexion():
	# delete the cookie by setting an expired date in the past
	resp = make_response(render_template('accueil.html'))
	resp.set_cookie('email', '', expires=0)
	return resp


@app.route("/panier", methods=["GET"])
def get_panier():
    pide = select_Id()
    nom = select_NomProduit()
    prix = select_Prix()
    response = {
        "status": 200,
        "pide": pide,
        "nom": nom,
        "prix": prix
    }
    return jsonify(response)


@app.route("/add-to-panier/", methods=['POST'])
def AddPanier():
    data = request.get_json()
    id = data['id']
    session['id'] = id
    email = session.get('email')
    print(email)

    cid = get_cid()

    result = select_quantite(id)

    if result:
        quantite = result[0] + 1
        update_query = "UPDATE Panier SET Quantite = %s WHERE ID_Produit = %s AND ID_Client = %s;"
        params = (quantite, id, cid)
        mycursor.execute(update_query, params)
    else:
        insert_query = f"INSERT INTO Panier (ID_client, ID_Produit, Quantite) VALUES ('{cid}', '{id}', 1);"
        mycursor.execute(insert_query)

    mydb.commit()

    response = {
        "status": 200
    }

    return jsonify(response)


@app.route("/delete_panier/", methods=['POST'])
def delete_panier():
    cid = get_cid()

    delete_query = f"DELETE FROM Panier WHERE ID_Client = '{cid}';"
    mycursor.execute(delete_query)

    mydb.commit()
    if delete_query:
        response = {
            "status": 200
        }
    else:
        response = {
            "status": 405
        }

    return jsonify(response)


@app.route("/acheter-panier/", methods=['POST'])
def acheter_panier():

    global response
    cid = get_cid()
    pid = session.get("id")
    print(pid)
    quantite = select_quantite(pid)
    print(quantite)

    try:
        req = f"INSERT INTO Commandes (ID_Client) VALUES ('{cid}')"
        mycursor.execute(req)
        mydb.commit()
    except Exception as e:
        print("erreur d'insertion dans Commandes:", e)
        response = {
            "status": 405
        }
        return jsonify(response)

    try:
        query = "UPDATE Produits SET StockDisponible = (StockDisponible - %s) WHERE ID_Produit = %s"
        params = (quantite, pid)
        mycursor.execute(query, params)
        mydb.commit()
        print('update réussi')
        response = {
            "status": 200
        }
    except Exception as e:
        print("erreur d'update de Produits:", e)
        response = {
            "status": 405
        }
        return jsonify(response)

    return jsonify(response)


if __name__ == "__main__":
	app.run(debug=True)
