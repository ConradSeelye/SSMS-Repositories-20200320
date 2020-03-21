/*
Who are the sysadmins in this sql server?
source: https://marlonribunal.com/who-are-the-sysadmins-in-this-sql-server/
date: 7/10/2019

ToDo:
* Adapt this to the "Execute SQL on a list of servers" project.  Justification is that we manage and inherit a lot of servers, and there could be a sysadmin lurking in one of them. 


*/

USE master
GO

SELECT p.name AS [loginname] ,
p.type ,
p.type_desc ,
p.is_disabled,
CONVERT(VARCHAR(10),p.create_date ,101) AS [created],
CONVERT(VARCHAR(10),p.modify_date , 101) AS [update]
FROM sys.server_principals p
JOIN sys.syslogins s ON p.sid = s.sid
WHERE p.type_desc IN ('SQL_LOGIN', 'WINDOWS_LOGIN', 'WINDOWS_GROUP')
-- Logins that are not process logins
AND p.name NOT LIKE '##%'
-- Logins that are sysadmins
AND s.sysadmin = 1
GO



