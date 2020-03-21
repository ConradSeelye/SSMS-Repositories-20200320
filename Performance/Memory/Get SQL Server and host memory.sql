/*
Get SQL Server and host memory
source:  https://www.dbrnd.com/2016/11/sql-server-script-to-find-memory-usage-and-allocation/
date: 10/15/2019


*/

-- requires view_server_state
SELECT * FROM sys.dm_os_host_info

DBCC MEMORYSTATUS 

SELECT
	(physical_memory_in_use_kb/1024) AS Memory_usedby_SQLServer_in_MB
	,(locked_page_allocations_kb/1024) AS Locked_pages_in_MB
	,(total_virtual_address_space_kb/1024) AS Total_Virtual_Address_Space_in_MB
	,memory_utilization_percentage 
	,process_physical_memory_low
	,process_virtual_memory_low
FROM sys.dm_os_process_memory;




-- source: http://udayarumilli.com/script-to-monitor-sql-server-memory-usage/
-- date: 10/15/2019
/*********************************************/
--Script: Captures Buffer Pool Usage
--Works On: 2008, 2008 R2, 2012, 2014, 2016
/*********************************************/

-- SQL server 2008 / 2008 R2

SELECT
     (bpool_committed*8)/1024.0 as BPool_Committed_MB,
     (bpool_commit_target*8)/1024.0 as BPool_Commit_Tgt_MB,
     (bpool_visible*8)/1024.0 as BPool_Visible_MB
FROM sys.dm_os_sys_info;

-- SQL server 2012 / 2014 / 2016
SELECT
      (committed_kb)/1024.0 as BPool_Committed_MB,
      (committed_target_kb)/1024.0 as BPool_Commit_Tgt_MB,
      (visible_target_kb)/1024.0 as BPool_Visible_MB
FROM  sys.dm_os_sys_info;





