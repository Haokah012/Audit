CREATE PROCEDURE SkyNet.Insert_Audit_Incident
(
    @LogID          INT,
    @SignUpTypeID   INT,
    @IncidentOutPut VARCHAR(MAX),
    @IsIncident     BIT,
    @IsWarning      BIT      
)
AS
    BEGIN

        SELECT @SignUpTypeID = ISNULL(SignUpTypeID,0)
          FROM SkyNet.Audit_SignUpType
         WHERE SignUpTypeID = @SignUpTypeID;

        --if no SignUpType then use default
        IF @SignUpTypeID = 0
            SELECT @SignUpTypeID = SignUpTypeID
              FROM SkyNet.Audit_SignUpType
             WHERE SignUpTypeName = 'Default';

        INSERT INTO SkyNet.Audit_Incident (LogID,
                                           IncidentOutput,
                                           IncidentDate,
                                           IsIncident,
                                           Iswarning,
                                           SignUpTypeID)
        VALUES (@LogID,
                @IncidentOutPut,
                GETDATE(),
                @IsIncident,
                @IsWarning, 
                @SignUpTypeID);
    END;