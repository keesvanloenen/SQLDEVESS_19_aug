USE tempdb;
GO

-- stap 1: 
BEGIN TRAN
	UPDATE tabelA
	SET naam = 'krokodil transactie 1'
	WHERE id = 1;

-- stap 3:
	UPDATE tabelB
	SET naam = 'nijlpaard transactie 1'
	WHERE id = 1;
COMMIT TRAN