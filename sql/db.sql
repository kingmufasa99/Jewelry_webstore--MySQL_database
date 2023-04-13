create database bijoux;
use bijoux;
show tables;


CREATE TABLE Clients (
  ID_Client INT,
  Nom VARCHAR(50),
  Prenom VARCHAR(50),
  AdresseEmail VARCHAR(255),
  AdressePostale VARCHAR(255),
  MotDePasse VARCHAR(255),
  PRIMARY KEY (ID_Client)
);

CREATE TABLE Commandes (
  ID_Commande INT,
  ID_Client INT,
  DateCommande DATE,
  DateLivraisonEstimee DATE,
  StatutCommande ENUM('en attente', 'expédiée', 'livrée', 'annulée'),
  PRIMARY KEY (ID_Commande),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client)
);

CREATE TABLE Produits (
  ID_Produit INT,
  NomProduit VARCHAR(255),
  Description TEXT,
  Prix DECIMAL(10, 2),
  StockDisponible BOOL,
  ID_Categorie INT,
  PRIMARY KEY (ID_Produit),
  FOREIGN KEY (ID_Categorie) REFERENCES Categories(ID_Categorie)
);

CREATE TABLE Categories (
  ID_Categorie INT,
  NomCategorie VARCHAR(255),
  PRIMARY KEY (ID_Categorie)
);

CREATE TABLE Notes (
  ID_Note INT,
  ID_Client INT,
  ID_Produit INT,
  Note INT,
  PRIMARY KEY (ID_Note),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

CREATE TABLE Images (
  ID_Image INT,
  ID_Produit INT,
  URLImage VARCHAR(255),
  PRIMARY KEY (ID_Image),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

select * from clients;
SELECT * FROM Produits;

INSERT INTO Produits (ID_Produit, NomProduit, Description, Prix, Stockdisponible, ID_Categorie)
VALUES (12,'Bague en diamant du Wakanda', 'Description inconnue', 99999.99, 0, 1);

update produits set stockdisponible=0 where ID_Categorie=1 ;
