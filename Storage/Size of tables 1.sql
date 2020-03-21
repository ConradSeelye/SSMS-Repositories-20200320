/*
Get size of tables 
source: https://stackoverflow.com/questions/7892334/get-size-of-all-tables-in-database
date: 5/23/2019

*/

-- ##########################################
SELECT 
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceMB,
    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceMB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceMB
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.NAME NOT LIKE 'dt%' 
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
GROUP BY 
    t.Name, s.Name, p.Rows
ORDER BY 
	UsedSpaceKB desc
    -- t.Name

return

-- ##########################################
EXEC sp_spaceused N'History'



-- ##########################################
-- Start

create table #TableSize (
    Name varchar(255),
    [rows] int,
    reserved varchar(255),
    data varchar(255),
    index_size varchar(255),
    unused varchar(255))
create table #ConvertedSizes (
    Name varchar(255),
    [rows] int,
    reservedKb int,
    dataKb int,
    reservedIndexSize int,
    reservedUnused int)

EXEC sp_MSforeachtable @command1="insert into #TableSize
EXEC sp_spaceused '?'"
insert into #ConvertedSizes (Name, [rows], reservedKb, dataKb, reservedIndexSize, reservedUnused)
select name, [rows], 
SUBSTRING(reserved, 0, LEN(reserved)-2), 
SUBSTRING(data, 0, LEN(data)-2), 
SUBSTRING(index_size, 0, LEN(index_size)-2), 
SUBSTRING(unused, 0, LEN(unused)-2)
from #TableSize

select * from #ConvertedSizes
order by reservedKb desc

drop table #TableSize
drop table #ConvertedSizes

-- End

-- ##########################################
-- compare how much space is used by indexes on the table
SELECT
    OBJECT_NAME(i.OBJECT_ID) AS TableName,
    i.name AS IndexName,
    i.index_id AS IndexID,
    8 * SUM(a.used_pages) AS 'Indexsize(KB)'
FROM
    sys.indexes AS i JOIN 
    sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id JOIN 
    sys.allocation_units AS a ON a.container_id = p.partition_id
where [i].[is_primary_key] = 0 -- fix for size discrepancy
GROUP BY
    i.OBJECT_ID,
    i.index_id,
    i.name
ORDER BY
    OBJECT_NAME(i.OBJECT_ID),
    i.index_id


-- ##########################################

CREATE TABLE #t 
( 
    [name] NVARCHAR(128),
    [rows] CHAR(11),
    reserved VARCHAR(18), 
    data VARCHAR(18), 
    index_size VARCHAR(18),
    unused VARCHAR(18)
) 

INSERT #t EXEC sp_msForEachTable 'EXEC sp_spaceused ''?''' 
-- -- sp_msforeachtable 'EXEC sp_spaceused [?]' 
	
SELECT *
FROM   #t
ORDER BY NAME 



