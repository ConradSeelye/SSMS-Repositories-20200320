USE [master]
GO
/****** Object:  Login [NW\ep135eADM01]    Script Date: 10/18/2019 2:24:22 PM ******/
EXEC master.dbo.sp_droplinkedsrvlogin @rmtsrvname = N'LinkedServerName', @locallogin = N'NW\ep135eADM01'
GO

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'LinkedServerName',@useself=N'False',@locallogin=N'NW\ep135eADM01',@rmtuser=N'yyyyy',@rmtpassword='#####'




