-- ==========================
-- Sessie 2: Reader en Writer
-- ==========================

USE AdventureWorksLT2017;
GO

-- 2. Met het SNAPSHOT isolation level worden read stability gegarandeerd.
-- Er worden geen shared locks aangevraagd. We krijgen simpelweg de data uit de 'Version Store' gedurende de gehele transactie

SET TRANSACTION ISOLATION LEVEL SNAPSHOT

BEGIN TRANSACTION;

SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;	-- NULL uit de version store
GO

-- Voer stap 3 uit in de andere sessie

-- 4. Herhaal de leesactie 
SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;	-- Nog steeds NULL uit de version store
GO

-- Onderstaand leidt tot de beroemde 3960 error (update conflict)
-- Er vindt ook een ROLLBACK van de actie plaats
UPDATE SalesLT.Customer
SET MiddleName = 'van'
WHERE CustomerID = 2;

-- Probeer het nog een keer
UPDATE SalesLT.Customer
SET MiddleName = 'van'
WHERE CustomerID = 2;

-- Check het resultaat
SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;

-- Reset de waarde voor een volgende demo
UPDATE SalesLT.Customer
SET MiddleName = NULL
WHERE CustomerID = 2;

-- Zet beide OPTIMISTIC ISOLATION LEVELS uit via de interface: AdventureWorks, Properties:
-- Is Read Committed Snapshot On
-- Allow Snapshot Isolation
