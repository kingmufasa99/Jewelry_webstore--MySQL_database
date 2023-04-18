create database bijoux;
use bijoux;
show tables;

select DATA_TYPE FROM INFORMATION_SCHEMA. COLUMNS WHERE table_schema = 'bijoux' AND table_name = 'produits';

delete from clients where Prenom like '%nadir%';

SELECT * FROM produits;

CREATE TABLE Panier (
  ID_Client INT,
  ID_Produit INT,
  Quantite INT,
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

CREATE TABLE Commandes (
  ID_Commande INTEGER AUTO_INCREMENT,
  ID_Client INT,
  PRIMARY KEY (ID_Commande),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client)
);

ALTER TABLE produits
MODIFY COLUMN StockDisponible INT;

