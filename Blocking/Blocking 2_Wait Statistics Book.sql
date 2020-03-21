/*
List current blocking
source: RedGate PDF book:  SQL Server Performance Tuning Using Wait Statistics
date: 1/16/2019

We can see the SQL statements executed by both the blocked and blocking sessions. We
can also use the resource_description to find out, for example, the identity of the
page that is the source of blocking contention. Armed with the pageid of the contended
page, we could use DBCC PAGE to find the owning table and index.

The commented-out lines are for populating this data into a table
that can be viewed by anyone with Read permission, thus bypassing
the View Server State permission on the DMVs.

*/

-- DELETE _CurrentBlocking

-- SELECT * FROM _CurrentBlocking

-- INSERT INTO _CurrentBlocking
SELECT 
	GETDATE() AS CurrentDateTime,
	blocking.session_id AS blocking_session_id ,
	blocked.session_id AS blocked_session_id ,
	waitstats.wait_duration_ms/60000 AS WaitDuration_Minutes,
	waitstats.wait_type AS blocking_resource ,
	waitstats.resource_description ,
	blocked_cache.text AS blocked_text ,
	blocking_cache.text AS blocking_text
-- INTO _CurrentBlocking
FROM sys.dm_exec_connections AS blocking
	INNER JOIN sys.dm_exec_requests blocked
		ON blocking.session_id = blocked.blocking_session_id
	CROSS APPLY sys.dm_exec_sql_text(blocked.sql_handle) blocked_cache
	CROSS APPLY sys.dm_exec_sql_text(blocking.most_recent_sql_handle) blocking_cache
	INNER JOIN sys.dm_os_waiting_tasks waitstats
		ON waitstats.session_id = blocked.session_id