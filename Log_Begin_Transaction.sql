CREATE PROCEDURE [SkyNet].[Log_Begin_Transaction]
(
    @TransactionID  INT          = NULL OUTPUT,
    @DatabaseName   VARCHAR(20),
    @ThisProgram    VARCHAR(1000),
    @SourceFileName VARCHAR(200) = NULL,
    @StatusID       INT          = 1,
    @StartNewTran   BIT OUTPUT
)
AS
    BEGIN
        --If Proc is not not nested inside another transaction and @TransactionID IS NULL--> create transaction log record. 
        IF @TransactionID IS NULL
            BEGIN
                EXECUTE SkyNet.Insert_Audit_Transaction @StatusID = @StatusID,
                                                        @TranSourceOfCode = @ThisProgram,
                                                        @DatabaseName = @DatabaseName,
                                                        @SourceFileName = @SourceFileName,
                                                        @TransactionID = @TransactionID OUTPUT;
            END;

        IF @@TRANCOUNT > 0
            BEGIN
                SET @StartNewTran = 0;
            END;
    END;
