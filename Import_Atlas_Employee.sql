--This Stored Proc imports Employee details from Atlas to SkyNet 
CREATE PROCEDURE SkyNet.Import_Atlas_Employee
(@Success INT OUTPUT)
AS
    DECLARE @ServerName     VARCHAR(20)  = @@SERVERNAME,
            @DatabaseName   VARCHAR(20)  = DB_NAME(),
            @ThisProgram    VARCHAR(50)  = 'SkyNet.Import_Atlas_Employee',
            @TransactionID  INT,
            @LogID          INT,
            @SignUpTypeName VARCHAR(100) = 'SkyNet',
            @SourceFileName VARCHAR(20)  = '',
            @RuleID         INT          = 1, --"Not Set"
            @StatusID       INT          = 1, --"In Progress"
            @LinkedServer   VARCHAR(20),
            @SQLCommand     NVARCHAR(MAX);

    BEGIN

        BEGIN TRY
            --create transaction
            EXECUTE SkyNet.Execute_Insert_Audit_Transaction @StatusID = @StatusID,
                                                            @TranSourceOfCode = @ThisProgram,
                                                            @ServerName = @ServerName,
                                                            @DatabaseName = @DatabaseName,
                                                            @SourceFileName = @SourceFileName,
                                                            @TransactionID = @TransactionID OUTPUT;

            BEGIN TRANSACTION;
            --create log
            EXECUTE SkyNet.Execute_Insert_Audit_Log @ServerName = @ServerName,
                                                    @TransactionID = @TransactionID,
                                                    @LogSourceOfCode = @ThisProgram,
                                                    @RuleID = 1,                -- RuleID Not Set for Technical errors
                                                    @StatusID = @StatusID,
                                                    @RuleExpectedResult = NULL, -- NULL for technical error logs
                                                    @RuleActualResult = NULL,   -- NULL for technical error logs
                                                    @LogID = @LogID OUTPUT;
            IF @ServerName = 'HMMSQL-WAREHOUS'
                SET @LinkedServer = '[HMMSQL-WAREHOUS]';
            ELSE
                SET @LinkedServer = '[HMMSQL-WAREHOUSE]';

            SET @SQLCommand = N'SELECT EmployeeID,  
                                       Email,        
                                       FirstName,    
                                       LastName,     
                                       SlackMemberID
                               INTO ##tempEmployee
                               FROM' + @LinkedServer + N'.Everest.Everest.Atlas_Employee
                               WHERE IsDeleted = 0';

            EXEC (@SQLCommand);

            MERGE INTO SkyNet.Audit_User target
            USING (SELECT EmployeeID,
                          Email,
                          FirstName,
                          LastName,
                          SlackMemberID
                   FROM ##tempEmployee) source
            ON (target.EmployeeID = source.EmployeeID)
            WHEN NOT MATCHED BY TARGET THEN
                INSERT (EmployeeID,
                        Email,
                        FirstName,
                        LastName,
                        SlackMemberID,
                        LastUpdated)
                VALUES (source.EmployeeID,
                        source.Email,
                        source.FirstName,
                        source.LastName,
                        source.SlackMemberID,
                        GETDATE())
            WHEN NOT MATCHED BY SOURCE THEN
                DELETE
            WHEN MATCHED THEN
                UPDATE SET target.Email = source.Email,
                           target.FirstName = source.FirstName,
                           target.LastName = source.LastName,
                           target.SlackMemberID = source.SlackMemberID,
                           target.LastUpdated = GETDATE();
            
            DROP TABLE ##tempEmployee;

            SET @Success = 1;
            SET @StatusID = 2;

            --Update End DateTime and status of the log
            EXECUTE SkyNet.Execute_Update_Audit_Log @ServerName = @ServerName,
                                                    @StatusID = @StatusID,
                                                    @LogID = @LogID;
            --Update status of the transaction to 3 (Error)
            EXECUTE SkyNet.Execute_Update_Audit_Transaction @ServerName = @ServerName,
                                                            @TransactionID = @TransactionID,
                                                            @StatusID = @StatusID;

            COMMIT TRANSACTION;

        END TRY
        BEGIN CATCH

            ROLLBACK TRANSACTION;

            SET @StatusID = 3; --"Error"
            SET @Success = 0; --"Fail"
            --create log for the TransactionID
            EXECUTE SkyNet.Execute_Insert_Audit_Log @ServerName = @ServerName,
                                                    @TransactionID = @TransactionID,
                                                    @LogSourceOfCode = @ThisProgram,
                                                    @RuleID = @RuleID,
                                                    @StatusID = @StatusID,
                                                    @RuleExpectedResult = NULL, -- NULL for technical error logs
                                                    @RuleActualResult = NULL,   -- NULL for technical error logs
                                                    @LogID = @LogID OUTPUT;
            --create Incident 
            EXECUTE SkyNet.Execute_Insert_Audit_Incident @ServerName = @ServerName,
                                                         @LogID = @LogID,
                                                         @SignUpTypeName = @SignUpTypeName,
                                                         @IsIncident = 1,
                                                         @IsWarning = 0;

            --Update End DateTime of the log
            EXECUTE SkyNet.Execute_Update_Audit_Log @ServerName = @ServerName,
                                                    @StatusID = @StatusID,
                                                    @LogID = @LogID;
            --Update status of the transaction to 3 (Errored)
            EXECUTE SkyNet.Execute_Update_Audit_Transaction @ServerName = @ServerName,
                                                            @TransactionID = @TransactionID,
                                                            @StatusID = @StatusID;
        END CATCH;
    END;

