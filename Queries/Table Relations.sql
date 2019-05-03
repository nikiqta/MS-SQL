CREATE DATABASE TableRelationDemo

USE TableRelationDemo


-- ONE-TO-MANY TABLE RELATION

CREATE TABLE Mountains (
Id INT IDENTITY,
[Name] VARCHAR(50) NOT NULL,
CONSTRAINT PK_Mountains PRIMARY KEY (Id)
)

CREATE TABLE Peaks (
	Id INT IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	MountainId INT NOT NULL,

	CONSTRAINT PK_Peaks
	PRIMARY KEY (Id),

	CONSTRAINT FK_Peaks_Mountains 
	FOREIGN KEY (MountainId) 
	REFERENCES Mountains(Id)
)

INSERT INTO Mountains ([Name]) VALUES
('Rila'),
('Pirin')

INSERT INTO Peaks ([Name], MountainId) VALUES
('Musala', 1),
('Malyovitsa', 1),
('Vihren', 2),
('Kutelo', 2)

-- MANY-TO-MANY TABLE RELATION

CREATE TABLE Employees (
Id INT IDENTITY,
[Name] VARCHAR(50) NOT NULL,
CONSTRAINT PK_Employees PRIMARY KEY (Id)
)

CREATE TABLE Projects (
Id INT IDENTITY,
[Name] VARCHAR(50) NOT NULL,
CONSTRAINT PK_Projects PRIMARY KEY (Id)
)

CREATE TABLE EmployeesProjects (
	EmployeeId INT NOT NULL,
    ProjectId INT NOT NULL,

	CONSTRAINT PK_EmployeesProjects
	PRIMARY KEY (EmployeeId, ProjectId),

	CONSTRAINT FK_EmployeesProjects_Employees 
	FOREIGN KEY (EmployeeId) 
	REFERENCES Employees(Id),

	CONSTRAINT FK_EmployeesProjects_Projects 
	FOREIGN KEY (ProjectId) 
	REFERENCES Projects(Id)
)

SELECT * FROM INFORMATION_SCHEMA.TABLES

INSERT INTO Employees ([Name]) VALUES
('Bay Ivan'),
('Bay Kosta'),
('Bay Anastas')

INSERT INTO Projects ([Name]) VALUES
('MySQL Project'),
('Super JS Project'),
('Microsoft Hell')

INSERT INTO EmployeesProjects (EmployeeId, ProjectId) VALUES
(1, 2),
(1, 1),
(3, 3),
(2, 1)

SELECT e.[Name], p.[Name] FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeId = e.Id
JOIN Projects AS p ON p.Id = ep.ProjectId

-- ONE-TO-ONE TABLE RELATION

CREATE TABLE Cars (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	DriverId INT FOREIGN KEY REFERENCES Drivers(Id) UNIQUE
)


CREATE TABLE Drivers (
	Id INT IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Drivers PRIMARY KEY (Id)
)

INSERT INTO Drivers ([Name]) VALUES
('Ivan Ivanov'),
('Toshko')

INSERT INTO Cars ([Name], DriverId) VALUES 
('Mercedes', 1),
('Trabant', 2)

-- Retrieving Related Data

SELECT * FROM Cars
JOIN Drivers ON Drivers.Id = Cars.DriverId

SELECT c.[Name] AS CarModel, d.[Name] AS DriverName FROM Cars AS c
JOIN Drivers AS d ON d.Id = c.DriverId

USE Geography

SELECT m.MountainRange, p.PeakName, p.Elevation FROM Mountains AS m
JOIN Peaks AS p ON m.Id = p.MountainId AND m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC

-- Cascade Operations

CREATE TABLE Employees (
Id INT IDENTITY,
[Name] VARCHAR(50) NOT NULL,
CONSTRAINT PK_Employees PRIMARY KEY (Id)
)

CREATE TABLE Projects (
Id INT IDENTITY,
[Name] VARCHAR(50) NOT NULL,
CONSTRAINT PK_Projects PRIMARY KEY (Id)
)

CREATE TABLE EmployeesProjects (
	EmployeeId INT NOT NULL,
    ProjectId INT NOT NULL,

	CONSTRAINT PK_EmployeesProjects
	PRIMARY KEY (EmployeeId, ProjectId),

	CONSTRAINT FK_EmployeesProjects_Employees 
	FOREIGN KEY (EmployeeId) 
	-- ON DELETE CASCADE ALLOWS AS TO DELETE INTO RELATED TABLES
	REFERENCES Employees(Id) ON DELETE CASCADE,

	CONSTRAINT FK_EmployeesProjects_Projects 
	FOREIGN KEY (ProjectId) 
	REFERENCES Projects(Id)
)

INSERT INTO Employees ([Name]) VALUES
('Bay Ivan'),
('Bay Kosta'),
('Bay Anastas')

INSERT INTO Projects ([Name]) VALUES
('MySQL Project'),
('Super JS Project'),
('Microsoft Hell')

INSERT INTO EmployeesProjects (EmployeeId, ProjectId) VALUES
(1, 2),
(1, 1),
(3, 3),
(2, 1)

SELECT e.[Name], p.[Name] FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeId = e.Id
JOIN Projects AS p ON p.Id = ep.ProjectId

-- DELETE WITH CASCADE OPTION

DELETE FROM Employees
WHERE Id = 1

-- DELETE WITHOUT CASCADE OPTION

DELETE FROM EmployeesProjects
WHERE EmployeeId = 1

DELETE FROM Employees
WHERE Id = 1

-- ADDITIONAL INFO: UPDATE CASCADE OPTION IS SIMILAR TO DELETE !!!