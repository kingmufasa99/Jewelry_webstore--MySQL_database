create database bijoux;
use bijoux;
show tables;

select * from Clients;
SELECT * FROM Produits;
select * from panier;
select * from categories;
select * from produits;
select * from images;

create table produits
(
    ID_Produit      int            not null,
    primary key (ID_Produit),
    NomProduit      varchar(255)   not null,
    Description     text           not null,
    Prix            decimal(10, 2) not null,
    StockDisponible int            not null,
    ID_Categorie    int            not null,
    foreign key (ID_Categorie) references categories (ID_Categorie)
);

create table categories
(
    ID_Categorie int not null,
    primary key (ID_Categorie),
    NomCategorie varchar(255) unique
);

CREATE TABLE Panier (
  ID_Client INT,
  ID_Produit INT,
  Quantite INT,
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client),
  FOREIGN KEY (ID_Produit) REFERENCES Produits(ID_Produit)
);

CREATE TABLE Commandes (
  ID_Commande INTEGER AUTO_INCREMENT,
  ID_Client INt,
  PRIMARY KEY (ID_Commande),
  FOREIGN KEY (ID_Client) REFERENCES Clients(ID_Client)
);

create table clients
(
    ID_Client int not null,
    primary key (ID_Client),
    Nom            varchar(50)  not null,
    Prenom         varchar(50)  not null,
    AdresseEmail   varchar(255) not null unique,
    AdressePostale varchar(255) not null,
    MotDePasse     varchar(255) not null
);


# INDEX Filali999. soyem99@hotmail.com

create index ID_Client
    on panier (ID_Client);

create index ID_Produit
    on panier (ID_Produit);

# faire un trigger qui empeche le stock de devenir negative
CREATE TRIGGER empecher_stock_negatif
BEFORE UPDATE ON produits
FOR EACH ROW
BEGIN
  IF NEW.StockDisponible < 0 THEN
    SET NEW.StockDisponible = 0;
  END IF;
END;

# faire un trigger qui bloque les doublons de email ou les champs vide
CREATE TRIGGER prevent_duplicate_emails_and_empty_fields
BEFORE INSERT ON clients
FOR EACH ROW
BEGIN
    IF NEW.AdresseEmail = '' OR EXISTS (SELECT * FROM Clients WHERE AdresseEmail = NEW.AdresseEmail) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Impossible d\'ajouter ce produit car l\'email est en double ou est vide';
    END IF;
END;

# proc format email verificator

DELIMITER //
CREATE PROCEDURE check_email_format(new_email VARCHAR(255))
BEGIN
  DECLARE valid_email BOOLEAN DEFAULT FALSE;

  IF new_email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
    SET valid_email = TRUE;
  END IF;

  select valid_email;
END //
DELIMITER ;

call check_email_format('mfilali99@hotmail.com');

# proc format mot de passe verificator

DELIMITER //
CREATE PROCEDURE check_password_format(in new_password VARCHAR(255))
BEGIN
  DECLARE valid_password BOOLEAN DEFAULT FALSE;

  IF new_password REGEXP '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$' THEN
    SET valid_password = TRUE;
  END IF;

  return valid_password;
END //
DELIMITER ;

call check_password_format('Filali999.')


INSERT INTO images (ID_Image, ID_Produit, URLImage) VALUES
(1, 1, 'https://example.com/images/bijou1.jpg'),
(2, 2, 'https://example.com/images/bijou1_2.jpg'),
(3, 3, 'https://example.com/images/bijou2.jpg'),
(4, 4, 'https://example.com/images/bijou3.jpg'),
(6, 5, 'https://example.com/images/bijou3_2.jpg'),
(7, 6, 'https://example.com/images/bijou4.jpg'),
(8, 7, 'https://example.com/images/bijou5.jpg');

