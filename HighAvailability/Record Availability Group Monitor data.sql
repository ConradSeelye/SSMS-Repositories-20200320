/*
Run this as a periodic Job

date: 5/23/2019

*/

CREATE TABLE [dbo].[_AvailabilityGroupMonitor](
	[MyDateTime] [datetime] NULL,
	[replica_server_name] [varchar](100) NULL,
	[database_name] [varchar](100) NULL,
	[ag_name] [varchar](100) NULL,
	[is_local] [bit] NULL,
	[is_primary_replica] [bit] NULL,
	[synchronization_state_desc] [varchar](100) NULL,
	[is_commit_participant] [bit] NULL,
	[synchronization_health_desc] [varchar](100) NULL,
	[log_send_queue_size] [int] NULL,
	[log_send_rate] [int] NULL,
	[redo_queue_size] [int] NULL,
	[redo_rate] [int] NULL,
	[last_commit_time] [datetime] NULL,
	[secondary_lag_seconds] [bigint] NULL
) ON [PRIMARY]
GO


INSERT INTO SQL_IMDB.dbo._AvailabilityGroupMonitor
SELECT 
	GetDate() AS MyDateTime,
	ar.replica_server_name, 
	adc.database_name, 
	ag.name AS ag_name, 
	drs.is_local, 
	drs.is_primary_replica, 
	drs.synchronization_state_desc, 
	drs.is_commit_participant, 
	drs.synchronization_health_desc, 
	drs.log_send_queue_size, 
	drs.log_send_rate, 
	drs.redo_queue_size, 
	drs.redo_rate, 
	--drs.filestream_send_rate, 
	drs.last_commit_time,
	drs.secondary_lag_seconds -- new 1/31/2019
FROM sys.dm_hadr_database_replica_states AS drs
INNER JOIN sys.availability_databases_cluster AS adc 
	ON drs.group_id = adc.group_id AND 
	drs.group_database_id = adc.group_database_id
INNER JOIN sys.availability_groups AS ag
	ON ag.group_id = drs.group_id
INNER JOIN sys.availability_replicas AS ar 
	ON drs.group_id = ar.group_id AND 
	drs.replica_id = ar.replica_id
WHERE database_name = 'PowerPick'
ORDER BY 
	ag.name, 
	ar.replica_server_name, 
	adc.database_name;

