CREATE TABLE [SkyNet].[Audit_ServerDatabase]
(
   ServerDatabaseID INT IDENTITY(1,1),
   DatabaseID       INT                NOT NULL,
   ServerID         INT                NOT NULL
   CONSTRAINT [PK_SkyNet_Audit_ServerDatabase] PRIMARY KEY (ServerDatabaseID),
   CONSTRAINT [FK_SkyNet_Audit_Server] FOREIGN KEY (ServerID) REFERENCES SkyNet.[Audit_Server](ServerID),
   CONSTRAINT [FK_SkyNet_Audit_Database] FOREIGN KEY (DatabaseID) REFERENCES SkyNet.[Audit_Database](DatabaseID),
   CONSTRAINT [CK_Audit_ServerDatabase_DatabaseIDServerID] UNIQUE (DatabaseID,ServerID)
)
