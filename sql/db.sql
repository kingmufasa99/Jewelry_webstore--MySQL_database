create database bijoux;
use bijoux;
show tables;

select * from Clients;
SELECT * FROM Produits;


delete from clients where ID_Client=11;

ALTER TABLE Clients
ADD CONSTRAINT unique_AdresseEmail UNIQUE (AdresseEmail);


insert into clients values (18, 'filali', 'mostafa', 'mfilali99@hotmail.com', '6270 rue alesia', 'root');

INSERT INTO clients VALUES (613, 'levi','jean','jean@gmail.com', '666 route de église','$5$rounds=535000$onjTtCxrRzpwGIK.$/VwR61d0jPz9QFuPkqVG2KViNadASUx7gxZaJ9cY/Z5');
# INSERT INTO clients (ID_Clien…8ThDWbAHrX5DrKMvEWqJFTXcPKFB')… failed.
