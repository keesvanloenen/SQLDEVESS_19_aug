USE master;
GO

--Drop if the DB already exists 
DROP DATABASE IF EXISTS HR;
GO
CREATE DATABASE HR;
GO

-- ********************** AANMAKEN PARTITIONED TABLE **********************

-- AANMAAK STAP 1: Maak FileGroup HRFG_01
-- = logische structuur om objecten (bijv. tabellen) te groeperen 
ALTER DATABASE HR
ADD FILEGROUP HRFG_01;
GO

-- AANMAAK STAP 2: Maak het achterliggende fysieke bestand HR_01
ALTER DATABASE HR
ADD FILE 
(
	NAME = HR_01, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\HR_01.ndf', 
	SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) TO FILEGROUP HRFG_01;
GO

-- Maak FileGroup HRFG_02
ALTER DATABASE HR
ADD FILEGROUP HRFG_02;
GO

-- Maak het achterliggende fysieke bestand HR_02
ALTER DATABASE HR
ADD FILE 
(
	NAME = HR_02, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\HR_02.ndf', 
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) TO FILEGROUP HRFG_02;
GO

-- Maak FileGroup HRFG_03
ALTER DATABASE HR
ADD FILEGROUP HRFG_03;
GO

-- Maak het achterliggende fysieke bestand HR_03
ALTER DATABASE HR
ADD FILE 
(
	NAME = HR_03, 
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\HR_03.ndf', 
	SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) TO FILEGROUP HRFG_03;
GO

USE HR;
GO

-- AANMAAK STAP 3: Maak de Partition Function met grenswaarden
-- LEFT = waarden GELIJK AAN BOUNDARY waarde gaan in LINKER partition
CREATE PARTITION FUNCTION OrderPartitionFunction (datetime2(0)) 
AS RANGE LEFT FOR VALUES ('20191130 23:59:59', '20191231 23:59:59'); 
GO
--SELECT * FROM sys.partition_functions;

-- AANMAAK STAP 4: Maak het Partition Scheme
-- = map de Partition Function naar de File Groups
-- Dus: 
-- waarden tot 20191201 komen in HRFG_01
-- waarden vanaf 20191201 tot 20200101 komen in HRFG_02
-- waarden vanaf 20200101 komen in HRFG_03

-- __________HRFG_01__________|__________HRFG_02__________|__________HRFG_03__________
--              20191130 23:59              20191231 23:59

-- De tabel wordt gemaakt met 3 partities. 
-- Partitie 1 accepteert alle records tot 1 december 2019.
-- Partitie 2 accepteert alle records tussen 1 december en 31 december 2019.
-- Partitie 3 (nu nog leeg) accepteert alle records vanaf 1 Jan 2020 en alles daarna. 

CREATE PARTITION SCHEME OrderPartitionScheme
AS PARTITION OrderPartitionFunction
TO (HRFG_01, HRFG_02, HRFG_03);
GO

-- AANMAAK STAP 5: Maak de tabel (met koppeling naar Partition Scheme)
CREATE TABLE dbo.Orders (
	OrderID			int IDENTITY NOT NULL, 
	OrderDate		datetime2(0) NOT NULL,
	CustomerID		int	NOT NULL, 
	OrderStatus		char(1) NOT NULL DEFAULT 'P',
	ShippingDate	datetime2(0) NOT NULL,
	PRIMARY KEY (OrderID, OrderDate)
)
ON OrderPartitionScheme (OrderDate);
GO

-- Vul de tabel
DECLARE @fromDate AS datetime2(0) = '20191001';
DECLARE @toDate AS datetime2(0) = '20200101';
DECLARE @nrOfSeconds AS bigint = DATEDIFF(second, @fromDate, @toDate) - 1;

INSERT INTO dbo.Orders
(OrderDate , CustomerID, OrderStatus, ShippingDate)
VALUES
(
	DATEADD(second, ROUND((RAND() * @nrOfSeconds), 0), @fromDate)
	, ROUND((RAND() * 1000), 0)
	, 'P'
	, DATEADD(second, ROUND((RAND() * @nrOfSeconds), 0), @fromDate)
);
GO 1000

-- SELECT * FROM dbo.Orders ORDER BY OrderID;

GO
-- Details over de gemaakte partities
CREATE PROCEDURE dbo.PartitionDetails 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		OBJECT_SCHEMA_NAME(pstats.object_id)	AS SchemaName
		, OBJECT_NAME(pstats.object_id)			AS TableName
		, ps.name								AS PartitionSchemeName
		, ds.name								AS PartitionFilegroupName
		, pf.name								AS PartitionFunctionName
		, CASE pf.boundary_value_on_right 
			WHEN 0 THEN 'Range Left' 
			ELSE		'Range Right' 
		  END									AS PartitionFunctionRange
		, CASE pf.boundary_value_on_right 
			WHEN 0 THEN 'Upper Boundary' 
			ELSE		'Lower Boundary'
		  END									AS PartitionBoundary
		, prv.value								AS PartitionBoundaryValue
		, c.name								AS PartitionKey
		, pstats.partition_number				AS PartitionNumber
		, pstats.row_count						AS PartitionRowCount
		, p.data_compression_desc				AS DataCompression
	FROM sys.dm_db_partition_stats AS pstats
	INNER JOIN sys.partitions AS p 
	ON pstats.partition_id = p.partition_id
	INNER JOIN sys.destination_data_spaces AS dds 
	ON pstats.partition_number = dds.destination_id
	INNER JOIN sys.data_spaces AS ds 
	ON dds.data_space_id = ds.data_space_id
	INNER JOIN sys.partition_schemes AS ps 
	ON dds.partition_scheme_id = ps.data_space_id
	INNER JOIN sys.partition_functions AS pf 
	ON ps.function_id = pf.function_id
	INNER JOIN sys.indexes AS i 
	ON pstats.object_id = i.object_id 
	AND pstats.index_id = i.index_id 
	AND dds.partition_scheme_id = i.data_space_id 
	AND i.type <= 1							-- Heap òf Clustered Index
	INNER JOIN sys.index_columns AS ic 
	ON i.index_id = ic.index_id 
	AND i.object_id = ic.object_id 
	AND ic.partition_ordinal > 0
	INNER JOIN sys.columns AS c 
	ON pstats.object_id = c.object_id 
	AND ic.column_id = c.column_id
	LEFT OUTER JOIN sys.partition_range_values AS prv 
	ON pf.function_id = prv.function_id 
	AND pstats.partition_number = (
		CASE pf.boundary_value_on_right 
			WHEN 0 THEN prv.boundary_id 
			ELSE (prv.boundary_id + 1)
		END
	)
	ORDER BY TableName, PartitionNumber;
END;
GO

EXEC dbo.PartitionDetails;
GO

-- ********************** SLIDING WINDOW ********************** 

-- Partitie 1 bevat de gegevens die we heel snel willen archiveren of verwijderen.
-- Verder willen we filegroups en files hergebruiken ('sliden').
-- We maken eerst een work/staging table waar de records uit partitie 1 straks tijdelijk geparkeerd worden.

-- Maak de Orders werk tabel
-- Zelfde kolommen, data typen, partition scheme, partition function en ... leeg!
CREATE TABLE Orders_Work (
	OrderID			int IDENTITY NOT NULL,
	OrderDate		datetime2(0) NOT NULL,
	CustomerID		int NOT NULL, 
	OrderStatus		char(1) NOT NULL DEFAULT 'P',
	ShippingDate	datetime2(0) NOT NULL,
	PRIMARY KEY (OrderID, OrderDate)
)
ON OrderPartitionScheme (OrderDate);
GO

EXEC dbo.PartitionDetails;
GO

-- ______FG1______|______FG2______|______FG3______
--       vol             vol             leeg


-- SLIDE STAP 1: Switch de 1ste partitie van de Orders tabel met de Orders_Work tabel
-- Omdat dit een metadata-only operatie is, gaat dit vliegensvlug
ALTER TABLE dbo.Orders SWITCH PARTITION 1 TO dbo.Orders_Work PARTITION 1;
GO

-- ______FG1______|______FG2______|______FG3______
--       leeg            vol             leeg

-- per 2016: wil je enkel purgen dan is SWITCH niet meer nodig:
-- TRUNCATE de 1ste partitie direct! (staat niet in boek!)
-- TRUNCATE TABLE dbo.Orders WITH (Partitions(1)); 
-- GO

EXEC dbo.PartitionDetails;
GO

-- SLIDE STAP 2: De data uit de Work_Table kan nu gearchiveerd worden of definitief verwijderd
-- Tijd is geen probleem :)
SELECT * INTO Orders_Archief FROM Orders_Work;	-- maak bijv. Archief tabel from scratch
GO
TRUNCATE TABLE Orders_Work;

-- SELECT * FROM Orders_Archief;
EXEC dbo.PartitionDetails;
GO

-- SLIDE STAP 3a: Wijzig het PartitionScheme en bepaal met NEXT USED welke Filegroup straks hergebruikt 
-- kan worden. 1ste keer is dat HRFG_01
ALTER PARTITION SCHEME OrderPartitionScheme NEXT USED HRFG_01;
GO

-- SLIDE STAP 3b: Split de partitie nr. 3 zodat er een nieuwe boundary bij kan komen. Deze boundary wordt
-- weer LEFT gemaakt, gebruik hiervoor dus HRFG_01. (rechts ervan blijft de partition voor datums nà de boundary)
ALTER PARTITION FUNCTION OrderPartitionFunction() SPLIT RANGE('20200131 23:59:59')
GO

-- ______FG1______|______FG2______|______FG1*_____|______FG3______
--       leeg            vol             leeg            leeg

EXECUTE dbo.PartitionDetails;
GO

-- SLIDE STAP 4: Partition Merge
-- Merge de overbodige (eerste lege) partition.
ALTER PARTITION FUNCTION OrderPartitionFunction() MERGE RANGE ('20191130 23:59:59');
GO

-- ______FG2______|______FG1______|______FG3______
--       vol             leeg             leeg

EXEC dbo.PartitionDetails
GO

