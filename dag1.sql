USE master;
GO

-- Sluit eerst evt. connecties op deze database
ALTER DATABASE ZorgInfo
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

DROP DATABASE IF EXISTS ZorgInfo;
GO

CREATE DATABASE ZorgInfo;
GO

USE ZorgInfo;
GO

DROP SEQUENCE IF EXISTS TransactionSeq;
GO

-- Entiteit die opeenvolgende nummers retourneert
-- Handig bij doorlopende nummering over meerdere tabellen
CREATE SEQUENCE TransactionSeq
	START WITH 1
	INCREMENT BY 1;

DROP TABLE IF EXISTS Hulpmiddelen;
GO

CREATE TABLE Hulpmiddelen
(
	-- IDENTITY = auto-nummering (tinyint, smallint, int, bigint)
	id		int IDENTITY PRIMARY KEY,	
	title	nvarchar(50)
);
GO

DROP TABLE IF EXISTS Transactions;
GO

DROP TABLE IF EXISTS Accounts;
GO

-- Primary Key
-- Check Constraint column
-- Check Constraint table
CREATE TABLE Accounts
(
	Id int IDENTITY(1,1) 
		   CONSTRAINT PK_Accounts_Id 
		   PRIMARY KEY,
	CountryCode	char(3)
				CHECK(CountryCode LIKE '[A-Z][A-Z][A-Z]'),
	Age	int
		CHECK(age >= 18),
	CONSTRAINT CHK_Accounts_When_NL_Then_Age_LargeOrEqualTo_21
	--CHECK(CASE WHEN CountryCode = 'NLD' AND Age >= 21 THEN 1 ELSE 0 END = 1) 
	CHECK(IIF(CountryCode = 'NLD' AND Age >= 21, 1, 0) = 1)
);

-- Foreign Key (AccountId)
-- Computed Column (AmountWithFee)
-- Default Constraint (TransactionDate)
CREATE TABLE Transactions 
(
	Id					bigint DEFAULT (NEXT VALUE FOR TransactionSeq),
	AccountId			int NOT NULL
						CONSTRAINT FK_Transactions_AccountId
						FOREIGN KEY (AccountId) REFERENCES Accounts(Id)
						ON UPDATE CASCADE
						ON DELETE CASCADE,
	Amount				decimal(5,2) NOT NULL,
	AmountWithFee		AS (Amount * 1.02) PERSISTED,
	TransactionDate		datetime2(0) NOT NULL DEFAULT GETDATE()
);

/* --------------------------------------------------------------------- */
/*                                Seed                                   */
/* --------------------------------------------------------------------- */

INSERT INTO Hulpmiddelen
(title)
VALUES
('Rolstoel'),
('Armprothese');

INSERT INTO Transactions
(AccountId, Amount)
VALUES
(12, 999.99),
(13, 7.55),
(25, 11);

INSERT INTO Transactions
(AccountId, Amount, TransactionDate)
VALUES
(2, 999.99, '20251231 23:22:31'),
(2, 999.98, '2025-12-31T23:22:31');

SELECT * FROM Transactions;

-- ----------------------------------------------------------------------------

-- Function
GO

CREATE OR ALTER FUNCTION dbo.DomainExtractor
(@emailAddress nvarchar(50))
RETURNS nvarchar(50)
AS
BEGIN
	RETURN SUBSTRING(@emailAddress, CHARINDEX('@', @emailAddress) + 1, 50);
END;

GO

SELECT dbo.DomainExtractor('kees.vanloenen@infosupport.com')

/* Bouw één van de volgende 3 functies:

1. Maak een UDF die controleert of een meegegeven getal even is
2. Maak een UDF die een forward-slash toevoegt aan een string als deze nog niet bestaat
3. Maak een UDF die controleer of een wachtwoord voldoet aan de volgende eisen:
- minimaal 12 tekens
- minimaal 1 cijfer
- minimaal 1 hoofdletter (hier heb je nog een function voor nodig: 'dbo.ContainsCapitalLetter')
*/