USE master;
GO

ALTER DATABASE ZorgInfo
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

DROP DATABASE IF EXISTS ZorgInfo;
GO

CREATE DATABASE ZorgInfo;
GO

USE ZorgInfo;
GO

DROP TABLE IF EXISTS Hulpmiddelen;
GO

CREATE TABLE Hulpmiddelen
(
	-- IDENTITY = auto-nummering (tinyint, smallint, int, bigint)
	id		int IDENTITY PRIMARY KEY,	
	title	nvarchar(50)
);
GO

INSERT INTO Hulpmiddelen
(title)
VALUES
('Rolstoel'),
('Armprothese');

SELECT * FROM Hulpmiddelen;

