-- VOORBEREIDING

DROP TABLE IF EXISTS dbo.Bestelling;
DROP TABLE IF EXISTS dbo.Klant;

CREATE TABLE dbo.Klant (
    KlantId int         NOT NULL,
    Naam    varchar(50) NOT NULL
);

CREATE TABLE dbo.Bestelling (
    BestellingId int           NOT NULL,
    KlantId      int           NOT NULL,
    Bedrag       decimal(10,2) NOT NULL
);
GO

-- 50.000 klanten
SET NOCOUNT ON;

DECLARE @i int = 1;

BEGIN TRANSACTION;		-- TRUC, geen impliciete transactie meer voor elke te inserten rij 😀

WHILE @i <= 50000
BEGIN
    INSERT dbo.Klant (KlantId, Naam)
    VALUES (@i, CONCAT('Klant ', @i));

    SET @i += 1;
END

COMMIT TRANSACTION;
GO

-- 200.000 bestellingen, netjes verdeeld over de klanten
DECLARE @i int = 1;

BEGIN TRANSACTION;

WHILE @i <= 200000
BEGIN
    INSERT dbo.Bestelling (BestellingId, KlantId, Bedrag)
    VALUES (@i, (@i % 50000) + 1, 10.00);

    SET @i += 1;
END

COMMIT TRANSACTION;
GO

-- Controle
SELECT COUNT(*) AS Klanten      FROM dbo.Klant;

SELECT COUNT(*) AS Bestellingen FROM dbo.Bestelling;
GO

-- ----------------------------------------------------------------------------------
-- DEMO 1 - Hash Match
-- Twee heaps, geen enkele index. 
-- Niets is gesorteerd dus SQL Server bouwt een hashtabel op de kleinste input (50.000 Klanten) en
-- jaagt de andere (200.000 Bestellingen) daar doorheen

SELECT k.Naam, b.Bedrag
FROM dbo.Klant k
INNER JOIN dbo.Bestelling b 
ON b.KlantId = k.KlantId;		-- 👈 hash op KlantId

-- ----------------------------------------------------------------------------------
-- DEMO 2 - Nested Loop
-- Indexen erbij én de buitenste input piepklein maken met een filter
-- Bij 10 rijen loont het om per rij een seek te doen

CREATE UNIQUE CLUSTERED INDEX CI_Klant 
ON dbo.Klant (KlantId);

CREATE NONCLUSTERED INDEX NCI_Bestelling_KlantId 
ON dbo.Bestelling (KlantId) 
INCLUDE (Bedrag);	-- Covering index, dag 3

SELECT 
	k.Naam
	, b.Bedrag
FROM dbo.Klant k
INNER JOIN dbo.Bestelling b 
ON b.KlantId = k.KlantId
WHERE k.KlantId BETWEEN 1 AND 10;

-- ----------------------------------------------------------------------------------
-- DEMO 3 - Merge Join
-- Zelfde indexen (allebei hebben index!)
-- Beide inputs zijn nu al fysiek gesorteerd op KlantId, en Klant is uniek op de joinkolom (KlantId).
-- Dan is één keer parallel doorlopen goedkoper dan hashen

SELECT k.Naam, b.Bedrag
FROM dbo.Klant k
JOIN dbo.Bestelling b ON b.KlantId = k.KlantId;

-- Toch een Hash Match? dan viel de kostenschatting net anders uit
-- Forceer hem dan ter vergelijking (dit is in de praktijk 99.999% van de gevallen een slecht idee)

SELECT k.Naam, b.Bedrag
FROM dbo.Klant k
JOIN dbo.Bestelling b 
ON b.KlantId = k.KlantId
OPTION (MERGE JOIN);

-- ----------------------------------------------------------------------------------
-- OPRUIMEN

DROP TABLE IF EXISTS dbo.Bestelling;
DROP TABLE IF EXISTS dbo.Klant;



