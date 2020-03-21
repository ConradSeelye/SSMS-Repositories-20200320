/*
Get properties of linked servers
source: https://jwcooney.com/2011/10/26/sql-server-how-to-list-the-full-properties-of-all-linked-servers/
date: 9/25/2019

*** adapt this to search multiple servers in search of those that have a certain data source

*/


sp_linkedservers

RETURN

SELECT *
FROM sys.Servers a
LEFT OUTER JOIN sys.linked_logins b ON b.server_id = a.server_id
LEFT OUTER JOIN sys.server_principals c ON c.principal_id = b.local_principal_id






