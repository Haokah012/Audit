CREATE PROCEDURE SkyNet.Update_Audit_Transaction_Status
(
    @TransactionID INT,
    @StatusID      INT
)
AS
    BEGIN
        --End all logs that haven't ended yet before ending transactions. 
        UPDATE SkyNet.Audit_Log
        SET EndDateTime = GETDATE(),
            StatusID = @StatusID
        WHERE TransactionID = @TransactionID
          AND EndDateTime IS NULL;

        --End Transaction and update details. 
        UPDATE SkyNet.Audit_Transaction
        SET StatusID = @StatusID,
            EndDateTime = GETDATE()
        WHERE TransactionID = @TransactionID;
    END;