CREATE TABLE [SkyNet].[Audit_SignUpType]
(
    SignUpTypeID   INT         IDENTITY(1, 1),
    SignUpTypeName VARCHAR(20) NOT NULL,
    CONSTRAINT [PK_SkyNet_Audit_SignUpTypeID] PRIMARY KEY (SignUpTypeID)
);
