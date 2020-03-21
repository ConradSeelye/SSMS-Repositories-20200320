/*
Get free space
source: https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-file-space-usage-transact-sql?view=sql-server-2017

*/

SELECT total_page_count/128, allocated_extent_page_count/128, unallocated_extent_page_count/128 
FROM sys.dm_db_file_space_usage 







