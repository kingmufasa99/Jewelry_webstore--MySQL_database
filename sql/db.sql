create database bijoux;
use bijoux;
show tables;

select * from Clients;
SELECT * FROM Produits;


delete from clients where Prenom like '%nadir%';

ALTER TABLE Clients
ADD CONSTRAINT unique_AdresseEmail UNIQUE (AdresseEmail);

