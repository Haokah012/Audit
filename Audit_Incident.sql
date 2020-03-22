CREATE TABLE [SkyNet].[Audit_Incident]
(
    IncidentID     INT          IDENTITY(1, 1) NOT NULL,
    LogID          INT          NOT NULL,
    IncidentOutput VARCHAR(MAX) NOT NULL,
    IncidentDate   DATETIME     NOT NULL,
    IsIncident     BIT          NOT NULL,
    IsWarning      BIT          NOT NULL,
    SignUpTypeID   INT          NOT NULL,
    CONSTRAINT [PK_SkyNet_Audit_Incident] PRIMARY KEY (IncidentID),
    CONSTRAINT [FK_SkyNet_Audit_Incident_Log] FOREIGN KEY (LogID) REFERENCES SkyNet.Audit_Log (LogID),
    CONSTRAINT [FK_SkyNet_Audit_Incident_SignUp_Type] FOREIGN KEY (SignUpTypeID) REFERENCES SkyNet.Audit_SignUpType
                                                      (SignUpTypeID),
    CONSTRAINT [CK_SkyNet_Audit_Either_Incident_Warning] CHECK (IsIncident <> IsWarning)
);