/*
Statistics update date
https://docs.microsoft.com/en-us/sql/t-sql/functions/stats-date-transact-sql?view=sql-server-ver15


*/

SELECT name AS stats_name,   
    STATS_DATE(object_id, stats_id) AS statistics_update_date  
FROM sys.stats   
-- WHERE object_id = OBJECT_ID('schema.table');  
GO  

/*
If statistics correspond to an index, the stats_id value in the sys.stats catalog 
view is the same as the index_id value in the sys.indexes catalog view, 
and the following query returns the same results as the preceding query. 
If statistics do not correspond to an index, they are in the sys.stats 
results but not in the sys.indexes results.
*/

SELECT name AS index_name,   
    STATS_DATE(object_id, index_id) AS statistics_update_date  
FROM sys.indexes
-- WHERE object_id = OBJECT_ID('schema.table');  


/*
sys.stats 
source: https://www.sqlshack.com/sql-server-statistics-and-how-to-perform-update-statistics-in-sql/

*/

SELECT sp.stats_id, 
       name, 
       filter_definition, 
       last_updated, 
       rows, 
       rows_sampled, 
       steps, 
       unfiltered_rows, 
       modification_counter
FROM sys.stats AS stat
     CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
WHERE stat.object_id = OBJECT_ID('CheckInReportData');




-- DBCC SHOW_STATISTICS
-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-show-statistics-transact-sql?view=sql-server-ver15
DBCC SHOW_STATISTICS ("CimsData", PK__ta__CAC5E742FEDFB3A) WITH HISTOGRAM



