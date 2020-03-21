/*
Check connection to a SQL Server linked server 
source: https://social.msdn.microsoft.com/Forums/sqlserver/en-US/d011656a-4ba0-42f7-a121-53482e4171ed/intermittent-quotunable-to-complete-login-process-due-to-delay-in-opening-server-connectionquot?forum=transactsql
date: 10/24/2019

Notes:
another to check: https://dba.stackexchange.com/questions/81505/sp-testlinkedserver-output-verbose

Execution:
Edit the server name.

*/

-- Version 1:
SELECT SYSTEM_USER AS usrname

SELECT * FROM OPENQUERY([server name], 'SELECT SYSTEM_USER AS usrname')

return
-- Version 2:
DECLARE  @MyResult VARCHAR(10)

BEGIN TRY
	EXEC sp_testlinkedserver DMLink
	SELECT @MyResult = 'ok'
END TRY
BEGIN CATCH
	SELECT @MyResult = 'some error'
END CATCH

SELECT @MyResult