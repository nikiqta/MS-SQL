USE Gringotts

SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT * FROM WizzardDeposits

-- 1.	Records’ Count

SELECT COUNT(*) AS [Count] FROM WizzardDeposits

-- 2.	Longest Magic Wand

SELECT MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits

-- 3.	Longest Magic Wand per Deposit Groups

SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits
GROUP BY DepositGroup

-- 4.	Smallest Deposit Group per Magic Wand Size *

SELECT TOP(2) DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

-- 5.	Deposits Sum

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
GROUP BY DepositGroup

-- 6.	Deposits Sum for Ollivander Family

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-- 7.	Deposits Filter

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-- 8.	 Deposit Charge

SELECT DepositGroup,
  MagicWandCreator,
  MIN(DepositCharge) AS MinDepositCharge
  FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup 

-- 9.	Age Groups

SELECT
    CASE 
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
		WHEN Age > 60 THEN '[61+]'
     END AS AgeGroup,
	  COUNT(*) AS WizzardCount
    FROM WizzardDeposits
   GROUP BY 
   CASE
       WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
       WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
	   WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	   WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	   WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
	   WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
	   WHEN Age > 60 THEN '[61+]'
	END

-- 10.	First Letter

SELECT DISTINCT LEFT(FirstName, 1) AS FirstLetter FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
ORDER BY  FirstLetter

-- 11.	Average Interest

SELECT * FROM WizzardDeposits

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest FROM WizzardDeposits
WHERE YEAR(DepositStartDate) > 1984
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

-- 12. Rich Wizzard, Poor Wizzard*

SELECT SUM(SumDifference) AS SumDifference FROM
(
SELECT DepositAmount - LEAD(DepositAmount) OVER(ORDER BY Id ASC) AS SumDifference
FROM WizzardDeposits
) AS Diffs

-- 13.	Departments Total Salaries

USE SoftUni

SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT DepartmentID, SUM(Salary)  AS MinimumSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

-- 14.	Problem 14.	Employees Minimum Salaries

SELECT DepartmentID, MIN(Salary)  AS MinimumSalary FROM Employees
WHERE DepartmentID IN (2, 5, 7) AND HireDate > '01/01/2000'
GROUP BY DepartmentID

-- 15.	Employees Average Salaries

SELECT * FROM Employees
WHERE Salary > 30000

SELECT *
INTO NewTable
FROM Employees
WHERE Salary > 30000

SELECT * FROM NewTable

DELETE FROM NewTable
WHERE ManagerID = 42

SELECT * FROM NewTable

UPDATE NewTable
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary FROM NewTable
GROUP BY DepartmentID

-- 16.	Employees Maximum Salaries

SELECT DepartmentID, MAX(Salary) AS MaxSalary FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- 17.	Employees Count Salaries

SELECT * FROM Employees

SELECT COUNT(*) - COUNT(ManagerID)  AS [Count] FROM Employees

-- 18.	3rd Highest Salary *

SELECT DepartmentID, Salary AS ThirdHighestSalary FROM
(
   SELECT DepartmentID,
   MAX(Salary) AS Salary,
   DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
   FROM Employees
   GROUP BY DepartmentID, Salary
) AS RankedSalaries
WHERE Rank = 3

-- 19.	Salary Challenge **

SELECT TOP(10) e1.FirstName, e1.LastName, e1.DepartmentID FROM Employees AS e1
WHERE Salary > (SELECT AVG(Salary) FROM Employees AS e2
WHERE e2.DepartmentID = e1.DepartmentID
GROUP BY DepartmentID)
ORDER BY e1.DepartmentID