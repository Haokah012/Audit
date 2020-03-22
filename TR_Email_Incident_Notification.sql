CREATE TRIGGER SkyNet.TR_Email_Incident_Notification
ON SkyNet.Audit_Incident
FOR INSERT
AS
    BEGIN

        SET NOCOUNT ON;

        IF EXISTS (SELECT 1 FROM inserted)
            BEGIN

                DECLARE @Program        VARCHAR(200),
                        @IncidentOutput VARCHAR(MAX),
                        @IncidentDate   DATETIME,
                        @IncidentType   VARCHAR(100),
                        @Subject        VARCHAR(MAX),
                        @Body           VARCHAR(MAX),
                        @DatabaseName   VARCHAR(20),
                        @ServerName     VARCHAR(20),
                        @SourceFileName VARCHAR(200);

                SELECT i.IncidentOutput,
                       i.IncidentDate,
                       st.SignUpTypeName  AS IncidentTypeName,
                       al.LogSourceOfCode AS Program,
                       adb.DatabaseName   AS DatabaseName,
                       asr.ServerName     AS ServerName,
                       atr.SourceFileName AS SourceFileName
                INTO #tempIncident
                FROM inserted                        i
                    JOIN SkyNet.Audit_Log            al
                      ON i.LogID              = al.LogID
                    JOIN SkyNet.Audit_SignUpType     st
                      ON st.SignUpTypeID      = i.SignUpTypeID
                    JOIN SkyNet.Audit_Transaction    atr
                      ON al.TransactionID     = atr.TransactionID
                    JOIN SkyNet.Audit_ServerDatabase asd
                      ON atr.ServerDatabaseID = asd.ServerDatabaseID
                    JOIN SkyNet.Audit_Server         asr
                      ON asr.ServerID         = asd.ServerID
                    JOIN SkyNet.Audit_Database       adb
                      ON asd.DatabaseID       = adb.DatabaseID;

                SELECT @Program        = Program,
                       @IncidentOutput = IncidentOutput,
                       @IncidentType   = IncidentTypeName,
                       @IncidentDate   = IncidentDate,
                       @DatabaseName   = DatabaseName,
                       @ServerName     = ServerName,
                       @SourceFileName = ISNULL(SourceFileName, '')
                FROM #tempIncident;

                SET @Subject = 'Audit_Incident: ' + @Program + ' returned an error';
                SET @Body = 'The following record was added to SkyNet.Audit_Incident
                                                                                      
' +             'ServerName: ' + @ServerName + '
' +             'DatabaseName: ' + @DatabaseName + '
' +             'Program: ' + @Program + '
' +             'IncidentType: ' + @IncidentType + '
' +             'ErrorMessage: ' + @IncidentOutput + '
' +             'ErrorDate: ' + CAST(@IncidentDate AS VARCHAR(20)) + '
' +             'SourceFileName: ' + @SourceFileName;

                SELECT Email
                INTO #tempemail
                FROM inserted                    i
                    JOIN SkyNet.Audit_SignUpType st
                      ON i.SignUpTypeID  = st.SignUpTypeID
                    JOIN SkyNet.Audit_UserSignUp us
                      ON us.SignUpTypeID = st.SignUpTypeID
                    JOIN SkyNet.Audit_User       au
                      ON au.EmployeeID   = us.UserID
                    JOIN SkyNet.Audit_Database ds
                      ON us.DatabaseID = ds.DatabaseID
                WHERE 1 = CASE
                              WHEN i.IsIncident = 1 --if incident, email incident subscribers
                    THEN
                                  us.ReceiveIncident
                              ELSE
                                  us.Receivewarning --if warning, email warning subscribers
                          END
                 AND ds.DatabaseName = @DatabaseName;

                DECLARE @email VARCHAR(100);
                DECLARE @emailList VARCHAR(MAX) = '';

                WHILE (SELECT COUNT(*)FROM #tempemail) > 0
                    BEGIN
                        SELECT TOP 1
                               @email = Email
                        FROM #tempemail;

                        SET @emailList = @emailList + ';' + @email;

                        DELETE FROM #tempemail
                        WHERE Email = @email;
                    END;

                DROP TABLE #tempemail;

                DROP TABLE #tempIncident;

                IF (@emailList <> '') --Trigger Email only if email list is not empty
                    EXEC msdb.dbo.sp_send_dbmail @recipients = @emailList,
                                                 @profile_name = 'DBA',
                                                 @subject = @Subject,
                                                 @body = @Body;
            END;
    END;

