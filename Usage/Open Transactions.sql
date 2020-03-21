/*
View Open Transactions
source: https://stackoverflow.com/questions/4449719/is-there-a-way-to-list-open-transactions-on-sql-server-2000-database
date: 7/15/2019


*/

-- SELECT * FROM sys.sysprocesses WHERE open_tran = 1

--SELECT * FROM sys.dm_tran_active_transactions
--SELECT * FROM sys.dm_tran_session_transactions
--SELECT * FROM sys.dm_tran_database_transactions
--SELECT * FROM sys.dm_exec_sessions

--sp_who2

-- DBCC OPENTRAN


-- source: https://stackoverflow.com/questions/4449719/is-there-a-way-to-list-open-transactions-on-sql-server-2000-database
SELECT
	trans.session_id AS [SESSION ID],
	ESes.host_name AS [HOST NAME],login_name AS [Login NAME],
	trans.transaction_id AS [TRANSACTION ID],
	tas.name AS [TRANSACTION NAME],tas.transaction_begin_time AS [TRANSACTION BEGIN TIME],
	tds.database_id AS [DATABASE ID],DBs.name AS [DATABASE NAME]
FROM sys.dm_tran_active_transactions tas
	JOIN sys.dm_tran_session_transactions trans
		ON (trans.transaction_id=tas.transaction_id)
	LEFT OUTER JOIN sys.dm_tran_database_transactions tds
		ON (tas.transaction_id = tds.transaction_id )
	LEFT OUTER JOIN sys.databases AS DBs
		ON tds.database_id = DBs.database_id
	LEFT OUTER JOIN sys.dm_exec_sessions AS ESes
		ON trans.session_id = ESes.session_id
-- WHERE ESes.session_id IS NOT NULL


--SELECT *
--FROM sys.dm_tran_active_transactions tas
--	JOIN sys.dm_tran_session_transactions trans
--		ON (trans.transaction_id=tas.transaction_id)





