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

