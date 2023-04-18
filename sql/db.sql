create database bijoux;
use bijoux;
show tables;

select * from Clients;
SELECT * FROM Produits;
select * from panier;
select * from categories;
select * from commandes;
select * from images;

CREATE TABLE images (
  ID_Image int NOT NULL AUTO_INCREMENT,
  ID_Produit int NOT NULL,
  URLImage varchar(255),
  PRIMARY KEY (ID_Image),
  FOREIGN KEY (ID_Produit) REFERENCES produits(ID_Produit)
);

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

# proc format email verificateur

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

# procedure format mot de passe verificateur

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

call check_password_format('Filali999.');

INSERT INTO categories (ID_Categorie, NomCategorie) VALUES (1, 'Collier'),(2, 'Bracelet');

INSERT INTO images (ID_Image, ID_Produit, URLImage) VALUES
(1, 1, 'https://example.com/images/bijou1.jpg'),
(2, 2, 'https://example.com/images/bijou1_2.jpg'),
(3, 3, 'https://example.com/images/bijou2.jpg'),
(4, 4, 'https://example.com/images/bijou3.jpg'),
(6, 5, 'https://example.com/images/bijou3_2.jpg'),
(7, 6, 'https://example.com/images/bijou4.jpg'),
(8, 7, 'https://example.com/images/bijou5.jpg');

insert into produits (ID_Produit, NomProduit, Description, Prix, StockDisponible, ID_Categorie) VALUES (10, 'Bague en or jaune et saphir', 'Bague en or jaune 18 carats sertie d''un saphir de qualité supérieure. Un bijou précieux pour toutes les occasions.', 1299.99, 7, 1),
(11, 'Collier en argent et turquoise', 'Collier en argent sterling 925 avec une pierre de turquoise naturelle. Parfait pour un look boho-chic.', 149.99, 15, 2),
(12, 'Bracelet en or blanc et améthyste', 'Bracelet en or blanc 18 carats serti d''une améthyste de qualité AAA. Un bijou élégant pour toutes les occasions.', 799.99, 10, 1),
(13, 'Boucles d''oreilles en argent et perle de Tahiti', 'Boucles d''oreilles en argent sterling 925 serties de perles de Tahiti de qualité supérieure. Un accessoire élégant pour une soirée spéciale.', 1299.99, 5, 1),
(14, 'Bague en or rose et tourmaline', 'Bague en or rose 18 carats sertie d''une tourmaline rose de qualité AAA. Un bijou élégant et romantique pour toutes les occasions.', 1799.99, 8, 1),
(15, 'Collier en or blanc et saphir', 'Collier en or blanc 18 carats serti d''un saphir de qualité supérieure. Un bijou précieux pour une occasion spéciale.', 1499.99, 4, 2),
(16, 'Boucles d''oreilles en argent et topaze blanche', 'Boucles d''oreilles en argent sterling 925 serties de topazes blanches de qualité AAA. Un bijou simple et élégant pour toutes les occasions.', 499.99, 20, 1),
(17, 'Bracelet en or jaune et diamant', 'Bracelet en or jaune 18 carats serti de diamants de qualité supérieure. Un bijou étincelant pour une soirée élégante.', 3499.99, 2, 1),
(18, 'Collier en argent et pierre de lave', 'Collier en argent sterling 925 avec une pierre de lave naturelle. Parfait pour un look décontracté.', 99.99, 30, 2),
(19, 'Bague en or blanc et tanzanite', 'Bague en or blanc 18 carats sertie d''une tanzanite de qualité AAA. Un bijou précieux pour une occasion spéciale.', 2199.99, 6, 1),
(20, 'Bague en or jaune et améthyste', 'Bague en or jaune 18 carats sertie d''une améthyste de qualité supérieure. Un bijou élégant pour toutes les occasions.', 899.99, 7, 1),
(21, 'Bague en argent et topaze blanche', 'Bague en argent sterling 925 sertie d''une topaze blanche de qualité AAA. Un bijou simple et élégant pour tous les jours.', 149.99, 30, 1),
(22, 'Bague en or blanc et saphir', 'Bague en or blanc 18 carats sertie d''un saphir de qualité supérieure. Un bijou précieux pour une occasion spéciale.', 2499.99, 4, 1),
(23, 'Bague en argent et grenat', 'Bague en argent sterling 925 sertie d''un grenat naturel de qualité supérieure. Un bijou délicat et romantique.', 299.99, 15, 1),
(24, 'Bague en or rose et quartz rose', 'Bague en or rose 18 carats sertie d''un quartz rose naturel. Un bijou doux et féminin pour tous les jours.', 599.99, 10, 1),
(25, 'Bague en argent et turquoise', 'Bague en argent sterling 925 sertie d''une turquoise naturelle. Un bijou bohème chic pour un style décontracté.', 199.99, 20, 1),
(26, 'Bague en or blanc et émeraude', 'Bague en or blanc 18 carats sertie d''une émeraude de qualité supérieure. Un bijou précieux pour une soirée inoubliable.', 2999.99, 3, 1),
(27, 'Bague en argent et onyx noir', 'Bague en argent sterling 925 sertie d''un onyx noir naturel. Un bijou sobre et élégant pour une soirée habillée.', 399.99, 12, 1),
(28, 'Bague en or jaune et citrine', 'Bague en or jaune 18 carats sertie d''une citrine naturelle de qualité supérieure. Un bijou lumineux pour une soirée d''été.', 799.99, 8, 1),
(29, 'Bague en argent et opale', 'Bague en argent sterling 925 sertie d''une opale naturelle. Un bijou délicat et lumineux pour tous les jours.', 149.99, 25, 1),
(31, 'Boucles d''oreilles en argent et turquoise', 'Boucles d''oreilles en argent sterling 925 serties de turquoises de qualité AAA. Un bijou élégant pour ajouter une touche de couleur à votre tenue.', 149.99, 30, 2),
(32, 'Bracelet jonc en or blanc et saphir', 'Bracelet jonc en or blanc 18 carats serti de saphirs de qualité supérieure. Un bijou étincelant pour une occasion spéciale.', 1799.99, 8, 1),
(33, 'Collier en argent et pierre d''agate', 'Collier en argent sterling 925 serti d''une pierre d''agate naturelle. Un bijou unique pour ajouter une touche de couleur à votre tenue.', 299.99, 15, 2),
(34, 'Bague en or jaune et améthyste', 'Bague en or jaune 18 carats sertie d''une améthyste de qualité supérieure. Un bijou élégant pour ajouter une touche de couleur à votre tenue.', 799.99, 7, 1),
(35, 'Bracelet en argent et pierres de lave', 'Bracelet en argent sterling 925 avec des pierres de lave naturelles. Un bijou simple et élégant qui peut être porté au quotidien.', 79.99, 40, 2),
(36, 'Boucles d''oreilles en or blanc et saphir', 'Boucles d''oreilles en or blanc 18 carats serties de saphirs de qualité supérieure. Un accessoire étincelant pour une soirée élégante.', 2199.99, 4, 1),
(37, 'Collier en argent et pierres de zircon', 'Collier en argent sterling 925 serti de zircons cubiques. Un bijou simple et élégant qui peut être porté au quotidien.', 99.99, 30, 2),
(38, 'Bague en or jaune et topaze', 'Bague en or jaune 18 carats sertie de topazes de qualité supérieure. Un bijou élégant pour toutes les occasions.', 899.99, 10, 1),
(39, 'Bracelet en argent et pierres précieuses', 'Bracelet en argent sterling 925 serti de pierres précieuses de différentes couleurs. Un bijou unique pour une occasion spéciale.', 599.99, 12, 1),
(40, 'Collier en or blanc et opale', 'Collier en or blanc 18 carats serti d''une opale de qualité supérieure. Un bijou élégant pour ajouter une touche de couleur à votre tenue.', 1499.99, 5, 1),
(41, 'Collier en or jaune et perles de Tahiti', 'Collier en or jaune 18 carats avec des perles de culture de Tahiti. Un bijou exotique pour une occasion spéciale.', 1499.99, 6, 2),
(42, 'Bague en argent et grenat', 'Bague en argent sterling 925 sertie d''un grenat naturel. Un bijou coloré pour égayer votre journée.', 249.99, 15, 1),
(43, 'Bracelet en or blanc et diamants noirs', 'Bracelet en or blanc 14 carats serti de diamants noirs naturels. Un bijou sophistiqué pour une soirée élégante.', 2499.99, 5, 1),
(44, 'Boucles d''oreilles en argent et améthyste', 'Boucles d''oreilles en argent sterling 925 serties d''améthystes de qualité AAA. Un bijou élégant pour toutes les occasions.', 399.99, 10, 1),
(45, 'Collier en or rose et opale', 'Collier en or rose 14 carats serti d''une opale naturelle de qualité supérieure. Un bijou unique pour une occasion spéciale.', 899.99, 8, 2),
(46, 'Bague en argent et tourmaline', 'Bague en argent sterling 925 sertie d''une tourmaline naturelle. Un bijou coloré pour égayer votre journée.', 299.99, 12, 1),
(47, 'Boucles d''oreilles en or blanc et saphir', 'Boucles d''oreilles en or blanc 18 carats serties de saphirs de qualité supérieure. Un bijou précieux pour une soirée inoubliable.', 1799.99, 4, 1),
(48, 'Bracelet en argent et perles d''eau douce', 'Bracelet en argent sterling 925 avec des perles d''eau douce. Un bijou élégant pour toutes les occasions.', 149.99, 20, 2),
(49, 'Collier en or jaune et pierre de lune', 'Collier en or jaune 14 carats serti d''une pierre de lune naturelle. Un bijou délicat et romantique.', 699.99, 10, 2),
(50, 'Bague en argent et topaze blanche', 'Bague en argent sterling 925 sertie de topazes blanches de qualité AAA. Un bijou élégant pour toutes les occasions.', 199.99, 18, 1),
(51, 'Bague en or jaune et émeraude', 'Bague en or jaune 18 carats sertie d''une émeraude de qualité AAA. Un bijou précieux pour toutes les occasions.', 1999.99, 7, 1),
(52, 'Collier en argent et perle d''eau douce', 'Collier en argent sterling 925 avec une perle d''eau douce de qualité AAA. Un bijou simple mais élégant pour toutes les occasions.', 129.99, 30, 2),
(53, 'Bracelet en or blanc et diamant', 'Bracelet en or blanc 18 carats serti de diamants de qualité supérieure. Un bijou étincelant pour une soirée élégante.', 3999.99, 2, 1),
(54, 'Boucles d''oreilles en argent et pierre de lune', 'Boucles d''oreilles en argent sterling 925 serties de pierres de lune naturelles. Un bijou délicat et romantique.', 599.99, 10, 1),
(55, 'Collier en or blanc et saphir', 'Collier en or blanc 18 carats serti de saphirs de qualité AAA. Un bijou précieux pour toutes les occasions.', 2799.99, 5, 1),
(56, 'Bague en argent et améthyste', 'Bague en argent sterling 925 sertie d''une améthyste de qualité AAA. Un bijou élégant pour toutes les occasions.', 149.99, 20, 1),
(57, 'Boucles d''oreilles en or rose et topaze', 'Boucles d''oreilles en or rose 18 carats serties de topazes de qualité AAA. Un bijou élégant pour toutes les occasions.', 799.99, 8, 1),
(58, 'Bracelet jonc en argent et opale', 'Bracelet jonc en argent sterling 925 serti d''opales de qualité AAA. Un bijou simple mais élégant qui s''adapte à tous les styles.', 249.99, 15, 1),
(59, 'Bague en or blanc et saphir rose', 'Bague en or blanc 18 carats sertie d''un saphir rose de qualité AAA. Un bijou précieux pour toutes les occasions.', 3499.99, 3, 1),
(60, 'Collier en argent et pendentif en quartz rose', 'Collier en argent sterling 925 avec un pendentif en quartz rose naturel. Un bijou simple mais élégant pour toutes les occasions.', 89.99, 35, 2),
(61, 'Boucles d''oreilles en argent et améthyste', 'Boucles d''oreilles en argent sterling 925 serties d''améthystes de qualité AAA. Un bijou élégant pour une soirée spéciale.', 349.99, 7, 1),
(62, 'Collier en or blanc et saphir rose', 'Collier en or blanc 18 carats serti de saphirs roses de qualité supérieure. Un bijou unique pour une occasion spéciale.', 1999.99, 4, 1),
(63, 'Bracelet jonc en argent et perle de Tahiti', 'Bracelet jonc en argent sterling 925 serti d''une perle de Tahiti de qualité AAA. Un bijou élégant pour toutes les occasions.', 799.99, 10, 2),
(64, 'Bague en or jaune et opale', 'Bague en or jaune 18 carats sertie d''une opale naturelle de qualité supérieure. Un bijou délicat et élégant.', 899.99, 6, 1),
(65, 'Collier en argent et perles de rocaille', 'Collier en argent sterling 925 avec des perles de rocaille de différentes couleurs. Parfait pour un style décontracté ou pour les occasions spéciales.', 149.99, 30, 2),
(66, 'Bracelet en argent et pierre de lune', 'Bracelet en argent sterling 925 serti d''une pierre de lune naturelle. Un bijou délicat et romantique.', 299.99, 12, 1),
(67, 'Boucles d''oreilles en or blanc et topaze', 'Boucles d''oreilles en or blanc 18 carats serties de topazes bleues de qualité supérieure. Un accessoire étincelant pour une soirée élégante.', 899.99, 3, 1),
(68, 'Bague en argent et grenat', 'Bague en argent sterling 925 sertie de grenats de qualité AAA. Un bijou élégant pour toutes les occasions.', 449.99, 8, 1),
(69, 'Collier en or rose et diamants', 'Collier en or rose 18 carats serti de diamants de qualité supérieure. Un bijou précieux pour une soirée inoubliable.', 2599.99, 2, 1),
(70, 'Bracelet en argent et zircons', 'Bracelet en argent sterling 925 serti de zircons cubiques. Un bijou simple mais élégant qui s''adapte à tous les styles.', 199.99, 20, 2),
(71, 'Bague en or jaune et saphir', 'Bague en or jaune 18 carats sertie d''un saphir de qualité supérieure. Un bijou précieux pour une occasion spéciale.', 1999.99, 7, 1),
(72, 'Bracelet en argent et améthyste', 'Bracelet en argent sterling 925 serti d''améthystes de qualité AAA. Un bijou élégant pour toutes les occasions.', 799.99, 10, 1),
(73, 'Bague en or rose et morganite', 'Bague en or rose 18 carats sertie d''une morganite de qualité supérieure. Un bijou unique pour une occasion spéciale.', 1499.99, 5, 1),
(74, 'Collier en argent et zircons', 'Collier en argent sterling 925 serti de zircons cubiques. Un bijou simple mais élégant qui s''adapte à tous les styles.', 249.99, 30, 2),
(75, 'Bracelet en or jaune et perles de Tahiti', 'Bracelet en or jaune 18 carats avec des perles de Tahiti. Un bijou élégant pour une occasion spéciale.', 2999.99, 3, 1),
(76, 'Boucles d''oreilles en argent et pierres précieuses', 'Boucles d''oreilles en argent sterling 925 serties de pierres précieuses de différentes couleurs. Un bijou unique pour toutes les occasions.', 1399.99, 8, 1),
(77, 'Bague en or blanc et saphir rose', 'Bague en or blanc 18 carats sertie d''un saphir rose de qualité supérieure. Un bijou précieux pour une occasion spéciale.', 2999.99, 4, 1),
(78, 'Collier en argent et perles d''eau douce', 'Collier en argent sterling 925 avec des perles d''eau douce. Parfait pour un style décontracté ou pour les occasions spéciales.', 399.99, 20, 2),
(79, 'Boucles d''oreilles en or jaune et émeraudes', 'Boucles d''oreilles en or jaune 18 carats serties d''émeraudes de qualité supérieure. Un bijou précieux pour une soirée inoubliable.', 1899.99, 6, 1),
(80, 'Bracelet en argent et pierres de lune', 'Bracelet en argent sterling 925 serti de pierres de lune naturelles. Un bijou délicat et romantique.', 299.99, 15, 1),
(81, 'Bracelet en argent et pierres de lune', 'Bracelet en argent sterling 925 serti de pierres de lune naturelles de qualité supérieure. Un bijou délicat pour une tenue élégante.', 299.99, 10, 1),
(82, 'Boucles d''oreilles en or rose et quartz', 'Boucles d''oreilles en or rose 18 carats serties de quartz de qualité supérieure. Un bijou élégant et sophistiqué pour toutes les occasions.', 1499.99, 7, 1),
(83, 'Collier en argent et perle d''eau douce', 'Collier en argent sterling 925 avec une perle d''eau douce de qualité supérieure. Un bijou classique pour tous les styles.', 399.99, 15, 2),
(84, 'Bague en or jaune et améthyste', 'Bague en or jaune 18 carats sertie d''une améthyste de qualité supérieure. Un bijou coloré pour toutes les occasions.', 699.99, 5, 1),
(85, 'Bracelet jonc en argent et améthyste', 'Bracelet jonc en argent sterling 925 serti d''améthystes de qualité supérieure. Un bijou élégant pour toutes les occasions.', 399.99, 12, 1),
(86, 'Collier en or blanc et diamant noir', 'Collier en or blanc 18 carats serti de diamants noirs de qualité supérieure. Un bijou unique pour une soirée élégante.', 2599.99, 3, 1),
(87, 'Boucles d''oreilles en argent et diamant', 'Boucles d''oreilles en argent sterling 925 serties de diamants de qualité supérieure. Un bijou étincelant pour une soirée élégante.', 799.99, 8, 1),
(88, 'Bague en or blanc et saphir rose', 'Bague en or blanc 18 carats sertie d''un saphir rose de qualité supérieure. Un bijou élégant pour une soirée inoubliable.', 1499.99, 6, 1),
(89, 'Collier en argent et topaze', 'Collier en argent sterling 925 serti de topazes de qualité supérieure. Un bijou élégant pour toutes les occasions.', 599.99, 10, 2),
(90, 'Bague en or jaune et émeraude', 'Bague en or jaune 18 carats sertie d''une émeraude de qualité supérieure. Un bijou coloré pour une occasion spéciale.', 1199.99, 4, 1),
(91, 'Bague en or blanc et émeraude', 'Bague en or blanc 18 carats sertie d''une émeraude de qualité AAA. Un bijou élégant pour toutes les occasions.', 2499.99, 7, 1),
(92, 'Bracelet en argent et améthyste', 'Bracelet en argent sterling 925 serti d''améthystes de qualité AAA. Un bijou élégant pour toutes les occasions.', 899.99, 10, 1),
(93, 'Boucles d''oreilles en or rose et diamant', 'Boucles d''oreilles en or rose 18 carats serties de diamants de qualité supérieure. Un accessoire étincelant pour une soirée élégante.', 2199.99, 4, 1),
(94, 'Collier en argent et perle de Tahiti', 'Collier en argent sterling 925 avec une perle de Tahiti de qualité AAA. Un bijou élégant pour toutes les occasions.', 1199.99, 6, 2),
(95, 'Bague en or jaune et saphir', 'Bague en or jaune 18 carats sertie d''un saphir de qualité AAA. Un bijou élégant pour toutes les occasions.', 1699.99, 8, 1),
(96, 'Bracelet en argent et grenat', 'Bracelet en argent sterling 925 serti de grenats de qualité AAA. Un bijou élégant pour toutes les occasions.', 799.99, 12, 1),
(97, 'Boucles d''oreilles en or blanc et saphir', 'Boucles d''oreilles en or blanc 18 carats serties de saphirs de qualité AAA. Un accessoire étincelant pour une soirée élégante.', 2399.99, 5, 1),
(98, 'Collier en or blanc et rubis', 'Collier en or blanc 18 carats serti de rubis de qualité AAA. Un bijou élégant pour toutes les occasions.', 1999.99, 9, 2),
(99, 'Bague en argent et zircon', 'Bague en argent sterling 925 sertie de zircons cubiques. Un bijou simple mais élégant qui s''adapte à tous les styles.', 149.99, 30, 1),
;