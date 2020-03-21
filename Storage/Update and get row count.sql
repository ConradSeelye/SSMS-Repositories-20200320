/*
Update and get row count
source: https://www.mssqltips.com/sqlservertip/1358/use-dbcc-updateusage-to-get-accurate-sql-server-space-allocation/
date: 10/24/2019

*/

DBCC UPDATEUSAGE (SND) WITH COUNT_ROWS
-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-updateusage-transact-sql?view=sql-server-ver15
-- Sets share lock on the table

exec sp_spaceused


