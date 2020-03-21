/*
CPU usage by database over time
source: http://dbadiaries.com/how-to-list-cpu-usage-per-database-in-sql-server/
	and modified to compare values over time
date: 10/24/2019

Notes:
Adapted to show CPU usage by database over a time period.

ToDo:
* Confirm that this is accurate. Maybe post this to SE.DBA.

Execution:
* Review and adjust the WaitFor Delay value.


*/

TRUNCATE TABLE SQL_IMDB.dbo.QueryStats
GO

WITH CPU_Per_Db
AS
(SELECT 
	dmpa.DatabaseID
	, DB_Name(dmpa.DatabaseID) AS [Database]
	, SUM(dmqs.total_worker_time) AS CPUTimeAsMS
FROM sys.dm_exec_query_stats dmqs 
	CROSS APPLY 
	(SELECT 
	CONVERT(INT, value) AS [DatabaseID] 
FROM sys.dm_exec_plan_attributes(dmqs.plan_handle)
WHERE attribute = N'dbid') dmpa
GROUP BY dmpa.DatabaseID)
 
INSERT INTO SQL_IMDB.dbo.QueryStats ([Database], CPUTimeAsMS, [CPUTimeAs%])
SELECT 
	 [Database] 
	 ,[CPUTimeAsMS] 
	 ,CAST([CPUTimeAsMS] * 1.0 / SUM([CPUTimeAsMS]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUTimeAs%]
FROM CPU_Per_Db
ORDER BY [CPUTimeAsMS] DESC;

-- Adjust this value:
WAITFOR DELAY '0:0:05'
GO

WITH CPU_Per_Db
AS
(SELECT 
	dmpa.DatabaseID
	, DB_Name(dmpa.DatabaseID) AS [Database]
	, SUM(dmqs.total_worker_time) AS CPUTimeAsMS
FROM sys.dm_exec_query_stats dmqs 
	CROSS APPLY 
	(SELECT 
	CONVERT(INT, value) AS [DatabaseID] 
FROM sys.dm_exec_plan_attributes(dmqs.plan_handle)
WHERE attribute = N'dbid') dmpa
GROUP BY dmpa.DatabaseID)
 
SELECT A.[Database]
	, B.DatabaseID
	, A.CPUTimeAsMS
	, B.CPUTimeAsMS
	, FORMAT(B.CPUTimeAsMS - A.CPUTimeAsMS, '#,#') AS CPUTimeAsMS_Difference
	,CAST((B.CPUTimeAsMS - A.CPUTimeAsMS) * 1.0 / SUM(B.CPUTimeAsMS - A.CPUTimeAsMS) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUTimeAs%]
FROM SQL_IMDB.dbo.QueryStats A
JOIN CPU_Per_Db B
ON A.[Database] = B.[Database]


--  SELECT * FROM SQL_IMDB.dbo.QueryStats

 /*
 -- Create the table: 
 SELECT 
 [Database] 
 ,[CPUTimeAsMS] 
 ,CAST([CPUTimeAsMS] * 1.0 / SUM([CPUTimeAsMS]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUTimeAs%]
 INTO SQL_IMDB.dbo.QueryStats
 FROM CPU_Per_Db
 ORDER BY [CPUTimeAsMS] DESC;
 */

