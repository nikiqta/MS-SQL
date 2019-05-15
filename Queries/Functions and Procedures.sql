
-- Functions
DROP FUNCTION dbo.udf_ProjectDurationWeeks

GO

-- ALTER FUNCTION command for existing function improvments or changes

CREATE FUNCTION udf_ProjectDurationWeeks (@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
--    DECLARE @ProjectWeeks INT = DATEDIFF(WEEK, @StartDate, @EndDate);
      DECLARE @ProjectWeeks INT;

	  IF(@EndDate IS NULL)
	  BEGIN
	     SET @EndDate = GETDATE();
	  END

	  SET @ProjectWeeks= DATEDIFF(WEEK, @StartDate, @EndDate);

	  RETURN @ProjectWeeks
END

GO

  SELECT 
         [Name], 
		 StartDate, 
		 EndDate,
		 dbo.udf_ProjectDurationWeeks(StartDate, EndDate) ProjectDurationWeeks
    FROM Projects

-- exercse - Salary Level

GO

ALTER FUNCTION udf_GetSalaryLevel (@Salary MONEY)
RETURNS VARCHAR(7)
AS
BEGIN
      DECLARE @SalaryLevel VARCHAR(7);

	  IF(@Salary < 30000)
	  BEGIN
	     SET @SalaryLevel = 'Low';
	  END

	  ELSE IF(@Salary BETWEEN 30000 AND 50000)
	  BEGIN
	     SET @SalaryLevel = 'Average';
	  END

	  ELSE
	  BEGIN
	     SET @SalaryLevel = 'High';
	  END

	  RETURN @SalaryLevel
END

GO

   SELECT 
          EmployeeID, 
		  FirstName, 
		  LastName, 
		  Salary, 
		  dbo.udf_GetSalaryLevel(Salary) SalaryLevel 
     FROM Employees

GO

   SELECT 
		  dbo.udf_GetSalaryLevel(Salary) SalaryLevel,
	COUNT (*) SalaryLevelStatistic
     FROM Employees
 GROUP BY dbo.udf_GetSalaryLevel(Salary)

GO

SELECT * FROM WizzardDeposits

GO

CREATE FUNCTION udf_GetAgeGroup(@Age INT)
RETURNS VARCHAR(10)
AS
BEGIN

  DECLARE @LowerBound INT = ((@Age - 1) / 10) * 10 + 1;
  DECLARE @UpperBound INT = (@LowerBound - 1) + 10;
  DECLARE @Result VARCHAR(10) = '[' + CAST(@LowerBound AS VARCHAR(3)) + '-' + CAST(@UpperBound AS VARCHAR(3)) + ']';
 
  RETURN @Result
END

GO 

   SELECT  
          dbo.udf_GetAgeGroup(Age) AgeRange,
		  COUNT(*) NumberoFWizzards
	 FROM WizzardDeposits
 GROUP BY dbo.udf_GetAgeGroup(Age)

GO

-- Stored Procedures without parameters and  with parameters

CREATE OR ALTER PROCEDURE usp_GetEmployeesBySeniority @HireYears INT
AS
BEGIN
    SELECT * FROM Employees
	WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > @HireYears
END

GO

EXEC dbo.usp_GetEmployeesBySeniority 2

EXEC sp_depends usp_GetEmployeesBySeniority

-- exercise Employees with three projects

GO

CREATE OR ALTER PROCEDURE usp_AddEmployeeToProject @EmployeeId INT, @ProjectId INT
AS
BEGIN
    DECLARE @EmployeeProjectCount INT;
	SET @EmployeeProjectCount = (SELECT COUNT(*) FROM EmployeesProjects
WHERE EmployeeID = @EmployeeId)

   IF(@EmployeeProjectCount > 2)
   BEGIN
   RAISERROR('Employee has too many projects!', 16, 1);
   RETURN
   END

   INSERT INTO EmployeesProjects ( EmployeeID, ProjectID )
   VALUES (@EmployeeId, @ProjectId)
END

GO

EXEC usp_AddEmployeeToProject 2, 6

-- Exercise Withraw Money

Use Bank

GO

CREATE OR ALTER PROC usp_WithdrawMoney @AccountId INT, @MoneyAmount DECIMAL(15, 2)
AS 
BEGIN
    DECLARE @CurrentBalance DECIMAL(15, 2);
	SET @CurrentBalance = (SELECT Balance FROM Accounts
	                       WHERE AccountHolderId = @AccountId);

        IF(@MoneyAmount < 0)
		BEGIN;
				   THROW 50000, 'Negative Amount Specified!', 1;
				   RETURN
		END

		IF(@CurrentBalance - @MoneyAmount < 0)
		BEGIN;
		   THROW 50000, 'Insufficient Funds!', 2;
		   RETURN
		END

		UPDATE Accounts
		SET Balance -= @MoneyAmount
		WHERE Id = @AccountId

END

GO

