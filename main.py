import idlelib.debugger
import os
import bcrypt
import jwt
import random
import pymysql
from passlib.hash import sha256_crypt
from dotenv import load_dotenv
from flask import Flask, jsonify, make_response, request, render_template

load_dotenv()
app = Flask(__name__)
mydb = pymysql.connect(
	host="localhost",
	user=os.getenv('DBPUSER'),
	password=os.getenv('DBPASSWORD'),
	database="bijoux"
)
mycursor = mydb.cursor()


def hash_password(password):
	return sha256_crypt.hash(password)


def verify_password(password, actual):
	return sha256_crypt.verify(password, actual)


def insert_user(cid: int, firstname: str , lastname: str, email: str, address: str, password: str):
	hashed_password = hash_password(password)  # chiffre le password donné

	request = f"INSERT INTO clients (ID_Client, Nom, Prenom, AdresseEmail, AdressePostale, MotDePasse) VALUES ('{cid}', '{firstname}','{lastname}','{email}', '{address}','{hashed_password}');"

	mycursor.execute(request)  # insere le nouveau client dans la DB


def check_user_password(email, password):
	request = f"SELECT MotDePasse FROM clients WHERE AdresseEmail = '{email}';"

	mycursor.execute(request)

	hashed_password = mycursor.fetchone()  # pas encrypté pour l'instant

	if (hashed_password[0] == password):
		return True
	return False

	return verify_password(password, hashed_password)


@app.route("/", methods=['GET', 'POST'])
def Accueil():
	sql = "SELECT * FROM Produits"
	mycursor.execute(sql)
	products = mycursor.fetchmany(size=5)
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
		else:
			response = {
				"status": 403,
				"message": "Mauvaise information de connexion",
				}
			print('Oups not connected cabron')

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
		password = data["new_password"]
		# cid = random.randint(1, 1000)

		insert_user(random.randint(1, 1000000), firstname, lastname, new_email, address, password)

		if insert_user(random.randint(1, 1000), firstname, lastname, new_email, address, password) is not None:
			return {"status": 200}
		else:
			return {"status": 400, "message": "Erreur lors de l'insertion de l'utilisateur dans la base de données"}


@app.route("/Deconnexion", methods=['POST'])
def Deconnexion():
	pass


@app.route("/api/rechercheProduit", methods=['POST'])
def rechercheProduit():
	pass


@app.route("/Recherche")
def Recherche():
	pass


@app.route("/api/ajouterPanier", methods=['POST'])
def ajouterPanier():
	# try:
	#     produit_id = int(request.form['produit_id'])
	#     user_id = int(request.form['user_id'])
	#     mycursor.execute("INSERT INTO Commandes (ID_Produit, ID_Client) VALUES (%s, %s)", (produit_id, user_id))
	#     mydb.commit()
	#     return make_response(jsonify({'message': 'Produit ajouté au panier'}), 200)
	# except:
	#     return make_response(jsonify({'error': 'Failed to add product to cart'}), 500)
	pass


@app.route("/api/supprimerPanier", methods=['POST'])
def supprimerPanier():
	# try:
	# 	produit_id = int(request.form['produit_id'])
	# 	user_id = int(request.form['user_id'])
	# 	mycursor.execute("DELETE FROM Commandes WHERE ID_Produit = %s AND ID_Client", (produit_id, user_id))
	# 	mydb.commit()
	# 	return make_response(jsonify({'message': 'Produit supprimé du panier'}), 200)
	# except:
	# 	return make_response(jsonify({'error': 'Failed to remove product from cart'}), 500)
	pass


@app.route("/api/commanderPanier", methods=['POST'])
def commanderPanier():
	# try:
	# 	resp = make_response(jsonify({"redirect": "/Commande", "message": request.form}))
	# 	return resp
	# except:
	# 	return ("", 404)
	pass


@app.route("/Commande")
def Commande():
	pass


@app.route("/api/Noter", methods=['POST'])
def Noter():
	pass


if __name__ == "__main__":
	app.run()
