
/*
Current Activity
My code
date: 10/9/2019

*/

SELECT 
-- *
	GetDate() AS DateTimeNow
	, DB_NAME(T.dbid) AS DatabaseName
	,R.session_id
	, R.start_time
	, R.status
	, R.command
	, R.blocking_session_id
	, R.wait_type
	, R.wait_time
	, R.last_wait_type
	, R.wait_resource
	, R.open_transaction_count
	, R.open_resultset_count
	, R.percent_complete
	, R.estimated_completion_time
	, R.cpu_time
	, R.total_elapsed_time
	, R.reads
	, R.writes
	, R.logical_reads
	, R.text_size
	, R.row_count
	-- , R.dop -- v 2016+
	, T.dbid

	, substring
    (REPLACE
    (REPLACE
        (SUBSTRING
        (T.text
        , (R.statement_start_offset/2) + 1
        , (
            (CASE statement_end_offset
                WHEN -1
                THEN DATALENGTH(T.text)  
                ELSE R.statement_end_offset
                END
                - R.statement_start_offset)/2) + 1)
    , CHAR(10), ' '), CHAR(13), ' '), 1, 512)  AS Statement_Text  
	, T.text AS FullText
	, P.query_plan AS Query_Plan
	, P.encrypted AS EncryptedPlan
FROM sys.dm_exec_requests R
	CROSS APPLY sys.dm_exec_sql_text(R.sql_handle) T
	CROSS APPLY sys.dm_exec_query_plan (R.plan_handle) P
-- WHERE session_id = 175




