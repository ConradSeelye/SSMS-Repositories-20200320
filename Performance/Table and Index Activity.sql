/*
Database activity
date: 10/27/2019
source: https://serverfault.com/questions/75688/how-to-determine-read-write-intensive-table-from-dmv-dmf-statistics?noredirect=1
context: database

Questions:
* Is this only indexes, or also tables?
* How to adjust this to server-level?
* Adapt this to rank order the databases by type of activity.
* Does it make sense to aggregate the various types of activity, to get an overall value per database, or per instance?
* Is on updat/delete/insert count by transaction? So, 1 transaction of 100 rows would increment the value by 1?

ToDo:
* Edit to show activity over a delay period.


*/


select  db_name(US.database_id)
    , object_name(US.object_id)
    , I.name as IndexName
    , OS.leaf_allocation_count
    , OS.nonleaf_allocation_count
    , OS.leaf_page_merge_count
    , OS.leaf_insert_count
    , OS.leaf_delete_count
    , OS.leaf_update_count
    , *
from    sys.dm_db_index_usage_stats US
    join sys.indexes I 
        on I.object_id = US.object_id 
        and I.index_id = US.index_id
    join sys.dm_db_index_operational_stats(db_id(), null, null, null) OS
        on OS.object_id = I.object_id and OS.index_id = I.Index_id
where   I.type <> 0  -- not heap
    and object_name(US.object_id) not like 'sys%'
order by    OS.leaf_allocation_count desc, 
        OS.nonleaf_allocation_count desc, 
        OS.leaf_page_merge_count desc,
        US.User_updates desc, 
        US.User_Seeks desc, 
        US.User_Scans desc, 
        US.User_Lookups desc


