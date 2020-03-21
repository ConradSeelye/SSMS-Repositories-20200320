

/*
sys-dm_os_wait_stats with time difference
source: https://www.sqlservergeeks.com/sys-dm_os_wait_stats/
date: 9/20/2019
context: database


*/

CREATE TABLE #CSS_Waits_Repository (wait_type NVARCHAR(100));

INSERT INTO #CSS_Waits_Repository VALUES ('ASYNC_IO_COMPLETION');
INSERT INTO #CSS_Waits_Repository VALUES ('CHECKPOINT_QUEUE');
INSERT INTO #CSS_Waits_Repository VALUES ('CHKPT');
INSERT INTO #CSS_Waits_Repository VALUES ('CXPACKET');
INSERT INTO #CSS_Waits_Repository VALUES ('DISKIO_SUSPEND');
INSERT INTO #CSS_Waits_Repository VALUES ('FT_IFTS_SCHEDULER_IDLE_WAIT');
INSERT INTO #CSS_Waits_Repository VALUES ('IO_COMPLETION');
INSERT INTO #CSS_Waits_Repository VALUES ('KSOURCE_WAKEUP');
INSERT INTO #CSS_Waits_Repository VALUES ('LAZYWRITER_SLEEP');
INSERT INTO #CSS_Waits_Repository VALUES ('LOGBUFFER');
INSERT INTO #CSS_Waits_Repository VALUES ('LOGMGR_QUEUE');
INSERT INTO #CSS_Waits_Repository VALUES ('MISCELLANEOUS');
INSERT INTO #CSS_Waits_Repository VALUES ('PREEMPTIVE_XXX');
INSERT INTO #CSS_Waits_Repository VALUES ('REQUEST_FOR_DEADLOCK_SEARCH');
INSERT INTO #CSS_Waits_Repository VALUES ('RESOURCE_QUERY_SEMAPHORE_COMPILE');
INSERT INTO #CSS_Waits_Repository VALUES ('RESOURCE_SEMAPHORE');
INSERT INTO #CSS_Waits_Repository VALUES ('SOS_SCHEDULER_YIELD');
INSERT INTO #CSS_Waits_Repository VALUES ('SQLTRACE_BUFFER_FLUSH ');
INSERT INTO #CSS_Waits_Repository VALUES ('THREADPOOL');
INSERT INTO #CSS_Waits_Repository VALUES ('WRITELOG');
INSERT INTO #CSS_Waits_Repository VALUES ('XE_DISPATCHER_WAIT');
INSERT INTO #CSS_Waits_Repository VALUES ('XE_TIMER_EVENT');


DECLARE @Waits TABLE (
    WaitID INT IDENTITY(1, 1) not null PRIMARY KEY,
    wait_type NVARCHAR(60),
    wait_time_s DECIMAL(12, 2),
	resources_wait_s DECIMAL(12, 2),
	signal_wait_s decimal(12, 2));    

WITH Waits AS
(SELECT wait_type, wait_time_ms / 1000. AS wait_time_s,
    100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct,
	(wait_time_ms - signal_wait_time_ms)/1000. AS resources_wait_s,
	signal_wait_time_ms/1000. AS signal_wait_s,
    ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn
FROM sys.dm_os_wait_stats
WHERE wait_type IN(SELECT wait_type FROM #CSS_Waits_Repository)) -- filter out additional irrelevant waits
INSERT INTO @Waits (wait_type, wait_time_s, resources_wait_s, signal_wait_s)
SELECT W1.wait_type,
  CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s,
  CAST(W1.resources_wait_s AS DECIMAL(12, 2)) AS resources_wait_s,
  CAST(W1.signal_wait_s AS DECIMAL(12, 2)) AS signal_wait_s
FROM Waits AS W1
INNER JOIN Waits AS W2
ON W2.rn <= W1.rn
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.resources_wait_s, W1.signal_wait_s, W1.pct
HAVING SUM(W2.pct) - W1.pct < 95; -- percentage threshold

WAITFOR DELAY '00:01:00';

WITH Waits AS
(SELECT wait_type, wait_time_ms / 1000. AS wait_time_s,
    100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct,
	(wait_time_ms - signal_wait_time_ms)/1000. AS resources_wait_s,
	signal_wait_time_ms/1000. AS signal_wait_s,
    ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN(SELECT wait_type FROM #CSS_Waits_Repository)) -- filter out additional irrelevant waits
INSERT INTO @Waits (wait_type, wait_time_s, resources_wait_s, signal_wait_s)
SELECT W1.wait_type,
  CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s,
  CAST(W1.resources_wait_s AS DECIMAL(12, 2)) AS resources_wait_s,
  CAST(W1.signal_wait_s AS DECIMAL(12, 2)) AS signal_wait_s
FROM Waits AS W1
INNER JOIN Waits AS W2
ON W2.rn <= W1.rn
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.resources_wait_s, W1.signal_wait_s, W1.pct
HAVING SUM(W2.pct) - W1.pct < 95; -- percentage threshold

SELECT wait_type, 
	MAX(wait_time_s) - MIN(wait_time_s) WaitDelta_total, 
	MAX(resources_wait_s) - MIN(resources_wait_s) WaitDelta_resource,
	MAX(signal_wait_s) - MIN(signal_wait_s) WaitDelta_signal
FROM @Waits
GROUP BY wait_Type
ORDER BY WaitDelta_total Desc