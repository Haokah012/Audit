CREATE TABLE [SkyNet].[Audit_Log]
(
    LogID              INT          IDENTITY(1, 1) NOT NULL,
    TransactionID      INT          NOT NULL,
    RuleID             INT          NOT NULL,
    StartDateTime      DATETIME     NOT NULL,
    EndDateTime        DATETIME     NULL,
    LogSourceOfCode    VARCHAR(100) NOT NULL,
    RuleExpectedResult INT          NULL,
    RuleActualResult   INT          NULL,
    FileURL            VARCHAR(500) NULL,
    StatusID           INT          NULL,
    CONSTRAINT [PK_SkyNet_Audit_Log] PRIMARY KEY (LogID),
    CONSTRAINT [FK_SkyNet_Audit_Log_Status] FOREIGN KEY (StatusID) REFERENCES SkyNet.Audit_Status (StatusID),
    CONSTRAINT [FK_SkyNet_Audit_Log_Transaction] FOREIGN KEY (TransactionID) REFERENCES SkyNet.Audit_Transaction
                                                 (TransactionID)
);