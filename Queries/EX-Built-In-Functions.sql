
-- 1.	Find Names of All Employees by First Name

SELECT FirstName, Lastname FROM Employees
WHERE FirstName Like 'SA%'

-- 2.	Find Names of All employees by Last Name 

SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%'

-- 3.	Problem 3.	Find First Names of All Employees

SELECT FirstName FROM Employees
WHERE DepartmentID IN(3, 10) AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

-- 4.	Find All Employees Except Engineers

SELECT FirstName, LastName FROM Employees
WHERE JobTitle NOT LIKE('%engineer%')

-- 5.	Find Towns with Name Length

SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT [Name] FROM Towns
WHERE DATALENGTH([Name]) BETWEEN 5 AND 6
ORDER BY [Name]

-- 6.	Find Towns Starting With

SELECT * FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

-- 7.	Find Towns Not Starting With

SELECT * FROM Towns
WHERE [Name] LIKE '[^RBD]%'
ORDER BY [Name]

-- 8.	Create View Employees Hired After 2000 Year
GO

CREATE VIEW v_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000

GO

SELECT * FROM v_EmployeesHiredAfter2000

-- 9.	Length of Last Name

SELECT FirstName, LastName FROM Employees
WHERE DATALENGTH(LastName) = 5

-- 10.	Countries Holding ‘A’ 3 or More Times

USE Geography

SELECT CountryName, IsoCode FROM Countries
WHERE CountryName LIKE '%A%A%A%' 
ORDER BY IsoCode

-- 11.	Mix of Peak and River Names

SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT PeakName, RiverName, LOWER(PeakName + RiverName) AS Mix FROM Rivers , Peaks
WHERE RiverName LIKE SUBSTRING(PeakName, LEN(PeakName) , 1) + '%'
ORDER BY Mix

-- 12.	Games from 2011 and 2012 year

USE Diablo

SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start] FROM Games
WHERE DATEPART(YEAR, [Start]) IN (2011, 2012)
ORDER BY [Start], [Name]

-- 13.	 User Email Providers

SELECT * FROM Users

SELECT Username,
SUBSTRING(Email, CHARINDEX('@', Email) + 1, 100) AS [Email Provider]
FROM Users
ORDER BY [Email Provider], Username


-- 14.	Get Users with IPAdress Like Pattern

SELECT Username, IpAddress AS [IP Addresses] FROM Users
WHERE IpAddress LIKE '[0-9][0-9][0-9].1[0-9]*.[0-9]*.[0-9][0-9][0-9]'
ORDER BY Username