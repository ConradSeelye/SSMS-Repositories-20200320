/*
Database Activity Based on Transaction Log Backup Size
source: https://www.mssqltips.com/sqlservertip/6096/sql-server-database-activity-based-on-transaction-log-backup-size/
date: 11/1/2019

*/

--Database LEVEL: SUM
--SUM: May be large for a large date range for analysis. this is my preferred over an 8 week period.
DECLARE @NumWeeks INT = 8 --<< SET the number of weeks to analyze.
DECLARE @Database nvarchar(100) = 'YourDBName'
SELECT 
   @@servername as 'Server', --For all full recovery model DBs 
    a.database_name,
   datepart(Hour,a.backup_start_date) as 'Hour',
   convert(int,SUM(CASE WHEN charindex('Sunday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)) as 'Sun_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Monday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End))  as 'Mon_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Tuesday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)) as 'Tue_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Wednesday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)) as 'Wed_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Thursday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)) as 'Thu_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Friday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)) as 'Fri_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Saturday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)) as 'Sat_size(MB)'
   ,MIN(a.backup_start_date ) as 'From:'
   ,MAX(a.backup_start_date ) as 'To:'
   ,COUNT(*) as 'NumberLogBackups'
FROM msdb.dbo.backupset a (NOLOCK)
WHERE 1=1
AND a.type = 'L' --log backups
--AND (a.database_name = @Database --Target Database 
--      OR @Database IS NULL)
--AND a.backup_start_date >= DATEADD(WEEK, DATEDIFF(WEEK,-1,GETDATE())-1*@NumWeeks,-1)  --Note: -1 Starts us at Sunday.
--AND a.backup_start_date < DATEADD(WEEK, DATEDIFF(WEEK,-1,GETDATE()),-1)  
GROUP BY a.database_name, 
  datepart(Hour,a.backup_start_date)
ORDER BY a.database_name, 
  datepart(Hour,a.backup_start_date)
GO

return


--Server Level: 
--Uses Sum / Number of week 
DECLARE @NumWeeks INT = 8
SELECT  
   @@servername as 'Server', --For all full recovery model DBs 
   datepart(Hour,a.backup_start_date) as 'Hour',
   convert(int,SUM(CASE WHEN charindex('Sunday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)/@NumWeeks) as 'Sun_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Monday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)/@NumWeeks)  as 'Mon_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Tuesday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)/@NumWeeks) as 'Tue_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Wednesday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)/@NumWeeks) as 'Wed_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Thursday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)/@NumWeeks) as 'Thu_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Friday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)/@NumWeeks) as 'Fri_size(MB)',
   convert(int,SUM(CASE WHEN charindex('Saturday',datename(weekday,a.backup_start_date)) > 0 then ceiling(a.backup_size/1048576.00) End)/@NumWeeks) as 'Sat_size(MB)'
   ,MIN(a.backup_start_date ) as 'From:'
   ,MAX(a.backup_start_date ) as 'To:'
   ,COUNT(*) as 'NumberLogBackups'
FROM msdb.dbo.backupset a
WHERE a.type = 'L' --log backups
--AND a.backup_start_date >= DATEADD(WEEK, DATEDIFF(WEEK,-1,GETDATE())-1*@NumWeeks,-1) 
--AND a.backup_start_date < DATEADD(WEEK, DATEDIFF(WEEK,-1,GETDATE()),-1)  
GROUP BY datepart(Hour,a.backup_start_date)
ORDER BY datepart(Hour,a.backup_start_date)
GO


