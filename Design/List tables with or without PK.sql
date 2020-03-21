/*
List tables with or without PK

source: https://sqlhints.com/2013/08/17/how-to-get-all-the-tables-with-and-without-primary-key-constraint-in-sql-server/

*/



SELECT T.name 'Table without Primary Key'
FROM SYS.Tables T
WHERE OBJECTPROPERTY(object_id,'TableHasPrimaryKey') = 1
      AND type = 'U'
ORDER BY T.name

-- SELECT * FROM sys.tables
