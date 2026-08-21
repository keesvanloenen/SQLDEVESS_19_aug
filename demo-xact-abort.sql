USE tempdb;
GO

DROP TABLE IF EXISTS nummers;

CREATE TABLE nummers
(
	kolom1 int PRIMARY KEY
);
GO

INSERT INTO nummers
VALUES
(1),
(2),
(3),
(4),
(5);

-- Voer beide rijen tegelijk uit

INSERT INTO nummers VALUES (1);
INSERT INTO nummers VALUES (99);

-- Welke rijen zijn toegevoegd?

SELECT * FROM nummers;

-- Wat als we beide statements in een transactie stoppen?
BEGIN TRANSACTION
	INSERT INTO nummers VALUES (1);
	INSERT INTO nummers VALUES (100);
COMMIT TRANSACTION;
GO

-- Werd rij 100 toegevoegd?

SELECT * FROM nummers;

-- Reden? standaard staat SET XACT_ABORT op OFF

SET XACT_ABORT ON;
BEGIN TRANSACTION
	INSERT INTO nummers VALUES (1);
	INSERT INTO nummers VALUES (101);
COMMIT TRANSACTION;
GO

-- Werd rij 101 toegevoegd?
SELECT * FROM nummers;


/* 
In de meeste productie-omgevingen zet je SET XACT_ABORT ON; juist expliciet aan, 
bijvoorbeeld bij:
   - Stored procedures voor kritieke dataverwerking
   - Financiële transacties
   - Batch scripts waar data-integriteit cruciaal is
*/

-- Standaard XACT_ABORT aanzetten?
-- In Object Explorer: Instance Properties, Connections, Default Connection Options
