CREATE TABLE [SkyNet].[Audit_Transaction]
(
   TransactionID    INT IDENTITY(1,1) NOT NULL,
   StartDateTime    DATETIME          NOT NULL,
   EndDateTime      DATETIME          NULL,
   SherpaActionID   INT               NULL,
   SourceFileName   VARCHAR(200)      NULL,
   StatusID         INT               NOT NULL,
   TranSourceOfCode VARCHAR(100)      NOT NULL,
   ServerDatabaseID INT               NOT NULL
   CONSTRAINT [PK_SkyNet_Audit_Transaction] PRIMARY KEY (TransactionID),
   CONSTRAINT [FK_SkyNet_Audit_Transaction_Status] FOREIGN KEY (StatusID) REFERENCES SkyNet.Audit_Status (StatusID),
   CONSTRAINT [FK_SkyNet_Audit_Transaction_ServerDatabase] FOREIGN KEY (ServerDatabaseID) REFERENCES SkyNet.Audit_ServerDatabase(ServerDatabaseID)
)