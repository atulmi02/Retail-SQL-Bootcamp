/*
H03_Create_Cities
*/
USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS H_Cities;

CREATE TABLE H_Cities
(
    CityID INT AUTO_INCREMENT PRIMARY KEY,
    CityName VARCHAR(50),
    StateName VARCHAR(50),
    Tier VARCHAR(20)
);

/*
LOAD CITIES
*/
INSERT INTO H_Cities
(CityName,StateName,Tier)

VALUES
('Delhi','Delhi','Metro'),
('Mumbai','Maharashtra','Metro'),
('Pune','Maharashtra','Tier-1'),
('Nagpur','Maharashtra','Tier-2'),
('Bengaluru','Karnataka','Metro'),
('Mysuru','Karnataka','Tier-2'),
('Chennai','Tamil Nadu','Metro'),
('Coimbatore','Tamil Nadu','Tier-2'),
('Hyderabad','Telangana','Metro'),
('Warangal','Telangana','Tier-2'),
('Ahmedabad','Gujarat','Metro'),
('Surat','Gujarat','Tier-1'),
('Jaipur','Rajasthan','Tier-1'),
('Udaipur','Rajasthan','Tier-2'),
('Lucknow','Uttar Pradesh','Tier-1'),
('Kanpur','Uttar Pradesh','Tier-2'),
('Kolkata','West Bengal','Metro'),
('Siliguri','West Bengal','Tier-2'),
('Bhopal','Madhya Pradesh','Tier-2'),
('Indore','Madhya Pradesh','Tier-1'),
('Patna','Bihar','Tier-1'),
('Ranchi','Jharkhand','Tier-2'),
('Bhubaneswar','Odisha','Tier-1'),
('Kochi','Kerala','Tier-1'),
('Chandigarh','Punjab','Tier-1');