/*
Page Life Expectancy
source: https://www.sqlshack.com/sql-server-memory-performance-metrics-part-4-buffer-cache-hit-ratio-page-life-expectancy/
date: 9/19/2019

*/

SELECT object_name, counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Buffer Manager%'
AND [counter_name] = 'Page life expectancy'

