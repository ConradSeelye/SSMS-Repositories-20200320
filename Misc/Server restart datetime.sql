/*
Server restart datetime

Notes:
* there are other methods;  add them here
	* sql logs

https://www.mssqltips.com/sqlservertip/2501/find-last-restart-of-sql-server/


*/


SELECT sqlserver_start_time FROM sys.dm_os_sys_info

