
-- called from job: 
/*
IF sys.fn_hadr_is_primary_replica ('DataMart') = 1
BEGIN
	Exec [SQL_IMDB].dbo.USP_IMDB_Backup_Full [DataMart], 5
END
*/

-- #########################################################
-- create job:

USE [msdb]
GO

/****** Object:  Job [-- OPS DBA -- profdb_Database_Airplane_DBBackup]    Script Date: 1/8/2020 12:25:29 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Instance Maintenance]    Script Date: 1/8/2020 12:25:29 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Instance Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Instance Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'-- OPS DBA -- profdb_DBBackup', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Full Backup Job with data compression.', 
		@category_name=N'Instance Maintenance', 
		@owner_login_name=N'boeingdba', 
		@notify_email_operator_name=N'Application_BU_OPERATORS', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [BackupFull]    Script Date: 1/8/2020 12:25:30 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'BackupFull', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=3, 
		@retry_interval=30, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Exec USP_IMDB_Backup_Full [profdb], 6', 
		@database_name=N'SQL_IMDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'BackupFull', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20091120, 
		@active_end_date=99991231, 
		@active_start_time=22730, 
		@active_end_time=235959, 
		@schedule_uid=N'30594897-0130-4072-9abf-9a3881844530'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO






