

USE [msdb]
GO

/****** Object:  Operator [App DBA and IT support]    Script Date: 6/4/2019 2:07:47 PM ******/
EXEC msdb.dbo.sp_delete_operator @name=N'App DBA and IT support'
GO

/****** Object:  Operator [Application DBA and IT support]    Script Date: 6/4/2019 2:07:01 PM ******/
EXEC msdb.dbo.sp_add_operator @name=N'Application DBA and IT support', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'conrad.b.seelye@boeing.com; 4253011157@txt.att.net; 5868020887@txt.att.net;  kent.e.price@boeing.com', 
		@category_name=N'[Uncategorized]'
GO


/****** Object:  Alert [AG Failover: Error 1480]    Script Date: 6/4/2019 2:08:04 PM ******/
EXEC msdb.dbo.sp_delete_alert @name=N'AG Failover: Error 1480'
GO

/****** Object:  Alert [AvailabilityGroup Failover 1480]    Script Date: 6/4/2019 2:06:51 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'AvailabilityGroup Failover 1480', 
		@message_id=1480, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=30, 
		@include_event_description_in=1, 
		@notification_message=N'Failover alert.  Please check the status of the AG to make sure all servers are on-line and synchronized.', 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'AvailabilityGroup Failover 1480', @operator_name=N'Application DBA and IT support', @notification_method = 1
GO


