USE tempdb;
GO

DROP TABLE IF EXISTS MyHeap;
GO

CREATE TABLE MyHeap
(
	Id		int IDENTITY,
	City	nvarchar(50)
);
GO

INSERT INTO MyHeap
VALUES
('Epe'),
('Scha'),
('Urk'),
('Ede');
GO

-- ---------------------------

DROP TABLE IF EXISTS MyClusteredIndex;
GO

CREATE TABLE MyClusteredIndex
(
	Id		int IDENTITY PRIMARY KEY,
	City	nvarchar(50)
);
GO

INSERT INTO MyClusteredIndex
VALUES
('Epe'),
('Scha'),
('Urk'),
('Ede');
GO

-- ------------------------------------------------------------------------

SELECT * FROM MyHeap;			-- Table Scan (scan data pages)
SELECT * FROM MyClusteredIndex; -- Clustered Index Scan (scan index pages)

SELECT * FROM MyHeap Where Id = 2;				-- Table Scan
SELECT * FROM MyClusteredIndex Where Id = 2;	-- Clustered Index Seek

SELECT * FROM MyHeap Where City = 'Urk';				-- Table Scan
SELECT * FROM MyClusteredIndex Where City = 'Urk';		-- Clustered Index Scan

-- --------------------------------------------------------------------

DROP INDEX IF EXISTS IX_MyClusteredIndex_City ON dbo.MyClusteredIndex;
GO

CREATE NONCLUSTERED INDEX IX_MyClusteredIndex_City 
	ON dbo.MyClusteredIndex(city ASC);


SELECT * FROM MyClusteredIndex Where City = 'Urk';		-- NC Seek (id en city zijn al beschikbaar)

-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS MyClusteredIndex2;
GO

CREATE TABLE MyClusteredIndex2
(
	Id		int IDENTITY PRIMARY KEY,
	City	nvarchar(50),
	NumberOfCitizens	int
);
GO

INSERT INTO MyClusteredIndex2
VALUES
('Epe', 4000),
('Scha', 20000),
('Urk', 50000),
('Ede', 30000);
GO


SELECT * FROM MyClusteredIndex2 Where City = 'Urk';		-- NC Seek (id en city zijn al beschikbaar, maar Scan is toch sneller ??)

-- -------------------------------------------------------------------

SET NOCOUNT ON			-- megabelangrijk!!!! + execution plan uitzetten!!!

DECLARE @i int = 1;

WHILE @i < 10000
BEGIN
	INSERT INTO MyClusteredIndex2
	(City, NumberOfCitizens)
	VALUES
	(CONCAT('Plaats', @i), 49002);

	SET @i += 1;
END;


SELECT * FROM MyClusteredIndex2 Where City = 'Urk';		-- NC Seek (id en city zijn al beschikbaar, numberOfCitizens niét)

-- -------------------------------------------------------------------

-- VIEWs zijn updatable

SELECT * FROM MyClusteredIndex2

GO

CREATE OR ALTER VIEW dbo.MarcoPolo
AS
SELECT
	*
FROM MyClusteredIndex2 AS mci
WHERE mci.NumberOfCitizens > 20000
WITH CHECK OPTION;

SELECT * FROM MarcoPolo ORDER By City DESC

INSERT INTO MarcoPolo
VALUES
('Cornwerderzand', 2);

GO
-- -----------------------------------------------------------------

-- INLINE TVF ken je al:

CREATE OR ALTER FUNCTION dbo.Haalop
(@aantal AS int)
RETURNS table
AS
RETURN
SELECT TOP (@aantal)
	mci.City
FROM MyClusteredIndex2 AS mci 
ORDER BY mci.City DESC;

SELECT * FROM dbo.Haalop(3);


-- Een MULTISTATEMENT TVF ziet er zo uit:
DROP FUNCTION IF EXISTS dbo.GetDateRange;
GO

CREATE OR ALTER FUNCTION dbo.GetDateRange 
(@StartDate date, @NumberOfDays int)
RETURNS @DateList TABLE			-- Een variabele die we straks retourneren met RETURN
(Position int, DateValue date)	-- Tabel definitie zoals bij 'CREATE'
AS 
BEGIN
	DECLARE @Counter int = 0;
	WHILE (@Counter < @NumberofDays) 
	BEGIN
		INSERT INTO @DateList
		VALUES (@Counter + 1, DATEADD(day, @Counter, @StartDate));
		SET @Counter += 1;
	END;
	RETURN;
END
GO

SELECT * FROM dbo.GetDateRange('2026-08-20', 15);

-- ----------------------------------------------------------------------------

