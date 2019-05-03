USE SoftUni

SELECT DISTINCT DepartmentID FROM Employees
GROUP BY DepartmentID

SELECT DISTINCT DepartmentID FROM Employees

SELECT DISTINCT DepartmentID, SUM(salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DISTINCT DepartmentID, MIN(salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DISTINCT DepartmentID, MAX(salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DepartmentID, COUNT(Salary) FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DepartmentID, AVG(Salary) FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DepartmentID, ROUND(AVG(Salary), 2) AS AverageSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DepartmentID, COUNT(*) FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DepartmentID, AVG(Salary) AS AverageSalary FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 20000
ORDER BY DepartmentID
