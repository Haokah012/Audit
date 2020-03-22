CREATE PROCEDURE SkyNet.Insert_Audit_Warning(@LogID          INT,
                                             @WarningOutput  VARCHAR(MAX),
                                             @IncidentType   INT) AS


BEGIN
   insert into SkyNet.Audit_Warning(LogID,
                                    WarningOutput,
                                    WarningDate,
                                    IncidentType)
      values (@LogID,
              @WarningOutput,
              GETDATE(),
              @IncidentType);
END;
