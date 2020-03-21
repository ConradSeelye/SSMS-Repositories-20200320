/*
Count of Logical CPU
source: https://blog.sqlauthority.com/2012/02/04/sql-server-finding-count-of-logical-cpu-using-t-sql-script-identify-virtual-processors/
date: 10/29/2019


*/


SELECT cpu_count
FROM sys.dm_os_sys_info
GO
-- Identify Virtual Processors in for SQL Server 2000
CREATE TABLE #TempTable
([Index] VARCHAR(2000),
[Name] VARCHAR(2000),
[Internal_Value] VARCHAR(2000),
[Character_Value] VARCHAR(2000)) ;
INSERT INTO #TempTable
EXEC xp_msver;
SELECT Internal_Value AS VirtualCPUCount
FROM #TempTable
WHERE Name = 'ProcessorCount';
DROP TABLE #TempTable
GO

