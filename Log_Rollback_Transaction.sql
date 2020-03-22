CREATE PROCEDURE [SkyNet].[Log_Rollback_Transaction]
(
    @TransactionID  INT,
    @ThisProgram    VARCHAR(2000),
    @SignUpTypeID   INT,
    @IncidentOutput VARCHAR(2000),
    @IsIncident     BIT,
    @IsWarning      BIT,
    @LogID          INT,
    @StatusID       INT = 3
)
AS
    BEGIN
        --create log for the TransactionID
        EXECUTE SkyNet.Insert_Audit_Log @TransactionID = @TransactionID,
                                        @LogSourceOfCode = @ThisProgram,
                                        @StatusID = @StatusID,
                                        @LogID = @LogID OUTPUT;

        --create Incident 
        EXECUTE SkyNet.Insert_Audit_Incident @LogID = @LogID,
                                             @SignUpTypeID = @SignUpTypeID,
                                             @IncidentOutput = @IncidentOutput,
                                             @IsIncident = @IsIncident, --Technical errors 
                                             @IsWarning = @IsWarning;  --Not Business rules violation

        --Update End DateTime of the log
        EXECUTE SkyNet.Update_Audit_Log_EndDate @LogID = @LogID,
                                                @StatusID = @StatusID;

        --Update status of the transaction to 3 (rolled back)

        EXECUTE SkyNet.Update_Audit_Transaction_Status @TransactionID = @TransactionID,
                                                       @StatusID = @StatusID;

    END;
