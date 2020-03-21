
-- On server 1
CREATE LOGIN MyLogin WITH  PASSWORD=N'MyPassword'

SELECT name, sid FROM dbo.syslogins WHERE name IN ('MyLogin','a')

-- On server 2
CREATE LOGIN MyLogin
WITH  PASSWORD=N'MyPassword', 
sid = 0xD16B56291FD0074DBC28530A8A4A16F5 

-- Confirm on both servers
-- Use SQLCMD mode
:CONNECT SQL-D-16P3030
SELECT @@SERVERNAME, name, sid FROM dbo.syslogins WHERE name IN ('dfk_dataReader','a')
GO

:CONNECT SQL-D-16P1042
SELECT @@SERVERNAME, name, sid FROM dbo.syslogins WHERE name IN ('dfk_dataReader','a')



