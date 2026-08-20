USE tempdb;
   GO

   DROP TABLE IF EXISTS Deelnemers;
   DROP TABLE IF EXISTS VIPs;
   GO

   CREATE TABLE Deelnemers
   (
       Id      int IDENTITY PRIMARY KEY,
       Naam    nvarchar(75) NOT NULL,
       Plaats  nvarchar(250) NULL
   );
   GO

   -- Voeg alle deelnemers toe:
   INSERT INTO Deelnemers
   VALUES
   ('Mike', 'Deventer'),
   ('Luuk', 'Ede'),
   ('Kees', 'Hilversum'),
   ('Anna', 'Urk');
   GO

   CREATE TABLE VIPs
   (
       Naam    nvarchar(75) NOT NULL
   );
   GO

   INSERT INTO VIPs
   VALUES
   ('Mike'), ('Luuk');
   GO

   SELECT * FROM Deelnemers;
   SELECT * FROM VIPs;