CREATE PROCEDURE SkyNet.Insert_Audit_Transaction
(
    @StatusID         INT,          --  staus of the transaction, 1-Inprogress, 2-Committed, 3-Rolledback
    @TranSourceOfCode VARCHAR(100), --  sql program the transaction is being executed on
    @DatabaseName     VARCHAR(20)  = NULL,
    @SherpaActionID   INT          = NULL,
    @SourceFileName   VARCHAR(200) = NULL,
    @TransactionID    INT OUTPUT
)
AS -- return TransactionID to be used by other SPs nested inside the current transaction

    DECLARE @ServerID         INT,
            @DatabaseID       INT,
            @ServerDatabaseID INT;

    BEGIN
        --get server name and database name of the transaction being executed on, 
        --create new record for each if they do not exist in the database and unique assign id by auto increment
        IF NOT EXISTS (SELECT ServerName
                       FROM SkyNet.Audit_Server
                       WHERE ServerName = @@SERVERNAME)
            BEGIN
                INSERT INTO SkyNet.Audit_Server (ServerName)
                VALUES (@@SERVERNAME);
            END;


        IF NOT EXISTS (SELECT DatabaseName
                       FROM SkyNet.Audit_Database
                       WHERE DatabaseName = @DatabaseName)
            BEGIN
                INSERT INTO SkyNet.Audit_Database (DatabaseName)
                VALUES (@DatabaseName);
            END;

        --fetch the id of the database the transaction is being run on
        SET @DatabaseID = (SELECT DatabaseID
                           FROM SkyNet.Audit_Database
                           WHERE DatabaseName = @DatabaseName);

        --fetch the id of the database server the transaction is being run on
        SET @ServerID = (SELECT ServerID FROM SkyNet.Audit_Server WHERE ServerName = @@SERVERNAME);

        --if the unique pair of databaseid and serverid fetched from above do not already exist, create a new record and assign an unique id ServerDatabaseID by autoincrement
        IF NOT EXISTS (SELECT ServerDatabaseID
                       FROM SkyNet.Audit_ServerDatabase
                       WHERE ServerID   = @ServerID
                         AND DatabaseID = @DatabaseID)
            BEGIN
                INSERT INTO SkyNet.Audit_ServerDatabase (ServerID,
                                                         DatabaseID)
                VALUES (@ServerID,
                        @DatabaseID);
            END;

        -- get the id for unique pair of database and server 
        SET @ServerDatabaseID = (SELECT ServerDatabaseID
                                 FROM SkyNet.Audit_ServerDatabase
                                 WHERE ServerID   = @ServerID
                                   AND DatabaseID = @DatabaseID);

        --insert the id fetched above, to track the database and server , the transaction is being executed to
        INSERT INTO SkyNet.Audit_Transaction (StatusID,
                                              StartDateTime,
                                              TranSourceOfCode,
                                              SherpaActionID,
                                              SourceFileName,
                                              EndDateTime,
                                              ServerDatabaseID)
        VALUES (@StatusID,
                GETDATE(),
                @TranSourceOfCode,
                @SherpaActionID,
                @SourceFileName,
                NULL,
                @ServerDatabaseID);

        -- return the current TransactionID to be used by other nested procs inside the transaction
        SET @TransactionID = @@IDENTITY;

    END;
