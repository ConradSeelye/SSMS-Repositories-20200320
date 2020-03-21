/*

Size of tables
source: https://dba.stackexchange.com/questions/249978/how-to-find-out-which-object-is-taking-space
date: 10/1/2019

*/

 SELECT name = OBJECT_SCHEMA_NAME(object_id) + '.' + OBJECT_NAME(object_id), 
       rows = SUM(CASE
                      WHEN index_id < 2
                      THEN row_count
                      ELSE 0
                  END), 
       reserved_mb = 8 * SUM(reserved_page_count) / 1024, 
       data_mb = 8 * SUM(CASE
                             WHEN index_id < 2
                             THEN in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count
                             ELSE lob_used_page_count + row_overflow_used_page_count
                         END) / 1024, 
       index_mb = 8 * (SUM(used_page_count) - SUM(CASE
                                                      WHEN index_id < 2
                                                      THEN in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count
                                                      ELSE lob_used_page_count + row_overflow_used_page_count
                                                  END)) / 1024, 
       unused_mb = 8 * SUM(reserved_page_count - used_page_count) / 1024
FROM sys.dm_db_partition_stats
WHERE object_id > 1024
GROUP BY object_id
ORDER BY rows DESC;

