/*
Blocking history
source: https://blogs.msdn.microsoft.com/microsoft_dynamics_nav_sustained_engineering/2008/03/28/simple-query-to-check-the-recent-blocking-history/
date: 11/20/2019

td:
* adjust this to show delta over time

*/



select
db_name(database_id) DB,
object_name(object_id) Obj,
--row_lock_count, page_lock_count,
row_lock_count + page_lock_count No_Of_Locks,
--row_lock_wait_count, page_lock_wait_count,
row_lock_wait_count + page_lock_wait_count No_Of_Blocks,
--row_lock_wait_in_ms, page_lock_wait_in_ms,
row_lock_wait_in_ms + page_lock_wait_in_ms Block_Wait_Time,
index_id
from sys.dm_db_index_operational_stats(NULL,NULL,NULL,NULL)
order by Block_Wait_Time desc
--order by No_Of_Blocks desc