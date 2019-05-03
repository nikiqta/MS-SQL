-- Problem 1. Create Database
CREATE DATABASE Minions

USE Minions

-- Problem 2. Create Tables
CREATE TABLE Minions(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(20) NOT NULL,
Age INT
)

CREATE TABLE Towns(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(20) NOT NULL
)

-- Problem 3. Alter Minions Table
ALTER TABLE Minions 
ADD TownId INT FOREIGN KEY REFERENCES Towns(Id)

-- Problem 4. Insert Records in Both Tables
SET IDENTITY_INSERT Minions ON

INSERT INTO Towns(Id, [Name])
VALUES(1, 'Sofia'),
      (2, 'Plovdiv'),
  (3, 'Varna')


INSERT INTO Minions(Id, [Name], Age, TownId)
VALUES(1, 'Kevin', 22, 1),
      (2, 'Bob', 15, 3),
  (3, 'Steward', NULL, 2)

-- Problem 5. Truncate Table Minions
TRUNCATE TABLE Minions

-- Problem 6. Drop All Tables
DROP TABLE Minions

-- Problem 7. Create Table People
CREATE TABLE People(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(200) NOT NULL,
Picture VARBINARY(max) NULL,
Height DECIMAL(18,2) NULL,
Weight DECIMAL(18,2) NULL,
Gender CHAR(1) NOT NULL,
Birthdate DATE  NOT NULL,
Biography NVARCHAR(200) NULL
)

INSERT INTO People([Name], Picture, Height, [Weight], Gender, Birthdate, Biography)
VALUES('Yanko', 010101010101001010101, 1.88, 99.50, 'm', '2008-11-12', 'rwerwerwerwrwerwerwerwer'),
      ('Banko', 010101010101001010101, 1.78, 89.50, 'm', '2007-10-14', 'rwerwerwerwrwerwerwerwer'),
  ('Tanko', 010101010101001010101, 1.68, 79.50, 'm', '2006-12-15', 'rwerwerwerwrwerwerwerwer'),
  ('Hanko', 010101010101001010101, 1.58, 69.50, 'm', '2005-11-17', 'rwerwerwerwrwerwerwerwer'),
      ('Danko', 010101010101001010101, 1.66, 59.50, 'm', '2004-11-18', 'rwerwerwerwrwerwerwerwer')

-- Problem 8. Create Table Users
CREATE TABLE Users(
Id BIGINT PRIMARY KEY IDENTITY NOT NULL,
Username VARCHAR(30) UNIQUE NOT NULL,
[Password] VARCHAR(26) NOT NULL,
ProfilePicture VARBINARY(MAX) CHECK (DATALENGTH(ProfilePicture) <= 921600)  NULL,
LastLoginTime DATETIME  NOT NULL,
IsDeleted BIT
)

INSERT INTO Users(Username, [Password], ProfilePicture, LastLoginTime, IsDeleted)
VALUES
('Yanko', 'rwerwerwerwrwerwerwerwer', 010101010101001010101, '2007-10-14 12:23:01', 0),
('Banko', 'rwerwerwerwrwerwerwerwer', 010101010101001010101, '2007-10-14 12:23:01', 0),
('Tanko', 'rwerwerwerwrwerwerwerwer', 010101010101001010101, '2007-10-14 12:23:01', 0),
('Hanko', 'rwerwerwerwrwerwerwerwer', 010101010101001010101, '2007-10-14 12:23:01', 0),
('Danko', 'rwerwerwerwrwerwerwerwer', 010101010101001010101, '2007-10-14 12:23:01', 0)

-- Problem 9. Change Primary Key

-- Problem 10. Add Check Constraint

-- Problem 11. Set Default Value of a Field

-- Problem 12. Set Unique Field

-- Problem 13. Movies Database

CREATE DATABASE Movies

GO

USE Movies

CREATE TABLE Directors (
Id INT IDENTITY,
DirectorName NVARCHAR(50) NOT NULL,
Notes NVARCHAR(500) NULL,
CONSTRAINT PK_DirectorsId PRIMARY KEY (Id)
)

GO

INSERT INTO Directors
VALUES
('Stoicho Konyarski', 'Mnogo filmi brat zad gyrba....'),
('Petko Marianski', 'Mnogo filmi brat zad gyrba....'),
('Kremen Kremenliev', 'Mnogo filmi brat zad gyrba....'),
('Ideal Kristalev', 'Mnogo filmi brat zad gyrba....'),
('Doicho Nemski', 'Mnogo filmi brat zad gyrba....')

GO

CREATE TABLE Genres (
Id INT IDENTITY,
GenreName NVARCHAR(20) NOT NULL,
Notes NVARCHAR(500) NULL,
CONSTRAINT PK_GenresId PRIMARY KEY (Id)
)

GO

INSERT INTO Genres
VALUES
('Drama', 'Mnogo filmi brat zad gyrba....'),
('Historical', 'Mnogo filmi brat zad gyrba....'),
('Comedy', 'Mnogo filmi brat zad gyrba....'),
('Documentary', 'Mnogo filmi brat zad gyrba....'),
('Action', 'Mnogo filmi brat zad gyrba....')

GO

CREATE TABLE Categories (
Id INT IDENTITY,
CategoryName NVARCHAR(40) NOT NULL,
Notes NVARCHAR(300) NULL,
CONSTRAINT PK_CategoriesId PRIMARY KEY (Id)
)

GO

INSERT INTO Categories
VALUES
('Best Movie', 'Film-1'),
('Worst Movie', 'Film-2'),
('Best Music', 'Film-3'),
('Worst Music', 'Film-4'),
('Best Acting', 'Film-1')

GO

CREATE TABLE Movies (
Id INT IDENTITY,
Title NVARCHAR(50),
DirectorId INT NOT NULL,
CopyrightYear INT NOT NULL,
[Length] INT NULL,
GenreId INT NOT NULL,
CategoryId INT NOT NULL,
Rating DECIMAL(3,1) NOT NULL,
Notes NVARCHAR(MAX),
CONSTRAINT PK_MoviesId PRIMARY KEY (Id),
CONSTRAINT FK_Movies_Directors FOREIGN KEY (DirectorId) REFERENCES Directors(Id),
CONSTRAINT FK_Movies_Genres FOREIGN KEY (GenreId) REFERENCES Genres(Id),
CONSTRAINT FK_Movies_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)

GO

INSERT INTO Movies 
VALUES
('The best live story Ever...', 1, 2019, 140, 1, 1, 9.9, 'Kysa... kysa.. kysaaaa'),
('The worst live story Ever...', 2, 2019, 130, 2, 2, 2.9, 'Kysa... kysa.. kysaaaa'),
('The newest and funniest comedy ever...', 3, 2019, 90, 3, 3, 7.9, 'Kysa... kysa.. kysaaaa'),
('Something weird...', 4, 2019, 126, 4, 4, 6.9, 'Kysa... kysa.. kysaaaa'),
('Crazy from the best...', 5, 2019, 87, 5, 5, 9.9, 'Kysa... kysa.. kysaaaa')

GO

SELECT * FROM Movies
-- Problem 14. Car Rental Database

CREATE DATABASE CarRental

GO

USE CarRental

CREATE TABLE Categories (
Id INT IDENTITY,
CategoryName NVARCHAR(50),
DailyRate DECIMAL(15,2) NOT NULL,
WeeklyRate DECIMAL(15,2) NOT NULL,
MonthlyRate DECIMAL(15,2) NOT NULL,
WeekendRate DECIMAL(15,2) NOT NULL,
CONSTRAINT PK_CategoriesId PRIMARY KEY (Id)
)

GO

INSERT INTO Categories
VALUES
('Cross-over', 45.50, 280.00, 1230.50, 67.70),
('SUV', 55.50, 580.00, 5230.50, 57.70),
('Urban', 15.50, 80.00, 230.50, 17.70)

GO

CREATE TABLE Cars (
Id INT IDENTITY,
PlateNumber NVARCHAR(20) NOT NULL,
Manufacturer NVARCHAR(50) NOT NULL,
Model NVARCHAR(50) NOT NULL,
CarYear NVARCHAR(50) NOT NULL,
CategoryId INT NOT NULL,
Doors NVARCHAR(50) NOT NULL,
Picture VARBINARY(MAX) CHECK (DATALENGTH(Picture) <= 921600)  NULL,
Condition NVARCHAR(50) NOT NULL,
Available BIT,
CONSTRAINT PK_CarsId PRIMARY KEY (Id),
CONSTRAINT FK_Cars_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)

GO

INSERT INTO Cars 
VALUES
('CH444HC', 'Seat', 'Ibiza', '1998', 3, '5', 0101010101010100101010101, 'Used', 1),
('C8888AC', 'BMW', '320', '1999', 3, '3', 0101010101010100101010101, 'Used', 1),
('CA8844HC', 'Fiat', 'Panda', '2005', 1, '5', 0101010101010100101010101, 'Used', 1)

GO

CREATE TABLE Employees (
Id INT IDENTITY,
FirstName NVARCHAR(50),
LastName NVARCHAR(50),
Title NVARCHAR(100),
Notes NVARCHAR(1000),
CONSTRAINT PK_EmployeesId PRIMARY KEY (Id)
)

GO

INSERT INTO Employees 
VALUES 
('Kolio', 'Lamyata', 'Bendzhiiiii idvam', '????? ????......'),
('????', 'L??????', 'Kurteeeee idvam', '????? ????......'),
('?????', 'Filev', 'Vaskoooo idvam', '????? ????......')

GO

CREATE TABLE Customers (
Id INT IDENTITY,
DriverLicenseNumber NVARCHAR(50),
FullName NVARCHAR(100),
[Address] NVARCHAR(150),
City NVARCHAR(30),
ZIPCode NVARCHAR(10),
Notes NVARCHAR(1000),
CONSTRAINT PK_CustomersId PRIMARY KEY (Id)
)
GO

INSERT INTO Customers
VALUES 
('KARAG905389538453', 'Nedko Nedkov Nedkov', 'str. Kraipytna koliba - 43A', 'Harmanli', '4345', 'fsdfsdfsdfsdfsd'),
('PERO3895384533434', 'Petko Petkov Petkov', 'str. na centyra - 1A', 'Aksakovo', '4665', 'fsdfsdfsdfsdfsd'),
('LEDEN538453222333', 'Kiro Kirov Kirov', 'str. Tuk tam stypvam - 0B', 'Harmanli', '7745', 'fsdfsdfsdfsdfsd')

GO

CREATE TABLE RentalOrders (
Id INT IDENTITY,
EmployeeId INT NOT NULL,
CustomerId INT NOT NULL,
CarId INT NOT NULL,
TankLevel FLOAT NOT NULL,
KilometrageStart DECIMAL(15, 2),
KilomtrageEnd DECIMAL(15, 2),
TotalKilometrage DECIMAL(15, 2) NOT NULL,
StartDate DATE NULL,
EndDate DATE NULL,
TotalDays INT,
RateApplied DECIMAL(15, 2),
TaxRate DECIMAL(15, 2),
OrderStatus NVARCHAR(20),
Notes NVARCHAR(1000)
CONSTRAINT PK_RentalOrdersId PRIMARY KEY (Id),
CONSTRAINT FK_RentalOrders_Employees FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
CONSTRAINT FK_Rentals_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
CONSTRAINT FK_Rentals_Cars FOREIGN KEY (CarId) REFERENCES Cars(Id)
)

GO

INSERT INTO RentalOrders
VALUES
(1, 2, 3, 45.5, 100056.00, 120056.00, 120056.00, '2013-12-12', '2013-12-30', 18, 56.50, 23.50, 'In use', 'Tok i jica.....'),
(3, 1, 2, 45.5, 100000.00, 120000.00, 120000.00, '2013-11-12', '2013-11-30', 18, 56.50, 23.50, 'Available', 'Tok i jica.....'),
(2, 3, 1, 45.5, 100023.00, 120023.00, 120023.00, '2013-10-12', '2013-10-30', 18, 56.50, 23.50, 'Service', 'Tok i jica.....')

SELECT * FROM RentalOrders
SELECT * FROM Cars WHERE Id = 3
-- Problem 15. Hotel Database

CREATE DATABASE Hotel

GO

USE Hotel

GO

CREATE TABLE Employees (
Id INT IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Title NVARCHAR(100),
Notes NVARCHAR(1000),
CONSTRAINT PK_EmployeesId PRIMARY KEY (Id)
)

GO

INSERT INTO Employees
VALUES
('dasdasda', 'bbbbbbbb', 'fsdfsfsdfsfsfsdfs', 'fsdfsd'),
('dasdasda', 'bbbbbbbb', 'fsdfsfsdfsfsfsdfs', 'fsdfsd'),
('dasdasda', 'bbbbbbbb', 'fsdfsfsdfsfsfsdfs', 'fsdfsd')

GO

CREATE TABLE Customers (
Id INT IDENTITY,
AccountNumber INT NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
PhoneNumber INT NOT NULL,
EmergencyName NVARCHAR(50) NOT NULL,
EmergencyNumber INT NOT NULL,
Notes NVARCHAR(1000),
CONSTRAINT PK_CustomersId PRIMARY KEY (Id)
)

GO

INSERT INTO Customers
VALUES
(4324234, 'bbbbbbbb', 'fsdfsfsdfsfsfsdfs', 423423, 'fsdfsd', 423423, 'fsdfsd'),
(4324234, 'bbbbbbbb', 'fsdfsfsdfsfsfsdfs', 4234234, 'fsdfsd', 423423, 'fsdfsd'),
(32423423, 'bbbbbbbb', 'fsdfsfsdfsfsfsdfs',4234234, 'fsdfsd', 423423, 'fsdfsd')

GO

CREATE TABLE RoomStatus (
Id INT IDENTITY,
RoomStatus NVARCHAR(10) NOT NULL,
Notes NVARCHAR(1000),
CONSTRAINT PK_RoomStatusId PRIMARY KEY (Id)
)

GO

INSERT INTO RoomStatus
VALUES
('dasdasda', 'dasdadasdasdas'),
('dasdasda', 'dasdadasdasdas'),
('dasdasda', 'dasdadasdasdas')

GO

CREATE TABLE RoomTypes (
Id INT IDENTITY,
RoomTypes NVARCHAR(20) NOT NULL,
Notes NVARCHAR(1000),
CONSTRAINT PK_RoomTypesId PRIMARY KEY (Id)
)

GO

INSERT INTO RoomTypes
VALUES
('dasdasda', 'dasdadasdasdas'),
('dasdasda', 'dasdadasdasdas'),
('dasdasda', 'dasdadasdasdas')

GO

CREATE TABLE BedTypes (
Id INT IDENTITY,
BetType NVARCHAR(20) NOT NULL,
Notes NVARCHAR(1000) NOT NULL,
CONSTRAINT PK_BedTypesId PRIMARY KEY (Id)
)

GO

INSERT INTO BedTypes
VALUES
('dasdasda', 'dasdadasdasdas'),
('dasdasda', 'dasdadasdasdas'),
('dasdasda', 'dasdadasdasdas')


GO

CREATE TABLE Rooms (
Id INT IDENTITY,
RoomNumber INT NOT NULL,
RoomType NVARCHAR(20) NOT NULL,
Bedtype NVARCHAR(20) NOT NULL,
Rate FLOAT NOT NULL,
RoomStatus NVARCHAR(20) NOT NULL,
Notes NVARCHAR(1000),
CONSTRAINT PK_RoomsId PRIMARY KEY (Id)
)

GO

INSERT INTO Rooms
VALUES
(1, 'dasdasda', 'dasdadasdasdas', 4.5, 'dasdadasdasdas', 'dasdadasdasdas'),
(33, 'dasdasda', 'dasdadasdasdas', 4.5, 'dasdadasdasdas', 'dasdadasdasdas'),
(44, 'dasdasda', 'dasdadasdasdas', 4.5, 'dasdadasdasdas', 'dasdadasdasdas')


GO

CREATE TABLE Payments (
Id INT IDENTITY,
EmployeeId INT NOT NULL,
PaymentDate DATE NOT NULL,
AccountNumber NVARCHAR(50) NOT NULL,
FirstDateOccupied DATE NOT NULL,
LastDateOccupied DATE NOT NULL,
TotalDays INT NOT NULL,
AmountCharged DECIMAL(15, 2) NOT NULL,
TaxRate DECIMAL(15, 2) NOT NULL,
TaxAmount DECIMAL(15, 2) NOT NULL,
PaymentTotal DECIMAL(15, 2) NOT NULL,
Notes NVARCHAR(1000),
CONSTRAINT PK_PaymentsId PRIMARY KEY (Id),
CONSTRAINT FK_Payments_Employees FOREIGN KEY (EmployeeId) REFERENCES Employees(Id)
)

GO

INSERT INTO Payments
VALUES
(1, '2002-12-12', 'dasdasda', '2002-12-12', '2002-12-12', 8, 155.00, 10.00, 10.00, 2560.00, 'fsdfs'),
(2, '2002-12-12', 'dasdasda', '2002-12-12', '2002-12-12', 8, 155.00, 10.00, 10.00, 2560.00, 'fsdfs'),
(2, '2002-12-12', 'dasdasda', '2002-12-12', '2002-12-12', 8, 155.00, 10.00, 10.00, 2560.00, 'fsdfs')

GO

CREATE TABLE Occupancies (
Id INT IDENTITY,
EmployeeId INT NOT NULL,
DateOccupied DATE NOT NULL,
AccountNumber NVARCHAR(50),
RoomNumber INT NOT NULL,
RateApplied DECIMAL(15, 2) NOT NULL,
PhoneCharge DECIMAL(15, 2) NOT NULL,
Notes NVARCHAR(1000),
CONSTRAINT PK_OccupanciesId PRIMARY KEY (Id),
CONSTRAINT FK_Occupancies_Employees FOREIGN KEY (EmployeeId) REFERENCES Employees(Id),
)

INSERT INTO Occupancies
VALUES
(1, '2002-12-12', 'dasdasda', 8, 155.00, 10.00, 'fsdfs'),
(2, '2002-12-12', 'dasdasda', 8, 155.00, 10.00, 'fsdfs'),
(3, '2002-12-12', 'dasdasda', 8, 155.00, 10.00, 'fsdfs')

-- Problem 16. Create SoftUni Database
CREATE DATABASE SoftUni
GO

USE SoftUni
GO

CREATE TABLE Towns (
Id INT IDENTITY,
[Name] NVARCHAR(50),
CONSTRAINT PK_TownsId PRIMARY KEY (Id)
)

GO

CREATE TABLE Addresses (
Id INT IDENTITY,
[AddressText] NVARCHAR(100),
TownId INT,
CONSTRAINT PK_AddressesId PRIMARY KEY (Id),
CONSTRAINT FK_Addresses_Towns FOREIGN KEY (TownId) REFERENCES Towns(Id)
)

GO

CREATE TABLE Departments (
Id INT IDENTITY,
[Name] NVARCHAR(50)
CONSTRAINT PK_DepartmentsId PRIMARY KEY (Id)
)

GO

CREATE TABLE Employees (
Id INT IDENTITY,
FirstName NVARCHAR(50),
MiddleName NVARCHAR(50),
LastName NVARCHAR(50),
JobTitle NVARCHAR(20),
DepartmentId INT,
HireDate DATE,
Salary DECIMAL(15, 2),
[AddressId] INT,
CONSTRAINT PK_EmployeesId PRIMARY KEY (Id),
CONSTRAINT FK_Employees_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id),
CONSTRAINT FK_Employees_Addresses FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)
-- Problem 17. Backup Database

-- Problem 18. Basic Insert

INSERT INTO Towns
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments
VALUES
('Engeneering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

GO

INSERT INTO Employees
VALUES
('Ivan', 'Ivanon', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00, NULL),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00, NULL),
('Maria', 'Petrova', 'Ivanova', 'Intern', 2, '2016-08-28', 525.00, NULL),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 3, '2007-09-12', 3000.00, NULL),
('Peter', 'Pan', 'Pan', 'Intern', 5, '2016-08-28', 599.88, NULL)

-- Problem 19. Basic Select All Fields

SELECT * FROM Towns

SELECT * FROM Departments

SELECT * FROM Employees

-- Problem 20. Basic Select All Fields and Order Them

SELECT * FROM Towns
ORDER BY [Name] ASC

SELECT * FROM Departments
ORDER BY [Name] ASC

SELECT * FROM Employees
ORDER BY [Salary] DESC

-- Problem 21. Basic Select Some Fields

SELECT [Name] FROM Towns

SELECT [Name] FROM Departments

SELECT FirstName, LastName, JobTitle, Salary FROM Employees 

-- Problem 22. Increase Employees Salary

UPDATE Employees
SET Salary *= 1.1 

-- Problem 23. Decrease Tax Rate

UPDATE Payments
SET TaxRate /= 1.03

SELECT * FROM Payments

-- Problem 24. Delete All Records