create database bijoux;
use bijoux;
show tables;

select * from Clients;
SELECT * FROM Produits;


delete from clients where Prenom like '%nadir%';

ALTER TABLE Clients
ADD CONSTRAINT unique_AdresseEmail UNIQUE (AdresseEmail);

CREATE TABLE Panier (
  ID_Client INT,
  ID_Produit INT,
  Quantite INT,
  PRIMARY KEY (ID_Client),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

CREATE TABLE Commandes (
  ID_Commande INTEGER AUTO_INCREMENT,
  ID_Client INT,
  PRIMARY KEY (ID_Commande),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client)
);
