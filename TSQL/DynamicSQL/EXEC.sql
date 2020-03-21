DECLARE @X VARCHAR(MAX)

SET @X = 'SELECT ''X''' + CHAR(13) + 
	'SELECT ''Y''' 

PRINT @X

EXEC(@X)
