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
  ID_Commande INTEGER AUTO_INCREMENT,
  ID_Client INT,
  PRIMARY KEY (ID_Commande),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client)
);

CREATE TABLE Produits (
  ID_Produit INT,
  NomProduit VARCHAR(255),
  Description TEXT,
  Prix DECIMAL(10, 2),
  StockDisponible INT,
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

CREATE TABLE Panier (
  ID_Panier INTEGER AUTO_INCREMENT,
  ID_Client INT,
  ID_Produit INT,
  Quantite INT,
  PRIMARY KEY (ID_Panier),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

INSERT INTO Clients (ID_Client, Nom, Prenom, AdresseEmail, AdressePostale, MotDePasse)
VALUES (1, 'Doe', 'John', 'john.doe@email.com', '123 Main St', 'password');

INSERT INTO Commandes (ID_Commande, ID_Client, DateCommande, DateLivraisonEstimee, StatutCommande)
VALUES (1, 1, '2023-04-11', '2023-04-15', 'en attente');

INSERT INTO Produits (ID_Produit, NomProduit, Description, Prix, Stockdisponible, ID_Categorie)
VALUES (1, 'Bague en or blanc et diamant', 'Bague en or blanc 18 carats sertie d''un diamant de qualité supérieure.', 1499.99, 10, 1);

INSERT INTO Produits (ID_Produit, NomProduit, Description, Prix, Stockdisponible, ID_Categorie)
VALUES (2, 'Collier en argent et perles de culture', 'Collier en argent sterling 925 avec des perles de culture d''eau douce. Parfait pour un style décontracté ou pour les occasions spéciales.', 299.99, 20, 2);

INSERT INTO Produits (ID_Produit, NomProduit, Description, Prix, Stockdisponible, ID_Categorie)
VALUES (3, 'Bracelet en argent et topaze bleue', 'Bracelet en argent sterling 925 serti de topazes bleues de qualité AAA. Un bijou élégant pour toutes les occasions.', 599.99, 15, 1);

INSERT INTO Categories (ID_Categorie, NomCategorie)
VALUES (1, 'Bague');

INSERT INTO Categories (ID_Categorie, NomCategorie)
VALUES (2, 'Collier');

INSERT INTO Categories (ID_Categorie, NomCategorie)
VALUES (3, 'Bracelet');












-- (2, 'Collier en argent et perles de culture', 'Collier en argent sterling 925 avec des perles de culture d''eau douce. Parfait pour un style décontracté ou pour les occasions spéciales.', 299.99, 20, 2),
-- (3, 'Bracelet en argent et topaze bleue', 'Bracelet en argent sterling 925 serti de topazes bleues de qualité AAA. Un bijou élégant pour toutes les occasions.', 599.99, 15, 1),
-- (4, 'Boucles d''oreilles en or blanc et diamant', 'Boucles d''oreilles en or blanc 18 carats serties de diamants de qualité supérieure. Un accessoire étincelant pour une soirée élégante.', 1899.99, 5, 1),
-- (5, 'Bracelet jonc en argent et zircon', 'Bracelet jonc en argent sterling 925 serti de zircons cubiques. Un bijou simple mais élégant qui s''adapte à tous les styles.', 149.99, 25, 2),
-- (6, 'Collier en or rose et pierres précieuses', 'Collier en or rose 18 carats serti de pierres précieuses de différentes couleurs. Un bijou unique pour une occasion spéciale.', 899.99, 8, 1),
-- (7, 'Bague en argent et pierre de lune', 'Bague en argent sterling 925 sertie d''une pierre de lune naturelle. Un bijou délicat et romantique.', 399.99, 12, 1),
-- (8, 'Boucles d''oreilles en or jaune et rubis', 'Boucles d''oreilles en or jaune 18 carats serties de rubis de qualité supérieure. Un bijou précieux pour une soirée inoubliable.', 2599.99, 3, 1),
-- (9, 'Collier en argent et cristal de Swarovski', 'Collier en argent sterling 925 serti de cristaux de Swarovski de qualité supérieure. Un bijou étincelant pour une soirée élégante.', 499.99, 18, 2),
-- (10, 'Bracelet en or jaune et perles de culture', 'Bracelet en or jaune 18 carats avec des perles de culture d''eau douce. Un bijou classique pour toutes les occasions.', 799.99, 10, 1),
-- (11, 'Bague en argent et améthyste', 'Bague en argent sterling 925 sertie d''une améthyste de qualité AAA. Un bijou élégant pour une soirée habillée.', 499.99, 7, 1);
