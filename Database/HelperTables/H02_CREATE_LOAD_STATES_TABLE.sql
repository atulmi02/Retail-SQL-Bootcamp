/*
H02_CREATE_STATES
CREATE HELPER TABLE STATES
*/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS H_States;

CREATE TABLE H_States
(
    StateID INT AUTO_INCREMENT PRIMARY KEY,
    StateName VARCHAR(50) NOT NULL,
    Region VARCHAR(20) NOT NULL
);

/* LOAD STATES TABLE
*/

INSERT INTO H_States(StateName,Region)
VALUES
('Delhi','North'),
('Maharashtra','West'),
('Karnataka','South'),
('Tamil Nadu','South'),
('Telangana','South'),
('Gujarat','West'),
('Rajasthan','North'),
('Uttar Pradesh','North'),
('West Bengal','East'),
('Madhya Pradesh','Central'),
('Punjab','North'),
('Haryana','North'),
('Kerala','South'),
('Odisha','East'),
('Bihar','East'),
('Assam','North East'),
('Jharkhand','East'),
('Chhattisgarh','Central'),
('Goa','West'),
('Uttarakhand','North');