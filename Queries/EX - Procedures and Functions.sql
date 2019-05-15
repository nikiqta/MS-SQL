USE SoftUni

SELECT * FROM AccountHolders AS ah
JOIN Accounts AS a ON a.AccountHolderId = ah.Id 

-- 1.	Employees with Salary Above 35000

GO

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
    SELECT FirstName, LastName FROM Employees
	WHERE Salary > 35000
END

GO

EXEC usp_GetEmployeesSalaryAbove35000

-- 2.	Employees with Salary Above Number

GO

CREATE OR ALTER PROCEDURE usp_GetEmployeesSalaryAboveNumber @Number DECIMAL(18, 4)
AS
BEGIN
    SELECT FirstName, LastName FROM Employees
	WHERE Salary >= @Number
END

GO

EXEC usp_GetEmployeesSalaryAboveNumber 48100

-- 3.	Town Names Starting With

GO

CREATE PROCEDURE usp_GetTownsStartingWith @TownName NVARCHAR(50)
AS
BEGIN
  SELECT [Name] AS Town FROM Towns
  WHERE [Name] Like  @TownName + '%'
END

GO

EXEC usp_GetTownsStartingWith 'b'

-- 4.	Employees from Town

GO

CREATE PROCEDURE usp_GetEmployeesFromTown  @TownName NVARCHAR(50)
AS
BEGIN

  SELECT e.FirstName, e.LastName FROM Employees AS e
  JOIN Addresses AS ad ON ad.AddressID = e.AddressID
  JOIN Towns AS t ON t.TownID = ad.TownID
  WHERE t.[Name] =  @TownName

END

GO

EXEC usp_GetEmployeesFromTown 'Sofia'

-- 5.	Salary Level Function

GO

CREATE FUNCTION ufn_GetSalaryLevel (@Salary DECIMAL(18, 4))
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

SELECT Salary, dbo.udf_GetSalaryLevel(Salary) AS [Salary Level] FROM Employees

-- 6.	Employees by Salary Level

GO

CREATE PROC usp_EmployeesBySalaryLevel @SalaryLevel VARCHAR(7)
AS 
BEGIN

     SELECT
	        e.FirstName,
			e.LastName
	   FROM Employees AS e
	   JOIN (
				 SELECT 
			   DISTINCT
						Salary, 
						dbo.udf_GetSalaryLevel(Salary) [Salary Level] 
				   FROM Employees
			) ss
		 ON ss.Salary = e.Salary
	  WHERE [Salary Level] = @SalaryLevel

END

GO

EXEC usp_EmployeesBySalaryLevel 'High'

-- 7.	Define Function

GO

CREATE OR ALTER FUNCTION ufn_IsWordComprised(@SetOfLetters NVARCHAR(50), @Word NVARCHAR(50))
RETURNS BIT
	BEGIN

		 DECLARE @IsMatch BIT = 1;
		 DECLARE @Index INT = 1; 
		 DECLARE @CurrentLetter CHAR;

		 WHILE
			   @Index <= LEN(@Word) 
				  BEGIN  
						SET @CurrentLetter = (SELECT SUBSTRING(@Word, @Index, 1));

      					IF(CHARINDEX(@CurrentLetter, @SetOfLetters, 1) < 1)
							BEGIN
								SET @IsMatch = 0;
								BREAK
							END

					    SET @Index += 1;
				  END

	  RETURN @IsMatch
	END

GO

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia') AS Result
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'halves') AS Result
SELECT dbo.ufn_IsWordComprised('bobr', 'Rob') AS Result
SELECT dbo.ufn_IsWordComprised('pppp', 'Guy') AS Result

-- 8.	Delete Employees and Departments* 

GO

CREATE PROC usp_GetEmployeeIDsFromDepartment (@DepartmentId INT)
AS
BEGIN
 SELECT EmployeeID 
	  FROM Employees
	 WHERE DepartmentID = @DepartmentId
END


GO

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment @DepartmentId INT
AS
BEGIN

    DELETE 
	  FROM EmployeesProjects
     WHERE EmployeeID IN (
    SELECT EmployeeID 
	  FROM Employees
	 WHERE DepartmentID = @DepartmentId);

	 ALTER TABLE Departments
	 ALTER COLUMN ManagerId INT NULL

	UPDATE Departments
	   SET ManagerID = NULL
	 WHERE ManagerID IN (
    SELECT EmployeeID 
	  FROM Employees
	 WHERE DepartmentID = @DepartmentId)

    UPDATE Employees
	   SET ManagerID = NULL
	 WHERE ManagerID IN (
    SELECT EmployeeID 
	  FROM Employees
	 WHERE DepartmentID = @DepartmentId)

    DELETE 
	  FROM Employees
     WHERE DepartmentID = @DepartmentId

	DELETE 
	  FROM Departments
     WHERE DepartmentID = @DepartmentId

END 

GO

-- 9.	Find Full Name

USE Bank

GO

CREATE PROCEDURE usp_GetHoldersFullName 
AS
BEGIN
  
  SELECT FirstName + ' ' + LastName AS [Full Name] FROM  AccountHolders
END

GO

EXEC usp_GetHoldersFullName

-- 10.	People with Balance Higher Than

GO

CREATE OR ALTER PROCEDURE usp_GetHoldersWithBalanceHigherThan @Number DECIMAL(18, 4)
AS
BEGIN
      SELECT ah.FirstName, ah.LastName FROM Accounts AS ac
	  JOIN AccountHolders AS ah ON ah.Id = ac.AccountHolderId
	  WHERE Balance > @Number
END

GO

EXEC usp_GetHoldersWithBalanceHigherThan 1000
   
-- 11.	Future Value Function

GO

CREATE OR ALTER FUNCTION ufn_CalculateFutureValue (@InitialSum DECIMAL(18, 4), @YearlyInterestRate FLOAT, @NumberOFYears INT)
RETURNS DECIMAL(15, 2)
AS
BEGIN
    DECLARE @Result DECIMAL(15, 2);

	SET @Result = @InitialSum * POWER((1 + @YearlyInterestRate), @NumberOFYears) 

	RETURN @Result
END

GO

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5) AS Result

-- 12.	Calculating Interest

GO

CREATE PROC usp_CalculateFutureValueForAccount  
AS
BEGIN
      SELECT ac.AccountHolderId [Account Id], ah.FirstName [First Name], ah.LastName [Last Name], ac.Balance AS [Current Balance],
	  dbo.ufn_CalculateFutureValue(Balance, 0.1, 5) AS [Balance in 5 years]
	    FROM Accounts AS ac
	  JOIN AccountHolders AS ah ON ah.Id = ac.AccountHolderId
END

GO

EXEC usp_CalculateFutureValueForAccount

-- 13.	Scalar Function: Cash in User Games Odd Rows*
USE Diablo

GO

CREATE FUNCTION ufn_CashInUsersGames (@GameName VARCHAR(50))
RETURNS DECIMAL(15, 2)
AS
BEGIN

       DECLARE @ResultSum DECIMAL(15, 2)
     SET @ResultSum = (
	                   SELECT 
	                      SUM (Cash) 
						 FROM (
								SELECT 
								       g.[Name], 
                                        ug.Cash,
						    ROW_NUMBER ()  
								  OVER (
							  ORDER BY ug.Cash 
								  DESC ) [Row]
			                      FROM Games g
			                      JOIN UsersGames ug 
						            ON ug.GameId = g.Id
								 WHERE g.[Name] = @GameName
							  ) OnlyOddRows
								 WHERE ([Row]) % 2 != 0
			                     GROUP BY [Name]
					 );
   RETURN @ResultSum
END

GO

SELECT dbo.ufn_CashInUsersGames('Love in a mist') AS SumCash