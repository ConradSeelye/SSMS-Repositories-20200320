/*
dm_exec_query_stats 
source: https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql?view=sql-server-ver15
date: 11/15/2019

*/

SELECT TOP 1 * FROM sys.dm_exec_query_stats

SELECT TOP 5 query_stats.query_hash AS "Query Hash",
	query_stats.execution_count,
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS "Avg CPU Time",  
	query_stats.text,
    MIN(query_stats.statement_text) AS "Statement Text"  
FROM   
    (SELECT QS.*, 
	ST.text,  
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,  
		((CASE statement_end_offset   
			WHEN -1 THEN DATALENGTH(ST.text)  
			ELSE QS.statement_end_offset END   
				- QS.statement_start_offset)/2) + 1) AS statement_text  
     FROM sys.dm_exec_query_stats AS QS  
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats  
GROUP BY query_stats.query_hash, query_stats.execution_count, query_stats.text
ORDER BY 2 DESC;  


return

SELECT * FROM sys.dm_exec_sql_text (0x03000400268AA17694AE000134AA000001000000000000000000000000000000000000000000000000000000)

SELECT * FROM sys.dm_exec_cached_plans

SELECT * FROM sys.dm_exec_query_plan (0x050001005C316901507F16FC7E02000001000000000000000000000000000000000000000000000000000000)









