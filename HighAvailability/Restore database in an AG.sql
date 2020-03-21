
/*
Restore a database from another server to an AG.
1. remove from AG
2. restore to 1
3. backup full and tran
4. copy and restore on 2
5. re-join AG



*/

:Connect SQL-S-16T301P

-- remove from AG
USE [master]
GO

/****** Object:  AvailabilityDatabase [Shield_Database_Users]    Script Date: 8/28/2019 4:17:07 PM ******/
ALTER AVAILABILITY GROUP [RDS-PQ-16T301P]
REMOVE DATABASE [Shield_Database_Users];
GO


-- Restore on 1
USE [master]
ALTER DATABASE [Shield_Database_Users] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

RESTORE DATABASE [Shield_Database_Users]
FROM  DISK = N'S:\MSSQLSERVER\Restore\Shield_Database_Users20190827235831.Bak' 
WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 5

ALTER DATABASE [Shield_Database_Users] SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO



-- Backup on 1
EXEC msdb.dbo.sp_start_job @job_name = '-- OPS DBA -- Shield_Database_Users_DBBackup'
GO

WAITFOR DELAY '00:00:02'

EXEC msdb.dbo.sp_start_job @job_name = '-- OPS DBA -- Shield_Database_Users_Trans_Backup'
GO


-- Copy from 1 to 2



-- restore on 2

:Connect SQL-S-16T101P

USE [master]
GO

RESTORE DATABASE [Shield_Database_Users] 
FROM  DISK = N'S:\MSSQLSERVER\RESTORE\Shield_Database_Users20190828165349.Bak' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE LOG [Shield_Database_Users] 
FROM  DISK = N'S:\MSSQLSERVER\RESTORE\Shield_Database_Users20190828165351.Trn' 
WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5

GO





--- YOU MUST EXECUTE THE FOLLOWING SCRIPT IN SQLCMD MODE.
:Connect SQL-S-16T301P

USE [master]

GO

ALTER AVAILABILITY GROUP [RDS-PQ-16T301P]
MODIFY REPLICA ON N'SQL-S-16T101P' WITH (SEEDING_MODE = MANUAL)

GO

USE [master]

GO

ALTER AVAILABILITY GROUP [RDS-PQ-16T301P]
ADD DATABASE [Shield_Database_Users];

GO

:Connect SQL-S-16T101P

USE [master]
GO

-- Wait for the replica to start communicating
begin try
declare @conn bit
declare @count int
declare @replica_id uniqueidentifier 
declare @group_id uniqueidentifier
set @conn = 0
set @count = 30 -- wait for 5 minutes 

if (serverproperty('IsHadrEnabled') = 1)
	and (isnull((select member_state from master.sys.dm_hadr_cluster_members where upper(member_name COLLATE Latin1_General_CI_AS) = upper(cast(serverproperty('ComputerNamePhysicalNetBIOS') as nvarchar(256)) COLLATE Latin1_General_CI_AS)), 0) <> 0)
	and (isnull((select state from master.sys.database_mirroring_endpoints), 1) = 0)
begin
    select @group_id = ags.group_id from master.sys.availability_groups as ags where name = N'RDS-PQ-16T301P'
	select @replica_id = replicas.replica_id from master.sys.availability_replicas as replicas where upper(replicas.replica_server_name COLLATE Latin1_General_CI_AS) = upper(@@SERVERNAME COLLATE Latin1_General_CI_AS) and group_id = @group_id
	while @conn <> 1 and @count > 0
	begin
		set @conn = isnull((select connected_state from master.sys.dm_hadr_availability_replica_states as states where states.replica_id = @replica_id), 1)
		if @conn = 1
		begin
			-- exit loop when the replica is connected, or if the query cannot find the replica status
			break
		end
		waitfor delay '00:00:10'
		set @count = @count - 1
	end
end
end try
begin catch
	-- If the wait loop fails, do not stop execution of the alter database statement
end catch
ALTER DATABASE [Shield_Database_Users] SET HADR AVAILABILITY GROUP = [RDS-PQ-16T301P];

GO


GO


