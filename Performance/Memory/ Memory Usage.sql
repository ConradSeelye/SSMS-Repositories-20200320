 /*
 Memory Usage
 source: http://udayarumilli.com/script-to-monitor-sql-server-memory-usage/
 date: 10/29/2019



 */
 
-- SQL server 2012 / 2014 / 2016
SELECT
      (committed_kb)/1024.0 as BPool_Committed_MB,
      (committed_target_kb)/1024.0 as BPool_Commit_Tgt_MB,
      (visible_target_kb)/1024.0 as BPool_Visible_MB
FROM  sys.dm_os_sys_info;


