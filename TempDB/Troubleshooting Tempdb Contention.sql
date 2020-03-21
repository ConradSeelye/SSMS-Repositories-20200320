/*
Troubleshooting: Tempdb Contention
source:  https://www.sqlskills.com/blogs/paul/the-accidental-dba-day-27-of-30-troubleshooting-tempdb-contention/#targetText=Tempdb%20contention%20refers%20to%20a,are%20always%20stored%20in%20tempdb).
date: 10/7/2019


*/

SELECT
    [owt].[session_id],
    [owt].[exec_context_id],
    [owt].[wait_duration_ms],
    [owt].[wait_type],
    [owt].[blocking_session_id],
    [owt].[resource_description],
    CASE [owt].[wait_type]
        WHEN N'CXPACKET' THEN
            RIGHT ([owt].[resource_description],
            CHARINDEX (N'=', REVERSE ([owt].[resource_description])) - 1)
        ELSE NULL
    END AS [Node ID],
    [es].[program_name],
    [est].text,
    [er].[database_id],
    [eqp].[query_plan],
    [er].[cpu_time]
FROM sys.dm_os_waiting_tasks [owt]
INNER JOIN sys.dm_exec_sessions [es] ON
    [owt].[session_id] = [es].[session_id]
INNER JOIN sys.dm_exec_requests [er] ON
    [es].[session_id] = [er].[session_id]
OUTER APPLY sys.dm_exec_sql_text ([er].[sql_handle]) [est]
OUTER APPLY sys.dm_exec_query_plan ([er].[plan_handle]) [eqp]
WHERE
    [es].[is_user_process] = 1
	AND owt.wait_type LIKE '%PAGELATCH%'
ORDER BY
    [owt].[session_id],
    [owt].[exec_context_id];
GO





