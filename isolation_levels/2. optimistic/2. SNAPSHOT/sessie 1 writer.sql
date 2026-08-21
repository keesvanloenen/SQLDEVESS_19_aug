-- == LET OP: Eenmalige wijziging in de database! ==
ALTER DATABASE AdventureWorksLT2017 SET READ_COMMITTED_SNAPSHOT ON;	-- Optimistic locking 
ALTER DATABASE AdventureWorksLT2017 SET ALLOW_SNAPSHOT_ISOLATION ON; 

-- ================
-- Sessie 1: Writer
-- ================
USE AdventureWorksLT2017;
GO

-- 1. Wijzig data met een UPDATE statement en bekijk het nog niet opgeslagen resultaat
BEGIN TRANSACTION;

-- Het oude record met NULL belandt in de Version Store (in tempdb)
UPDATE SalesLT.Customer
SET MiddleName = 'van der'
WHERE CustomerID = 2;

SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;		-- nog niet opgeslagen in de database

-- Voer stap 2 uit in de andere sessie

-- 3. Maak de wijziging definitief
COMMIT;

-- Voer stap 4 uit in de andere sessie
