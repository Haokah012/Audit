CREATE PROCEDURE SkyNet.Insert_Audit_Log(@TransactionID      INT,
                                         @LogSourceOfCode    VARCHAR(100),
                                         @RuleID             INT = 1,
                                         @StatusID           INT,
                                         @RuleExpectedResult INT = NULL,  --is NUll for Techincal error logs, populate only for business logs
                                         @RuleActualResult   INT = NULL,  --is NUll for Techincal error logs, populate only for business logs
                                         @LogID              INT OUTPUT) AS                                      
BEGIN
   insert into SkyNet.Audit_Log(TransactionID,
                                RuleID,
                                StartDateTime,
                                EndDateTime,
                                LogSourceOfCode,
                                StatusID,
                                RuleExpectedResult,
                                RuleActualResult)                              
      values(@TransactionID,
             @RuleID,
             GETDATE(),
             NULL,
             @LogSourceOfCode,
             @StatusID,
             @RuleExpectedResult,
             @RuleActualResult);

   set @LogID = @@IDENTITY;
END;