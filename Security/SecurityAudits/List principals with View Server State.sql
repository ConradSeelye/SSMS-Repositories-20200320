/*
List principals with View Server State
8/13/2019
source: https://www.stigviewer.com/stig/microsoft_sql_server_2012_database_instance/2016-06-24/finding/V-41294
notes:
* this could be modified to other permissions


*/

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
AND who.name NOT LIKE '##MS%##'
AND who.type_desc <> 'SERVER_ROLE'
ORDER BY
who.name
;
GO
