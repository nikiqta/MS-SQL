
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

-- Stored Procedures without parameters

CREATE PROCEDURE usp_GetEmployeesBySeniority
AS
BEGIN
    SELECT * FROM Employees
	WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5
END

GO

EXEC dbo.usp_GetEmployeesBySeniority

EXEC sp_depends usp_GetEmployeesBySeniority

-- Stored Procedures with parameters


