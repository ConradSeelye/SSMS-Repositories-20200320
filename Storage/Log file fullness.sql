/*
Log file fullness
source: https://dba.stackexchange.com/questions/255969/is-pseudo-simple-sql-server-recovery-a-real-thing
date: 12/19/2019


*/


select file_id
, type_desc
, name
, substring([physical_name],1,3) AS [Drive]
, physical_name
, state_desc
, size / 128 as 'AllocatedSizeMB'
, FILEPROPERTY([name],'SpaceUsed') /128 AS 'SpaceUsedMB'  --Addapted from https://sqlperformance.com/2014/12/io-subsystem/proactive-sql-server-health-checks-1
, (1- (FILEPROPERTY([name],'SpaceUsed') / CAST (size AS MONEY))) *100 AS 'PercentFree'
, growth / 128 as 'GrowthSettingMB'

 from sys.database_files
 order by type_desc Desc, name


