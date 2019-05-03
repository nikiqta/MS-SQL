USE SoftUni

SELECT * FROM Departments

SELECT FirstName, LastName, JobTitle, Salary FROM Employees
WHERE Salary > 20000.00
ORDER BY Salary DESC

SELECT EmployeeID AS Id, FirstName, LastName, JobTitle, Salary FROM Employees
WHERE Salary > 20000.00
ORDER BY Salary DESC

SELECT d.DepartmentID, d.Name AS [DepartmentName], e.FirstName + ' ' + e.LastName AS ManagerName FROM Departments AS d
JOIN Employees AS e ON d.ManagerID = e.EmployeeID

SELECT FirstName + ' ' + LastName AS [Full Name],
       JobTitle AS [Job Title],
	   Salary
  FROM Employees

  SELECT DISTINCT DepartmentID
  FROM Employees


SELECT * FROM Employees
WHERE DepartmentID = 6

SELECT * FROM Employees
WHERE NOT (DepartmentID = 6 OR DepartmentID = 4)

SELECT * FROM Employees
WHERE DepartmentID NOT IN(6, 4)

SELECT * FROM Employees
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE [Name] = 'Marketing' )

GO

CREATE VIEW v_EmployeesNamesAndDepartments AS
SELECT d.DepartmentID, d.Name AS [DepartmentName], e.FirstName + ' ' + e.LastName AS ManagerName FROM Departments AS d
JOIN Employees AS e ON d.ManagerID = e.EmployeeID

GO

SELECT * FROM v_EmployeesNamesAndDepartments


USE Geography

SELECT TOP(16) * FROM Peaks
ORDER BY Elevation DESC

SELECT TOP 50 PERCENT * FROM Peaks
ORDER BY Elevation DESC

SELECT * 
INTO EmployeesNamesAndDepartments
FROM v_EmployeesNamesAndDepartments

SELECT * FROM EmployeesNamesAndDepartments

CREATE SEQUENCE seq_Customers_CustomerID
AS INT
START WITH 5
INCREMENT BY 10

SELECT NEXT VALUE FOR seq_Customers_CustomerID

SELECT * FROM EmployeesNamesAndDepartments

DELETE FROM EmployeesNamesAndDepartments
WHERE DepartmentID = 5

TRUNCATE TABLE EmployeesNamesAndDepartments

GO

SELECT * FROM Employees

GO

UPDATE Employees
SET MiddleName = 'Ivanov' 
WHERE EmployeeID = 3

SELECT * FROM Projects

UPDATE Projects
SET EndDate = GETDATE()
WHERE EndDate IS NULL