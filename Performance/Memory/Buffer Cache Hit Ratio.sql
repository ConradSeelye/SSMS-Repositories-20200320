/*
Buffer Cache Hit Ratio
source: http://blogs.lessthandot.com/index.php/datamgmt/dbprogramming/use-sys-dm_os_performance_counters-to-ge/
date: 11/14/2019
ref:
https://docs.microsoft.com/en-us/sql/relational-databases/performance-monitor/sql-server-buffer-manager-object?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-performance-counters-transact-sql?view=sql-server-ver15
https://docs.microsoft.com/en-us/sql/relational-databases/performance-monitor/sql-server-buffer-manager-object?view=sql-server-ver15
	Indicates the percentage of pages found in the buffer cache without having to read from disk. 
	The ratio is the total number of cache hits divided by the total number of cache lookups 
	over the last few thousand page accesses. After a long period of time, the ratio moves very little. 

*/


 SELECT (a.cntr_value * 1.0 / b.cntr_value) * 100.0 as BufferCacheHitRatio
FROM sys.dm_os_performance_counters  a
JOIN  (SELECT cntr_value,OBJECT_NAME 
	FROM sys.dm_os_performance_counters  
  	WHERE counter_name = 'Buffer cache hit ratio base'
        AND OBJECT_NAME = 'SQLServer:Buffer Manager') b ON  a.OBJECT_NAME = b.OBJECT_NAME
WHERE a.counter_name = 'Buffer cache hit ratio'
AND a.OBJECT_NAME = 'SQLServer:Buffer Manager'




RETURN

-- If you don't have a default instance of SQL server, but named instance, you have to modify query like this:
-- https://dba.stackexchange.com/questions/88784/what-does-a-buffer-cache-hit-ratio-of-9990-mean
  SELECT (a.cntr_value * 1.0 / b.cntr_value) * 100.0 as BufferCacheHitRatio
FROM sys.dm_os_performance_counters  a
JOIN  (SELECT cntr_value, OBJECT_NAME 
    FROM sys.dm_os_performance_counters  
    WHERE counter_name = 'Buffer cache hit ratio base'
        AND OBJECT_NAME LIKE '%:Buffer Manager%') b ON  a.OBJECT_NAME = b.OBJECT_NAME
WHERE a.counter_name = 'Buffer cache hit ratio'
AND a.OBJECT_NAME LIKE '%:Buffer Manager%'

