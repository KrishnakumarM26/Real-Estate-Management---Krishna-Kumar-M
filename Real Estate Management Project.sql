CREATE DATABASE RealEstate;
USE RealEstate;

CREATE TABLE Agents (Agent_ID INT PRIMARY KEY AUTO_INCREMENT, Name VARCHAR(20), 
Email VARCHAR(50) UNIQUE, Phone VARCHAR(20), Commission DECIMAL(5,2));

INSERT INTO Agents (Name, Email, Phone, Commission) 
VALUES ('Krishna', 'krishna@gmail.com', '9389900922', 3.5),('Pavi', 'pavi@gmail.com', '7338291831', 3.0);

CREATE TABLE Client (Client_ID INT PRIMARY KEY AUTO_INCREMENT, Name VARCHAR(20), Email VARCHAR(50) UNIQUE, Phone VARCHAR(20));

INSERT INTO Client (Name, Email, Phone) 
VALUES ('Rose', 'Rose@gmail.com', '9988332211'),('Ruby', 'Ruby@gmail.com', '8899007766');

CREATE TABLE Properties (
    Property_ID INT PRIMARY KEY AUTO_INCREMENT,Address VARCHAR(50) NOT NULL, City VARCHAR(20), 
State VARCHAR(20),Price INT, Agent_ID INT, 
    Status ENUM('available','sold') DEFAULT 'available', 
    FOREIGN KEY (Agent_ID) REFERENCES Agents(Agent_ID));

INSERT INTO Properties (Address, City, State, Price, Agent_ID, Status) 
VALUES ('123 Ram Nagar', 'Chennai', 'TN', 600009, 1, 'available'),('456 LIC Nagar', 'Chennai', 'TN', 600001, 2, 'sold');

CREATE TABLE Transactions (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,Property_ID INT, Client_ID INT, 
    Agent_ID INT, Sale_Price INT, Transaction_Date DATE,
    FOREIGN KEY (Property_ID) REFERENCES Properties(Property_ID),
    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
    FOREIGN KEY (Agent_ID) REFERENCES Agents(Agent_ID));

INSERT INTO Transactions (Property_ID, Client_ID, Agent_ID, Sale_Price, Transaction_Date) 
VALUES (2, 1, 2, 90000, '2024-01-01');

SELECT * FROM Properties;
SELECT * FROM Client;
SELECT * FROM Agents;
SELECT * FROM Transactions;

SELECT p.Address, p.City, p.State, p.Price, a.Name AS Agent_Name, a.Email AS Agent_Email, a.Phone AS Agent_Phone 
FROM Properties p JOIN Agents a ON p.Agent_ID = a.Agent_ID;

CREATE VIEW Sold_Properties AS 
SELECT p.Property_ID, p.Address, p.City, p.State, t.Sale_Price, t.Transaction_Date 
FROM Transactions t 
JOIN Properties p ON t.Property_ID = p.Property_ID 
JOIN Agents a ON t.Agent_ID = a.Agent_ID 
JOIN Client c ON t.Client_ID = c.Client_ID
WHERE p.Status = 'sold';
SELECT * FROM Sold_Properties;
DROP VIEW Sold_Properties;
SELECT Name, Email 
FROM Agents 
WHERE Agent_ID IN (SELECT DISTINCT Agent_ID FROM Transactions);

DELIMITER &&
CREATE PROCEDURE GetSoldPropertyCount()
BEGIN
    SELECT COUNT(*) AS Sold_Properties_Count FROM Transactions;
END &&
DELIMITER ;

CALL GetSoldPropertyCount();
DROP PROCEDURE GetSoldPropertyCount;