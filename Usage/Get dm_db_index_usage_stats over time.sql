/*
Get dm_db_index_usage_stats over time
This runs every @DelaySeconds until @EndDateTime
Source: myself
Date: 10/16/2019
Status: sort of working, but needs dev
Notes:
* details
	* this only counts the number of updates; not the row count
* alternatives:
	* https://www.experts-exchange.com/articles/17780/Monitoring-table-level-activity-in-a-SQL-Server-database-by-using-T-SQL.html
* instructions
	* edit the variables
* questions
	? How to get the row count?  
* to do
	* use sys.dm_exec_query_stats for row count 
		* join with plan definition with a search for the table and row in question
		? will this include ad hoc queries?

*/


-- integrate this snippet:
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql?view=sql-server-ver15
BEGIN
/*
SELECT TOP 5 query_stats.query_hash AS "Query Hash",   
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
*/
END



USE tempdb

DECLARE @DelaySeconds INT = 3 -- how often should the usage_stats table be copied? e.g. once every 3 seconds 
DECLARE @EndDateTime DATETIME = DATEADD(SECOND,30,GETDATE()) -- when should the copying end?

SELECT @EndDateTime AS 'Time To End'
--SELECT GETDATE()
--SELECT DATEADD(SECOND,25,GETDATE())
--WAITFOR DELAY '00:00:03'

TRUNCATE TABLE TEMPDB.dbo._dm_db_index_usage_stats

WHILE GETDATE() <= @EndDateTime
BEGIN

	INSERT INTO TEMPDB.dbo._dm_db_index_usage_stats
	(Table_Name, DB_NAME, database_id, object_id, index_id, user_seeks, user_scans, user_lookups, user_updates, last_user_seek, last_user_scan, last_user_lookup, last_user_update, system_seeks, system_scans, system_lookups, system_updates, last_system_seek, last_system_scan, last_system_lookup, last_system_update)
	SELECT t.name AS Table_Name, DB_NAME(s.database_id) AS DB_NAME, s.*
	FROM sys.dm_db_index_usage_stats s
		JOIN sys.tables t
			ON s.object_id = t.object_id
	WHERE DB_NAME(s.database_id) = 'tempdb'
		AND t.name = 'SND'

	WAITFOR DELAY @DelaySeconds
END

SELECT 'END'

SELECT * FROM TEMPDB.dbo._dm_db_index_usage_stats ORDER BY ID DESC

/*
DROP TABLE TEMPDB.dbo.SND 
SELECT * INTO TEMPDB.dbo.SND FROM SND.dbo.SND
*/

/* 
DROP TABLE TEMPDB.dbo._dm_db_index_usage_stats
CREATE TABLE TEMPDB.dbo._dm_db_index_usage_stats
	(ID INT IDENTITY(1,1),
	Table_Name VARCHAR(100),
	DB_NAME VARCHAR(100),
	database_id INT,
	object_id INT,
	index_id INT,
	user_seeks INT,
	user_scans INT,
	user_lookups INT,
	user_updates INT,
	last_user_seek DATETIME,
	last_user_scan DATETIME,
	last_user_lookup DATETIME,
	last_user_update DATETIME,
	system_seeks INT,
	system_scans INT,
	system_lookups INT,
	system_updates INT,
	last_system_seek DATETIME,
	last_system_scan DATETIME,
	last_system_lookup DATETIME,
	last_system_update DATETIME)
*/











