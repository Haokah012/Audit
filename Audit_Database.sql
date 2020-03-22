CREATE TABLE [SkyNet].[Audit_Database]
(
   DatabaseID   INT IDENTITY(1,1),
   DatabaseName VARCHAR(20)        NOT NULL,
   CONSTRAINT [PK_SkyNet_Audit_Database] PRIMARY KEY (DatabaseID),
   CONSTRAINT [CK_Audit_Database_DatabaseName_Unique] UNIQUE (DatabaseName)
)
