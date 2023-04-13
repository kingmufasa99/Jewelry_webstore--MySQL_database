import os
import bcrypt
import jwt
# from flask_cors import CORS
import pymysql
from dotenv import load_dotenv
from flask import Flask, jsonify, make_response, request, render_template, redirect, url_for, flash
from flask_login import logout_user

load_dotenv()
app = Flask(__name__)
mydb = pymysql.connect(
    host="localhost",
    user=os.getenv('DBPUSER'),
    password=os.getenv('DBPASSWORD'),
    database="bijoux"
)
mycursor = mydb.cursor()


@app.route("/")
def Accueil():
    sql = "SELECT * FROM Produits"
    mycursor.execute(sql)
    products = mycursor.fetchmany(size=2)
    return render_template('accueil.html', products=products)


@app.route("/api/Connexion", methods=['POST'])
def Connexion():
    email = request.form.get('email')
    password = request.form.get('password')

    pwd = "SELECT MotDePasse FROM Clients WHERE AdresseEmail = %s"
    val = (email,)
    mycursor.execute(pwd, val)
    client = mycursor.fetchone()

    if client:
        hashed_password = client[0].encode('utf-8')
        if bcrypt.checkpw(password.encode('utf-8'), hashed_password):
            return make_response("", 200)
        else:
            return make_response("Moitié marche", 404)
    else:
        return make_response("Rien ne marche", 404)


@app.route("/api/Inscription", methods=['POST'])
def Inscription():
    email = request.form.get('mail')
    nom = request.form.get('nom')
    prenom = request.form.get('prenom')
    password1 = request.form.get('mdp1')
    password2 = request.form.get('mdp2')


@app.route("/api/Deconnexion")
def Deconnexion():
    logout_user()
    return redirect(url_for("Acceuil"))


@app.route("/api/rechercheProduit", methods=['POST'])
def rechercheProduit():
    # try:
    # 	reponse = make_response(jsonify({"redirect": "/Recherche", "message": request.form}))
    # 	return reponse
    # except:
    # 	return ("no", 404)
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
    app.run(port=8900, debug=True)
