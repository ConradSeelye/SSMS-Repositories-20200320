/*
Get database users and server logins that 
have same name but different SIDs.
These probably need to be synced. 

date: 1/7/2020

sources:
* https://stackoverflow.com/questions/17616620/cannot-resolve-collation-conflict
* https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-user-transact-sql?view=sql-server-ver15

* exec: 
	* edit Where
	* edit COLLATE 
	* confirm with 2x SELECTs

*/

select d.name AS Name_User, 
	s.name AS Name_Login,
	d.sid AS SID_User,
	s.sid AS SID_Login
from sys.database_principals d 
join sys.server_principals s
	on d.name = s.name COLLATE SQL_Latin1_General_CP1_CI_AS
 	AND d.sid <> s.sid 
WHERE d.name = 'ShieldUser_test1'

-- ALTER USER ShieldUser_test1 WITH LOGIN = ShieldUser_test1

SELECT name, sid
FROM sys.database_principals 
WHERE name = 'ShieldUser_test1'

SELECT name, sid
FROM sys.server_principals
WHERE name = 'ShieldUser_test1'

SELECT name, sid 
FROM dbo.syslogins WHERE name IN ('ShieldUser_test1','a')

SELECT name, sid 
FROM sys.sql_logins WHERE name IN ('ShieldUser_test1','a')





-- scratch
/*
user
0xD16B56291FD0074DBC28530A8A4A16F7
0xD16B56291FD0074DBC28530A8A4A16F7
0xD16B56291FD0074DBC28530A8A4A16F7



*.







