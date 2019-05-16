
-- Section 1. DDL (30 pts)

-- 1.	Database design


CREATE DATABASE ReportService
DROP DATABASE ReportService

USE ReportService

CREATE TABLE Users (
	Id INT IDENTITY,
	Username NVARCHAR(30) NOT NULL UNIQUE,
	[Password] NVARCHAR(50) NOT NULL,
	[Name] NVARCHAR(50),
	Gender CHAR CHECK (Gender IN ('M', 'F')),
	BirthDate DATETIME,
	Age INT,
	Email NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Users
	PRIMARY KEY (Id)
)

CREATE TABLE [Status] (
	Id INT IDENTITY,
	Label NVARCHAR(30) NOT NULL

	CONSTRAINT PK_Status
	PRIMARY KEY (Id)
)

CREATE TABLE Departments (
    Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL

	CONSTRAINT PK_Departments
	PRIMARY KEY (Id)
)

CREATE TABLE Employees (
    Id INT IDENTITY,
	FirstName NVARCHAR(25) NOT NULL,
	LastName NVARCHAR(25) NOT NULL,
	Gender CHAR CHECK (Gender IN ('M', 'F')),
	BirthDate DATETIME,
	Age INT,
	DepartmentId INT NOT NULL,

	CONSTRAINT PK_Employees
	PRIMARY KEY (Id),

	CONSTRAINT FK_Employees_Departments
	FOREIGN KEY (DepartmentId) 
	REFERENCES Departments(Id)
)

CREATE TABLE Categories (
    Id INT IDENTITY,
	DepartmentId INT,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Categories
	PRIMARY KEY (Id),

	CONSTRAINT FK_Categories_Departments
	FOREIGN KEY (DepartmentId) 
	REFERENCES Departments(Id)
)

CREATE TABLE Reports (
    Id INT IDENTITY,
	CategoryId INT NOT NULL,
	StatusId INT NOT NULL,
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME,
	[Description] NVARCHAR(200),
	UserId INT NOT NULL,
	EmployeeId INT,

	CONSTRAINT PK_Reports
	PRIMARY KEY (Id),

	CONSTRAINT FK_Reports_Categories
	FOREIGN KEY (CategoryId) 
	REFERENCES Categories(Id),

	CONSTRAINT FK_Reports_Status
	FOREIGN KEY (StatusId) 
	REFERENCES [Status](Id),

	CONSTRAINT FK_Reports_Users
	FOREIGN KEY (UserId) 
	REFERENCES Users(Id),

	CONSTRAINT FK_Reports_Employees
	FOREIGN KEY (EmployeeId) 
	REFERENCES Employees(Id)
)

-- Section 2. DML (10 pts)

-- 3.	Update

USE ReportService

	UPDATE Reports
	   SET StatusId = 2
	 WHERE StatusId = 1 
	   AND CategoryId = 4

-- 4. Delete

    DELETE Reports
     WHERE StatusId = 4

-- Section 3. Querying (40 pts)

-- 5.	Users by Age

    SELECT
	       Username, 
		   Age 
	  FROM Users
  ORDER BY 
          Age, 
		  Username 
	 DESC

-- 6.	Unassigned Reports

     SELECT 
	        [Description], 
			OpenDate 
	   FROM Reports
      WHERE EmployeeId 
	IS NULL
   ORDER BY 
            OpenDate,
		    [Description]

-- 7.	Employees & Reports

	SELECT
	       e.FirstName, 
		   e.LastName, 
		   r.[Description], 
		   (
		   SELECT 
		   FORMAT (
		          r.OpenDate, 'yyyy-MM-dd'
				  )
		   ) 
		   OpenDate 
	  FROM Reports r
	  JOIN Employees e 
	    ON r.EmployeeId = e.Id
	 WHERE r.EmployeeId IS NOT NULL
  ORDER BY 
           r.EmployeeId, 
           r.OpenDate, 
		   r.Id

-- 8.	Most reported Category

	SELECT
	       c.[Name] Categorynumber, 
     COUNT (r.CategoryId) ReportsNumber 
	  FROM Reports r
	  JOIN Categories c ON c.Id = r.CategoryId
  GROUP BY c.[Name]
  ORDER BY 
     COUNT (r.CategoryId) 
	  DESC , 
	       c.[Name] 
	   ASC

-- 9.	Employees in Category

	SELECT
	       c.[Name] CategoryName,
     COUNT (UserId) [Employees Number] 
	  FROM Reports r
	  JOIN Categories c 
	    ON c.Id = r.CategoryId
  GROUP BY c.[Name]
  ORDER BY c.[Name]

-- 10.	Users per Employee 

	SELECT
  DISTINCT 
           e.FirstName + ' ' + e.LastName [Name], 
	 COUNT (r.UserId) [User Number] 
	  FROM Reports r
	  JOIN Employees e 
	    ON e.Id = r.EmployeeId
	  JOIN Users u 
	    ON u.Id = r.UserId
  GROUP BY e.FirstName, e.LastName
  ORDER BY 
           [User Number] 
	  DESC , 
	       [Name] 
	   ASC

-- 11.	Emergency Patrol

SELECT *, r.OpenDate, r.[Description], u.Email [Reporter Email] FROM Reports r
JOIN Users u ON u.Id = r.UserId
FULL OUTER JOIN Employees e ON e.Id = r.EmployeeId
FULL OUTER JOIN Departments d ON d.Id = e.DepartmentId
WHERE r.CloseDate IS NULL
AND LEN(r.[Description]) > 20
AND CHARINDEX('str', r.[Description]) <> 0
AND d.[Name] IN ('Infrastructure', 'Emergency', 'Roads Maintenance')
-- ORDER BY OpenDate, [Reporter Email], r.Id

SELECT * FROM Reports
SELECT e.DepartmentId, d.[Name] FROM Employees e
JOIN Departments d ON d.Id = e.DepartmentId
WHERE d.[Name] IN ('Infrastructure', 'Emergency', 'Roads Maintenance')