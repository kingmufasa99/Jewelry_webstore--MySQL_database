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


def insert_user(email, password):
	hashed_password = hash_password(password)

	request = f"INSERT INTO clients (AdresseEmail, MotDePasse) VALUES ('{email}', '{hashed_password}');"

	mycursor.execute(request)


def check_user_password(email, password):
	request = f"SELECT MotDePasse FROM clients WHERE AdresseEmail = '{email}';"

	mycursor.execute(request)

	hashed_password = mycursor.fetchone() #pas chifre pour linstant

	if(hashed_password[0] == password):
		return True, print('trueeee')
	return False, print('false')

	# return verify_password(password, hashed_password)


@app.route("/", methods=['GET', 'POST'])
def Accueil():
	sql = "SELECT * FROM Produits"
	mycursor.execute(sql)
	products = mycursor.fetchmany(size=5)
	return render_template('accueil.html', products=products)


@app.route("/login", methods=['GET', 'POST'])
def login():
	print("on est dans login")
	if request.method == "GET":
		print("on est dans le get")
		return render_template("accueil.html")
	else:

		print("on est dans le post")
		data = request.json

		username = data["username"]
		password = data["password"]

		if check_user_password(username, password):
			response = {
				"status": 200
			}
		else:
			response = {
				"status": 403,
				"message": "Mauvaise informations de connexion"
			}

		return jsonify(response)


@app.route("/api/Inscription", methods=['POST'])
def Inscription():
	cid = random.shuffle(list(range(1, 100)))
	firstname = request.form.get('firstname')
	lastname = request.form.get('lastname')
	email = request.form.get('new_email')
	address = request.form.get('address')
	password = request.form.get('new_password')

	# Cryptage du mot de passe
	hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
	inscription = "INSERT INTO Clients VALUES (%s,%s,%s,%s,%s)"
	val = (cid, firstname, lastname, email, address, hashed_password)

	mycursor.execute(inscription, val)
	mydb.commit()

	# Réponse HTTP
	return make_response("accueil.html", 200)


@app.route("/api/Deconnexion", methods=['POST'])
def Deconnexion():
	pass


@app.route("/api/rechercheProduit", methods=['POST'])
def rechercheProduit():
	# try:
	# 	reponse = make_response(jsonify({"redirect": "/Recherche", "message": request.form}))
	# 	return reponse
	# except:
	# 	return ("", 404)
	pass


@app.route("/Recherche")
def Recherche():
	# params = []
	# mycursor.callproc("selection_produits")
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
