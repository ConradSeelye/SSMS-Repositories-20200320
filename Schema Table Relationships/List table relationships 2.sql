/*
List table relationships 2
source: https://blog.sqlauthority.com/2006/11/01/sql-server-query-to-display-foreign-key-relationships-and-name-of-the-constraint-for-each-table-in-database/
date: 5/20/2019

*/

	

SELECT
K_Table = FK.TABLE_NAME,
FK_Column = CU.COLUMN_NAME,
PK_Table = PK.TABLE_NAME,
PK_Column = PT.COLUMN_NAME,
Constraint_Name = C.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
INNER JOIN (
SELECT i1.TABLE_NAME, i2.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
) PT ON PT.TABLE_NAME = PK.TABLE_NAME
---- optional:
--ORDER BY
--1,2,3,4
--WHERE PK.TABLE_NAME='something'WHERE FK.TABLE_NAME='something'
--WHERE PK.TABLE_NAME IN ('one_thing', 'another')
--WHERE FK.TABLE_NAME IN ('one_thing', 'another')

