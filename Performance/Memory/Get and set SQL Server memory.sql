/* Get and set SQL Server memory

*/

SELECT name, value, value_in_use, [description] 
FROM sys.configurations
WHERE name like '%server memory%'
ORDER BY name OPTION (RECOMPILE);


/* Set SQL Server memory
EXEC sys.sp_configure N'max server memory (MB)', N'12000'
GO
RECONFIGURE WITH OVERRIDE
GO

*/

