/*
Get list of permissions
source: https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/determining-effective-database-engine-permissions?view=sql-server-ver15
date: 12/10/2019

TD:
* clean this up
* list specific sources


*/

SELECT pr.type_desc, pr.name, 
 isnull (pe.state_desc, 'No permission statements') AS state_desc, 
 isnull (pe.permission_name, 'No permission statements') AS permission_name 
 FROM sys.server_principals AS pr
 LEFT OUTER JOIN sys.server_permissions AS pe
   ON pr.principal_id = pe.grantee_principal_id
 WHERE is_fixed_role = 0 -- Remove for SQL Server 2008
	AND name = 'SW\b0322752'
 ORDER BY pr.name, type_desc;




 SELECT pr.type_desc, pr.name, 
 isnull (pe.state_desc, 'No permission statements') AS state_desc, 
 isnull (pe.permission_name, 'No permission statements') AS permission_name 
FROM sys.database_principals AS pr
LEFT OUTER JOIN sys.database_permissions AS pe
    ON pr.principal_id = pe.grantee_principal_id
WHERE pr.is_fixed_role = 0 
	AND name = 'SW\b0322752'
ORDER BY pr.name, type_desc;

SELECT *
FROM sys.server_permissions 



SELECT
who.name AS [Principal Name],
who.type_desc AS [Principal Type],
who.is_disabled AS [Principal Is Disabled],
what.state_desc AS [Permission State],
what.permission_name AS [Permission Name]
FROM
sys.server_permissions what
INNER JOIN sys.server_principals who
ON who.principal_id = what.grantee_principal_id
WHERE
what.permission_name = 'View server state'
-- AND who.name NOT LIKE '##MS%##'
-- AND who.type_desc <> 'SERVER_ROLE'
ORDER BY
who.name


