/*
List indexes
date: 2/6/2020

*/


/*
List indexes with columns for index_columns and included_columns
source: https://dataedo.com/kb/query/sql-server/list-all-indexes-in-the-database
date: 2/6/2020

mods
I separated index columns and included columns by adding another cross apply

*/

select i.[name] as index_name,
    substring(column_names, 1, len(column_names)-1) as [columns],
	    substring(column_names2, 1, len(column_names2)-1) as [columns_included],
    case when i.[type] = 1 then 'Clustered index'
        when i.[type] = 2 then 'Nonclustered unique index'
        when i.[type] = 3 then 'XML index'
        when i.[type] = 4 then 'Spatial index'
        when i.[type] = 5 then 'Clustered columnstore index'
        when i.[type] = 6 then 'Nonclustered columnstore index'
        when i.[type] = 7 then 'Nonclustered hash index'
        end as index_type,
    case when i.is_unique = 1 then 'Unique'
        else 'Not unique' end as [unique],
    schema_name(t.schema_id) + '.' + t.[name] as table_view, 
    case when t.[type] = 'U' then 'Table'
        when t.[type] = 'V' then 'View'
        end as [object_type]
from sys.objects t
    inner join sys.indexes i
        on t.object_id = i.object_id
    cross apply (select col.[name] + ', '
                    from sys.index_columns ic
                        inner join sys.columns col
                            on ic.object_id = col.object_id
                            and ic.column_id = col.column_id
                    where ic.object_id = t.object_id
                        and ic.index_id = i.index_id
						and ic.is_included_column = 0
					order by key_ordinal
                            for xml path ('') ) D (column_names)
    cross apply (select col.[name] + ', '
                    from sys.index_columns ic
                        inner join sys.columns col
                            on ic.object_id = col.object_id
                            and ic.column_id = col.column_id
                    where ic.object_id = t.object_id
                        and ic.index_id = i.index_id
						and ic.is_included_column = 1
					order by key_ordinal
                            for xml path ('') ) E (column_names2)

where t.is_ms_shipped <> 1
and index_id > 0
order by t.name, i.name

SELECT TOP 10 * FROM sys.objects
select top 100 * from sys.objects
SELECT * FROM sys.indexes
SELECT TOP 100 * FROM sys.index_columns
SELECT TOP 100 * FROM sys.columns
SELECT * 
from sys.index_columns ic
    inner join sys.columns col
        on ic.object_id = col.object_id


		select col.[name] + ', '
                    from sys.index_columns ic
                        inner join sys.columns col
                            on ic.object_id = col.object_id
                            and ic.column_id = col.column_id
                    --where ic.object_id = t.object_id
                    --    and ic.index_id = i.index_id
                            order by key_ordinal
                            for xml path ('') 




/*
Create Create statements for all indexes
source: https://www.sqlservercentral.com/forums/topic/script-all-indexes#bm1058836
date: 2/6/2020

*/

DECLARE @idxTableName SYSNAME

DECLARE @idxTableID INT

DECLARE @idxname SYSNAME

DECLARE @idxid INT

DECLARE @colCount INT

DECLARE @IxColumn SYSNAME

DECLARE @IxFirstColumn BIT

DECLARE @ColumnIDInTable INT

DECLARE @ColumnIDInIndex INT

DECLARE @IsIncludedColumn INT

DECLARE @sIncludeCols varCHAR(4000)

DECLARE @sIndexCols varCHAR(4000)

declare @sSQL VARCHAR(4000)

declare @rowcnt int

declare @sParamSQL VARCHAR(4000)

declare @location sysname

-- Get all the index info

declare curidx cursor for

select

object_name(si.object_id), si.object_id, si.name, si.index_id

from

sys.indexes si left join information_schema.table_constraints tc

on si.name = tc.constraint_name and object_name(si.object_id) = tc.table_name

where

objectproperty(si.object_id, 'IsUserTable') = 1

order by object_name(si.object_id), si.index_id

open curidx

fetch next from curidx into @idxTableName, @idxTableID, @idxname, @idxid

--loop

while (@@FETCH_STATUS = 0)

begin

set @sSQL = 'CREATE '

-- Check if the index is unique

if (INDEXPROPERTY(@idxTableID, @idxname, 'IsUnique') = 1)

set @sSQL = @sSQL + 'UNIQUE '

-- Check if the index is clustered

if (INDEXPROPERTY(@idxTableID, @idxname, 'IsClustered') = 1)

set @sSQL = @sSQL + 'CLUSTERED '

set @sSQL = @sSQL + 'INDEX ' + @idxname + ' ON ' + @idxTableName + CHAR(13) + '('

set @sSQL = @sSQL + CHAR(13)

set @colCount = 0

-- Get the number of cols in the index

select @colCount = COUNT(*) from

sys.index_columns ic join sys.columns sc

on ic.object_id = sc.object_id and ic.column_id = sc.column_id

where ic.object_id = @idxtableid and index_id = @idxid and ic.is_included_column = 0

-- Get the file group info

select

@location = f.[name]

from

sys.indexes i INNER JOIN sys.filegroups f ON i.data_space_id = f.data_space_id

INNER JOIN sys.all_objects o ON i.[object_id] = o.[object_id]

Where

o.object_id = @idxTableID

and i.index_id = @idxid

-- Get all columns of the index

declare curidxcolumn cursor for

select

sc.column_id as columnidintable,sc.name,ic.index_column_id columnidinindex,ic.is_included_column as isincludedcolumn

from

sys.index_columns ic join sys.columns sc

on ic.object_id = sc.object_id and ic.column_id = sc.column_id

where

ic.object_id = @idxTableID and index_id = @idxid

order by ic.index_column_id

set @IxFirstColumn = 1

set @sIncludeCols = ''

set @sIndexCols = ''

set @rowcnt = 0

open curidxColumn

fetch next from curidxColumn into @ColumnIDInTable, @IxColumn,@ColumnIDInIndex,@IsIncludedColumn

--loop

while (@@FETCH_STATUS = 0)

begin

if @IsIncludedColumn = 0

begin

set @rowcnt = @rowcnt + 1

set @sIndexCols = char(9) + @sIndexCols + '[' + @IxColumn + ']'

-- Check the sort order of the index cols

if (INDEXKEY_PROPERTY (@idxTableID,@idxid,@ColumnIDInIndex,'IsDescending')) = 0

set @sIndexCols = @sIndexCols + ' ASC '

else

set @sIndexCols = @sIndexCols + ' DESC '

if @rowcnt < @colCount

set @sIndexCols = @sIndexCols + ', '

end

else

begin

-- Check for any include columns

if len(@sIncludeCols) > 0

set @sIncludeCols = @sIncludeCols + ','

set @sIncludeCols = @sIncludeCols + '[' + @IxColumn + ']'

if (INDEXKEY_PROPERTY (@idxTableID,@idxid,@ColumnIDInIndex,'IsDescending')) = 0

set @sIncludeCols = @sIncludeCols + ' ASC '

else

set @sIncludeCols = @sIncludeCols + ' DESC '

end

fetch next from curidxColumn into @ColumnIDInTable, @IxColumn,@ColumnIDInIndex,@IsIncludedColumn

end

close curidxColumn

deallocate curidxColumn

--append to the result

if LEN(@sIncludeCols) > 0

set @sIndexCols = @sSQL + @sIndexCols + CHAR(13) + ') ' + ' INCLUDE [ ' + @sIncludeCols + ' ] '

else

set @sIndexCols = @sSQL + @sIndexCols + CHAR(13) + ') '

-- Build the options

set @sParamSQL = ' WITH ('

if (INDEXPROPERTY(@idxTableID, @idxname, 'IsPadIndex') = 1)

set @sParamSQL = @sParamSQL + ' PAD_INDEX = ON, '

else

set @sParamSQL = @sParamSQL + ' PAD_INDEX = OFF, '

if (INDEXPROPERTY(@idxTableID, @idxname, 'IsPageLockDisallowed') = 1)

set @sParamSQL = @sParamSQL + ' ALLOW_PAGE_LOCKS = ON, '

else

set @sParamSQL = @sParamSQL + ' ALLOW_PAGE_LOCKS = OFF, '

if (INDEXPROPERTY(@idxTableID, @idxname, 'IsRowLockDisallowed') = 1)

set @sParamSQL = @sParamSQL + ' ALLOW_ROW_LOCKS = ON, '

else

set @sParamSQL = @sParamSQL + ' ALLOW_ROW_LOCKS = OFF, '

if (INDEXPROPERTY(@idxTableID, @idxname, 'IsStatistics') = 1)

set @sParamSQL = @sParamSQL + ' STATISTICS_NORECOMPUTE = ON, '

else

set @sParamSQL = @sParamSQL + ' STATISTICS_NORECOMPUTE = OFF, '

set @sParamSQL = @sParamSQL + ' DROP_EXISTING = ON ) '

set @sIndexCols = @sIndexCols + CHAR(13) + @sParamSQL + ' ON [' + @location + ']'

print @sIndexCols

fetch next from curidx into @idxTableName, @idxTableID, @idxname, @idxid

END

close curidx

deallocate curidx







return



/*
List all indexes in a table, without columns listed
source: https://social.msdn.microsoft.com/Forums/sqlserver/en-US/1fa80d4b-70d0-4041-8047-41d104e4db84/get-all-database-indexes-including-index-definition-script
date: 2/6/2020

*/

/*
With Cte As
(
Select 
T4.Name ColumnName ,
T2.Name TableName,T1.Name As IndexName,T5.Name As SchemaName From Sys.Indexes T1
Join Sys.Tables  T2 On T1.Object_Id = T2.Object_Id
Join Sys.Index_Columns T3 On T1.Object_Id = T3.Object_Id And T1.Index_Id = T3.Index_Id
Join Sys.Columns T4 on T4.Object_Id = T3.Object_Id And T4.Column_Id = T3.Column_Id
Join Sys.Schemas T5 On T2.ScheMa_Id = T5.Schema_Id
Where T1.Type = 1
)

Select Distinct 'Create Clustered Index '+T2.IndexName+ ' On '+T2.Schemaname+'.'+ T2.TableName+' ('+ 
Stuff((Select ','+ ColumnName From Cte  T1 Where T1.TableName = T2.TableName For Xml Path ('')),1,1,'')+ ')' As IndexDefination
From Cte T2

*/