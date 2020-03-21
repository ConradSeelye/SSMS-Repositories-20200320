
/*
Optimize for ad hoc workloads Server Configuration Option
source: https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/optimize-for-ad-hoc-workloads-server-configuration-option?view=sql-server-2017
date: 9/9/2019

*/

SELECT objtype, cacheobjtype, 
  AVG(usecounts) AS Avg_UseCount, 
  SUM(refcounts) AS AllRefObjects, 
  SUM(CAST(size_in_bytes AS bigint))/1024/1024 AS Size_MB
FROM sys.dm_exec_cached_plans
WHERE objtype = 'Adhoc' AND usecounts = 1
GROUP BY objtype, cacheobjtype;


-- https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-scoped-configuration-transact-sql?view=sql-server-2017
-- ALTER DATABASE SCOPED CONFIGURATION SET OPTIMIZE_FOR_AD_HOC_WORKLOADS = ON;



