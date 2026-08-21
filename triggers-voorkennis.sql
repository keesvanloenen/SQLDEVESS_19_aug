   USE tempdb;
   GO

   -- Om triggers te begrijpen is het handig kennis te hebben van:
   -- 1. EXISTS
   -- 2. de 2 virtuele tabellen

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

-- EXISTS

SELECT d.*
FROM Deelnemers AS d
INNER JOIN Vips As v
ON d.Naam = v.Naam;

SELECT *
FROM Deelnemers AS d
WHERE d.Naam IN
(
	SELECT Naam
	FROM Vips AS v
);

SELECT *
FROM Deelnemers AS d
WHERE EXISTS
(
	SELECT 1
	FROM Vips AS v
	WHERE v.Naam = d.Naam
);

-- Virtuele tabellen
INSERT INTO Deelnemers
OUTPUT inserted.Naam
INTO LogTabel(GebruikersNaam)
VALUES
('Lisa', 'Arnhem');

CREATE TABLE LogTabel
(
	GebruikersNaam nvarchar(75) NOT NULL
);

DELETE FROM Deelnemers
OUTPUT deleted.Naam
INTO LogTabel(GebruikersNaam)
WHERE Naam = 'Mike';

SELECT * FROM LogTabel

--UPDATE Deelnemers
--SET Naam = 'Lucky Luuk'
--WHERE Naam = 'Luuk';

UPDATE Deelnemers
SET Naam = 'Lucky Luuk'
OUTPUT deleted.*, inserted.*
WHERE Naam = 'Luuk';

UPDATE Deelnemers
SET Naam = 'Look'
OUTPUT CONCAT_WS(' ', inserted.Naam, '(gewijzigd)')
INTO LogTabel(GebruikersNaam)
WHERE Naam = 'Luuk';

SELECT * FROM LogTabel