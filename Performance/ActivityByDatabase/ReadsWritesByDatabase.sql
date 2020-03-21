/*
Page Reads, Page Write by database
This shows the activity by database for logical reads and writes. 
date: 3/4/2020
source: https://blog.sqlauthority.com/2010/01/14/sql-server-find-busiest-database/
notes:
* I added Percentage columns 

TD
* add logging and aggregates by time period

Original:
SELECT SUM(deqs.total_logical_reads) TotalPageReads,
SUM(deqs.total_logical_writes) TotalPageWrites,
CASE
WHEN DB_NAME(dest.dbid) IS NULL THEN 'AdhocSQL'
ELSE DB_NAME(dest.dbid) END Databasename
FROM sys.dm_exec_query_stats deqs
CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
GROUP BY DB_NAME(dest.dbid)

*/

DECLARE @QueryStats TABLE (ID INT IDENTITY(1,1), TotalPageReads BIGINT,TotalPageWrites BIGINT,Databasename VARCHAR(100))

INSERT INTO @QueryStats
	SELECT SUM(deqs.total_logical_reads) TotalPageReads,
		SUM(deqs.total_logical_writes) TotalPageWrites,
		CASE
			WHEN DB_NAME(dest.dbid) IS NULL THEN 'AdhocSQL'
			ELSE DB_NAME(dest.dbid) 
		END Databasename
	FROM sys.dm_exec_query_stats deqs
		CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
	GROUP BY DB_NAME(dest.dbid)
	ORDER BY TotalPageReads DESC

DECLARE @SumTotalPageReads BIGINT = (SELECT SUM(TotalPageReads) FROM @QueryStats)
DECLARE @SumTotalPageWrites BIGINT = (SELECT SUM(TotalPageWrites) FROM @QueryStats)

-- SELECT @SumTotalPageReads

SELECT 
	TotalPageReads,
	PercentageTPR = CONVERT(VARCHAR, CONVERT(MONEY,100.0 * TotalPageReads) / @SumTotalPageReads),
	TotalPageWrites, 
	PercentageTPW = CONVERT(VARCHAR, CONVERT(MONEY,100.0 * TotalPageWrites) / @SumTotalPageWrites),
	-- (SELECT SUM(TotalPageReads) FROM @QueryStats SUB WHERE SUB.ID <= BASE.ID) / @SumTotalPageReads * 100 AS RunningPercent
	Databasename
FROM @QueryStats BASE
ORDER BY TotalPageReads DESC









