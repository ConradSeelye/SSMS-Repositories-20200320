/*
Page Life Expectancy
source: https://www.sqlshack.com/sql-server-memory-performance-metrics-part-4-buffer-cache-hit-ratio-page-life-expectancy/
date: 11/14/2019

*/


USE SHIELD_DATABASE_AIRPLANE
--USE SHIELD_DATABASE_BIT
--USE SHIELD_DATABASE_CHECKINRECORDS
--USE SHIELD_DATABASE_LOTO
--USE Shield_Database_Users

SELECT object_name, counter_name, cntr_value / 60 AS PLE_Minutes, cntr_value / 3600 AS PLE_Hours
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Buffer Manager%'
AND [counter_name] = 'Page life expectancy'


