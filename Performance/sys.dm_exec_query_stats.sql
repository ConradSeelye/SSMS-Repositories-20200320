/*
Query Stats
source: https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql?view=sql-server-2017
date: 5/23/2019

Notes: 
* customize SUM(..) 
* To clear the stats:
DBCC FREEPROCCACHE -- Removes all elements from the plan cache, removes a specific plan from the plan cache by specifying a plan handle or SQL handle, or removes all cache entries associated with a specified resource pool.
DBCC DROPCLEANBUFFERS -- Removes all clean buffers from the buffer pool, and columnstore objects from the columnstore object pool.


*/

SELECT COUNT(*) FROM sys.dm_exec_query_stats

SELECT st.text, s.last_execution_time, s.execution_count
FROM sys.dm_exec_query_stats s
CROSS APPLY sys.dm_exec_sql_text (s.sql_handle) st
ORDER BY last_execution_time DESC


SELECT /* TOP 5 */ query_stats.query_hash AS "Query Hash",   
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS "Avg CPU Time",  
    MIN(query_stats.statement_text) AS "Statement Text"  
FROM   
    (SELECT QS.*,   
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,  
    ((CASE statement_end_offset   
        WHEN -1 THEN DATALENGTH(ST.text)  
        ELSE QS.statement_end_offset END   
            - QS.statement_start_offset)/2) + 1) AS statement_text  
     FROM sys.dm_exec_query_stats AS QS  
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats  
GROUP BY query_stats.query_hash  
ORDER BY 2 DESC;  

