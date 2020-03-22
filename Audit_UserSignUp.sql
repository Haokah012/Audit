CREATE TABLE [SkyNet].[Audit_UserSignUp]
(
    UserSignUpID    INT IDENTITY(1, 1) NOT NULL,
    UserID          INT NOT NULL,
    SignUpTypeID    INT NOT NULL,
    DatabaseID      INT NULL,
    ReceiveIncident BIT NOT NULL,
    ReceiveWarning  BIT NOT NULL,
    CONSTRAINT [PK_SkyNet_Audit_UserSignUp] PRIMARY KEY (UserSignUpID),
    CONSTRAINT [FK_SkyNet_Audit_SignUp_User] FOREIGN KEY (UserID) REFERENCES SkyNet.Audit_User (EmployeeID) ON DELETE CASCADE,
    CONSTRAINT [FK_SkyNet_Audit_SignUp_Type] FOREIGN KEY (SignUpTypeID) REFERENCES SkyNet.Audit_SignUpType
                                             (SignUpTypeID),
    CONSTRAINT [FK_SkyNet_Audit_SignUp_Database] FOREIGN KEY (DatabaseID) REFERENCES SkyNet.Audit_Database (DatabaseID),
    CONSTRAINT [CK_SkyNet_Audit_UserSignUp_Unique] UNIQUE (UserID, SignUpTypeID, DatabaseID)
);
