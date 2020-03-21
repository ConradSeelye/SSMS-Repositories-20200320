/*
Get the rows of dirtied pages
source: https://blog.sqlauthority.com/2015/04/20/sql-server-how-to-view-the-dirty-pages-in-memory-of-a-database/
date: 9/10/2019

*/


SELECT
	database_name = d.name,
	OBJECT_NAME =
	CASE au.TYPE
		WHEN 1 THEN o1.name
		WHEN 2 THEN o2.name
		WHEN 3 THEN o1.name
	END,
	OBJECT_ID =
	CASE au.TYPE
		WHEN 1 THEN p1.OBJECT_ID
		WHEN 2 THEN p2.OBJECT_ID
		WHEN 3 THEN p1.OBJECT_ID
	END,
	index_id =
	CASE au.TYPE
		WHEN 1 THEN p1.index_id
		WHEN 2 THEN p2.index_id
		WHEN 3 THEN p1.index_id
	END,
	bd.FILE_ID,
	bd.page_id,
	bd.page_type,
	bd.page_level
FROM sys.dm_os_buffer_descriptors bd
	INNER JOIN sys.databases d
		ON bd.database_id = d.database_id
	INNER JOIN sys.allocation_units au
		ON bd.allocation_unit_id = au.allocation_unit_id
	LEFT JOIN sys.partitions p1
		ON au.container_id = p1.hobt_id
	LEFT JOIN sys.partitions p2
		ON au.container_id = p2.partition_id
	LEFT JOIN sys.objects o1
		ON p1.OBJECT_ID = o1.OBJECT_ID
	LEFT JOIN sys.objects o2
		ON p2.OBJECT_ID = o2.OBJECT_ID
WHERE is_modified = 1
	AND d.name = 'ICE'
	AND
	(
	o1.name = 't1'
	OR o2.name = 't1'
	);

GO
