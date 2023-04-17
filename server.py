import random
import os
import pymysql
from dotenv import load_dotenv
from flask import Flask, jsonify, make_response, request, render_template, redirect, url_for, session
from flask_login import logout_user
from passlib.hash import sha256_crypt

load_dotenv()
app = Flask(__name__)
mydb = pymysql.connect(
    host="localhost",
    user=os.getenv('DBPUSER'),
    password=os.getenv('DBPASSWORD'),
    database="bijoux"
)
mycursor = mydb.cursor()


def select_panier():
    query = f"SELECT * FROM Panier"
    mycursor.execute(query)
    panier = [entry for entry in mycursor.fetchall()]
    return panier


def select_Id():
    req = "SELECT ID_Produit FROM Panier "
    mycursor.execute(req)
    id = [entry for entry in mycursor.fetchall()]
    return id


def select_NomProduit():
    req = "SELECT NomProduit FROM Produits P, Panier N WHERE P.ID_Produit = N.ID_Produit "
    mycursor.execute(req)
    nom = [entry for entry in mycursor.fetchall()]
    return nom


def select_Prix():
    req = "SELECT Prix FROM Produits P, Panier N WHERE P.ID_Produit = N.ID_Produit "
    mycursor.execute(req)
    prix = [entry for entry in mycursor.fetchall()]
    return prix


# def hash_password(password):
#     return sha256_crypt.hash(password)
#
#
# def insert_user(cid: int, firstname: str, lastname: str, new_email: str, address: str, new_password: str):
#     hashed_password = hash_password(new_password)
#
#     sql_insert = "INSERT INTO clients (ID_Client, Nom, Prenom, AdresseEmail, AdressePostale, MotDePasse) " \
#                  "VALUES (%s, %s, %s, %s, %s, %s);"
#     values = (cid, firstname, lastname, new_email, address, hashed_password)
#
#     mycursor.execute(sql_insert, values)
#     mydb.commit()

def get_cid():
    email = session.get('email')
    query = f"SELECT ID_Client FROM Clients WHERE AdresseEmail = {email} "
    mycursor.execute(query)
    res = mycursor.fetchone()
    cid = res[0]
    return cid


def products():
    req = "SELECT * FROM Produits"
    mycursor.execute(req)
    products = mycursor.fetchmany(size=3)
    return products


def verify_password(password, actual):
    return sha256_crypt.verify(password, actual)


def check_user_password(email, password):
    request = f"SELECT MotDePasse FROM clients WHERE AdresseEmail = '{email}';"
    mycursor.execute(request)
    hashed_password = mycursor.fetchone()[0]
    return verify_password(password, hashed_password)


@app.route("/")
@app.route("/catalogue")
def Accueil():
    sql = "SELECT * FROM Produits"
    mycursor.execute(sql)
    products = mycursor.fetchmany(size=3)
    return render_template('accueil.html', products=products)


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
    itemId = data['id']
    email = session.get('email')
    print(email)

    cid = get_cid()

    query2 = f"SELECT Quantite FROM Panier WHERE ID_Produit = {itemId} AND ID_Client = {cid} "
    mycursor.execute(query2)
    result = mycursor.fetchone()

    if result:
        quantite = result[0] + 1
        update_query = f"UPDATE Panier SET Quantite = {quantite} WHERE ID_Produit = {itemId} AND ID_Client = {cid} "
        mycursor.execute(update_query)
    else:
        insert_query = f"INSERT INTO Panier (ID_client, ID_Produit, Quantite) VALUES ({cid}, {itemId}, 1)"
        mycursor.execute(insert_query)

    mydb.commit()

    response = {
        "status": 200
    }

    return jsonify(response)


@app.route("/delete_panier/", methods=['POST'])
def delete_panier():
    cid = get_cid()

    delete_query = f"DELETE * FROM Panier WHERE ID_Client = {cid}"
    mycursor.execute(delete_query)

    mydb.commit()

    response = {
        "status": 200
    }

    return jsonify(response)


@app.route("/acheter-panier/", methods=['POST'])
def acheter_panier():
    cid = get_cid()

    request = f"""INSERT INTO Commandes (ID_Client) VALUE ("{cid}")"""

    mycursor.execute(request)

    if request:
        query = f"UPDATE Produits SET (StockDisponible = StockDisponible - (SELECT Quantite FROM Panier WHERE " \
                f"ID_Client = {cid}))"
        mycursor.execute(query)

    response = {
        "status": 200
    }

    return jsonify(response)


#     for produit in produits:


#         if produit[1] == itemName and produit[4] > 0:
#             return jsonify({'success': True})
#     return jsonify({'success': False, 'message': 'Le produit est en rupture de stock.'})
# except:
#     return jsonify({'success': False, 'message': 'Une erreur s\'est produite.'})


# code a mous le pd


@app.route("/Connexion", methods=['GET', 'POST'])
def Connexion():
    if request.method == "GET":
        return render_template("accueil.html")
    else:
        data = request.json
        username = data["email"]
        password = data["password"]

        if check_user_password(username, password):
            session['email'] = username
            response = {
                "status": 200
            }
            print('Tu es connecté bravo!')
            return redirect(url_for('insite'))

        else:
            print(data["password"])
            print(sha256_crypt.hash(password))
            response = {
                "status": 403,
                "message": "Mauvaise information de connexion",
            }
            return render_template("accueil.html")


@app.route("/insite")
def insite():
    return render_template("insite.html")


# @app.route("/Inscription", methods=['GET', 'POST'])
# def Inscription():
#     if request.method == "GET":
#         return render_template("accueil.html")
#     else:
#         data = request.json
#     if request.method == "GET":
#         return render_template("accueil.html")
#     else:
#         data = request.json
#
#         lastname = data["lastname"]
#         firstname = data["firstname"]
#         new_email = data["new_email"]
#         address = data["address"]
#         new_password = data["new_password"]
#         cid = random.randint(1, 10000)
#         lastname = data["lastname"]
#         firstname = data["firstname"]
#         new_email = data["new_email"]
#         address = data["address"]
#         new_password = data["new_password"]
#         cid = random.randint(1, 10000)
#
#         result = insert_user(cid, firstname, lastname, new_email, address, new_password)
#         insert_user(cid, firstname, lastname, new_email, address, new_password)
#
#         if result:
#             return make_response("accueil.html", 200)
#         else:
#             return {"status": 400, "message": "Erreur lors de l'insertion de l'utilisateur dans la base de données"}
#         return make_response(render_template("accueil.html"), 200)
#
#
# @app.route("/Deconnexion", methods=['POST'])
# def Deconnexion():
#     pass
#     return render_template("accueil.html")


if __name__ == "__main__":
    app.run(port=8900, debug=True)
