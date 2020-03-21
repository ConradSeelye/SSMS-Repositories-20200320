

-- statement called by the job:
/*
IF sys.fn_hadr_is_primary_replica ('DataMart') = 1
BEGIN
	Exec SQL_IMDB.dbo.USP_IMDB_Backup_TranLog DataMartTest, 5
END
*/


-- script to create the job:

USE [msdb]
GO

/****** Object:  Job [-- OPS DBA -- profdb_Trans_Backup]    Script Date: 1/8/2020 12:41:37 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Instance Maintenance]    Script Date: 1/8/2020 12:41:38 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Instance Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Instance Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'-- OPS DBA -- profdb_Trans_Backup', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Tranlog Backup Job every 60 minutes with data compression.', 
		@category_name=N'Instance Maintenance', 
		@owner_login_name=N'boeingdba', 
		@notify_email_operator_name=N'Application_BU_OPERATORS', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [BackupTran]    Script Date: 1/8/2020 12:41:38 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'BackupTran', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Exec USP_IMDB_Backup_TranLog [profdb]', 
		@database_name=N'SQL_IMDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'BackupTran', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=60, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20091120, 
		@active_end_date=99991231, 
		@active_start_time=25730, 
		@active_end_time=15731, 
		@schedule_uid=N'2a29b680-c265-4efe-a303-df2bc5377dc4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


