/*
Get free space on drives
source: https://www.sqlshack.com/track-sql-server-database-space-usage-built-functions-dmvs/
date: 1/6/2020
td:
* work through the rest of this article


*/


CREATE TABLE SpaceUsed
    (SpaceDate datetime DEFAULT GETDATE(),
     database_name     NVARCHAR(128),
     database_size     VARCHAR(18),
     unallocated_space VARCHAR(18),
     reserved          VARCHAR(18),
     data              VARCHAR(18),
     index_size        VARCHAR(18),
     unused            VARCHAR(18)
    ); 


INSERT INTO SpaceUsed
    (database_name,
     database_size,
     unallocated_space,
     reserved,
     data,
     index_size,
     unused
    )
    EXEC sp_spaceused @oneresultset = 1;

SELECT * FROM SpaceUsed




