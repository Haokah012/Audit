CREATE TABLE [SkyNet].[Audit_Status]
(
   StatusID   INT               NOT NULL,
   StatusName VARCHAR(100)      NOT NULL,
   CONSTRAINT [PK_SkyNet_Audit_Status] PRIMARY KEY (StatusID),
   CONSTRAINT [CK_Audit_Status_StatusName] UNIQUE (StatusName)
)