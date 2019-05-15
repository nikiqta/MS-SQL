
-- TRANSACTIONS

GO

CREATE OR ALTER PROC usp_TransferFunds @AccountIdSource INT, @AccountIdDestination INT, @Amount DECIMAL(15, 2)
AS
BEGIN
    BEGIN TRANSACTION

	    IF(@Amount <= 0)
		BEGIN
		    RAISERROR('Zero or Negative Amount Specified!', 16, 1);
		END

		UPDATE Accounts
		SET Balance -= @Amount
		WHERE Id = @AccountIdSource 

		IF(@@ROWCOUNT <> 1)
		BEGIN
		    RAISERROR('Invalid Source Account ID!', 16, 1);
			ROLLBACK;
			RETURN
		END

		DECLARE @FinalAmount DECIMAL(15, 2);
		SET @FinalAmount = (SELECT Balance FROM Accounts WHERE Id = @AccountIdSource );

		IF(@FinalAmount < 0)
		BEGIN
		    RAISERROR('Insufficient Frunds!', 16, 1);
			ROLLBACK;
			RETURN
		END

		UPDATE Accounts
		SET Balance += @Amount
		WHERE Id = @AccountIdDestination

		IF(@@ROWCOUNT <> 1)
		BEGIN
		    RAISERROR('Invalid Destination Account ID!', 16, 2);
			ROLLBACK;
			RETURN
		END

		COMMIT
END

GO

SELECT * FROM Accounts

EXEC usp_TransferFunds 1, 2, 1230.12

EXEC usp_TransferFunds 2, 1, 1230.12

-- ACID MODEL

   -- Atomicity
      -- Atomicity means that:

			--Transactions execute as a whole

			--DBMS guarantees that either all of the
			--operations are performed or none of them

			--Example: Transferring funds between bank accounts

			--Either withdraw + deposit both succeed, or none of them do

			--In case of failure, the database stays unchanged

   -- Consistency

       -- Consistency means that:

			--The database has a legal state in both the transaction’s beginning
			--and end

			--Only valid data will be written to the DB

			--Transaction cannot break the rules of
			--the database

			--Primary keys, foreign keys, check constraints…

			--Consistency example:

			--Transaction cannot end with a duplicate primary key in a table
   -- Isolatiion

	   -- Isolation means that:

			--Multiple transactions running at the same time do not impact
			--each other’s execution

			--Transactions don’t see other
			--transactions’ uncommitted changes

			--Isolation level defines how deep
			--transactions isolate from one another

			--Isolation example:

			--If two or more people try to buy the last copy of a product, only
			--one of them will succeed
   -- Durability

	     -- Durability means that:

			--If a transaction is committed it becomes persistent

			--Cannot be lost or undone

			--Ensured by use of database transaction logs

			--Durability example:

			--After funds are transferred and committed the power supply at
			--the DB server is lost

			--Transaction stays persistent (no data is lost)


-- TRIGERS

   -- AFTER TRIGERS - INSERT / UPDATE / DELETE

		GO

		CREATE OR ALTER TRIGGER tr_ProccessTransaction
		ON Accounts	
		AFTER UPDATE
		AS
		BEGIN

		    INSERT INTO Transactions (AccountId, OldBalance, NewBalance, Amount, [DateTime])
			SELECT deleted.Id, deleted.Balance, inserted.Balance, ABS(deleted.Balance - inserted.balance), GETDATE() FROM inserted
			JOIN deleted ON deleted.Id = inserted.Id

		END

		GO

		SELECT * FROM Accounts

		UPDATE Accounts
		SET Balance -= 50
		WHERE Id = 1

		SELECT * FROM Transactions

		EXEC usp_TransferFunds 2, 1, 123.12

   -- INSTED OF TRIGERS - INSERT / UPDATE / DELETE
        
	GO

	CREATE TRIGGER tr_DeleteClient
	ON AccountHolders
	INSTEAD OF DELETE
	AS
	BEGIN
	-- Just an example does not really work, IsActive does not exist as a column in the table
		UPDATE AccountHolders
		SET IsActive = 0
		FROM AccountHolders ah
		JOIN deleted d ON ah.Id = d.Id
		WHERE d.IsActive = 1
	END

	DELETE FROM AccountHolders
	WHERE Id = 3


    SELECT IS_MEMBER('db_owner')