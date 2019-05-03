
-- 1.	One-To-One Relationship

CREATE TABLE Passports (
Id INT IDENTITY,
PassportNumber NVARCHAR(10) NOT NULL,
CONSTRAINT PK_Passports PRIMARY KEY (Id)
)

CREATE TABLE Persons (
Id INT IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
Salary DECIMAL(15, 2) NOT NULL,
PassportId INT FOREIGN KEY REFERENCES Passports(Id) UNIQUE,

CONSTRAINT PK_Persons PRIMARY KEY (Id),
)

INSERT INTO Passports (PassportNumber) VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons (FirstName, Salary, PassportId) VALUES
('Roberto', 43300.00, 2),
('Tom', 56100.00, 3),
('Yana', 60200.00, 1)

SELECT Passports.PassportNumber, Persons.FirstName, Persons.Salary  FROM Passports
JOIN Persons ON PassportId = Passports.id

-- 2.	One-To-Many Relationship

CREATE TABLE Manufacturers (
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	EstablishedOn DATETIME NOT NULL,

	CONSTRAINT PK_Manufacturers PRIMARY KEY (Id)
)

CREATE TABLE Models (
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	ManufacturerId INT NOT NULL,

	CONSTRAINT PK_Models PRIMARY KEY (Id),

	CONSTRAINT FK_Models_Manufacturers
	FOREIGN KEY (ManufacturerId) 
	REFERENCES Manufacturers(Id)
)

INSERT INTO Manufacturers VALUES
('BMW',	'07/03/1916'),
('Tesla',	'01/01/2003'),
('Lada',	'01/05/1966')

INSERT INTO Models VALUES
('X1',	1),
('i6',	1),
('Model S',	2),
('Model X',	2),
('Model 3',	2),
('Nova',	3)


SELECT mf.[Name], md.[Name], mf.EstablishedOn  FROM Manufacturers AS mf
JOIN Models AS md ON md.ManufacturerId = mf.id

-- 3.	Many-To-Many Relationship

CREATE TABLE Students (
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Students PRIMARY KEY (Id)
)

CREATE TABLE Exams (
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Exams PRIMARY KEY (Id)
)

CREATE TABLE StudentsExams (
	StudentId INT NOT NULL,
	ExamId INT NOT NULL,

	CONSTRAINT PK_StudentsExams
	PRIMARY KEY (StudentId, ExamId),

	CONSTRAINT FK_StudentsExam_Students 
	FOREIGN KEY (StudentId) 
	REFERENCES Students(Id),

	CONSTRAINT FK_StudentsExam_Exams 
	FOREIGN KEY (ExamId) 
	REFERENCES Exams(Id)
)

INSERT INTO Students VALUES
('Mila'),                                      
('Toni'),
('Ron')

INSERT INTO Exams VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

INSERT INTO StudentsExams VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 3),
(2, 2),
(2, 3)

-- 4.	Self-Referencing 

CREATE TABLE Teachers (
Id INT IDENTITY,
[Name] NVARCHAR(50),
ManagerId INT REFERENCES Teachers(Id),
CONSTRAINT PK_Teachers PRIMARY KEY (Id)
)

INSERT INTO Teachers VALUES
('John',	NULL),
('Maya',	6),
('Silvia',	6),
('Ted',	5),
('Mark',	1),
('Greta',	1)

SELECT * FROM Teachers

-- 5.	Online Store Database

CREATE DATABASE OnlineStore

USE OnlineStore


CREATE TABLE Cities (
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_Cities PRIMARY KEY (Id)
)

CREATE TABLE ItemTypes (
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,

	CONSTRAINT PK_ItemTypes PRIMARY KEY (Id)
)

CREATE TABLE Customers (
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	BirthDay DATE NOT NULL,
	CityId INT,

	CONSTRAINT PK_Customers PRIMARY KEY (Id),

	CONSTRAINT FK_Customers_Cities 
	FOREIGN KEY (CityId) 
	REFERENCES Cities(Id)
)

CREATE TABLE Items (
	Id INT IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	ItemTypeId INT,

	CONSTRAINT PK_Items PRIMARY KEY (Id),

	CONSTRAINT FK_Items_ItemTypes 
	FOREIGN KEY (ItemTypeId) 
	REFERENCES ItemTypes(Id)
)

CREATE TABLE Orders (
	Id INT IDENTITY,
	CustomerId INT,

	CONSTRAINT PK_Orders PRIMARY KEY (Id),

	CONSTRAINT FK_Orders_Customers 
	FOREIGN KEY (CustomerId) 
	REFERENCES Customers(Id)
)

CREATE TABLE OrderItems (
	OrderId INT,
	ItemId INT,

	CONSTRAINT PK_OrderItems 
	PRIMARY KEY (OrderId, ItemId),

	CONSTRAINT FK_OrderItems_Orders 
	FOREIGN KEY (OrderId) 
	REFERENCES Orders(Id),

	CONSTRAINT FK_OrderItems_Items
	FOREIGN KEY (ItemId) 
	REFERENCES Items(Id)
)

-- 6.	University Database

CREATE DATABASE University

USE University

CREATE TABLE Subjects (
Id INT IDENTITY,
[Name] NVARCHAR(50) NOT NULL,

CONSTRAINT PK_Subjects PRIMARY KEY (Id)
)

CREATE TABLE Majors (
Id INT IDENTITY,
[Name] NVARCHAR(50) NOT NULL,

CONSTRAINT PK_Majors PRIMARY KEY (Id)
)

CREATE TABLE Students (
Id INT IDENTITY,
	StudentNumber NVARCHAR(50) NOT NULL,
	StudentName NVARCHAR(50) NOT NULL,
	MajorId INT,

	CONSTRAINT PK_Students 
	PRIMARY KEY (Id),

	CONSTRAINT FK_Students_Majors 
	FOREIGN KEY (MajorId) 
	REFERENCES Majors(Id)
)

CREATE TABLE Payments (
	Id INT IDENTITY,
	PaymentDate DATETIME NOT NULL,
	PaymentAmount DECIMAL(15, 2),
	StudentId INT,

	CONSTRAINT PK_Payments 
	PRIMARY KEY (Id),

	CONSTRAINT FK_Payments_Students 
	FOREIGN KEY (StudentId) 
	REFERENCES Students(Id)
)

CREATE TABLE Agenda (
	StudentId INT,
	SubjectId INT,

	CONSTRAINT PK_Agenda 
	PRIMARY KEY (StudentId, SubjectID),

	CONSTRAINT FK_Agenda_Students
	FOREIGN KEY (StudentId)
	REFERENCES Students(Id),

	CONSTRAINT FK_Agenda_Subjects
	FOREIGN KEY (SubjectId)
	REFERENCES Subjects(Id)
)

-- 7.	SoftUni Design

-- 8.	Geography Design

-- 9.	Peaks in Rila *

USE Geography

SELECT m.MountainRange, p.PeakName, p.Elevation FROM Mountains AS m
JOIN Peaks AS p ON m.Id = p.MountainId AND m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC




