CREATE TABLE [SkyNet].[Audit_Server]
(
   ServerID   INT IDENTITY(1,1),
   ServerName VARCHAR(20)        NOT NULL
   CONSTRAINT [PK_SkyNet_Audit_Server] PRIMARY KEY (ServerID),
   CONSTRAINT [CK_Audit_Server_ServerName_Unique] UNIQUE (ServerName)
)
