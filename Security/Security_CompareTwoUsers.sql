/*
Compare two users permissions on SQL Server database
source: https://dba.stackexchange.com/questions/152621/compare-two-users-permissions-on-sql-server-database
date: 11/12/2019
Notes
* there are other methods in the link

*/

--Database user and role memberships (if any).
SELECT u.name, r.name
FROM sys.database_principals u
LEFT JOIN sys.database_role_members rm
    ON rm.member_principal_id = u.principal_id
LEFT JOIN sys.database_principals r
    ON r.principal_id = rm.role_principal_id
WHERE u.type != 'R'
AND u.[name] = 'SW\b0322736';
GO

--Individual GRANTs and DENYs.
SELECT prin.[name] [User], sec.state_desc + ' ' + sec.permission_name [Permission],
    sec.class_desc Class, object_name(sec.major_id) [Securable], 
    sec.major_id [Securible_Id]
FROM [sys].[database_permissions] sec 
JOIN [sys].[database_principals] prin 
    ON sec.[grantee_principal_id] = prin.[principal_id] 
WHERE prin.[name] = 'SW\b0322736'
ORDER BY [User], [Permission];
GO
