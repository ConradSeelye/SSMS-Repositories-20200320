/*

Sessions with transaction_isolation_level
source: https://blogs.msdn.microsoft.com/sqlcan/2012/05/24/a-microsoft-sql-server-dmvdmf-cheat-sheet/
date: 3/20/2109
ToDo:
* add sql_text

*/

 SELECT c.session_id
 , c.auth_scheme
 , c.node_affinity
 , r.scheduler_id
 , s.login_name
 , db_name(s.database_id) AS database_name
 , CASE s.transaction_isolation_level
 WHEN 0 THEN 'Unspecified'
 WHEN 1 THEN 'Read Uncomitted'
 WHEN 2 THEN 'Read Committed'
 WHEN 3 THEN 'Repeatable'
 WHEN 4 THEN 'Serializable'
 WHEN 5 THEN 'Snapshot'
 END AS transaction_isolation_level
 , s.status AS SessionStatus
 , r.status AS RequestStatus
 , CASE WHEN r.sql_handle IS NULL THEN
 c.most_recent_sql_handle
 ELSE
 r.sql_handle
 END AS sql_handle
 , r.cpu_time
 , r.reads
 , r.writes
 , r.logical_reads
 , r.total_elapsed_time
 FROM sys.dm_exec_connections c
 INNER JOIN sys.dm_exec_sessions s
 ON c.session_id = s.session_id
 LEFT JOIN sys.dm_exec_requests r
 ON c.session_id = r.session_id

