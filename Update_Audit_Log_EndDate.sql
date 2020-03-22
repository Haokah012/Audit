CREATE PROCEDURE SkyNet.Update_Audit_Log_EndDate
(
    @LogID    INT,
    @StatusID INT
)
AS
    BEGIN
        UPDATE SkyNet.Audit_Log
           SET EndDateTime = GETDATE(),
               StatusID = @StatusID
         WHERE LogID = @LogID;
    END;