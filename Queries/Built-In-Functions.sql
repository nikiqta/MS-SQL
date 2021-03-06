USE SoftUni

-- STRING FUNCTIONS

SELECT * FROM Employees

SELECT CONCAT('Gosho', NULL, 'Ivanov') AS FullName

SELECT CONCAT('Gosho', 'Goshev', 'Ivanov') AS FullName

SELECT SUBSTRING('SoftUni', 5, 3)

SELECT SUBSTRING(LastName, 1, 4) AS ShortLastName, * FROM Employees

SELECT REPLACE('SoftUni', 'Soft', 'Hard') AS brbr

SELECT LTRIM('     SoftUni')

SELECT RTRIM('SoftUni      ')

SELECT LEN('SoftUni      ')

SELECT DATALENGTH('          SoftUni  ')

SELECT LEFT('SoftUni', 4)

SELECT RIGHT('SoftUni', 3)

USE Diablo

SELECT Id, LEFT([Name], 3) AS ShortHand, [Start] FROM Games

USE Demo

SELECT CustomerID,
	   FirstName,
	   LastName,
	   LEFT(PaymentNumber, 6) + REPLICATE('*', LEN(PaymentNumber) - 6) AS PrivatePaymentNumber
 FROM Customers


SELECT LOWER('SoftUni')

SELECT UPPER('SoftUni')

SELECT REVERSE('SoftUni')

SELECT CHARINDEX('Uni', 'SoftUni')

SELECT STUFF('SoftUni', 1, 0, 'Test')

-- MATH FUNCTIONS

SELECT Id, A, H, (A * H) / 2 AS Area FROM Triangles2

SELECT PI()

SELECT ABS(10 - 25)

SELECT SQRT(36)

SELECT SQUARE(10)

SELECT POWER(2, 4)

SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT * FROM Lines

SELECT *,
 SQRT(SQUARE(X1 - X2) + SQUARE(Y1 - Y2)) AS LinesLenght 
 FROM Lines

 SELECT ROUND(165.12121212, 2)


 SELECT FLOOR(165.121212)

 SELECT CEILING(165.121212)

 SELECT *, 
        CEILING(
	      CEILING(
		   CAST(Quantity AS float) / BoxCapacity) / PalletCapacity)
		   AS [Number of pallets]
		   FROM Products

 SELECT SIGN(5)

 SELECT SIGN(-1)

 SELECT SIGN(0)

 SELECT RAND()

 -- DATE FUNCTIONS

SELECT DATEPART(YEAR, '2019-04-19 12:55:08')

SELECT DATEPART(MONTH, '2019-04-19 12:55:08')

SELECT DATEPART(DAY, '2019-04-19 12:55:08')

SELECT DATEPART(HOUR, '2019-04-19 12:55:08')

SELECT DATEPART(MINUTE, '2019-04-19 12:55:08')

SELECT DATEPART(SECOND, '2019-04-19 12:55:08')

USE ORDERS

SELECT 
  DATEPART(QUARTER, OrderDate) AS [Quarter],
  DATEPART(MONTH, OrderDate) AS [Month],
  DATEPART(YEAR, OrderDate) AS [Year],
  DATEPART(DAY, OrderDate) AS [Day]
   FROM Orders

SELECT DATEDIFF(DAY, '1989-01-23', '2019-04-19')

SELECT DATENAME(MONTH, OrderDate) AS StartMonth FROM Orders

SELECT FORMAT(DATEADD(MONTH, 1, '11-12-2016'), 'dd-MM-yyyy')

SELECT FORMAT(GETDATE(), 'MMM dd MM yyyy hh:mm tt')

-- OTHER FUNCTIONS

SELECT CAST(12.5 AS INT)

SELECT CAST(12.532312312 AS DECIMAL(6, 2))

SELECT CAST(GETDATE() AS INT)

SELECT CONVERT(DATE, '12-11-2016', 103)

SELECT ISNULL('Data', 'Should not be null')

SELECT ISNULL(NULL, 'Should not be null')

USE SoftUni

SELECT * FROM Employees
ORDER BY EmployeeID
OFFSET 50 ROWS
FETCH NEXT 10 ROWS ONLY

SELECT * FROM Employees
WHERE FirstName LIKE 'B%'

SELECT * FROM Employees
WHERE FirstName LIKE '%A'

SELECT * FROM Employees
WHERE FirstName LIKE '%ul%'

SELECT * FROM Employees
WHERE FirstName LIKE '__ul%'

SELECT * FROM Employees
WHERE FirstName LIKE '[PA]%'

SELECT * FROM Employees
WHERE FirstName LIKE '[^PA]%'

SELECT * FROM Employees
WHERE FirstName LIKE '[A-C]%'