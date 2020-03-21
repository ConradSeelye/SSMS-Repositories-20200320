/*
To check current tempdb size and growth parameters, use the following query:
source: <https://docs.microsoft.com/en-us/sql/relational-databases/databases/tempdb-database?view=sql-server-2017> 
date: 5/20/2019

*/

 SELECT name AS FileName,    size*1.0/128 AS FileSizeInMB,    CASE max_size        WHEN 0 THEN 'Autogrowth is off.'        WHEN -1 THEN 'Autogrowth is on.'        ELSE 'Log file grows to a maximum size of 2 TB.'    END,    growth AS 'GrowthValue',    'GrowthIncrement' =        CASE            WHEN growth = 0 THEN 'Size is fixed.'            WHEN growth > 0 AND is_percent_growth = 0                THEN 'Growth value is in 8-KB pages.'            ELSE 'Growth value is a percentage.'        ENDFROM tempdb.sys.database_files;