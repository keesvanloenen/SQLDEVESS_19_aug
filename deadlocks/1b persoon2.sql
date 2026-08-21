USE tempdb;
GO

-- stap 2: 
BEGIN TRAN
	UPDATE tabelB
	SET naam = 'nijlpaard transactie 2'
	WHERE id = 1;

-- stap 4: 
	UPDATE tabelA
	SET naam = 'krokodil transactie 2'
	WHERE id = 1;
COMMIT TRAN