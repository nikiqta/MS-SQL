
-- INNER JOIN

SELECT e.FirstName +  ' '  + e.LastName AS EmployeeName, JobTitle, d.[Name] AS DepartmentName FROM Employees AS e
INNER JOIN Departments AS d ON e.DepartmentID = d.DepartmentID

-- LEFT OUTER JOIN

SELECT * FROM Employees AS e
LEFT OUTER JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID

-- RIGHT OUTER JOIN 

SELECT * FROM Employees AS e
RIGHT OUTER JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID

-- FULL JOIN 

SELECT * FROM Employees AS e
FULL JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID

-- CROSS JOIN

SELECT * FROM Employees AS e
CROSS JOIN Departments AS d


-- exercises
-- Addresses with Towns

SELECT TOP 50
		   e.FirstName,
		   e.LastName, 
		   t.[Name] 
		AS Town, 
		   a.AddressText 
      FROM Employees 
	    AS e
INNER JOIN Addresses 
        AS a 
        ON a.AddressID = e.AddressID
INNER JOIN Towns 
        AS t 
        ON t.TownID = a.TownID
  ORDER BY e.FirstName

-- Sales Employees

     SELECT 
	        e.EmployeeID,
			e.FirstName, 
			e.LastName,
			d.[Name] 
		 AS DepartmentName 
       FROM Employees 
	     AS e
 INNER JOIN Departments 
         AS d 
         ON d.DepartmentID = e.DepartmentID
        AND d.[Name] = 'Sales'
   ORDER BY e.EmployeeID

-- Employees Hired After

     SELECT 
			e.FirstName, 
			e.LastName,
			e.HireDate,
			d.[Name] 
		 AS DeptName 
       FROM Employees 
	     AS e
 INNER JOIN Departments 
         AS d 
         ON d.DepartmentID = e.DepartmentID
        AND d.[Name] 
		 IN ('Sales', 'Finance')
		AND e.HireDate > '1/1/1999'
   ORDER BY e.HireDate

-- Employee Summary

		 SELECT TOP 50
					e.EmployeeID,
					e.FirstName + ' ' + e.LastName
				 AS EmployeeName,
		 			m.FirstName + ' ' + m.LastName
				 AS ManagerName,
					d.[Name] 
				 AS DepartmentName 
			   FROM Employees 
				 AS e
	LEFT OUTER JOIN Employees AS m
				 ON e.ManagerID = m.EmployeeID
	LEFT OUTER JOIN Departments 
				 AS d 
				 ON d.DepartmentID = e.DepartmentID
		   ORDER BY e.EmployeeID ASC


-- Subqueries

       SELECT *
         FROM Employees 
           AS e
        WHERE DepartmentID = (
	   SELECT d.DepartmentID 
	     FROM Departments 
		   AS d
        WHERE d.[Name] = 'Finance')

-- exercises

-- Min Average Salary

   SELECT MIN(AverageSalary) 
       AS MinAverageSalary
     FROM
  (SELECT DepartmentID, AVG(Salary) 
       AS AverageSalary 
	 FROM Employees
 GROUP BY DepartmentID) 
       AS AverageSalariesByDepartment


-- Common Table Expressions

   WITH CTE_EmployeeInfo (FirstName, LastName, salary) 
	 AS
        (
 SELECT FirstName, LastName, salary 
   FROM Employees
        )
  
 SELECT * 
   FROM CTE_EmployeeInfo

-- Indices 

 CREATE 
 NONCLUSTERED INDEX IX_People_FirstName
                 ON People(FirstName, LastName)
 
 SELECT * FROM People
 WHERE FirstName = 'Rebecca'
 AND LastName = 'Van'
