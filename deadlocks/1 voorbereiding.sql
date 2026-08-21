USE tempdb;
GO

DROP TABLE IF EXISTS tabelA;
DROP TABLE IF EXISTS tabelB;

CREATE TABLE tabelA
(
	id int PRIMARY KEY,
	naam varchar(25)
);
GO

CREATE TABLE tabelB
(
	id int PRIMARY KEY,
	naam varchar(25)
);
GO

INSERT INTO tabelA
VALUES
(1, 'krokodil');

INSERT INTO tabelB
VALUES
(1, 'nijlpaard');
