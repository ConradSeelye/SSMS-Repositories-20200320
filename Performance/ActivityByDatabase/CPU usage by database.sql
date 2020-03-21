/*
CPU usage by database

source:
date: 2/5/2020

notes
This shows the total worker time since service start, not the recent activity.
It's based on sys.dm_exec_query_stats, so it's based on cached query execution.


exec:

USE master
GO
SELECT d.name,dbo.udf_Get_DB_Cpu_Pct (d.name) as usagepct
FROM sysdatabases d
ORDER BY usagepct desc
GO

*/


USE master
GO

-- ===========================================================
-- Author:      Eli Leiba
-- Create date: 19-09-2019
-- Description: Get the CPU usage percentage for the given database.
--              Result should be a decimal between 0 and 100
-- ===========================================================

DROP FUNCTION IF EXISTS dbo.udf_Get_DB_Cpu_Pct
GO

CREATE FUNCTION dbo.udf_Get_DB_Cpu_Pct (@dbName sysname)
RETURNS decimal (6, 3)AS
BEGIN
 
   DECLARE @pct decimal (6, 3) = 0

   SELECT @pct = T.[CPUTimeAsPercentage]
   FROM
    (SELECT 
        [Database],
        CONVERT (DECIMAL (6, 3), [CPUTimeInMiliSeconds] * 1.0 / 
        SUM ([CPUTimeInMiliSeconds]) OVER () * 100.0) AS [CPUTimeAsPercentage]
     FROM 
      (SELECT 
          dm_execplanattr.DatabaseID,
          DB_Name(dm_execplanattr.DatabaseID) AS [Database],
          SUM (dm_execquerystats.total_worker_time) AS CPUTimeInMiliSeconds
       FROM sys.dm_exec_query_stats dm_execquerystats
       CROSS APPLY 
        (SELECT 
            CONVERT (INT, value) AS [DatabaseID]
         FROM sys.dm_exec_plan_attributes(dm_execquerystats.plan_handle)
         WHERE attribute = N'dbid'
        ) dm_execplanattr
       GROUP BY dm_execplanattr.DatabaseID
      ) AS CPUPerDb
    )  AS T
   WHERE T.[Database] = @dbName

   RETURN @pct
END
GO


return

-- version 2:

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
 
 SELECT 
 [Database] 
 ,[CPUTimeAsMS] 
 ,CAST([CPUTimeAsMS] * 1.0 / SUM([CPUTimeAsMS]) OVER() * 100.0 AS DECIMAL(5, 2)) AS [CPUTimeAs{96f5cbaad583fb885ff5d18ecce5734bf1e8596949521e20c290401929518f75}]
 FROM CPU_Per_Db
 ORDER BY [CPUTimeAsMS] DESC;


