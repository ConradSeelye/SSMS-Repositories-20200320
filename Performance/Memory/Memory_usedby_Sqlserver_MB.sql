
-- https://dba.stackexchange.com/questions/84510/os-paging-too-high-in-sql-server

select 
	(physical_memory_in_use_kb/1024)Memory_usedby_Sqlserver_MB, 
	(locked_page_allocations_kb/1024 )Locked_pages_used_Sqlserver_MB 
from sys. dm_os_process_memory

