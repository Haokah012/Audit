CREATE PROCEDURE [SkyNet].[Log_Commit_Transaction]
(
    @TransactionID INT,
    @LogID         INT,
    @NestLevel     INT
)
AS
    BEGIN
        DECLARE @StatusID INT = 2; --Completed

        --Update End date of the log
        EXECUTE SkyNet.Update_Audit_Log_EndDate @LogID = @LogID,
                                                @StatusID = @StatusID;

        IF @NestLevel <= 1
            BEGIN
                --update transaction status to committed
                EXECUTE SkyNet.Update_Audit_Transaction_Status @TransactionID = @TransactionID,
                                                               @StatusID = @StatusID;
            END;
    END;