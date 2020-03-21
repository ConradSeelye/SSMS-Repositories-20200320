/*
AG Dashboard
source: https://dba.stackexchange.com/questions/164440/how-to-see-the-errors-on-alwayson-using-t-sql/164446#164446
date: 3/12/2020
TD:
* add AG name, DB name


*/



--  Always On Status Report
--
-- This script will show the status of the Alway On replication status

SELECT DISTINCT
primary_replica as 'Primary Server',
[endpoint_url] as 'End Point URL',
primary_recovery_health_desc as 'Primary Server Health Status',
secondary_recovery_health_desc as 'Secondary Server Health Status',
operational_state_desc as 'Operational State',
connected_state_desc as 'Connection State',
recovery_health_desc as 'Recovery Health',
synchronization_state_desc as 'Synchronization State',
database_state_desc as 'Database State',
JOIN_state_desc as 'Join State',
suspend_reason_desc as 'Suspended Reason',
availability_mode_desc as 'Availability Mode',
failover_mode_desc as 'Failover Mode',
primary_role_allow_connections_desc as 'Primary Connections Allowed',
secondary_role_allow_connections_desc as 'Secondary Connections Allowed',
create_date as 'Date Created',
modify_date as 'Date Modified',
[backup_priority] as 'Backup Priority',
role_desc as 'Role Type',
last_connect_error_description as 'Last Connection Error',
last_connect_error_timestamp as 'Last Connection Error Time',
last_sent_time as 'Last Data Send Time',
last_received_time as 'Last Data Recieved TIme',
last_hardened_time  as 'Last Hardened Time',
last_redone_time as 'Last Redone Time',
log_send_queue_size as 'Log Send Queue Size',
log_send_rate as 'Log Send Rate',
redo_queue_size as 'Redo Queue Size',
redo_rate as 'Rate of Redo',
filestream_send_rate as 'Filestream Send Rate',
last_commit_time as ' Last Commit Time',
low_water_mark_for_ghosts as 'Low Water Mark for Ghosts'
FROM sys.dm_hadr_availability_group_states

LEFT OUTER JOIN  sys.availability_replicas
ON sys.dm_hadr_availability_group_states.group_id =  sys.availability_replicas.group_id

LEFT OUTER JOIN sys.dm_hadr_availability_replica_cluster_states
ON sys.dm_hadr_availability_group_states.group_id =  sys.dm_hadr_availability_replica_cluster_states.group_id

LEFT OUTER JOIN sys.dm_hadr_availability_replica_states
ON sys.dm_hadr_availability_group_states.group_id =  sys.dm_hadr_availability_replica_states.group_id

LEFT OUTER JOIN sys.dm_hadr_database_replica_states
ON sys.dm_hadr_availability_group_states.group_id =  sys.dm_hadr_database_replica_states.group_id

--WHERE operational_state_desc IS NOT NULL
--AND database_state_desc IS NOT NULL
ORDER BY [endpoint_url] DESC


