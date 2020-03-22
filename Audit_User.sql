CREATE TABLE [SkyNet].[Audit_User]
(
    EmployeeID    INT          NOT NULL,
    Email         VARCHAR(100) NULL,
    FirstName     VARCHAR(50)  NOT NULL,
    LastName      VARCHAR(50)  NOT NULL,
    SlackMemberID VARCHAR(20)  NULL,
    LastUpdated   DATETIME     NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT [PK_SkyNet_Audit_User] PRIMARY KEY (EmployeeID)
);