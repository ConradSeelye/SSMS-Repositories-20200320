/*
sys.dm_os_latch_stats
source: https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-latch-stats-transact-sql?view=sql-server-2017
date: 9/4/2019

Notes:
DBCC SQLPERF ('sys.dm_os_latch_stats', CLEAR);

*/


SELECT 
	latch_class	
	,waiting_requests_count	
	,wait_time_ms/1000 AS WaitTime_MS
	,max_wait_time_ms/1000 AS MaxWaittime_MS
FROM sys.dm_os_latch_stats  
-- WHERE latch_class = 'FGCB_ADD_REMOVE'
-- WHERE latch_class = 'buffer'
ORDER BY WaitTime_MS DESC

RETURN

-- source: https://www.sqlshack.com/all-about-latches-in-sql-server/
SELECT latch_class, wait_time_ms,waiting_requests_count, 100.0 * wait_time_ms / SUM 
(wait_time_ms) OVER() AS '% of latches'
FROM sys.dm_os_latch_stats
WHERE latch_class NOT IN ('BUFFER')
AND wait_time_ms > 0

