--CREATE DATABASE RaceDayDB;

USE RaceDayDB;

CREATE TABLE Roles (
RoleID INT IDENTITY(1,1) PRIMARY KEY,
RoleName VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Users (
UserID INT IDENTITY(1,1) PRIMARY KEY,
FullName VARCHAR(100) NOT NULL,
Email VARCHAR(150) NOT NULL UNIQUE,
PasswordHash VARCHAR(255) NOT NULL,
RoleID INT NOT NULL,
CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE Events (
EventID INT IDENTITY(1,1) PRIMARY KEY,
EventName VARCHAR(150) NOT NULL,
EventDate DATE NOT NULL,
Location VARCHAR(150) NOT NULL,
Description VARCHAR(500) NULL,
OrganiserID INT NOT NULL,
CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (OrganiserID) REFERENCES Users(UserID)
);

CREATE TABLE Categories (
CategoryID INT IDENTITY(1,1) PRIMARY KEY,
EventID INT NOT NULL,
CategoryName VARCHAR(100) NOT NULL,
DistanceKm DECIMAL(5,2) NOT NULL,
EntryFee DECIMAL(8,2) NOT NULL DEFAULT 0,
MaxParticipants INT NOT NULL DEFAULT 100,
FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

CREATE TABLE EventEnrolments (
EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
ParticipantID INT NOT NULL,
CategoryID INT NOT NULL,
EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE(),
Status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',
FOREIGN KEY (ParticipantID) REFERENCES Users(UserID),
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
UNIQUE (ParticipantID, CategoryID)
);

CREATE TABLE Results (
ResultID INT IDENTITY(1,1) PRIMARY KEY,
EnrolmentID INT NOT NULL UNIQUE,
FinishTime TIME NULL,
Position INT NULL,
CapturedAt DATETIME NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (EnrolmentID) REFERENCES EventEnrolments(EnrolmentID)
);

INSERT INTO Roles (RoleName) VALUES ('Organiser'), ('Participant');

INSERT INTO Users (FullName, Email, PasswordHash, RoleID)
VALUES
('Thabo Nkosi', 'thabo.nkosi@raceday.co.za', 'HASHED_PASSWORD_1', 1),
('Lindiwe Dube', 'lindiwe.dube@raceday.co.za', 'HASHED_PASSWORD_2', 1),
('Sarah Botha', 'sarah.botha@example.com', 'HASHED_PASSWORD_3', 2),
('Kagiso Molefe', 'kagiso.molefe@example.com', 'HASHED_PASSWORD_4', 2);

INSERT INTO Events (EventName, EventDate, Location, Description, OrganiserID)
VALUES
('Cape Town Cycle Tour', '2026-03-08', 'Cape Town', 'Iconic 109km cycling road race around the peninsula.', 1),
('Soweto Marathon', '2026-11-01', 'Soweto', 'Community road running event through historic Soweto.', 1),
('Two Oceans Marathon', '2026-04-04', 'Cape Town', 'Ultra marathon along the Cape Peninsula coastline.', 2);

INSERT INTO Categories (EventID, CategoryName, DistanceKm, EntryFee, MaxParticipants)
VALUES
(1, 'Individual Time Trial', 109.00, 550.00, 500),
(1, 'Mini Cycle Tour', 35.00, 250.00, 300),
(2, '10km Fun Run', 10.00, 100.00, 1000),
(2, '21km Half Marathon', 21.10, 200.00, 800),
(3, 'Ultra Marathon', 56.00, 650.00, 400),
(3, 'Half Marathon', 21.10, 300.00, 600);

INSERT INTO EventEnrolments (ParticipantID, CategoryID, Status)
VALUES
(3, 1, 'Confirmed'),
(3, 4, 'Confirmed'),
(4, 3, 'Confirmed'),
(4, 5, 'Pending');

INSERT INTO Results (EnrolmentID, FinishTime, Position)
VALUES
(1, '03:12:45', 214),
(2, '01:45:10', 58),
(3, '00:48:22', 12);