create database bijoux;
use bijoux;
show tables;

select * from Clients;
SELECT * FROM Produits;

delete from clients where ID_Client=14;

ALTER TABLE Clients
ADD CONSTRAINT unique_AdresseEmail UNIQUE (AdresseEmail);


insert into clients values (14, 'filali', 'mostafa', 'mfilali99@hotmail.com', '6270 rue alesia', 'naruto');



