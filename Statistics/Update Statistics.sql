/*
UPDATE STATISTICS
source: https://docs.microsoft.com/en-us/sql/t-sql/statements/update-statistics-transact-sql?view=sql-server-ver15
date: 12/9/2019

*/


UPDATE STATISTICS [dbo].[CheckInRecords]
[PK_CheckInRecords]
WITH SAMPLE 40 PERCENT, INCREMENTAL = OFF


