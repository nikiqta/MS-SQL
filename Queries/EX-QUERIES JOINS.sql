USE SoftUni

-- 1.	Employee Address

  SELECT TOP (5)
             e.EmployeeID,
			 e.JobTitle,
			 e.AddressID,
			 a.AddressText 
	    FROM Employees 
		  AS e
        JOIN Addresses 
		  AS a 
		  ON e.AddressID = a.AddressID
    ORDER BY e.AddressID

-- 2.	Addresses with Towns

  SELECT TOP (50) 
             e.FirstName, 
			 e.LastName ,
			 t.[Name] AS Town,
			 a.AddressText
	    FROM Employees 
		  AS e
        JOIN Addresses 
		  AS a 
		  ON a.AddressID = e.AddressID
        JOIN Towns 
		  AS t 
		  ON t.TownID = a.TownID
    ORDER BY e.FirstName, e.LastName

-- 3.	Sales Employee

   SELECT 
          e.EmployeeID, 
		  e.FirstName, 
		  e.LastName, 
		  d.[Name] 
     FROM Employees 
	   AS e
     JOIN Departments 
	   AS d 
	   ON d.DepartmentID = e.DepartmentID 
	  AND d.[Name] = 'Sales'
 ORDER BY e.EmployeeID

 -- 4.	Employee Departments

 SELECT TOP (5)
            e.EmployeeID, 
			e.FirstName, 
			Salary, 
			d.[Name] AS DepartmentName 
	   FROM Employees 
	     AS e
       JOIN Departments 
	     AS d 
		 ON d.DepartmentID = e.DepartmentID 
		AND e.Salary > 15000
   ORDER BY e.DepartmentID
        ASC


-- 5.	Employees Without Project

	SELECT TOP (3) 
				EmployeeID, 
				FirstName 
			FROM Employees
		WHERE EmployeeID 
		NOT IN (
        SELECT 
        DISTINCT EmployeeID 
            FROM EmployeesProjects
			    )
        ORDER BY EmployeeID 
		    ASC

SELECT * FROM INFORMATION_SCHEMA.TABLES

-- 6.	Employees Hired After

   SELECT 
		  e.FirstName, 
		  e.LastName,
		  e.HireDate, 
		  d.[Name] 
	   AS DeptName
     FROM Employees 
	   AS e
     JOIN Departments 
	   AS d 
	   ON d.DepartmentID = e.DepartmentID 
	  AND d.[Name] IN ('Sales', 'Finance')
	  AND e.HireDate > '01-01-1999'
 ORDER BY e.HireDate
      ASC

-- 7.	Employees with Project

SELECT TOP (5) 
           e.EmployeeID, 
		   e.FirstName, 
		   p.[Name] 
        AS ProjectName
	  FROM Employees 
	    AS e
      JOIN EmployeesProjects 
	    AS ep 
		ON ep.EmployeeID = e.EmployeeID
      JOIN Projects 
	    AS p 
		ON p.ProjectID = ep.ProjectID
	 WHERE p.StartDate > '2002-08-13'
       AND p.EndDate 
   IS NULL
  ORDER BY e.EmployeeID 
       ASC

-- 8.	Employee 24

    SELECT 
           e.EmployeeID, 
		   e.FirstName,
	  CASE
	  WHEN YEAR(p.StartDate) >= 2005 
	  THEN 'NULL'
	  ELSE p.[Name]
       END 
		AS ProjectName
	  FROM Employees 
	    AS e
      JOIN EmployeesProjects 
	    AS ep 
		ON ep.EmployeeID = e.EmployeeID
	   AND ep.EmployeeID = 24
      JOIN Projects 
	    AS p 
		ON p.ProjectID = ep.ProjectID
  ORDER BY e.EmployeeID 
       ASC

-- 9.	Employee Manager

   SELECT 
          e.EmployeeID, 
		  e.FirstName, 
		  e.ManagerID, 
		  e2.FirstName 
	   AS ManagerName 
     FROM Employees 
	   AS e
     JOIN Employees 
	   AS e2 
	   ON e2.EmployeeID = e.ManagerID
    WHERE e.ManagerID 
	   IN (3,7)
 ORDER BY EmployeeID 
      ASC

-- 10.	Employee Summary

   SELECT 
      TOP (50)
          e.EmployeeID, 
		  e.FirstName + ' ' + e.LastName
	   AS EmployeeName, 
		  e2.FirstName + ' ' + e2.LastName
	   AS ManagerName,
	      d.[Name] 
	   AS DepartmentName
     FROM Employees 
	   AS e
     JOIN Employees 
	   AS e2 
	   ON e2.EmployeeID = e.ManagerID
	 JOIN Departments 
	   AS d 
	   ON d.DepartmentID = e.DepartmentID
 ORDER BY e.EmployeeID 
      ASC

-- 11.	Min Average Salary

    SELECT 
	   MIN (AverageSalary) 
	    AS MinAverageSalary 
	  FROM (
	SELECT DepartmentID, 
	   AVG (Salary) 
	    AS AverageSalary 
	  FROM Employees
  GROUP BY DepartmentID)
        AS AverageSalariesByDepartment

-- 12.	Highest Peaks in Bulgaria

USE [Geography]

SELECT * FROM INFORMATION_SCHEMA.TABLES
SELECT * FROM MountainsCountries
SELECT TOP 1 * FROM Peaks
SELECT TOP 1 * FROM Countries

	SELECT 
	       mc.CountryCode, 
		   m.MountainRange, 
		   p.PeakName, 
		   p.Elevation 
	  FROM Peaks 
	    AS p
	  JOIN Mountains 
	    AS m 
		ON m.Id = p.MountainId
	  JOIN MountainsCountries 
	    AS mc 
		ON mc.MountainId = p.MountainId
	   AND mc.CountryCode = 'BG'
	   AND p.Elevation > 2835
  ORDER BY p.Elevation 
      DESC

-- 13.	Count Mountain Ranges

	SELECT
	       mc.CountryCode, 
     COUNT (
	       m.MountainRange
		   ) 
		AS MountainRanges
      FROM Mountains 
	    AS m 
	  JOIN MountainsCountries 
	    AS mc 
		ON mc.MountainId = m.Id
	   AND mc.CountryCode IN ('BG', 'RU', 'US')
  GROUP BY (mc.CountryCode)

-- 14.	Countries with Rivers

			SELECT 
			   TOP (5) 
				   c.CountryName, 
				   r.RiverName 
			  FROM Countries 
				AS c
			  JOIN Continents 
			    AS cc 
				ON cc.ContinentCode = c.ContinentCode
   FULL OUTER JOIN CountriesRivers 
				AS cr 
				ON cr.CountryCode = c.CountryCode
   FULL OUTER JOIN Rivers 
                AS r 
				ON r.Id = cr.RiverId
			 WHERE cc.ContinentCode = 'AF'
          ORDER BY c.CountryName 
		       ASC

-- 15.	Continents and Currencies *

      SELECT             
	         ContinentCode, 
			 CurrencyCode, 
			 CurrencyUsage 
	    FROM (
			  SELECT
					 ContinentCode, 
					 CurrencyCode, 
					 CurrencyUsage,
		  DENSE_RANK () 
				OVER (
		PARTITION BY ContinentCode 
			ORDER BY CurrencyUsage
				DESC
					 ) 
				  AS [Rank]
				FROM (
					  SELECT
							 ContinentCode, 
							 CurrencyCode, 
					   COUNT (CurrencyCode) 
						  AS CurrencyUsage  
						FROM Countries
					GROUP BY CurrencyCode, ContinentCode) 
						  AS e
					  ) 
				  AS RankCurrencies
	   WHERE [Rank] = 1 AND CurrencyUsage > 1
	ORDER BY ContinentCode

-- 16.	Countries without any Mountains

  SELECT 
   COUNT (CountryCode) CountryCode 
    FROM Countries
   WHERE CountryCode 
  NOT IN (
  SELECT 
         CountryCode 
	FROM MountainsCountries
	     )

------------------------------------------------------------------

			SELECT  
				  COUNT(c.CountryCode) 
                AS CountryCode
			  FROM Countries 
				AS c
			  JOIN Continents 
			    AS cc 
				ON cc.ContinentCode = c.ContinentCode
   FULL OUTER JOIN MountainsCountries
				AS mc 
				ON mc.CountryCode = c.CountryCode
   LEFT OUTER JOIN Mountains 
                AS m 
				ON m.Id = mc.MountainId
				WHERE m.MountainRange IS NULL

-- 17.	Highest Peak and Longest River by Country


		 SELECT 
			TOP (5) 
				c.CountryName, 
			MAX (p.Elevation) HighestPeakElevation, 
			MAX (r.Length) LongestRiverElevation 
		   FROM Countries c
LEFT OUTER JOIN CountriesRivers cr ON cr.CountryCode = c.CountryCode
LEFT OUTER JOIN Rivers r ON r.Id = cr.RiverId
LEFT OUTER JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
LEFT OUTER JOIN Peaks p ON p.MountainId = mc.MountainId
       GROUP BY c.CountryName
       ORDER BY HighestPeakElevation DESC, LongestRiverElevation DESC

-- 18.	Highest Peak Name and Elevation by Country*

          SELECT 
		         CountryName Country,
		    CASE
				WHEN PeakName IS NULL 
				THEN '(no highest peak)'
				ELSE PeakName
             END [Highest Peak Name],

			CASE  
				WHEN HighestPeakElevation IS NULL 
				THEN '0'
				ELSE HighestPeakElevation
             END [Highest Peak Elevation], 

			CASE
				WHEN MountainRange IS NULL 
				THEN '(no mountain)'
				ELSE MountainRange
				 END Mountain 
		    FROM (
                 SELECT  
						c.CountryName,
						p.PeakName,
						p.Elevation HighestPeakElevation,
						m.MountainRange,
			 DENSE_RANK () 
				   OVER (
		   PARTITION BY c.CountryName 
			   ORDER BY p.Elevation
				   DESC
						) [Rank]
				   FROM Countries c
		LEFT OUTER JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
		LEFT OUTER JOIN Mountains m ON m.Id = mc.MountainId
		LEFT OUTER JOIN Peaks p ON p.MountainId = mc.MountainId
                        ) t
           WHERE [Rank] = 1
		   ORDER BY Country,
		            [Highest Peak Name]
