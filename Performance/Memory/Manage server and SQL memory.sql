/*
Manage server and SQL memory

date: 10/18/2019

ToDo:
* create PS1 script for querying a set of servers for consistency

*/



-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-sys-memory-transact-sql?view=sql-server-ver15
SELECT * FROM sys.dm_os_sys_memory

SELECT total_physical_memory_kb/1024/1024 AS ServerMemory_GB FROM sys.dm_os_sys_memory



-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-sys-info-transact-sql?view=sql-server-ver15
SELECT * FROM sys.dm_os_sys_info

RETURN

/*
-- Adjust SQL Server memory
EXEC sys.sp_configure N'max server memory (MB)', N'44000'
GO
RECONFIGURE WITH OVERRIDE
GO
*/


