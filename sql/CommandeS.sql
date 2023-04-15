-- creation du base des données
CREATE DATABASE projetbijoux3;
USE projetbijoux3;



-- creation du tableau Clients
CREATE TABLE Clients (
  ID_Client INT AUTO_INCREMENT,
  Nom VARCHAR(50),
  Prenom VARCHAR(50),
  AdresseEmail VARCHAR(255),
  AdressePostale VARCHAR(255),
  MotDePasse VARCHAR(255),
  PRIMARY KEY (ID_Client)
);

-- ajouter une constraint "UNIQUE" a l'adress mail pour que chaque utilisateur n'avoir q'un seule compte 
ALTER TABLE Clients
ADD CONSTRAINT unique_AdresseEmail UNIQUE (AdresseEmail);

-- creation du tableaux commandes
CREATE TABLE Commandes (
  ID_Commande INT AUTO_INCREMENT,
  ID_Client INT,
  ID_Produit INT,
  Quantite INT,
  DateCommande DATE,
  DateLivraisonEstimee DATE,
  StatutCommande ENUM('en attente', 'expédiée', 'livrée', 'annulée'),
  PRIMARY KEY (ID_Commande),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit));

-- creation du tableau categories
CREATE TABLE Categories (
  ID_Categorie INT AUTO_INCREMENT,
  NomCategorie VARCHAR(255),
  PRIMARY KEY (ID_Categorie));

CREATE INDEX Nom_Categorie
ON Categories (NomCategorie);

-- creation du tableau produits
CREATE TABLE Produits (
  ID_Produit INT AUTO_INCREMENT,
  NomProduit VARCHAR(255),
  Description TEXT,
  Prix DECIMAL(10, 2),
  StockDisponible INT,
  ID_Categorie INT,
  PRIMARY KEY (ID_Produit),
  FOREIGN KEY (ID_Categorie) REFERENCES Categories(ID_Categorie)
);

ALTER TABLE Produits
ADD CONSTRAINT unique_NomProduit UNIQUE (NomProduit);

CREATE INDEX chercher_prix
ON Produits (prix);

CREATE INDEX chercher_par_Categorie
ON Produits (ID_Categorie);

CREATE INDEX chercher_par_nom
ON Produits (NomProduit);
-- creation d'une indexation sur la colomn "ID_Categorie" dans la tableau "Produis" 



-- creation d'un tableau commentaires
CREATE TABLE Commentaires (
  ID_Commentaire INT AUTO_INCREMENT,
  ID_Client INT,
  ID_Produit INT,
  Note INT,
  Commentaire TEXT,
  PRIMARY KEY (ID_Commentaire),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

-- Creation du tableau Images
CREATE TABLE Images (
  ID_Image INT AUTO_INCREMENT,
  ID_Produit INT,
  URLImage VARCHAR(255),    -- ajout du URL colomn
  PRIMARY KEY (ID_Image),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

-- Creation du tableau recherche table
CREATE TABLE tableau_recherche (
  ID_recherche INT AUTO_INCREMENT,
  ID_Produit INT,
  info_recherche VARCHAR(4000),
  PRIMARY KEY (ID_recherche),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

INSERT INTO Categories (ID_Categorie, NomCategorie)
VALUES 
(1, 'Bijoux en or'),
(2, 'Bijoux en argent');

INSERT INTO Produits (ID_Produit, NomProduit, Description, Prix, StockDisponible, ID_Categorie)
VALUES 
(1, 'Bague en or blanc et diamant', 'Bague en or blanc 18 carats sertie d''un diamant de qualité supérieure.', 1499.99, 10, 1),
(2, 'Collier en argent et perles de culture', 'Collier en argent sterling 925 avec des perles de culture d''eau douce. Parfait pour un style décontracté ou pour les occasions spéciales.', 299.99, 20, 2),
(3, 'Bracelet en argent et topaze bleue', 'Bracelet en argent sterling 925 serti de topazes bleues de qualité AAA. Un bijou élégant pour toutes les occasions.', 599.99, 15, 1),
(4, 'Boucles d''oreilles en or blanc et diamant', 'Boucles d''oreilles en or blanc 18 carats serties de diamants de qualité supérieure. Un accessoire étincelant pour une soirée élégante.', 1899.99, 5, 1),
(5, 'Bracelet jonc en argent et zircon', 'Bracelet jonc en argent sterling 925 serti de zircons cubiques. Un bijou simple mais élégant qui s''adapte à tous les styles.', 149.99, 25, 2),
(6, 'Collier en or rose et pierres précieuses', 'Collier en or rose 18 carats serti de pierres précieuses de différentes couleurs. Un bijou unique pour une occasion spéciale.', 899.99, 8, 1),
(7, 'Bague en argent et pierre de lune', 'Bague en argent sterling 925 sertie d''une pierre de lune naturelle. Un bijou délicat et romantique.', 399.99, 12, 1),
(8, 'Boucles d''oreilles en or jaune et rubis', 'Boucles d''oreilles en or jaune 18 carats serties de rubis de qualité supérieure. Un bijou précieux pour une soirée inoubliable.', 2599.99, 3, 1),
(9, 'Collier en argent et cristal de Swarovski', 'Collier en argent sterling 925 serti de cristaux de Swarovski de qualité supérieure. Un bijou étincelant pour une soirée élégante.', 499.99, 18, 2);






INSERT INTO Images values (1,1, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\1\1-Bague en or blanc et diamant.jpg'));
INSERT INTO Images values (2,2, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\2\2-Collier en argent et perles de culture.jpg'));
INSERT INTO Images values (3,3, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\3\3-Bracelet en argent et topaze bleue.jpg'));
INSERT INTO Images values (4,4, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\4\4-Boucles d''oreilles en or blanc et diamant.jpg'));
INSERT INTO Images values (5,5, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\5\5-Bracelet jonc en argent et zircon.jpg'));
INSERT INTO Images values (6,6, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\6\6-Collier en or rose et pierres précieuses.jpg'));
INSERT INTO Images values (7,7, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\7\7-Bague en argent et pierre de lune.jpg'));
INSERT INTO Images values (8,8, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\8\8-Boucles d''oreilles en or jaune et rubis.jpg'));
INSERT INTO Images values (9,9, load_file('C:\Users\administrateur\Desktop\PROJET-B-SQL\image\9\9-Collier en argent et cristal de Swarovski.jpg'));

SELECT * FROM Images;

-- les procedures

---------------------------------------------------------------------------------------------------
DELIMITER //

-- ajouter un client :Cette procédure insère un nouveau client dans la table Clients.
CREATE PROCEDURE AjouterClient(
  IN p_Nom VARCHAR(50),
  IN p_Prenom VARCHAR(50),
  IN p_AdresseEmail VARCHAR(255),
  IN p_AdressePostale VARCHAR(255),
  IN p_MotDePasse VARCHAR(255)
)
BEGIN
  INSERT INTO Clients (Nom, Prenom, AdresseEmail, AdressePostale, MotDePasse)
  VALUES (p_Nom, p_Prenom, p_AdresseEmail, p_AdressePostale, p_MotDePasse);
END //
DELIMITER ;

---------------------------------------------------------------------------------------------------
DELIMITER //

-- ajouter produit: Cette procédure insère un nouveau produit dans la table Produits.
CREATE PROCEDURE AjouterProduit(
  IN p_NomProduit VARCHAR(255),
  IN p_Description TEXT,
  IN p_Prix DECIMAL(10, 2),
  IN p_StockDisponible INT,
  IN p_ID_Categorie INT
)
BEGIN
  INSERT INTO Produits (NomProduit, Description, Prix, StockDisponible, ID_Categorie)
  VALUES (p_NomProduit, p_Description, p_Prix, p_StockDisponible, p_ID_Categorie);
END //
DELIMITER ;
---------------------------------------------------------------------------------------------------
/*     faire un nouveau ordre / Ajouter nouveau Commande   */ 

DELIMITER //
CREATE PROCEDURE AjouterCommande(
  IN p_ID_Client INT,
  IN p_DateCommande DATE,
  IN p_DateLivraisonEstimee DATE,
  IN p_StatutCommande ENUM('en attente', 'expédiée', 'livrée', 'annulée')
)
BEGIN
  INSERT INTO Commandes (ID_Client, DateCommande, DateLivraisonEstimee, StatutCommande)
  VALUES (p_ID_Client, p_DateCommande, p_DateLivraisonEstimee, p_StatutCommande);
END //
DELIMITER ;

---------------------------------------------------------------------------------------------------
/*     Obtenir une liste de produits par catégorie    */

DELIMITER //
CREATE PROCEDURE ObtenuProduitParCategorie(
  IN p_ID_Categorie INT
)
BEGIN
  SELECT * FROM Produits
  WHERE ID_Categorie = p_ID_Categorie;
END //
DELIMITER ;

DELIMITER //

---------------------------------------------------------------------------------------------------

DELIMITER //
/*Mise a jour du statut de la commande :Cette procédure met à 
jour le statut d'une commande dans la table Commandes.   */

CREATE PROCEDURE MiseAjourStatut(
  IN p_ID_Commande INT,
  IN p_StatutCommande ENUM('en attente', 'expédiée', 'livrée', 'annulée')
)
BEGIN
  UPDATE Commandes
  SET StatutCommande = p_StatutCommande
  WHERE ID_Commande = p_ID_Commande;
END //
DELIMITER ;


---------------------------------------------------------------------------------------------------
DELIMITER //

/*recherche du produit :
 Cette procédure recherche des produits a partir de son 
 nom ou la description du produit   */
 
CREATE PROCEDURE RechercheProduit(
  IN info_recherche VARCHAR(255)
)
BEGIN
  SELECT * FROM Produits
  WHERE NomProduit LIKE CONCAT('%', info_recherche, '%')
  OR Description LIKE CONCAT('%', info_recherche, '%');
END //
DELIMITER ;

---------------------------------------------------------------------------------------------------

--Cette gâchette permet de sélectionner les produits dont le prix est compris entre une fourchette de prix spécifiée

DELIMITER //
CREATE PROCEDURE rechercher_par_fourchette_de_prix(INT min_prix FLOAT, INT max_prix FLOAT)
BEGIN
  SELECT * FROM Produits
  WHERE prix >= @min_prix AND prix <= @max_prix;
END //
DELIMITER ;
---------------------------------------------------------------------------------------------------
DELIMITER //

/* btenir les commentaires sur un proudit
Cette procédure récupère tous les commentaires liés à un produit spécifique ainsi que 
les informations du client qui a publié le commentaire.   */

CREATE PROCEDURE ObtenirCommentaireProduit(
  IN p_ID_Produit INT
)
BEGIN
  SELECT c.ID_Commentaire, c.ID_Client, cl.Nom, cl.Prenom, c.ID_Produit, c.Note, c.Commentaire
  FROM Commentaires c
  JOIN Clients cl ON c.ID_Client = cl.ID_Client
  WHERE c.ID_Produit = p_ID_Produit;
END //

DELIMITER ;
--------------------------------------------------------------------------------
/*      Mettre à jour le stock produit après une commande       */


DELIMITER //
CREATE TRIGGER miseAjourStock AFTER INSERT ON Commandes
FOR EACH ROW
BEGIN
  UPDATE Produits
  SET StockDisponible = StockDisponible - NEW.Quantite
  WHERE ID_Produit = NEW.ID_Produit;
END;
DELIMITER ;
---------------------------------------------------------------------------------------------------

--Cette gachette est conçu pour appliquer un montant minimum de commande de 100 $ pour 
---les nouvelles commandes insérées dans la table Commandes

DELIMITER //

CREATE TRIGGER montant_minimum_commande BEFORE INSERT ON Commandes
FOR EACH ROW
BEGIN
  DECLARE commande_total DECIMAL(10, 2);
  SELECT SUM(Prix * Quantite) INTO order_total
  FROM Produits
  WHERE ID_Produit IN (SELECT ID_Produit FROM Commandes WHERE ID_Commande = NEW.ID_Commande);
  
  IF (commande_total < 100) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Minimum order amount is $50';
  END IF;
END;

DELIMITER ;
----------------------------------------------------------------------------------------------------
---pour envoyer un e-mail au client lorsque sa commande est expédiée :

DELIMITER  //
CREATE TRIGGER envoyer_notification_expedition AFTER UPDATE OF StatutCommande ON Commandes
FOR EACH ROW
BEGIN
  IF (OLD.StatutCommande = 'en attente' AND NEW.StatutCommande = 'expédiée') THEN
    DECLARE client_email VARCHAR(255);
    DECLARE client_nom VARCHAR(100);
    SELECT AdresseEmail, CONCAT(Prenom, ' ', Nom) INTO client_email, client_nom
    FROM Clients
    WHERE ID_Client = NEW.ID_Client;
    
    SET @sujet = 'Votre commande a été expédiée';
    SET @corp = CONCAT('Bonjour ', client_nom, ',\n\nVotre commande a été expédiée. Merci pour votre achat !');
    SET @entete = CONCAT('From: ServiceClientBBijoux@BBijoux.com', '\r\n', 'Reply-To: ServiceClientBBijoux@BBijoux.com');
    
    ---call pour envoie de courriel , il faut un operateur 
  END IF;
END;
DELIMITER  ;

----------------------------------------------------------------------------------------------------
/*     TEST        */

-- afficher le contenu de tous les tableaux
SELECT * FROM Clients;
SELECT * FROM Commandes;
SELECT * FROM Categories;
SELECT * FROM Produits;
SELECT * FROM Commentaires;
SELECT * FROM Images;
SELECT * FROM tableau_recherche;

-- call des procedures

CALL rechercher_par_fourchette_de_prix(5,100)

CALL AjouterClient('Hajar', 'ULAVAL', 'hajar@gmail.com', '123 canada', '123456789');


CALL AjouterProduit('bague diamond', 'bague diamond brillante.', 4000.00, 5, 1);


CALL AjouterCommande(1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'en attente');


CALL ObtenuProduitParCategorie(1);


CALL MiseAjourStatut(1, 'expédiée');


CALL SupprimerProduitParId(9);


CALL RechercheProduit('Ring');


CALL ObtenirCommandClient(1);


CALL ObtenirCommentaireProduit(1);


CALL miseAjourStock(1, 2);

CALL SendGrid.Email(from='ServiceClientBBijoux@BBijoux.com', to=client_email, subject=@sujet, body=@corp_texte, header=@entete);


-- afficher le contenu du tableau apres le call des procedures
SELECT * FROM Clients;
SELECT * FROM Commandes;
SELECT * FROM Categories;
SELECT * FROM Produits;
SELECT * FROM Commentaires;
SELECT * FROM Images;
SELECT * FROM tableau_recherche;




