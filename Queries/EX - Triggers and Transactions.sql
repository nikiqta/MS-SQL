
-- 1.	Create Table Logs
    USE Bank

    GO

	CREATE OR ALTER TRIGGER tr_ProccessTransaction
	ON Accounts	
	AFTER UPDATE
	AS
	BEGIN

		INSERT INTO Logs (AccountId, OldSum, NewSum)
		SELECT deleted.Id, deleted.Balance, inserted.Balance FROM inserted
		JOIN deleted ON deleted.Id = inserted.Id

	END

	GO
		
	SELECT * FROM Accounts

	SELECT * FROM Logs

	EXEC usp_TransferFunds 1, 2, 123.12

    EXEC usp_TransferFunds 2, 1, 123.12

-- 2.	Create Table Emails

GO
CREATE OR ALTER TRIGGER tr_ProccessNotificationEmails
ON Logs
AFTER INSERT
AS
BEGIN

	INSERT INTO NotificationEmails (Recipient, [Subject], Body)	
	SELECT 
		   inserted.AccountId,
		   'Balance change for account: ' + CAST(inserted.AccountId AS nvarchar),
		   'On ' + (SELECT FORMAT(GETDATE(), 'MMM dd MM yyyy hh:mm tt'))  + ' your balance was changed from ' + CAST(inserted.OldSum AS NVARCHAR) + ' to ' +  CAST(inserted.NewSum AS NVARCHAR) + '.'
	  FROM inserted

END

-- 3.	Deposit Money

GO

CREATE OR ALTER PROC usp_DepositMoney @AccountId INT, @MoneyAmount DECIMAL(18, 4)
AS
BEGIN
    BEGIN TRANSACTION

			IF(@MoneyAmount <= 0)
			BEGIN
				RAISERROR('Zero or Negative Amount Specified!', 16, 1);
				ROLLBACK;
				RETURN
			END

			UPDATE Accounts
			SET Balance += @MoneyAmount
			WHERE Id = @AccountId

			IF(@@ROWCOUNT <> 1)
			BEGIN
				RAISERROR('Invalid Account ID!', 16, 1);
				ROLLBACK;
				RETURN
			END

	COMMIT
END

GO

EXEC usp_DepositMoney 1, 24

SELECT * FROM Accounts

SELECT * FROM Logs

SELECT * FROM NotificationEmails

-- 4.	Withdraw Money

GO

CREATE OR ALTER PROC usp_WithdrawMoney @AccountId INT, @MoneyAmount DECIMAL(18, 4)
AS
BEGIN
    BEGIN TRANSACTION

			IF(@MoneyAmount <= 0)
			BEGIN
				RAISERROR('Zero or Negative Amount Specified!', 16, 1);
				ROLLBACK;
				RETURN
			END

			UPDATE Accounts
			SET Balance -= @MoneyAmount
			WHERE Id = @AccountId

			IF(@@ROWCOUNT <> 1)
			BEGIN
				RAISERROR('Invalid Account ID!', 16, 1);
				ROLLBACK;
				RETURN
			END

		    DECLARE @FinalAmount DECIMAL(15, 2);
			SET @FinalAmount = (SELECT Balance FROM Accounts WHERE Id = @AccountId );

			IF(@FinalAmount < 0)
			BEGIN
				RAISERROR('Insufficient Frunds!', 16, 1);
				ROLLBACK;
				RETURN
			END

	COMMIT
END

EXEC usp_DepositMoney 1, 100

EXEC usp_WithdrawMoney 1, 100

SELECT * FROM Accounts

SELECT * FROM Logs

SELECT * FROM NotificationEmails

-- 5. Money Transfer

GO

CREATE OR ALTER PROC usp_TransferMoney @SenderId INT, @ReceiverId INT, @Amount DECIMAL(15, 4)
AS
BEGIN
    BEGIN TRANSACTION

	    IF(@Amount <= 0)
		BEGIN
		    RAISERROR('Zero or Negative Amount Specified!', 16, 1);
		END

		UPDATE Accounts
		SET Balance -= @Amount
		WHERE Id = @SenderId 

		IF(@@ROWCOUNT <> 1)
		BEGIN
		    RAISERROR('Invalid Source Account ID!', 16, 1);
			ROLLBACK;
			RETURN
		END

		DECLARE @FinalAmount DECIMAL(15, 2);
		SET @FinalAmount = (SELECT Balance FROM Accounts WHERE Id = @SenderId );

		IF(@FinalAmount < 0)
		BEGIN
		    RAISERROR('Insufficient Frunds!', 16, 1);
			ROLLBACK;
			RETURN
		END

		UPDATE Accounts
		SET Balance += @Amount
		WHERE Id = @ReceiverId

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

EXEC usp_TransferMoney 1, 2, 123.12

EXEC usp_TransferMoney 2, 1, 123.12

-- 6.	Trigger

USE Diablo

SELECT u.Username, g.[Name], ug.Cash, i.[Name] FROM Users u
JOIN UsersGames ug ON ug.UserId = u.Id
JOIN UserGameItems ugi ON ugi.ItemId = ug.Id
JOIN Items i ON i.Id = ugi.ItemId
JOIN Games g ON g.Id = ug.GameId
WHERE g.[Name] = 'Bali' AND u.Username = 'baleremuda'

-- 7.	Massive Shopping*
   USE Diablo

   DECLARE @UserId INT = (SELECT Id FROM Users WHERE Username = 'Stamat');
   DECLARE @GameId INT = (SELECT Id FROM Games WHERE [Name] = 'Safflower');
   DECLARE @UserGameId INT = (SELECT Id FROM UsersGames WHERE UserId = @UserId AND GameId = @GameId);

   BEGIN TRY
	   BEGIN TRANSACTION

		   UPDATE UsersGames
		   SET Cash -= (SELECT SUM(Price) FROM Items WHERE MinLevel IN (11, 12))
		   WHERE Id = @UserGameId

		   DECLARE @UserBalance DECIMAL(15, 2);
		   SET @UserBalance = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId);

		   IF(@UserBalance < 0)
		   BEGIN
		   RAISERROR('Not enough money!', 16, 1);
		   ROLLBACK
		   RETURN
		   END

		   INSERT INTO UserGameItems
		   SELECT Id, @UserGameId FROM Items
		   WHERE MinLevel IN (11, 12)
	   COMMIT
	END TRY
	BEGIN CATCH
	END CATCH

	BEGIN TRY
			BEGIN TRANSACTION

			UPDATE UsersGames
			SET Cash -= (SELECT SUM(Price) FROM Items WHERE MinLevel IN (19, 20, 21))
			WHERE Id = @UserGameId

			SET @UserBalance = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId);

			IF(@UserBalance < 0)
			BEGIN
			RAISERROR('Not enough money!', 16, 1);
			ROLLBACK
			RETURN
			END

			INSERT INTO UserGameItems
			SELECT Id, @UserGameId FROM Items
			WHERE MinLevel IN (19, 20, 21)
		COMMIT
   	END TRY
	BEGIN CATCH
	END CATCH


    SELECT i.[Name] FROM Items i
    JOIN UserGameItems ugi ON ugi.ItemId = i.Id
    WHERE ugi.UserGameId = @UserGameId
    ORDER BY i.[Name]

-- 8.	Employees with Three Projects
USE SoftUni

GO

CREATE OR ALTER PROCEDURE usp_AssignProject @EmployeeId INT, @ProjectId INT
AS
BEGIN
      BEGIN TRANSACTION

		   DECLARE @EmployeeProjectCount INT;
		   SET @EmployeeProjectCount = (SELECT COUNT(*) FROM EmployeesProjects
										 WHERE EmployeeID = @EmployeeId);

		   IF(@EmployeeProjectCount > 2)
		   BEGIN
		   RAISERROR('Employee has too many projects!', 16, 1);
		   ROLLBACK;
		   RETURN
		   END

		   INSERT INTO EmployeesProjects ( EmployeeID, ProjectID )
		   VALUES (@EmployeeId, @ProjectId)

		   IF(@@ROWCOUNT <> 1)
		   BEGIN
				RAISERROR('Invalid Employee ID Or Project ID!', 16, 1);
				ROLLBACK;
				RETURN
		   END

	  COMMIT
END

GO

EXEC usp_AssignProject 6, 6656456

SELECT e.EmployeeID, COUNT(ep.ProjectID) ProjectsCount FROM Employees e
JOIN EmployeesProjects ep ON ep.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID

-- 9.	Delete Employees

CREATE TABLE DeletedEmployees(
EmployeeId INT IDENTITY PRIMARY KEY, 
FirstName NVARCHAR(50) NOT NULL, 
LastName NVARCHAR(50) NOT NULL, 
MiddleName NVARCHAR(50) NOT NULL, 
JobTitle NVARCHAR(50) NOT NULL, 
DepartmentId INT NOT NULL, 
Salary DECIMAL(15, 2) NOT NULL
)

GO

CREATE OR ALTER TRIGGER tr_ProccessDeletedEmployees
ON Employees	
AFTER DELETE
AS
BEGIN

    INSERT INTO DeletedEmployees(FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
	SELECT deleted.FirstName, deleted.LastName, deleted.MiddleName, deleted.JobTitle, deleted.DepartmentID, deleted.Salary FROM deleted

END

