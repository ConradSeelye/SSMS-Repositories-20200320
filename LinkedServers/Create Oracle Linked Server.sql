USE [master]
GO

/****** Object:  LinkedServer [LINK_DFK_PSDH]    Script Date: 1/30/2020 1:25:04 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'LINK_DFK_PSDH', @srvproduct=N'DH1PRD1_RPT', @provider=N'OraOLEDB.Oracle', @datasrc=N'DH1PRD1_RPT'
-- EXEC master.dbo.sp_addlinkedserver @server = N'IBIHSVP', @srvproduct=N'IBIHSVP', @provider=N'OraOLEDB.Oracle', @datasrc=N'IBIHSVP'

 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'LINK_DFK_PSDH',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'LINK_DFK_PSDH',@useself=N'False',@locallogin=N'nw\ep135eADM01',@rmtuser=N'DFK_QRY',@rmtpassword='####'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'LINK_DFK_PSDH',@useself=N'False',@locallogin=N'app_dfk',@rmtuser=N'DFK_QRY',@rmtpassword='####'

GO