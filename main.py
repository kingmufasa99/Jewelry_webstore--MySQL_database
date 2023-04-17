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


def hash_password(password):
    return sha256_crypt.hash(password)


def verify_password(password, actual):
    return sha256_crypt.verify(password, actual)


def insert_user(cid: int, firstname: str, lastname: str, new_email: str, address: str, new_password: str):
    hashed_password = hash_password(new_password)

    sql_insert = "INSERT INTO clients (ID_Client, Nom, Prenom, AdresseEmail, AdressePostale, MotDePasse) VALUES (%s, %s, %s, %s, %s, %s);"
    values = (cid, firstname, lastname, new_email, address, hashed_password)

    mycursor.execute(sql_insert, values)
    mydb.commit()


def check_user_password(email, password):
    request = f"SELECT MotDePasse FROM clients WHERE AdresseEmail = '{email}';"
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
                "status": 403,
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


if __name__ == "__main__":
    app.run()
