USE [master]
GO
CREATE LOGIN Linked_Server_Username WITH PASSWORD = 'Lydd808lydd808'
GO
USE taxi_project -- Please change to your own database
GO
CREATE USER Linked_Server_Username FOR LOGIN Linked_Server_Username
GO
GRANT SELECT TO Linked_Server_Username
GO

USE [master]
GO

EXEC master.dbo.sp_addlinkedserver
@server = N'Serverless-Synapse',
@srvproduct = N'',
@provider = N'SQLOLEDB', -- You can also use SQLNCLI11
@datasrc = N'tcp:amir-ws-ondemand.sql.azuresynapse.net,1433',
@catalog = N'Amir_Test'

EXEC master.dbo.sp_addlinkedsrvlogin
@rmtsrvname = N'Serverless-Synapse',
@useself = N'False',
@locallogin = NULL,
@rmtuser = N'Linked_Server_Username',
@rmtpassword = 'Lydd808lydd808'

EXEC master.dbo.sp_serveroption
@server = N'Serverless-Synapse',
@optname = N'rpc',
@optvalue = N'true'

EXEC master.dbo.sp_serveroption
@server = N'Serverless-Synapse',
@optname = N'rpc out',
@optvalue = N'true'

EXEC master.dbo.sp_serveroption
@server = N'Serverless-Synapse',
@optname = N'remote proc transaction promotion',
@optvalue = N'false'
